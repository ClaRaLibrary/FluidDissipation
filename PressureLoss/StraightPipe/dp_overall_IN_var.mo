within FluidDissipation.PressureLoss.StraightPipe;
record dp_overall_IN_var "Input record for function dp_overall, dp_overall_DP and dp_overall_MFLOW"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_overall\"> dp_overall </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_overall_DP\"> dp_overall_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_overall_MFLOW\"> dp_overall_MFLOW </a>.
</html>"));

end dp_overall_IN_var;
