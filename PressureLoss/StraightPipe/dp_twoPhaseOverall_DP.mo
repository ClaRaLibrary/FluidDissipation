within FluidDissipation.PressureLoss.StraightPipe;
function dp_twoPhaseOverall_DP "Pressure loss of straight pipe for two phase flow | calculate (frictional, momentum, geodetic) pressure loss"
  extends Modelica.Icons.Function;
  //SOURCE_1: Friedel,L.:IMPROVED FRICTION PRESSURE DROP CORRELATIONS FOR HORIZONTAL AND VERTICAL TWO PHASE PIPE FLOW, 3R International, Vol. 18, Issue 7, pp. 485-491, 1979
  //SOURCE_2: Chisholm,D.:PRESSURE GRADIENTS DUE TO FRICTION DURING THE FLOW OF EVAPORATING TWO-PHASE MIXTURES IN SMOOTH TUBES AND CHANNELS, Int. J. Heat Mass Transfer, Vol. 16, pp. 347-358, Pergamon Press 1973
  //SOURCE_3: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.
  //SOURCE 4: J.M. Jensen and H. Tummescheit. Moving boundary models for dynamic simulations of two-phase flows. In Proceedings of the 2nd International Modelica Conference, pp. 235-244, Oberpfaffenhofen, Germany, 2002. The Modelica Association.
  //SOURCE_5: Thome, J.R., Engineering Data Book 3, Swiss Federal Institute of Technology Lausanne (EPFL), 2009.

  //input records
  input FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_IN_con IN_con "Input record for function dp_twoPhaseOverall_DP"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_IN_var IN_var "Input record for function dp_twoPhaseOverall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Two phase pressure loss";

  import TYP = FluidDissipation.Utilities.Types.TwoPhaseFrictionalPressureLoss;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, IN_con.A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, IN_con.perimeter)) "Hydraulic diameter";

  Real mdot_A=abs(m_flow)/A_cross "Mass flux";
  Real xflowEnd=min(1, max(0, abs(IN_var.x_flow_end))) "Mass flow rate quality at end of length";
  Real xflowSta=min(1, max(0, abs(IN_var.x_flow_sta))) "Mass flow rate quality at start of length";
  Real x_flow=(xflowEnd + xflowSta)/2 "Mean mass flow rate quality over length";

//   //SOURCE_5: p.17-1 to 17-5, sec. 17.1 to 17.2: Considering cross sectional void fraction [epsilon=A_g/(A_g+A_l)]
//   Real epsilon=
//       FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.VoidFraction(
//       IN_con.voidFractionApproach,
//       true,
//       IN_var.rho_g,
//       IN_var.rho_l,
//       x_flow) "Void fraction";

  //SOURCE_1: Considering frictional pressure loss w.r.t. to correlation of Friedel
  //SOURCE_2: Considering frictional pressrue loss w.r.t. to correlation of Chisholm
  SI.Pressure DP_fric=if IN_con.frictionalPressureLoss == TYP.Friedel then
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseFriedel_DP(
      FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con(
      A_cross=IN_con.A_cross,
      perimeter=IN_con.perimeter,
      length=IN_con.length),
      FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var(
      rho_g=IN_var.rho_g,
      rho_l=IN_var.rho_l,
      eta_g=IN_var.eta_g,
      eta_l=IN_var.eta_l,
      sigma=IN_var.sigma,
      x_flow=IN_var.x_flow),
      m_flow)
      else if IN_con.frictionalPressureLoss == TYP.Chisholm then
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseChisholm_DP(
      FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con(
      A_cross=IN_con.A_cross,
      perimeter=IN_con.perimeter,
      length=IN_con.length),
      FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var(
      rho_g=IN_var.rho_g,
      rho_l=IN_var.rho_l,
      eta_g=IN_var.eta_g,
      eta_l=IN_var.eta_l,
      sigma=IN_var.sigma,
      x_flow=IN_var.x_flow),
      m_flow)
      else if IN_con.frictionalPressureLoss == TYP.MuellerSteinhagenHeck then
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseMSH_DP(
      FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con(
      A_cross=IN_con.A_cross,
      perimeter=IN_con.perimeter,
      length=IN_con.length),
      FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var(
      rho_g=IN_var.rho_g,
      rho_l=IN_var.rho_l,
      eta_g=IN_var.eta_g,
      eta_l=IN_var.eta_l,
      sigma=IN_var.sigma,
      x_flow=IN_var.x_flow),
      m_flow)
      else 0 "Frictional pressure loss";

  //SOURCE_3: p.Lba 4, eq. 22: Considering momentum pressure loss assuming heterogeneous approach for two phase flow
  //Evaporation >> positive momentum pressure loss (assumed vice versa at condensation)
  SI.Pressure DP_mom=if IN_con.momentumPressureLoss then
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseMomentum_DP(
      IN_con.voidFractionApproach,
      IN_con.massFlowRateCorrection,
      IN_con.A_cross,
      IN_con.perimeter,
      IN_var.rho_g,
      IN_var.rho_l,
      IN_var.x_flow_end,
      IN_var.x_flow_sta,
      abs(m_flow)) else 0 "Momentum pressure loss";

  //SOURCE_3: p.Lbb 1, eq. 4: Considering geodetic pressure loss assuming constant void fraction for flow length
  SI.Pressure DP_geo=if IN_con.geodeticPressureLoss then
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseGeodetic_DP(
      IN_con.voidFractionApproach,
      true,
      IN_con.length,
      IN_con.phi,
      IN_var.rho_g,
      IN_var.rho_l,
      IN_var.x_flow) else 0 "Geodetic pressure loss";

  //Documentation
