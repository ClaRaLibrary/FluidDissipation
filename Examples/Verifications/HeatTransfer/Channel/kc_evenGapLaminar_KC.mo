within FluidDissipation.Examples.Verifications.HeatTransfer.Channel;
model kc_evenGapLaminar_KC "Verification of function kc_evenGapLaminar_KC"

  parameter Integer n=size(cp, 1);
  parameter SI.Diameter d_hyd=2*s;

  //even gap variables
  parameter SI.Length h=0.1 "Height of cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length s=0.05 "Distance between parallel plates in cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length L=1 "Overflowed length of gap"
    annotation (Dialog(group="Geometry"));

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550} "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114} "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387} "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu[n]=ones(n)*input_Nu.y;
  SI.MassFlowRate m_flow_1[n](start=ones(n)*1e-3);
  SI.MassFlowRate m_flow_2[n](start=ones(n)*1e-3);
  SI.MassFlowRate m_flow_3[n](start=ones(n)*1e-3);
  SI.MassFlowRate m_flow_4[n](start=ones(n)*1e-3);
  SI.CoefficientOfHeatTransfer kc_OUT_1[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_OUT_2[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_OUT_3[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_OUT_4[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};

  //input record
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_1[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.DevOne)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow_1,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_2[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.DevBoth)
              annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_2[n](
    m_flow=m_flow_2,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_3[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.UndevOne)
              annotation (Placement(transformation(extent={{10,20},{30,40}})));
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_3[n](
    m_flow=m_flow_3,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_4[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.UndevBoth)
              annotation (Placement(transformation(extent={{60,20},{80,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_4[n](
    m_flow=m_flow_4,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{80,20},{100,40}})));

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e4 - 10,
    offset=1.1e1) annotation (Placement(
        transformation(extent={{50,-80},{70,-60}})));

  SI.ReynoldsNumber Re_1[n]={abs(m_flow_1[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_2[n]={abs(m_flow_2[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_3[n]={abs(m_flow_3[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_4[n]={abs(m_flow_4[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};

equation
  //heat transfer calculation
  kc_OUT_1 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};

  kc_OUT_2 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC(
    m_flow_IN_con_2[i], m_flow_IN_var_2[i]) for i in 1:n};

  kc_OUT_3 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC(
    m_flow_IN_con_3[i], m_flow_IN_var_3[i]) for i in 1:n};

  kc_OUT_4 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_KC(
    m_flow_IN_con_4[i], m_flow_IN_var_4[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/channel/kc_evenGapLaminar_KC.mos" "Verification of kc_evenGapLaminar_KC"),
                                                Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Heat transfer of EVEN GAP for LAMINAR flow regime (inlining)"),
          Text(extent={{-158,9},{42,4}},
          lineColor={0,0,255},
          textString="Target == DevOne "),Text(
          extent={{-118,9},{82,4}},
          lineColor={0,0,255},
          textString="Target == DevBoth"),Text(
          extent={{-80,9},{120,4}},
          lineColor={0,0,255},
          textString="Target == UndevOne"),Text(
          extent={{-38,9},{162,4}},
          lineColor={0,0,255},
          textString="Target == UndevBoth"),Text(
          extent={{-98,-102},{102,38}},
          lineColor={0,0,255},
          textString=
            "Target == DevOne >>>>>> DEVELOPED fluid flow AND heat transfer at ONE side"),
          Text(
          extent={{-98,-102},{102,28}},
          lineColor={0,0,255},
          textString=
            "Target == DevBoth >>>> DEVELOPED fluid flow AND heat transfer at BOTH sides"),
          Text(
          extent={{-98,-102},{102,18}},
          lineColor={0,0,255},
          textString=
            "Target == UndevOne >>>> UNDEVELOPED fluid flow AND heat transfer at ONE side"),
          Text(
          extent={{-98,-102},{102,8}},
          lineColor={0,0,255},
          textString="Target == UndevBoth >> UNDEVELOPED fluid flow AND heat transfer at BOTH sides"),
                                                 Text(
          extent={{-100,-24},{100,1}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}),
    experiment(StopTime=1.01));
end kc_evenGapLaminar_KC;
