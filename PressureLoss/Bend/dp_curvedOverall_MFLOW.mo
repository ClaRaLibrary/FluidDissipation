within FluidDissipation.PressureLoss.Bend;
function dp_curvedOverall_MFLOW
  "Pressure loss of curved bend | calculate mass flow rate | overall flow regime | surface roughness"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Lac 6 (Verification)
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Bend;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con IN_con
    "Input record for function dp_curvedOverall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var IN_var
    "Input record for function dp_curvedOverall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Output for function dp_curvedOverall_MFLOW";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd=max(MIN, IN_con.d_hyd) "Hydraulic diameter";
  SI.Area A_cross=PI*IN_con.d_hyd^2/4 "Circular cross sectional area";
  Real frac_RD=max(MIN, IN_con.R_0/d_hyd) "Relative curvature radius";
  Real k=max(MIN, abs(IN_con.K)/d_hyd) "Relative roughness";
  Real delta=IN_con.delta*180/PI "Angle of turning";
  SI.Length L=IN_con.delta*IN_con.R_0 "Length of flow path";

  //SOURCE_1: p.336, sec.15: definition of flow regime boundaries
  SI.ReynoldsNumber Re_min=1 "Minimum Reynolds number";
  SI.ReynoldsNumber Re_lam_max=6.5e3
    "Maximum Reynolds number for laminar regime (6.5e3)";
  SI.ReynoldsNumber Re_turb_min=4e4
    "Minimum Reynolds number for turbulent regime (4e4)";
  SI.ReynoldsNumber Re_turb_max=3e5
    "Maximum Reynolds number for turbulent regime (3e5)";
  SI.ReynoldsNumber Re_turb_const=1e6
    "Reynolds number for independence on pressure loss coefficient (1e6)";

  SI.ReynoldsNumber Re_lam_leave=min(Re_lam_max, max(1e2, 754*Modelica.Math.exp(
      if k <= 0.007 then 0.0065/0.007 else 0.0065/k)))
    "Start of transition regime for increasing Reynolds number (leaving laminar regime)";

  //SOURCE_1: p.357, diag. 6-1: coefficients for local resistance coefficient [zeta_LOC]:
  //IN_con.R_0/IN_con.d_hyd <= 3
  Real A1=if delta <= 70 then 0.9*sin(delta/180*PI) else if delta >= 100 then
      0.7 + 0.35*delta/90 else 1.0
    "Coefficient considering effect for angle of turning on zeta_LOC";
  Real A2=if frac_RD > 2.0 then 6e2 else if frac_RD <= 2.0 and frac_RD > 0.55 then (if frac_RD > 1.0 then 1e3 else if frac_RD <= 1.0 and frac_RD > 0.7 then 3e3 else 6e3) else 4e3
    "Coefficient considering laminar regime on zeta_LOC";
  Real B1=if frac_RD >= 1.0 then 0.21*(frac_RD)^(-0.5) else 0.21*(frac_RD)^(-2.5)
    "Coefficient considering relative curvature radius (R_0/d_hyd) on zeta_LOC";
  Real C1=1.0
    "Considering relative elongation of cross sectional area on zeta_LOC (here: circular cross sectional area)";
  TYP.LocalResistanceCoefficient zeta_LOC_sharp_turb=max(MIN, A1*B1*C1)
    "Local resistance coefficient for turbulent regime (Re > Re_turb_max)";

  //SOURCE_1: p.357, diag. 6-1: pressure loss boundaries for w.r.t flow regimes
  //IN_con.R_0/d_hyd <=3
  SI.AbsolutePressure dp_lam_max=(zeta_LOC_sharp_turb + A2/Re_lam_leave)*IN_var.rho
      /2*(Re_lam_leave*IN_var.eta/(IN_var.rho*d_hyd))^2
    "Maximum pressure loss for laminar regime";
  SI.AbsolutePressure dp_turb_min=zeta_LOC_sharp_turb*(if frac_RD > 0.7 then
      11.5/Re_turb_min^0.19 else if frac_RD <= 0.7 and frac_RD >= 0.55 then
      5.45/Re_turb_min^0.131 else 1 + 4400/Re_turb_min)*IN_var.rho/2*(
      Re_turb_min*IN_var.eta/(IN_var.rho*d_hyd))^2
    "Minimum pressure loss for turbulent regime";
  SI.AbsolutePressure dp_turb_max=zeta_LOC_sharp_turb*(if frac_RD > 0.7 then
      11.5/Re_turb_max^0.19 else if frac_RD <= 0.7 and frac_RD >= 0.55 then
      5.45/Re_turb_max^0.131 else 1 + 4400/Re_turb_max)*IN_var.rho/2*(
      Re_turb_max*IN_var.eta/(IN_var.rho*d_hyd))^2
    "Maximum pressure loss for turbulent regime";
  SI.AbsolutePressure dp_turb_const=zeta_LOC_sharp_turb*IN_var.rho/2*(
      Re_turb_const*IN_var.eta/(IN_var.rho*d_hyd))^2
    "Pressure loss for independence of Reynolds number on pressure loss coefficient";

  //SOURCE_1: p.357, diag. 6-1: mean velocities for assumed flow regime
  //IN_con.R_0/d_hyd <=3
  SI.Velocity v_lam=if 1e7*sqrt(abs(zeta_LOC_sharp_turb*abs(dp)*IN_var.rho*
      d_hyd^2)) < abs(A2*IN_var.eta) then 2*abs(dp)*d_hyd/A2/IN_var.eta else (-
      A2/2*IN_var.eta + 0.5*sqrt(max(MIN, (A2*IN_var.eta)^2 + 8*
      zeta_LOC_sharp_turb*abs(dp)*IN_var.rho*d_hyd^2)))/zeta_LOC_sharp_turb/
      IN_var.rho/d_hyd "Mean velocity in laminar regime (Re < Re_lam_leave)";
  SI.Velocity v_tra=if 1e7*sqrt(abs(zeta_LOC_sharp_turb*abs(dp_lam_max)*IN_var.rho
      *d_hyd^2)) < abs(A2*IN_var.eta) then 2*abs(dp_lam_max)*d_hyd/A2/IN_var.eta
       else (-A2/2*IN_var.eta + 0.5*sqrt(max(MIN, (A2*IN_var.eta)^2 + 8*
      zeta_LOC_sharp_turb*abs(dp_lam_max)*IN_var.rho*d_hyd^2)))/
      zeta_LOC_sharp_turb/IN_var.rho/d_hyd
    "Mean velocity in transition regime (Re_lam_leave < Re_turb_min)";
  SI.Velocity v_turb=if frac_RD > 0.7 then (max(MIN, abs(dp))/(IN_var.rho/2*
      11.5*zeta_LOC_sharp_turb)*(IN_var.rho*IN_con.d_hyd/max(MIN, IN_var.eta))^
      0.19)^(1/(2 - 0.19)) else if frac_RD > 0.55 and frac_RD < 0.7 then (max(
      MIN, abs(dp))/(IN_var.rho/2*5.45*zeta_LOC_sharp_turb)*(IN_var.rho*IN_con.d_hyd
      /max(MIN, IN_var.eta))^0.131)^(1/(2 - 0.131)) else -2200/(IN_var.rho*
      IN_con.d_hyd/IN_var.eta) + ((-2200/(IN_var.rho*IN_con.d_hyd/max(MIN,
      IN_var.eta)))^2 + 2*abs(max(MIN, dp))/max(MIN, IN_var.rho))^0.5
    "Mean velocity in turbulent regime with dependence on pressure loss coefficient (Re_turb_min < Re < Re_turb_max)";
  SI.Velocity v_turb_const=sqrt(max(MIN, 2*abs(dp)/(IN_var.rho*
      zeta_LOC_sharp_turb)))
    "Mean velocity in turbulent regime with independence on pressure loss coefficient (Re > Re_turb_max)";

  //mean velocity under smooth conditions w.r.t flow regime
  SI.Velocity v_smooth=if dp < dp_lam_max then v_lam else if dp < dp_turb_min then
            SMOOTH(
      dp_lam_max,
      dp_turb_min,
      dp)*v_lam + SMOOTH(
      dp_turb_min,
      dp_lam_max,
      dp)*v_turb else if dp < dp_turb_max then v_turb else SMOOTH(
      dp_turb_max,
      dp_turb_const,
      dp)*v_turb + SMOOTH(
      dp_turb_const,
      dp_turb_max,
      dp)*v_turb_const
    "Mean velocity under smooth conditions for R_0/d_hyd < 3";

  SI.ReynoldsNumber Re_smooth=max(Re_min, IN_var.rho*v_smooth*d_hyd/IN_var.eta)
    "Reynolds number under smooth conditions";

  //SOURCE_2: p.191, eq. 8.4: considering surface roughness
  //restriction of lambda_FRI at maximum Reynolds number Re=1e6 (SOURCE_2: p.207, sec. 9.2.4)
  TYP.DarcyFrictionFactor lambda_FRI_rough=0.25/(Modelica.Math.log10(k/(3.7*
      IN_con.d_hyd) + 5.74/min(1e6, max(Re_lam_leave, Re_smooth))^0.9))^2
    "Darcy friction factor considering surface roughness";
  TYP.DarcyFrictionFactor lambda_FRI_smooth=0.25/(Modelica.Math.log10(5.74/max(
      Re_lam_leave, Re_smooth)^0.9))^2
    "Darcy friction factor neglecting surface roughness";

  //SOURCE_2: p.207, sec. 9.2.4: correction factors CF w.r.t.surface roughness
  Real CF_3=1+SMOOTH(
      6e3,
      1e3,
      Re_smooth)*min(1.4, (lambda_FRI_rough*L/d_hyd/zeta_LOC_sharp_turb)) + SMOOTH(
      1e3,
      6e3,
      Re_smooth) "Correction factor for surface roughness";

  SI.Velocity velocity=v_smooth/max(1, CF_3)^(0.5)
    "Corrected velocity considering surface roughness";

  //Documentation

