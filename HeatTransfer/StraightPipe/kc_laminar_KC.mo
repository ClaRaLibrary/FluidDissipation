within FluidDissipation.HeatTransfer.StraightPipe;
function kc_laminar_KC "Mean heat transfer coefficient of straight pipe | uniform wall temperature or uniform heat flux | hydrodynamically developed or undeveloped laminar flow regime"
  extends Modelica.Icons.Function;
  //input records
  input FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con IN_con "Input record for function kc_laminar_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var IN_var "Input record for function kc_laminar_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Output for function kc_laminar_KC";

protected
  type TYP =
      Modelica.Fluid.Dissipation.Utilities.Types.HeatTransferBoundary;

  Real MIN=Modelica.Constants.eps "Limiter";

  SI.Area A_cross=PI*IN_con.d_hyd^2/4 "Circular cross sectional area";

  Real Nu0=if IN_con.target == TYP.UWTuDFF or IN_con.target == TYP.UWTuUFF then
            0.7 else if IN_con.target == TYP.UHFuDFF or IN_con.target == TYP.UHFuUFF then
            0.6 else 0 "Help variable for mean Nusselt number";
  Real Nu1=if IN_con.target == TYP.UWTuDFF or IN_con.target == TYP.UWTuUFF then
            3.66 else if IN_con.target == TYP.UHFuDFF or IN_con.target == TYP.UHFuUFF then
            4.364 else 0 "Help variable for mean Nusselt number";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*A_cross) "Mean velocity";
  SI.ReynoldsNumber Re=(IN_var.rho*velocity*IN_con.d_hyd/max(MIN,
      IN_var.eta)) "Reynolds number";
  SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda)) "Prandtl number";

  SI.NusseltNumber Nu2=if IN_con.target == TYP.UWTuDFF or IN_con.target == TYP.UWTuUFF then
            1.615*(Re*Pr*IN_con.d_hyd/IN_con.L)^(1/3) else if IN_con.target ==
      TYP.UHFuDFF or IN_con.target == TYP.UHFuUFF then 1.953*(Re*Pr*IN_con.d_hyd
      /IN_con.L)^(1/3) else 0 "Help variable for mean Nusselt number";
  SI.NusseltNumber Nu3=if IN_con.target == TYP.UWTuUFF then (2/(1 + 22*Pr))^(1/
      6)*(Re*Pr*IN_con.d_hyd/IN_con.L)^0.5 else if IN_con.target == TYP.UHFuUFF then
            0.924*(Pr^(1/3))*(Re*IN_con.d_hyd/IN_con.L)^(1/2) else 0 "Help variable for mean Nusselt number";

  SI.NusseltNumber Nu=(Nu1^3 + Nu0^3 + (Nu2 - Nu0)^3 + Nu3^3)^(1/3) "Mean Nusselt number";

  //Documentation
algorithm
  kc := Nu*IN_var.lambda/max(MIN, IN_con.d_hyd);
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of mean convective heat transfer coefficient <b> kc </b> of a straight pipe at an uniform wall temperature <b> or </b> uniform heat flux <b>and</b> for a hydrodynamically developed <b>or</b> undeveloped laminar fluid flow
</p>
 
<p>
Generally this function is numerically best used for the calculation of the mean convective heat transfer coefficient <b> kc </b> at known mass flow rate.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> circular cross sectional area </li>
<li> uniform wall temperature (UWT) <b> or </b> uniform heat flux (UHF) </li>
<li> hydrodynamically developed fluid flow (DFF) <b> or </b> hydrodynamically undeveloped fluid flow (UFF) </li>
<li> 0.6 &le; Prandtl number &le; 1000 </li>
<li> laminar regime (Reynolds number &le; 2000) </li>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>  
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The mean convective heat transfer coefficient <b> kc </b> of a straight pipe in the laminar regime can be calculated for the following four heat transfer boundary conditions through its corresponding Nusselt number <b> Nu </b>:
 
