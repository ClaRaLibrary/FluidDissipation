within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function TwoPhaseMultiplierFriedel
  "Calculation of two phase multiplier according to Friedel | constant mass flow rate quality | horizontal flow | vertical upflow and downflow"
  extends Modelica.Icons.Function;
  //SOURCE_1: Friedel,L.:IMPROVED FRICTION PRESSURE DROP CORRELATIONS FOR HORIZONTAL AND VERTICAL TWO PHASE PIPE FLOW, 3R International, Vol. 18, Issue 7, pp. 485-491, 1979
  //SOURCE_2: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.

  import Modelica.Math.log;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var IN_var(final
      sigma=0) annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  output Real phi "Two phase multiplier w.r.t. Friedel";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, IN_con.A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, IN_con.perimeter))
    "Hydraulic diameter";

  //SOURCE_2: p.Lba 4, sec. 3.3: Correlation based on constant mass flow rate quality (x_flow) for increment (dx)
  //Pressure loss for total length (e.g. L=n*dx) can be achieved by discretisation
  Real mdot_A=abs(m_flow)/A_cross "Mass flux";
  Real x_flow=max(0, min(1, abs(IN_var.x_flow))) "Mass flow rate quality";

  //SOURCE_1: p.490 (Appendix): Characteristic numbers based on total mass flow rate flowing as liquid
  SI.FroudeNumber Fr_l=max(MIN, mdot_A^2/max(MIN, 9.81*IN_var.rho_l^2*d_hyd))
    "Froude number based on liquid flow";
  SI.ReynoldsNumber Re_g=max(1, mdot_A*d_hyd/max(MIN, IN_var.eta_g))
    "Reynolds number based on gas flow";
  SI.ReynoldsNumber Re_l=max(1, mdot_A*d_hyd/max(MIN, IN_var.eta_l))
    "Reynolds number based on liquid flow";
  SI.WeberNumber We_l=max(MIN, mdot_A^2*d_hyd/max(MIN, IN_var.sigma*IN_var.rho_l))
    "Weber number based on liquid flow";

  //SOURCE_1: p.490 (Appendix): Smoothing for sudden change from assumed laminar to assumed turbulent regime (numerical improvement at Re=1055)
  SI.ReynoldsNumber Re_lam_max=1025
    "Maximum Reynolds number assuming laminar regime";
  SI.ReynoldsNumber Re_turb_min=1075
    "Minimum Reynolds number assuming turbulent regime";

  //SOURCE_2: p.Lbb 2, eq. 9-10: Considering influence of Reynolds number on Darcy friction factor for smooth straight pipes
  //Correlation based on neglection of surface roughness
  //Correlation based on assumption that total mass flow rate is flowing as gas
  TYP.DarcyFrictionFactor lambda_lam_g=64/Re_g
    "Darcy friction factor of gas for assumed laminar regime";
  TYP.DarcyFrictionFactor lambda_turb_g=1/max(MIN, 0.86859*log(max(1, Re_g/max(
      MIN, 1.964*log(Re_g) - 3.8215))))^(2)
    "Darcy friction factor of gas for assumed turbulent regime";
  TYP.DarcyFrictionFactor lambda_g=lambda_lam_g*SMOOTH(
      Re_lam_max,
      Re_turb_min,
      Re_g) + lambda_turb_g*SMOOTH(
      Re_turb_min,
      Re_lam_max,
      Re_g) "Darcy friction factor of gas for overall regime";
  //Correlation based on assumption that total mass flow rate is flowing as liquid
  TYP.DarcyFrictionFactor lambda_lam_l=64/Re_l
    "Darcy friction factor of liquid for assumed laminar regime";
  TYP.DarcyFrictionFactor lambda_turb_l=1/max(MIN, 0.86859*log(max(1, Re_l/max(
      MIN, 1.964*log(Re_l) - 3.8215))))^(2)
    "Darcy friction factor of liquid for assumed turbulent regime";
  TYP.DarcyFrictionFactor lambda_l=lambda_lam_l*SMOOTH(
      Re_lam_max,
      Re_turb_min,
      Re_l) + lambda_turb_l*SMOOTH(
      Re_turb_min,
      Re_lam_max,
      Re_l) "Darcy friction factor of liquid for overall regime";

  Real A=(1 - x_flow)^2 + x_flow^2*(IN_var.rho_l/max(MIN, IN_var.rho_g))*(
      lambda_g/max(MIN, lambda_l)) "Summand for two phase multiplier";

  //SOURCE_1: p.490 (Appendix): Two phase multiplier for vertical downflow for future usage
  // Timm Hoppe, 21.2.2013: Dead Code.

//   Real phi_vdo=A + 38.5*x_flow^0.76*(1 - x_flow)^0.314*(IN_var.rho_l/max(MIN,
//       IN_var.rho_g))^0.86*(IN_var.eta_g/max(MIN, IN_var.eta_l))^0.73*(1 -
//       IN_var.eta_g/max(MIN, IN_var.eta_l))^6.84*(1/Fr_l^(0.0001))*(1/We_l^(
//       0.087));

  //SOURCE_1: p.490 (Appendix): Two phase multiplier for horizontal and vertical upflow (failure in SOURCE_2)
  // Timm Hoppe, 21.02.2013: Introduced another guard for IN_var.rho_g.

  Real phi_vup=A + 3.43*x_flow^0.685*(1 - x_flow)^0.24*(max(IN_var.rho_l/max(MIN,
      IN_var.rho_g), MIN))^0.8*(max(IN_var.eta_g/max(MIN, IN_var.eta_l),MIN))^0.22*(max(1 - IN_var.eta_g
      /max(MIN, IN_var.eta_l),MIN))^0.89*(1/Fr_l^(0.048))*(1/We_l^(0.0334));

//   Real phi_vup=A + 3.43*x_flow^0.685*(1 - x_flow)^0.24*(IN_var.rho_l/max(MIN,
//       IN_var.rho_g))^0.8*(IN_var.eta_g/max(MIN, IN_var.eta_l))^0.22*(1 - IN_var.eta_g
//       /max(MIN, IN_var.eta_l))^0.89*(1/Fr_l^(0.048))*(1/We_l^(0.0334));

algorithm
  phi := phi_vup;

      annotation (Inline=false);
end TwoPhaseMultiplierFriedel;
