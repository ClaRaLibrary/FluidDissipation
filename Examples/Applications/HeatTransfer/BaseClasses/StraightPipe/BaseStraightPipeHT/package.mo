within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe;
package BaseStraightPipeHT "Base package for all heat transfer functions of a straight pipe"
extends FluidDissipation.Utilities.Icons.BaseLibrary;


replaceable partial function coefficientOfHeatTransfer
  "base function for straight pipe"

  //input record for straight pipe
  input
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.BaseStraightPipeHT.HeatTransferStraightPipe_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  input
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.BaseStraightPipeHT.HeatTransferStraightPipe_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //convective heat transfer coefficient as output
  output SI.CoefficientOfHeatTransfer kc "convective heat transfer coefficient";

end coefficientOfHeatTransfer;

end BaseStraightPipeHT;
