within FluidDissipation.PressureLoss.Junction;
function dp_Tsplit_symmetric "pressure loss of T-junction | design case: splitting of entering total fluid flow into side branches"
  extends Modelica.Icons.Function;
  //SOURCE: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006
  //p. 472, diag. 7-29
  //Notation of equations according to SOURCE

  import SI = Modelica.SIunits;
  import PI = Modelica.Constants.pi;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.SmoothPower;
  import SMOOTH_2 = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Junction.dp_Tsplit_symmetric_IN_con IN_con "input record for function dp_Tsplit_symmetric"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Junction.dp_Tsplit_symmetric_IN_var IN_var "input record for function dp_Tsplit_symmetric"
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
  parameter SI.Diameter d_hyd[3]={IN_con.d_hyd[i] for i in 1:3} "hydraulic diameter [left,right,bottom]";
  parameter SI.Area A_cross[3]=PI/4*{d_hyd[i]^2 for i in 1:3} "crossectional area of branches [left,right,bottom]";
  parameter SI.Area frac_Across[2]={A_cross[i]/A_cross[3] for i in 1:2} "left/bottom,right/bottom";
  parameter Real k=1.5 "parameter of manufacture |standard wye == 1.5 (decreasing for better manufacture)"
    annotation (Dialog(group="T-junction"));

  //limitations
  parameter SI.MassFlowRate m_flow_min=abs(IN_con.m_flow_min) "minimal mass flow rate for linear interpolation";
  parameter SI.Velocity v_max=abs(IN_con.v_max) "maximal velocity of fluid flow";
  parameter Real zeta_LOC_max=abs(IN_con.zeta_TOT_max) "maximum local resistance coefficient";
  parameter Real zeta_LOC_min=-zeta_LOC_max "minimum local resistance coefficient";

  SI.Velocity velocity[3]={min(abs(m_flow[i])/(IN_var.rho*A_cross[i]),
      v_max) for i in 1:3} "average fluid flow velocity [left,right,bottom]";
  Real frac_v[2]={min(velocity[1]/max(velocity[3], minimum), 100),min(
      velocity[2]/max(velocity[3], minimum), 100)} "[left/bottom,right/bottom]";
  SI.VolumeFlowRate V_flow[3]={abs(m_flow[1]),abs(m_flow[2]),abs(m_flow[
      3])}/IN_var.rho "volume flow rate [left,right,bottom]";
  Real frac_Vflow[2]={min(V_flow[i]/max(V_flow[3], minimum), 1) for i in
      1:2} "[left/bottom,right/bottom]";

  //local resistance coefficient
  TYP.LocalResistanceCoefficient zeta_LOC_left "local resistance coefficient [bottom-left]";
  TYP.LocalResistanceCoefficient zeta_LOC_right "local resistance coefficient [bottom-right]";

  //dynamic pressure difference for splitting
  Real dp_dyn[2]={(IN_var.rho/2)*((velocity[3])^2 - (velocity[i])^2) for i in
          1:2} "dynamic pressure difference [bottom-left,bottom-right]";

  //(total) pressure loss
  SI.Pressure dp_LOC_left "[bottom-left]";
  SI.Pressure dp_LOC_right "[bottom-right]";

  //(thermodynamic) pressure loss
  SI.Pressure dp[2] "[bottom-left,bottom-right]";

  //failure status
  Real fstatus[4] "check of expected boundary conditions";
  Real joint;

