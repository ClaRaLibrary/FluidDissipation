within FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase;
function kc_twoPhase_boilingHorizontal "Local two phase heat transfer coefficient of straight pipe | horizontal boiling"
  extends Modelica.Icons.Function;
  //SOURCE_1: Bejan,A.: HEAT TRANSFER HANDBOOK, Wiley, 2003.
  //SOURCE_2: Gungor, K.E. and R.H.S. Winterton: A general correlation for flow boiling in tubes and annuli, Int.J. Heat Mass Transfer, Vol.29, p.351-358, 1986.

  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //records
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowHT_IN_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowHT_IN_var IN_var
    annotation (Dialog(group="Variable inputs"));

  output SI.CoefficientOfHeatTransfer kc "Local two phase heat transfer coefficient";
  output SI.CoefficientOfHeatTransfer kc_FC "Local heat transfer coefficient due to forced convection";
  output SI.CoefficientOfHeatTransfer kc_PB "Local heat transfer coefficient due to nucleate pool boiling";
  output Real E;
  output Real recXtt "1/X_tt";
protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, IN_con.A_cross) "Cross sectional area";
  SI.Diameter d_hyd=max(MIN, 4*A_cross/max(MIN, IN_con.perimeter)) "Hydraulic diameter";

  Real mdot_A=abs(IN_var.m_flow)/A_cross "Mass flux";
  Real x_flow=max(0, min(1, abs(IN_var.x_flow))) "Mass flow rate quality";
  Real p_red=max(MIN, abs(IN_var.pressure)/max(MIN, abs(IN_con.p_crit))) "Reduced pressure";

  //SOURCE_1: p.674, sec. 9.8.3: Considering nucleate and convective boiling w.r.t. equation of Gungor-Winterton
  SI.MassFlowRate mdot_l=abs(IN_var.m_flow)*(1 - x_flow) "Mass flow rate of liquid only";
  SI.Velocity velocity_l=mdot_l/max(MIN, IN_var.rho_l*A_cross) "Mean velocity assuming liquid mass flow rate flows alone";
  SI.ReynoldsNumber Re_l=max(1, IN_var.rho_l*velocity_l*d_hyd/max(MIN, IN_var.eta_l)) "Reynolds number assuming liquid mass flow rate flows alone";
  SI.PrandtlNumber Pr_l=abs(IN_var.eta_l*IN_var.cp_l/max(MIN, IN_var.lambda_l)) "Prandtl number assuming liquid mass flow rate flows alone";
  //SOURCE_1: p.352, sec. Nomenclature: Considering effect of stratification w.r.t. Froude number
  SI.FroudeNumber Fr_l=abs(mdot_A^2/max(MIN, IN_var.rho_l^2*9.81*d_hyd)) "Froude number assuming (total) mass flux flowing as liquid";

  //SOURCE_1: p.674, eq. 9.98: Considering effect of heat flux on nucleate boiling with Boiling number
  //Boiling number (Bo) is defined as ratio of actual heat flux to maximum heat flux necessary for complete evaporation of liquid
  Real Bo=abs(IN_var.qdot_A)/(max(MIN, mdot_A*IN_var.dh_lg)) "Boiling number";
  //SOURCE_1: p.673, eq. 9.94: Considering of Martinelli parameter w.r.t. equation of Chen
  Real X_tt=abs(((1 - x_flow)/max(MIN, x_flow))^0.9*(IN_var.rho_g/max(MIN,
      IN_var.rho_l))^0.5*(IN_var.eta_l/max(MIN, IN_var.eta_g))^0.1) "Martinelli parameter";

  //SOURCE_1: p.675, eq. 9.105: Considering of convection enhancement factor w.r.t. equation of Gungor-Winterton
  Real E_fc=1 + 24000*Bo^1.16 + 1.37*(1/max(MIN, X_tt))^0.86 "Enhancement factor for forced convection";
  //SOURCE_1: p.675, eq. 9.105: Considering of boiling suppression factor w.r.t. equation of Gungor-Winterton
  Real S_nb=1/max(MIN, 1 + 1.15e-6*E_fc^2*Re_l^1.17) "Suppression factor for nucleate boiling";
  //SOURCE_1: p.680, eq. 9.123: Considering correction of convection enhancement factor for horizontal pipes
  Real E_fc_hor=SMOOTH(
        0.049,
        0.051,
        Fr_l)*Fr_l^max(0, 0.1 - 2*Fr_l) + SMOOTH(
        0.051,
        0.049,
        Fr_l) "Correction of enhancement factor for forced convection in horizontal pipes";
  //SOURCE_1: p.680, eq. 9.124: Considering correction of boiling suppression factor for horizontal pipes
  Real S_nb_hor=SMOOTH(
        0.049,
        0.051,
        Fr_l)*Fr_l^0.5 + SMOOTH(
        0.051,
        0.049,
        Fr_l) "Correction of suppression factor for nucleate boiling in horizontal pipes";

  //SOURCE_1: p.672, eq. 9.91: Considering effect of forced convective boiling ew.r.t. equation of Dittus-Boelter
  SI.CoefficientOfHeatTransfer kc_fc=0.023*Re_l^0.8*Pr_l^0.4*(IN_var.lambda_l
      /d_hyd) "Convective heat transfer coefficient assuming liquid mass flow rate only";
  //SOURCE_1: p.675, eq. 9.107: Considering effect of nucleate boiling w.r.t. equation of Cooper
  SI.CoefficientOfHeatTransfer kc_nb=55*p_red^0.12*(1/max(MIN,
      Modelica.Math.log10(1/p_red))^0.55)*(1/max(MIN, IN_con.MM^0.5))*abs(
      IN_var.qdot_A)^0.67 "Nucleate boiling heat transfer coefficient";

  //SOURCE_2: p.354, sec. final equations: Calculation of two phase heat transfer coefficient for horizontal pipes w.r.t. equation of Gungor-Winterton
algorithm
  kc_FC :=E_fc*E_fc_hor*kc_fc;
  kc_PB :=S_nb*S_nb_hor*kc_nb;
  kc := E_fc*E_fc_hor*kc_fc + S_nb*S_nb_hor*kc_nb;
  E:=E_fc*E_fc_hor;
  recXtt:=1/max(1e-3,X_tt);
                             annotation (Inline=false, smoothOrder=5);
end kc_twoPhase_boilingHorizontal;
