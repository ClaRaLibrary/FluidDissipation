within FluidDissipation.PressureLoss.Junction;
function dp_Tjoin
  "pressure loss of T-junction | design case: joining of entering fluid flow transported through side branch and straight passage into total passage"
  extends Modelica.Icons.Function;
  //SOURCE: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006
  //page 416, section 15
  //Notation of equations according to SOURCE

  import SI = Modelica.SIunits;
  import PI = Modelica.Constants.pi;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.SmoothPower;
  import SMOOTH_2 = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Junction.dp_Tjoin_IN_con IN_con
    "input record for function dp_Tjoin"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Junction.dp_Tjoin_IN_var IN_var
    "input record for function dp_Tjoin"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow[3]
    "mass flow rate in passages [side,straight,total]"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP[2] "(thermodynamic) pressure loss [side,straight]"
    annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW[3] "mass flow rate [side,straight,total]"
    annotation (Dialog(group="Output"));
  output TYP.LocalResistanceCoefficient zeta_LOC[2]
    "local resistance coefficient [side,straight]"
    annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re[3] "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Integer failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  constant Real minimum=Modelica.Constants.eps;
  constant Real frac_v_min=1e-2
    "minimal fraction of velocities for linear interpolation [v_branch/v_total]";

  Real alpha= max(min(IN_con.alpha, 90), 0) "angle of branching";

  parameter SI.Diameter d_hyd[3]={IN_con.d_hyd[1],IN_con.d_hyd[2],IN_con.d_hyd[3]}
    "hydraulic diameter [side,straight,total]";
  parameter SI.Area A_cross[3]=PI/4*{d_hyd[i]^2 for i in 1:3}
    "crossectional area of branches [side,straight,total]";
  parameter SI.Area frac_Across[2]={A_cross[i]/A_cross[3] for i in 1:2}
    "[side/total,straight/total]";

  //limitations
  parameter SI.MassFlowRate m_flow_min=abs(IN_con.m_flow_min)
    "minimal mass flow rate for linear interpolation";
  parameter SI.Velocity v_max=abs(IN_con.v_max)
    "maximal velocity of fluid flow";
  parameter Real zeta_LOC_max=abs(IN_con.zeta_TOT_max)
    "maximum local resistance coefficient";
  parameter Real zeta_LOC_min=-zeta_LOC_max
    "minimum local resistance coefficient";

  SI.Velocity velocity[3]={min(abs(m_flow[i])/(IN_var.rho*A_cross[i]),
      v_max) for i in 1:3}
    "average fluid flow velocity [side, straight, total]";
  Real frac_v[2]={min(velocity[1]/max(velocity[3], minimum), 100),min(
      velocity[2]/max(velocity[3], minimum), 100)}
    "[side/total, straight/total]";
  Real frac_v_inv[2]={abs(velocity[3])/max(abs(velocity[i]), minimum)
      for i in 1:2} "total/side, total/straight";
  SI.VolumeFlowRate V_flow[3]={abs(m_flow[1]),abs(m_flow[2]),abs(m_flow[
      3])}/IN_var.rho "volume flow rate [side, straight, total]";
  Real frac_Vflow[2]={min(V_flow[i]/max(V_flow[3], minimum), 1) for i in
      1:2} "[side/total, straight/total]";

  //local resistance coefficient
  TYP.LocalResistanceCoefficient zeta_LOC_side
    "local resistance coefficient [side-total]";
  TYP.LocalResistanceCoefficient zeta_LOC_straight
    "local resistance coefficient [straight-total]";

  //dynamic pressure difference for joining
  Real dp_dyn[2]={(IN_var.rho/2)*((velocity[i])^2 - (velocity[3])^2) for i in
          1:2} "dynamic pressure difference [side-total,straight-total]";

  //(total) pressure loss
  SI.Pressure dp_loc_side "[side-total]";
  SI.Pressure dp_loc_straight "[straight-total]";

  //(thermodynamic) pressure loss
  SI.Pressure dp[2] "[side-total,straight-total]";

  // SOURCE: p.417 section 7-15
  Real A "parameter of T-join";
  Real K_s "parameter of T-join";
  Real K_st1 "parameter of T-join";
  Real K_st2 "parameter of T-join";

  //failure status
  Real fstatus[4] "check of expected boundary conditions";
  Real joint;

