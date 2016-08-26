within FluidDissipation.PressureLoss.Orifice;
function dp_thickEdgedOverall_MFLOW "Pressure loss of thick and sharp edged orifice | calculate mass flow rate | overall flow regime | constant influence of friction  | arbitrary cross sectional area"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Orifice;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_con IN_con "Input record for function dp_thickEdgedOverall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_var IN_var "Input record for function dp_thickEdgedOverall_MFLOW"
    annotation (Dialog(group="Variable inputs"));

  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Output for function dp_thickEdgedOverall_MFLOW";

protected
  Real MIN=Modelica.Constants.eps;
  TYP.DarcyFrictionFactor lambda_FRI=0.02 "Assumption for Darcy friction factor in vena contraction according to SOURCE_1";
  SI.ReynoldsNumber Re_lim=1e3 "Limitation for laminar regime if dp is target";

  SI.Area A_0=IN_con.A_0 "Cross sectional area of vena contraction";
  SI.Area A_1=IN_con.A_1 "Large cross sectional area";
  SI.Diameter d_hyd_0=max(MIN, 4*A_0/IN_con.C_0) "Hydraulic diameter of vena contraction";
  SI.Diameter d_hyd_1=max(MIN, 4*A_1/IN_con.C_1) "Hydraulic diameter of large cross sectional area";
  SI.Length l=IN_con.L "Length of vena contraction";
  Real l_bar=IN_con.L/d_hyd_0;

  //SOURCE_1, section 4, diagram 4-15, page 222:
  Real phi=0.25 + 0.535*min(l_bar, 2.4)^8/(0.05 + min(l_bar, 2.4)^8);
  Real tau=(max(2.4 - l_bar, 0))*10^(-phi);

  TYP.PressureLossCoefficient zeta_TOT_1=max(MIN, (0.5*(1 - A_0/A_1)^0.75 + tau
      *(1 - A_0/A_1)^1.375 + (1 - A_0/A_1)^2 + lambda_FRI*l/d_hyd_0)*(A_1/A_0)^
      2) "Pressure loss coefficient w.r.t. to flow velocity in large cross sectional area";

  //Documentation

algorithm
  M_FLOW := IN_var.rho*A_1*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    dp,
    IN_con.dp_smooth,
    0.5)/(0.5*IN_var.rho*zeta_TOT_1)^0.5;
  annotation (
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of pressure loss in thick edged orifices with sharp corners at overall flow regime for incompressible and single-phase fluid flow through an arbitrary shaped cross sectional area (square, circular, etc.) considering constant influence of surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> compressible case </b>, where the pressure loss (dp) is known (out of pressures as state variable) in the used model and the corresponding mass flow rate (M_FLOW) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP\">dp_thickEdgedOverall_DP</a> is numerically best used for the <b> incompressible case </b> if the mass flow rate (m_flow) is known (as state variable) and the pressure loss (DP) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> Reynolds number (for vena contracta) Re &gt; 1e3 </b> <i>[Idelchik 2006, p. 222, diag. 4-15] </i>
 <li> 
      <b> Relative length of vena contracta (L/d_hyd_0) &gt; 0.015 </b> <i>[Idelchik 2006, p. 222, diag. 4-15] </i>
 <li> 
      <b> Darcy friction factor lambda_FRI = 0.02 </b> <i>[Idelchik 2006, p. 222, sec. 4-15] </i>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/pic_thickEdged.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss <b> dp </b> for a thick edged orifice is determined by:
<p>
<pre>
dp = zeta_TOT * (rho/2) * (velocity_1)^2
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity_1     </b></td><td> as mean velocity in large cross sectional area [m/s],</td></tr>
<tr><td><b> zeta_TOT       </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
The pressure loss coefficient <b> zeta_TOT </b> of a thick edged orifice can be calculated for different cross sectional areas <b> A_0 </b> and relative length of orifice <b> l_bar </b>=L/d_hyd_0 by:
<p>
<pre>
zeta_TOT = (0.5*(1 - A_0/A_1)^0.75 + tau*(1 - A_0/A_1)^1.375 + (1 - A_0/A_1)^2 + lambda_FRI*l_bar)*(A_1/A_0)^2 <i>[Idelchik 2006, p. 222, diag. 4-15] </i> 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> A_0       </b></td><td> cross sectional area of vena contracta [m2],</td></tr>
<tr><td><b> A_1       </b></td><td> large cross sectional area of orifice [m2],</td></tr>
<tr><td><b> d_hyd_0   </b></td><td> hydraulic diameter of vena contracta [m],</td></tr>
<tr><td><b> lambda_FRI</b></td><td> as constant Darcy friction factor [-],</td></tr>
<tr><td><b> l_bar     </b></td><td> relative length of orifice [-],</td></tr>
<tr><td><b> L         </b></td><td> length of vena contracta [m],</td></tr>
<tr><td><b> tau       </b></td><td> geometry parameter [-].</td></tr>
</table>
</p>
 
<p>
The geometry factor <b> tau </b> is determined by <i>[Idelchik 2006, p. 219, diag. 4-12]</i>:
</p>
 
<p>
<pre>
tau = (2.4 - l_bar)*10^(-phi)
phi = 0.25 + 0.535*l_bar^8 / (0.05 + l_bar^8) .
</pre>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>   
The pressure loss coefficient <b> zeta_TOT </b> of a thick edged orifice in dependence of a relative length <b>(l_bar = L /d_hyd)</b> with different ratios of cross sectional areas <b> A_0/A_1 </b> is shown in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/fig_orifice_thickEdgedOverall_ZETAvsLENGHT.png\">
</p>
 
<p>
<b> Compressible case </b> [Mass flow rate = f(dp)]: 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/fig_orifice_thickEdgedOverall_MFLOWvsDP.png\">
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
</dl>
</html>
"));
end dp_thickEdgedOverall_MFLOW;
