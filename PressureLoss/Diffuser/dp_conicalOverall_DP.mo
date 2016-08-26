within FluidDissipation.PressureLoss.Diffuser;
function dp_conicalOverall_DP "Pressure loss of conical diffuser | calculate total pressure loss | overall flow regime | frictional pressure loss of (inlet/outlet) pipe sections"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 2nd edition, 1984.
  //SOURCE_3: Rosa, S. and Pinho, F.: Pressure drop coefficient of laminar Newtonian flow in axisymmetric diffusers, International Journal of Heat and Fluid Flow , 2006, 319-328.
  //SOURCE_4: Oliveira,P.J and Pinho, F.T: Pressure drop coefficient of laminar Newtonian flow in axisysmmetric sudden expansions, International Journal of Heat and Fluid Flow , 1997, 518-529.
  //Notation of equations according to SOURCES

  import FD = FluidDissipation.PressureLoss.Diffuser;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Diffuser.dp_conicalOverall_IN_con IN_con "Input record for function dp_conicalOverall_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Diffuser.dp_conicalOverall_IN_var IN_var "Input record for function dp_conicalOverall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP_tot "Total pressure loss considering change in cross sectional area and frictional pressure loss of (inlet/outlet) pipe sections";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Diameter d_hyd_1=4*abs(IN_con.A_1)/max(MIN, abs(IN_con.C_1)) "Hydraulic diameter in small cross sectional area";
  SI.Diameter d_hyd_2=max(d_hyd_1, 4*abs(IN_con.A_2)/max(MIN, abs(IN_con.C_2))) "Hydraulic diameter in large cross sectional area";
  //SI.Angle alpha = PI*0.01;
  SI.Angle alpha=Modelica.Math.atan(min(PI/2, 0.5*(d_hyd_2 - d_hyd_1)/max(MIN,
      abs(IN_con.L_d)))) "Half diffuser diverging angle (0 < alpha < Pi/2)";
  /*SI.Angle alpha= Modelica.Math.atan(min(PI/2,0.5*(IN_con.A_2 - IN_con.A_1)/max(MIN,abs(IN_con.L_d)))) 
    "Half diffuser diverging angle (0 < alpha < Pi/2)";*/
  SI.Angle angle=sin(alpha);
  SI.Area AR=max(MIN, abs(IN_con.A_2)/max(MIN, abs(IN_con.A_1))) "Diffuser area ratio (Large to small cross sectional area)";
  SI.Velocity velocity_1=abs(m_flow)/max(MIN, abs(IN_var.rho)*abs(IN_con.A_1)) "Mean velocity in inlet pipe";
  SI.Velocity velocity_2=abs(m_flow)/max(MIN, abs(IN_var.rho)*abs(IN_con.A_2)) "Mean velocity in outlet pipe";
  SI.ReynoldsNumber Re_1=max(MIN, IN_var.rho*velocity_1*d_hyd_1/max(MIN, abs(
      IN_var.eta))) "Reynolds number in small cross sectional area";
  SI.ReynoldsNumber Re_2=max(MIN, IN_var.rho*velocity_2*d_hyd_2/max(MIN, abs(
      IN_var.eta))) "Reynolds number in large cross sectional area";

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
  //SOURCE_3: p.327, eq. 17: Considering local pressure loss of diffuser section for laminar regime
  //Restriction: 0deg< alpha < 90deg, d_hyd_2/d_hyd_1 = 1.5 or d_hyd_2/d_hyd_1 = 2

  Real CT1[16]={11.1,81.6,-213,180,-52.6,3.01,-75.8,196,-166,50,-3.13,17.7,-45.4,
      38.5,-11.86,0.851} "Coefficients for d_hyd_2/d_hyd_1 = 1.5";
  /*Real CT2[16]={16.4,202,-559,550,-217,21.9,-173,470,-456,179,-18.3,37.1,-99.6,96,
      -37.8,4.06} "Coefficients for d_hyd_2/d_hyd_1 = 2";*/
  Real C1=CT1[1]*(max(MIN, angle))^(-0.824)/max(MIN, Re_1^(-2.23*angle^3 + 2.98*angle^2 -
      0.874*angle + 1.04)) + CT1[2]*angle^4 + CT1[3]*angle^3 + CT1[4]*angle^2
       + CT1[5]*angle + CT1[6] + (CT1[7]*angle^4 + CT1[8]*angle^3 + CT1[9]*
      angle^2 + CT1[10]*angle + CT1[11])*Modelica.Math.log10(Re_1) + (CT1[12]*
      angle^4 + CT1[13]*angle^3 + CT1[14]*angle^2 + CT1[15]*angle + CT1[16])*(
      Modelica.Math.log10(Re_1))^2 "d_hyd_2 / d_hyd_1 = 1.5";
  /*Real C2=CT2[1]*angle^(-0.703)/max(MIN, Re^(-1.54*angle^3 + 3.33*angle^2 - 2.24
      *angle + 1.24)) + CT2[2]*angle^4 + CT2[3]*angle^3 + CT2[4]*angle^2 + CT2[5]
      *angle + CT2[6] + (CT2[7]*angle^4 + CT2[8]*angle^3 + CT2[9]*angle^2 + CT2
      [10]*angle + CT2[11])*Modelica.Math.log10(Re_1) + (CT2[12]*angle^4 + CT2[13]
      *angle^3 + CT2[14]*angle^2 + CT2[15]*angle + CT2[16])*(
      Modelica.Math.log10(Re_1))^2 "d_hyd_2 / d_hyd_1 = 2";*/
  //SOURCE_4: p.528: Considering dependence of area ratio on local resistance coefficient for laminar regime
  TYP.LocalResistanceCoefficient zeta_loc_lam=C1*(1 - 1/AR)/max(MIN, 1 - 1/1.5^
      2) "Local resistance coefficient for laminar regime of diffuser section";
  //SOURCE_1: p.299, diag. 5-7: Considering laminar regime
  //Restriction: 0deg< alpha < 45deg, d_hyd_2/d_hyd_1 = not restricted
  /*TYP.LocalResistanceCoefficient zeta_loc_lam_1=(20*AR^0.33/(tan(alpha))^0.75)/
      max(1, Re_1) "Laminar regime (0deg< alpha < 45deg)";*/

  //SOURCE_1: p.251, eq. 5-7: Considering local pressure loss of diffuser section for turbulent regime
  //SOURCE_1: p.293, diag. 5-4: Considering shock coefficient
  Real phi=0.9455*(1 - exp(-0.0541*2*alpha*180/PI)) "Shock coefficient";
  Real exp_phi=1.92 "Geometry exponent for shock losses (here: conical diffuser)";

  TYP.LocalResistanceCoefficient zeta_loc_tur=phi*(1 - 1/AR)^exp_phi "Local resistance coefficient for turbulent regime of diffuser section";

  //SOURCE_3: p.319: Considering restriction for laminar regime

  SI.ReynoldsNumber Re_min_d=180 "Minimum Reynolds number for laminar regime in diffuser section";
  SI.ReynoldsNumber Re_max_d=220 "Maximum Reynolds number for laminar regime in diffuser section";
  TYP.LocalResistanceCoefficient zeta_loc_d=SMOOTH(
      Re_min_d,
      Re_max_d,
      Re_1)*zeta_loc_lam + SMOOTH(
      Re_max_d,
      Re_min_d,
      Re_1)*zeta_loc_tur "Local resistance coefficient for overall regime of diffuser section";

  //SOURCE_1: p.250, sec. 38: Considering frictional pressure loss of conical diffuser section for turbulent regime
  Real x_bar=IN_con.L_d/d_hyd_1 "Characteristic length of diffuser";
  Real x_tilde=Modelica.Math.log(1 + 2*x_bar*tan(alpha))/(2*tan(alpha)) "Mean characteristic length of conical diffuser";
  TYP.DarcyFrictionFactor lambda_fri_d=(lambda_fri_1 + lambda_fri_2)/2 "Mean Darcy friction factor for conical diffuser section";

  TYP.FrictionalResistanceCoefficient zeta_fri_d=(1 + 0.5/1.5^x_tilde)*
      lambda_fri_d*(1 - 1/AR^2)/(8*angle);

  //SOURCE_1: p.258, sec. 57: Considering maximum Reynolds number for laminar regime in diffuser section
  //SI.ReynoldsNumber Re_lam_dif_max=200;*/

  TYP.PressureLossCoefficient zeta_tot=min(IN_con.zeta_tot_max, max(IN_con.zeta_tot_min,
      zeta_fri_1 + (zeta_loc_d + zeta_fri_d) + zeta_fri_2*(1/AR^2)));

  //Documentation