algorithm
  //parameter of joint
  //SOURCE: p.417 table 7-1
  /*A := if IN_con.united_converging_crossection then 1 else if frac_Across[1]
     <= 0.35 then 1 else if frac_Across[1] > 0.35
     and frac_Vflow[1] <= 0.4 then 0.9*(1 - frac_Vflow[1]) else if
    frac_Across[1] > 0.35 and frac_Vflow[1] > 0.4 then 0.55 else 0;*/
  // polynom out of data from SOURCE: p.417 table 7-1 (least square method)
  A := if IN_con.united_converging_crossection then 1 else if frac_Across[1]
     <= 0.35 then 1 else if frac_Across[1] > 0.35 then max(min(-0.6527*(
    frac_Vflow[1])^3 + 1.6970*(frac_Vflow[1])^2 - 1.4058*(frac_Vflow[1])
     + 0.9166, 1), 0.5) else 0;

  //SOURCE: p.417 table 7-2
  K_s := if not (IN_con.united_converging_crossection) then 0 else if
    frac_Across[1] < 0.2 then 0 else if frac_Across[1] < 0.33 and alpha
     == 90 then 0.1 else if frac_Across[1] < 0.5 and alpha == 90 then 0.2 else
          if frac_Across[1] == 0.5 and alpha == 60 then 0.1 else if
    frac_Across[1] == 0.5 and alpha == 90 then 0.25 else 0;

  //SOURCE: p.418 table 7-3
  //ASSUMPTION: Difference of boundary condition according to Idelchik: >35 set to >0.35 (more reliable)
  /*K_st1 := if frac_Across[1] <= 0.35 then 0.8*(
    frac_Vflow[1]) else if frac_Across[1] > 0.35 and frac_Vflow[1] <= 0.6 then
          0.5 else if frac_Across[1] > 0.35 and frac_Vflow[1] > 0.6 then
    0.8*(frac_Vflow[1]) else 0;*/
  // polynom out of data from SOURCE: SOURCE: p.418 table 7-3 (least square method)
  K_st1 := if frac_Across[1] <= 0.35 then 0.8*(frac_Vflow[1]) else if
    frac_Across[1] > 0.35 then max(min(0.6255*(frac_Vflow[1])^3 - 0.3182*
    (frac_Vflow[1])^2 + 0.0032*(frac_Vflow[1]) + 0.5032, 0.45), 1) else 0;

  //SOURCE: p.417 table 7-2
  K_st2 := if frac_Across[1] <= 0.1 and alpha == 45 then 0.05 else if
    frac_Across[1] <= 0.2 and alpha == 45 then 0.14 else if frac_Across[1]
     <= 0.33 and alpha <= 15 then 0.14 else if frac_Across[1] <= 0.33
     and alpha <= 30 then 0.17 else if frac_Across[1] <= 0.33 and alpha
     <= 45 then 0.14 else if frac_Across[1] <= 0.33 and alpha <= 60 then
    0.10 else if frac_Across[1] <= 0.5 and alpha <= 15 then 0.4 else if
    frac_Across[1] <= 0.5 and alpha <= 30 then 0.35 else if frac_Across[1]
     <= 0.5 and alpha <= 45 then 0.3 else if frac_Across[1] <= 0.5 and
    alpha <= 60 then 0.25 else 0;

  //local resistance coefficient for side branch
  //SOURCE: p.417 eq.7-1
  zeta_LOC_side := max(zeta_LOC_min, min(zeta_LOC_max, if IN_con.velocity_reference_branches then
          (A*(1 + (frac_v[1])^2 - 2*((1/frac_Across[2]))*(1 - (frac_Vflow[
    1]))^2 - 2*(1/frac_Across[1])*(frac_Vflow[1])^2*cos(alpha*PI/180)) +
    K_s)/(max(minimum, frac_v[1])^2) else A*(1 + (frac_v[1])^2 - 2*((1/
    frac_Across[2]))*(1 - (frac_Vflow[1]))^2 - 2*(1/frac_Across[1])*(
    frac_Vflow[1])^2*cos(alpha*PI/180)) + K_s));

  //local resistance coefficient for straight branch
  //a) united_converging_crossection == true
  //SOURCE: p.418 eq. 7-2
  //b) united_converging_crossection == false
  //SOURCE: p.417 eq. 7-2
  zeta_LOC_straight := max(zeta_LOC_min, min(zeta_LOC_max, if IN_con.united_converging_crossection
     and IN_con.velocity_reference_branches then (1 + ((1/frac_Across[2]))^2*
    (1 - frac_Vflow[1])^2 - 2*(1/frac_Across[2])*(1 - frac_Vflow[1])^2 -
    2*((1/frac_Across[1]))*(frac_Vflow[1])^2*cos(alpha*PI/180) + K_st2)/(
    max(minimum, frac_v[2])^2) else if IN_con.united_converging_crossection
     and not (IN_con.velocity_reference_branches) then 1 + ((1/frac_Across[2]))
    ^2*(1 - frac_Vflow[1])^2 - 2*(1/frac_Across[2])*(1 - frac_Vflow[1])^2
     - 2*((1/frac_Across[1]))*(frac_Vflow[1])^2*cos(alpha*PI/180) + K_st2 else
          if not (IN_con.united_converging_crossection) and IN_con.velocity_reference_branches then
          (1 - (1 - frac_Vflow[1])^2 - (1.4 - frac_Vflow[1])*(frac_Vflow[
    1])^2*sin(alpha*PI/180) - 2*K_st1*((1/frac_Across[1]))*(frac_Vflow[1])
    *cos(alpha*PI/180))/(max(minimum, frac_v[2])^2) else 1 - (1 -
    frac_Vflow[1])^2 - (1.4 - frac_Vflow[1])*(frac_Vflow[1])^2*sin(alpha*
    PI/180) - 2*K_st1*((1/frac_Across[1]))*(frac_Vflow[1])*cos(alpha*PI/
    180)));
  zeta_LOC := {zeta_LOC_side,zeta_LOC_straight};

  //(total) pressure loss for joining
  dp_loc_side := if IN_con.velocity_reference_branches then sign(m_flow[1])
    *zeta_LOC[1]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[1])^2*SMOOTH(
          abs(m_flow[1]),
          m_flow_min,
          2), v_max^2) else sign(-m_flow[3])*zeta_LOC[1]*IN_var.rho/2*min(1/
    (IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [side-total]";
  dp_loc_straight := if IN_con.velocity_reference_branches then sign(m_flow[
    2])*zeta_LOC[2]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[2])^2*SMOOTH(
          abs(m_flow[2]),
          m_flow_min,
          2), v_max^2) else sign(-m_flow[3])*zeta_LOC[2]*IN_var.rho/2*min(1/
    (IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [straight-total]";

  //(thermodynamic) pressure loss
  //change TV: 08.09.08: smoothing at zero mass flow rates >> numerical improvement
  dp := {(dp_loc_side - dp_dyn[1])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[1])),(dp_loc_straight - dp_dyn[2])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[2]))}
    "(thermodynamic) pressure loss [side-total,straight-total]";
  /*dp := {(dp_loc_side - dp_dyn[1])*abs(m_flow[1])/max(abs(m_flow[3]),
    minimum),(dp_loc_straight - dp_dyn[2])*abs(m_flow[2])/max(abs(m_flow[
    3]), minimum)} "(thermodynamic) pressure loss [side-total,straight-total]";*/

  //output
  //design flow direction for T-joint (at ports):
  //m_flow[1] == pos (side branch), m_flow[2] == pos (straight passage), m_flow[3] == neg (total passage)
  DP := dp "(thermodynamic) pressure loss [side-total,straight-total]";

  //change TV: 07.10.08: assuming design flow if using function (no check here) >> always positive mass flow rates going out of function
  M_FLOW := abs(m_flow) "positive mass flow rate (assuming design flow)";
  //OUT.M_FLOW := m_flow;

  //failure status
  fstatus[1] := if not (IN_con.united_converging_crossection) then if abs(
    A_cross[2] - A_cross[3]) < minimum then 0 else 1 else 0;
  fstatus[2] := if abs(m_flow[1] + m_flow[2] + m_flow[3]) <
    minimum then 0 else 1 "check of mass balance";
  fstatus[3] := if sign(m_flow[1]) + sign(m_flow[2]) + sign(m_flow[
    3]) > 0 then 0 else 1 "check of flow situation";
  fstatus[4] := 0;
  for i in 1:3 loop
    if abs(velocity[i]) >= v_max then
      fstatus[4] := 1;
    end if;
  end for;

  failureStatus := if fstatus[1] == 1 or fstatus[2] == 1 or fstatus[3]
     == 1 or fstatus[4] == 1 then 1 else 0;

  //joint := if sign(m_flow[3]) < 0 then 1 else 0;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2,Documentation(info="<html>
