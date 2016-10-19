within FluidDissipation.HeatTransfer.Channel;
function kc_evenGapLaminar_KC
  "Mean heat transfer coefficient of even gap | laminar flow regime | considering boundary layer development | heat transfer at ONE or BOTH sides | identical and constant wall temperatures"
  extends Modelica.Icons.Function;
  //SOURCE: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Gb 6-10

  //input records
  input FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con IN_con
    "Input record for function kc_evenGapLaminar_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var IN_var
    "Input record for function kc_evenGapLaminar_KC"
    annotation (Dialog(group="Variable inputs"));
  //output variables
  output SI.CoefficientOfHeatTransfer kc
    "Output for function kc_evenGapLaminar_KC";

protected
  type TYP = Modelica.Fluid.Dissipation.Utilities.Types.kc_evenGap;

  Real MIN=Modelica.Constants.eps "Limiter";

  SI.Area A_cross=max(MIN, IN_con.s*IN_con.h) "Cross sectional area of gap";
  SI.Diameter d_hyd=2*IN_con.s "Hydraulic diameter";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*A_cross)
    "Mean velocity in gap";
  SI.ReynoldsNumber Re=(IN_var.rho*velocity*d_hyd/max(MIN, IN_var.eta))
    "Reynolds number";
  SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda))
    "Prandtl number";

  //variables for mean Nusselt number
  //SOURCE: p.Gb 7, eq. 36/37
  SI.NusseltNumber Nu_1=if IN_con.target == TYP.DevOne or IN_con.target == TYP.UndevOne then
            4.861 else if IN_con.target == TYP.DevBoth or IN_con.target == TYP.UndevBoth then
            7.541 else 0 "First Nusselt number";
  //SOURCE: p.Gb 7, eq. 38
  SI.NusseltNumber Nu_2=1.841*(Re*Pr*d_hyd/(max(IN_con.L, MIN)))^(1/3)
    "Second Nusselt number";
  //SOURCE: p.Gb 7, eq. 42
  SI.NusseltNumber Nu_3=if IN_con.target == TYP.UndevOne or IN_con.target ==
      TYP.UndevBoth then (2/(1 + 22*Pr))^(1/6)*(Re*Pr*d_hyd/(max(IN_con.L, MIN)))
      ^(0.5) else 0 "Third mean Nusselt number";
  SI.NusseltNumber Nu=((Nu_1)^3 + (Nu_2)^3 + (Nu_3)^3)^(1/3);

  //Documentation
algorithm
  kc := Nu*((IN_var.lambda/max(MIN, d_hyd)));
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of the mean convective heat transfer coefficient <b> kc </b> for a laminar fluid flow through an even gap at different fluid flow and heat transfer situations.
</p> 
 
