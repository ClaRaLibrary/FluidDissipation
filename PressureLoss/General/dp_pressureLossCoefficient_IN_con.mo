within FluidDissipation.PressureLoss.General;
record dp_pressureLossCoefficient_IN_con "Input record for function dp_pressureLossCoefficient, dp_pressureLossCoefficient_DP and dp_pressureLossCoefficient_MFLOW"
  extends Modelica.Icons.Record;

  //generic variables
  SI.Area A_cross=Modelica.Constants.pi*0.1^2/4 "Cross sectional area"
    annotation (Dialog(group="Generic variables"));

  //linearisation
  SI.Pressure dp_smooth=1 "Start linearisation for decreasing pressure loss"
    annotation (Dialog(group="Linearisation"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient\"> dp_pressureLossCoefficient </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP\"> dp_pressureLossCoefficient_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW\"> dp_pressureLossCoefficient_MFLOW </a>.
</html>"));
end dp_pressureLossCoefficient_IN_con;
