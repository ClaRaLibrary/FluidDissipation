within FluidDissipation.PressureLoss.General;
function dp_pressureLossCoefficient_MFLOW
  "Generic pressure loss | calculate mass flow rate | pressure loss coefficient (zeta_TOT)"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.General;

  //input records
  input FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con
    IN_con "Input record for function dp_pressureLossCoefficient_MFLOW"
    annotation (Dialog(group="Constant inputs"));

  input FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var
    IN_var "Input record for function dp_pressureLossCoefficient_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW
    "Output for function dp_pressureLossCoefficientt_MFLOW";

  //Documentation

algorithm
  M_FLOW := IN_var.rho*IN_con.A_cross*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    dp,
    IN_con.dp_smooth,
    0.5)/(0.5*IN_var.zeta_TOT*IN_var.rho)^0.5;
  annotation (Inline=true,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=dp_pressureLossCoefficient_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of a generic pressure loss in dependence of  a pressure loss coefficient.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP\">dp_pressureLossCoefficient_DP</a> is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. 
</p> 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mass flow rate <b> m_flow </b> is determined by:
<p>
<pre>
    m_flow = rho*A_cross*(dp/(zeta_TOT *(rho/2))^0.5
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> A_cross        </b></td><td> as cross sectional area [m2],</td></tr>
<tr><td><b> dp             </b></td><td> as pressure loss [Pa],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> m_flow         </b></td><td> as mass flow rate [kg/s],</td></tr>
<tr><td><b> zeta_TOT       </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4> 
<p>
<b> Compressible case </b> [Mass flow rate = f(dp)]:
</p>
The mass flow rate <b> M_FLOW </b> in dependence of the pressure loss <b> dp </b> for a constant pressure loss coefficient <b> zeta_TOT </b> is shown in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/general/fig_general_dp_pressureLossCoefficient_MFLOWvsDP.png\">
</p>
 
Note that the verification for <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP\">dp_pressureLossCoefficient_DP</a> is also valid for this inverse calculation due to using the same functions.
 
 
Note that the verification for <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP\">dp_pressureLossCoefficient_DP</a> is also valid for this inverse calculation due to using the same functions.
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Elmqvist, H., M.Otter and S.E. Cellier:</dt>
    <dd><b>Inline integration: A new mixed
    symbolic / numeric approach for solving differential-algebraic equation systems.</b>.
    In Proceedings of European Simulation MultiConference, Praque, 1995.</dd>
 <dt>Wischhusen, S.:</dt>
    <dd><b>Dynamische Simulation zur wirtschaftlichen Bewertung von komplexen Energiesystemen.</b>.
    PhD thesis, Technische Universit&auml;t Hamburg-Harburg, 2005.</dd>
</dl>
</html>
"));
end dp_pressureLossCoefficient_MFLOW;
