within FluidDissipation.Examples.Applications.HeatTransfer;
model StraightPipeHeatTransferModel "Application model for a straight pipe in Modelica_Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.StraightPipe_i;

  //interfaces
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort "Thermal port"
                   annotation (Placement(transformation(extent={{-20,60},{20,80}},
          rotation=0)));

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (Dialog(group="Fluid properties"), choicesAllMatching=true);

  //heat transfer calculation
  replaceable package HeatTransferLam =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.Laminar
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.Laminar "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Laminar), choicesAllMatching=
        true);
  replaceable package HeatTransferOver =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.Overall
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.Overall "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Overall), choicesAllMatching=
        true);
  replaceable package HeatTransferTurb =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.Turbulent
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.Turbulent "Characteristic of convective heat transfer"
                                                 annotation (Dialog(group=
          "Heat transfer", enable=fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Turbulent), choicesAllMatching=
        true);
  parameter FluidDissipation.Utilities.Types.FluidFlowRegime fluidFlowRegime=
      FluidDissipation.Utilities.Types.FluidFlowRegime.Overall "Choice of fluid flow regime"
                                  annotation (Dialog(group="Heat transfer"));

  //straightPipe
  parameter FluidDissipation.Utilities.Types.HeatTransferBoundary target=
      FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuDFF "Choice of heat transfer boundary condition"
                                                 annotation (Dialog(group=
          "Straight pipe", enable=if fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Laminar
           or fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Overall
           then true else false));
  parameter FluidDissipation.Utilities.Types.Roughness roughness=
      FluidDissipation.Utilities.Types.Roughness.Considered "Choice of considering surface roughness"
                                              annotation (Dialog(group=
          "Straight pipe", enable=if not (fluidFlowRegime == FluidDissipation.Utilities.Types.FluidFlowRegime.Laminar)
           then true else false));

  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="Straight pipe"));
  parameter SI.Length L=1 "Length" annotation (Dialog(group="Straight pipe"));

  //input
  input SI.MassFlowRate m_flow "mass flow rate"
    annotation (Dialog(group="Input"));

  //target
  Real kc "Mean convective heat transfer coefficient for StraightPipe";
  SI.HeatFlowRate Q_flow=thermalPort.Q_flow "Heat flow rate over boundary";

  //thermodynamic state from (missing) volume
  //outer Medium.ThermodynamicState state;
  outer FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer stateForHeatTransfer;

  //input records
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.BaseStraightPipeHT.HeatTransferStraightPipe_con
    IN_con(
    d_hyd=d_hyd,
    L=L,
    target=target,
    roughness=roughness)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.StraightPipe.BaseStraightPipeHT.HeatTransferStraightPipe_var
    IN_var(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  // For information
  SI.Area A_cross=PI*d_hyd^2/4 "Cross sectional area";
  SI.Area A_kc=PI*d_hyd*L "Convective heat transfer area";

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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-40,-70},{40,-110}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}), Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Removed erroneous temperature offset.</p>
</html>"));
end StraightPipeHeatTransferModel;
