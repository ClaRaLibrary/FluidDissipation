within FluidDissipation.Utilities.Records.PressureLoss;
record Bend "Input for bend"
  extends Modelica.Icons.Record;

  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered "Choice of considering surface roughness"
                                              annotation (Dialog(group="Bend"));

  SI.Angle delta=90*PI/180 "Angle of turning" annotation (Dialog(group="Bend"));
  SI.Diameter d_hyd(min=Modelica.Constants.eps) = 0.1 "Hydraulic diameter"
    annotation (Dialog(group="Bend"));
  SI.Length K=0 "Roughness (average height of surface asperities)" annotation (
      Dialog(group="Bend", enable=roughness == FluidDissipation.Utilities.Types.Roughness.considered));
  SI.Length L=10*d_hyd "Length of the straight starting section before the bend"
    annotation (Dialog(group="Bend"));
  SI.Radius R_0=0.5*d_hyd "Curvature radius" annotation (Dialog(group="Bend"));

end Bend;
