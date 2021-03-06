within FluidDissipation.Examples.Verifications.HeatTransfer.Channel;
model kc_evenGapOverall_KC "Verification of function kc_evenGapOverall_KC"

  parameter Integer n=size(cp, 1);
  parameter SI.Diameter d_hyd=2*s;

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

  //target variables
  //here: mass flow rate as input for normal calculation
  /*SI.MassFlowRate mflow_test=input_mflow_0.y;
  SI.MassFlowRate m_flow[:]={mflow_test*eta[1]/eta[3],mflow_test*eta[2]/eta[3],
      mflow_test} "mass flow rate" annotation (Dialog(group="Input"));
  SI.NusseltNumber Nu[n]={kc[i]*d_hyd/lambda[i] for i in 1:n};*/

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
  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con m_flow_IN_con_1[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.DevOne)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow_1,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con m_flow_IN_con_2[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.DevBoth)
              annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_var m_flow_IN_var_2[n](
    m_flow=m_flow_2,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con m_flow_IN_con_3[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.UndevOne)
              annotation (Placement(transformation(extent={{10,20},{30,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_var m_flow_IN_var_3[n](
    m_flow=m_flow_3,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_con m_flow_IN_con_4[n](
    each h=0.6,
    each s=0.5,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.UndevBoth)
              annotation (Placement(transformation(extent={{60,20},{80,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_IN_var m_flow_IN_var_4[n](
    m_flow=m_flow_4,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{80,20},{100,40}})));

  SI.ReynoldsNumber Re_1[n]={abs(m_flow_1[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_2[n]={abs(m_flow_2[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_3[n]={abs(m_flow_3[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};
  SI.ReynoldsNumber Re_4[n]={abs(m_flow_4[i])*d_hyd/(eta[i]*Modelica.Constants.pi
      *d_hyd*d_hyd/4) for i in 1:n};

  /*Modelica.Blocks.Sources.Ramp input_mflow(
    duration=1000,
    height=1000,
    offset=0) annotation ( Placement(transformation(
          extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(amplitude=100, freqHz=1/100) 
    annotation ( Placement(transformation(extent={{
            -40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1) annotation (Placement(
        transformation(extent={{0,-80},{20,-60}})));*/

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e4 - 10,
    offset=1.1e1) annotation (Placement(
        transformation(extent={{50,-80},{70,-60}})));
equation
  //heat transfer calculation
  kc_OUT_1 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};

  kc_OUT_2 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_KC(
    m_flow_IN_con_2[i], m_flow_IN_var_2[i]) for i in 1:n};

  kc_OUT_3 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_KC(
    m_flow_IN_con_3[i], m_flow_IN_var_3[i]) for i in 1:n};

  kc_OUT_4 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapOverall_KC(
    m_flow_IN_con_4[i], m_flow_IN_var_4[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/channel/kc_evenGapOverall_KC.mos"
        "Verification of kc_evenGapOverall_KC"),Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Heat transfer of EVEN GAP for OVERALL flow regime (inlining)"),
          Text(
          extent={{-160,7},{40,2}},
          lineColor={0,0,255},
          textString="Target == DevOne "),Text(
          extent={{-120,7},{80,2}},
          lineColor={0,0,255},
          textString="Target == DevBoth"),Text(
          extent={{-82,7},{118,2}},
          lineColor={0,0,255},
          textString="Target == UndevOne"),Text(
          extent={{-40,7},{160,2}},
          lineColor={0,0,255},
          textString="Target == UndevBoth"),Text(
          extent={{-100,-104},{100,36}},
          lineColor={0,0,255},
          textString=
            "Target == DevOne >>>>>> DEVELOPED fluid flow AND heat transfer at ONE side"),
          Text(
          extent={{-100,-104},{100,26}},
          lineColor={0,0,255},
          textString=
            "Target == DevBoth >>>> DEVELOPED fluid flow AND heat transfer at BOTH sides"),
          Text(
          extent={{-100,-104},{100,16}},
          lineColor={0,0,255},
          textString=
            "Target == UndevOne >>>> UNDEVELOPED fluid flow AND heat transfer at ONE side"),
          Text(
          extent={{-100,-104},{100,6}},
          lineColor={0,0,255},
          textString="Target == UndevBoth >> UNDEVELOPED fluid flow AND heat transfer at BOTH sides"),
                                                 Text(
          extent={{-100,-24},{100,1}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}),
    experiment(StopTime=1.01));
end kc_evenGapOverall_KC;
