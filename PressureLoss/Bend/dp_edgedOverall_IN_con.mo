within FluidDissipation.PressureLoss.Bend;
record dp_edgedOverall_IN_con "Input record for function dp_edgedOverall, dp_edgedOverall_DP and  dp_edgedOverall_MFLOW"

  //bend variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Bend(final R_0=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the  pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall\"> dp_edgedOverall </a>,
<a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP\"> dp_edgedOverall_DP </a> and
<a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_edgedOverall_MFLOW\"> dp_edgedOverall_MFLOW </a>.
</html>"));
end dp_edgedOverall_IN_con;
