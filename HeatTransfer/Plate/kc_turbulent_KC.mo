within FluidDissipation.HeatTransfer.Plate;
function kc_turbulent_KC
  "Mean heat transfer coefficient of even plate | turbulent regime | constant wall temperature"
  extends Modelica.Icons.Function;
  //SOURCE: VDI-Waermeatlas, Aufl. 9, Springer-Verlag, 2002, Section Gd 1
  //Notation of equations according to SOURCE

  //input records
  input FluidDissipation.HeatTransfer.Plate.kc_turbulent_IN_con IN_con
    "Input record for function kc_turbulent_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.Plate.kc_turbulent_IN_var IN_var
    "Input record for function kc_turbulent_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Output for function kc_turbulent_KC";

protected
  Real MIN=Modelica.Constants.eps "Limiter";

  SI.Length L=max(MIN, IN_con.L) "Plate length";

  SI.SpecificHeatCapacityAtConstantPressure cp=IN_var.cp
    "Specific heat capacity";
  SI.DynamicViscosity eta=max(MIN, IN_var.eta) "Dynamic viscosity";
  SI.ThermalConductivity lambda=max(MIN, IN_var.lambda) "Thermal conductivity";
  SI.Density rho=IN_var.rho "Density";

  SI.Velocity velocity=abs(IN_var.velocity) "Mean velocity";
  SI.ReynoldsNumber Re=abs(rho*velocity*L/eta) "Reynolds number";
  SI.PrandtlNumber Pr=abs(eta*cp/lambda) "Prandtl number";

  //Documentation
algorithm
  kc := abs((lambda/L))*(0.037*Re^0.8*Pr)/(1 + 2.443/(max(Re^0.1, 1e-6))*(Pr^(2
    /3) - 1));
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of the mean convective heat transfer coefficient <b> kc </b> for a hydrodynamically developed turbulent fluid flow over an even surface.
</p>
 
<p>
Generally this function is numerically best used for the calculation of the mean convective heat transfer coefficient <b> kc </b> at known fluid velocity.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> constant wall temperature </li>
<li> turbulent regime (Reynolds number 5e5 &lt; Re &lt; 1e7) </li>
<li> Prandtl number 0.6 &le; Pr &le; 2000 </li>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/plate/pic_plate.png\">
</p>  
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc</b> for flat plate is calculated through the corresponding Nusselt number <b> Nu_turb</b> according to <i>[VDI 2002, p. Gd 1, eq. 2]</i> :
 
<pre>
    Nu_turb = (0.037 * Re^0.8 * Pr) / (1 + 2.443/Re^0.1 * (Pr^(2/3)-1))
</pre>
 
<p>
and the corresponding mean convective heat transfer coefficient <b> kc </b> :
</p>
 
<p>
<pre>
    kc =  Nu_turb * lambda / L
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> cp                           </b></td><td> as specific heat capacity at constant pressure [J/(kg.K)],</td></tr>
<tr><td><b> eta                          </b></td><td> as dynamic viscosity of fluid [Pa.s],</td></tr>
<tr><td><b> kc                           </b></td><td> as mean convective heat transfer coefficient [W/(m2.K)],</td></tr>
<tr><td><b> lambda                       </b></td><td> as heat conductivity of fluid [W/(m.K)],</td></tr>
<tr><td><b> L                            </b></td><td> as length of plate [m],</td></tr>
<tr><td><b> Nu_turb                 </b></td><td> as mean Nusselt number for turbulent regime [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda           </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> rho                          </b></td><td> as fluid density [kg/m3],</td></tr>
<tr><td><b> Re = v*rho*L/eta             </b></td><td> as Reynolds number [-].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
 
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> for Prandtl numbers of different fluids is shown in the figure below.
Here the figures are calculated for an (unintended) inverse calculation, where an unknown mass flow rate is calculated out of a given mean convective heat transfer coefficient <b> kc </b>.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/plate/fig_plate_kc_mean_turbulent_KC.png\">
</p>
 
<p> 
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.Plate.kc_turbulent\"> kc_turbulent </a> is also valid for this inverse calculation due to using the same functions. 
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Elmquist,H., M.Otter and S.E. Cellier:</dt>
    <dd><b>Inline integration: A new mixed
    symbolic / numeric approach for solving differential-algebraic equation systems.</b>.
    In Proceedings of European Simulation MultiConference, Praque, 1995.</dd> 
 
<dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
 
</html>
", revisions="<html>
<pre>2016-04-12 Stefan Wischhusen: Removed singularity for Re at zero mass flow rate. </pre>
</html>"));
end kc_turbulent_KC;