<p>
Generally this  function is numerically best used for the calculation of the mean convective heat transfer coefficient <b> kc </b> at known mass flow rate.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> laminar regime (Reynolds number &le; 2200) </li>
<li> developed fluid flow</li>
   <ul>
   <li> heat transfer from one side of the gap (target=1) <(li>    
   <li> heat transfer from both sides of the gap (target=2) <(li>
   </ul>
<li> undeveloped fluid flow</li>
   <ul>
   <li> heat transfer from one side of the gap (target=3) <(li>
       <ul>
       <li> Prandtl number 0.1 &le; Pr &le; 10 </li>    
       </ul>
   <li> heat transfer from both sides of the gap (target=4) <(li>
   <ul>
       <li> Prandtl number 0.1 &le; Pr &le; 1000 </li>    
       </ul>
   </ul>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/pic_gap.png\">
</p> 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc</b> for an even gap is calculated through the corresponding Nusselt number <b> Nu_lam</b> according to <i>[VDI 2002, p. Gb 7, eq. 43]</i> :
 
<pre>
    Nu_lam = [(Nu_1)^3 + (Nu_2)^3 + (Nu_3)^3]^(1/3) 
</pre>
 
<p>
with the corresponding mean convective heat transfer coefficient <b> kc </b> :
</p>
 
<p>
<pre>
    kc =  Nu_lam * lambda / d_hyd
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
<tr><td><b> Nu_lam                  </b></td><td> as mean Nusselt number [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda      </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> rho                     </b></td><td> as fluid density [kg/m3],</td></tr>
<tr><td><b> s                       </b></td><td> as distance between parallel plates of cross sectional area [m],</td></tr>
<tr><td><b> Re = rho*v*d_hyd/eta    </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> v                       </b></td><td> as mean velocity in gap [m/s].</td></tr>
</table>
</p>
 
The summands for the mean Nusselt number <b> Nu_lam </b> at a chosen fluid flow and heat transfer situation are calculated as follows:
<ul>
<li> developed fluid flow</li>
   <ul>
   <li> heat transfer from one side of the gap (target=1) <(li> 
        <ul>
            <li> Nu_1 = 4.861 </li>
            <li> Nu_2 = 1.841*(Re*Pr*d_hyd/L)^(1/3) </li>
            <li> Nu_3 = 0 </li>
        </ul>
   <li> heat transfer from both sides of the gap (target=2) <(li>
        <ul>
            <li> Nu_1 = 7.541 </li>
            <li> Nu_2 = 1.841*(Re*Pr*d_hyd/L)^(1/3) </li>
            <li> Nu_3 = 0 </li>
        </ul>
   </ul>
<li> undeveloped fluid flow</li>
   <ul>
   <li> heat transfer from one side of the gap (target=3) <(li>
        <ul>
            <li> Nu_1 = 4.861 </li>
            <li> Nu_2 = 1.841*(Re*Pr*d_hyd/L)^(1/3) </li>
            <li> Nu_3 = [2/(1+22*Pr)]^(1/6)*(Re*Pr*d_hyd/L)^(1/2) </li>
        </ul>      
   <li> heat transfer from both sides of the gap (target=4) <(li>
        <ul>
            <li> Nu_1 = 7.541 </li>
            <li> Nu_2 = 1.841*(Re*Pr*d_hyd/L)^(1/3) </li>
            <li> Nu_3 = [2/(1+22*Pr)]^(1/6)*(Re*Pr*d_hyd/L)^(1/2) </li>
        </ul>
   </ul>
</ul>
<p>
Note that the fluid flow properties shall be calculated with an arithmetic mean temperature out of the fluid flow temperatures at the entrance and the exit of the gap.
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4> 
<p>
The mean Nusselt number <b> Nu_lam </b> representing the mean convective heat transfer coefficient <b> kc </b> in dependence of
the chosen fluid flow and heat transfer situations (targets) is shown in the figure below. 
Here the figures are calculated for an (unintended) inverse calculation, where an unknown mass flow rate is calculated out of a given mean convective heat transfer coefficient <b> kc </b>.  
</p>
 
<ul>
   <li> Target 1: Developed fluid flow and heat transfer from one side of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapLaminar_target1_KC.png\">
</p>
</ul>
 
<ul>
   <li> Target 2: Developed fluid flow and heat transfer from both sides of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapLaminar_target2_KC.png\">
</p>
</ul>
 
<ul>
  <li> Target 3: Undeveloped fluid flow and heat transfer from one side of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapLaminar_target3_KC.png\">
</p>
</ul>
 
<ul>
 <li> Target 4: Undeveloped fluid flow and heat transfer from both sides of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapLaminar_target4_KC.png\">
</p>
</ul>
 
<p> 
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar\">kc_evenGapLaminar</a> is also valid for this inverse calculation due to using the same functions. 
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl> 
<dt>Bejan,A.:</dt> 
    <dd><b>Heat transfer handbook</b>. 
    Wiley, 2003.</dd>
<dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
 
</html>
", revisions="<html>
<pre>2016-04-12 Stefan Wischhusen: Removed singularity for Re at zero mass flow rate. </pre>
</html>"));
end kc_evenGapLaminar_KC;
