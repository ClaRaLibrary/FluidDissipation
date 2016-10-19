within FluidDissipation.PressureLoss.General;
record dp_idealGas_IN_con
  "Input record for function dp_idealGas, dp_idealGas_DP and dp_idealGas_MFLOW"

  //generic variables
  extends FluidDissipation.Utilities.Records.General.IdealGas_con;

  //linearisation
  SI.Pressure dp_smooth(min=Modelica.Constants.eps) = 1
    "Start linearisation for smaller pressure loss"
    annotation (Dialog(group="Linearisation"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_idealGas\"> dp_idealGas </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_idealGas_DP\"> dp_idealGas_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_idealGas_MFLOW\"> dp_idealGas_MFLOW </a>.
</html>"));

end dp_idealGas_IN_con;
