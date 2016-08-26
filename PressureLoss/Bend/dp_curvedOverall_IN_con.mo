within FluidDissipation.PressureLoss.Bend;
record dp_curvedOverall_IN_con "Input record for function dp_curvedOverall, dp_curvedOverall_DP and dp_curvedOverall_MFLOW"

  //bend variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Bend;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall\"> dp_curvedOverall </a>,
<a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall_DP\"> dp_curvedOverall_DP </a>
and <a href=\"Modelica://FluidDissipation.PressureLoss.Bend.dp_curvedOverall_MFLOW\"> dp_curvedOverall_MFLOW </a>.
</html>"));
end dp_curvedOverall_IN_con;
