within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger;
partial package BaseHeatExchangerPL "Base package for all pressure loss functions of a heat exchanger"
  extends FluidDissipation.Utilities.Icons.BaseLibrary;


  replaceable partial function pressureLoss_mflow
    extends Modelica.Icons.Function;

    //pressure loss as output
    output SI.Pressure DP;

  end pressureLoss_mflow;

end BaseHeatExchangerPL;