algorithm
  DP := DP_fric + DP_mom + DP_geo;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of pressure loss for <b>two phase flow</b> in a horizontal <b>or</b> vertical straight pipe for an overall flow regime considering frictional, momentum and geodetic pressure loss. For an inverted frictional pressue loss model see FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.dp_twoPhaseMSH_MFLOW.
</p>

<p> 
Generally the pressure loss for two phase flow in a horizontal or a vertical straight pipe can be calculated for the following fluid flow regimes:
<p> 
<p> 
<b>Horizontal fluid flow</b> [(a) bubble flow, (b) stratified flow, (c) wavy flow, (d) slug flow, (e) annular flow]:
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/pic_twoPhaseFlowRegimes_horizontal.png\">
</p>

<p> 
<b>Vertical fluid flow</b> [(a) bubble flow, (b) plug slug flow, (c) foam flow, (d) annular streak flow, (e) annular flow]:
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/pic_twoPhaseFlowRegimes_vertical.png\">
</p> 
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used within the restricted limits according to the referenced literature.
<ul>
 <li> <b> circular cross sectional area </b>
 <li> <b> neglecting of surface roughness </b> </li>
 <li> <b> horizontal flow or vertical upflow </b> </li>
 <li> <b> usage of mass flow rate quality (see Calculation) </b> </li>
 <li> <b> two phase pressure loss for mean constant mass flow rate quality (x_flow) over (increment) length </li>
 <li> <b> usage of two phase pressure loss function for discretisation at boiling or condensation considering variable mass flow rate quality </li>
</ul>
 
<h4><font color=\"#EF9B13\">Geometry </font></h4>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The two phase pressure loss <b> dp_2ph </b> of straight pipes is determined by:
<p>
<pre>
dp_2ph = dp_fri + dp_mom + dp_geo
</pre>
</p>
 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_fri        </b></td><td> as frictional pressure loss [Pa],</td></tr>
<tr><td><b> dp_mom        </b></td><td> as momentum pressure loss [Pa],</td></tr>
<tr><td><b> dp_geo        </b></td><td> as geodetic pressure loss [Pa].</td></tr>
</table>
</p>

<p> 
<b>Definition of quality for two phase flow</b>:
</p>
<p> 
Different definitions of the quality exist for two phase flow. Static quality, mass flow rate quality and thermodynamic quality can be used to describe the fraction of gas and liquid in two phase flow. 
Here the mass flow rate quality <b>(x_flow)</b> is used to describe two phase flow as follows:
</p>

