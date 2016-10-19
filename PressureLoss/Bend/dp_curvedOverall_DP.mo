within FluidDissipation.PressureLoss.Bend;
function dp_curvedOverall_DP
  "Pressure loss of curved bend | calculate pressure loss | overall flow regime | surface roughness"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Lac 6 (Verification)
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Bend;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_con IN_con
    "Input record for function dp_curvedOverall_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Bend.dp_curvedOverall_IN_var IN_var
    "Input record for function dp_curvedOverall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_curvedOverall_DP";

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
  Real A1=if delta <= 70 then 0.9*sin(delta*PI/180) else if delta >= 100 then
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

  SI.ReynoldsNumber Re=max(Re_min, 4*abs(m_flow)/(PI*IN_con.d_hyd*IN_var.eta))
    "Reynolds number";

  //mass flow rate boundaries for w.r.t flow regimes
  SI.MassFlowRate m_flow_smooth=Re_min*PI*IN_con.d_hyd*IN_var.eta/4;

  //SOURCE_1: p.357, diag. 6-1, sec. 2 / p.336, sec. 15 (turbulent regime + hydraulically rough):
  //IN_con.R_0/IN_con.d_hyd < 3
  Real C_Re=if frac_RD > 0.7 then 11.5/Re^0.19 else if frac_RD <= 0.7 and
      frac_RD >= 0.55 then 5.45/Re^0.131 else 1 + 4400/Re
    "Correction factor for hydraulically rough turbulent regime (Re_turb_min < Re < Re_turb_max)";

  //SOURCE_1: p.357, diag. 6-1
  //IN_con.R_0/IN_con.d_hyd < 3
  TYP.LocalResistanceCoefficient zeta_LOC_sharp=if Re < Re_lam_leave then A2/Re
       + zeta_LOC_sharp_turb else if Re < Re_turb_min then SMOOTH(
      Re_lam_leave,
      Re_turb_min,
      Re)*(A2/max(Re_lam_leave, Re) + zeta_LOC_sharp_turb) + SMOOTH(
      Re_turb_min,
      Re_lam_leave,
      Re)*(C_Re*zeta_LOC_sharp_turb) else if Re < Re_turb_max then SMOOTH(
      Re_turb_min,
      Re_turb_max,
      Re)*(C_Re*zeta_LOC_sharp_turb) + SMOOTH(
      Re_turb_max,
      Re_turb_min,
      Re)*zeta_LOC_sharp_turb else zeta_LOC_sharp_turb
    "Local resistance coefficient for R_0/d_hyd < 3";

  TYP.LocalResistanceCoefficient zeta_LOC=zeta_LOC_sharp
    "Local resistance coefficient";

  //SOURCE_2: p.191, eq. 8.4: considering surface roughness
  //restriction of lambda_FRI at maximum Reynolds number Re=1e6 (SOURCE_2: p.207, sec. 9.2.4)
  TYP.DarcyFrictionFactor lambda_FRI_rough=0.25/(Modelica.Math.log10(k/(3.7*
      IN_con.d_hyd) + 5.74/min(1e6, max(Re_lam_leave, Re))^0.9))^2
    "Darcy friction factor considering surface roughness";

  //SOURCE_2: p.207, sec. 9.2.4: correction factors CF w.r.t.surface roughness
  Real CF_fri=1+SMOOTH(
      Re_lam_max,
      Re_lam_leave,
      Re)*min(1.4, (lambda_FRI_rough*L/d_hyd/zeta_LOC)) + SMOOTH(
      Re_lam_leave,
      Re_lam_max,
      Re) "Correction factor for surface roughness";

  TYP.PressureLossCoefficient zeta_TOT=max(1, CF_fri)*zeta_LOC
    "Pressure loss coefficient";

  //Documentation

