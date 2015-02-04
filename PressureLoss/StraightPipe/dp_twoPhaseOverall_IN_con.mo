within FluidDissipation.PressureLoss.StraightPipe;
record dp_twoPhaseOverall_IN_con
  "Input record for function dp_twoPhaseOverall_DP"

  //choices
  FluidDissipation.Utilities.Types.TwoPhaseFrictionalPressureLoss frictionalPressureLoss=
      FluidDissipation.Utilities.Types.TwoPhaseFrictionalPressureLoss.Friedel
    "Choice of frictional pressure loss approach"
    annotation (Dialog(group="Choices"));
  FluidDissipation.Utilities.Types.VoidFractionApproach voidFractionApproach=
      FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous
    "Choice of void fraction approach" annotation (Dialog(group="Choices"));

  Boolean momentumPressureLoss=false "Considering momentum pressure loss"
    annotation (Dialog(group="Choices"));
  Boolean massFlowRateCorrection=false
    "Consider heterogeneous mass flow rate correction" annotation (Dialog(group=
         "Choices", enable=if momentumPressureLoss then true else false));
  Boolean geodeticPressureLoss=false "Considering geodetic pressure loss"
    annotation (Dialog(group="Choices"));

  extends FluidDissipation.Utilities.Records.General.TwoPhaseFlow_con;
  SI.Angle phi=0 "Tilt angle to horizontal"
    annotation (Dialog(group="Geometry"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_DP\"> dp_twoPhaseOverall_DP </a>.
</html>"));

end dp_twoPhaseOverall_IN_con;
