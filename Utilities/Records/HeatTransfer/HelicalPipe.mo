within FluidDissipation.Utilities.Records.HeatTransfer;
record HelicalPipe "Input for helical pipe"
  extends Modelica.Icons.Record;

  Real n_nt=1 "Total number of turns" annotation (Dialog(group="HelicalPipe"));
  SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="HelicalPipe"));
  SI.Length h=0.01 "Distance between turns"
    annotation (Dialog(group="HelicalPipe"));
  SI.Length L=1 "Total length of helical pipe"
    annotation (Dialog(group="HelicalPipe"));

end HelicalPipe;
