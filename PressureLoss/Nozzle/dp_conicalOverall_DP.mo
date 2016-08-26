within FluidDissipation.PressureLoss.Nozzle;
function dp_conicalOverall_DP "Pressure loss of conical nozzles | calculate total pressure loss | overall flow regime | frictional pressure loss of (inlet/outlet) pipe sections"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Nozzle;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_con IN_con "Input record for function dp_conicalOverall_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_var IN_var "Input record for function dp_conicalOverall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP_tot "Total pressure loss considering change in cross sectional area and frictional pressure loss of (inlet/outlet) pipe sections";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd_2=max(MIN, 4*IN_con.A_2/max(MIN, IN_con.C_2)) "Hydraulic diameter of straight pipe after diffuser section";
  SI.Diameter d_hyd_1=max(d_hyd_2, 4*IN_con.A_1/max(MIN, IN_con.C_1)) "Hydraulic diameter of straight pipe before diffuser section";
   SI.Angle alpha=Modelica.Math.atan(min(PI/2, 0.5*max(MIN, abs(d_hyd_1 -
       d_hyd_2))/max(MIN, abs(IN_con.L_trans)))) "Half diffuser diverging angle (0deg< alpha <90deg)";
  SI.Area AR=max(MIN, abs(IN_con.A_2)/max(MIN, IN_con.A_1)) "Diffuser area ratio (Large to small cross sectional area)";
  SI.Angle angle=sin(alpha);
  SI.Velocity velocity_1=abs(m_flow)/max(MIN, IN_var.rho*IN_con.A_1) "Mean velocity in inlet pipe";
  SI.Velocity velocity_2=abs(m_flow)/max(MIN, IN_var.rho*IN_con.A_2) "Mean velocity in outlet pipe";
  SI.ReynoldsNumber Re_1=max(MIN, IN_var.rho*abs(velocity_1)*d_hyd_1/max(MIN,
      IN_var.eta)) "Reynolds number in small cross sectional area";
  // S.W.: abs(velocity_2)
  SI.ReynoldsNumber Re_2=max(MIN, IN_var.rho*abs(velocity_2)*d_hyd_2/max(MIN,
      IN_var.eta)) "Reynolds number in large cross sectional area";

  //Considering frictional pressure loss for pipe sections
  Real k1=max(MIN, abs(IN_con.K)/d_hyd_1) "Relative roughness of inlet pipe";
  Real k2=max(MIN, abs(IN_con.K)/d_hyd_2) "Relative roughness of outlet pipe";
  //SOURCE_1: p.81, fig. 2-3, sec 21-22: definition of flow regime boundaries
  SI.ReynoldsNumber Re_lam_min=1e3 "Minimum Reynolds number for laminar regime in pipes";
  SI.ReynoldsNumber Re_lam_max1=2090*(1/max(0.007, k1))^0.0635 "Maximum Reynolds number for laminar regime of inlet pipe";
  SI.ReynoldsNumber Re_lam_max2=2090*(1/max(0.007, k2))^0.0635 "Maximum Reynolds number for laminar regime of outlet pipe";
  SI.ReynoldsNumber Re_turb_min=4e3 "Minimum Reynolds number for turbulent regime in pipes";
  SI.ReynoldsNumber Re_lam_leave1=min(Re_lam_max1, max(Re_lam_min, 754*
      Modelica.Math.exp(if k1 <= 0.007 then 0.0065/0.007 else 0.0065/k1)));
  SI.ReynoldsNumber Re_lam_leave2=min(Re_lam_max2, max(Re_lam_min, 754*
      Modelica.Math.exp(if k2 <= 0.007 then 0.0065/0.007 else 0.0065/k2)));
  //SOURCE_2: p.132, eq. 8.4: Considering Darcy friction factor for turbulent regime
  TYP.DarcyFrictionFactor lambda_fri_tur1=0.25/(Modelica.Math.log10(k1/3.7 +
      5.74/max(Re_lam_leave1, Re_1)^0.9))^2;
  TYP.DarcyFrictionFactor lambda_fri_tur2=0.25/(Modelica.Math.log10(k2/3.7 +
      5.74/max(Re_lam_leave2, Re_2)^0.9))^2;
  TYP.DarcyFrictionFactor lambda_fri_1=SMOOTH(
      Re_lam_leave1,
      Re_turb_min,
      Re_1)*64/Re_1 + SMOOTH(
      Re_turb_min,
      Re_lam_leave1,
      Re_1)*lambda_fri_tur1 "Darcy friction factor for inlet pipe";
  TYP.DarcyFrictionFactor lambda_fri_2=SMOOTH(
      Re_lam_leave2,
      Re_turb_min,
      Re_2)*64/Re_2 + SMOOTH(
      Re_turb_min,
      Re_lam_leave1,
      Re_2)*lambda_fri_tur2 "Darcy friction factor for outlet pipe";
  TYP.FrictionalResistanceCoefficient zeta_fri_1=lambda_fri_1*IN_con.L_1/
      d_hyd_1 "Frictional pressure loss for inlet pipe";
  TYP.FrictionalResistanceCoefficient zeta_fri_2=lambda_fri_2*IN_con.L_2/
      d_hyd_2 "Frictional pressure loss for outlet pipe";

  //SOURCE_1: p.318, Diag. 5-24: Considering total pressure loss of transition section for laminar regime
  //Restriction: 5deg< alpha <= 40deg, Re<= 50
  Real A=20.5/sqrt(AR)/(tan(min(Modelica.Constants.pi/4,2*alpha)))^0.75;

  //SOURCE_1: p.318: Considering dependence of area ratio on resistance coefficient for laminar regime
  TYP.LocalResistanceCoefficient zeta_tot_lam=zeta_fri_1*AR^2 + A/Re_2 +
      zeta_fri_2 "Local resistance coefficient for laminar regime of diffuser section";

  //SOURCE_1: p.316, Diag. 5-23: Considering local pressure loss of nozzle section for turbulent regime (Re>=1e5)
  TYP.LocalResistanceCoefficient zeta_loc_tur=(-0.0125*AR^4 + 0.0224*AR^3 -
      0.00723*AR^2 + 0.00444*AR - 0.00745)*((2*alpha)^3 - 2*PI*(2*alpha)^2 - 10
      *(2*alpha)) "Local resistance coefficient for turbulent regime of nozzle section";

  //SOURCE_1: p.318: Considering restriction for laminar regime
  SI.ReynoldsNumber Re_min_trans=50 "Minimum Reynolds number for laminar regime in nozzle section";
  SI.ReynoldsNumber Re_max_trans=100 "Maximum Reynolds number for laminar regime in nozzle section";

 //SOURCE_1: p.250, sec. 38: Considering frictional pressure loss of conical nozzle section for turbulent regime
  Real x_bar=IN_con.L_trans/d_hyd_2 "Characteristic length of nozzle";
  Real x_tilde=Modelica.Math.log(1 + 2*x_bar*tan(alpha))/(2*tan(alpha)) "Mean characteristic length of conical nozzle";
  TYP.DarcyFrictionFactor lambda_fri_trans=lambda_fri_2 "Mean Darcy friction factor for conical nozzle section";
  TYP.FrictionalResistanceCoefficient zeta_fri_trans=(1 + 0.5/1.5^x_tilde)*
    lambda_fri_trans*(1 - AR^2)/(8*angle);
   TYP.FrictionalResistanceCoefficient zeta_tot_tur=zeta_fri_1*AR^2 + (
       zeta_loc_tur + zeta_fri_trans) + zeta_fri_2 "Total resistance coefficient for turbulent regime";

   TYP.LocalResistanceCoefficient zeta_tot_smooth=SMOOTH(
       Re_min_trans,
       Re_max_trans,
       Re_2)*zeta_tot_lam + SMOOTH(
       Re_max_trans,
       Re_min_trans,
       Re_2)*zeta_tot_tur "Local resistance coefficient for overall regime of nozzle section";

  //SOURCE_1: p.258, sec. 57: Considering maximum Reynolds number for laminar regime in nozzle section
  //SI.ReynoldsNumber Re_lam_noz_max=200;*/
   TYP.PressureLossCoefficient zeta_tot=min(IN_con.zeta_tot_max, max(IN_con.zeta_tot_min,
       zeta_tot_smooth));

  //Documentation
