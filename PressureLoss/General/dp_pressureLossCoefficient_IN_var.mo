within FluidDissipation.PressureLoss.General;
record dp_pressureLossCoefficient_IN_var "Input record for function dp_pressureLossCoefficient, dp_pressureLossCoefficient_DP and dp_pressureLossCoefficient_MFLOW"
  extends Modelica.Icons.Record;

  //generic variables
  TYP.PressureLossCoefficient zeta_TOT=0.02*1/0.1 "Pressure loss coefficient"
    annotation (Dialog(group="Generic variables"));

  //fluid property variables
  SI.Density rho=1e3 "Density of fluid"
    annotation (Dialog(group="FluidProperties"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient\"> dp_pressureLossCoefficient </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP\"> dp_pressureLossCoefficient_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW\"> dp_pressureLossCoefficient_MFLOW </a>.
</html>"));
end dp_pressureLossCoefficient_IN_var;
