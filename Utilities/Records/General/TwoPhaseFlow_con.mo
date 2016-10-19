within FluidDissipation.Utilities.Records.General;
record TwoPhaseFlow_con "Base record for two phase Flow"
  extends Modelica.Icons.Record;

  SI.Area A_cross=PI*0.1^2/4 "Cross sectional area"
    annotation (Dialog(group="Geometry"));
  SI.Length perimeter=PI*0.1 "Wetted perimeter"
    annotation (Dialog(group="Geometry"));
  SI.Length length=1 "Length in fluid flow direction"
    annotation (Dialog(group="Geometry"));

end TwoPhaseFlow_con;
