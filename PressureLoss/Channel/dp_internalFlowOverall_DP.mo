within FluidDissipation.PressureLoss.Channel;
function dp_internalFlowOverall_DP "Pressure loss of internal flow | calculate pressure loss | overall flow regime | surface roughness | several geometries"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 1978.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Channel;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_con IN_con "Input record for function dp_internalFlowOverall_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_var IN_var "Input record for function dp_internalFlowOverall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_internalFlowOverall_DP";

  import TYP = FluidDissipation.Utilities.Types.GeometryOfInternalFlow;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, if IN_con.geometry == TYP.Annular then (PI/4)*((
      IN_con.D_ann)^2 - (IN_con.d_ann)^2) else if IN_con.geometry == TYP.Circular then
            PI/4*(IN_con.d_cir)^2 else if IN_con.geometry == TYP.Elliptical then
            PI*IN_con.a_ell*IN_con.b_ell else if IN_con.geometry == TYP.Rectangular then
            IN_con.a_rec*IN_con.b_rec else if IN_con.geometry == TYP.Isosceles then
            0.5*(IN_con.a_tri*IN_con.h_tri) else 0) "Cross sectional area";
  SI.Length perimeter=max(MIN, if IN_con.geometry == TYP.Annular then PI*(
      IN_con.D_ann + IN_con.d_ann) else if IN_con.geometry == TYP.Circular then
            PI*IN_con.d_cir else if IN_con.geometry == TYP.Elliptical then PI*(
      IN_con.a_ell + IN_con.b_ell) else if IN_con.geometry == TYP.Rectangular then
            2*(IN_con.a_rec + IN_con.b_rec) else if IN_con.geometry == TYP.Isosceles then
            IN_con.a_tri + 2*((IN_con.h_tri)^2 + (IN_con.a_tri/2)^2)^0.5 else 0) "Perimeter";
  SI.Diameter d_hyd=4*A_cross/perimeter "Hydraulic diameter";
  Real beta=IN_con.beta*180/PI "Top angle";

  //SOURCE_2: p.138, sec 8.5
  Real Dd_ann=min(max(MIN, IN_con.d_ann), IN_con.D_ann)/max(MIN, max(IN_con.d_ann,
      IN_con.D_ann)) "Ratio of small to large diameter of annular geometry";
  Real CF_ann=98.7378*Dd_ann^0.0589 "Correction factor for annular geometry";
  Real ab_rec=min(IN_con.a_rec, IN_con.b_rec)/max(MIN, max(IN_con.a_rec, IN_con.b_rec)) "Aspect ratio of rectangular geometry";
  Real CF_rec=-59.85*(ab_rec)^3 + 148.67*(ab_rec)^2 - 128.1*(ab_rec) + 96.1 "Correction factor for rectangular geometry";
  Real ab_ell=min(IN_con.a_ell, IN_con.b_ell)/max(MIN, max(IN_con.a_ell, IN_con.b_ell)) "Ratio of small to large length of annular geometry";
  Real CF_ell=-169.2211*(ab_ell)^4 + 260.9028*(ab_ell)^3 - 113.7890*(ab_ell)^2
       + 9.2588*(ab_ell)^1 + 78.7124 "Correction factor for elliptical geometry";
  Real CF_tri=-0.0013*(min(90, beta))^2 + 0.1577*(min(90, beta)) + 48.5575 "Correction factor for triangular geometry";
  Real CF_lam=if IN_con.geometry == TYP.Annular then CF_ann else if IN_con.geometry
       == TYP.Circular then 64 else if IN_con.geometry == TYP.Elliptical then
      CF_ell else if IN_con.geometry == TYP.Rectangular then CF_rec else if
      IN_con.geometry == TYP.Isosceles then CF_tri else 0 "Correction factor for laminar flow";

  //SOURCE_1: p.81, fig. 2-3, sec 21-22: definition of flow regime boundaries
  Real k=max(MIN, abs(IN_con.K)/d_hyd) "Relative roughness";
  SI.ReynoldsNumber Re_lam_min=1e3 "Minimum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_lam_max=2090*(1/max(0.007, k))^0.0635 "Maximum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_lam_leave=min(Re_lam_max, max(Re_lam_min, 754*
      Modelica.Math.exp(if k <= 0.007 then 0.0065/0.007 else 0.0065/k))) "Start of transition regime for increasing Reynolds number (leaving laminar regime)";

  //Adapted mass flow rate for function dp_turbulent of a straight pipe
  SI.MassFlowRate m_flow_turb=m_flow*(PI/4*d_hyd^2)/A_cross "Mass flow rate for turbulent calculation";
  SI.Velocity velocity=m_flow/(IN_var.rho*A_cross) "Velocity of internal flow";
  SI.ReynoldsNumber Re=IN_var.rho*abs(velocity)*d_hyd/IN_var.eta;

