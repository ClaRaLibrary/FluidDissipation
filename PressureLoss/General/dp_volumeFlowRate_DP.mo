within FluidDissipation.PressureLoss.General;
function dp_volumeFlowRate_DP "Generic pressure loss | calculate pressure loss | quadratic function (dp=a*V_flow^2 + b*V_flow)"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.General;

  //input records
  input FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_con IN_con "Input record for function dp_volumeFlowRate_DP"
    annotation (Dialog(group="Constant inputs"));

  input FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_var IN_var "Input record for function dp_volumeFlowRate_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_volumeFlowRate_DP";

protected
  Real a=max(Modelica.Constants.eps, abs(IN_con.a));
  Real b=max(Modelica.Constants.eps, abs(IN_con.b));

  SI.VolumeFlowRate V_flow=m_flow/max(Modelica.Constants.eps, IN_var.rho) "Volume flow rate";
  SI.Pressure dp_min=IN_con.dp_min "Start of approximation for decreasing pressure loss";
  SI.VolumeFlowRate V_flow_smooth=if IN_con.a > 0 then -(b/(2*a) + ((-b/(2*a))^
      2 + dp_min/a)^0.5) else dp_min/b "Start of approximation for decreasing volume flow rate";

  //Documentation

algorithm
  DP := a*FluidDissipation.Utilities.Functions.General.SmoothPower(
    V_flow,
    V_flow_smooth,
    2) + b*V_flow;
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.General.dp_volumeFlowRate_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of a generic pressure loss with linear or quadratic dependence on volume flow rate.
The function can be used to calculate pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_MFLOW\">dp_volumeFlowRate_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
The geometry parameters of energy devices necessary for the pressure loss calculations are often not exactly known. 
Therefore the modelling of the detailed pressure loss calculation has to be simplified. This function uses as
quadratic dependence of the pressure loss on the volume flow rate.
</p>
 
The pressure loss <b> dp </b> for the incompressible case [Pressure loss = f(m_flow)] is determined to <i> [see Wischhusen] </i>:
<pre>
    dp = a*V_flow^2 + b*V_flow
</pre>
 
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> a              </b></td><td> as quadratic coefficient [Pa*s^2/m^6],</td></tr>
<tr><td><b> b              </b></td><td> as linear coefficient [Pa*s/m3],</td></tr>
<tr><td><b> dp             </b></td><td> as pressure loss [Pa],</td></tr>
<tr><td><b> m_flow         </b></td><td> as mass flow rate [kg/s],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> V_flow         </b></td><td> as volume flow rate [m3/s].</td></tr>
</table>
</p>
 
Note that the coefficients <b> a,b </b> have to be positive values so that there will be a positive (linear or quadratic) pressure loss for a given positive volume flow rate.
 
<h4><font color=\"#EF9B13\">Verification</font></h4>  
<p> 
<b> Incompressible case </b> [Pressure loss = f(m_flow)]:
</p> 
The generic pressure loss <b> dp </b> for different coefficients <b> a </b> as parameter is shown in dependence of the volume flow rate <b> V_flow </b> in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/general/fig_general_dp_volumeFlowRate_DPvsMFLOW.png\">
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
end dp_volumeFlowRate_DP;
