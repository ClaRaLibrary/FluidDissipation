within FluidDissipation.Utilities.Functions.General;
function PrandtlNumber "calculation of Prandtl number"
  extends Modelica.Icons.Function;
  import SI = Modelica.SIunits;
  import MIN = Modelica.Constants.eps;

  //fluid properties
  input SI.SpecificHeatCapacityAtConstantPressure cp "specific heat capacity of fluid at constant pressure";
  input SI.DynamicViscosity eta "dynamic viscosity of fluid";
  input SI.ThermalConductivity lambda "thermal conductivity of fluid";

  output SI.PrandtlNumber Pr "Prandtl number";

algorithm
  Pr := eta*cp/max(MIN, lambda);
  annotation (Inline=true, smoothOrder=1);
end PrandtlNumber;