algorithm
  DP := zeta_TOT*(IN_var.rho/2)*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    m_flow_smooth,
    2)/max(MIN, (IN_var.rho*A_cross)^2);
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>Calculation of pressure loss in curved bends at overall flow regime for incompressible and single-phase fluid flow through circular cross sectional area considering surface roughness. </p>
<p>This function can be used to calculate both the pressure loss at known mass flow rate <b>or </b>mass flow rate at known pressure loss within one function in dependence of the known variable (dp or m_flow). </p>
<p>Generally this function is numerically best used for the <b>incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW\">dp_curvedOverall_MFLOW</a> is numerically best used for the <b>compressible case </b>if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. </p>
<p><h4><font color=\"#ef9b13\">Restriction</font></h4></p>
<p>This function shall be used inside of the restricted limits according to the referenced literature. </p>
<p><ul>
<li><h4>circular cross sectional area </h4></li>
<li><b>0.5 &le; curvature radius / diameter &le; 3 </b><i>[Idelchik 2006, p. 357, diag. 6-1] </i></li>
<li><b>length of bend straight starting section / diameter &ge; 10 </b><i>[Idelchik 2006, p. 357, diag. 6-1] </i></li>
<li><b>angle of curvature smaller than 180&deg; (delta &le; 180) </b><i>[Idelchik 2006, p. 357, diag. 6-1] </i></li>
</ul></p>
<p><b><font style=\"color: #ef9b13; \">Geometry</font></b> </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/pic_circularBend.png\"/> </p>
<p><h4><font color=\"#ef9b13\">Calculation</font></h4></p>
<p>The pressure loss <b>dp </b>for curved bends is determined by: </p>
<pre>dp = zeta_TOT * (rho/2) * velocity^2 </pre>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>rho </h4></p></td>
<td><p>as density of fluid [kg/m3],</p></td>
</tr>
<tr>
<td><p><h4>velocity </h4></p></td>
<td><p>as mean velocity [m/s],</p></td>
</tr>
<tr>
<td><p><h4>zeta_TOT </h4></p></td>
<td><p>as pressure loss coefficient [-].</p></td>
</tr>
</table>
<p><br/><b>Curved bends with relative curvature radius R_0/d_hyd &le; 3 </b>according to <i>[Idelchik 2006, p. 357, diag. 6-1]</i> </p>
<p>The pressure loss of curved bends is similar to its calculation in straight pipes. There are three different flow regimes observed (laminar,transition,turbulent). The turbulent regime is further separated into sections with a dependence or independence of the local resistance coefficient (<b>zeta_LOC </b>) on Reynolds number. The local resistance coefficient (<b>zeta_LOC</b>) of a curved bend is calculated in dependence of the flow regime as follows: </p>
<p><ul>
<li><b>Laminar regime (Re &le; Re_lam_leave)</b>: <br/><br/></li>
<pre>      zeta_LOC = A2/Re + A1*B1*C1</pre>
<li><b>Transition regime (Re_lam_leave &le; 4e4)</b> This calculation is done using a smoothing function interpolating between the laminar and the first turbulent flow regime. </li>
<li><b>Turbulent regime (4e4 &le; 3e5) with dependence </b>of local resistance coefficient on Reynolds number: <br/><br/></li>
<pre>      zeta_LOC = k_Re * (A1*B1*C1)</pre>
<p>where <b>k_Re</b> depends on the relative curvature radius <b>R_0/d_hyd </b></p>
<pre> 
      k_Re = 1 + 4400/Re              for 0.50 &LT; r/d_hyd &LT; 0.55
      k_Re = 5.45/Re^(0.118)          for 0.55 &le; r/d_hyd &LT; 0.70
      k_Re = 11.5/Re^(0.19)           for 0.70 &le; r/d_hyd &LT; 3.00</pre>
