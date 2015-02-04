within FluidDissipation.PressureLoss.Orifice;
record dp_thickEdgedOverall_IN_var
  "Input record for function dp_thickEdgedOverall, dp_thickEdgedOverall_DP and dp_thickEdgedOverall_MFLOW"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(final cp=0,
      final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss functions <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall\"> dp_thickEdgedOverall </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP\"> dp_thickEdgedOverall_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_MFLOW\"> dp_thickEdgedOverall_MFLOW </a>.
</html>"));
end dp_thickEdgedOverall_IN_var;
