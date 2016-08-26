within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_flatTube "Verification of function kc_flatTube"

  parameter Integer n=2 "Number of various fin geometries";

  //heat exchanger variables
  parameter SI.Area A_fr=1 "Frontal area";

  //heat exchanger variables geometry no.1
  parameter SI.Length D_m_1=0.005 "Major tube diameter for flat tube";
  parameter SI.Length F_l_1=0.019 "Fin length";
  parameter SI.Length F_p_1=0.0018 "Fin pitch, fin spacing + fin thickness";
  parameter SI.Length L_l_1=0.01607 "Louver length";
  parameter SI.Length L_p_1=0.001534 "Louver pitch";
  parameter SI.Length T_d_1=0.026 "Tube depth";
  parameter SI.Length T_p_1=0.0197 "Tube pitch";

  parameter SI.Length delta_f_1=0.0001 "fin thickness";
  parameter SI.Angle Phi_1=28*PI/180 "Louver angle";

  //heat exchanger variables geometry no.2
  parameter SI.Length D_h_2=0.002383 "Hydraulic diameter";
  parameter SI.Length D_m_2=0.002 "Major tube diameter for flat tube";
  parameter Real alpha_2=0.244 "Lateral fin spacing (s) / free flow height (h)";
  parameter Real gamma_2=0.067 "Fin thickness (t) / lateral fin spacing (s)";
  parameter Real delta_2=0.032 "Fin thickness (t) / Fin length (l)";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp=1007 "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta=18.24e-6 "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda=25.69e-3 "Thermal conductivity of fluid";
  parameter SI.Density rho=1.188 "Density of fluid";

  //input VARIABLES
  SI.ReynoldsNumber Re=input_Re.y "Reynolds number"
    annotation (Dialog(group="Input"));

  //input record

  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_con m_flow_IN_con_1(
    A_fr=A_fr,
    D_m=D_m_1,
    F_l=F_l_1,
    F_p=F_p_1,
    L_l=L_l_1,
    L_p=L_p_1,
    T_d=T_d_1,
    T_p=T_p_1,
    delta_f=delta_f_1,
    Phi=Phi_1,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_var m_flow_IN_var_1(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[1])
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_con m_flow_IN_con_2(
    A_fr=A_fr,
    D_h=D_h_2,
    alpha=alpha_2,
    gamma=gamma_2,
    delta=delta_2,
    D_m=D_m_2,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin)
               annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_var m_flow_IN_var_2(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[2])
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  //output variables
  SI.MassFlowRate m_flow[n] "Mass flow rate" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu[n] "Nusselt number" annotation (Dialog(group="Output"));

public
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    height=10000,
    offset=1) annotation (Placement(transformation(
          extent={{-80,-80},{-60,-60}})));

equation
  //heat transfer calculation
  (,,Re,Nu[1],) = FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube(
    m_flow_IN_con_1, m_flow_IN_var_1);

  (,,Re,Nu[2],) = FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube(
    m_flow_IN_con_2, m_flow_IN_var_2);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_flatTube.mos" "Verification of kc_flatTube"),
                                        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
              "Heat transfer of heat exchangers with FLAT tubes and various fin geometries"),
          Text(
          extent={{-58,-22},{-22,-30}},
          lineColor={0,0,255},
          textString="Flat tube and louver fin"),Text(
          extent={{22,-22},{58,-30}},
          lineColor={0,0,255},
          textString="Flat tube and slit fin")}));
end kc_flatTube;
