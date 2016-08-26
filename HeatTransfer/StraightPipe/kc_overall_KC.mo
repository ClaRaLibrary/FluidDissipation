within FluidDissipation.HeatTransfer.StraightPipe;
function kc_overall_KC "Mean heat transfer coefficient of straight pipe | uniform wall temperature or uniform heat flux | hydrodynamically developed or undeveloped overall flow regime| pressure loss dependence"
  extends Modelica.Icons.Function;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con IN_con "Input record for function kc_overall_KC"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var IN_var "Input record for function kc_overall_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Output for function kc_overall_KC";

protected
  Real MIN=Modelica.Constants.eps "Limiter";
  Real laminar=2200 "Maximum Reynolds number for laminar regime";
  Real turbulent=1e4 "Minimum Reynolds number for turbulent regime";

  SI.Area A_cross=PI*IN_con.d_hyd^2/4 "Cross sectional area";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*A_cross) "Mean velocity";
  SI.ReynoldsNumber Re=(IN_var.rho*velocity*IN_con.d_hyd/max(MIN,
      IN_var.eta)) "Reynolds number";
  SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda)) "Prandtl number";

  kc_turbulent_IN_con IN_con_turb(d_hyd=IN_con.d_hyd, L= IN_con.L, roughness = IN_con.roughness, K=IN_con.K) "Constant input parameter record for turbulent flow conditions";
  kc_laminar_IN_con IN_con_lam(d_hyd=IN_con.d_hyd, L= IN_con.L, target=IN_con.target) "Constant input parameter record for laminar flow conditions";

algorithm
  kc := SMOOTH(
    laminar,
    turbulent,
    Re)*FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_KC(IN_con_lam, IN_var)
     + (if Re>2200 then SMOOTH(
    turbulent,
    laminar,
    Re)*FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_KC(IN_con_turb,
    IN_var) else 0);

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of mean convective heat transfer coefficient <b> kc </b> of a straight pipe at an uniform wall temperature <b> or </b> uniform heat flux <b> and </b> for a hydrodynamically developed <b>or</b> undeveloped overall fluid flow with neglect <b> or </b> consideration of pressure loss influence.
</p>
 
<p>
Generally this function is numerically best used for the calculation of the mean convective heat transfer coefficient <b> kc </b> at known mass flow rate.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
<ul>
<li> circular cross sectional area </li>
<li> uniform wall temperature (UWT) <b> or </b> uniform heat flux (UHF) </li>
<li> hydrodynamically developed fluid flow </li>
<li> hydraulic diameter / length &le; 1 </li>
<li> 0.6 &le; Prandtl number &le; 1000 </li>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4> 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>    
 
<h4><font color=\"#EF9B13\">Calculation</font></h4> 
<p>
<b> Laminar regime:</b>
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
<b> Uniform heat flux in undeveloped fluid flow (heatTransferBoundary == UHFuUFF)</b> according to <i>[VDI 2002, p. Ga 5, eq. 25]</i> :
</p>
 
<pre>
    Nu_qU = [4.364^3 + 0.6^3 + {1.953*(Re*Pr*d_hyd/L)^1/3 - 0.6}^3 + {0.924*Pr^1/3*[Re*d_hyd/L]^0.5}^3]^1/3.  
</pre>
 
<p> 
<p>
The <b> transition regime </b> (2e3 &le; Reynolds number &le; 1e4) is calculated via a smoothing interpolation function.
<p>
<p>  
<b> Turbulent regime: </b>
<p>
<b>Neglect pressure loss influence (roughness == Neglected):</b>
</p>
 
The mean convective heat transfer coefficient <b> kc </b> for smooth straight pipes is calculated through its corresponding Nusselt number <b> Nu </b> according to <i> [Dittus and Boelter in Bejan 2003, p. 424, eq. 5.76]</i>
 
<pre>
    Nu = 0.023 * Re^(4/5) * Pr^(1/3).
</pre>
 
<p>
<b>Consider pressure loss influence (roughness == Considered):</b>
</p>
 
<p>
The mean convective heat transfer coefficient <b> kc </b> for rough straight pipes is calculated through its corresponding Nusselt number <b> Nu </b> according to <i>[Gnielinski in VDI 2002, p. Ga 5, eq. 26]</i>
</p>
 
<pre>
    Nu = (zeta/8)*Re*Pr/(1 + 12.7*(zeta/8)^0.5*(Pr^(2/3)-1))*(1+(d_hyd/L)^(2/3)),
</pre>
 
<p>
where the influence of the pressure loss on the heat transfer calculation is considered through
</p>
 
<p>
<pre>
    zeta =  (1.8*log10(Re)-1.5)^-2.
</pre>
</p>
 
<p>
The corresponding mean convective heat transfer coefficient <b> kc </b> results to
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
<tr><td><b> d_hyd                      </b></td><td> as hydraulic diameter of straight pipe [m],</td></tr>
<tr><td><b> kc                         </b></td><td> as mean convective heat transfer coefficient [W/(m2K)],</td></tr>
<tr><td><b> lambda                     </b></td><td> as heat conductivity of fluid [W/(mK)],</td></tr>
<tr><td><b> L                          </b></td><td> as length of straight pipe [m],</td></tr>
<tr><td><b> Nu = kc*d_hyd/lambda       </b></td><td> as mean Nusselt number [-], </td></tr>
<tr><td><b> Pr = eta*cp/lambda         </b></td><td> as Prandtl number [-],</td></tr>
<tr><td><b> Re = rho*v*d_hyd/eta       </b></td><td> as Reynolds number [-],</td></tr>
<tr><td><b> v                          </b></td><td> as mean velocity [m/s],</td></tr>
<tr><td><b> zeta                       </b></td><td> as pressure loss coefficient [-]. </td></tr>
</table>
</p>
 
<p>
Note that there is no significant difference for the calculation of the mean Nusselt number <b> Nu </b> at a uniform wall temperature (UWT) or a uniform heat flux (UHF) as heat transfer boundary in the turbulent regime (Bejan 2003, p.303).
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>
The mean Nusselt number <b> Nu </b> representing the mean convective heat transfer coefficient <b> kc </b> is shown for Prandtl numbers of different fluids in the figures below. Here an inverse calculation of the mass flow rate <b> m_flow </b> out of a given mean Nusselt number <b> Nu </b> is shown.
 
<p>
The following verification considers pressure loss influence (roughness == Considered).
</p>
 
<p>
<b> Uniform wall temperature in developed fluid flow (heatTransferBoundary == UWTuDFF)</b> :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_overall_UWTwithDFF_KC.png\">
</p>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuDFF)</b>  :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_overall_UHFwithDFF_KC.png\">
</p>
 
<p>
<b> Uniform wall temperature in undeveloped fluid flow (heatTransferBoundary == UWTuUFF)</b> :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_overall_UWTwithUFF_KC.png\" width=600>
</p>
 
<p>
<b> Uniform heat flux in developed fluid flow (heatTransferBoundary == UHFuUFF)</b> :
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_straightPipe_kc_overall_UHFwithUFF_KC.png\" width=600>
</p>
 
<p> 
Note that the verification for <a href=\"Modelica://FluidDissipation.HeatTransfer.StraightPipe.kc_overall\"> kc_overall </a> is also valid for this inverse calculation due to using the same functions. 
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
end kc_overall_KC;
