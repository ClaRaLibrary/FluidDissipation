within FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase;
function kc_twoPhase_condensationHorizontal_KC
  "Local two phase heat transfer coefficient of straight pipe | horizontal condensation"
  extends Modelica.Icons.Function;
  //SOURCE_1: M.M. Shah. A general correlation for heat transfer during film condensation inside pipes.Int. J. Heat Mass Transfer, Vol.22, p.547-556, 1979.

  //records
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowHT_IN_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowHT_IN_var IN_var
    annotation (Dialog(group="Variable inputs"));

  output SI.CoefficientOfHeatTransfer kc
    "Local two phase heat transfer coefficient";

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, IN_con.A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, IN_con.perimeter))
    "Hydraulic diameter";

  Real x_flow=max(0, min(1, abs(IN_var.x_flow))) "Mass flow rate quality";
  Real p_red=max(MIN, abs(IN_var.pressure)/max(MIN, abs(IN_con.p_crit)))
    "Reduced pressure";

  SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho_l*A_cross)
    "Mean velocity";
  SI.ReynoldsNumber Re_l=max(1, IN_var.rho_l*velocity*d_hyd/max(MIN, IN_var.eta_l))
    "Reynolds number assuming (total) mass flux flowing as liquid";
  SI.PrandtlNumber Pr_l=abs(IN_var.eta_l*IN_var.cp_l/max(MIN, IN_var.lambda_l))
    "Prandtl number assuming (total) mass flux flowing as liquid";

  //SOURCE_1: p.548, eq. 8: Considering two phase multiplier for condensation w.r.t. Shah
  SI.CoefficientOfHeatTransfer kc_1ph=0.023*Re_l^0.8*Pr_l^0.4*IN_var.lambda_l
      /d_hyd;

algorithm
  kc := kc_1ph*((1 - x_flow)^0.8 + 3.8*x_flow^0.76*(1 - x_flow)^0.04/p_red^
    0.38);
  annotation (Inline=false, smoothOrder=5);
end kc_twoPhase_condensationHorizontal_KC;