<p>
Calculation of pressure loss in a T-junction acting as Tjoin for merging the incompressible fluid flow of a side branch and a straight passage into a total fluid flow.
This T-split can be calculated for standard geometries with a varying branching angle of the side branch and hydraulic diameters at the edges as parameters.
This function can be used to calculate the pressure loss at a known mass flow rate fraction of the fluid flow in the side branch and the total passage.
 
<p>
Note that the following sign convention of the mass flow rates is used for the pressure loss function in a T-junction. Mass flow rates flowing out of this T-junction via the total passage has a negative sign, whereas the ingoing mass flow rate via the side branch or straight passage have a positive sign for the design flow. The (total) pressure loss between the entrance at the side branch or the straight passage and the total passage can be either positive or negative at design flow for certain fluid flow situations.
</p>
 
<ul>
   <li> Decreasing <b>(total)</b> pressure in actual fluid flow direction occurs only if the following criteria are fulfilled:
      <ul>
         <li> Design flow (positive sign of fluid flow through at least one side branch) </li>
         <li> Positive pressure loss coefficient (p_tot_entrance - p_tot_exit &gt; 0)</li>
         <pre><b> or </b></pre>
         <li> Reverse design flow (negative sign of fluid flow through at least one side branch)</li>
         <li> Negative pressure loss coefficient (p_tot_entrance - p_tot_exit &lt; 0) </li>
      </ul>
   </li>
   <li> Increasing (total) pressure in actual fluid flow direction occurs only if the following criteria are fulfilled:
      <ul>
         <li> Design flow (positive sign of fluid flow through at least one side branch) </li>
         <li> Negative pressure loss coefficient (p_tot_entrance - p_tot_exit &lt; 0)  </li>
          <pre><b> or </b></pre>
         <li> Reverse design flow (negative sign of fluid flow through at least one side branch) </li>
         <li> Positive pressure loss coefficient (p_tot_entrance - p_tot_exit &gt; 0)  </li>
      </ul>
   </li>
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> p_tot_entrance    </b></td><td> total pressure at entrance of the total passage [Pa],</td></tr>
<tr><td><b> p_tot_exit        </b></td><td> total pressure at exit of a side branch or straight passage [Pa].</td></tr>
</table>
</p>
 
