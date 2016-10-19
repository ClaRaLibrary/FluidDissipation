within FluidDissipation.HeatTransfer.HeatExchanger;
function kc_tubeBundle_1ph_KC
  "Heat transfer for a lateral flow through a tube row or a bundle of staggered or inline tube rows (laminar and turbulent flow schemes)"
  extends Modelica.Icons.Function;
  //SOURCE: Gnielinski, V.. Heat Transfer in laterally passed single tube rows and tube bundles (in German). in VDI-Waermeatlas, 9th edition, VDI-Verlag, 2002.
  //input records
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con IN_con
    "Input record for function kc_FilmCondensationTubeBundle"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var IN_var
    "Input record for function kc_FilmCondensationTubeBundle"
    annotation (Dialog(group="Variable inputs"));

  output Modelica.SIunits.CoefficientOfHeatTransfer kc
    "Output for function kc_tubeBundle_1ph_KC";

protected
  Real MIN=1e-5 "Limiter";
  Real Nu_L_lam "Nusselt number of laminar flow, one tube";
  Real Nu_L_turb "Nusselt number of turbulent flow, one tube";
  Real Nu_L "Nusselt number one tube";
  Real Nu_L_B "Average Nusselt number of whole tube bundle";
  Real Re_L "Laminar Reynolds number one tube";
  Real Pr "Prandtl number of fluid";
  Real Pr_w "Prandtl number of fluid near wall";
  Real fa "Alignment factor";
  SI.Length L "Characteristic length";
  Real a "Longitudinal alignment ratio";
  Real b "Perpendicular alignment ratio";
  Real psi "Void ratio";
  Real K "Heat flow direction coefficient";