algorithm
  //DP_tot := IN_con.L_d;
  DP_tot := zeta_tot*(IN_var.rho/2)*
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    velocity_1,
    IN_con.velocity_small,
    2) "Total pressure loss considering change in cross sectional area and frictional pressure loss of (inlet/outlet) pipe sections";
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of pressure loss in a conical diffuser with circular cross sectional area at overall flow regime for an incompressible and single-phase fluid flow.
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
      <b> ensure design flow direction from small to large cross sectional area [uncorrect calculation for reverse flow (nozzle)] </b>
 </li>
 <li>
      <b> circular cross sectional area </b>
 </li>
 <li>
      <b> fully developed fluid flow </b>
 </li>
 <li>
      <b> uniform velocity profile at inlet section of diffuser </b>
 </li>
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/diffuser/pic_conicalDiffuser.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The total pressure loss <b>(dp_tot)</b> for diffusers is determined by:
<p>
<pre>
    dp_tot = zeta_tot * (rho/2) * velocity_1^2 
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_tot         </b></td><td> as total pressure loss [Pa],</td></tr>
<tr><td><b> rho            </b></td><td> as density of fluid [kg/m3],</td></tr>
<tr><td><b> velocity_1     </b></td><td> as mean velocity at inlet section [m/s],</td></tr>
<tr><td><b> zeta_tot       </b></td><td> as total pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
Please note that the total pressure loss <b>(dp_tot)</b> instead of a static pressure difference <b>(dp_sta)</b> has to be calculated due to a changing cross sectional area of a diffuser. For a continuous increase in cross sectional area, there is a decrease in fluid flow velocity and a corresponding increase in static pressure due to the law of Bernoulli.
For a reversible fluid flow of a diffuser, the increase in static pressure is completely converted from the decrease of dynamic pressure difference <b>(dp_dyn)</b>. In practice, this reversible static pressure difference is always reduced by irreversible local effects like the creation of vortices due to friction.
Therefore the total pressure loss coefficient <b>(zeta_tot)</b>, describing the total pressure difference <b>(dp_tot)</b> as driving potential for the direction of the mass flow rate in a diffuser, is calculated by the law of Bernoulli for an irreversible and incompressible fluid flow as follows:
</p>
<p>
<pre>
    p_stat_1 + (rho/2)*velocity_1^2 = p_stat_2 + (rho/2)*velocity_2^2 + zeta_fri_1*(rho/2)*velocity_1^2 + (zeta_loc_d + zeta_fri_d)*(rho/2)*velocity_1^2 + zeta_fri_2*(rho/2)*velocity_2^2  (Eq.1)