algorithm
  M_FLOW := sign(dp)*IN_var.rho*A_cross*abs(velocity);

  annotation (
    Inline = false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.Bend.dp_curvedOverall_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of pressure loss in curved bends at overall flow regime for incompressible and single-phase fluid flow through circular cross sectional area considering surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this function is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall_DP\">dp_curvedOverall_DP</a> is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. 
</p> 
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> circular cross sectional area </b>
 </li>
 <li> 
      <b> 0.5 &le; curvature radius / diameter &le; 3 </b> <i>[Idelchik 2006, p. 357, diag. 6-1] </i>
 </li> 
 <li> 
      <b> length of bend straight starting section / diameter &ge; 10 </b> <i>[Idelchik 2006, p. 357, diag. 6-1] </i>
 </li>
  <li> 
      <b> angle of curvature smaller than 180&deg; (delta &le; 180) </b> <i>[Idelchik 2006, p. 357, diag. 6-1] </i>
 </li>  
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/pic_circularBend.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss <b> dp </b> for curved bends is determined by:
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
 
<b> Curved bends with relative curvature radius R_0/d_hyd &le; 3 </b> according to <i>[Idelchik 2006, p. 357, diag. 6-1]</i> 
<p>
The pressure loss of curved bends is similar to its calculation in straight pipes. There are three different flow regimes observed (laminar,transition,turbulent). The turbulent regime is further separated into sections with a dependence or independence of the local resistance coefficient (<b>zeta_LOC </b>) on Reynolds number. The local resistance coefficient (<b>zeta_LOC</b>) of a curved bend is calculated in dependence of the flow regime as follows:
</p>
<ul>
  <li> <b>Laminar regime (Re &le; Re_lam_leave)</b>:
     <br><br>
     <pre>
      zeta_LOC = A2/Re + A1*B1*C1
     </pre>
  <li> <b>Transition regime (Re_lam_leave &le; 4e4)</b>
        This calculation is done using a smoothing function interpolating between the laminar and the first turbulent flow regime. 
  <li> <b>Turbulent regime (4e4 &le; 3e5) with dependence </b> of local resistance coefficient on Reynolds number:
     <br><br>
     <pre>
      zeta_LOC = k_Re * (A1*B1*C1)
     </pre> 
       where <b>k_Re</b> depends on the relative curvature radius <b> R_0/d_hyd </b>
     <pre> 
      k_Re = 1 + 4400/Re              for 0.50 &lt; r/d_hyd &lt; 0.55
      k_Re = 5.45/Re^(0.118)          for 0.55 &le; r/d_hyd &lt; 0.70
      k_Re = 11.5/Re^(0.19)           for 0.70 &le; r/d_hyd &lt; 3.00
     </pre>
  <li> <b>Turbulent regime (Re &ge; 3e5) with independence </b> of local resistance coefficient on Reynolds number
     <br><br>
     <pre>
      zeta_LOC = A1*B1*C1
     </pre>
</ul>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> A1            </b></td><td> as coefficient considering effect of angle of turning (delta) [-],</td></tr>
<tr><td><b> A2            </b></td><td> as coefficient considering effect for laminar regime [-],</td></tr>
<tr><td><b> B1            </b></td><td> as coefficient considering effect of relative curvature radius (R_0/d_hyd) [-],</td></tr>
<tr><td><b> C1=1          </b></td><td> as coefficient considering relative elongation of cross sectional area (here: circular cross sectional area) [-],</td></tr>
<tr><td><b> k_Re          </b></td><td> as coefficient considering influence of laminar regime in transition regime [-],</td></tr>
<tr><td><b> Re            </b></td><td> as Reynolds number [-].</td></tr>
</table>
</p>
 
<p><br/><br/>The pressure loss coefficient <b>zeta_TOT </b>of a curved bend including pressure loss due to friction is determined by its local resistance coefficient <b>zeta_LOC </b>multiplied with a correction factor <b>CF </b>for surface roughness according to <i>[Miller, p. 209, eq. 9.4]:</i> </p>
<pre>    zeta_TOT = CF*zeta_LOC </pre>
<p>where the correction factor <b>CF </b>is determined from the Darcy friction factor of a straight pipe having the bend flow path length </p>
<pre>    CF = 1 + (lambda_FRI_rough * pi * delta/d_hyd) / zeta_LOC</pre>
<p>and the Darcy friction factors <b>lambda_FRI_rough </b>is calculated with an approximated Colebrook-White law according to <i>[Miller, p. 191, eq. 8.4]:</i> </p>
<pre>    lambda_FRI_rough = 0.25*(lg(K/(3.7*d_hyd) + 5.74/Re^0.9))^-2</pre>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>delta </h4></p></td>
<td><p>as curvature radiant [rad],</p></td>
</tr>
<tr>
<td><p><h4>d_hyd </h4></p></td>
<td><p>as hydraulic diameter [m],</p></td>
</tr>
<tr>
<td><p><h4>K </h4></p></td>
<td><p>as absolute roughness (average height of surface asperities) [m],</p></td>
</tr>
<tr>
<td><p><h4>lambda_FRI_rough </h4></p></td>
<td><p>as Darcy friction factor[-],</p></td>
</tr>
<tr>
<td><p><h4>Re </h4></p></td>
<td><p>as Reynolds number [m],</p></td>
</tr>
<tr>
<td><p><h4>zeta_LOC </h4></p></td>
<td><p>as local resistance coefficient [-],</p></td>
</tr>
<tr>
<td><p><h4>zeta_TOT </h4></p></td>
<td><p>as pressure loss coefficient [-].</p></td>
</tr>
</table>
<p><br/>The correction for surface roughness through <b>CF </b>is used only in the turbulent regime, where the fluid flow is influenced by surface asperities not covered by a laminar boundary layer. The turbulent regime starts at <b>Re &ge; 4e4 </b>according to <i>[Idelchik 2006, p. 336, sec. 15]</i>. There is no correction due to roughness in the laminar regime up to <b>Re &le; 6.5e3 </b>according to <i>[Idelchik 2006, p. 336, sec. 15]</i>. </p>
 
<p>
Nevertheless the transition point from the laminar to the transition regime is shifted to smaller Reynolds numbers for an increasing absolute roughness. This effect is considered according to <i>[Samoilenko in Idelchik 2006, p. 81, sec. 2-1-21]</i> as: 
<pre>
    Re_lam_leave = 754*exp(if k &le; 0.007 then 0.0065/0.007 else 0.0065/k)
</pre>
</p> 
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> k = K /d_hyd       </b></td><td> as relative roughness [-],</td></tr>
<tr><td><b> Re_lam_leave       </b></td><td> as Reynolds number for leaving laminar regime [-].</td></tr>
</table>
</p>
 
<p>
Note that the beginning of the laminar regime cannot be beneath <b> Re &le; 1e2 </b>. 
</p> 
 
<h4><font color=\"#EF9B13\">Verification</font></h4>      
<p>
The pressure loss coefficient <b> zeta_TOT </b> of a curved bend in dependence of the Reynolds number <b> Re </b> for different relative curvature radii <b> R_0/d_hyd </b> and different angles of turning <b> delta </b> is shown in the figures below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_curvedOverall_DPvsMFLOW.png\">
</p>
 
<p> 
There are deviations of the pressure loss coefficient <b> zeta_TOT </b> comparing different references. Usually these deviations in the transition regime have to be accepted due to an uncertainty for the determination of comparable boundary conditions in the different references. Nevertheless these calculations cover the usual range of pressure loss coefficients for a curved bend. The pressure loss coefficient <b> zeta_TOT </b> for the same geometry can be adjusted via varying the average height of surface asperities <b> K </b> for calibration. 
</p>
 
<p>
<b> Compressible case </b> [Mass flow rate = f(dp)]: 
</p> 
<p> 
The mass flow rate in dependence of the pressure loss of water of water is shown for different relative curvature radii:
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_curvedOverall_DPvsMFLOWwrtRD.png\">
</p>
 
<p> 
The mass flow rate in dependence of the pressure loss of water is shown for different angles of turning:
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_curvedOverall_DPvsMFLOWwrtDelta.png\">
</p>
 
<p> 
Note that there is a small deviation between the compressible and incompressible calculation due to the lack of a direct analytical invertibility.
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Elmquist,H., M.Otter and S.E. Cellier:</dt>
    <dd><b>Inline integration: A new mixed
symbolic / numeric approach for solving differential-algebraic equation systems.</b>.
    In Proceedings of European Simulation MultiConference, Praque, 1995.</dd>
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
</html>", revisions="<html>
2014-07-01 Stefan Wischhusen: Introduced an expansion in v_lam and v_tra for numerical improvement at close to zero flows.<br>
2014-12-12 Stefan Wischhusen: Factor A2 corrected for R/D > 0.55-0.7. The factor is now 6e3 instead of 4e3.<br>
</html>"));
end dp_curvedOverall_MFLOW;
