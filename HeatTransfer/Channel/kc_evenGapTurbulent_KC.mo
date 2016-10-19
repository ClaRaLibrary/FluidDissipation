within FluidDissipation.HeatTransfer.Channel;
function kc_evenGapTurbulent_KC
  "Mean heat transfer coefficient of even gap | turbulent flow regime | developed fluid flow | heat transfer at BOTH sides | identical and constant wall temperatures"
  extends Modelica.Icons.Function;
  //SOURCE: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Gb 7

  //input records
  input FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_IN_con IN_con
    "Input record for function kc_evenGapTurbulent_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_IN_var IN_var
    "Input record for function kc_evenGapTurbulent_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc
    "Output for function kc_evenGapTurbulentRoughness_KC";

protected
  Real MIN=Modelica.Constants.eps "Limiter";

  SI.Area A_cross=max(MIN, IN_con.s*IN_con.h) "Cross sectional area of gap";
  SI.Diameter d_hyd=2*IN_con.s "Hydraulic diameter";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*A_cross)
    "Mean velocity in gap";
  SI.ReynoldsNumber Re=max(MIN, (IN_var.rho*velocity*d_hyd/max(MIN, IN_var.eta)))
    "Reynolds number";
  SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda))
    "Prandtl number";

  //SOURCE: p.Ga 5, eq. 27
  Real zeta=1/max(MIN, 1.8*Modelica.Math.log10(abs(Re)) - 1.5)^2
    "Pressure loss coefficient";

  //SOURCE: p.Gb 5, eq. 26
  //assumption according to Gb 7, sec. 2.4
  SI.NusseltNumber Nu=abs((zeta/8)*Re*Pr/(1 + 12.7*(zeta/8)^0.5*(Pr^(2/3) - 1))
      *(1 + (d_hyd/max(MIN, IN_con.L))^(2/3)));

  //Documentation
algorithm
  kc := Nu*(IN_var.lambda/max(MIN, d_hyd));

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of the mean convective heat transfer coefficient <b> kc </b> for a developed turbulent fluid flow through an even gap at heat transfer from both sides.
</p>
 
<p>
Generally this function is numerically best used for the calculation of the mean convective heat transfer coefficient <b> kc </b> at known mass flow rate.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> identical and constant wall temperatures</li>
<li> hydraulic diameter per gap lenght (d_hyd / L) &le; 1</li>
<li> 0.5 &le; Prandtl number Pr &le; 100) </li>
<li> turbulent regime (3e4 &le; Reynolds number &le; 1e6) </li>
<li> developed fluid flow</li>    
<li> heat transfer from both sides of the gap (Target = 2) <(li>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/pic_gap.png\">
</p> 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc</b> for an even gap is calculated through the corresponding Nusselt number <b> Nu_turb</b> according to <i> Gnielinski in [VDI 2002, p. Gb 7, sec. 2.4]</i>
 
<pre>
    Nu_turb =(zeta/8)*Re*Pr/{1+12.7*[zeta/8]^(0.5)*[Pr^(2/3) -1]}*{1+[d_hyd/L]^(2/3)}
</pre>
 
<p>
where the pressure loss coefficient <b> zeta </b> according to <i> Konakov in [VDI 2002, p. Ga 5, eq. 27]</i> is determined by
</p>
 
<p>
<pre>
    zeta =  1/[1.8*log10(Re) - 1.5]^2
</pre>
</p>
 
<p>
resulting to the corresponding mean convective heat transfer coefficient <b> kc </b>
</p>
 
<p>
<pre>
    kc =  Nu_turb * lambda / d_hyd
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> cp                      </b></td><td> as specific heat capacity at constant pressure [J/(kg.K)],</td></tr>
<tr><td><b> d_hyd = 2*s             </b></td><td> as hydraulic diameter of gap [m],</td></tr>
<tr><td><b> eta                     </b></td><td> as dynamic viscosity of fluid [Pa.s],</td></tr>
<tr><td><b> h                       </b></td><td> as height of cross sectional area in gap [m],</td></tr>
<tr><td><b> kc                      </b></td><td> as mean convective heat transfer coefficient [W/(m2.K)],</td></tr>
<tr><td><b> lambda                  </b></td><td> as heat conductivity of fluid [W/(m.K)],</td></tr>
<tr><td><b> L                       </b></td><td> as overflowed length of gap (normal to cross sectional area) [m] ,</td></tr>
<tr><td><b> Nu_turb                 </b></td><td> as mean Nusselt number for turbulent regime [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda      </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> rho                     </b></td><td> as fluid density [kg/m3],</td></tr>
<tr><td><b> s                       </b></td><td> as distance between parallel plates of cross sectional area [m],</td></tr>
<tr><td><b> Re = rho*v*d_hyd/eta    </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> v                       </b></td><td> as mean velocity in gap [m/s],</td></tr>
<tr><td><b> zeta                    </b></td><td> as pressure loss coefficient [-].</td></tr>
</table>
</p>
<p>
Note that the fluid flow properties shall be calculated with an arithmetic mean temperature out of the fluid flow temperatures at the entrance and the exit of the gap.
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>  
<p>
The mean Nusselt number <b> Nu_turb </b> representing the mean convective heat transfer coefficient <b> kc </b> at developed turbulent fluid flow and heat transfer from both sides of the gap for Prandtl numbers of different fluids (Target = 2) is shown in the figure below. Here the figures are calculated for an (unintended) inverse calculation, where an unknown mass flow rate is calculated out of a given mean convective heat transfer coefficient <b> kc </b>.
</p>
 
<ul>
   <li> Target 2: Developed fluid flow and heat transfer from both sides of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapTurbulent.png\">
</p>
</ul>
 
 
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulentRoughness\">kc_evenGapTurbulentRoughness</a> is also valid for this inverse calculation due to using the same functions.
 
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
<pre>2016-04-12 Stefan Wischhusen: Limited Re to very small value (Modelica.Constant.eps). </pre>
</html>"));
end kc_evenGapTurbulent_KC;
