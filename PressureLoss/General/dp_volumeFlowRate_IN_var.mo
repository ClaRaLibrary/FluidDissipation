within FluidDissipation.PressureLoss.General;
record dp_volumeFlowRate_IN_var "Input record for function dp_volumeFlowRate, dp_volumeFlowRate_DP and dp_volumeFlowRate_MFLOW"

  //fluid property variables
  extends FluidDissipation.Utilities.Records.General.FluidProperties(
    final cp=0,
    final eta=0,
    final lambda=0);

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate\"> dp_volumeFlowRate </a>,
 <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP\"> dp_volumeFlowRate_DP </a> and 
 <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_MFLOW\"> dp_volumeFlowRate_MFLOW </a>.
</html>"));

end dp_volumeFlowRate_IN_var;
