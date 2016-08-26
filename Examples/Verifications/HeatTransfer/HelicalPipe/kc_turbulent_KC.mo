within FluidDissipation.Examples.Verifications.HeatTransfer.HelicalPipe;
model kc_turbulent_KC "Verification of function kc_turbulent_KC"
  import FluidDissipation;

  parameter Integer n=size(cp, 1);

  //helical pipe variables
  parameter Real n_nt[:]={1,5,10} "Total number of turns";

  parameter SI.Diameter d_hyd=0.01;
  parameter SI.Length L=10 "Total length of helical pipe";
  parameter SI.Length h=1.5*d_hyd "Distance between turns";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550} "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114} "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387} "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu[n]=ones(n)*input_Nu.y;
  SI.MassFlowRate m_flow_1[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_2[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_3[3](start=ones(n)*1e-6);

  SI.CoefficientOfHeatTransfer kc_1[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_2[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_3[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};

  //input record
  FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_IN_con m_flow_IN_con_1[
     n](
    each d_hyd=d_hyd,
    each L=L,
    each n_nt=n_nt[1],
    each h=h) annotation (Placement(transformation(
          extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_IN_var m_flow_IN_var_1[
     n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_1) annotation (Placement(
        transformation(extent={{-60,20},{-40,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_IN_con m_flow_IN_con_2[
     n](
    each d_hyd=d_hyd,
    each L=L,
    each h=h,
    each n_nt=n_nt[2]) annotation (Placement(
        transformation(extent={{-20,20},{0,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_IN_var m_flow_IN_var_2[
     n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_2) annotation (Placement(
        transformation(extent={{0,20},{20,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_IN_con m_flow_IN_con_3[
     n](
    each d_hyd=d_hyd,
    each L=L,
    each h=h,
    each n_nt=n_nt[3]) annotation (Placement(
        transformation(extent={{40,20},{60,40}})));

  FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_IN_var m_flow_IN_var_3[
     n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_3) annotation (Placement(
        transformation(extent={{60,20},{80,40}})));

  SI.ReynoldsNumber Re_1[n]={abs(m_flow_1[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};
  SI.ReynoldsNumber Re_2[n]={abs(m_flow_2[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};
  SI.ReynoldsNumber Re_3[n]={abs(m_flow_3[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e6,
    offset=5) annotation (Placement(transformation(
          extent={{50,-80},{70,-60}})));

equation
  //heat transfer calculation
  kc_1 = {FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};
  kc_2 = {FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_KC(
    m_flow_IN_con_2[i], m_flow_IN_var_2[i]) for i in 1:n};
  kc_3 = {FluidDissipation.HeatTransfer.HelicalPipe.kc_turbulent_KC(
    m_flow_IN_con_3[i], m_flow_IN_var_3[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/helicalPipe/kc_turbulent_KC.mos" "Verification of kc_turbulent_KC"),
                                            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Heat transfer of helical pipe for TURBULENT flow regime (inlining)"),
          Text(
          extent={{-100,-50},{100,-25}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)"),
          Text(
          extent={{-78,17},{-40,8}},
          lineColor={0,0,255},
          textString="number of turns n_nt = 1"),Text(
          extent={{-16,17},{22,8}},
          lineColor={0,0,255},
          textString="number of turns n_nt = 5"),Text(
          extent={{40,17},{78,8}},
          lineColor={0,0,255},
          textString="number of turns n_nt = 10")}));
end kc_turbulent_KC;