<p>
<pre>
x_flow = mdot_g/(mdot_g+mdot_l)
</pre>
</p>

<p>
with
</p>
 
<p>
<table>
<tr><td><b> x_flow        </b></td><td> as mass flow rate quality [-],</td></tr>
<tr><td><b> mdot_g        </b></td><td> as gaseous mass flow rate [kg/s],</td></tr>
<tr><td><b> mdot_l        </b></td><td> as liquid mass flow rate [kg/s].</td></tr>
</table>
</p>

<p> 
Note that mass flow rate quality <b>(x_flow)</b> is only equal to the static quality, if a difference between the velocity of gas and liquid phase is neglected (homogeneous approach). 
Additionally the thermodynamic quality is only equal to the mass flow rate quality <b>(x_flow)</b> in the two phase regime for thermodynamic equilibrium of the phases.
</p>

<p> 
<b>Frictional pressure loss</b>:
</p>

<p> 
The frictional pressure loss <b>dp_fri</b> of a straight pipe is calculated either by the correlation of <b>Friedel</b> (frictionalPressureLoss==Friedel) or by the correlation of <b>Chisholm</b> (frictionalPressureLoss==Chisholm).
Both correlations can be used for the above named two phase flow regimes.
The two phase frictional pressure loss results from a frictional pressure loss assuming one phase liquid fluid flow and a two phase multiplier taking into account the effects of two phase flow:
</p> 
<pre>
dp_fri = dp_1ph*phi_i
</pre>
</p> 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> dp_1ph  </b></td><td> as frictional pressure loss assuming one phase liquid fluid flow [Pa],</td></tr>
<tr><td><b> phi_i   </b></td><td> as two phase multiplier [-].</td></tr>
</table>
</p>

<p>
The liquid frictional pressure loss is calculated with the <b>total mass flow rate</b> assumed to flow as liquid.
</p>

<p>
The correlations of Friedel and Chisholm differ in their calculation of the two phase multiplier:
</p>
</p> 
<pre>
phi_friedel = (1 - x_flow)^2 + x_flow^2*(rho_l/rho_g)*(lambda_g/lambda_l) 
            + 3.43*x_flow^0.685*(1 - x_flow)^0.24*(rho_l/rho_g)^0.8*(eta_g/eta_l)^0.22*(1 - eta_g/eta_l)^0.89*(1/Fr_l^(0.048))*(1/We_l^(0.0334))
</pre>
<pre>
phi_chisholm = 1 + (gamma^2 - 1)*(B*x_flow^((2 - n_exp)/2)*(1 - x_flow)^((2 -n_exp)/2) + x_flow^(2 - n_exp))
</pre>
</p> 

<p>
with
</p>
 
<p>
<table>
<tr><td><b> B              </b></td><td> as Lockhart-Martinelli coefficient [-],</td></tr>
<tr><td><b> eta_l          </b></td><td> as dynamic viscosity of the liquid phase [Pas],</td></tr>
<tr><td><b> eta_g          </b></td><td> as dynamic viscosity of the gaseous phase [Pas],</td></tr>
<tr><td><b> gamma          </b></td><td> as physical property coefficient [-],</td></tr>
<tr><td><b> n_exp</b> =0.2     </td><td> as exponent in Chisholm correlation [-],</td></tr>
<tr><td><b> phi_i          </b></td><td> as two phase multiplier [-],</td></tr>
<tr><td><b> rho_l          </b></td><td> as density of the liquid phase [kg/m3],</td></tr>
<tr><td><b> rho_g          </b></td><td> as density of the gaseous phase [kg/m3],</td></tr>
<tr><td><b> Re_l           </b></td><td> as Reynolds number of the liquid phase [-],</td></tr>
<tr><td><b> Re_g           </b></td><td> as Reynolds number of the gaseous phase [-],</td></tr>
<tr><td><b> Fr_l           </b></td><td> as Froude number of the liquid phase [-],</td></tr>
<tr><td><b> We_l           </b></td><td> as Weber number of the liquid phase [-],</td></tr>
<tr><td><b> x_flow         </b></td><td> as mass flow rate quality [-].</td></tr>
</table>
</p>

