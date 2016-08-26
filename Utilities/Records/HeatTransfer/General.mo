within FluidDissipation.Utilities.Records.HeatTransfer;
record General "Input for generic correlation"
  extends Modelica.Icons.Record;

  //choices
  FluidDissipation.Utilities.Types.kc_general target=FluidDissipation.Utilities.Types.kc_general.Finest "Target correlation"
                         annotation (Dialog(group="Generic variables"));

  //geometry
  SI.Area A_cross=Modelica.Constants.pi*0.1^2/4 "Cross sectional area"
    annotation (Dialog(group="Generic variables"));
  SI.Length perimeter=Modelica.Constants.pi*0.1 "Wetted perimeter"
    annotation (Dialog(group="Generic variables"));
end General;
