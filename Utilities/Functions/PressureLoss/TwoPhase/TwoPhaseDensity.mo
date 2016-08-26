within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function TwoPhaseDensity "Calculation of mean density for two phase flow"
  extends Modelica.Icons.Function;

  //SOURCE_1: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.
  input FluidDissipation.Utilities.Types.VoidFractionApproach voidFractionApproach=
      FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous "Choice of void fraction approach"
                                       annotation (Dialog(group="Choices"));

  //SOURCE_3: p.52, eq. 4.6: heterogenous effects on momentum pressure loss considered through corrected mass flow rate
  input Boolean massFlowRateCorrection=false "Consider heterogeneous mass flow rate correction"
    annotation (Dialog(group="Choices"));

  input SI.Density rho_g(min=Modelica.Constants.eps) "Density of gaseous phase"
    annotation (Dialog);
  input SI.Density rho_l(min=Modelica.Constants.eps) "Density of liquid phase"
    annotation (Dialog);
  input Real epsilon_A(min=0,max=1) "Void fraction (cross sectional averaged)"
    annotation (Dialog(enable=not (twoPhaseDensityApproach == FluidDissipation.Utilities.Types.TwoPhaseDensityApproach.Homogeneous)));
  input Real x_flow(min=0,max=1) "Mass flow rate quality" annotation (Dialog);

  output SI.Density rho_2ph "Mean density of two phase flow";
protected
  Real MIN=Modelica.Constants.eps;

  Real epsilonA=min(1, max(0, abs(epsilon_A))) "Void fraction (cross sectional averaged)";
  Real xflow=min(1, max(0, abs(x_flow))) "Mass flow rate quality";

  //SOURCE_1: p.Lba 3, eq. 17: Mean two phase density assuming homogeneous approach
  SI.Density rho_hom=1/max(MIN, x_flow/max(MIN, rho_g) + (1 - x_flow)/max(MIN,
      rho_l));
  //SOURCE_1: p.Lbb 7, tab. 2: Mean two phase density assuming momentum flux approach
  SI.Density rho_mom=1/max(MIN, (x_flow)^2/max(MIN, rho_g*epsilonA) + (1 -
      x_flow)^2/max(MIN, rho_l*(1 - epsilonA)));
  //SOURCE_1: p.Lbb 7, tab. 2: Mean two phase density assuming kinetic energy flow approach from Zivi (corrected formula!)
  SI.Density rho_kin=1/max(MIN, rho_hom*(x_flow^3/max(MIN, rho_g^2*epsilonA^2)
       + (1 - x_flow)^3/max(MIN, rho_l^2*(1 - epsilonA)^2)));

algorithm
  rho_2ph := if not massFlowRateCorrection then rho_hom else if
    voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous
     then rho_hom else if voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Momentum
     then rho_mom else if voidFractionApproach == FluidDissipation.Utilities.Types.VoidFractionApproach.Energy
     then rho_kin else MIN;

  annotation (Inline=false, Documentation(info="<html>
<p>
The gaseous and the liquid part of a fluid in a two phase flow are often discontinuously distributed. This complex behaviour is simplified for engineering calculations. The two phase flow of different fluid flow situations (e.g. bubble or stratified flow) is modelled as if the gaseous and the liquid phase are continuously distributed. 
</p>

<p>
A <b> mean density </b> assuming a continuous distribution out of a discontinuous two phase fluid flow situation can be calculated with a <b> homogeneous or a heterogeneous approach </b> (see <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_DP\">dp_twoPhaseOverall_DP</a>). 

The following <b> modelling approaches </b> can be used to calculate the mean density of two phase flow:
<ul>
<li>        <b> homogeneous density </b> (homogeneous approach) </li>
<li>         <b> momentum flux density </b> (heterogeneous approach) </li>
<li>         <b> kinetic energy flow density </b> (heterogeneous approach) </li>
</ul>
</p>

<p>
The heterogeneous approaches are analytically derived by minimising the momentum flux or the kinetic energy flow assuming implicitly that the two-phase flow will tend towards the minimum of this quantity.
</p>

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
 <dt>VDI:</dt> 
    <dd><b>VDI - W&auml;rmeatlas: Berechnungsbl&auml;tter f&uuml;r den W&auml;rme&uuml;bergang</b>. 
    Springer Verlag, 10th edition, 2006.</dd>
</dl>
</html>", revisions="<html>
<p>2011-03-30        XRG Simulation GmbH - Stefan Wischhusen: Changed error in logical statement (NOT <code>massFlowRateCorrection</code>). </p>
</html>"));
end TwoPhaseDensity;