<p>
Note that the (mean constant) mass flow rate quality <b>(x_flow)</b> used for frictional pressure loss is calculated as arithmetic mean value out of the mass flow rate quality at the end and at the start of the straight pipe length.
</p>
<p>
The frictional pressure loss with the Mueller-Steinhagen and Heck correlation is calculated as follows:
<br>Laminar flow regime</br>
<p>
i.e. <img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/Equations/equation007.png\" alt=\"\"><br>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/Equations/equation008.png\" alt=\"\"><br>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/Equations/equation013.png\" alt=\"\"><br>
</p>


<br>Turbulent flow regime</br>
<p>
i.e. <img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/Equations/equation006.png\" alt=\"\"><br>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/Equations/equation001.png\" alt=\"\"><br>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/Equations/equation012.png\" alt=\"\"></p>

</p>

<p>
<b>Momentum pressure loss</b>:
</p>
<p>
The momentum pressure loss <b> dp_mom </b> can be considered (momentumPressureLoss = true) for a homogeneous or heterogeneous two phase flow depending on the approach used for the void fraction <b>(epsilon)</b>. 
At evaporation the liquid phase having a slow velocity has to be accelerated to the higher velocity of the gas. The difference in static pressure at the outlet and the inlet causes a positive momentum pressure loss at evaporation (assumed vice versa for condensation).
The momentum pressure loss occurs for a changing mass flow rate quality due to condensation or evaporation according to <i>[VDI 2006, p.Lba 4, eq. 22]</i> :
<p>
<pre>
dp_mom = mdot_A^2*[[((1-x_flow)^2/(rho_l*(1-epsilon)) + x_flow^2/(rho_g*epsilon))]_out - [((1-x_flow)^2/(rho_l*(1-epsilon)) + x_flow^2/(rho_g*epsilon))]_in]
</pre>
</p>
<p>
with
</p>
 
<p>
<table>
<tr><td><b> mdot_A         </b></td><td> as total mass flow rate density [kg/(m2s)],</td></tr>
<tr><td><b> epsilon        </b></td><td> as void fraction [-],</td></tr>
<tr><td><b> rho_l          </b></td><td> as density of the liquid phase [kg/m3],</td></tr>
<tr><td><b> rho_g          </b></td><td> as density of the gaseous phase [kg/m3],</td></tr>
<tr><td><b> x_flow         </b></td><td> as mass flow rate quality [-].</td></tr>
</table>
</p> 

<p> 
Note that a momentum pressure loss is only considered for a variable mass flow rate quality <b>(x_flow)</b> during evaporation or condensation. Momentum pressure loss does not occur under adiabatic conditions for a corresponding constant mass flow rate quality (evaporation due to pressure loss is not considered).
</p>

<p>
<b>Void fraction approach</b>:
</p>
<p>
The void fraction is one of the most important parameter used to characterise two phase flow. There are several analytical and empirical approaches according to <i>[Thome, J.R]</i> :
</p>
<ul>
 <li>    <b> homogeneous approach </b> </li>  
 <li>     <b> momentum flux approach (heterogeneous model) </b></li>
 <li>     <b> Kinetic energy flow approach by Zivi (heterogeneous model) </b></li>
 <li>     <b> Empirical momentum flux approach by Chisholm (heterogeneous model) </b></li>
</ul>
<p>
These approaches for the void fraction <b>epsilon</b> imply a correlation for the slip ratio. The slip ratio is defined as ratio of the velocity from the gaseous phase to the liquid phase at two phase flow.
The effects of different fluid flow velocities of the phases on two phase pressure loss can be considered with the slip ratio in the heterogeneous approaches. The slip ratio for the homogeneous approach is unity, so that there is no difference in the velocities of the two phases (e.g. usable for bubble flow).
</p>

