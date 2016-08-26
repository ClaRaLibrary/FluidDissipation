within FluidDissipation.Examples.Verifications.HeatTransfer.HelicalPipe;
model kc_overall "Verification of function kc_overall"

  parameter Integer n=size(cp, 1);

  //helical pipe variables
  parameter SI.Diameter d_hyd=0.02;
  parameter SI.Length L=10 "Total length of helical pipe";
  parameter SI.Length h=1.5*d_hyd "Distance between turns";

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
  FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_IN_con m_flow_IN_con_1[n](
    each d_hyd=d_hyd,
    each L=L,
    each h=h,
    each n_nt=n_nt[1])
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_IN_con m_flow_IN_con_2[n](
    each d_hyd=d_hyd,
    each L=L,
    each h=h,
    each n_nt=n_nt[2])
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_IN_var m_flow_IN_var_2[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{0,20},{20,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_IN_con m_flow_IN_con_3[n](
    each d_hyd=d_hyd,
    each L=L,
    each h=h,
    each n_nt=n_nt[3])
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_overall_IN_var m_flow_IN_var_3[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{60,20},{80,40}})));

  //output variables
  SI.ReynoldsNumber Re_1[n] "Reynolds number"
    annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_1[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_2[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_3[n] "Nussel number" annotation (Dialog(group="Output"));

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    duration=1,
    offset=1e-5,
    height=1e3) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(amplitude=100, freqHz=1)
    annotation (Placement(transformation(extent={{
            -40,-80},{-20,-60}})));

  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1) annotation (Placement(
        transformation(extent={{0,-80},{20,-60}})));

protected
  constant Real MIN=Modelica.Constants.eps;

  parameter Real frac_dtoL=d_hyd/L;
  parameter Real frac_dhydTodcoil[n]={0.012,0.049,0.098};
  parameter Real d_coil[n]={d_hyd/frac_dhydTodcoil[i] for i in 1:n};
  parameter Real d_w[n]={sqrt((d_coil[i])^2 + (h/PI)^2) for i in 1:n};
  parameter Real n_nt[n]={L/(d_w[i]*PI) for i in 1:n};

  SI.ReynoldsNumber Re=Re_1[1] "Reynolds number";
  SI.PrandtlNumber Pr[n]={eta[i]*cp[i]/lambda[i] for i in 1:n} "Prandtl number";

equation
  //heat transfer calculation
  for i in 1:n loop
    (,,Re_1[i],Nu_1[i],) = FluidDissipation.HeatTransfer.HelicalPipe.kc_overall(
      m_flow_IN_con_1[i], m_flow_IN_var_1[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_2[i],) = FluidDissipation.HeatTransfer.HelicalPipe.kc_overall(
      m_flow_IN_con_2[i], m_flow_IN_var_2[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_3[i],) = FluidDissipation.HeatTransfer.HelicalPipe.kc_overall(
      m_flow_IN_con_3[i], m_flow_IN_var_3[i]);
  end for;

  annotation (
    __Dymola_Commands(file="modelica://FluidDissipation/Extras/Scripts/heatTransfer/helicalPipe/kc_overall.mos" "Verification of kc_overall"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of helical pipe for OVERALL flow regime"),
          Text(
          extent={{-78,19},{-40,10}},
          lineColor={0,0,255},
          textString="number of turns n_nt = 1"),Text(
          extent={{-16,19},{22,10}},
          lineColor={0,0,255},
          textString="number of turns n_nt = 5"),Text(
          extent={{40,19},{78,10}},
          lineColor={0,0,255},
          textString="number of turns n_nt = 10")}),
    experiment(Interval=0.00002, Tolerance=1e-007),
    __Dymola_experimentSetupOutput(events=false));
end kc_overall;
