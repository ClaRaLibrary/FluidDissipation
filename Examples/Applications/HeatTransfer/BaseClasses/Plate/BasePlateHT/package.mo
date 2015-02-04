within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate;
package BasePlateHT "Base package for all heat transfer functions of a plate"
extends FluidDissipation.Utilities.Icons.BaseLibrary;
import FD =
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT;


replaceable partial function coefficientOfHeatTransfer
  "base function for plate"
  extends Modelica.Icons.Function;

  //input record for plates
  input
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT.HeatTransferPlate_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  input
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT.HeatTransferPlate_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //convective heat transfer coefficient as output
  output SI.CoefficientOfHeatTransfer kc "convective heat transfer coefficient";

end coefficientOfHeatTransfer;

end BasePlateHT;
