within FluidDissipation.PressureLoss.Valve;
record dp_severalGeometryOverall_IN_con
  "Input record for function dp_severalGeometryOverall, dp_severalGeometryOverall_DP and dp_severalGeometryOverall_MFLOW"

  extends Modelica.Icons.Record;

  FluidDissipation.Utilities.Types.ValveGeometry geometry=FluidDissipation.Utilities.Types.ValveGeometry.Ball
    "Choice of geometry for valve" annotation (Dialog(group="Valve", enable=if
          not (valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.OP)
           then true else false));
  FluidDissipation.Utilities.Types.ValveCoefficient valveCoefficient=
      FluidDissipation.Utilities.Types.ValveCoefficient.AV
    "Choice of valve coefficient" annotation (Dialog(group="Valve"));

  //valve variables
  Real Av=PI*0.1^2/4 "Av (metric) flow coefficient [Av]=m^2" annotation (Dialog(
        group="Valve", enable=if valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.AV then
                true else false));
  Real Kv=Av/27.7e-6 "Kv (metric) flow coefficient [Kv]=m^3/h" annotation (
      Dialog(group="Valve", enable=if valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.KV then
                true else false));
  Real Cv=Av/24.6e-6 "Cv (US) flow coefficient [Cv]=USG/min" annotation (Dialog(
        group="Valve", enable=if valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.CV then
                true else false));
  SI.Pressure dp_nominal=1e3 "Nominal pressure loss" annotation (Dialog(group=
          "Valve", enable=if valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.OP then
                true else false));
  SI.MassFlowRate m_flow_nominal=opening_nominal*Av*(rho_nominal*dp_nominal)^
      0.5 "Nominal mass flow rate" annotation (Dialog(group="Valve", enable=if
          valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.OP then
                true else false));
  SI.Density rho_nominal=1e3 "Nominal inlet density" annotation (Dialog(group=
          "Valve", enable=if valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.OP then
                true else false));
  Real opening_nominal=0.5 "Nominal opening" annotation (Dialog(group="Valve",
        enable=if valveCoefficient == FluidDissipation.Utilities.Types.ValveCoefficient.OP then
                true else false));
  Real zeta_tot_min=1e-3 "Minimal pressure loss coefficient at full opening"
    annotation (Dialog(group="Valve"));
  Real zeta_tot_max=1e8 "Maximum pressure loss coefficient at closed opening"
    annotation (Dialog(group="Valve"));

  //numerical aspects
  SI.Pressure dp_small=0.01*dp_nominal
    "Linearisation for a pressure loss smaller then dp_small"
    annotation (Dialog(group="Linearisation"));

  annotation (Documentation(info="<html>
This record is used as <b> input record </b> for the pressure loss function <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall\"> dp_severalGeometryOverall </a>, 
<a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP\"> dp_severalGeometryOverall_DP </a> and 
<a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW\"> dp_severalGeometryOverall_MFLOW </a>.
</html>"));
end dp_severalGeometryOverall_IN_con;
