within FluidDissipation.Utilities.Records.PressureLoss;
record PressureLossInput "Input for pressure loss calculation"
  extends Modelica.Icons.Record;

  //target variables
  FluidDissipation.Utilities.Types.PressureLossTarget target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss "Target variable of calculation"
                                     annotation (Dialog(group="Input"));

  SI.Pressure dp=0 "Pressure loss" annotation (Dialog(group="Input", enable=
          target == FluidDissipation.Utilities.Types.PressureLossTarget.pressureLoss));
  SI.MassFlowRate m_flow=0 "Mass flow rate" annotation (Dialog(group="Input",
        enable=target == FluidDissipation.Utilities.Types.PressureLossTarget.massFlowRate));

end PressureLossInput;
