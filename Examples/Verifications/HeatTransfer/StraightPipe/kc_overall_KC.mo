within FluidDissipation.Examples.Verifications.HeatTransfer.StraightPipe;
model kc_overall_KC "Verification of function kc_mean_overall_KC"
  parameter Integer n=size(cp, 1);

  //straight pipe variables
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter";
  parameter SI.Length L=1 "Length of straight pipe";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550}
    "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114}
    "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387}
    "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu[n]=ones(n)*input_Nu.y;
  SI.MassFlowRate m_flow_1[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_2[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_3[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_4[3](start=ones(n)*1e-6);

  SI.CoefficientOfHeatTransfer kc_1[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_2[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_3[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_4[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};

  //input record
  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con m_flow_IN_con_1[3](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuDFF,
    each roughness=FluidDissipation.Utilities.Types.Roughness.Considered)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var m_flow_IN_var_1[3](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con m_flow_IN_con_2[3](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UHFuDFF,
    each roughness=FluidDissipation.Utilities.Types.Roughness.Considered)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var m_flow_IN_var_2[3](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_2)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con m_flow_IN_con_3[3](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UWTuUFF,
    each roughness=FluidDissipation.Utilities.Types.Roughness.Considered)
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var m_flow_IN_var_3[3](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_3)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con m_flow_IN_con_4[3](
    each d_hyd=d_hyd,
    each L=L,
    each target=FluidDissipation.Utilities.Types.HeatTransferBoundary.UHFuUFF,
    each roughness=FluidDissipation.Utilities.Types.Roughness.Considered)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var m_flow_IN_var_4[3](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_4)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  SI.ReynoldsNumber Re_1[n]={abs(m_flow_1[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};
  SI.ReynoldsNumber Re_2[n]={abs(m_flow_2[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};
  SI.ReynoldsNumber Re_3[n]={abs(m_flow_3[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};
  SI.ReynoldsNumber Re_4[n]={abs(m_flow_4[i])*d_hyd/(eta[i]*PI*d_hyd^2/4) for i in
          1:n};

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e4,
    offset=5) annotation (Placement(transformation(
          extent={{52,-80},{72,-60}})));

equation
  //heat transfer calculation
  kc_1 = {FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};
  kc_2 = {FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC(
    m_flow_IN_con_2[i], m_flow_IN_var_2[i]) for i in 1:n};
  kc_3 = {FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC(
    m_flow_IN_con_3[i], m_flow_IN_var_3[i]) for i in 1:n};
  kc_4 = {FluidDissipation.HeatTransfer.StraightPipe.kc_overall_KC(
    m_flow_IN_con_4[i], m_flow_IN_var_4[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/straightPipe/kc_overall_KC.mos"
        "Verification of kc_overall_KC"), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of straight pipe for OVERALL flow regime "),
          Text(
          extent={{-98,-50},{102,-25}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)"),
          Text(
          extent={{-102,12},{-56,4}},
          lineColor={0,0,255},
          textString="UWT+DFF"),Text(
          extent={{-52,18},{-6,10}},
          lineColor={0,0,255},
          textString="UHF + DFF"),Text(
          extent={{6,10},{52,2}},
          lineColor={0,0,255},
          textString="UWT+UFF"),Text(
          extent={{56,18},{102,10}},
          lineColor={0,0,255},
          textString="UHF + UFF")}));
end kc_overall_KC;
