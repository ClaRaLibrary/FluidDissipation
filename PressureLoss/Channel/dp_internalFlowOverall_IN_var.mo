within FluidDissipation.PressureLoss.Channel;
record dp_internalFlowOverall_IN_var
  "Input record for function dp_internalFlowOverall"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall\"> dp_internalFlowOverall </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_DP\"> dp_internalFlowOverall_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_MFLOW\"> dp_internalFlowOverall_MFLOW </a>.
</html>"));
end dp_internalFlowOverall_IN_var;
