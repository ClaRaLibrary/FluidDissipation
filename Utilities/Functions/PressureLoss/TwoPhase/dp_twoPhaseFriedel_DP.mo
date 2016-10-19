within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function dp_twoPhaseFriedel_DP
  "Frictional pressure loss of straight pipe for two phase flow according to Friedel correlation | calculate pressure loss| overall flow regime"
  extends Modelica.Icons.Function;
  //SOURCE_1: Friedel,L.:IMPROVED FRICTION PRESSURE DROP CORRELATIONS FOR HORIZONTAL AND VERTICAL TWO PHASE PIPE FLOW, 3R International, Vol. 18, Issue 7, pp. 485-491, 1979
  //SOURCE_2: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;
  import SMOOTH2 = FluidDissipation.Utilities.Functions.General.SmoothPower;

  //records
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var IN_var
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  output SI.Pressure DP "Output for function dp_twoPhaseFriedel_DP";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, IN_con.A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, IN_con.perimeter))
    "Hydraulic diameter";

  Real mdot_A=abs(m_flow)/A_cross "Mass flux";
  SI.ReynoldsNumber Re_liq=max(1, mdot_A*d_hyd/max(MIN, IN_var.eta_l))
    "Reynolds number assuming (total) mass flux flowing as liquid";
  SI.ReynoldsNumber Re_lam_leave=1055
    "Maximum Reynolds number for laminar regime (1055)";
  SI.ReynoldsNumber Re_turb=1100
    "Minimum Reynolds number for turbulent regime (1100)";
  SI.ReynoldsNumber Re_smooth=m_flow/A_cross*d_hyd/max(MIN, abs(IN_var.eta_l))
    "Reynolds number for smoothing";
  TYP.DarcyFrictionFactor lambda_FRI_lam=64/Re_liq
    "Darcy friction factor for laminar regime";
  TYP.DarcyFrictionFactor lambda_FRI_turb=(0.86859*Modelica.Math.log(max(1, (
      Re_liq/max(MIN, (1.964*Modelica.Math.log(Re_liq) - 3.8215))))))^(-2)
    "Darcy friction factor for turbulent regime";
  TYP.DarcyFrictionFactor lambda_FRI=lambda_FRI_lam*SMOOTH(
      Re_lam_leave,
      Re_turb,
      Re_liq) + lambda_FRI_turb*SMOOTH(
      Re_turb,
      Re_lam_leave,
      Re_liq);
  TYP.PressureLossCoefficient zeta_FRI=lambda_FRI*IN_con.length/d_hyd
    "Pressure loss coefficient";
  SI.Pressure DP_liq=zeta_FRI*mdot_A^2/(2*max(MIN, IN_var.rho_l))
    "Frictional pressure loss assuming (total) mass flux flowing as liquid";

algorithm
  DP := SMOOTH2(
    Re_smooth,
    1,
    0)*DP_liq*(
    FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.TwoPhaseMultiplierFriedel(
    IN_con,
    IN_var,
    m_flow));
  annotation (Inline=false);
end dp_twoPhaseFriedel_DP;