algorithm
  //local resistance coefficient
  //SOURCE: p.472 diagram 7-29
  zeta_LOC_left := max(zeta_LOC_min, min(zeta_LOC_max, if IN_con.velocity_reference_branches then
          (1 + k*(frac_v[1])^2)/(max(minimum, frac_v[1])^2) else (1 +
    k*(frac_v[1])^2)));
  zeta_LOC_right := max(zeta_LOC_min, min(zeta_LOC_max, if IN_con.velocity_reference_branches then
          (1 + k*(frac_v[2])^2)/(max(minimum, frac_v[2])^2) else (1 +
    k*(frac_v[2])^2)));
  zeta_LOC := {zeta_LOC_left,zeta_LOC_right};

  //(total) pressure loss for splitting
  dp_LOC_left := if IN_con.velocity_reference_branches then sign(-m_flow[1])
    *zeta_LOC[1]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[1])^2*SMOOTH(
          abs(m_flow[1]),
          m_flow_min,
          2), v_max^2) else sign(m_flow[3])*zeta_LOC[1]*IN_var.rho/2*min(1/(
    IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [bottom-left]";
  dp_LOC_right := if IN_con.velocity_reference_branches then sign(-m_flow[
    2])*zeta_LOC[2]*IN_var.rho/2*min(1/(IN_var.rho*A_cross[2])^2*SMOOTH(
          abs(m_flow[2]),
          m_flow_min,
          2), v_max^2) else sign(m_flow[3])*zeta_LOC[2]*IN_var.rho/2*min(1/(
    IN_var.rho*A_cross[3])^2*SMOOTH(
          abs(m_flow[3]),
          m_flow_min,
          2), v_max^2) "(total) pressure loss [bottom-right]";

  //(thermodynamic) pressure loss
  //change TV: 08.09.08: smoothing at zero mass flow rates >> numerical improvement
  dp := {(dp_LOC_left - dp_dyn[1])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[1])),(dp_LOC_right - dp_dyn[2])*SMOOTH_2(
          frac_v_min,
          0,
          abs(frac_v[2]))} "(thermodynamic) pressure loss [side-total,straight-total]";
  dp := {(dp_LOC_left - dp_dyn[1])*abs(m_flow[1])/max(abs(m_flow[3]),
    minimum),(dp_LOC_right - dp_dyn[2])*abs(m_flow[2])/max(abs(m_flow[
    3]), minimum)} "(thermodynamic) pressure loss [bottom-left,bottom-right]";

  //output
  //design flow direction for T-split_symmetric:
  //m_flow[1] == neg (left side branch), m_flow[2] == neg (right side branch), m_flow[3] == pos (total passage at bottom)
  DP := dp "(thermodynamic) pressure loss [bottom-left,bottom-right]";

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
Calculation of pressure losses in a T-junction acting as symmetric split for the splitting of an incompressible total fluid flow in the bottom passage into two symmetrical side branches.
This T-split can be calculated with a constant branching angle of 90&deg; and identical hydraulic diameters.
This function can be used to calculate the pressure loss at a known mass flow rate fraction of the fluid flow in one of the side branches and the total fluid flow in the bottom passage.
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
The local resistance coefficient <b>zeta_loc_branch</b> for the right or left side branch of a symmetric T-split can be calculated with the same equation according to <i>[Idelchik 2006, p. 472, eq. 7-29]</i>:
<ul>
       <li> <b> Side branches of symmetric T-split </b>:
       <pre>
 
       zeta_loc_branch = 1 + k*(v_side/v_tot)^2
       </pre>
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> k = f(manufacture)         </b></td><td> as variables for a symmetric T-split depending on manufacture (standard = 1.5, decreasing for better manufacture) [-],</td></tr>
<tr><td><b> v_side                     </b></td><td> as velocity of the fluid flow in one side branch [m/s].</td></tr>
<tr><td><b> v_total                    </b></td><td> as velocity of the total fluid flow in the bottom passage [m/s].</td></tr>
</table>
</p>
 
The (thermodynamic) pressure loss <b>dp</b> between the entrance of the bottom passage and the exit of one side branch is calculated out of the determined total pressure <b>dp_tot</b> loss (out of the pressure loss coefficient) reduced by the dynamic pressure loss <b>dp_dyn</b> between these sections:
 
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
<tr><td><b> v_entrance                  </b></td><td> as velocity at the entrance of the bottom passage [m/s],</td></tr>
<tr><td><b> v_exit                      </b></td><td> as velocity at the exit of a side branch [m/s],</td></tr>
<tr><td><b> zeta_loc_branch             </b></td><td> as local resistance coefficient of one branch in the T-split [-].</td></tr>
</table>
</p>
 
The pressure loss coefficient <b> zeta_TOT </b> of a symmetric T-junction for splitting a total fluid flow in the bottom passage into two symmetrical side branches is shown in dependence of the volume flow rate fraction of the fluid flow through one side branch to the total fluid flow in the bottom passage below. The crossectional areas of all passages is identical (A_cross_branch = A_cross_bottom).
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tsplit_symmetric_noconv_zetaTOTvsfracVflow.png\", width=708>
</p>
 
<p>
The corresponding (thermodynamic) pressure losses w.r.t the prior pressure loss coefficients at identical crossectional areas (A_cross_branch = A_cross_bottom) is shown below:
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/junction/fig_Tsplit_symmetric_noconv_DPvsfracVflow.png\", width=708>
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4>
<dl>
 <dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
</dl>
</html>
"));
end dp_Tsplit_symmetric;
