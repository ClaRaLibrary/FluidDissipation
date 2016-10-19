within FluidDissipation.Utilities.Records.HeatTransfer;
record EvenGap "Input for even gap"
  extends Modelica.Icons.Record;

  //choices
  FluidDissipation.Utilities.Types.kc_evenGap target=FluidDissipation.Utilities.Types.kc_evenGap.DevBoth
    "Target variable of calculation" annotation (Dialog(group="Even gap"));

  SI.Length h=0.1 "Height of cross sectional area"
    annotation (Dialog(group="Even gap"));
  SI.Length s=0.05 "Distance between parallel plates in cross sectional area"
    annotation (Dialog(group="Even gap"));
  SI.Length L=1 "Overflowed length of gap" annotation (Dialog(group="Even gap"));
end EvenGap;
