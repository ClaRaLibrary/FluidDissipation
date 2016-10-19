within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger;
package BaseHeatExchangerHT "Base package for all heat transfer functions of a heat exchanger"
  extends FluidDissipation.Utilities.Icons.BaseLibrary;


  replaceable partial function coefficientOfHeatTransfer
  "base function for heat Exchanger"
    extends Modelica.Icons.Function;

    //convective heat transfer coefficient as output
    output SI.CoefficientOfHeatTransfer kc
    "convective heat transfer coefficient";

  end coefficientOfHeatTransfer;

end BaseHeatExchangerHT;
