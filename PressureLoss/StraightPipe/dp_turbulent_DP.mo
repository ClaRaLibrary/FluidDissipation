within FluidDissipation.PressureLoss.StraightPipe;
function dp_turbulent_DP
  "Pressure loss of straight pipe | calculate pressure loss | turbulent flow regime | surface roughness"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002.

  import FD = FluidDissipation.PressureLoss.StraightPipe;

  //input records
  input FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_con IN_con
    "Input record for function dp_turbulent_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_var IN_var
    "Input record for function dp_turbulent_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_turbulent_DP";

  import TYP1 = FluidDissipation.Utilities.Types.Roughness;

protected
  Real MIN=Modelica.Constants.eps;

  SI.ReynoldsNumber Re_min=1;
  SI.Velocity v_min=Re_min*IN_var.eta/(IN_var.rho*IN_con.d_hyd);

  SI.Diameter d_hyd=IN_con.d_hyd "Hydraulic diameter";
  SI.Area A_cross=PI*IN_con.d_hyd^2/4 "Circular cross sectional area";
  Real k=max(MIN, abs(IN_con.K)/IN_con.d_hyd) "Relative roughness";

  //SOURCE_1: p.81, fig. 2-3, sec 21-22: definition of flow regime boundaries
  SI.ReynoldsNumber Re_lam_min=1e3 "Minimum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_lam_max=2090*(1/max(0.007, k))^0.0635
    "Maximum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_turb_min=4e3
    "Minimum Reynolds number for turbulent regime";

  SI.ReynoldsNumber Re_lam_leave=min(Re_lam_max, max(Re_lam_min, 754*
      Modelica.Math.exp(if k <= 0.007 then 0.0065/0.007 else 0.0065/k)))
    "Start of transition regime for increasing Reynolds number (leaving laminar regime)";

  SI.Velocity velocity=m_flow/(IN_var.rho*A_cross) "Mean velocity";
  SI.ReynoldsNumber Re=max(Re_min, IN_var.rho*abs(velocity)*d_hyd/IN_var.eta);

  //SOURCE_2: p.191, eq. 8.4: determining Darcy friction factor
  //assuming lambda_FRI == lambda_FRI_calc/Re^2
  TYP.DarcyFrictionFactor lambda_FRI_smooth=0.3164*Re^(1.75)
    "Darcy friction factor neglecting surface roughness (Blasius)";
  //here with lambda_FRI_rough == lambda_FRI*Re^2
  TYP.DarcyFrictionFactor lambda_FRI_rough=0.25*(max(Re, Re_lam_leave)/
      Modelica.Math.log10(k/3.7 + 5.74/max(Re, Re_lam_leave)^0.9))^2
    "Darcy friction factor considering surface roughness";
  TYP.DarcyFrictionFactor lambda_FRI=if IN_con.roughness == TYP1.Neglected then
            lambda_FRI_smooth else lambda_FRI_rough "Darcy friction factor";
  TYP.DarcyFrictionFactor lambda_FRI_calc=if Re < Re_lam_leave then 64/Re else
      if Re > Re_turb_min then lambda_FRI/Re^2 else
      FluidDissipation.Utilities.Functions.General.CubicInterpolation_LAMBDA(
      Re,
      Re_lam_leave,
      Re_turb_min,
      k)/Re^2 "Darcy friction factor";

  TYP.PressureLossCoefficient zeta_TOT=lambda_FRI_calc*IN_con.L/d_hyd
    "Pressure loss coefficient";

  //Documentation

algorithm
  DP := zeta_TOT*(IN_var.rho/2)*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    velocity,
    v_min,
    2);
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of pressure loss in a straight pipe for <b> turbulent </b> flow regime of an incompressible and single-phase fluid flow only considering surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW\">dp_turbulent_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b>
 <li>
      <b> turbulent flow regime (Reynolds number Re &ge 4e3) <i>[VDI-W&auml;rmeatlas 2002, p. Lab 3, fig. 1] </i> </b>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss <b> dp </b> for straight pipes is determined by:
<p>
<pre>
dp = lambda_FRI * (L/d_hyd) * (rho/2) * velocity^2
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> lambda_FRI     </b></td><td> as Darcy friction factor [-].</td></tr>
<tr><td><b> L              </b></td><td> as length of straight pipe [m],</td></tr>
<tr><td><b> d_hyd          </b></td><td> as hydraulic diameter of straight pipe [m],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity       </b></td><td> as mean velocity [m/s].</td></tr>
</table>
</p>
 
<p>
The Darcy friction factor <b> lambda_FRI </b> for a straight pipe in the turbulent regime can be calculated for a smooth surface (Blasius law) <b> or </b> a rough surface (Colebrook-White law).
</p>
 
<p>
<b> Smooth surface (roughness =1) </b> w.r.t. <b> Blasius </b> law in the turbulent regime according to <i>[Idelchik 2006, p. 77, sec. 15]</i>:
</p> 
<pre>
    lambda_FRI = 0.3164*Re^(-0.25)
</pre>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> lambda_FRI     </b></td><td> as Darcy friction factor [-].</td></tr>
<tr><td><b> Re             </b></td><td> as Reynolds number [-].</td></tr>
</table>
</p>
 
<p>      
Note that the Darcy friction factor <b> lambda_FRI </b> for smooth straight pipes in the turbulent regime is independent 
of the surface roughness <b> K </b> . 
</p>
 
<p>
<b> Rough surface (roughness =2) </b> w.r.t. <b> Colebrook-White </b> law in the turbulent regime according to <i>[Miller 1984, p. 191, eq. 8.4]</i>:
</p> 
<pre>
    lambda_FRI = 0.25/{lg[k/3.7 + 5.74/Re^0.9]}^2
</pre>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> d_hyd          </b></td><td> as hydraulic diameter [-],</td></tr>
<tr><td><b> k= K/d_hyd     </b></td><td> as relative roughness [-],</td></tr>
<tr><td><b> K              </b></td><td> as roughness (average height of surface asperities [m].</td></tr>
<tr><td><b> lambda_FRI     </b></td><td> as Darcy friction factor [-],</td></tr>
<tr><td><b> Re             </b></td><td> as Reynolds number [-].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
<p> 
The Darcy friction factor <b> lambda_FRI </b> in dependence of Reynolds number for different values of relative roughness <b> k </b> is shown in the figure below.
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/fig_straightPipe_turbulent.png\">
</p>
 
<p>  
Note that this pressure loss function shall not be used for the modelling outside of the turbulent flow regime at <b> Re </b> &lt; 4e3 even though it could be used for that. 
</p>
 
</p>
If the overall flow regime shall be modelled, the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_overall\">dp_overall</a> can be used.
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
 <dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
</html>"));
end dp_turbulent_DP;
