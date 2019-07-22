within FluidDissipation.Examples.Verifications.HeatTransfer.Channel;
model kc_evenGapTurbulent "Verification of function kc_evenGapTurbulent"

  parameter Integer n=size(cp, 1);
  parameter SI.Diameter d_hyd=2*s;

  SI.Velocity velocity[n]={m_flow[i]/(rho[i]*h*s) for i in 1:n};

  //even gap variables
  parameter SI.Length h=0.1 "Height of cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length s=0.05
    "Distance between parallel plates in cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length L=1 "Overflowed length of gap"
    annotation (Dialog(group="Geometry"));

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550}
    "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114}
    "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387}
    "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //input VARIABLES
  //create identical Reynolds number for different fluid properties >> adjustment of  mass flow rate
  SI.MassFlowRate m_flow[:]={mflow_test*eta[1]/eta[3],mflow_test*eta[2]/eta[3],
      mflow_test} "mass flow rate" annotation (Dialog(group="Input"));

  //input record
  FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_IN_con m_flow_IN_con_2[n](
    each h=h,
    each s=s,
    each L=L) annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_IN_var m_flow_IN_var_2[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{0,20},{20,40}})));

  //output variables
  SI.ReynoldsNumber Re_2[n] "Reynolds number"
    annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_2[n] "Nussel number" annotation (Dialog(group="Output"));

protected
  Real mflow_test=input_mflow_0.y;
public
  Modelica.Blocks.Sources.Ramp input_mflow_0(
    offset=0,
    duration=1,
    height=1e4) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(amplitude=1e4, freqHz=1)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    riseTime=1e-1,
    riseTimeConst=1e-1,
    outMax=1e4) annotation (Placement(
        transformation(extent={{0,-80},{20,-60}})));

equation
  //heat transfer calculation
  for i in 1:n loop
    (,,Re_2[i],Nu_2[i],) =
      FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent(m_flow_IN_con_2
      [i], m_flow_IN_var_2[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/channel/kc_evenGapTurbulent.mos"
        "Verification of kc_evenGapTurbulent"),Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of EVEN GAP for TURBULENT flow regime")}),
    experiment(StopTime=1.01));
end kc_evenGapTurbulent;