algorithm
  DP_tot := zeta_tot*(IN_var.rho/2)*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    velocity_2,
    IN_con.velocity_small,
    2) "Total pressure loss considering change in cross sectional area and frictional pressure loss of (inlet/outlet) pipe sections";
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of pressure loss in a conical nozzle with circular cross sectional area at overall flow regime for an incompressible and single-phase fluid flow.
</p>
 
<p>
Generally this function is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding (total) pressure loss (dp_tot) has to be calculated.
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> usage of total pressure loss neglecting geodetic pressure difference </b>
 </li>
 <li>
      <b> ensure design flow direction from large to small cross sectional area </b>
 </li>
 <li>
      <b> circular cross sectional area </b>
 </li>
 <li>
      <b> fully developed fluid flow </b>
 </li>
 <li>
      <b> uniform velocity profile at inlet section of nozzle </b>
 </li>
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/nozzle/pic_conicalNozzle.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The total pressure loss <b>(dp_tot)</b> for nozzles is determined by:
<p>
<pre>
    dp_tot = zeta_tot * (rho/2) * velocity_2^2 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_tot         </b></td><td> as total pressure loss [Pa],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity_2     </b></td><td> as mean velocity at outlet section [m/s],</td></tr>
<tr><td><b> zeta_tot       </b></td><td> as total pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
Please note that the total pressure loss <b>(dp_tot)</b> instead of a static pressure difference <b>(dp_sta)</b> has to be calculated due to a changing cross sectional area of a nozzle. For a continuous decrease in cross sectional area, there is a increase in fluid flow velocity and a corresponding decrease in static pressure due to the law of Bernoulli.
For a reversible fluid flow of a nozzle, the decrease in static pressure is completely converted from the increase of dynamic pressure difference <b>(dp_dyn)</b>. In practice, this reversible static pressure difference is always reduced by irreversible local effects like the creation of vortices due to friction.
Therefore the total pressure loss coefficient <b>(zeta_tot)</b>, describing the total pressure difference <b>(dp_tot)</b> as driving potential for the direction of the mass flow rate in a nozzle, is calculated by the law of Bernoulli for an irreversible and incompressible fluid flow as follows:
</p>
<p>
<pre>
    p_stat_1 + (rho/2)*velocity_1^2 = p_stat_2 + (rho/2)*velocity_2^2 + zeta_fri_1*(rho/2)*velocity_1^2 + (zeta_loc + zeta_fri_trans)*(rho/2)*velocity_2^2 + zeta_fri_2*(rho/2)*velocity_2^2  (Eq.1)
