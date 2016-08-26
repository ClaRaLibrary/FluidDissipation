within FluidDissipation.PressureLoss.StraightPipe;
function dp_overall_MFLOW "Pressure loss of straight pipe | calculate mass flow rate | overall flow regime | surface roughness"
  extends Modelica.Icons.Function;
  import FD = FluidDissipation.PressureLoss.StraightPipe;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;
  import FluidDissipation.Utilities.Types.Roughness;

  //input records
  input FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd=max(MIN, IN_con.d_hyd) "Hydraulic diameter";
  SI.Area A_cross=max(MIN, PI*IN_con.d_hyd^2/4) "Circular cross sectional area";
  Real k=max(MIN, abs(IN_con.K)/IN_con.d_hyd) "Relative roughness";

  //SOURCE_1: p.81, fig. 2-3, sec 21-22: definition of flow regime boundaries
  SI.ReynoldsNumber Re_lam_min=1e3 "Minimum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_lam_max=2090*(1/max(0.007, k))^0.0635 "Maximum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_turb_min=4e3 "Minimum Reynolds number for turbulent regime";

  SI.ReynoldsNumber Re_lam_leave=min(Re_lam_max, max(Re_lam_min, 754*
      Modelica.Math.exp(if k <= 0.007 then 0.0065/0.007 else 0.0065/k))) "Start of transition regime for increasing Reynolds number (leaving laminar regime)";

  //determining Darcy friction factor out of pressure loss calculation for straight pipe:
  //dp = lambda_FRI*L/d_hyd*(rho/2)*velocity^2 and assuming lambda_FRI == lambda_FRI_calc/Re^2
  TYP.DarcyFrictionFactor lambda_FRI_calc=2*abs(dp)*d_hyd^3*IN_var.rho/(IN_con.L
      *IN_var.eta^2) "Adapted Darcy friction factor";

  //SOURCE_3: p.Lab 1, eq. 5: determine Re assuming laminar regime (Blasius)
  SI.ReynoldsNumber Re_lam=lambda_FRI_calc/64 "Reynolds number assuming laminar regime";

  //SOURCE_3: p.Lab 2, eq. 10: determine Re assuming turbulent regime (Colebrook-White)
  SI.ReynoldsNumber Re_turb=if IN_con.roughness == Roughness.Neglected then (max(MIN,
      lambda_FRI_calc)/0.3164)^(1/1.75) else -2*sqrt(max(lambda_FRI_calc, MIN))
      *Modelica.Math.log10(2.51/sqrt(max(lambda_FRI_calc, MIN)) + k/3.7) "Reynolds number assuming turbulent regime";

  //determine actual flow regime
  SI.ReynoldsNumber Re_check=if Re_lam < Re_lam_leave then Re_lam else Re_turb;
  //determine Re for transition regime
  SI.ReynoldsNumber Re_trans=if Re_lam >= Re_lam_leave then
      FluidDissipation.Utilities.Functions.General.CubicInterpolation_DP(
      Re_check,
      Re_lam_leave,
      Re_turb_min,
      k,
      lambda_FRI_calc) else 0;
  //determine actual Re
  SI.ReynoldsNumber Re=if Re_lam < Re_lam_leave then Re_lam else if Re_turb >
      Re_turb_min then Re_turb else Re_trans;

  dp_laminar_IN_con IN_con_lam(d_hyd=IN_con.d_hyd, L= IN_con.L);

algorithm
  M_FLOW := SMOOTH(
    Re_lam_min,
    Re_turb,
    Re)*FluidDissipation.PressureLoss.StraightPipe.dp_laminar_MFLOW(
    IN_con_lam,
    IN_var,
    dp) + SMOOTH(
    Re_turb,
    Re_lam_min,
    Re)*FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW(
    IN_con,
    IN_var,
    dp);
  annotation (
    Inline = false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.StraightPipe.dp_overall_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of pressure loss in a straight pipe for <b> overall </b> flow regime of an incompressible and single-phase fluid flow only considering surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> compressible case </b>, where the pressure loss (dp) is known (out of pressures as state variable) in the used model and the corresponding mass flow rate (M_FLOW) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_overall_DP\">dp_overall_DP</a> is numerically best used for the <b> incompressible case </b> if the mass flow rate (m_flow) is known (as state variable) and the pressure loss (DP) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b>
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
<tr><td><b> lambda_FRI     </b></td><td> as Darcy friction factor [-],</td></tr>
<tr><td><b> L              </b></td><td> as length of straight pipe [m],</td></tr>
<tr><td><b> d_hyd          </b></td><td> as hydraulic diameter of straight pipe [m],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity       </b></td><td> as mean velocity [m/s].</td></tr>
</table>
</p>
 
<p> 
The Darcy friction factor <b> lambda_FRI </b> for straight pipes is calculated depending on the fluid flow regime (with corresponding Reynolds number <b>Re</b>) and the absolute surface roughness <b> K </b>.
</p> 
 
<b> Laminar regime </b> is calculated for <b> Re </b> &le; 2000</li> by the Hagen-Poiseuille law according to <i>[Idelchik 2006, p. 77, eq. 2-3]</i>
<pre>
    lambda_FRI = 64/Re
</pre>
 
<p>
The Darcy friction factor <b> lambda_FRI </b> in the laminar regime is independent of the surface roughness <b> k </b> as long as the relative roughness <b> k </b> is smaller than 0.007. A greater relative roughness <b> k </b> than 0.007 is leading to an earlier leaving of the Hagen-Poiseuille law at some value of Reynolds number <b> Re_lam_leave </b>. The leaving of the laminar regime in dependence of the relative roughness <b> k </b> is calculated according to <i>[Samoilenko in Idelchik 2006, p. 81, sect. 2-1-21]</i> as: 
</p>     
<pre>
    Re_lam_leave = 754*exp(if k &le; 0.007 then 0.93 else 0.0065/k)
</pre>
 
<p> 
<b> Transition regime </b> is calculated for <b> 2000 &lt; <b> Re </b> &le; 4000 </b> by a cubic interpolation between the equations of the laminar and turbulent flow regime. Different cubic
interpolation equations for the calculation of either pressure loss <b> dp </b> or mass flow rate <b> m_flow </b> results in a deviation of the Darcy friction factor <b> lambda_FRI </b> through the
transition regime. This deviation can be neglected due to the uncertainty in determination of the fluid flow in the transition regime.
</p>
 
<p>
<b> Turbulent regime </b> can be calculated for a smooth surface (Blasius law) <b> or </b> a rough surface (Colebrook-White law):
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
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/fig_straightPipe_dp_overall_lambdavsRe_ver.png\">
</p>
 
<p>
The mass flow rate <b> m_flow </b> for the turbulent regime in dependence of the pressure loss of water is shown in the figure below.
</p>
<p> 
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/fig_straightPipe_dp_overall_MFLOWvsDP.png\">
</p> 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
 <dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984.
 <dt>Samoilenko,L.A.:</dt>
    <dd><b>Investigation of the hydraulic resistance of pipelines in the
        zone of transition from laminar into turbulent motion</b>.
        PhD thesis, Leningrad State University, 1968.</dd>
 <dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
</html>
"));
end dp_overall_MFLOW;
