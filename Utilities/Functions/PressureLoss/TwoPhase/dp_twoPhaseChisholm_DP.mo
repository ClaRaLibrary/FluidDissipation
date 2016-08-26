within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function dp_twoPhaseChisholm_DP "Frictional pressure loss of straight pipe for two phase flow according to Chisholm correlation | calculate pressure loss | overall flow regime"
  extends Modelica.Icons.Function;
  //SOURCE_1: Chisholm,D.:PRESSURE GRADIENTS DUE TO FRICTION DURING THE FLOW OF EVAPORATING TWO-PHASE MIXTURES IN SMOOTH TUBES AND CHANNELS, Int. J. Heat Mass Transfer, Vol. 16, pp. 347-358, Pergamon Press 1973

  //records
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var IN_var
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  output SI.Pressure DP "Output for function dp_twoPhaseChisholm_DP";

protected
  Real MIN=Modelica.Constants.eps;

  FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_con IN_con_1ph(
    final roughness=FluidDissipation.Utilities.Types.Roughness.Neglected,
    final d_hyd=4*abs(IN_con.A_cross)/max(MIN, abs(IN_con.perimeter)),
    final K=0,
    final L=abs(IN_con.length));

  FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_var IN_var_1ph(final eta=
       IN_var.eta_l, final rho=IN_var.rho_l);

algorithm
  DP := FluidDissipation.PressureLoss.StraightPipe.dp_overall_DP(
    IN_con_1ph,
    IN_var_1ph,
    m_flow)*(
    FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.TwoPhaseMultiplierChisholm(
    IN_con,
    IN_var,
    m_flow));
  annotation (Inline=false);
end dp_twoPhaseChisholm_DP;