algorithm

  a:=IN_con.s_1/IN_con.d;
  b:=IN_con.s_2/IN_con.d;
  // b<=0 refers to single row case!
  psi:=if b >= 1 or b<=0 then 1 - Modelica.Constants.pi/4/a else 1 - Modelica.Constants.pi/4/a/b;
  L:=Modelica.Constants.pi/2*IN_con.d;
  Re_L :=abs(IN_var.m_flow)/IN_con.A_front/IN_var.rho*L/psi/IN_var.eta*IN_var.rho;
  Pr   :=IN_var.eta*IN_var.cp/max(MIN,IN_var.lambda);
  Pr_w   :=IN_var.eta_w*IN_var.cp_w/max(MIN,IN_var.lambda_w);
  Nu_L_lam :=0.664*sqrt(Re_L)*max(MIN,Pr)^(1/3);
  Nu_L_turb :=(0.037*Re_L^0.8*Pr)/(1 + 2.443*max(MIN,Re_L)^(-0.1)*(max(MIN,Pr)^(2/3) - 1));
  K :=if Pr/Pr_w > 1 then (max(MIN,Pr/Pr_w))^0.25 else (max(MIN,Pr/Pr_w))^0.11;
  Nu_L :=K*(0.3 + sqrt((Nu_L_lam^2 + Nu_L_turb^2)));
  if IN_con.staggeredAlignment then
    fa := 1 + (if b>0 then 2/3/b else 0);
  else
    fa := 1 + (if b>0 then 0.7/psi^1.5*(b/a - 0.3)/(b/a + 0.7)^2 else 0);
  end if;
  Nu_L_B := Nu_L*(if IN_con.n>=10 then fa else (((IN_con.n-1)*fa+1)/IN_con.n));

  kc:= Nu_L_B*IN_var.lambda/L;
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(info="<html>
<p>
Calculation of the mean heat transfer coefficient <b> kc </b> for laterally passed single tube rows and tube bundles.
</p>

<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>

<li> single-phase medium  </li>

<li> 10 &lt; Re_psi_L &lt; 1e6</li>

<li> 0.6 &lt; Pr &lt; 1e3</li>

</ul>

<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/pic_tubeBundle186_1phase.png\", width=600>
</p> 

<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
The mean heat transfer coefficient <b> kc </b> for a single row of tubes or a tube bundle is calculated through the corresponding Nusselt number <b> Nu_lam</b> according to <i>[VDI 2002, p. Gg 1, eq. 3]</i> :
</p>

<pre>
    Nu_lam = 0.664 * Re_psi_L^0.5 * Pr^(1/3)
</pre>
 
<p>
with the corresponding mean heat transfer coefficient <b> kc </b> :
</p>
 
<p>
<pre>
    kc =  Nu * lambda / L
</pre>
</p>
 
<p>
whereas <b> L </b> equals half of the tubes circumference and for the non-dimensional Reynolds number <b> Re_psi_L </b> holds:
</p>

<p>
<pre>
    Re_psi_L =  (w0 * L * rho) / (psi * eta)
</pre>
</p>

<p>
The void fraction <b> psi </b> of the tube bundle is calculated for different longitudinal (i.e., in-flow) alignment ratios <b> b </b> = s_2/d_a:
</p>

<p>
<pre>
    psi = 1 - pi / (4 * a) if b &ge; 1
</pre>
</p>

<p>
<pre>
    psi = 1 - pi / (4 * a * b) if b &lt; 1 
</pre>
</p>

<p>
For the turbulent contribution <b> Nu_turb </b> equals:
</p>

<p>
<pre>
    Nu_turb = 0.037 * Re_psi_L^0.8 * Pr / (1 + 2.443 * Re_psi_L^(-0.1) * (Pr^(2/3) - 1)).
<pre>
</p>

<h4> Single row of tubes </h4>

<p> The superposition of the laminar and turbulent part yields for a single row of tubes:</p>

<p>
<pre>
    Nu_L,0 = 0.3 + (Nu_lam^2 + Nu_turb^2)^(0.5).
<pre>
</p>

<h4> Bundle of tube rows </h4>

<p> Depending on the row arrangement the Nusselt number is scaled with an arrangement factor <b>fa</b>:</p>

<p><i> Inline arrangement </i></p>

<p>
<pre>
    fa = 1 + 0.7 / psi^1.5 * (b/a - 0.3) / (b/a + 0.7)^2 
<pre>
</p>

<p><i> Staggered arrangement </i></p>

<p>
<pre>
    fa = 1 + 2 / (3*b)
<pre>
</p>

<p>which yields for <b> more </b> than 10 rows:</p>

<p>
<pre>
    Nu_bundle = fa * Nu_L,0.
<pre>
</p>

<p> <b>Less</b> than 10 rows are scaled with an additional factor:</p>

<p>
<pre>
    Nu_bundle =  (1 + (n - 1)*fa) / n * Nu_L,0.
<pre>
</p>


<p>
with
</p>
 
<p>
<table>
<tr><td><b> a </b></td><td> as alignment ratio orthogonal to flow direction [-],</td></tr>
<tr><td><b> b </b></td><td> as alignment ratio parallel to flow direction [-],</td></tr>
<tr><td><b> eta </b></td><td> as dynamic viscosity of fluid [Pa.s],</td></tr>
<tr><td><b> fa </b></td><td> as alignment factor [-],</td></tr>
<tr><td><b> kc </b></td><td> as heat transfer coefficient [W/(m2.K)],</td></tr>
<tr><td><b> L = 0.5*PI*d </b></td><td> as characteristic length [m],</td></tr>
<tr><td><b> lambda </b></td><td> as heat conductivity of fluid [W/(m.K)],</td></tr>
<tr><td><b> Nu_L,0</b></td><td> as mean Nusselt number of single tube row [-], </td></tr>
<tr><td><b> Nu_bundle</b></td><td> as mean Nusselt number of whole tube bundle [-], </td></tr>
<tr><td><b> Nu_lam </b></td><td> as mean Nusselt number of laminar flow region [-], </td></tr>
<tr><td><b> Nu_turb </b></td><td> as mean Nusselt number of turbulent flow region [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda </b></td><td> as Prandtl number of fluid [-], </td></tr>
<tr><td><b> psi </b></td><td> as void factor [-],</td></tr>
<tr><td><b> Re_psi_L </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> rho </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> w0 </b></td><td> as oncoming velocity of fluid [m/s].</td></tr>
</table>
</p>

<h4><font color=\"#EF9B13\">Verification</font></h4>  
<p>
The mean Nusselt number <b> Nu </b> representing the mean heat transfer coefficient <b> kc </b> is shown below for different tube alignments. 
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/fig_TubeBundle_kc_KC.png\">
</p>

<p><b><font style=\"color: #ef9b13; \">References</font></b> </p>
<dl><dt>Gnielinski, V. </dt>
<dd><b>Heat Transfer in laterally passed single tube rows and tube bundles</b>  (in German). in VDI-Waermeatlas, 9th edition, VDI-Verlag, 2002.</dd>
<dl><dt>Zukauskas, A. and Ulinskas, R. </dt>
<dd><b>Heat Transfer in Tube Banks in Crosslflow</b>, Hemisphere Publishing Corporation (outside North America: Springer-Verlag), 1988.</dd>

</html>"));
end kc_tubeBundle_1ph_KC;
