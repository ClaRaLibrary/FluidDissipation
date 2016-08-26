within FluidDissipation.PressureLoss.Junction;
function dp_Tjoin_symmetric "pressure loss of T-junction | design case: joining of entering fluid flows through symmetric side branches into total fluid flow at the bottom"
  extends Modelica.Icons.Function;
  //SOURCE: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006
  //page 471, diagram 7-29
  //Notation of equations according to SOURCE

  import SI = Modelica.SIunits;
  import PI = Modelica.Constants.pi;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.SmoothPower;
  import SMOOTH_2 = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric_IN_con IN_con "input record for function dp_Tjoin_symmetric"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric_IN_var IN_var "input record for function dp_Tjoin_symmetric"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow[3] "mass flow rate in passages [left-bottom,right-bottom,total]"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP[2] "(thermodynamic) pressure loss [left-bottom,right-bottom]"
    annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW[3] "mass flow rate [left-bottom,right-bottom,total]"
    annotation (Dialog(group="Output"));
  output TYP.LocalResistanceCoefficient zeta_LOC[2] "local resistance coefficient [left-bottom,right-bottom]"
    annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re[3] "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Integer failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  constant Real minimum=Modelica.Constants.eps;
  constant Real frac_v_min=1e-2 "minimal fraction of velocities for linear interpolation [v_branch/v_total]";

  /*parameter Integer alpha(
    min=0,
    max=90) = max(min(IN_con.alpha, 90), 0) "angle of branching";*/
   Real alpha = max(min(IN_con.alpha, 90), 0) "angle of branching";

  parameter SI.Diameter d_hyd[3]={IN_con.d_hyd[1],IN_con.d_hyd[2],IN_con.d_hyd[3]} "hydraulic diameter [left,right,bottom]";
  parameter SI.Area A_cross[3]=PI/4*{d_hyd[i]^2 for i in 1:3} "crossectional area of branches [left,right,bottom]";
  parameter SI.Area frac_Across[2]={A_cross[i]/A_cross[3] for i in 1:2} "[left/bottom,right/bottom]";

  //limitations
  parameter SI.MassFlowRate m_flow_min=abs(IN_con.m_flow_min) "minimal mass flow rate for linear interpolation";
  parameter SI.Velocity v_max=abs(IN_con.v_max) "maximal velocity of fluid flow";
  parameter Real zeta_LOC_max=abs(IN_con.zeta_TOT_max) "maximum local resistance coefficient";
  parameter Real zeta_LOC_min=-zeta_LOC_max "minimum local resistance coefficient";

  //parameter of T-join
  Real A[2] "parameter of T-join";

  SI.Velocity velocity[3]={min(abs(m_flow[i])/(IN_var.rho*A_cross[i]),
      v_max) for i in 1:3} "average fluid flow velocity [left,right,bottom]";
  Real frac_v[2]={min(velocity[1]/max(velocity[3], minimum), 100),min(
      velocity[2]/max(velocity[3], minimum), 100)} "[left/bottom,right/bottom]";
  SI.Velocity frac_v_inv[2]={abs(velocity[3])/max(abs(velocity[i]),
      minimum) for i in 1:2} "[bottom/left,bottom/right]";
  SI.VolumeFlowRate V_flow[3]={abs(m_flow[1]),abs(m_flow[2]),abs(m_flow[
      3])}/IN_var.rho "volume flow rate [left,right,bottom]";
  Real frac_Vflow[2]={min(V_flow[i]/max(V_flow[3], minimum), 1) for i in
      1:2} "[left/bottom,right/bottom]";

  //local resistance coefficient
  TYP.LocalResistanceCoefficient zeta_LOC_left "local resistance coefficient [left-bottom]";
  TYP.LocalResistanceCoefficient zeta_LOC_right "local resistance coefficient [right-bottom]";

  //dynamic pressure difference for joining
  Real dp_dyn[2]={(IN_var.rho/2)*((velocity[i])^2 - (velocity[3])^2) for i in
          1:2} "dynamic pressure difference [left-bottom,right-bottom]";

  //(total) pressure loss
  SI.Pressure dp_LOC_left "[left-bottom]";
  SI.Pressure dp_LOC_right "[right-bottom]";

  //(thermodynamic) pressure loss
  SI.Pressure dp[2] "[left-bottom,right-bottom]";

  //failure status
  Real fstatus[4] "check of expected boundary conditions";
  Real joint;

