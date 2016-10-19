within FluidDissipation.Utilities.Records.HeatTransfer;
record TwoPhaseFlowHT_IN_var
  "Base record for two phase heat transfer coefficient"
  extends Modelica.Icons.Record;

//   //choices
//   FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget target=
//       FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor "Choice of (horizontal/vertical) boiling or (horizontal) condensation in pipe"
//     annotation (Dialog(group="Choices"));

  //fluid properties
  SI.SpecificHeatCapacityAtConstantPressure cp_l=4.19e3
    "Specific heat capacity of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.ThermalConductivity lambda_l=0.58 "Thermal conductivity of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho_g=1.1220 "Density of gas" annotation (Dialog(group=
          "Fluid properties", enable=if target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor
           or target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilVer then
                true else false));
  SI.Density rho_l=943.11 "Density of liquid"
    annotation (Dialog(group="Fluid properties"));
  SI.DynamicViscosity eta_g=12.96e-6 "Dynamic viscosity of gas" annotation (
      Dialog(group="Fluid properties", enable=if target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor
           or target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilVer then
                true else false));
  SI.DynamicViscosity eta_l=232.1e-6 "Dynamic viscosity of liquid"
    annotation (Dialog(group="Fluid properties"));

  SI.Pressure pressure=2e5 "Mean pressure of fluid"
    annotation (Dialog(group="Fluid properties"));
  SI.SpecificEnthalpy dh_lg=2202.08e3 "Evaporation enthalpy of fluid"
    annotation (Dialog(group="Fluid properties", enable=if target ==
          FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor
           or target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilVer then
                true else false));

  //input variables
  SI.MassFlowRate m_flow "Mass flow rate" annotation (Dialog(group="Input"));
  SI.HeatFlux qdot_A=0 "Heat flux at boiling" annotation (Dialog(group="Input",
        enable=if target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilHor
           or target == FluidDissipation.Utilities.Types.TwoPhaseHeatTransferTarget.BoilVer then
                true else false));

  Real x_flow=0 "Mass flow rate quality" annotation (Dialog(group="Input"));
  annotation (Documentation(revisions="<html>
<pre>2016-04-13 Stefan Wischhusen: Removed obsolete target.</pre>
</html>"));
end TwoPhaseFlowHT_IN_var;
