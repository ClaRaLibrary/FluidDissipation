within FluidDissipation.HeatTransfer.StraightPipe;
function kc_boilingOverall "Local two phase heat transfer coefficient of straight pipe | horizontal or vertical boiling"
  extends Modelica.Icons.Function;
  //SOURCE_1: Bejan,A.: HEAT TRANSFER HANDBOOK, Wiley, 2003.
  //SOURCE_2: Gungor, K.E. and R.H.S. Winterton: A general correlation for flow boiling in tubes and annuli, Int.J. Heat Mass Transfer, Vol.29, p.351-358, 1986.

  //input records
  input FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_con
    IN_con annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var
    IN_var annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Local two phase heat transfer coefficient";
  output SI.CoefficientOfHeatTransfer kc_FC "Local heat transfer coefficient due to forced convection";
  output SI.CoefficientOfHeatTransfer kc_PB "Local heat transfer coefficient due to nucleate pool boiling";
  output Real E;
  output Real recXtt "1/X_tt";
protected
  Real MIN=Modelica.Constants.eps;

  //Documentation
algorithm
  if IN_con.target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor then
    (kc, kc_FC,kc_PB, E, recXtt) :=      FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase.kc_twoPhase_boilingHorizontal(IN_con, IN_var);
  elseif IN_con.target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilVer then
     (kc, kc_FC,kc_PB, E, recXtt) :=      FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase.kc_twoPhase_boilingVertical(IN_con, IN_var);
  else
     kc:=MIN;
     kc_FC:=MIN;
     kc_PB :=MIN;
     E:=MIN;
     recXtt:=MIN;
  end if;
  E:=min(E, 1000);
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>Calculation of local <b>two phase</b> heat transfer coefficient <b>kc_2ph </b>for (horizontal/vertical) <b>boiling</b> or (horizontal) <b>condensation</b> for an overall flow regime. </p>
<p><h4><font color=\"#ef9b13\">Restriction</font></h4></p>
<p><ul>
<li>circular cross sectional area </li>
<li>no subcooled boiling </li>
<li>film condensation </li>
<li>0 &LT; x &LT; 1</li>
</ul></p>
<p><h4><font color=\"#ef9b13\">Geometry </font></h4></p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/straightPipe/pic_straightPipe.png\"/> </p>
<p><b><font style=\"color: #ef9b13; \">Calculation</font></b> </p>
<p><b>Boiling in a horizontal pipe (target == BoilHor):</b> </p>
<p>The local two phase heat transfer coefficient <b>kc_2ph </b>during boiling in a <b>horizontal</b> straight pipe for an overall regime is calculated according to <i>[Gungor/Winterton 1986, p.354, eq. 2]</i> : </p>
<p><code>    kc_2ph = E_fc*E_fc_hor*kc_fc+S_nb*S_nb_hor*kc_nb</code> </p>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><b>Bo</b>=qdot_A/(mdot_A*dh_lv) </p></td>
<td><p>as boiling number [-],</p></td>
</tr>
<tr>
<td><p><h4>dh_lv </h4></p></td>
<td><p>as evaporation enthalpy [J/kg],</p></td>
</tr>
<tr>
<td><p><b>E_fc</b>=f(Bo,Fr_l,X_tt) </p></td>
<td><p>as forced convection enhancement factor [-],</p></td>
</tr>
<tr>
<td><p><b>E_fc_hor</b> =f(Fr_l) </p></td>
<td><p>as forced convection enhancement factor for horizontal straight pipes [-],</p></td>
</tr>
<tr>
<td><p><h4>Fr_l </h4></p></td>
<td><p>as Froude number assuming total mass flow rate flowing as liquid [-],</p></td>
</tr>
<tr>
<td><p><h4>kc_2ph </h4></p></td>
<td><p>as local two phase heat transfer coefficient [W/(m2K)],</p></td>
</tr>
<tr>
<td><p><h4>kc_fc </h4></p></td>
<td><p>as heat transfer coefficient considering forced convection [W/(m2K)],</p></td>
</tr>
<tr>
<td><p><h4>kc_nb </h4></p></td>
<td><p>as heat transfer coefficient considering nucleate boiling [W/(m2K)],</p></td>
</tr>
<tr>
<td><p><h4>mdot_A </h4></p></td>
<td><p>as total mass flow rate density [kg/(m2s)],</p></td>
</tr>
<tr>
<td><p><h4>qdot_A </h4></p></td>
<td><p>as heat flow rate density [W/m2],</p></td>
</tr>
<tr>
<td><p><h4>Re_l </h4></p></td>
<td><p>as Reynolds number assuming liquid mass flow rate flowing alone [-],</p></td>
</tr>
<tr>
<td><p><b>S_nb</b> =f(E_fc,Re_l) </p></td>
<td><p>as suppression factor of nucleate boiling [-],</p></td>
</tr>
<tr>
<td><p><b>S_nb_hor</b> =f(Fr_l) </p></td>
<td><p>as suppression factor of nucleate boiling for horizontal straight pipes [-],</p></td>
</tr>
<tr>
<td><p><h4>x_flow </h4></p></td>
<td><p>as mass flow rate quality [-],</p></td>
</tr>
<tr>
<td><p><b>X_tt</b> = f(x_flow) </p></td>
<td><p>as Martinelli parameter [-].</p></td>
</tr>
</table>
<p><br/><b>Boiling in a vertical pipe (target == BoilVer):</b> </p>
<p>The local two phase heat transfer coefficient <b>kc_2ph </b>during boiling in a <b>vertical</b> straight pipe for an overall regime is calculated out of the correlations for boiling in a horizontal straight pipe, where the horizontal correction factors <b>E_fc_hor,S_nb_hor</b> are unity. </p>
<p>Please note that the correlations named above are not valid for subcooled boiling due to a different driving temperature for nucleate boiling and forced convection. At subcooled boiling there is no enhancement factor (no vapour generation) but the suppression factor remains effective. </p>
<p><b>Condensation in a horizontal pipe (target == CondHor):</b> </p>
<p>The local two phase heat transfer coefficient <b>kc_2ph </b>during condensation in a <b>horizontal</b> straight pipe for an overall regime is calculated according to <i>[Shah 1979, p.548, eq. 8]</i> : </p>
<p><code>  kc_2ph = kc_1ph*[(1 - x_flow)^0.8 + 3.8*x_flow^0.76*(1 - x_flow)^0.04/p_red^0.38]</code> </p>
<p>where the convective heat transfer coefficient <b>kc_1ph </b>assuming the total mass flow rate is flowing as liquid according to <i>[Shah 1979, p.548, eq. 5]</i> : </p>
<pre>  kc_1ph = 0.023*Re_l^0.8*Pr_l^0.4*lambda_l/d_hyd</pre>
<p><code> </code> </p>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>d_hyd </h4></p></td>
<td><p>as hydraulic diameter [m],</p></td>
</tr>
<tr>
<td><p><h4>kc_2ph </h4></p></td>
<td><p>as local two phase heat transfer coefficient [W/(m2K)],</p></td>
</tr>
<tr>
<td><p><h4>kc_1ph </h4></p></td>
<td><p>as convective heat transfer coefficient assuming total mass flow rate is flowing as liquid [W/(m2K)],</p></td>
</tr>
<tr>
<td><p><h4>lambda_l </h4></p></td>
<td><p>as thermal conductivity of fluid [W/(mK)],</p></td>
</tr>
<tr>
<td><p><h4>pressure </h4></p></td>
<td><p>as thermodynamic pressure of fluid [Pa],</p></td>
</tr>
<tr>
<td><p><h4>p_crit </h4></p></td>
<td><p>as critical pressure of fluid [Pa],</p></td>
</tr>
<tr>
<td><p><b>p_red</b> = pressure/p_crit </p></td>
<td><p>as reduced pressure [-],</p></td>
</tr>
<tr>
<td><p><h4>Pr_l </h4></p></td>
<td><p>as Prandtl number assuming [-],</p></td>
</tr>
<tr>
<td><p><h4>Re_l </h4></p></td>
<td><p>as Reynolds number assuming <b>total</b> mass flow rate is flowing as liquid [-],</p></td>
</tr>
<tr>
<td><p><h4>x_flow </h4></p></td>
<td><p>as mass flow rate quality [-],</p></td>
</tr>
</table>
<p><br/><h4><font color=\"#ef9b13\">Verification</font></h4></p>
<p>The local two phase heat transfer coefficient <b>kc_2ph </b>during for horizontal and vertical boiling as well as for horizontal condensation is shown for a straight pipe in the figures below. </p>
<p><b>Boiling in a horizontal pipe (target == BoilHor):</b> </p>
<p>Here the validation of the two phase heat transfer coefficient is shown for boiling in a horizontal straight pipe. </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_kc_twoPhaseOverall_KC_4.png\"/> </p>
<p>The two phase heat transfer coefficient (<b>kc_2ph </b>) w.r.t. <i>Gungor/Winterton</i> is shown in dependence of the mass flow rate quality (<b>x_flow </b>) for different mass flow rate densities (<b>mdot_A </b>). The validation has been done with measurement results from <i>Kattan/Thome</i> for R134a as medium. </p>
<p>The two phase heat transfer coefficient increases with increasing mass flow rate quality up to a maximum value. After that there is a rapid decrease of (<b>kc_2ph </b>) with increasing (<b>x_flow </b>). This can be explained with a partial dryout of the pipe wall for a high mass flow rate quality. </p>
<p><b>Condensation in a horizontal pipe (target == CondHor):</b> </p>
<p>Here the validation of the two phase heat transfer coefficient is shown for condensation in a horizontal straight pipe. </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/fig_kc_twoPhaseOverall_KC_2.png\"/> </p>
<p>The two phase heat transfer coefficient (<b>kc_2ph </b>) w.r.t. <i>Shah</i> is shown in dependence of the mass flow rate quality (<b>x_flow </b>) for different mass flow rate densities (<b>mdot_A </b>). The validation has been done with measurement results from <i>Dobson/Chato</i> for R134a as medium. </p>
<p><b><font style=\"color: #ef9b13; \">References</font></b> </p>
<dl><dt>Bejan,A.: </dt>
<dd><b>Heat transfer handbook</b>. Wiley, 2003. </dd>
<dl><dt>M.K. Dobson and J.C. Chato: </dt>
<dd><b>Condensation in smooth horizontal tubes</b>. Journal of HeatTransfer, Vol.120, p.193-213, 1998. </dd>
<dl><dt>Gungor, K.E. and R.H.S. Winterton: </dt>
<dd><b>A general correlation for flow boiling in tubes and annuli</b>, Int.J. Heat Mass Transfer, Vol.29, p.351-358, 1986. </dd>
<dl><dt>N. Kattan and J.R. Thome: </dt>
<dd><b>Flow boiling in horizontal pipes: Part 2 - new heat transfer data for five refrigerants.</b>. Journal of Heat Transfer, Vol.120. p.148-155, 1998. </dd>
<dl><dt>Shah, M.M.: </dt>
<dd><b>A general correlation for heat transfer during film condensation inside pipes</b>. Int. J. Heat Mass Transfer, Vol.22, p.547-556, 1979. </dd>
</dl></html>"));
end kc_boilingOverall;
