within FluidDissipation.PressureLoss.Bend;
record dp_edgedOverall_IN_var
  "Input record for function dp_edgedOverall, dp_edgedOverall_DP and  dp_edgedOverall_MFLOW"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);
  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the  pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall\"> dp_edgedOverall </a>,
<a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP\"> dp_edgedOverall_DP </a> and
<a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_MFLOW\"> dp_edgedOverall_MFLOW </a>.
</html>"));
end dp_edgedOverall_IN_var;