<li><b>Turbulent regime (Re &ge; 3e5) with independence </b>of local resistance coefficient on Reynolds number <br/><br/></li>
</ul></p>
<pre>      zeta_LOC = A1*B1*C1</pre>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>A1 </h4></p></td>
<td><p>as coefficient considering effect of angle of turning (delta) [-],</p></td>
</tr>
<tr>
<td><p><h4>A2 </h4></p></td>
<td><p>as coefficient considering effect for laminar regime [-],</p></td>
</tr>
<tr>
<td><p><h4>B1 </h4></p></td>
<td><p>as coefficient considering effect of relative curvature radius (R_0/d_hyd) [-],</p></td>
</tr>
<tr>
<td><p><h4>C1=1 </h4></p></td>
<td><p>as coefficient considering relative elongation of cross sectional area (here: circular cross sectional area) [-],</p></td>
</tr>
<tr>
<td><p><h4>k_Re </h4></p></td>
<td><p>as coefficient considering influence of laminar regime in transition regime [-],</p></td>
</tr>
<tr>
<td><p><h4>Re </h4></p></td>
<td><p>as Reynolds number [-].</p></td>
</tr>
</table>
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
<p>Nevertheless the transition point from the laminar to the transition regime is shifted to smaller Reynolds numbers for an increasing absolute roughness. This effect is considered according to <i>[Samoilenko in Idelchik 2006, p. 81, sec. 2-1-21]</i> as: </p>
<pre>    Re_lam_leave = 754*exp(if k &le; 0.007 then 0.0065/0.007 else 0.0065/k)</pre>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>k = K /d_hyd </h4></p></td>
<td><p>as relative roughness [-],</p></td>
</tr>
<tr>
<td><p><h4>Re_lam_leave </h4></p></td>
<td><p>as Reynolds number for leaving laminar regime [-].</p></td>
</tr>
</table>
<p><br/><br/>Note that the beginning of the laminar regime cannot be beneath <b>Re &le; 1e2 </b>. </p>
<p><b><font style=\"color: #ef9b13; \">Verification</font></b> </p>
<p>The pressure loss coefficient <b>zeta_TOT </b>of a curved bend in dependence of the Reynolds number <b>Re </b>for different relative curvature radii <b>R_0/d_hyd </b>and different angles of turning <b>delta </b>is shown in the figures below. </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_curvedOverall_DPvsMFLOW.png\"/> </p>
<p>There are deviations of the pressure loss coefficient <b>zeta_TOT </b>comparing different references. Usually these deviations in the transition regime have to be accepted due to an uncertainty for the determination of comparable boundary conditions in the different references. Nevertheless these calculations cover the usual range of pressure loss coefficients for a curved bend. The pressure loss coefficient <b>zeta_TOT </b>for the same geometry can be adjusted via varying the average height of surface asperities <b>K </b>for calibration. </p>
<p><b>Incompressible case </b>[Pressure loss = f(m_flow)]: </p>
<p>The pressure loss in dependence of the mass flow rate of water is shown for different relative curvature radii: </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_curvedOverall_DPvsMFLOWwrtRD.png\"/> </p>
<p>The pressure loss in dependence of the mass flow rate of water is shown for different angles of turning: </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/bend/fig_bend_dp_curvedOverall_DPvsMFLOWwrtDelta.png\"/> </p>
<p>Note that there is a small deviation between the compressible and incompressible calculation due to the lack of a direct analytical invertibility. </p>
<p><b><font style=\"color: #ef9b13; \">References</font></b> </p>
<dl><dt>Elmqvist,H., M.Otter and S.E. Cellier: </dt>
<dd><b>Inline integration: A new mixed symbolic / numeric approach for solving differential-algebraic equation systems.</b>. In Proceedings of European Simulation MultiConference, Praque, 1995.</dd>
<dt>Idelchik,I.E.: </dt>
<dd><b>Handbook of hydraulic resistance</b>. Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
<dt>Miller,D.S.: </dt>
<dd><b>Internal flow systems</b>. volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984. </dd>
<dt>Samoilenko,L.A.: </dt>
<dd><b>Investigation of the hydraulic resistance of pipelines in the zone of transition from laminar into turbulent motion</b>. PhD thesis, Leningrad State University, 1968.</dd>
<dt>VDI: </dt>
<dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. Springer Verlag, 9th edition, 2002. </dd>
</dl></html>", revisions="<html>
2014-12-12 Stefan Wischhusen: Factor A2 corrected for R/D > 0.55-0.7. The factor is now 6e3 instead of 4e3.<br>
</html>"));
end dp_curvedOverall_DP;
