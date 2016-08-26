within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_roundTube "Verification of function kc_roundTube"

  parameter Integer n=4 "Number of various fin geometries";

  //heat exchanger variables
  parameter SI.Area A_fr=1 "Frontal area";
  parameter SI.Length delta_f=0.0001 "fin thickness";

  //heat exchanger variables geometry no.1
  parameter SI.Length D_c_1=0.00752 "Fin collar diameter";
  parameter SI.Length F_p_1=0.00122 "Fin pitch, fin spacing + fin thickness";
  parameter SI.Length P_l_1=0.0127 "Longitudinal tube pitch";
  parameter SI.Length P_t_1=0.021 "Transverse tube pitch";
  parameter Integer N_1=2 "Number of tube rows";

  //heat exchanger variables geometry no.2
  parameter SI.Length D_c_2=0.01042 "Fin collar diameter";
  parameter SI.Length F_p_2=0.00205 "Fin pitch, fin spacing + fin thickness";
  parameter SI.Length L_2=N_2*P_l_2 "Heat exchanger length";
  parameter SI.Length L_h_2=0.0014 "Louver height";
  parameter SI.Length L_p_2=0.0024 "Louver pitch";
  parameter Integer N_2=2 "Number of tube rows";
  parameter SI.Length P_l_2=0.01905 "Longitudinal tube pitch";
  parameter SI.Length P_t_2=0.0254 "Transverse tube pitch";

  //heat exchanger variables geometry no.3
  parameter SI.Length D_c_3=0.01034 "Fin collar diameter";
  parameter SI.Length F_p_3=0.00246 "Fin pitch, fin spacing + fin thickness";
  parameter Integer N_3=2 "Number of tube rows";
  parameter SI.Length P_l_3=0.022 "Longitudinal tube pitch";
  parameter SI.Length P_t_3=0.0254 "Transverse tube pitch";
  parameter SI.Length delta_f_3=0.00012 "fin thickness";
  parameter SI.Length S_h_3=0.00099 "Slit height";
  parameter SI.Length S_p_3=0.0022 "Slit pitch";

  //heat exchanger variables geometry no.4
  parameter SI.Length D_c_4=0.0103 "Fin collar diameter";
  parameter SI.Length F_p_4=0.00169 "Fin pitch, fin spacing + fin thickness";
  parameter Integer N_4=2 "Number of tube rows";
  parameter SI.Length P_l_4=0.01905 "Longitudinal tube pitch";
  parameter SI.Length P_t_4=0.0254 "Transverse tube pitch";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp=1007 "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta=18.24e-6 "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda=25.69e-3 "Thermal conductivity of fluid";
  parameter SI.Density rho=1.188 "Density of fluid";

  //input VARIABLES
  SI.ReynoldsNumber Re=input_Re.y "Reynolds number"
    annotation (Dialog(group="Input"));

  //input record
  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_con m_flow_IN_con_1(
    A_fr=A_fr,
    D_c=D_c_1,
    F_p=F_p_1,
    P_t=P_t_1,
    P_l=P_l_1,
    N=N_1,
    delta_f=delta_f,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_var m_flow_IN_var_1(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[1])
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_con m_flow_IN_con_2(
    A_fr=A_fr,
    D_c=D_c_2,
    F_p=F_p_2,
    L_h=L_h_2,
    L_p=L_p_2,
    P_t=P_t_2,
    P_l=P_l_2,
    N=N_2,
    delta_f=delta_f,
    L=L_2,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin)
           annotation (Placement(transformation(extent={{20,20},{40,40}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_var m_flow_IN_var_2(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[2])
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_con m_flow_IN_con_3(
    A_fr=A_fr,
    D_c=D_c_3,
    F_p=F_p_3,
    P_t=P_t_3,
    P_l=P_l_3,
    N=N_3,
    S_h=S_h_3,
    S_p=S_p_3,
    delta_f=delta_f_3,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_var m_flow_IN_var_3(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[3])
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_con m_flow_IN_con_4(
    A_fr=A_fr,
    D_c=D_c_4,
    F_p=F_p_4,
    P_t=P_t_4,
    delta_f=delta_f,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_IN_var m_flow_IN_var_4(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[4])
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  //output variables
  SI.MassFlowRate m_flow[n] "Mass flow rate" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu[n] "Nusselt number" annotation (Dialog(group="Output"));

public
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    height=10000,
    offset=0) annotation (Placement(transformation(
          extent={{-80,-80},{-60,-60}})));

equation
  //heat transfer calculation
  (,,Re,Nu[1],) = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube(
    m_flow_IN_con_1, m_flow_IN_var_1);

  (,,Re,Nu[2],) = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube(
    m_flow_IN_con_2, m_flow_IN_var_2);

  (,,Re,Nu[3],) = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube(
    m_flow_IN_con_3, m_flow_IN_var_3);

  (,,Re,Nu[4],) = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube(
    m_flow_IN_con_4, m_flow_IN_var_4);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_roundTube.mos" "Verification of kc_roundTube"),
                                         Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
              "Heat transfer of heat exchangers with ROUND tubes and various fin geometries"),
          Text(
          extent={{-60,18},{-20,10}},
          lineColor={0,0,255},
          textString="Round tube and plain fin"),Text(
          extent={{20,18},{60,10}},
          lineColor={0,0,255},
          textString="Round tube and louver fin"),Text(
          extent={{-58,-22},{-22,-30}},
          lineColor={0,0,255},
          textString="Round tube and slit fin"),Text(
          extent={{20,-22},{60,-30}},
          lineColor={0,0,255},
          textString="Round tube and wavy fin")}));
end kc_roundTube;
