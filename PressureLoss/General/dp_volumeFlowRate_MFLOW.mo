within FluidDissipation.PressureLoss.General;
function dp_volumeFlowRate_MFLOW
  "Generic pressure loss | calculate mass flow rate | quadratic function (dp=a*V_flow^2 + b*V_flow)"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.General;

  //input records
  input FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_con IN_con
    "Input record for function dp_volumeFlowRate_MFLOW"
    annotation (Dialog(group="Constant inputs"));

  input FluidDissipation.PressureLoss.General.dp_volumeFlowRate_IN_var IN_var
    "Input record for function dp_volumeFlowRate_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Output for function dp_volumeFlowRate_MFLOW";

protected
  Real a=abs(IN_con.a);
  Real b=abs(IN_con.b);

  SI.Pressure dp_min=max(Modelica.Constants.eps, abs(IN_con.dp_min))
        "Start of approximation for decreasing pressure loss";

  //Documentation

algorithm

        assert(a+b>0, "Please provide non-zero factors for either a or b of function dp=a*V_flow^2 + b*V_flow");
       if b>0 then
         M_FLOW := IN_var.rho*(if a>0 then (-b/(2*a) +
                sqrt((b/(2*a))^2 + (1/a)*dp)) else b*dp);
       else
         M_FLOW := IN_var.rho*sqrt(1/a)*
                FluidDissipation.Utilities.Functions.General.SmoothPower(
                dp,
                dp_min,
                0.5);
       end if;
  annotation (Inline=true,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP(
          IN_con,
          IN_var,
          M_FLOW)),
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
Generally this  function is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP\">dp_volumeFlowRate_DP</a> is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. 
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
The geometry parameters of energy devices necessary for the pressure loss calculations are often not exactly known. 
Therefore the modelling of the detailed pressure loss calculation has to be simplified. This function uses as
quadratic dependence of the pressure loss on the volume flow rate.
</p>
 
The mass flow rate <b> m_flow </b> for the compressible case [Mass flow rate = f(dp)] is determined to <i> [see Wischhusen] </i>:
<pre>
 m_flow:= rho*[-b/(2a) + {[b/(2a)]^2 + dp/a}^0.5] ;
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
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3].</td></tr>
</table>
</p>
 
Note that the coefficients <b> a,b </b> have to be positive values so that there will be a positive (linear or quadratic) pressure loss at positive volume flow rate and vice versa.
 
<h4><font color=\"#EF9B13\">Verification</font></h4>  
<b> Compressible case </b> [Mass flow rate = f(dp)]:  
The generic pressure loss <b> dp </b> for different coefficients <b> a </b> as parameter is shown in dependence of the volume flow rate <b> V_flow </b> in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/general/fig_general_dp_volumeFlowRate_MFLOWvsDP.png\">
</p>
Note that the verification for <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP\">dp_volumeFlowRate_DP</a> is also valid for this inverse calculation due to using the same functions.
 
 
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
", revisions="<html>
2018-11-21 Stefan Wischhusen: Fixed problem for linear case (a=0 and b>0).
</html>"));
end dp_volumeFlowRate_MFLOW;
