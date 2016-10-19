within FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase;
function kc_twoPhase_boilingVertical_KC
  "Local two phase heat transfer coefficient of straight pipe | vertical boiling"
  extends Modelica.Icons.Function;
  //SOURCE_1: Bejan,A.: HEAT TRANSFER HANDBOOK, Wiley, 2003.
  //SOURCE_2: Gungor, K.E. and R.H.S. Winterton: A general correlation for flow boiling in tubes and annuli, Int.J. Heat Mass Transfer, Vol.29, p.351-358, 1986.

  //records
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowHT_IN_con IN_con
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowHT_IN_var IN_var
    annotation (Dialog(group="Variable inputs"));

  output SI.CoefficientOfHeatTransfer kc
    "Local two phase heat transfer coefficient";


algorithm
  (kc,,,,) := kc_twoPhase_boilingHorizontal(IN_con, IN_var);
  annotation (Inline=false, smoothOrder=5,
    Documentation(revisions="<html>
<pre>2016-06-06 Stefan Wischhusen: Removed double code (now just in kc_twoPhase_boilingVertical)</pre>
</html>"));
end kc_twoPhase_boilingVertical_KC;
