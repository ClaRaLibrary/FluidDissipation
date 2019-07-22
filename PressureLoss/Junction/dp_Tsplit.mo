within FluidDissipation.PressureLoss.Junction;
function dp_Tsplit
  "pressure loss of T-junction | design case: splitting of entering total fluid flow transported through straight passage"
  extends Modelica.Icons.Function;
  //SOURCE: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006
  //page 418, section 16
  //Notation of equations according to SOURCE

  import SI = Modelica.SIunits;
  import PI = Modelica.Constants.pi;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.SmoothPower;
  import SMOOTH_2 = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Junction.dp_Tsplit_IN_con IN_con
    "input record for function dp_Tsplit"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Junction.dp_Tsplit_IN_var IN_var
    "input record for function dp_Tsplit"
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
    "local resistance coefficient [total-side,total-straight]"
    annotation (Dialog(group="Output"));
  // Re has no meaning for this function
  final output SI.ReynoldsNumber Re[3] = zeros(3) "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  constant Real coef[3]={2.2511,-3.3072,1.2258}
    "polynomial coefficients for split AND united_converging_cross_section == true (least square method with data out of SOURCE at p.455";
  constant Real coef_2[3]={-2.9720,5.2720,-2.0594}
    "polynomial coefficients for tau_st in split (least square method with data out of SOURCE at p.453";
  constant Real minimum=Modelica.Constants.eps;
  constant Real frac_v_min=1e-2
    "minimal fraction of velocities for linear interpolation [v_branch/v_total]";

  /*parameter Integer alpha(
    min=0,
    max=90) = max(min(IN_con.alpha, 90), 0) "angle of branching";*/
   Real alpha = max(min(IN_con.alpha, 90), 0) "angle of branching";
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
  //parameter Real zeta_LOC_min=0.01 "minimum local resistance coefficient";
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
    "local resistance coefficient [total-side]";
  TYP.LocalResistanceCoefficient zeta_LOC_straight
    "local resistance coefficient [total-straight]";

  //dynamic pressure difference for splitting
  Real dp_dyn[2]={(IN_var.rho/2)*((velocity[3])^2 - (velocity[i])^2) for i in
          1:2} "dynamic pressure difference [total-side,total-straight]";

  //(total) pressure loss
  SI.Pressure dp_LOC_side "[total-side]";
  SI.Pressure dp_LOC_straight "[total-straight]";

  //(thermodynamic) pressure loss
  SI.Pressure dp[2] "[total-side,total-straight]";

  //SOURCE: p.418 section 7-16
  Real A_div "parameter of split";
  Real K_s1_div "parameter of split";
  Real tau_st "parameter of split";

  //failure status
  Real fstatus[4] "check of expected boundary conditions";
  Real joint;