<p>
Therefore the (thermodynamic) pressure loss between the entrance of the total passage and the side branch or straight passage at the exit can be either positive or negative. For example an increase of (thermodynamic) pressure in the direction of fluid flow leading to a negative pressure loss difference can be a result of the diffuser effect. Increasing the crossectional area from the total passage to the side branch leads to a decrease in fluid flow velocity (continuity equation) and an increase in (thermodynamic) pressure (equation of Bernoulli). If the increase of (thermodynamic) pressure due to the diffuser effect is higher then the irreversible pressure losses due to the splitting of the fluid flows there will be an increasing (thermodynamic) pressure in fluid flow direction.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This inline function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular crossectional area </b>
 </li>
 <li>
      <b> angle of turning 0&deg; &le; alpha &le; 90&deg; </b> <i>[Idelchik 2006, p. 417, sec. 15] </i>
 </li>
</ul>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The local pressure loss in a T-split can be determined for each fluid flow through the side branch <b>(dp_loc_side)</b> or  the straight passage <b>(dp_loc_straight)</b> by:
<p>
<pre>
     dp_loc_branch = zeta_LOC_branch*(rho/2)*v_tot^2,
</pre>
</p>
 
<p>
where the local pressure loss is calculated w.r.t. the fluid flow velocity of the total fluid flow in the total passage as reference.
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_loc_branch     </b></td><td> as local pressure loss due to fluid flow through the side branch or straight passage [Pa],</td></tr>
<tr><td><b> rho               </b></td><td> as density of fluid flow [kg/m3],</td></tr>
<tr><td><b> v_tot             </b></td><td> as velocity of the total fluid flow in the total passage [m/s],</td></tr>
<tr><td><b> zeta_LOC_branch   </b></td><td> as local resistance coefficient of the side branch or the straight passage in the T-split [-].</td></tr>
</table>
</p>
 