</pre>
</p>

<p>
where the frictional pressure loss coefficient of an inlet pipe before and an outlet pipe after the nozzle section is calculated with:
</p>
<p>
<pre>
    zeta_fri_1 = lambda_fri_1*(L_1/d_hyd_1)
    zeta_fri_2 = lambda_fri_2*(L_2/d_hyd_2)
</pre>
</p>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> 1                                </b></td><td> as nozzle inlet [-],</td></tr>
<tr><td><b> 2                                </b></td><td> as nozzle outlet [-],</td></tr>
<tr><td><b> dp_dyn                           </b></td><td> as dynamic pressure difference [Pa],</td></tr>
<tr><td><b> dp_sta </b> = p_sta_2 - p_sta_1      </td><td> as static pressure difference [Pa],</td></tr>
<tr><td><b> dp_tot </b> = p_tot_1 - p_tot_2      </td><td> as total pressure loss [Pa],</td></tr>
<tr><td><b> trans                               </b></td><td> as nozzle section [-],</td></tr>
<tr><td><b> d_hyd                            </b></td><td> as hydraulic diameter of pipes [m],</td></tr>
<tr><td><b> lambda_fri                       </b></td><td> as Darcy friction factor [-],</td></tr>
<tr><td><b> L                                </b></td><td> as length of pipe sections [m],</td></tr>
<tr><td><b> p_dyn </b> = (rho/2)*velocity^2      </td><td> as dynamic pressure [Pa],</td></tr>
<tr><td><b> p_sta</b>                            </td><td> as static pressure [Pa],</td></tr>
<tr><td><b> p_tot </b> =  p_sta + p_dyn          </td><td> as total pressure [Pa],</td></tr>
<tr><td><b> zeta_fri</b>                         </td><td> as frictional resistance coefficient of pipe sections [-],</td></tr>
<tr><td><b> zeta_loc</b>                         </td><td> as (irreversible) local resistance coefficient [-].</td></tr>
</table>
</p>