<p>
<b> Uniform wall temperature in developed fluid flow (heatTransferBoundary == UWTuDFF)</b> according to <i>[VDI 2002, p. Ga 2, eq. 6]</i> :
</p>
 
<pre>
    Nu_TD = [3.66^3 + 0.7^3 + {1.615*(Re*Pr*d_hyd/L)^1/3 - 0.7}^3]^1/3 
</pre>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuDFF)</b> according to <i>[VDI 2002, p. Ga 4, eq. 19]</i> :
</p>
 
<pre>
    Nu_qD = [4.364^3 + 0.6^3 + {1.953*(Re*Pr*d_hyd/L)^1/3 - 0.6}^3]^1/3 
</pre>
 
<p>
<b> Uniform wall temperature in undeveloped fluid flow (heatTransferBoundary == UWTuUFF)</b> according to <i>[VDI 2002, p. Ga 2, eq. 12]</i> :
</p>
 
<pre>
    Nu_TU = [3.66^3 + 0.7^3 + {1.615*(Re*Pr*d_hyd/L)^1/3 - 0.7}^3 + {(2/[1+22*Pr])^1/6*(Re*Pr*d_hyd/L)^0.5}^3]^1/3 
</pre>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuUFF)</b> according to <i>[VDI 2002, p. Ga 5, eq. 25]</i> :
</p>
 
<pre>
    Nu_qU = [4.364^3 + 0.6^3 + {1.953*(Re*Pr*d_hyd/L)^1/3 - 0.6}^3 + {0.924*Pr^1/3*[Re*d_hyd/L]^0.5}^3]^1/3.  
</pre>
 
<p>
The corresponding mean convective heat transfer coefficient <b> kc </b> is determined w.r.t. the chosen heat transfer boundary by:
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
<tr><td><b> d_hyd                    </b></td><td> as hydraulic diameter of straight pipe [m],</td></tr>
<tr><td><b> kc                       </b></td><td> as mean convective heat transfer coefficient [W/(m2K)],</td></tr>
<tr><td><b> lambda                   </b></td><td> as heat conductivity of fluid [W/(mK)],</td></tr>
<tr><td><b> L                        </b></td><td> as length of straight pipe [m],</td></tr>
<tr><td><b> Nu = kc*d_hyd/lambda     </b></td><td> as mean Nusselt number [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda       </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> Re = rho*v*d_hyd/eta     </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> v                        </b></td><td> as mean velocity [m/s].</td></tr>
</table>
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> is shown for Prandtl numbers of different fluids in the figures below. Here an inverse calculation of the mass flow rate <b> m_flow </b> out of a given mean Nusselt number <b> Nu </b> is shown. Note that an inverse calculation is not possible below a specific Nusselt number Nu (here Nu is about 5) due to an asymtotic behaviour for mass flow rates going to zero.
 
<p>
<b> Uniform wall temperature in developed fluid flow (heatTransferBoundary == UWTuDFF)</b> :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_laminar_UWTwithDFF_KC.png\">
</p>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuDFF)</b>  :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_laminar_UHFwithDFF_KC.png\">
</p>
 
<p>
<b> Uniform wall temperature in undeveloped fluid flow (heatTransferBoundary == UWTuUFF)</b> :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_laminar_UWTwithUFF_KC.png\" width=600>
</p>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuUFF)</b> :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_laminar_UHFwithUFF_KC.png\" width=600>
</p>
 
<p> 
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_laminar\"> kc_laminar </a> is also valid for this inverse calculation due to using the same functions. 
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
<p>2014-08-05 Stefan Wischhusen: Corrected term for Uniform heat flux in developed fluid flow (Nu3). </p>
<pre>2016-04-12 Stefan Wischhusen: Removed singularity for Re at zero mass flow rate. </pre>
</html>"));
end kc_laminar_KC;