</pre>
</p>
 
<p>
where the frictional pressure loss coefficient of an inlet pipe before and an outlet pipe after the diffuser section is calculated with:
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
<tr><td><b> 1                                </b></td><td> as diffuser inlet [-],</td></tr>
<tr><td><b> 2                                </b></td><td> as diffuser outlet [-],</td></tr>
<tr><td><b> dp_dyn                           </b></td><td> as dynamic pressure difference [Pa],</td></tr>
<tr><td><b> dp_sta </b> = p_sta_2 - p_sta_1      </td><td> as static pressure difference [Pa],</td></tr>
<tr><td><b> dp_tot </b> = p_tot_1 - p_tot_2      </td><td> as total pressure loss [Pa],</td></tr>
<tr><td><b> d                                </b></td><td> as diffuser section [-],</td></tr>
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
For a reversible fluid flow in a diffuser neglecting local and frictional pressure losses, the static pressure recovery coefficient <b>(eta_sta_rev)</b> can be defined from Eq.1 to:
</p>
<p>
<pre>
    eta_sta_rev = dp_sta/[(rho/2)*velocity_1^2]
                = (p_sta_2 - p_sta_1)/[(rho/2)*velocity_1^2]
                = 1 - 1/AR^2.                                  (Eq.2)
</pre>
</p>

<p>
For an irreversible fluid flow in a diffuser considering local and frictional pressure losses, the static pressure recovery coefficient <b>(eta_sta_irr)</b> can be defined from Eq.1 to:
</p>
<p>
<pre>
    eta_sta_irr = dp_sta/[(rho/2)*velocity_1^2]
                = (p_sta_2 - p_sta_1)/[(rho/2)*velocity_1^2]
                = 1 - 1/AR^2 - (zeta_fri_1 + zeta_loc_d + zeta_fri_d + zeta_fri_2*[1/AR^2])
                = 1 - 1/AR^2 - zeta_tot.                                                      (Eq.3) 
</pre>
</p>

