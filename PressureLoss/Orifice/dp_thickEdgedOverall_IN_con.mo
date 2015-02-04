within FluidDissipation.PressureLoss.Orifice;
record dp_thickEdgedOverall_IN_con
  "Input record for function dp_thickEdgedOverall, dp_thickEdgedOverall_DP and dp_thickEdgedOverall_MFLOW"

  //orifice variables
  extends FluidDissipation.Utilities.Records.PressureLoss.Orifice(
    final A_2=A_1,
    final K=0,
    final C_2=C_1);

  //linearisation
  SI.Pressure dp_smooth(min=Modelica.Constants.eps) = 1
    "Start linearisation for decreasing pressure loss"
    annotation (Dialog(group="Linearisation"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss functions <a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall\"> dp_thickEdgedOverall </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP\"> dp_thickEdgedOverall_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_MFLOW\"> dp_thickEdgedOverall_MFLOW </a>.
</html>"));
end dp_thickEdgedOverall_IN_con;
