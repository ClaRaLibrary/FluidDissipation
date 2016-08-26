within FluidDissipation.Examples.Verifications.HeatTransfer.StraightPipe;
model kc_laminar "Verification of function kc_laminar"

  parameter Integer n=size(cp, 1);

  //straight pipe variables
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter";
  parameter SI.Length L=1 "Length of straight pipe";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550} "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114} "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387} "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //input VARIABLES
  SI.MassFlowRate m_flow[n]={input_mflow_0.y*eta[1]/eta[3],input_mflow_0.y*eta[
      2]/eta[3],input_mflow_0.y} "Mass flow rate"
    annotation (Dialog(group="Input"));

  //input record
  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con m_flow_IN_con_1[n](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuDFF)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var m_flow_IN_var_1[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con m_flow_IN_con_2[n](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UHFuDFF)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var m_flow_IN_var_2[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con m_flow_IN_con_3[n](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuUFF)
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var m_flow_IN_var_3[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con m_flow_IN_con_4[n](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UHFuUFF)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var m_flow_IN_var_4[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  //output variables
  SI.ReynoldsNumber Re_1[n] "Reynolds number"
    annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_1[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_2[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_3[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_4[n] "Nussel number" annotation (Dialog(group="Output"));

protected
  parameter Real frac_dtoL=d_hyd/L;

  SI.ReynoldsNumber Re=Re_1[1] "Reynolds number";
  SI.PrandtlNumber Pr[n]={eta[i]*cp[i]/lambda[i] for i in 1:n} "Prandtl number";

public
  Modelica.Blocks.Sources.Ramp input_mflow_0(
    duration=1,
    offset=0,
    startTime=0,
    height=100) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    amplitude=100,
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1) annotation (Placement(transformation(
          extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1,
    startTime=0) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));

equation
  for i in 1:n loop
    (,,Re_1[i],Nu_1[i],) =
      FluidDissipation.HeatTransfer.StraightPipe.kc_laminar(m_flow_IN_con_1[i],
      m_flow_IN_var_1[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_2[i],) = FluidDissipation.HeatTransfer.StraightPipe.kc_laminar(
      m_flow_IN_con_2[i], m_flow_IN_var_2[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_3[i],) = FluidDissipation.HeatTransfer.StraightPipe.kc_laminar(
      m_flow_IN_con_3[i], m_flow_IN_var_3[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_4[i],) = FluidDissipation.HeatTransfer.StraightPipe.kc_laminar(
      m_flow_IN_con_4[i], m_flow_IN_var_4[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/straightPipe/kc_laminar.mos" "Verification of kc_laminar"),
                                       Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of straight pipe for LAMINAR flow regime"),
          Text(
          extent={{-104,14},{-58,6}},
          lineColor={0,0,255},
          textString="UWT+DFF"),Text(
          extent={{-54,20},{-8,12}},
          lineColor={0,0,255},
          textString="UHF + DFF"),Text(
          extent={{6,12},{52,4}},
          lineColor={0,0,255},
          textString="UWT+UFF"),Text(
          extent={{56,20},{102,12}},
          lineColor={0,0,255},
          textString="UHF + UFF")}));
end kc_laminar;
