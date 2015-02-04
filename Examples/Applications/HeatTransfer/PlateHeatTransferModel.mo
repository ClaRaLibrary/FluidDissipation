within FluidDissipation.Examples.Applications.HeatTransfer;
model PlateHeatTransferModel "Application model for a plate in Modelica_Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.Plate_i;

  //interfaces
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort
    "Thermal port" annotation (Placement(transformation(extent={{-20,60},{20,80}},
          rotation=0)));

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (Dialog(group="Fluid properties"), choicesAllMatching=true);

  //heat transfer calculation
  replaceable package HeatTransfer =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.Overall
    constrainedby
    FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT
    "Characteristic of convective heat transfer" annotation (Dialog(group=
          "Heat transfer"), choicesAllMatching=true);

  //plate
  parameter SI.Length length=1 "Length of plate"
    annotation (Dialog(group="Plate"));
  parameter SI.Length width=1 "Width of plate"
    annotation (Dialog(group="Plate"));

  //input
  input SI.Velocity velocity "fluid flow velocity around plate"
    annotation (Dialog(group="Input"));

  //target
  Real kc "mean convective heat transfer coefficient for plate";
  SI.HeatFlowRate Q_flow=thermalPort.Q_flow "heat flow rate over boundary";

  //thermodynamic state from (missing) volume
  //outer Medium.ThermodynamicState state;
  outer FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer stateForHeatTransfer;

  //input records
  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT.HeatTransferPlate_con
    IN_con(L=length)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.Plate.BasePlateHT.HeatTransferPlate_var
    IN_var(
    eta=eta,
    lambda=lambda,
    rho=rho,
    velocity=velocity)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //For information
  SI.Area A_kc=length*width "Convective heat transfer area";

  //fluid properties
protected
  SI.SpecificHeatCapacityAtConstantPressure cp=Medium.heatCapacity_cp(
      stateForHeatTransfer.state);
  SI.DynamicViscosity eta=Medium.dynamicViscosity(stateForHeatTransfer.state);
  SI.ThermalConductivity lambda=Medium.thermalConductivity(stateForHeatTransfer.state);
  SI.Density rho=Medium.density(stateForHeatTransfer.state);
  SI.Temp_K T=Medium.temperature(stateForHeatTransfer.state);

  SI.ReynoldsNumber Re=rho*velocity*length/eta;
  SI.NusseltNumber Nu=kc*length/lambda;

equation
  kc = HeatTransfer.coefficientOfHeatTransfer(IN_con, IN_var);

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
end PlateHeatTransferModel;
