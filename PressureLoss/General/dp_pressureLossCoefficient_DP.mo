within FluidDissipation.PressureLoss.General;
function dp_pressureLossCoefficient_DP "Generic pressure loss | calculate pressure loss | pressure loss coefficient (zeta_TOT)"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.General;

  //input records
  input FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con
    IN_con "Input record for dp_pressureLossCoefficient_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var
    IN_var "Input record for dp_pressureLossCoefficient_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_pressureLossCoefficient_DP";

  //Documentation

algorithm
  DP := 0.5*IN_var.zeta_TOT*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    (IN_con.dp_smooth/(0.5*IN_var.zeta_TOT*IN_var.rho))^0.5*IN_var.rho*IN_con.A_cross,
    2)/(IN_var.rho*(IN_con.A_cross)^2);
  annotation (Inline=true,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of a generic pressure loss in dependence of a pressure loss coefficient.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW\">dp_pressureLossCoefficient_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The generic pressure loss <b> dp </b> is determined by:
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
<tr><td><b> dp             </b></td><td> as pressure loss [Pa],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity       </b></td><td> as mean velocity [m/s],</td></tr>
<tr><td><b> zeta_TOT       </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>  
<p> 
<b> Incompressible case </b> [Pressure loss = f(m_flow)]:
</p>  
The pressure loss <b> DP </b> in dependence of the mass flow rate <b> m_flow </b> for a constant pressure loss coefficient <b> zeta_TOT </b> is shown in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/general/fig_general_dp_pressureLossCoefficient_DPvsMFLOW.png\">
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>Elmquist, H., M.Otter and S.E. Cellier:</dt>
    <dd><b>Inline integration: A new mixed
    symbolic / numeric approach for solving differential-algebraic equation systems.</b>.
    In Proceedings of European Simulation MultiConference, Praque, 1995.</dd>
 <dt>Wischhusen, S.:</dt>
    <dd><b>Dynamische Simulation zur wirtschaftlichen Bewertung von komplexen Energiesystemen.</b>.
    PhD thesis, Technische Universit&auml;t Hamburg-Harburg, 2005.</dd>
</dl>
</html>"));
end dp_pressureLossCoefficient_DP;
