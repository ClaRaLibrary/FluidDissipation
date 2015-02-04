within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function TwoPhaseMultiplierChisholm
  "Calculation of two phase multiplier according to Chisholm | constant mass flow rate quality"
  extends Modelica.Icons.Function;
  //SOURCE_1: Chisholm,D.:PRESSURE GRADIENTS DUE TO FRICTION DURING THE FLOW OF EVAPORATING TWO-PHASE MIXTURES IN SMOOTH TUBES AND CHANNELS, Int. J. Heat Mass Transfer, Vol. 16, pp. 347-358, Pergamon Press 1973
  //SOURCE_2: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var IN_var
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  output Real phi "Two phase multiplier w.r.t. Chisholm";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, IN_con.A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, IN_con.perimeter))
    "Hydraulic diameter";

  Real mdot_A=abs(m_flow)/A_cross "Mass flux";
  Real x_flow=max(0, min(1, abs(IN_var.x_flow))) "Mass flow rate quality";

  //SOURCE_1: p.357, Appendix 1: Considering Darcy friction factor (lambda_FRI) of smooth pipes for overall flow regime
  Real n_exp=0.2 "Exponent for Reynolds number (lambda_FRI= A/Re^n)";

  //SOURCE_1: p.349, eq. 21: Considering effect of physical properties (failure in SOURCE_2)
  Real gamma=max(1, abs(IN_var.rho_l/max(MIN, IN_var.rho_g))^0.5*(IN_var.eta_g/
      max(MIN, IN_var.eta_l))^(n_exp/2));

  //SOURCE: p. 353, tab. 2: Considering effect of mass flux on two phase multiplier
  Real B_gamma_1=SMOOTH(
      450,
      550,
      mdot_A)*4.8 + SMOOTH(
      550,
      450,
      mdot_A)*2400/max(MIN, mdot_A) - SMOOTH(
      1950,
      1850,
      mdot_A)*2400/max(MIN, mdot_A) + SMOOTH(
      1950,
      1850,
      mdot_A)*55/max(MIN, mdot_A^0.5) "Coefficient B for gamma <= 9.5";
  Real B_gamma_2=SMOOTH(
      550,
      650,
      mdot_A)*520/max(1, max(9.5, gamma)*mdot_A^0.5) + SMOOTH(
      650,
      550,
      mdot_A)*21/max(9.5, gamma) "Coefficient B for 9.5 <= gamma <= 28";
  Real B_gamma=SMOOTH(
      9.0,
      10,
      gamma)*B_gamma_1 + SMOOTH(
      10,
      9.0,
      gamma)*B_gamma_2 - SMOOTH(
      28.5,
      27.7,
      gamma)*B_gamma_2 + SMOOTH(
      28.5,
      27.5,
      gamma)*15000/max(MIN, gamma^2*mdot_A^0.5) "Coefficient B for gamma";

  //SOURCE_1: p. 350, eq. 24/26: Considering two phase multiplier w.r.t. Chisholm
algorithm
  phi := 1 + (gamma^2 - 1)*(B_gamma*x_flow^((2 - n_exp)/2)*(1 - x_flow)^((2 -
    n_exp)/2) + x_flow^(2 - n_exp));

      annotation (Inline=false);
end TwoPhaseMultiplierChisholm;