<p>
There is a correlation of the total pressure loss coefficient <b>(zeta_tot)</b> and the static pressure recovery coefficients according to the comparison of Eq.2 and Eq.3:
</p>
<p>
<pre>
    zeta_tot = eta_sta_rev - eta_sta_irr 
             = zeta_fri_1 + zeta_loc_d + zeta_fri_d + zeta_fri_2*[1/AR^2]  (Eq.4)
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> 1                                </b></td><td> as diffuser inlet [-],</td></tr>
<tr><td><b> 2                                </b></td><td> as diffuser outlet [-],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2     </td><td> as area ratio of diffuser [-],</td></tr>
<tr><td><b> d                                </b></td><td> as diffuser section [-],</td></tr>
<tr><td><b> d_hyd                                </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> dp_sta </b> = p_sta_2 - p_sta_1      </td><td> as static pressure difference [Pa],</td></tr>
<tr><td><b> p_sta</b>                            </td><td> as static pressure [Pa],</td></tr>
<tr><td><b> zeta_fri</b>                         </td><td> as frictional resistance coefficient of pipe sections [-],</td></tr>
<tr><td><b> zeta_loc</b>                         </td><td> as (irreversible) local resistance coefficient [-],</td></tr>
<tr><td><b> zeta_tot                         </b></td><td> as total pressure loss coefficient [-].</td></tr>
</table>
</p>