algorithm
  //parameter of split
  //SOURCE: p.418 table 7-4
  /*A_div := if IN_con.united_converging_cross_section then 1 else if frac_Across[1]
     <= 0.35 and frac_Vflow[1] <= 0.4 then 1.1 - 0.7*frac_Vflow[1] else if
    frac_Across[1] <= 0.35 and frac_Vflow[1] > 0.4 then 0.85 else if
    frac_Across[1] > 0.35 and frac_Vflow[1] <= 0.6 then 1.0 - 0.6*frac_Vflow[1]
     else if frac_Across[1] > 0.35 and frac_Vflow[1] > 0.6 then 0.6 else 0;*/
  // polynom out of data from SOURCE: p.418 table 7-4 (least square method)
  /*A_div := if IN_con.united_converging_cross_section then 1 else if frac_Across[
    1] <= 0.35 then max(min(1.1 - 0.7*frac_Vflow[1], 1.1), 0.85) else if
    frac_Across[1] > 0.35 then max(min(1.0 - 0.6*frac_Vflow[1], 1), 0.6) else
          0;*/
  A_div := if IN_con.united_converging_cross_section then 1 else if frac_Across[
    1] <= 0.35 then SMOOTH_2(
          0.3,
          0.41,
          frac_Vflow[1])*(1.1 - 0.7*frac_Vflow[1]) + SMOOTH_2(
          0.41,
          0.3,
          frac_Vflow[1])*0.85 else if frac_Across[1] > 0.35 then SMOOTH_2(
          0.62,
          0.67,
          frac_Vflow[1])*(1 - 0.6*frac_Vflow[1]) + SMOOTH_2(
          0.67,
          0.62,
          frac_Vflow[1])*0.6 else 0;

  //SOURCE: p.419 table 7-5
  /*K_s1_div := if IN_con.united_converging_cross_section then if alpha <= 15 then
          0.04 else if alpha <= 30 then 0.16 else if alpha <= 45 then
    0.36 else if alpha <= 60 then 0.64 else if alpha <= 90 then 1.0 else
    0 else 0;*/
  //polynom out of data from SOURCE: p.419 table 7-5 (least square method)
  K_s1_div := if IN_con.united_converging_cross_section then max(min(0.0133*
    alpha - 0.2, 1), 0) else 0;

  //SOURCE: p.453 diagram 7-20

  //polynom out of data from SOURCE: SOURCE: p.453 diagram 7-20 (least square method)
  if not IN_con.united_converging_cross_section and frac_Across[1]==1 then
  tau_st := if frac_Across[1] <= 0.4 then 0.4 else
          if frac_Across[1] > 0.4 and frac_Vflow[1] <= 0.5 then 2*(2*frac_Vflow[1] - 1) else if frac_Across[1] > 0.4 and frac_Vflow[1] >
    0.5 then 0.3*(2*frac_Vflow[1] - 1) else 0;
  else
  tau_st := if frac_Across[1] <= 0.4 then 0.4 else min(coef_2[1]*
    frac_Vflow[1]*frac_Vflow[1] + coef_2[2]*frac_Vflow[1] + coef_2[3],
    0.3);
  end if;

  //local resistance coefficient for side branch
  //SOURCE: p.418 section 7-16
  zeta_LOC_side := max(zeta_LOC_min, min(zeta_LOC_max, if IN_con.velocity_reference_branches then
          A_div*(frac_v_inv[1]^2 + 1 - 2*frac_v_inv[1]*cos(alpha*PI/180))
     - K_s1_div else (A_div*(1 + (frac_v[1])^2 - 2*frac_v[1]*cos(alpha*PI/
    180)) - K_s1_div*(frac_v[1])^2)));

  //local resistance coefficient for straight branch
  //a) united_converging_cross_section == true
  //SOURCE: p.455 diagram 7-20 (table)
  //ASSUMPTION: Calculation independent of united_converging_crosssection (no equation in Idelchik for: SPLIT = true AND united_converging_cross_section == true*/
  //b) united_converging_cross_section == false
  //SOURCE: p.453 diagram 7-20 (table)
  zeta_LOC_straight := max(zeta_LOC_min, min(zeta_LOC_max, if IN_con.united_converging_cross_section
     and IN_con.velocity_reference_branches then min(4, (coef[3]*frac_v_inv[2]
    ^2 + coef[2]*frac_v_inv[2] + coef[1])) else if IN_con.united_converging_cross_section
     and not (IN_con.velocity_reference_branches) then min(4, coef[3] + coef[
    2]*frac_v[2] + coef[1]*frac_v[2]*frac_v[2]) else if not (IN_con.united_converging_cross_section)
     and IN_con.velocity_reference_branches then (tau_st*(frac_Vflow[1])^2)*
    frac_v_inv[2]^2 else tau_st*(frac_Vflow[1])^2));
  zeta_LOC := {zeta_LOC_side,zeta_LOC_straight};

  //(total) pressure loss for splitting
  dp_LOC_side := if IN_con.velocity_reference_branches then sign(-m_flow[1])
    *zeta_LOC[1]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[1])^2*SMOOTH(
          abs(m_flow[1]),
          m_flow_min,
          2), v_max^2) else sign(m_flow[3])*zeta_LOC[1]*IN_var.rho/2*min(1/(
    IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [total-side]";
  dp_LOC_straight := if IN_con.velocity_reference_branches then sign(-m_flow[
    2])*zeta_LOC[2]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[2])^2*SMOOTH(
          abs(m_flow[2]),
          m_flow_min,
          2), v_max^2) else sign(m_flow[3])*zeta_LOC[2]*IN_var.rho/2*min(1/(
    IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [total-straight]";

  //(thermodynamic) pressure loss
  //change TV: 08.09.08: smoothing at zero mass flow rates >> numerical improvement
  dp := {(dp_LOC_side - dp_dyn[1])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[1])),(dp_LOC_straight - dp_dyn[2])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[2]))}
    "(thermodynamic) pressure loss [side-total,straight-total]";

  /*dp := {(dp_LOC_side - dp_dyn[1])*abs(m_flow[1])/max(abs(m_flow[3]),
    minimum),(dp_LOC_straight - dp_dyn[2])*abs(m_flow[2])/max(abs(m_flow[
    3]), minimum)} "(thermodynamic) pressure loss [total-side,total-straight]";*/

  //output
  //design flow direction for T-split:
  //m_flow[1] == neg (side side branch), m_flow[2] == neg (straight side branch), m_flow[3] == pos (total passage)
  DP := dp "(thermodynamic) pressure loss [total-side,total-straight]";
  //change TV: 07.10.08: assuming design flow if using function (no check here) >> always positive mass flow rates going out of function
  M_FLOW := abs(m_flow) "positive mass flow rate (assuming design flow)";
  //OUT.M_FLOW := m_flow;

  //failure status
  fstatus[1] := if not (IN_con.united_converging_cross_section) then if abs(
    A_cross[2] - A_cross[3]) < minimum then 0 else 1 else 0;
  fstatus[2] := if abs(m_flow[1] + m_flow[2] + m_flow[3]) <
    minimum then 0 else 1 "check of mass balance";
  fstatus[3] := if sign(m_flow[1]) + sign(m_flow[2]) + sign(m_flow[
    3]) < 0 then 0 else 1 "check of flow situation";
  fstatus[4] := 0;
  for i in 1:3 loop
    if abs(velocity[i]) >= v_max then
      fstatus[4] := 1;
    end if;
  end for;

  failureStatus := if fstatus[1] == 1 or fstatus[2] == 1 or fstatus[3]
     == 1 or fstatus[4] == 1 then 1 else 0;

  //OUT.joint := if sign(m_flow[3]) < 0 then 1 else 0;
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2,Documentation(info = "<html>
<p>
Calculation of pressure loss in a T-junction acting as split for separating an incompressible fluid flow through a total passage into a side branch and a straight passage.
This T-split can be calculated for standard geometries with varying branching angle of the side branch and different hydraulic diameters of the passages.
This function can be used to calculate the pressure loss at a known mass flow rate fraction of the fluid flow in the side branch and the total passage.
</p>
 
<p>
Note that the following sign convention of the mass flow rates is used for the pressure loss function in a T-junction. Mass flow rates flowing out of this T-junction via the side branch or straight passage have a negative sign, whereas the ingoing mass flow rate via the total passage has a positive sign for the design flow. The (total) pressure loss between the entrance at the total passage and the side branch or the straight passage can be either positive or negative at design flow for certain fluid flow situations.
</p>
 
<ul>
   <li> Decreasing <b>(total)</b> pressure in actual fluid flow direction occurs only if the following criteria are fulfilled:
      <ul>
         <li> Design flow (negative sign of fluid flow through at least one side branch) </li>
         <li> Positive pressure loss coefficient (p_tot_entrance - p_tot_exit &gt; 0)</li>
         <pre><b> or </b></pre>
         <li> Reverse design flow (positive sign of fluid flow through at least one side branch)</li>
         <li> Negative pressure loss coefficient (p_tot_entrance - p_tot_exit &lt; 0) </li>
      </ul>
   </li>
   <li> Increasing (total) pressure in actual fluid flow direction occurs only if the following criteria are fulfilled:
      <ul>
         <li> Design flow (negative sign of fluid flow through at least one side branch) </li>
         <li> Negative pressure loss coefficient (p_tot_entrance - p_tot_exit &lt; 0)  </li>
          <pre><b> or </b></pre>
         <li> Reverse design flow (positive sign of fluid flow through at least one side branch) </li>
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
<tr><td><b> p_tot_exit        </b></td><td> total pressure at exit of a side branch [Pa].</td></tr>
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
      <b> angle of turning 0&deg; &le; alpha &le; 90&deg; </b> <i>[Idelchik 2006, p. 424, sec. 38] </i>
 </li>
</ul>
 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The local pressure loss in a T-split can be determined for each fluid flow through the side branch <b>(dp_loc_side)</b> or  the straight passage <b>(dp_loc_straight)</b> by:
<p>
<pre>
     dp_loc_branch = zeta_loc_branch*(rho/2)*v_tot^2,
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
<tr><td><b> zeta_loc_branch   </b></td><td> as local resistance coefficient of the side branch or the straight passage in the T-split [-].</td></tr>
</table>
</p>
 
The local resistance coefficient for the side branch and the straight passage of the T-split can be calculated for two general geometries according to <i>[Idelchik 2006, p. 419, eq. 7-16]</i>:
<ul>
 <li> <b> United converging area </b> with A_cross_side + A_cross_straight = A_total:
    <ul>
       <li> <b> Side branch of T-split </b>:
       <pre>
 
       zeta_loc_side = 1 + [v_side/v_total]^2 - 2[v_side/v_total]*cos[alpha] + Ks*[v_side/v_total]^2
       </pre>
       </li>
       <li> <b> Straight passage of T-split </b> (polynomial coefficients resulting through least square method with data from <i>[Idelchik 2006, p. 455, table]</i>):
        <pre>
 
       zeta_loc_straight = 2.2511*(v_straight/v_total)^2 - 3.3072*(v_straight/v_total) + 1.2258
       </pre>
       </li>
   </ul>
 <li> <b> Constant converging area </b> with A_cross_side + A_cross_straight > A_total and A_cross_straight = A_cross_total:
    <ul>
       <li> <b> Side branch of T-split </b>:
       <pre>
 
       zeta_loc_side = A_div(1 + [v_side/v_total]^2 - 2[v_side/v_total]*cos[alpha])
       </pre>
       </li>
       <li> <b> Straight passage of T-split </b>:
        <pre>
 
       zeta_loc_straight = tau*(V_flow_side/V_flow_total)^2
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
<tr><td><b> A_div,Ks,tau = f(geometry, velocity) </b></td><td> as variables for a T-split depending on geometry as well as on the velocities of the fluid flow [-],</td></tr>
<tr><td><b> v_side                     </b></td><td> as velocity of the fluid flow in the side passage [m/s],</td></tr>
<tr><td><b> v_straight                 </b></td><td> as velocity of the fluid flow in the straight passage [m/s].</td></tr>
<tr><td><b> v_total                    </b></td><td> as velocity of the total fluid flow [m/s].</td></tr>
</table>
</p>
 
Note that the local resistance coefficients of the straight passages <b> zeta_loc_straight </b> for a T-split are independent of the chosen branching angle.
 
The (thermodynamic) pressure loss <b>dp</b> between the entrance of the bottom passage and the side branch or straight passage at the exit is calculated out of the determined total pressure <b>dp_tot</b> loss (out of the pressure loss coefficient) reduced by the dynamic pressure loss <b>dp_dyn</b>:
 
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
     dp_tot = p_tot_entrance - p_tot-exit = zeta_loc_branch*(rho/2)*(v_tot)^2 and
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
<tr><td><b> v_entrance                  </b></td><td> as velocity at the entrance of of the bottom passage [m/s],</td></tr>
<tr><td><b> v_exit                      </b></td><td> as velocity at the exit of the a side branch or straight passage  [m/s],</td></tr>
<tr><td><b> zeta_loc_branch             </b></td><td> as local resistance coefficient of the side branch or the straight passage in the T-split [-].</td></tr>
</table>
</p>
 
The calculation of the local resistance coefficients in a T-junction is shown in the following figure, where the total crossectional area is the sum of crossectional areas of the side branch and the straight passage (A_side + A_straight = A_total):
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tsplit_conv_zetaTOTvsfracVflow.png\", width=708>
</p>
 
Note that the local pressure loss coefficient <b> zeta_loc_side </b> of an united converging area (A_cross_side + A_cross_straight = A_total) and a branching angle of 90 is always 1 and decreases with decreasing branching angles.
 
<p>
The corresponding (thermodynamic) pressure losses w.r.t. the prior pressure loss coefficients at an united converging area (A_cross_side + A_cross_straight = A_total) is shown below:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tsplit_conv_DPvsfracVflow.png\", width=708>
</p>
 
<p>
The calculation of the local resistance coefficients in a T-junction is shown in the following figure, where the total crossectional area is larger as the sum of the crossectional areas of the side branch and the straight passage (A_cross_side= A_cross_straight= A_total):
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tsplit_noconv_zetaTOTvsfracVflow.png\", width=708>
</p>
 
<p>
Note that the local resistance coefficient <b> zeta_loc_straight </b> of a T-split with constant converging area (A_cross_side= A_cross_straight= A_total) can have negative values shown in in the figure above. Physically this negative local resistance coefficient <b> zeta_loc_straight </b> means an increase of energy between before and after splitting of the fluid flow in the straight passage. The increase in energy in the straight passage is accompanied by an increase of energy losses in the side branch so that the there is a positive total pressure loss in the T-split.
</p>
 
<p>
The corresponding (thermodynamic) pressure losses w.r.t the prior pressure loss coefficients at an identical crossectional area (A_cross_side= A_cross_straight= A_total) is shown below:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tsplit_noconv_DPvsfracVflow.png\", width=708>
</p>
 
 
Note that this function delivers a failure status without terminating the simulation. The failure status allows checking if the results are still reasonable even though that some boundary conditions are not fulfilled as expected. The following boundary conditions are checked:
 
<ul>
 <li> check of geometry:
      failure status is true if united_converging_cross_section is not used and the crossectional areas of the total passage and the straight passage have not the same hydraulic diameter
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
</html>", revisions = "<html>
2017-03-24 Stefan Wischhusen: Provided reasonable outputs for all outputs of the function.
2017-03-24 Stefan Wischhusen: Changed type of failureStatus to Real.
</html>"));
end dp_Tsplit;