The local resistance coefficient for the side branch and the straight passage of the T-join can be calculated for two general geometries according to <i>[Idelchik 2006, p. 417, eq. 7-15]</i>:
<ul>
 <li> <b> United converging area </b> with A_cross_side + A_cross_straight = A_total:
    <ul>
       <li> <b> Side branch of T-join </b>:
       <pre>
 
       zeta_LOC_side = 1 + [v_side/v_total]^2 - 2*[A_cross_straight/A_cross_total]*[v_straight/v_total]^2 - 2*[A_cross_side/A_cross_total]*[v_straight/v_total]*cos[alpha] + Ks
       </pre>
       </li>
       <li> <b> Straight passage of T-join </b> (polynomial coefficients resulting through least square method with data from <i>[Idelchik 2006, p. 455, table]</i>):
        <pre>
 
       zeta_LOC_straight = 1 + (v_straight/v_total)^2 - 2*(A_cross_straight/A_cross_total)*(v_straight/v_total)^2 - 2*(A_cross_side/A_cross_total)*(v_side/v_total)^2*cos(alpha) + Kst2
       </pre>
       </li>
   </ul>
 <li> <b> Constant converging area </b> with A_cross_side + A_cross_straight > A_total and A_cross_straight = A_cross_total:
    <ul>
       <li> <b> Side branch of T-join </b>:
       <pre>
 
       zeta_LOC_side = A_con*(1 + [v_side/v_total]^2 - 2*[A_cross_straight/A_cross_total]*[v_straight/v_total]^2 - 2*[A_cross_side/A_cross_total]*[v_straight/v_total]*cos[alpha])
       </pre>
       </li>
       <li> <b> Straight passage of T-join </b>:
        <pre>
 
       zeta_LOC_straight = 1 - (1-V_flow_side/V_flow_total)^2  - (1.4 - V_flow_side/V_flow_total)*(V_flow_side/V_flow_total)^2*sin(alpha) - 2*Kst1*(A_cross_total/A_cross_side)*(V_flow_side/V_flow_total)*cos(alpha)
       </pre>
       </li>
   </ul>
 </li>
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> alpha                      </b></td><td> as branching angle between the side branch and the total passage [deg],</td></tr>
<tr><td><b> A_cross_i                  </b></td><td> as crossectional area of the particular passage[m2],</td></tr>
<tr><td><b> A_con,Kst1,Kst2 = f(geometry, velocity) </b></td><td> as variables for a T-join depending on geometry as well as on the velocities of the fluid flow [-],</td></tr>
<tr><td><b> v_side                     </b></td><td> as velocity of the fluid flow in the side passage [m/s],</td></tr>
<tr><td><b> v_straight                 </b></td><td> as velocity of the fluid flow in the straight passage [m/s].</td></tr>
<tr><td><b> v_total                    </b></td><td> as velocity of the total fluid flow [m/s].</td></tr>
<tr><td><b> V_flow_i                   </b></td><td> as volume flow rate in the particular passage [m^3/s].</td></tr>
</table>
</p>
 
