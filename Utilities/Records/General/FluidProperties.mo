within FluidDissipation.Utilities.Records.General;
record FluidProperties "Base record for fluid properties"
  extends Modelica.Icons.Record;

  SI.SpecificHeatCapacityAtConstantPressure cp=4.19e3
    "Specific heat capacity of fluid at constant pressure"
    annotation (Dialog(group="Fluid properties"));
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid"
    annotation (Dialog(group="Fluid properties"));
  SI.ThermalConductivity lambda=0.58 "Thermal conductivity of fluid"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho=1e3 "Density of fluid"
    annotation (Dialog(group="Fluid properties"));
end FluidProperties;
