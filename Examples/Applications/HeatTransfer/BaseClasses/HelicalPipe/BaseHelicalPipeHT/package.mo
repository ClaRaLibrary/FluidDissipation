within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HelicalPipe;
package BaseHelicalPipeHT "Base package for all heat transfer functions of a helical pipe"
extends FluidDissipation.Utilities.Icons.BaseLibrary;


replaceable partial function coefficientOfHeatTransfer
  "base function for helical pipes"
  extends Modelica.Icons.Function;

  //input record for helical pipe
  input
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HelicalPipe.BaseHelicalPipeHT.HeatTransferHelicalPipe_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  input
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HelicalPipe.BaseHelicalPipeHT.HeatTransferHelicalPipe_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //convective heat transfer coefficient as output
  output SI.CoefficientOfHeatTransfer kc "convective heat transfer coefficient";

end coefficientOfHeatTransfer;

end BaseHelicalPipeHT;