algorithm
  //coefficient for different angles of branching
  //SOURCE: p.418 sec. 7-16 (united_converging_crossection == false)
  A := {if frac_Across[i] <= 0.35 then 1 else if frac_Across[i] > 0.35 then
          max(min(-0.6527*(frac_Vflow[i])^3 + 1.6970*(frac_Vflow[i])^2 -
    1.4058*(frac_Vflow[i]) + 0.9166, 1), 0.5) else 0 for i in 1:2};
  /*for i in 1:2 loop
    A[i] := if IN_con.united_converging_crossection then 1 else if frac_Across[i]
       <= 0.35 and frac_Vflow[i] <= 1 then 1 else if frac_Across[i] > 0.35 and
      frac_Vflow[i] <= 0.4 then 0.9*(1 - frac_Vflow[i]) else if frac_Across[i]
       > 0.35 and frac_Vflow[i] > 0.4 then 0.55 else 0;
  end for;*/

  //local resistance coefficient
  //SOURCE: p.471 diag. 7-29
  zeta_LOC_left := max(min(if IN_con.velocity_reference_branches then A[1]*(1
     + (1/frac_Across[1])^2 + 3*(1/frac_Across[1])^2*(frac_Vflow[1]^2 -
    frac_Vflow[1]))/(max(minimum, frac_v[1])^2) else A[1]*(1 + (1/
    frac_Across[1])^2 + 3*(1/frac_Across[1])^2*(frac_Vflow[1]^2 -
    frac_Vflow[1])), zeta_LOC_max), zeta_LOC_min);
  zeta_LOC_right := max(min(if IN_con.velocity_reference_branches then A[2]*(
    1 + (1/frac_Across[2])^2 + 3*(1/frac_Across[2])^2*(frac_Vflow[2]^2 -
    frac_Vflow[2]))/(max(minimum, frac_v[2])^2) else A[2]*(1 + (1/
    frac_Across[2])^2 + 3*(1/frac_Across[2])^2*(frac_Vflow[2]^2 -
    frac_Vflow[2])), zeta_LOC_max), zeta_LOC_min);
  zeta_LOC := {zeta_LOC_left,zeta_LOC_right};

  //(total) pressure loss for joining
  dp_LOC_left := if IN_con.velocity_reference_branches then sign(m_flow[1])
    *zeta_LOC[1]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[1])^2*SMOOTH(
          abs(m_flow[1]),
          m_flow_min,
          2), v_max^2) else sign(-m_flow[3])*zeta_LOC[1]*IN_var.rho/2*min(1/
    (IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [left-bottom]";
  dp_LOC_right := if IN_con.velocity_reference_branches then sign(m_flow[2])
    *zeta_LOC[2]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[2])^2*SMOOTH(
          abs(m_flow[2]),
          m_flow_min,
          2), v_max^2) else sign(-m_flow[3])*zeta_LOC[2]*IN_var.rho/2*min(1/
    (IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [right-bottom]";

  //(thermodynamic) pressure loss
  //change TV: 08.09.08: smoothing at zero mass flow rates >> numerical improvement
  dp := {(dp_LOC_left - dp_dyn[1])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[1])),(dp_LOC_right - dp_dyn[2])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[2]))} "(thermodynamic) pressure loss [side-total,straight-total]";
  /*dp := {(dp_LOC_left - dp_dyn[1])*abs(m_flow[1])/max(abs(m_flow[3]),
    minimum),(dp_LOC_right - dp_dyn[2])*abs(m_flow[2])/max(abs(m_flow[
    3]), minimum)} "(thermodynamic) pressure loss [left-bottom,right-bottom]";*/

  //output
  //design flow direction for T-join_symmetric:
  //m_flow[1] == pos (left side branch), m_flow[2] == pos (right side branch), m_flow[3] == neg (total passage at bottom)
  DP := dp "(thermodynamic) pressure loss [left-bottom,right-bottom]";

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
Calculation of pressure loss in a symmetric T-junction acting as T-join for merging the incompressible fluid flow entering through side branches into a total fluid flow at the bottom passage.
This T-split can be calculated for a standard geometry with an equal and constant crossectional area at a branching angle of 90&deg;.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This pressure loss function shall be used inside of the restricted limits according to the referenced literature.
<ul>
  <li>
      <b> circular crossectional areas </b>
 </li>
 <li>
      <b> identical hydraulic diameters in all passages </b> <i>[Idelchik 2006, p. 471, diag. 7-29] </i>
 </li>
 <li>
      <b> no partition inside of T-junction for fluid flow separation </b> <i>[Idelchik 2006, p. 471, diag. 7-29] </i>
 </li>
 <li>
      <b> angle of turning alpha = 90&deg; </b> <i>[Idelchik 2006, p. 471, diag. 7-29] </i>
 </li>
