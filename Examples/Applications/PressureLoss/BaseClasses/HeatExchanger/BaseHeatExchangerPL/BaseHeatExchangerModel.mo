within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.HeatExchanger.BaseHeatExchangerPL;
partial model BaseHeatExchangerModel
  "Base flow model for heat exchanger functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=false, final
      allowFlowReversal=true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.HeatExchanger_i;

equation
  dp = dp_tot;
end BaseHeatExchangerModel;
