within FluidDissipation.HeatTransfer.General;
function kc_approxForcedConvection_KC
  "Mean convective heat transfer coefficient for forced convection | approximation | turbulent regime | hydrodynamically developed fluid flow"
  extends Modelica.Icons.Function;
  //SOURCE: A Bejan and A.D. Kraus. Heat Transfer handbook.John Wiley & Sons, 2nd edition, 2003. (p.424 ff)
  //Notation of equations according to SOURCE

  //input records
  input FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con IN_con
    "Input record for function kc_approxForcedConvection_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var IN_var
    "Input record for function kc_approxForcedConvection_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc
    "Output for function kc_approxForcedConvection_KC";

  import TYP = FluidDissipation.Utilities.Types.kc_general;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd=max(MIN, 4*IN_con.A_cross/max(MIN, IN_con.perimeter))
    "Hydraulic diameter";

  SI.PrandtlNumber Pr=max(MIN, abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda)))
    "Prandtl number";
  SI.ReynoldsNumber Re=max(1, 4*abs(IN_var.m_flow)/max(MIN, IN_con.perimeter*
      IN_var.eta)) "Reynolds number";

algorithm
  kc := IN_var.lambda/d_hyd*(if IN_con.target == TYP.Rough then 0.023*Re^(4/5)*
    Pr^IN_con.exp_Pr else if IN_con.target == TYP.Middle then 0.023*Re^(4/5)*Pr
    ^(1/3)*(IN_var.eta/IN_var.eta_wall)^0.14 else if IN_con.target == TYP.Finest and Pr
     <= 1.5 then 0.0214*max(1, abs(Re^0.8 - 100))*Pr^0.4 else if IN_con.target
     == TYP.Finest then 0.012*max(1, abs(Re^0.87 - 280))*Pr^0.4 else 0);

  //Documentation
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Approximate calculation of the mean convective heat transfer coefficient <b> kc </b> for forced convection with a fully developed fluid flow in a turbulent regime.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> Constant wall temperature <b> or </b> constant heat flux  
<li> Turbulent regime (Reynolds number 2500 &lt; Re &lt; 1e6) 
<li> Prandtl number 0.5 &le; Pr &le; 500 
</ul>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc </b> is approximated through different Nusselt number <b> Nu </b> correlations out of <i>[Bejan 2003, p. 424 ff]</i>. <br>
Roughest approximation according to Dittus/Boelter (1930):
<pre>
    Nu_1 = 0.023 * Re^(4/5) * Pr^(exp_Pr) 
</pre>
 
Middle approximation according to Sieder/Tate (1936) considering the temperature dependence of the fluid properties:
<pre>
    Nu_2 = 0.023 * Re^(4/5) * Pr^(1/3) * (eta/eta_wall)^(0.14) 
</pre>
 
Finest approximation according to Gnielinski (1976):
<pre>
    Nu_3 = 0.0214 * [Re^(0.8) - 100] * Pr^(0.4) for Pr &le; 1.5 
         = 0.012 * [Re^(0.87) - 280] * Pr^(0.4) for Pr &gt; 1.5
</pre>
 
<p>
The mean convective heat transfer coefficient <b> kc </b> is calculated by:
</p 
<p>
<pre>
    kc =  Nu * lambda / d_hyd
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> eta                          </b></td><td> as dynamic viscosity of fluid [Pa.s],</td></tr>
<tr><td><b> eta_wall                     </b></td><td> as dynamic viscosity of fluid at wall temperature [Pa.s],</td></tr>
<tr><td><b> exp_Pr                       </b></td><td> as exponent for Prandtl number w.r.t. Dittus/Boelter (0.4 for heating or 0.3 for cooling) [-],</td></tr>
<tr><td><b> kc                           </b></td><td> as mean convective heat transfer coefficient [W/(m2.K)],</td></tr>
<tr><td><b> lambda                       </b></td><td> as heat conductivity of fluid [W/(m.K)],</td></tr>
<tr><td><b> d_hyd                        </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> Nu_1/2/3                     </b></td><td> as mean Nusselt number [-], </td></tr>
<tr><td><b> Pr                           </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> Re                           </b></td><td> as Reynolds number [-].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
 
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> for Prandtl numbers of different fluids is shown in the figure below. <br>
<b>Dittus/Boelter</b> (Target = 1)
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/general/fig_kc_approxForcedConvection_T1.png\">
</p>
<b>Sieder/Tate</b> (Target = 2)
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/general/fig_kc_approxForcedConvection_T2.png\">
</p>
<b>Gnielinski</b> (Target = 3)
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/general/fig_kc_approxForcedConvection_T3.png\">
</p>
 
Note that all fluid properties shall be calculated with the mean temperature of the fluid between the entrance and the outlet of the generic device.
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl> 
<dt>Bejan,A.:</dt> 
    <dd><b>Heat transfer handbook</b>. 
    Wiley, 2003.</dd>
</dl>
 
</html>"));
end kc_approxForcedConvection_KC;
