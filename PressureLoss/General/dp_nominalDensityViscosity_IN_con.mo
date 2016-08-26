within FluidDissipation.PressureLoss.General;
record dp_nominalDensityViscosity_IN_con "Output record for function dp_nominalDensityViscosity, dp_nominalDensityViscosity_DP and dp_nominalDensityViscosity_MFLOW"

  //generic variables
  extends FluidDissipation.Utilities.Records.General.NominalDensityViscosity;

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity\"> dp_nominalDensityViscosity </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_DP\"> dp_nominalDensityViscosity_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalDensityViscosity_MFLOW\"> dp_nominalDensityViscosity_MFLOW </a>.
</html>"));
end dp_nominalDensityViscosity_IN_con;
