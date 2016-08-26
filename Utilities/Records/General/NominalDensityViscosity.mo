within FluidDissipation.Utilities.Records.General;
record NominalDensityViscosity "Base record for generic pressure loss function"

  extends Modelica.Icons.Record;

  SI.Pressure dp_nom=2 "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  SI.MassFlowRate m_flow_nom=1 "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  SI.Density rho_nom=1e3 "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));
  Real exp_eta=1 "Exponent for dynamic viscosity dependence"
    annotation (Dialog(group="Generic variables"));
  SI.DynamicViscosity eta_nom=1e-3 "Dynamic viscosity at nominal pressure loss"
    annotation (Dialog(group="Generic variables"));

end NominalDensityViscosity;