protected
  FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_con IN_2_con(
    final roughness=IN_con.roughness,
    final d_hyd=d_hyd,
    final K=IN_con.K,
    final L=IN_con.L) "Input record for turbulent regime"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_var IN_2_var(final eta=
       IN_var.eta, final rho=IN_var.rho) "Input record for turbulent regime"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  //Documentation

algorithm
  DP := SMOOTH(
    Re_lam_min,
    Re_lam_max,
    Re)*(CF_lam/2)*IN_con.L/d_hyd^2*velocity*IN_var.eta + SMOOTH(
    Re_lam_max,
    Re_lam_min,
    Re)*FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_DP(
    IN_2_con,
    IN_2_var,
    m_flow_turb);
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of pressure loss for an internal flow through different geometries at overall flow regime for incompressible and single-phase fluid flow considering surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_MFLOW\">dp_internalFlowOverall_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> developed fluid flow </b>
 </li>
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/channel/pic-pLchannel.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss <b> dp </b> for channels is determined by:
<p>
<pre>
    dp = zeta_TOT * (rho/2) * velocity^2 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity       </b></td><td> as mean velocity [m/s],</td></tr>
<tr><td><b> zeta_TOT       </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
<b> Channels with different shape of its cross sectional area are calculated </b> according to <i>[Miller 1978, p. 138, fig. 8.5-8-6]</i> 
<p>
The pressure loss of these channels is similar to its calculation in straight pipes. There are three different flow regimes observed (laminar,transition,turbulent). The pressure loss coefficient (<b>zeta_TOT</b>) of a channel is calculated in dependence of the flow regime as follows:
</p>
<ul>
  <li> <b>Laminar regime (Re &le; Re_lam_leave)</b>:
     <br><br>
     <pre>
      zeta_TOT = CF_lam/Re * (L/d_hyd)
     </pre>
  <li> <b>Transition regime (Re_lam_leave &le; 4e3)</b>
        This calculation is done using a smoothing function interpolating between the laminar and the turbulent flow regime. 
  <li> <b>Turbulent regime (Re &ge; 4e3)</b>:<br>
        The turbulent regime can be calculated with the pressure loss correlations for a straight pipe with the hydraulic diameter of the chosen geometry instead of the internal diameter of a straight pipe according to <i>[VDI 2002, p. Lab 4, sec. 2.1]</i> . The documentation of turbulent fluid flow for a straight pipe is shown in <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_turbulent\">dp_turbulent</a>.
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> CF_lam        </b></td><td> as correction factor considering the geometry for laminar regime [-],</td></tr>
<tr><td><b> L             </b></td><td> as length of geometry perpendicular to cross sectional area [m],</td></tr>
<tr><td><b> d_hyd         </b></td><td> as hydraulic diameter of geometry [m],</td></tr>
<tr><td><b> Re            </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> zeta_TOT      </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
 
<p>
Note that the beginning of the laminar regime depends on the chosen surface roughness of the channel and cannot be beneath <b>Re &le; 1e3</b>. 
</p> 
 
<h4><font color=\"#EF9B13\">Verification</font></h4>      
<p>
The Darcy friction factor (<b>lambda_FRI</b>) of a channel with different shapes of its cross sectional area are shown in dependence of the Reynolds number (<b>Re</b>) in the figures below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/channel/fig_channel_dp_internalFlowOverall_lambdaVsRe.png\">
</p>
 
The Darcy friction factor (<b>lambda_FRI</b>) for different geometries has been obtained at the same hydraulic diameter and the same mean velocity of the internal flow. Note that there is no difference of the Darcy friction factor in the turbulent regime if using the same hydraulic diameter for all geometries. Roughness can be considered but it is not used for this validation.  
 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    Volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1978.
<dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
</html>
"));
end dp_internalFlowOverall_DP;