<p>
<b>Laminar regime</b> (Re &le; 200 w.r.t. Rosa and Pinho 2006):
</p>
<p>
The (irreversible) local resistance coefficient for the laminar regime <b>(zeta_loc_lam)</b> is calculated according to <i>[Rosa and Pinho 2006, p. 327, eq. 17]</i>:
</p>
<p>
<pre>
    zeta_loc_lam = f(alpha,AR,Re) 
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> alpha                                      </b></td><td> as half diffuser diverging angle (0 &lt; alpha &lt; &#x3C0;/2) [rad],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2           </td><td> as area ratio of diffuser [-],</td></tr>
<tr><td><b> d_hyd                                      </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> Re_1</b>                                   </td><td> as Reynolds number at inlet of diffuser [-],</td></tr>
<tr><td><b> zeta_loc_lam</b>                           </td><td> as (irreversible) local pressure loss coefficient in laminar regime [-].</td></tr>
</table>
</p>

<p>
Please note that the dependence of the local resistance coefficient in the laminar regime <b>(zeta_loc_lam)</b> on the area ratio <b>(AR)</b> is considered according to <i>[Oliveira,P. and Pinho, F., p.528]</i>.
</p>

<p>
<b>Turbulent regime</b> (Re &gt; 200):
</p>
<p>
The (irreversible) local resistance coefficient for the turbulent regime <b>(zeta_loc_tur)</b> is calculated according to <i>[Idelchik 2006, p. 251, eq. 5-7]</i>:
</p>
<p>
<pre>
    zeta_loc_tur = phi * (1-1/AR)^exp_phi
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> alpha                                </b></td><td> as half diffuser diverging angle (0 &lt; alpha &lt; &#x3C0;/2) [rad],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2     </td><td> as area ratio of diffuser [-],</td></tr>
<tr><td><b> d_hyd                                </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> phi </b> = f(alpha)                  </td><td> as shock coefficient [-],</td></tr>
<tr><td><b> exp_phi                              </td><td> as geometry exponent (exp_phi=1.92 for a conical diffuser) [-],</td></tr>
<tr><td><b> zeta_loc_tur</b>                     </td><td> as (irreversible) local pressure loss coefficient in turbulent regime [-].</td></tr>
</table>
</p>

<p>
The frictional resistance coefficient for the turbulent regime <b>(zeta_fri_tur)</b> is calculated according to <i>[Idelchik 2006, p. 250, eq. 5-6]</i>:
</p>
<p>
<pre>
    zeta_fri_tur = (1 + 0.5/1.5^x_tilde) * lambda_fri_d * (1 - 1/AR^2) / [8 *sin(alpha)]
</pre>
</p>

<p>
with
</p>

<p>
<table>
<tr><td><b> alpha                                </b></td><td> as half diffuser diverging angle (0 &lt; alpha &lt; &#x3C0;/2) [rad],</td></tr>
<tr><td><b> AR</b> = (d_hyd_2)^2/(d_hyd_1)^2     </td><td> as area ratio of diffuser [-],</td></tr>
<tr><td><b> d_hyd                                </b></td><td> as hydraulic diameter of pipe sections [m],</td></tr>
<tr><td><b> lambda_fri_d                         </b></td><td> as Darcy friction factor of diffuser section [-],</td></tr>
<tr><td><b> x_tilde</b>= f(Geometry)              </td><td> as relative length of diffuser [-],</td></tr>
<tr><td><b> zeta_fri_tur</b>                     </td><td> as frictional resistance coefficient in turbulent regime [-].</td></tr>
</table>
</p>

<p>
Please note that the Darcy friction factor for the conical diffuser section <b>(lambda_fri_d)</b> is calculated as arithmetic mean value out of the values from the inlet and outlet pipe sections.
</p>
 
<h4><font color=\"#EF9B13\">Verification</font></h4>      
<p>
The local resistance coefficient <b>(zeta_loc)</b> of a conical diffuser in dependence of the inlet Reynolds number <b>(Re_1)</b> for different half diffuser diverging angles <b>(alpha)</b> is shown for the laminar regime in the figure below.
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/diffuser/fig_diffuser_dp_conical_DP_zetaLocVsRelamWrtAlpha.png\">
</p>

<p>
There is a slight difference in the validation due to the fact that the effect of frictional pressure loss of the diffuser section considered in the reference results cannot be separated out of the calculation of the total pressure loss. The indirect considering of the frictional pressure loss leads to a constant increase of the calculated local resistance coefficient compared to the reference results.
Frictional pressure loss of an inlet or outlet pipe connected to the diffuser section is neglected here.
</p>

<p>
The total pressure loss <b>(zeta_tot)</b> of a conical diffuser in dependence of the inlet Reynolds number <b>(Re_1)</b> for different half diffuser diverging angles <b>(alpha)</b> is shown for the overall regime in the figure below.
Frictional pressure loss of an inlet and outlet pipe connected to the diffuser section is considered here for a pipes with a length of one inlet diameter (d_hyd_1/L_1 = 1 and d_hyd_2/L_2 = 1).</p>

<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/diffuser/fig_diffuser_dp_conical_DP_zetaTotVsReWrtAlpha.png\">
</p>

<p>
The total pressure loss <b>(dp_tot)</b> of a conical diffuser in dependence of the mass flow rate of air for different half diffuser diverging angles <b>(alpha)</b> in the overall flow regime is shown in the figure below. The shown total pressure loss also considers frictional pressure loss of pipes at the inlet and the outlet of the diffuser. The area ratio <b>(AR)</b> has been kept constant, so that there is a decrease in the length of the diffuser section <b>(L_d)</b> with increasing half diffuser diverging angles <b>(alpha)</b>.  
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/diffuser/fig_diffuser_dp_conical_DP_dptotVsMflow_wrtAlpha.png\">
</p>
 
<p>
The total pressure loss coefficient <b>(zeta_tot)</b> of a conical diffuser in dependence of half diffuser diverging angle <b>(alpha)</b> for a different Reynolds number <b>(Re)</b> in the turbulent regime is shown in the figure below. Frictional pressure loss of pipes at the inlet and the outlet of the diffuser is neglected. The area ratio has been kept constant <b>(AR=6)</b> , so that there is a decrease in the length of the diffuser section <b>(L_d)</b> with increasing half diffuser diverging angles <b>(alpha)</b>.  
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/diffuser/fig_diffuser_dp_conical_DP_zetaTotVsAlphaWrtRe.png\">
</p> 
 
<p>
The dependence of the total pressure loss coefficient <b>(zeta_tot)</b> on the Reynolds number <b>(Re)</b> can be neglected compared to the influence of the half diffuser diverging angle <b>(alpha)</b>. Deviations between calculation and reference values could be explained due to the neglect of the local resistance coefficient for a non-uniform velocity profile at the inlet of the diffuser.
Please note that generally it is not advisable to parameterise a diffuser with a half diffuser diverging angle larger than 22.5&deg; due to large irreversible local shock losses. 
</p> 
 
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Idelchik,I.E.:</dt>
    <dd><b>Handbook of hydraulic resistance</b>.
    Jaico Publishing House,Mumbai,3rd edition, 2006.</dd>
<dt>Miller,D.S.:</dt>
    <dd><b>Internal flow systems</b>.
    volume 5th of BHRA Fluid Engineering Series.BHRA Fluid Engineering, 1984.
<dt>Rosa, S. and Pinho, F.:</dt> 
    <dd><b>Pressure drop coefficient of laminar Newtonian flow in axisymmetric diffusers</b>. 
    International Journal of Heat and Fluid Flow , 2006, 319-328.</dd>
</dl>
<dt>Oliveira,P. and Pinho, F.:</dt> 
    <dd><b>Pressure drop coefficient of laminar Newtonian flow in axisymmetric sudden expansions</b>. 
    International Journal of Heat and Fluid Flow , 1997, 518-529.</dd>
</dl>
</html>
"));
end dp_conicalOverall_DP;
