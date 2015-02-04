within FluidDissipation.HeatTransfer.Channel;
function kc_evenGapOverall_KC
  "Mean heat transfer coefficient of even gap | overall flow regime | considering boundary layer development | heat transfer at ONE or BOTH sides | identical and constant wall temperatures | surface roughness"
  extends Modelica.Icons.Function;
  //SOURCE: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002, Section Gb 6-10

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con IN_con
    "Input record for function kc_evenGapOverall_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_var IN_var
    "Input record for function kc_evenGapOverall_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc
    "Output for function kc_evenGapOverall_KC";

protected
  Real MIN=Modelica.Constants.eps;

  Real laminar=2200 "Maximum Reynolds number for laminar regime";
  Real turbulent=1e4 "Minimum Reynolds number for turbulent regime";

  SI.Area A_cross=max(MIN, IN_con.s*IN_con.h) "Cross sectional area of gap";
  SI.Diameter d_hyd=2*IN_con.s "Hydraulic diameter";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*A_cross)
    "Mean velocity in gap";
  SI.ReynoldsNumber Re=max(1, IN_var.rho*velocity*d_hyd/max(MIN, IN_var.eta));
  SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda));

  kc_evenGapTurbulent_IN_con IN_con_turb(h=IN_con.h,s=IN_con.s,L=IN_con.L);

algorithm
  kc := SMOOTH(
    laminar,
    turbulent,
    Re)*FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC(IN_con,
    IN_var) + SMOOTH(
    turbulent,
    laminar,
    Re)*FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_KC(IN_con_turb,
    IN_var);
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of the mean convective heat transfer coefficient <b> kc </b> for an overall fluid flow through an even gap at different fluid flow and heat transfer situations.
</p>
 
<p>
Generally this function is numerically best used for the calculation of the mean convective heat transfer coefficient <b> kc </b> at known mass flow rate.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
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
<li> turbulent regime always calculated for developed fluid flow and heat transfer from both sides of the gap (target=2)</li>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/pic_gap.png\">
</p> 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc</b> for an even gap is calculated through the corresponding Nusselt number <b> Nu </b> according to <i>[VDI 2002, p. Gb 6-7]</i> :
 
<pre>
    Nu_lam = [(Nu_1)^3 + (Nu_2)^3 + (Nu_3)^3]^(1/3),
    Nu_turb =(zeta/8)*Re*Pr/{1+12.7*[zeta/8]^(0.5)*[Pr^(2/3) -1]}*{1+[d_hyd/L]^(2/3)},
    Nu = f(Nu_lam,Nu_turb) 
</pre>
 
<p>
with the corresponding mean convective heat transfer coefficient <b> kc </b> :
</p>
 
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
<tr><td><b> cp                      </b></td><td> as specific heat capacity at constant pressure [J/(kg.K)],</td></tr>
<tr><td><b> d_hyd = 2*s             </b></td><td> as hydraulic diameter of gap [m],</td></tr>
<tr><td><b> eta                     </b></td><td> as dynamic viscosity of fluid [Pa.s],</td></tr>
<tr><td><b> h                       </b></td><td> as height of cross sectional area in gap [m],</td></tr>
<tr><td><b> kc                      </b></td><td> as mean convective heat transfer coefficient [W/(m2.K)],</td></tr>
<tr><td><b> lambda                  </b></td><td> as heat conductivity of fluid [W/(m.K)],</td></tr>
<tr><td><b> L                       </b></td><td> as overflowed length of gap (normal to cross sectional area) [m] ,</td></tr>
<tr><td><b> Nu_lam                  </b></td><td> as mean Nusselt number for laminar regime [-], </td></tr>
<tr><td><b> Nu_turb                 </b></td><td> as mean Nusselt number for turbulent regime [-], </td></tr>
<tr><td><b> Nu                      </b></td><td> as mean Nusselt number for overall regime [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda      </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> rho                     </b></td><td> as fluid density [kg/m3],</td></tr>
<tr><td><b> s                       </b></td><td> as distance between parallel plates of cross sectional area [m],</td></tr>
<tr><td><b> Re = rho*v*d_hyd/eta    </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> v                       </b></td><td> as mean velocity in gap [m/s].</td></tr>
</table>
</p>
 
The summands for the mean Nusselt number in the laminar regime <b> Nu_lam </b> at a chosen fluid flow and heat transfer situation are calculated as follows:
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
The Nusselt number in the turbulent regime <b> Nu_turb </b> is calculated according to <i> Gnielinski in [VDI 2002, p. Gb 7, sec. 2.4]</i>
</p>
<pre>
    Nu_turb =(zeta/8)*Re*Pr/{1+12.7*[zeta/8]^(0.5)*[Pr^(2/3) -1]}*{1+[d_hyd/L]^(2/3)}
</pre>
 
<p>
where the pressure loss coefficient <b> zeta </b> according to <i> Konakov in [VDI 2002, p. Ga 5, eq. 27]</i> is determined by
</p>
 
<p>
<pre>
    zeta =  1/[1.8*log10(Re) - 1.5]^2.
</pre>
</p> 
 
<p> 
Note that the fluid flow properties shall be calculated with an arithmetic mean temperature out of the fluid flow temperatures at the entrance and the exit of the gap.
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4> 
 
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> for Prandtl numbers of different fluids in dependence of
the chosen fluid flow and heat transfer situations (targets) is shown in the figures below. Here the figures are calculated for an (unintended) inverse calculation, where an unknown mass flow rate is calculated out of a given mean convective heat transfer coefficient <b> kc </b>.
</p>
 
<ul>
   <li> Target 1: Developed fluid flow and heat transfer from one side of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapOverall_target1_KC.png\">
</p>
</ul>
 
<ul>
   <li> Target 2: Developed fluid flow and heat transfer from both sides of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapOverall_target2_KC.png\">
</p>
</ul>
 
<ul>
  <li> Target 3: Undeveloped fluid flow and heat transfer from one side of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapOverall_target3_KC.png\">
</p>
</ul>
 
<ul>
 <li> Target 4: Undeveloped fluid flow and heat transfer from both sides of the gap <(li>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/channel/fig_channel_kc_evenGapOverall_target4_KC.png\">
</p>
</ul>
 
<p>
Note that the heat transfer in the turbulent regime of a gap for a developed fluid flow and heat transfer from both sides of the gap (target = 2) can be calculated with the correlations of a straight pipe. In doing so the hydraulic diameter of the gap (d_hyd = 2*s) has to be used for the heat transfer correlation instead of the hydraulic diameter of the straight pipe. All calculations of different targets use this assumption for the turbulent regime. 
</p> 
 
<p>
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall\">kc_evenGapOverall</a> is also valid for this inverse calculation due to using the same functions.
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl> 
<dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 9th edition, 2002.</dd>
</dl>
 
</html>
"));
end kc_evenGapOverall_KC;
