within FluidDissipation.PressureLoss.General;
function dp_nominalDensityViscosity_DP
  "Generic pressure loss | calculate mass flow rate | nominal operation point | pressure loss law (exponent) | density and dynamic viscosity dependence"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.General;

  //input records
  input FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_con
    IN_con "Input record for function dp_nominalDensityViscosity_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_IN_var
    IN_var "Input record for function dp_nominalDensityViscosity_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Output for function dp_nominalDensityViscosity_DP";

protected
  SI.MassFlowRate m_flow_smooth=(max(1, 0.01*IN_con.dp_nom)*IN_var.rho/IN_con.rho_nom
      *(1/IN_var.eta*IN_con.eta_nom)^(IN_con.exp_eta)*(1/IN_con.m_flow_nom))^(1
      /IN_con.exp) "Start of approximation for decreasing mass flow rate";

  //Documentation

algorithm
  DP := if IN_con.exp > 1.0 or IN_con.exp < 1.0 then
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    m_flow_smooth,
    IN_con.exp)*(IN_var.eta/IN_con.eta_nom)^IN_con.exp_eta*IN_con.rho_nom/
    IN_var.rho*IN_con.dp_nom*(1/IN_con.m_flow_nom)^(IN_con.exp) else m_flow/
    IN_con.m_flow_nom*(IN_var.eta/IN_con.eta_nom)^IN_con.exp_eta*IN_con.rho_nom
    /IN_var.rho*IN_con.dp_nom;
  annotation (Inline=true,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>
Calculation of a generic pressure loss in dependence of nominal fluid variables (e.g. nominal density, nominal dynamic viscosity) at an operation point via interpolation.
This generic function considers the pressure loss law via a pressure loss exponent and the influence of density and dynamic viscosity on pressure loss.
The function can be used to calculate pressure loss at known mass flow rate <b> or </b>  mass flow rate at known pressure loss.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this  function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the  function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_MFLOW\">dp_nominalDensityViscosity_MFLOW</a> is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
The geometry parameters of energy devices necessary for the pressure loss calculations are often not exactly known. 
Therefore the modelling of the detailed pressure loss calculation has to be simplified.
This function uses nominal variables (e.g. nominal pressure loss) at a known operation point of the energy device to interpolate the actual pressure loss according to a pressure loss law (exponent).
</p>
 
The generic pressure loss <b> dp </b> is determined for:
<ul>
 <li> 
 compressible case [Mass flow rate = f(dp)]:
  <pre>
   m_flow = m_flow_nom*[(dp/dp_nom)*(rho/rho_nom)]^(1/exp)*(eta_nom/eta)^(exp_eta/exp)
   </pre>   
 </li>
 <li> 
 incompressible case [Pressure loss = f(m_flow)]:
  <pre>
   dp = dp_nom*(m_flow/m_flow_nom)^exp*(rho_nom/rho)*(eta/eta_nom)^exp_eta
   </pre>
  </li>
</ul>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp             </b></td><td> as pressure loss [Pa],</td></tr>
<tr><td><b> dp_nom         </b></td><td> as nominal pressure loss [Pa],</td></tr>
<tr><td><b> eta            </b></td><td> as dynamic viscosity of fluid [kg/(ms)].</td></tr>
<tr><td><b> eta_nom        </b></td><td> as nominal dynamic viscosity of fluid [kg/(ms)].</td></tr>
<tr><td><b> m_flow         </b></td><td> as mass flow rate [kg/s],</td></tr>
<tr><td><b> m_flow_nom     </b></td><td> as nominal mass flow rate [kg/s],</td></tr>
<tr><td><b> exp            </b></td><td> as exponent of pressure loss calculation [-],</td></tr>
<tr><td><b> exp_eta        </b></td><td> as exponent of dynamic viscosity dependence [-],</td></tr>
<tr><td><b> rho            </b></td><td> as fluid density [kg/m3],</td></tr>
<tr><td><b> rho_nom        </b></td><td> as nominal fluid density [kg/m3].</td></tr>
</table>
</p>
 
To avoid numerical difficulties this pressure loss function is linear smoothed for
<ul>
 <li> 
 small mass flow rates, where 
 <pre> 
  m_flow &le; (0.01*rho/rho_nom*(1/eta*eta_nom)^(exp_eta))^(1/exp) and
  </pre>  
 </li>
 <li> small pressure losses, where
 <pre> 
 dp &le; 0.01*dp_nom) 
 </pre> 
 </li>
</ul>
 
Note that the density (rho) and dynamic viscosity (eta) of the fluid are defined through the defintion of the kinematic viscosity (nue).
<pre> 
    nue = eta / rho
</pre>  
Therefore if you set both the exponent of dynamic viscosity (exp_eta = 1) and additionally a relation of density and dynamic viscosity there will be no difference for varying densities because the dynamic viscosities will vary in the same manner.
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
<p> 
<b> Incompressible case </b> [Pressure loss = f(m_flow)]:
</p> 
The generic pressure loss <b> DP </b> in dependence of the mass flow rate <b> m_flow </b> with different fluid densities and dynamic viscosity dependence as parameters is shown for a turbulent pressure loss regime (exp == 2) in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/general/fig_general_dp_nominalDensityViscosity_DPvsMFLOW.png\">
</p>
 
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
end dp_nominalDensityViscosity_DP;
