within FluidDissipation.HeatTransfer.HeatExchanger;
function kc_tubeBundleFilmCondensation_lam_KC "Laminar film condensation in a tube bundle"
  extends Modelica.Icons.Function;
  // SOURCE: Mueller,J. and Numrich, R.: Film Condensation of Pure Vapour (in German) in VDI Waermeatlas, 9th edition, 2002.
  // And
  // T. Fujii, H.Uehara and C. Kurata: Laminar Filmwise Condensation of Flowing Vapour on a Horizontal Cylinder in Int. J. of Heat and Mass Transfer, Vol. 15, pp 235-246,  Pergamon Press, 1972.

  //input records
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_con
    IN_con "Input record for function kc_tubeBundleFilmCondensation_lam_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundleFilmCondensation_lam_IN_var
    IN_var "Input record for function kc_tubeBundleFilmCondensation_lam_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output Modelica.SIunits.CoefficientOfHeatTransfer kc "Heat transfer coefficient";

protected
  Real Xi;
  Real G;
  Real Ph "Phase change number";
  Real Fr "Froude number";
  Real Re_FS "Reynolds number of flowing steam";
  Real Pr "Prandtl number of the film";

algorithm
  Ph    :=IN_var.cp_l*(IN_var.T_s - IN_var.T_w)/IN_var.dh_lg;
  Pr    :=IN_var.eta_l*IN_var.cp_l/IN_var.lambda_l;
  G     :=Ph/Pr*(IN_var.rho_l*IN_var.eta_l/(IN_var.rho_g*IN_var.eta_g))^0.5;
  Xi    :=0.9*(1 + 1/G)^(1/3);
  // According to original paper (Fujii et. al) Reynolds number is calculated with tube diameter "d" instead of characteristic length of film flow "L" = (eta_liq^2/rho_liq^2/g)^(1/3).
  Re_FS :=abs(IN_var.m_flow)/IN_con.A_front/IN_var.rho_g*IN_con.d/(IN_var.eta_l/IN_var.rho_l);
  Fr    :=(max(Modelica.Constants.eps, abs(IN_var.m_flow))/IN_con.A_front/IN_var.rho_g)^2/Modelica.Constants.g_n/IN_con.d;

  kc :=IN_var.lambda_l/IN_con.d*IN_con.C*Xi*(1 + (0.276*Pr)/(Xi^4*Fr*Ph))^0.25* sqrt(Re_FS);

  annotation (smoothOrder(normallyConstant=IN_con) = 2, Documentation(info="<html>
<p>
Calculation of the mean heat transfer coefficient <b> kc </b> for the laminar filmwise condensation of vapour in an horizontal tube bundle heat exchanger.
</p>

<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>

<li> horizontal tube orientation </li>

<li> medium = single-component vapour </li>

<li> validated for 3e5 &lt; Re_FS &lt; 1e6 (according to measurement data) </li>

</ul>

<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/pic_tubeBundle.png\", width=850>
</p> 

<h4><font color=\"#EF9B13\">Calculation</font></h4>
<p>
The mean heat transfer coefficient <b> kc </b> for heat exchanger is calculated through the corresponding Nusselt number <b> Nu_lam</b> according to <i>[VDI 2002, p. Ja 7, eq. 43]</i> :
</p>

<pre>
    Nu = C * Xi * (1 + (0.276*Pr_l)/(Xi^4*Fr*Ph))^0.25 * Re_FS^0.5
</pre>

<p>
with the corresponding mean heat transfer coefficient <b> kc </b> :
</p>

<p>
<pre>
    kc =  Nu * lambda_l / d
</pre>
</p>

<p>
and the non dimensional numbers:
</p>

<p>
<pre>
    Xi =  0.9 * (1 + 1/G)^(1/3)
</pre>
</p>

<p>
<pre>
    G = Ph / Pr_l * (rho_l*eta_l / (rho_v*eta_v))^0.5
</pre>
</p>

<p>
<pre>
    Ph = cp_l * (T_s - T_w) / r
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> C                        </b></td><td> as Correction factor for tube arrangement: offset pattern=1| aligned pattern=0.8 [-], </td></tr>
<tr><td><b> cp_l                        </b></td><td> as specific heat capacity of liquid at constant pressure [J/(kg.K)],</td></tr>
<tr><td><b> d                        </b></td><td> as tube diameter [m],</td></tr>
<tr><td><b> eta_l                        </b></td><td> as dynamic viscosity of liquid [Pa.s],</td></tr>
<tr><td><b> eta_v                        </b></td><td> as dynamic viscosity of vapour [Pa.s],</td></tr>
<tr><td><b> Fr = u^2/(g*d)                </b></td><td> as Froude number [-], </td></tr>
<tr><td><b> G                        </b></td><td> as non dimensional number [-], </td></tr>
<tr><td><b> g                        </b></td><td> as acceleration of gravity [m/s^2],</td></tr>
<tr><td><b> lambda_l                </b></td><td> as heat conductivity of liquid [W/(m.K)],</td></tr>
<tr><td><b> Nu                        </b></td><td> as mean Nusselt number [-], </td></tr>
<tr><td><b> Ph                        </b></td><td> as phase change number [-], </td></tr>
<tr><td><b> Pr_l = eta_l*cp_l/lambda_l        </b></td><td> as Prandtl number of liquid [-], </td></tr>
<tr><td><b> Re_FS = u*d*rho_l/eta_l        </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> r                        </b></td><td> as specific enthalpy of evaporation [J/kg], </td></tr>
<tr><td><b> rho_l                        </b></td><td> as density of liquid [kg/m3],</td></tr>
<tr><td><b> rho_v                        </b></td><td> as density of vapour [kg/m3],</td></tr>
<tr><td><b> T_s                        </b></td><td> as saturation temperature of steam [K], </td></tr>
<tr><td><b> T_w                        </b></td><td> as wall temperature [K], </td></tr>
<tr><td><b> u                        </b></td><td> as oncoming velocity of steam [m/s],</td></tr>
<tr><td><b> Xi                        </b></td><td> as non dimensional number [-]. </td></tr>
</table>
</p>

<p>
<b>Please note</b>: According to original paper (Fujii et. al) Reynolds number is calculated with tube diameter <b>d</b> instead of characteristic lentgh of film flow <b>L</b> = (eta_liq^2/rho_liq^2/g)^(1/3) (VDI-Waermeatlas). This improves the comparability with validation data and other equations and has no influence on calculated heat transfer coefficients. 
</p>

<h4><font color=\"#EF9B13\">Verification</font></h4>  
<p>
The mean Nusselt number <b> Nu </b> representing the mean heat transfer coefficient <b> kc </b> is shown below for different temperature differences between vapour and wall for identical dimensions. 
</p>

<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/heatExchanger/fig_FilmCondensationTubeBundle_kc_KC.png\">
</p>

<p><b><font style=\"color: #ef9b13; \">References</font></b> </p>
<dl><dt>Mueller, J. and Numrich, R. </dt>
<dd><b>Film Condensation of Pure Vapour</b> (in German). in VDI-Waermeatlas, 9th edition,  VDI-Verlag, 2002.</dd>
<dl><dt>T. Fujii, H.Uehara and C. Kurata </dt>
<dd><b>Laminar Filmwise Condensation of Flowing Vapour on a Horizontal Cylinder</b>. in Int. J. of Heat and Mass Transfer, Vol. 15, pp 235-246,  Pergamon Press, 1972.</dd>
</dl></html>"));
end kc_tubeBundleFilmCondensation_lam_KC;