<p>
<b>Geodetic pressure loss</b>:
</p>
<p>
The geodetic pressure loss <b>dp_geo</b> can be considered (geodeticPressureLoss=true) for two phase flow according to <i>[VDI 2006, p.Lbb 1, eq. 4]</i> :
<p>
<pre>
dp_geo = (epsilon*rho_g +(1-epsilon)*rho_l)*g*L*sin(phi)
</pre>
</p> 
<p>
with
</p>
 
<p>
<table>
<tr><td><b> epsilon        </b></td><td> as void fraction [-],</td></tr>
<tr><td><b> rho_l          </b></td><td> as density of the liquid phase [kg/m3],</td></tr>
<tr><td><b> rho_g          </b></td><td> as density of the gaseous phase [kg/m3],</td></tr>
<tr><td><b> g              </b></td><td> as acceleration of gravity [m/s2],</td></tr>
<tr><td><b> L              </b></td><td> as length of straight pipe [m],</td></tr>
<tr><td><b> phi            </b></td><td> as angle to horizontal [rad].</td></tr>
</table>
</p> 

<h4><font color=\"#EF9B13\">Verification</font></h4>
<p> 
The two phase pressure loss for a horizontal pipe calculated by the correlation of <i> Friedel </i> neglecting momentum and geodetic pressure loss is shown in the figure below. 
</p>
<p> 
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/fig_dp_twoPhaseOverall_1.png\">
</p> 
<p> 
The two phase pressure loss for a horizontal pipe calculated by the correlation of <i> Chisholm </i> neglecting momentum and geodetic pressure loss is shown in the figure below. 
</p>
<p> 
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/fig_dp_twoPhaseOverall_4.png\">
</p>  
<p> 
The two phase pressure loss for a horizontal pipe calculated by the correlation of <i> Mueller-Steinhagen and Heck </i> neglecting momentum and geodetic pressure loss is shown in the figure below. 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/StraightPipe/fig_validPL_straigthPipeTwoPhaseMSH.png\" alt=\"\" width=\"600\">
</p>
<p>
Fluid is Nitrogen, pipe diameter is 0.014 m.
<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Chisholm,D.:</dt>
    <dd><b>Pressure gradients due to friction during the flow of evaporating two-phase mixtures in smooth tubes and channels</b>.
    Volume 16th of International Journal of Heat and Mass Transfer, 1973.</dd>
 <dt>Friedel,L.:</dt>
    <dd><b>IMPROVED FRICTION PRESSURE DROP CORRELATIONS FOR HORIZONTAL AND VERTICAL TWO PHASE PIPE FLOW</b>.3R International, Vol. 18, Issue 7, pp. 485-491, 1979.
 <dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 10th edition, 2006.</dd>
<dt>J.M. Jensen and H. Tummescheit:</dt> 
    <dd><b>Moving boundary models for dynamic simulations of two-phase flows</b>. 
    In Proceedings of the 2nd International Modelica Conference, pages 235?244, Oberpfaffenhofen, Germany, 2002. The Modelica Association.</dd>
<dt>Thome, J.R.:</dt> 
    <dd><b>Engineering Data Book 3</b>.Swiss Federal Institute of Technology Lausanne (EPFL), 2009.</dd>
<dt> H. Mueller-Steinhagen and K. Heck:</dt>  
<dd><b>A Simple Friction Pressure Drop Correlation for Two-Phase Flow in Pipes. </b>Chem. Eng. Process, 1986, 20, 297-308
<dt> H. Mueller-Steinhagen:</dt>  
<dd><b>Waermeuebergang und Fouling beim Stroemungssieden von Argon und Stickstoff im horizontalen Rohr. </b>Fortschrittsberichte der VDI Zeitschriften, Reihe 6 Nr. 143, 1984  
</dl>
</html>
", revisions="<html>
<pre>2016-04-13 Stefan Wischhusen: Epsilon is not used in the function.
2016-04-18 Timm Hoppe: Added Mueller-Steinhagen and Heck correlation for frictional pressure loss.</pre>
</html>"));
end dp_twoPhaseOverall_DP;