The (thermodynamic) pressure loss <b>dp</b> between the entrance the side branch or straight passage and of the total passage at the exit is calculated out of the determined total pressure <b>dp_tot</b> loss (out of the pressure loss coefficient) reduced by the dynamic pressure loss <b>dp_dyn</b>:
 
<p>
<pre>
     dp = dp_tot - dp_dyn,
</pre>
</p>
 
<p>
where
</p>
 
<p>
<pre>
     dp_tot = p_tot_entrance - p_tot-exit = zeta_LOC_branch*(rho/2)*(v_tot)^2 and
     dp_dyn = (rho/2)*(v_entrance - v_exit)^2,
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp                          </b></td><td> as thermodynamic pressure difference between entrance and exit section [Pa],</td></tr>
<tr><td><b> dp_dyn                      </b></td><td> as dynamic pressure difference between entrance and exit section [Pa],</td></tr>
<tr><td><b> dp_tot                      </b></td><td> as total pressure difference between entrance and exit section [Pa],</td></tr>
<tr><td><b> rho                         </b></td><td> as density of fluid flow [kg/m3],</td></tr>
<tr><td><b> v_entrance                  </b></td><td> as velocity at the entrance of a side branch or straight passage [m/s],</td></tr>
<tr><td><b> v_exit                      </b></td><td> as velocity at the exit the bottom passage   [m/s],</td></tr>
<tr><td><b> zeta_LOC_branch             </b></td><td> as local resistance coefficient of the side branch or the straight passage in the T-split [-].</td></tr>
</table>
</p>
 
The calculation of the local resistance coefficients in a T-junction is shown in the following figure, where the total crossectional area is the sum of crossectional areas of the side branch and the straight passage (A_side + A_straight = A_total):
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tjoin_conv_zetaTOTvsfracVflow.png\", width=708>
</p>
 
<p>
The corresponding (thermodynamic) pressure losses w.r.t. the prior pressure loss coefficients at an united converging area (A_cross_side + A_cross_straight = A_total) is shown below:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tjoin_conv_DPvsfracVflow.png\", width=708>
</p>
 
<p>
The calculation of the local resistance coefficients in a T-junction is shown in the following figure, where the total crossectional area is larger as the sum of the crossectional areas of the side branch and the straight passage (A_cross_side= A_cross_straight= A_total):
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tjoin_noconv_zetaTOTvsfracVflow.png\", width=708>
</p>
 
<p>
The corresponding (thermodynamic) pressure losses w.r.t. the prior pressure loss coefficients at an united converging area (A_cross_side= A_cross_straight= A_total) is shown below:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tjoin_noconv_DPvsfracVflow.png\", width=708>
</p>
 
Note that this function delivers a failure status without terminating the simulation. The failure status allows to check if the results are still reasonable even though that some boundary conditions are not fulfilled as expected. The following boundary conditions are checked:
 
<ul>
 <li> check of geometry:
      failure status is true if united_converging_crossection is not used and the crossectional areas of the total passage and the straight passage have not the same hydraulic diameter
 <li> check of mass balance:
      failure status is true the mass balance is temporarily not fulfilled
 <li> check of flow situation:
      failure status is true if the junction is not acting as a split
</ul>
 
<h4><font color=\"#EF9B13\">References</font></h4>
<dl>
 <dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
 <dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984.
 <dt>VDI:</dt>
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>.
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
</html>
"));
end dp_Tjoin;
