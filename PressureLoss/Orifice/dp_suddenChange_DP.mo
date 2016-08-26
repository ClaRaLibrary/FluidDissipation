within FluidDissipation.PressureLoss.Orifice;
function dp_suddenChange_DP "Pressure loss of orifice with sudden change in cross sectional area | calculate pressure loss | turbulent flow regime | smooth surface | arbitrary cross sectional area | without buffles | sharp edge"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Orifice;

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_con IN_con "Input record for function dp_suddenChange_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_var IN_var "Input record for function dp_suddenChange_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_suddenChange_DP";

protected
  Real MIN=Modelica.Constants.eps;
  SI.ReynoldsNumber Re_min=10 "Minimum Reynolds number for linear smoothing";
  //restriction of local resistance coefficient zeta_LOC >> numerical improvement
  TYP.LocalResistanceCoefficient zeta_LOC_min=1e-3 "Minimal local resistance coefficient";

  SI.Area A_1=max(MIN, min(IN_con.A_1, IN_con.A_2)) "Small cross sectional area of orifice";
  SI.Area A_2=max(MIN, max(IN_con.A_1, IN_con.A_2)) "Large cross sectional area of orifice";
  SI.Length C_1=max(MIN, min(IN_con.C_1, IN_con.C_2)) "Perimeter of small cross sectional area of orifice";
  SI.Length C_2=max(MIN, max(IN_con.C_1, IN_con.C_2)) "perimeter of large cross sectional area of orifice";
  SI.Diameter d_hyd=4*A_1/C_1 "Hydraulic diameter of small cross sectional area of orifice";

  //sudden expansion  :  SOURCE_1, section 4, diagram 4-1, page 208
  //assumption of Re >= 3.3e3 for sudden expansion
  TYP.LocalResistanceCoefficient zeta_LOC_exp=max(zeta_LOC_min, (1 - A_1/A_2)^2);

  //sudden contraction:  SOURCE_1, section 4, diagram 4-9, page 216 / 217
  //assumption of Re >= 1.0e4 for sudden contraction
  TYP.LocalResistanceCoefficient zeta_LOC_con=max(zeta_LOC_min, 0.5*(1 - A_1/A_2)^0.75);

  SI.Velocity velocity_1=m_flow/(IN_var.rho*A_1) "Mean velocity in smaller cross sectional area";

  //determine Reynolds number for small cross sectional area of orifice
  SI.ReynoldsNumber Re=IN_var.rho*d_hyd*velocity_1/IN_var.eta;

  //actual local resistance coefficient
  TYP.LocalResistanceCoefficient zeta_LOC=max(zeta_LOC_min, zeta_LOC_exp*SMOOTH(
      Re_min,
      -Re_min,
      Re) + zeta_LOC_con*SMOOTH(
      -Re_min,
      Re_min,
      Re));

  //Documentation

algorithm
  DP := zeta_LOC*IN_var.rho/2*(IN_var.eta/IN_var.rho/d_hyd)^2*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    Re,
    Re_min,
    2);

  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.Orifice.dp_suddenChange_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of the local pressure loss at a sudden change of the cross sectional areas (sudden expansion or sudden contraction) with sharp corners at turbulent flow regime for incompressible and single-phase fluid flow through arbitrary shaped cross sectional area (square, circular, etc.) considering a smooth surface. The flow direction determines the type of the transition. In case of the design flow a sudden expansion will be considered. At flow reversal a sudden contraction will be considered.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_suddenChange_MFLOW\">dp_suddenChange_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li>
      <b>Smooth surface</b>
 <li>
      <b>Turbulent flow regime</b>
 <li>
      <b>Reynolds number for sudden expansion Re &gt; 3.3e3 </b> <i>[Idelchik 2006, p. 208, diag. 4-1] </i>
 <li> 
      <b>Reynolds number for sudden contraction Re &gt; 1e4 </b> <i>[Idelchik 2006, p. 216-217, diag. 4-9] </i>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/pic_suddenChangeSection.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The local pressure loss <b> dp </b> is generally determined by:
<p>
<pre>
dp = 0.5 * zeta_LOC * rho * |v_1|*v_1 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho              </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> v_1             </b></td><td> as average flow velocity in small cross sectional area [m/s].</td></tr>
<tr><td><b> zeta_LOC         </b></td><td> as local resistance coefficient [-],</td></tr>
</table>
</p>
 
The local resistance coefficient <b> zeta_LOC </b> of a sudden expansion can be calculated for different ratios of cross sectional areas by:
<p>
<pre>
zeta_LOC = (1 - A_1/A_2)^2  <i>[Idelchik 2006, p. 208, diag. 4-1] </i> 
</pre>
</p>
 
 
and for sudden contraction:
<p>
<pre>
zeta_LOC = 0.5*(1 - A_1/A_2)^0.75  <i>[Idelchik 2006, p. 216-217, diag. 4-9] </i> 
</pre>
</p>
 
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> A_1       </b></td><td> small cross sectional area [m^2],</td></tr>
<tr><td><b> A_2       </b></td><td> large cross sectional area [m^2].</td></tr>
 
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>   
The local resistance coefficient <b> zeta_LOC </b> of a sudden expansion in dependence of the cross sectional area ratio <b> A_1/A_2 </b> is shown in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/fig_orifice_suddenChangeExpansion.png\">
</p>
 
The local resistance coefficient <b> zeta_LOC </b> of a sudden contraction in dependence of the cross sectional area ratio <b> A_1/A_2 </b> is shown in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/orifice/fig_orifice_suddenChangeContraction.png\">
</p>
 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Elmquist, H., M.Otter and S.E. Cellier:</dt>
    <dd><b>Inline integration: A new mixed
    symbolic / numeric approach for solving differential-algebraic equation systems.</b>.
    In Proceedings of European Simulation MultiConference, Praque, 1995.</dd>
 
<dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
</dl>
</html>
"));
end dp_suddenChange_DP;
