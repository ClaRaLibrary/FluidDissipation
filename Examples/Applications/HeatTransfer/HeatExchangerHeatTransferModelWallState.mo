within FluidDissipation.Examples.Applications.HeatTransfer;
model HeatExchangerHeatTransferModelWallState "Application model for a heat exchanger requiring wall states in Modelica_Fluid"

  //icon
  extends FluidDissipation.Utilities.Icons.HeatTransfer.HeatExchanger_i;

  //interfaces
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort "Thermal port"
                   annotation (Placement(transformation(extent={{-20,60},{20,80}},
          rotation=0), iconTransformation(extent={{-20,100},{20,120}})));

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (Dialog(group="Fluid properties"),
      choicesAllMatching=true);

  //choice for heat exchanger heat transfer model
  replaceable model HeatTransfer =
      FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTubeBundle.RoundTubeBundleHeatTransferModel
    constrainedby FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT.BaseHeatExchangerModelWallState "1st: choose heat transfer calculation | 2nd: edit corresponding record"
    annotation (Dialog(group="Heat transfer"), choicesAllMatching=true);

  //input
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //instance of chosen heat transfer model
  HeatTransfer heatTransferModel(
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    T=T,
    cp_w=cp_w,
    eta_w=eta_w,
    lambda_w=lambda_w) annotation (Placement(transformation(extent={{-18,-18},{18,18}})));

  //thermodynamic state from (missing) volume
  //outer Medium.ThermodynamicState state;
  outer FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer stateForHeatTransfer;
  outer FluidDissipation.Examples.TestCases.HeatTransfer.StateForHeatTransfer stateForHeatTransferWall;

  //fluid properties
protected
  SI.SpecificHeatCapacityAtConstantPressure cp=Medium.heatCapacity_cp(
      stateForHeatTransfer.state);
  SI.DynamicViscosity eta=Medium.dynamicViscosity(stateForHeatTransfer.state);
  SI.ThermalConductivity lambda=Medium.thermalConductivity(stateForHeatTransfer.state);
  SI.Density rho=Medium.density(stateForHeatTransfer.state);
  SI.Temp_K T=Medium.temperature(stateForHeatTransfer.state);
  SI.SpecificHeatCapacityAtConstantPressure cp_w=Medium.heatCapacity_cp(
      stateForHeatTransferWall.state);
  SI.DynamicViscosity eta_w=Medium.dynamicViscosity(stateForHeatTransferWall.state);
  SI.ThermalConductivity lambda_w=Medium.thermalConductivity(stateForHeatTransferWall.state);
equation
  connect(heatTransferModel.thermalPort, thermalPort) annotation (Line(
      points={{0,19.8},{0,70}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-150,-114},{150,-154}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
    Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Removed erroneous temperature offset.</p>
</html>"));
end HeatExchangerHeatTransferModelWallState;
