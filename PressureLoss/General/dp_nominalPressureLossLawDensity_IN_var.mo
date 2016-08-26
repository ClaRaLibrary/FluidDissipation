within FluidDissipation.PressureLoss.General;
record dp_nominalPressureLossLawDensity_IN_var "Input record for function dp_nominalPressureLossLawDensity, dp_nominalPressureLossLawDensity_DP and dp_nominalPressureLossLawDensity_MFLOW"

  //generic variables
  extends FluidDissipation.Utilities.Records.General.NominalPressureLossLawDensity_var;

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(
    final cp=0,
    final eta=0,
    final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity\"> dp_nominalPressureLosslawDensity </a>,
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_DP\"> dp_nominalPressureLosslawDensity_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_MFLOW\"> dp_nominalPressureLosslawDensity_MFLOW </a>.
</html>"));
end dp_nominalPressureLossLawDensity_IN_var;
