within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_roundTube_KC "Verification of function kc_roundTube_KC"
  //The functions for heat exchanger geometry no.2 and no.3 are too complex for inverting.
  //Therefore they have been removed from this verification model.

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

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu=input_Nu.y;
  SI.MassFlowRate m_flow[n](start=ones(n)*1e-6);

  SI.CoefficientOfHeatTransfer kc_1=Nu*lambda/D_c_1;
  //SI.CoefficientOfHeatTransfer kc_2 = Nu*lambda/D_c_2;
  //SI.CoefficientOfHeatTransfer kc_3 = Nu*lambda/D_c_3;
  SI.CoefficientOfHeatTransfer kc_4=Nu*lambda/D_c_4;

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

  SI.ReynoldsNumber Re_1=abs(m_flow[1])*D_c_1/(eta*A_fr*((F_p_1*P_t_1 - F_p_1*
      D_c_1 - (P_t_1 - D_c_1)*delta_f)/(F_p_1*P_t_1)));
  //SI.ReynoldsNumber Re_2 = abs(m_flow[2])*D_c_2/(eta*A_fr*((F_p_2*P_t_2-F_p_2*D_c_2-(P_t_2-D_c_2)*delta_f)/(F_p_2*P_t_2)));
  //SI.ReynoldsNumber Re_3 = abs(m_flow[3])*D_c_3/(eta*A_fr*((F_p_3*P_t_3-F_p_3*D_c_3-(P_t_3-D_c_3)*delta_f_3)/(F_p_3*P_t_3)));
  SI.ReynoldsNumber Re_4=abs(m_flow[4])*D_c_4/(eta*A_fr*((F_p_4*P_t_4 - F_p_4*
      D_c_4 - (P_t_4 - D_c_4)*delta_f)/(F_p_4*P_t_4)));
public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e3,
    offset=5) annotation (Placement(transformation(
          extent={{50,-80},{70,-60}})));
equation
  //heat transfer calculation
  kc_1 = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC(
    m_flow_IN_con_1, m_flow_IN_var_1);
  //kc_2 = FluidDissipation.HeatTransfer.HeatExchanger.kc_heatExchanger_KC(
  //m_flow_IN_con_2, m_flow_IN_var_2);
  //kc_3 = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC(
  //m_flow_IN_con_3, m_flow_IN_var_3);
  kc_4 = FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC(
    m_flow_IN_con_4, m_flow_IN_var_4);
  m_flow[2] = 1;
  m_flow[3] = 1;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_roundTube_KC.mos" "Verification of kc_roundTube_KC"),
                                            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
              "Heat transfer of heat exchangers with ROUND tubes and various fin geometries (inlining)"),
          Text(
          extent={{-60,18},{-20,10}},
          lineColor={0,0,255},
          textString="Round tube and plain fin"),Text(
          extent={{20,18},{60,10}},
          lineColor={0,0,255},
          textString="Round tube and louver fin"),Text(
          extent={{-60,-22},{-20,-30}},
          lineColor={0,0,255},
          textString="Round tube and slit fin"),Text(
          extent={{20,-22},{60,-30}},
          lineColor={0,0,255},
          textString="Round tube and wavy fin"),
          Text(
          extent={{-100,-54},{100,-29}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end kc_roundTube_KC;
