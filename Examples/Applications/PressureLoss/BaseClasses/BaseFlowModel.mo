within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses;
partial model BaseFlowModel
  "Base flow model for pressure loss functions in Modelica.Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.FlowModel;

  //interfaces
  extends Modelica.Fluid.Interfaces.PartialTwoPortTransport;

  // state record for fluid property computations
  Medium.ThermodynamicState state;

  //fluid properties
  parameter Boolean use_nominal=false
    "= true, if eta_nominal and rho_nominal are used, otherwise computed from medium"
    annotation (Evaluate=true, Dialog(group="Fluid properties"));
  parameter SI.DynamicViscosity eta_nominal=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Nominal dynamic viscosity (e.g. eta_liquidWater = 1e-3, eta_air = 1.8e-5)"
    annotation (Dialog(enable=use_nominal, group="Fluid properties"));
  parameter SI.Density rho_nominal=Medium.density_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)
    "Nominal density (e.g. d_liquidWater = 995, d_air = 1.2)"
    annotation (Dialog(enable=use_nominal, group="Fluid properties"));

  SI.Density rho_a=if use_nominal then rho_nominal else Medium.density(state_a);
  SI.Density rho_b=if use_nominal then rho_nominal else Medium.density(state_b);
  SI.Density rho=if use_nominal then rho_nominal else Medium.density(state);
  //SI.Density rho = (rho_a+rho_b)/2;

  SI.DynamicViscosity eta_a=if use_nominal then eta_nominal else
      Medium.dynamicViscosity(state_a);
  SI.DynamicViscosity eta_b=if use_nominal then eta_nominal else
      Medium.dynamicViscosity(state_b);
  SI.DynamicViscosity eta=if use_nominal then eta_nominal else
      Medium.dynamicViscosity(state);
  //SI.DynamicViscosity eta=(eta_a + eta_b)/2;

  parameter Boolean from_dp=true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Medium.AbsolutePressure dp_small=system.dp_small
    "Default small pressure drop for regularization of laminar and zero flow"
    annotation (Dialog(tab="Advanced"));

  // Has to be defined in top-level:
  SI.Pressure dp_tot "Total pressure difference";

equation
  //isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Fluid properties
  if allowFlowReversal then
    if from_dp then
      state = Medium.setSmoothState(
        dp_tot,
        state_a,
        state_b,
        dp_small);
    else
      state = Medium.setSmoothState(
        m_flow,
        state_a,
        state_b,
        m_flow_small);
    end if;
  else
    state = state_a;
    end if;

  annotation (Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics));
end BaseFlowModel;
