within FluidDissipation.Utilities.Records.PressureLoss;
record Orifice "Input for orifice"

  extends Modelica.Icons.Record;

  SI.Area A_0=0.1*A_1 "Cross sectional area of vena contraction"
    annotation (Dialog(group="Orifice"));
  SI.Area A_1=PI*0.01^2/4 "Small cross sectional area of orifice"
    annotation (Dialog(group="Orifice"));
  SI.Area A_2=A_1 "Large cross sectional area of orifice"
    annotation (Dialog(group="Orifice"));
  SI.Length C_0=0.1*C_1 "Perimeter of vena contraction"
    annotation (Dialog(group="Orifice"));
  SI.Length C_1=PI*0.01 "Small perimeter of orifice"
    annotation (Dialog(group="Orifice"));
  SI.Length C_2=C_1 "Large perimeter of orifice"
    annotation (Dialog(group="Orifice"));
  SI.Length K=0 "roughness == average height of surface asperities"
    annotation (Dialog(group="Orifice"));
  SI.Length L=1e-3 "Length of vena contraction"
    annotation (Dialog(group="Orifice"));
end Orifice;