<p>
For engineering calculations with an irreversible fluid flow in a nozzle considering local and frictional pressure losses the total resistance coefficient of a converging nozzle is represented as:
</p>
<p>
<pre>
    zeta_tot = zeta_loc + zeta_fri  (Eq.2)
</pre>
</p>

<p>
The general friction resistance coeffcient <b>(zeta_fri)</b> of a converging nozzle with rectilinear boundaries can be defined from Eq.1 to:
</p>
<p>
<pre>
    zeta_fri = zeta_fri_1*AR^2 + zeta_loc + zeta_fri_trans + zeta_fri_2     (Eq.3) 
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> 1                                </b></td><td> as nozzle inlet [-],</td></tr>
<tr><td><b> 2                                </b></td><td> as nozzle outlet [-],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2     </td><td> as area ratio of nozzle [-],</td></tr>
<tr><td><b> trans                                </b></td><td> as nozzle transition section [-],</td></tr>
<tr><td><b> d_hyd                                </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> zeta_fri</b>                         </td><td> as frictional resistance coefficient of pipe sections [-],</td></tr>
<tr><td><b> zeta_loc</b>                         </td><td> as (irreversible) local resistance coefficient [-],</td></tr>
<tr><td><b> zeta_tot                         </b></td><td> as total pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
<b>Laminar regime</b> (Re &le; 50):
</p>
<p>
The (irreversible) local resistance coefficient of a contracting section for the laminar regime <b>(zeta_loc_lam)</b> is calculated according to <i>[Idelchik 2006, p. 318, diag. 5-24]</i>:
</p>
<p>
<pre>
    zeta_loc_lam = A/Re_2 
</pre>
</p>

<p>
where the quantity A is a function of the angle and the area ratio 
</p>
<p>
<pre>
    A = 20.5/(AR^0.5*(tan(2 * alpha))^0.75) 
