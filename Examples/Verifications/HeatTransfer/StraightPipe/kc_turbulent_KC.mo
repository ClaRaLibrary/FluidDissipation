within FluidDissipation.Examples.Verifications.HeatTransfer.StraightPipe;
model kc_turbulent_KC "Verification of function kc_turbulent_KC"

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

  //here: Nusselt number as input for reverse calculation
  SI.NusseltNumber Nu[n]=ones(n)*input_Nu.y;
  SI.MassFlowRate m_flow_1[3](start=ones(n));
  SI.MassFlowRate m_flow_2[3](start=ones(n));
  SI.CoefficientOfHeatTransfer kc[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};

  //input record
  FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_IN_con m_flow_IN_con_1[n](
    each d_hyd=d_hyd,
    each L=L,
    each roughness=FluidDissipation.Utilities.Types.Roughness.Neglected)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_IN_var m_flow_IN_var_1[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_IN_con m_flow_IN_con_2[n](
    each d_hyd=d_hyd,
    each L=L,
    each roughness=FluidDissipation.Utilities.Types.Roughness.Considered)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_IN_var m_flow_IN_var_2[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow_2)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  SI.ReynoldsNumber Re_1[n]={abs(m_flow_1[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_2[n]={abs(m_flow_2[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e4,
    offset=10)   annotation (Placement(
        transformation(extent={{50,-80},{70,-60}})));

equation
  //heat transfer calculation
  //neglecting surface roughness
  kc = {FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};

  //considered surface roughness
  kc = {FluidDissipation.HeatTransfer.StraightPipe.kc_turbulent_KC(
    m_flow_IN_con_2[i], m_flow_IN_var_2[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/straightPipe/kc_turbulent_KC.mos"
        "Verification of kc_turbulent_KC"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-100,5},{100,0}},
          lineColor={0,0,255},
          textString="Target: kc == f(m_flow)"),Text(
          extent={{-100,-50},{100,-25}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)"),
          Text(
          extent={{-100,52},{100,77}},
          lineColor={0,0,255},
          textString=
            "Heat transfer in straight pipe for turbulent flow regime considering surface roughness"),
        Text(
          extent={{-70,18},{-8,6}},
          lineColor={0,0,255},
          textString="Roughness == Neglected"),
        Text(
          extent={{10,18},{72,6}},
          lineColor={0,0,255},
          textString="Roughness == Considered")}));
end kc_turbulent_KC;
