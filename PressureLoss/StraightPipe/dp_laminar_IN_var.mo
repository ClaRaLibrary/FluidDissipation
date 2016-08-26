within FluidDissipation.PressureLoss.StraightPipe;
record dp_laminar_IN_var "Input record for function dp_laminar, dp_laminar_DP and dp_laminar_MFLOW"

  extends FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_var;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_laminar\"> dp_laminar </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_laminar_DP\"> dp_laminar_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_laminar_MFLOW\"> dp_laminar_MFLOW </a>.
</html>"));

end dp_laminar_IN_var;
