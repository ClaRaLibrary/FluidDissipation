within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT;
partial model BaseHeatExchangerModelWallState
  "Base heat transfer model with wall state for heat exchanger functions in Modelica.Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.HeatExchanger_i;

  extends BaseClasses.BaseHeatTransferModel;

    //fluid properties at wall
  input SI.SpecificHeatCapacityAtConstantPressure cp_w
    "Specific heat capacity of fluid at constant pressure at wall surface";
  input SI.DynamicViscosity eta_w "Dynamic viscosity of fluid at wall surface";
  input SI.ThermalConductivity lambda_w
    "Thermal conductivity of fluid at wall surface";
  SI.Temp_K T_w "Temperature of fluid at wall surface";

end BaseHeatExchangerModelWallState;
