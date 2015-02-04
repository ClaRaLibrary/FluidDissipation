within FluidDissipation.Utilities.Records.General;
record TwoPhaseFlow_var "Base record for two phase flow"
  extends Modelica.Icons.Record;

  SI.Density rho_g=1.1220 "Density of gas"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho_l=943.11 "Density of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.DynamicViscosity eta_g=12.96e-6 "Dynamic viscosity of gas"
    annotation (Dialog(group="Fluid properties"));
  SI.DynamicViscosity eta_l=232.1e-6 "Dynamic viscosity of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.SurfaceTension sigma=54.97e-3 "Surface tension"
    annotation (Dialog(group="Fluid properties"));

  //input variables
  Real x_flow=0 "Mean mass flow rate quality over length"
    annotation (Dialog(group="Input"));
end TwoPhaseFlow_var;