</ul>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The local pressure loss in a symmetric T-junction can be determined for each fluid flow through one of the side branches <b>(dp_loc_left)</b> or <b>(dp_loc_right)</b> by the same equation with
<p>
<pre>
     dp_loc_branch = zeta_LOC_branch*(rho/2)*v_tot^2,
</pre>
</p>
 
<p>
where the local pressure loss is calculated w.r.t the fluid flow velocity of the total flow in the bottom passage as reference.
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_loc_branch     </b></td><td> as local pressure loss due to fluid flow through the left or right side branch  [Pa],</td></tr>
<tr><td><b> rho               </b></td><td> as density of fluid flow [kg/m3],</td></tr>
<tr><td><b> v_tot             </b></td><td> as velocity of the total fluid flow in the bottom passage [m/s],</td></tr>
<tr><td><b> zeta_LOC_branch   </b></td><td> as local resistance coefficient of one branch in the T-join [-].</td></tr>
</table>
</p>
 
The local resistance coefficient for the side branches of the T-join with equal and constant crossectional areas (A_cross_branch = A_cross_bottom) is calculated according to <i>[Idelchik 2006, p. 471, sec. 7-29]</i>:
<ul>
   <li> <b> Side branch of T-join </b>:
       <pre>
 
       zeta_LOC_branch = A*(1 + B + C*D)
                     A = Coefficient for T-join <i>[Idelchik 2006, p. 417, tab. 7-1]</i>
                     B = (A_cross_tot/A_cross_branch)^2
                     C = 3*(A_cross_tot/A_cross_branch)^2
                     D = [(V_flow_branch/V_flow_tot)^2 - (V_flow_branch/V_flow_tot)]
       </pre>
   </li>
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> A = f(geometry, velocity)  </b></td><td> as variables for a symmetric T-join depending on geometry as well as on the velocities of the fluid flow [-],</td></tr>
<tr><td><b> A_cross_branch             </b></td><td> as crossectional area a side branch[m^2],</td></tr>
<tr><td><b> A_cross_tot                </b></td><td> as crossectional area the total passage at the bottom[m^2],</td></tr>
<tr><td><b> V_flow_branch              </b></td><td> as volume flow rate in a side branch [m^3/s],</td></tr>
<tr><td><b> V_flow_tot                 </b></td><td> as volume flow rate in the total passage at the bottom [m^3/s].</td></tr>
</table>
</p>
 
The (thermodynamic) pressure loss <b>dp</b> between the entrance of one side branch and the exit of the bottom passage is calculated out of the determined total pressure <b>dp_tot</b> loss (out of the pressure loss coefficient) reduced by the dynamic pressure loss <b>dp_dyn</b>:
 
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
<tr><td><b> v_entrance                  </b></td><td> as velocity at the entrance of a side branch [m/s],</td></tr>
<tr><td><b> v_exit                      </b></td><td> as velocity at the exit of the bottom passage [m/s],</td></tr>
<tr><td><b> zeta_LOC_branch             </b></td><td> as local resistance coefficient of one branch in the T-join [-].</td></tr>
</table>
</p>
 
The pressure loss coefficient <b> zeta_TOT </b> of a symmetric T-junction for joining two entering fluid flows through both side branches is shown in dependence of the volume flow rate fraction of the fluid flow through one side branch to the total fluid flow in the bottom passage below. The crossectional areas of all passages is identical (A_cross_branch = A_cross_bottom).
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tjoin_symmetric_noconv_zetaTOTvsfracVflow.png\", width=708>
</p>
 
<p>
The corresponding (thermodynamic) pressure losses w.r.t the prior pressure loss coefficients at identical crossectional areas (A_cross_branch = A_cross_bottom) is shown below:
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tjoin_symmetric_noconv_DPvsfracVflow.png\", width=708>
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4>
<dl>
<dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
</html>
"));
end dp_Tjoin_symmetric;
