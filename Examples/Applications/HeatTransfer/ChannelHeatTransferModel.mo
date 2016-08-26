within FluidDissipation.Examples.Applications.HeatTransfer;
model ChannelHeatTransferModel "Application model for a channel in Modelica_Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.Channel_i;

  //interfaces
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort "Thermal port"
                   annotation (Placement(transformation(extent={{-20,60},{20,80}},
          rotation=0)));

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (Dialog(group="Fluid properties"),
      choicesAllMatching=true);

  //heat transfer calculation
  replaceable package HeatTransferLam =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.Laminar
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.Laminar "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Laminar), choicesAllMatching=
        true);

  replaceable package HeatTransferOver =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.Overall
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.Overall "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Overall), choicesAllMatching=
        true);

  replaceable package HeatTransferTurb =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.Turbulent
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.Turbulent "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Turbulent), choicesAllMatching=
        true);

  //channel
  parameter FluidDissipation.Utilities.Types.kc_evenGap target=FluidDissipation.Utilities.Types.kc_evenGap.DevOne "Target variable of calculation (only for laminar regime)"
                                                               annotation (
      Dialog(group="Even gap", enable=if fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Laminar
           or fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Overall
           then true else false));
  parameter FluidDissipation.Utilities.Types.FluidFlowRegime fluidFlowRegime=
      FluidDissipation.Utilities.Types.FluidFlowRegime.Overall "Choice of fluid flow regime"
                                  annotation (Dialog(group="Heat transfer"));
  parameter SI.Length h=0.1 "Height of cross sectional area"
    annotation (Dialog(group="Even gap"));
  parameter SI.Length s=0.01 "Distance between parallel plates in cross sectional area"
    annotation (Dialog(group="Even gap"));
  parameter SI.Length L=1 "Overflowed length of gap"
    annotation (Dialog(group="Even gap"));

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
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.BaseChannelHT.HeatTransferChannel_con
    IN_con(
    target=target,
    h=h,
    s=s,
    L=L) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Channel.BaseChannelHT.HeatTransferChannel_var
    IN_var(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //For information
  SI.Diameter d_hyd=2*s "Hydraulic diameter of (finite) gap";
  SI.Area A_kc=2*(s+h)*L "Heat transfer area for convective heat transfer coefficient (kc)";
  SI.Area A_cross=s*h "cross sectional area";

  //fluid properties
protected
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
  if fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Laminar then
    kc = HeatTransferLam.coefficientOfHeatTransfer(IN_con, IN_var);
  elseif fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Overall then
    kc = HeatTransferOver.coefficientOfHeatTransfer(IN_con, IN_var);
  elseif fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Turbulent then
    kc = HeatTransferTurb.coefficientOfHeatTransfer(IN_con, IN_var);
  else
    kc = 0;
    assert(true, "Fluid flow regime is not selected");
  end if;

  //heat transfer rate is negative if outgoing out of system
  thermalPort.Q_flow = kc*A_kc*(thermalPort.T - T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-40,-70},{40,-110}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Removed erroneous temperature offset.</p>
</html>"));
end ChannelHeatTransferModel;
