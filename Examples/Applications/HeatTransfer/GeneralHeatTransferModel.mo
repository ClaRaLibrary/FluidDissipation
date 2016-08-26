within FluidDissipation.Examples.Applications.HeatTransfer;
model GeneralHeatTransferModel "Application model for a generic geometry in Modelica_Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.General_i;

  //interfaces
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort "Thermal port"
                   annotation (Placement(transformation(extent={{-20,60},{20,80}},
          rotation=0)));

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (Dialog(group="Fluid properties"),
      choicesAllMatching=true);

  //heat transfer calculation
  replaceable package HeatTransferTurb =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General.Turbulent
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General.Turbulent "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Turbulent), choicesAllMatching=
        true);

  //generic geometry
  FluidDissipation.Utilities.Types.kc_general target=FluidDissipation.Utilities.Types.kc_general.Finest "Target correlation"
                         annotation (Dialog(group="Generic geometry"));
  parameter SI.Area A_cross=Modelica.Constants.pi*0.1^2/4 "Cross sectional area"
                           annotation (Dialog(group="Generic geometry"));
  parameter SI.Length perimeter=Modelica.Constants.pi*0.1 "Wetted perimeter"
    annotation (Dialog(group="Generic geometry"));
  parameter Real exp_Pr=0.4 "Exponent for Prandtl number w.r.t. Dittus/Boelter | 0.4 for heating | 0.3 for cooling"
    annotation (Dialog(group="Generic geometry",enable=if target == FluidDissipation.Utilities.Types.kc_general.Rough then true else
                false));
  parameter SI.Length length=1 "Length"
    annotation (Dialog(group="Generic geometry"));
  SI.DynamicViscosity eta_wall=1e-3 "Dynamic viscosity of fluid at wall temperature"
                                                     annotation (Dialog(group=
          "Fluid properties", enable=if target == FluidDissipation.Utilities.Types.kc_general.Middle then true else false));

  //input
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //target
  Real kc "Mean convective heat transfer coefficient for channel";
  SI.HeatFlowRate Q_flow=thermalPort.Q_flow "Heat flow rate over boundary";

  //thermodynamic state from (missing) volume
  //outer Medium.ThermodynamicState state;
  outer FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer stateForHeatTransfer;

  //input records
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General.BaseGeneralHT.HeatTransferGeneral_con
    IN_con(
    target=target,
    A_cross=A_cross,
    perimeter=perimeter,
    exp_Pr=exp_Pr)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.General.BaseGeneralHT.HeatTransferGeneral_var
    IN_var(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    eta_wall=eta_wall,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //For information
  SI.Area A_kc=perimeter*length "Convective heat transfer area";
  SI.Diameter d_hyd=4*A_cross/perimeter "Hydraulic diameter";

protected
  FluidDissipation.Utilities.Types.FluidFlowRegime fluidFlowRegime=
      FluidDissipation.Utilities.Types.FluidFlowRegime.Turbulent "Choice of fluid flow regime"
                                  annotation (Dialog(group="Heat transfer"));

  SI.SpecificHeatCapacityAtConstantPressure cp=Medium.heatCapacity_cp(
      stateForHeatTransfer.state);
  SI.DynamicViscosity eta=Medium.dynamicViscosity(stateForHeatTransfer.state);
  SI.ThermalConductivity lambda=Medium.thermalConductivity(stateForHeatTransfer.state);
  SI.Density rho=Medium.density(stateForHeatTransfer.state);
  SI.Temp_K T=Medium.temperature(stateForHeatTransfer.state);

  SI.Velocity velocity=abs(m_flow)/max(Modelica.Constants.eps, (rho*A_cross)) "Mean velocity";
  SI.ReynoldsNumber Re=rho*velocity*d_hyd/eta;
  SI.NusseltNumber Nu=kc*d_hyd/lambda;

equation
  if fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Turbulent then
    kc = HeatTransferTurb.coefficientOfHeatTransfer(IN_con, IN_var);
  else
    kc = 0;
    assert(true, "Fluid flow regime is not selected");
  end if;

  //heat transfer rate is negative if outgoing out of system
  thermalPort.Q_flow = kc*A_kc*(thermalPort.T - T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-40,-70},{40,-110}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}), Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Removed erroneous temperature offset.</p>
</html>"));
end GeneralHeatTransferModel;
