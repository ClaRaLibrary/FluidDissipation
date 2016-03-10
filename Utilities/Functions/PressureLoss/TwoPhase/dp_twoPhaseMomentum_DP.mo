within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function dp_twoPhaseMomentum_DP "Momentum pressure loss of straight pipe for two phase flow | calculate pressure loss"
  extends Modelica.Icons.Function;
  //SOURCE_1: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.
  //SOURCE_2: Thome, J.R., Engineering Data Book 3, Swiss Federal Institute of Technology Lausanne (EPFL), 2009.
  //SOURCE 3: J.M. Jensen and H. Tummescheit. Moving boundary models for dynamic simulations of two-phase flows. In Proceedings of the 2nd International Modelica Conference, pp. 235-244, Oberpfaffenhofen, Germany, 2002. The Modelica Association.

  import PI = Modelica.Constants.pi;
  import MIN = Modelica.Constants.eps;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.SmoothPower;

  //choices
  input FluidDissipation.Utilities.Types.VoidFractionApproach voidFractionApproach=
      FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous "Choice of void fraction approach"
                                       annotation (Dialog(group="Choices"));

  //SOURCE_3: p.52, eq. 4.6: heterogenous effects on momentum pressure loss considered through corrected mass flow rate
  input Boolean massFlowRateCorrection=false "Consider heterogeneous mass flow rate correction"
    annotation (Dialog(group="Choices"));

  //geometry
  input SI.Area A_cross(min=Modelica.Constants.eps) = PI*0.1^2/4 "Cross sectional area"
                           annotation (Dialog(group="Geometry"));
  input SI.Length perimeter(min=Modelica.Constants.eps) = PI*0.1 "Perimeter"
    annotation (Dialog(group="Geometry"));

  //fluid properties
  input SI.Density rho_g(min=Modelica.Constants.eps) = 1.1220 "Density of gas"
    annotation (Dialog(group="Fluid properties"));
  input SI.Density rho_l(min=Modelica.Constants.eps) = 943.11 "Density of liquid"
                        annotation (Dialog(group="Fluid properties"));
  input Real x_flow_end(
    min=0,
    max=1) = 0 "Mass flow rate quality at end of length"
    annotation (Dialog(group="Fluid properties"));
  input Real x_flow_sta(
    min=0,
    max=1) = 0 "Mass flow rate quality at start of length"
    annotation (Dialog(group="Fluid properties"));

  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

    input Real delta_xflow_smooth "Mass flow rate quality at which smoothing for flow reversal or switch of phase change mechanism (boiling to condensation or vice versa) begins";
  output SI.Pressure DP_mom "Momentum pressure loss";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area Across=max(MIN, A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, perimeter)) "Hydraulic diameter";

  Real mdot_A=abs(m_flow)/Across "Mass flux";
  Real xflowEnd=min(1, max(0, abs(x_flow_end))) "Mass flow rate quality at end of length";
  Real xflowSta=min(1, max(0, abs(x_flow_sta))) "Mass flow rate quality at start of length";
  Real xflowMean=(xflowEnd + xflowSta)/2 "Mean mass flow rate quality over length";

  Real delta_xflow=xflowEnd - xflowSta "Difference of mass flow rate quality between end and start of length (pos >> evaporation, neg >> condensation";

  //SOURCE_2: Considering void fraction approaches
  Real eps_end=
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.VoidFraction(
      voidFractionApproach,
      true,
      rho_g,
      rho_l,
      xflowEnd) "Void fraction at end of length";
  Real eps_sta=
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.VoidFraction(
      voidFractionApproach,
      true,
      rho_g,
      rho_l,
      xflowSta) "Void fraction at start of length";

  //SOURCE_2: p.17-6, eq. 17.3.3: Considering mean two phase density at end and start of length
  SI.Density rho_end=
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.TwoPhaseDensity(
      voidFractionApproach,
      massFlowRateCorrection,
      rho_g,
      rho_l,
      eps_end,
      xflowEnd) "Mean two phase density at end of length";
  SI.Density rho_sta=
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.TwoPhaseDensity(
      voidFractionApproach,
      massFlowRateCorrection,
      rho_g,
      rho_l,
      eps_sta,
      xflowSta) "Mean two phase density at start of length";

  SI.Velocity meanVelEnd=abs(m_flow)/max(MIN, rho_end*A_cross) "Mean velocity of two phase flow at end of length";
  SI.Velocity meanVelSta=abs(m_flow)/max(MIN, rho_sta*A_cross) "Mean velocity of two phase flow at start of length";

  //SOURCE 3: p.15, eq. 2.26: Considering velocity difference for heterogeneous approach using slip ratio
  Real SR=FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.SlipRatio(
      voidFractionApproach,
      rho_g,
      rho_l,
      xflowMean) "Slip ratio for velocity void fraction approach";
  SI.Velocity deltaVelEnd=meanVelEnd*(SR - 1)/(xflowEnd*(SR - 1) + 1) "Velocity difference of two phases at end of length";
  SI.Velocity deltaVelSta=meanVelSta*(SR - 1)/(xflowSta*(SR - 1) + 1) "Velocity difference of two phases at start of length";

  //SOURCE 3: p.52, eq. 4.6: Considering of corrected mass flow rate for heterogenous approach
  SI.MassFlowRate mdotCorEnd=xflowEnd*(1 - xflowEnd)*rho_end*deltaVelEnd*Across "Correction mass flow rate at end of length";
  SI.MassFlowRate mdotCorSta=xflowSta*(1 - xflowSta)*rho_sta*deltaVelSta*Across "Correction mass flow rate at start of length";

  //SOURCE 3: p.53, eq. 4.13: Calculation of heterogeneous approach with correction of mass flow rate for considering velocity difference between fluid phases
  SI.Pressure dp_mom_cor=SMOOTH(
      delta_xflow,
      delta_xflow_smooth,
      0)*(abs(mdot_A*meanVelEnd + mdotCorEnd*deltaVelEnd/Across) - abs(mdot_A*
      meanVelSta + mdotCorSta*deltaVelSta/Across)) "Momentum pressure loss using mass flow rate correction";

algorithm
  //SOURCE_1: p.Lba 4, eq. 22: Considering momentum pressure loss assuming heterogeneous approach for two phase flow
  //Momentum pressure loss occurs for a changing mass flow rate quality due to condensation or evaporation
  //At evaporation the liquid phase with a slow velocity has to be accelerated to the higher velocity of the gas
  //The difference in static pressure at the outlet and the inlet causes a positiv momentum pressure loss at evaporation (assumed vice versa for condensation)
  DP_mom := if massFlowRateCorrection then dp_mom_cor else mdot_A^2*SMOOTH(
    delta_xflow,
    delta_xflow_smooth,
    0)*abs(1/max(MIN, rho_end) - 1/max(MIN, rho_sta));
  annotation (Inline=false, Documentation(revisions="<html>
2012-11-28 Corrected an error in momentum pressure loss calculation. Stefan Wischhusen.
</html>"));
end dp_twoPhaseMomentum_DP;
