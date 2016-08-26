within FluidDissipation.PressureLoss.General;
record dp_volumeFlowRate_IN_con "Input record for function dp_volumeFlowRate, dp_volumeFlowRate_DP and dp_volumeFlowRate_MFLOW"

  //generic variables
  extends FluidDissipation.Utilities.Records.General.QuadraticVFLOW;

  SI.Pressure dp_min=0.1 "Start of approximation for decreasing pressure loss";

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate\"> dp_volumeFlowRate </a>,
 <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_DP\"> dp_volumeFlowRate_DP </a> and 
 <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_volumeFlowRate_MFLOW\"> dp_volumeFlowRate_MFLOW </a>.
</html>"));

end dp_volumeFlowRate_IN_con;
