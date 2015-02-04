within FluidDissipation.HeatTransfer.HeatExchanger;
record kc_tubeBundle_1ph_IN_var
  "Input record for function kc_tubeBundle_1ph and kc_tubeBundle_1ph_KC"
 extends FluidDissipation.Utilities.Records.General.FluidProperties;

  //Not relevant in this case and not needed for always one-phase systems. Stefan Wischhusen.
  //Real x = 0 "Steam Fraction of fluid" annotation (Dialog(group="Fluid properties"));

  SI.SpecificHeatCapacityAtConstantPressure cp_w=4.19e3
    "Specific heat capacity of fluid near wall at constant pressure"
    annotation (Dialog(group="Fluid properties near wall"));
  SI.DynamicViscosity eta_w=1e-3 "Dynamic viscosity of fluid near wall"
    annotation (Dialog(group="Fluid properties near wall"));
  SI.ThermalConductivity lambda_w=0.58
    "Thermal conductivity of fluid  near wall"
    annotation (Dialog(group="Fluid properties near wall"));

  //input variable (mass flow rate)
  SI.MassFlowRate m_flow annotation (Dialog(group="Input"));
end kc_tubeBundle_1ph_IN_var;
