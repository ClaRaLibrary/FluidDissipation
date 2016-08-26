within FluidDissipation.PressureLoss.HeatExchanger;
function dp_corrugatedPlate_1ph_DP "1-phase pressure loss of corrugated plate heat exchanger"
  extends Modelica.Icons.Function;
  //SOURCE: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002
  //Notation of equations according to SOURCE

  import FD = FluidDissipation.PressureLoss.HeatExchanger;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_con
                                                                              IN_con "Input record for function dp_corrugatedPlate_1ph_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var
                                                                              IN_var "Input record for function dp_corrugatedPlate_1ph_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));

protected
  Real MIN=Modelica.Constants.eps;

  Modelica.SIunits.ReynoldsNumber Re = IN_var.rho*w*D_h/IN_var.eta "Reynolds number based on hydraulic diameter";

  Real xi "pressure loss coefficient";
  Real xi_0 "pressure loss coefficient if phi=0°";
  Real xi_1 "pressure loss coefficient if phi=90°";

  SI.Velocity w=max(MIN, abs(m_flow)/(IN_var.rho*A_c)) "Velocity";

  SI.Area A_c = IN_con.channels*2*IN_con.amp*IN_con.Width "Cross flow area";
  SI.Length D_h = 4*IN_con.amp/Phi "Hydraulic diameter";

  Real X = 2*Modelica.Constants.pi*IN_con.amp/IN_con.Lambda "wave number";
  Real Phi = 1/6*(1+sqrt(1+X^2)+4*sqrt(1+0.5*X^2)) "area enhancement factor";

algorithm
  //pressure loss coefficient if phi=0°
  xi_0 := SMOOTH(
    2000+100,
    2000-100,
    Re)*(1/((1.8*log10(Re) - 1.5)^2))
    + SMOOTH(
    2000-100,
    2000+100,
    Re)*(64/Re);

  //pressure loss coefficient if phi=90°
  xi_1 := IN_con.a*(SMOOTH(
    2000+100,
    2000-100,
    Re)*(39/Re^(0.289))
    + SMOOTH(
    2000-100,
    2000+100,
    Re)*(597/Re + 3.85));

  //real pressure loss coefficient
  xi := 1/((cos(IN_con.phi)/(sqrt(IN_con.b*tan(IN_con.phi)+IN_con.c*sin(IN_con.phi)+xi_0/cos(IN_con.phi)))
    +(1-cos(IN_con.phi))/sqrt(xi_1))^2);

  //pressure loss
  DP := sign(m_flow)*xi*IN_con.Length*IN_var.rho/(2*D_h)*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    w,
    IN_con.velocity_small,
    2);
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    Documentation(info=" <html>
<p>
Calculation of pressure loss in corrugated plate heat exchangers for incompressible and single-phase fluid flow.
</p>
 
<p>
This function can be used to calculate the pressure loss at known mass flow rate (m_flow).
</p>

<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>

<li> medium = incompressible and single-phase fluid </li>

</ul>

<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/pic_corrugatedPlate.png\", width=850>
</p> 

<h4><font color=\"#EF9B13\">Calculation</font></h4>

<p>
The pressure loss <b> dp </b> for heat exchangers is determined by:
</p>

<p>
<pre>
    dp = zeta_TOT * (rho/2) * w^2 
</pre>
</p>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> rho                </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> w                     </b></td><td> as average velocity [m/s],</td></tr>
<tr><td><b> zeta_TOT        </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
The pressure loss coefficient <b> zeta_TOT </b> for heat exchangers is determined by:
</p>

<p>
<pre>
    zeta_TOT = xi * Length / D_h
</pre>
</p>

<p>
<pre>
         D_h = 4 * amp * Phi 
</pre>
</p>

<p>
<pre>
         Phi = 1/6 * (1 + (1 + X^2)^(1/2) + 4 * (1 + 0.5 * X^2)^(1/2))) 
</pre>
</p>

<p>
<pre>
           X = 2 * pi * amp / Lambda
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> amp        </b></td><td> as amplitude of corrugated plate [m],</td></tr>
<tr><td><b> D_h        </b></td><td> as hydraulic diameter [m],</td></tr>
<tr><td><b> Lambda        </b></td><td> as wave length of corrugated plate [m],</td></tr>
<tr><td><b> Length        </b></td><td> as length of heat exchanger [m],</td></tr>
<tr><td><b> Phi        </b></td><td> as area enhancement factor [-],</td></tr>
<tr><td><b> X        </b></td><td> as wave number [-],</td></tr>
<tr><td><b> xi        </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
The pressure loss coefficient <b> xi </b> for different corrugation angles is interpolated between two extremes:
</p>

<p>
<pre>
     xi(phi) = cos(phi) / (b * tan(phi) + c * sin(phi) xi_0/cos(phi))^(1/2) + (1 - cos(phi)) / (xi_1)^(1/2)
</pre>
</p>

<p>
<ul>
  <li> xi_0(<b>phi = 0°</b>):
     <pre>
        <table>
        <tr><td>   xi_0 = 64 / Re                        </td><td> for <b>Re &lt; 2000</b>,</td></tr>
        <tr><td>   xi_0 = 1 / (1.8 * lg(Re) - 1.5)^2        </td><td> for <b>Re &ge; 2000</b>,</td></tr>
        </table>
     </pre>
  <li> xi_1(<b>phi = 90°</b>):
     <pre>
        <table>
        <tr><td>   xi_1 = a * 597 / Re + 3.85                </td><td> for <b>Re &lt; 2000</b>,</td></tr>
        <tr><td>   xi_1 = a * 39 / Re^0.289                </td><td> for <b>Re &ge; 2000</b>,</td></tr>
        </table>
     </pre>
</ul>
</p>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> a = 3.8                        </b></td><td> as friction loss parameter (default values from literaure) [-],</td></tr>
<tr><td><b> b = 0.18                </b></td><td> as friction loss parameter (default values from literaure) [-],</td></tr>
<tr><td><b> c = 0.36                </b></td><td> as friction loss parameter (default values from literaure) [-],</td></tr>
<tr><td><b> Re = rho*w*D_h/eta        </b></td><td> as Reynolds number based on hydraulic diameter <b> D_h </b> and average velocity <b> w </b> [-].</td></tr>
</table>
</p>

<h4><font color=\"#EF9B13\">Verification</font></h4>
<p>
The pressure loss coefficient (<b>xi</b>) of corrugated plate heat exchangers with varying corrugation angle <b>phi</b> are shown in dependence of the Reynolds number (<b>Re</b>) in the figure below.<br>
According to literature the parameter a, b and c have been set to 1.6, 0.4 and 0.36 for better fit.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/fig_heatExchanger_dp_corrugatedPlate_xiVsRe.png\">
</p>

<p>
The pressure loss of the same type of heat exchangers with three different corrugation angles in dependence of mass flow rate is shown in the figure below.
<p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/heatExchanger/fig_heatExchanger_dp_corrugatedPlate_DPvsRe.png\">
</p> 

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dl><dt>A. Leveque, E.-U. Schlünder and h. Martin </dt>
<dd><b>Pressure Loss and Heat Transfer in Plate Heat Exchangers</b> (in German). in VDI-Waermeatlas, 10th edition,  VDI-Verlag, 2006.</dd>
</dl>

</html>"));
end dp_corrugatedPlate_1ph_DP;
