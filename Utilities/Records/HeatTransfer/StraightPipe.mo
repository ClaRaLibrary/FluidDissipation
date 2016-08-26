within FluidDissipation.Utilities.Records.HeatTransfer;
record StraightPipe "Input for straight pipe"
  extends Modelica.Icons.Record;

  //choices
  FluidDissipation.Utilities.Types.HeatTransferBoundary target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuDFF "Choice of heat transfer boundary condition"
    annotation (Dialog(group="Choices"));
  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered "Choice of considering surface roughness"
    annotation (Dialog(group="Choices"));

  SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="Straight pipe"));
  SI.Length K=0 "Roughness (average height of surface asperities)" annotation (
      Dialog(group="Straight pipe", enable=roughness == FluidDissipation.Utilities.Types.Roughness.considered));
  SI.Length L=1 "Length" annotation (Dialog(group="Straight pipe"));
end StraightPipe;