</pre>
</p>
<p>
and with
</p>
<p>
<table>
<tr><td><b> alpha                                      </b></td><td> as half nozzle angle (2.5*&#x3C0;/180 &lt; alpha &lt; 20*&#x3C0;/180) [rad],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2           </td><td> as area ratio of nozzle [-],</td></tr>
<tr><td><b> d_hyd                                      </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> Re_2</b>                                   </td><td> as Reynolds number at outlet of nozzle [-],</td></tr>
<tr><td><b> zeta_loc_lam</b>                           </td><td> as (irreversible) local pressure loss coefficient in laminar regime [-].</td></tr>
</table>
</p>

<p>
<b>Turbulent regime</b> (Re &ge; 10^5):
</p>
<p>
The (irreversible) local resistance coefficient of a contracting section for the turbulent regime <b>(zeta_loc_tur)</b> is calculated according to <i>[Idelchik 2006, p. 316, diag. 5-23]</i>:
</p>
<p>
<pre>
    zeta_loc_tur = (-0.0125 * AR^4 + 0.0224 * AR^3 - 0.00723 * AR^2 + 0.00444 * AR - 0.00745) * ((2*angle)^3 - 2*PI*(2*angle)^2 - 10*(2*angle))
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> alpha                                </b></td><td> as half nozzle angle (0 &lt; alpha &lt; 90*&#x3C0;/180) [rad],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2     </td><td> as area ratio of nozzle [-],</td></tr>
<tr><td><b> d_hyd                                </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> zeta_loc_tur</b>                     </td><td> as (irreversible) local pressure loss coefficient in turbulent regime [-].</td></tr>
</table>
</p>

<p>
The frictional resistance coefficient of a contracting section for the turbulent regime <b>(zeta_fri_trans)</b> is calculated according to <i>[Idelchik 2006, p. 250, eq. 5-6]</i>:
</p>
<p>
<pre>
    zeta_fri_trans = (1 + 0.5/1.5^x_tilde) * lambda_fri_trans * (1 - AR^2) / [8 *sin(alpha)]
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> alpha                                </b></td><td> as half nozzle angle (0 &lt; alpha &lt; 90*&#x3C0;/180) [rad],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2     </td><td> as area ratio of nozzle [-],</td></tr>
<tr><td><b> d_hyd                                </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> lambda_fri_trans                     </b></td><td> as Darcy friction factor of nozzle section [-],</td></tr>
<tr><td><b> x_tilde</b>= f(Geometry)             </td><td> as relative length of nozzle [-],</td></tr>
</table>
</p>

<p>
Please note that the Darcy friction factor for the conical nozzle section <b>(lambda_fri_trans)</b> is calculated from the outlet pipe sections.
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>      
<p>
The local resistance coefficient <b>(zeta_loc)</b> of a conical nozzle in dependence of the outlet Reynolds number <b>(Re_2)</b> for different half 
nozzle contraction angles <b>(alpha)</b> is shown for the laminar regime in the figure below. (AR = 0.5, L_1/d_hyd_1 = 0 and L_2/d_hyd_2 = 0)
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/nozzle/fig_nozzle_dp_conical_DP_zetaLocVsRelamWrtAlpha.png\">
</p>
<p>
The quantity A is a function of the angle and the area ratio. For given values of an angle and an area ratio of a nozzle there is only a dependence 
of the outlet Reynolds number due to that quantity A is constant. There is an exact match in the validation due to the fact that frictional pressure
 loss of an inlet or outlet pipe connected to the nozzle section is neglected here. 
</p>

<p>
The total pressure loss <b>(zeta_tot)</b> of a conical nozzle in dependence of the outlet Reynolds number <b>(Re_2)</b> for different half nozzle 
contraction angles <b>(alpha)</b> is shown for the overall regime in the figure below.
The frictional pressure loss of an inlet or outlet pipe connected to the nozzle section is neglected here. (AR = 0.5, L_1/d_hyd_1 = 0 and L_2/d_hyd_2 = 0).</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/nozzle/fig_nozzle_dp_conical_DP_zetaTotVsReturbWrtAlpha.png\">
</p>

<p>
The total pressure loss <b>(zeta_tot)</b> of a conical nozzle in dependence of the half nozzle contraction angle for different outlet Reynolds 
number <b>(Re_2)</b> is shown for the turbulent regime in the figure below. The frictional pressure loss of an inlet or outlet pipe connected 
to the nozzle section is neglected here. (AR = 0.5, L_1/d_hyd_1 = 0 and L_2/d_hyd_2 = 0)
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/nozzle/fig_nozzle_zetaTotVsAlphaWrtRe.png\">
</p>
<p>
There is a slight difference in the validation at half nozzle contraction angle within the limits 10&deg; &lt; alpha &lt; 20&deg; due to the fact that for the 
turbulent regime the resistance coefficient of a nozzle with rectilinear boundaries has a minimum which remains approximately constant value equal 
to zeta_tot &#x2248; 0.05. The dependence of the total pressure loss coefficient <b>(zeta_tot)</b> on the Reynolds number <b>(Re)</b> can be 
neglected compared to the influence of the half nozzle contraction angle <b>(alpha)</b>. At large half nozzle contraction angles alpha &gt; 20&deg; 
the difference in the validation increase due to the correlations function of the local resistance coefficient <b>(zeta_loc)</b>. Constant values for the 
total pressure loss <b>(zeta_tot)</b> result at half nozzle contraction angles alpha &gt; 57.5&deg; and AR = 0.5 for the turbulent regime. 
</p>

<p>
The total pressure loss <b>(dp_tot)</b> of a conical nozzle in dependence of the mass flow rate of air for different half nozzle contraction angles <b>(alpha)</b> 
in the overall flow regime is shown in the figure below. The shown total pressure loss also considers frictional pressure loss of pipes at the inlet and the outlet 
of the nozzle. The area ratio <b>(AR)</b> has been kept constant, so that there is a decrease in the length of the nozzle section <b>(L_trans)</b> with increasing 
half nozzle contraction angles <b>(alpha)</b>.  
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/nozzle/fig_nozzle_dpTotVsMflowWrtAlpha.png\">
</p>
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
<dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984.
</html>
"));
end dp_conicalOverall_DP;
