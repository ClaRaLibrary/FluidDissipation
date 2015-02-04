within FluidDissipation.PressureLoss.StraightPipe;
record dp_twoPhaseOverall_IN_var
  "Input record for function dp_twoPhaseOverall_DP"

  Real x_flow_end=0 "Mass flow rate quality at end of length"
    annotation (Dialog(group="Fluid properties"));
  Real x_flow_sta=0 "Mass flow rate quality at start of length"
    annotation (Dialog(group="Fluid properties"));
  extends FluidDissipation.Utilities.Records.General.TwoPhaseFlow_var(final
      x_flow=(x_flow_end + x_flow_sta)/2);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_DP\"> dp_twoPhaseOverall_DP </a>.
</html>"));

end dp_twoPhaseOverall_IN_var;
