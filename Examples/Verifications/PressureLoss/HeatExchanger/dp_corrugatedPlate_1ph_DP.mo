within FluidDissipation.Examples.Verifications.PressureLoss.HeatExchanger;
model dp_corrugatedPlate_1ph_DP
  "Verification of function dp_corrugatedPlate_1ph_DP"
  parameter Integer n=5 "Number of various plate geometries";

  parameter Integer channels(min = 1) = 1
    "number of parallel channels per fluid";
  parameter Modelica.SIunits.Length Length(min=1e-2)=0.3
    "length of the heat exchanger plates in flow direction (header center to header center)";
  parameter Modelica.SIunits.Length Width(min=1e-2)=0.1
    "width of the heat exchanger plates in flow direction";
  parameter Modelica.SIunits.Length amp(min=1e-10)=2e-3
    "amplitude of corrugated plate";
  parameter Modelica.SIunits.Length Lambda(min=1e-10)=2*PI*
    amp "wave length of corrugated plate";
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg[n] phi={23,34,45,57,68}
      *PI/180 "Corrugation angle";

  Real a = 1.6 "Friction loss parameter (default value from literature)";
  Real b = 0.40 "Friction loss parameter (default value from literature)";
  Real c = 0.36 "Friction loss parameter (default value from literature)";

  //fluid property variables
  Modelica.SIunits.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  Modelica.SIunits.Density rho=1000 "Density of fluid";

  //input VARIABLES
  Modelica.SIunits.ReynoldsNumber Re=input_Re.y "Reynolds number"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow=abs(Re)*eta*A_c/D_h "mass flow"
    annotation (Dialog(group="Input"));

  //output variables
  Modelica.SIunits.Pressure DP[n] "Pressure loss in [bar]"
                                    annotation (Dialog(group="Output"));
  Real zeta_TOT[n]={2*abs(DP[i])/(max(rho*(w)^2, MIN)) for i in 1:n}
    "Pressure loss coefficients" annotation (Dialog(group="Output"));
  Real lambda_FRI[n]={zeta_TOT[i]*D_h/Length for i in 1:n}
    "Frictional resistance coefficient";

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

protected
  constant Real MIN=Modelica.Constants.eps;

  Modelica.SIunits.Velocity w=abs(Re)*eta/(rho*D_h) "Velocity";
  Modelica.SIunits.Area A_c=channels*2*amp*Width "Flow cross-sectional area";
  Modelica.SIunits.Length D_h=4*amp/Phi "Hydraulic diameter";

  Real X = 2*Modelica.Constants.pi*amp/Lambda "wave number";
  Real Phi = 1/6*(1+sqrt(1+X^2)+4*sqrt(1+0.5*X^2)) "area enhancement factor";

public
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_con
    m_flow_IN_con_1(
    channels=channels,
    Length=Length,
    Width=Width,
    amp=amp,
    phi=phi[1],
    a=a,
    b=b,
    c=c)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var
    m_flow_IN_var_1(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_con
    m_flow_IN_con_2(
    channels=channels,
    Length=Length,
    Width=Width,
    amp=amp,
    phi=phi[2],
    a=a,
    b=b,
    c=c)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var
    m_flow_IN_var_2(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    height=10000,
    offset=0) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_con
    m_flow_IN_con_3(
    channels=channels,
    Length=Length,
    Width=Width,
    amp=amp,
    phi=phi[3],
    a=a,
    b=b,
    c=c)
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var
    m_flow_IN_var_3(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
public
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_con
    m_flow_IN_con_4(
    channels=channels,
    Length=Length,
    Width=Width,
    amp=amp,
    phi=phi[4],
    a=a,
    b=b,
    c=c)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var
    m_flow_IN_var_4(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_con
    m_flow_IN_con_5(
    channels=channels,
    Length=Length,
    Width=Width,
    amp=amp,
    phi=phi[5],
    a=a,
    b=b,
    c=c)
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_IN_var
    m_flow_IN_var_5(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
equation
  //target == DP (incompressible)
  DP[1] = FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_DP(
      m_flow_IN_con_1,
      m_flow_IN_var_1,
      m_flow);

  DP[2] = FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_DP(
      m_flow_IN_con_2,
      m_flow_IN_var_2,
      m_flow);

  DP[3] = FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_DP(
      m_flow_IN_con_3,
      m_flow_IN_var_3,
      m_flow);

  DP[4] = FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_DP(
      m_flow_IN_con_4,
      m_flow_IN_var_4,
      m_flow);

  DP[5] = FluidDissipation.PressureLoss.HeatExchanger.dp_corrugatedPlate_1ph_DP(
      m_flow_IN_con_5,
      m_flow_IN_var_5,
      m_flow);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/heatExchanger/dp_corrugatedPlate_1ph_DP.mos"
        "Verification of dp_corrugatedPlate_1ph_DP"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={                               Text(
            extent={{-100,56},{100,66}},
            lineColor={0,0,255},
          textString="Pressure loss of corrugated plate heat exchanger"),
          Text(
          extent={{-97,6},{-22,-2}},
          lineColor={0,0,255},
          textString="phi = 23 deg"),
          Text(
          extent={{-37,6},{38,-2}},
          lineColor={0,0,255},
          textString="phi = 34 deg"),
          Text(
          extent={{23,6},{98,-2}},
          lineColor={0,0,255},
          textString="phi = 45 deg"),
          Text(
          extent={{-67,-34},{8,-42}},
          lineColor={0,0,255},
          textString="phi = 57 deg"),
          Text(
          extent={{-7,-34},{68,-42}},
          lineColor={0,0,255},
          textString="phi = 68 deg")}));
end dp_corrugatedPlate_1ph_DP;
