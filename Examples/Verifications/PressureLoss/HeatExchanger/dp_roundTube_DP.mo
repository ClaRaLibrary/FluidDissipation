within FluidDissipation.Examples.Verifications.PressureLoss.HeatExchanger;
model dp_roundTube_DP "Verification of function dp_roundTube_DP"
  import FluidDissipation;

  parameter Integer n=4 "Number of various fin geometries";

  //heat exchanger variables
  parameter Modelica.SIunits.Area A_fr=0.1 "Frontal area";

  //heat exchanger variables geometry no.1

  parameter Modelica.SIunits.Length D_c_1=0.01023 "Fin collar diameter";
  parameter Modelica.SIunits.Length F_p_1=0.00177
    "Fin pitch, fin spacing + fin thickness";
  parameter Modelica.SIunits.Length L_1=N_1*P_l_1 "Heat exchanger length";
  parameter Integer N_1=2 "Number of tube rows";
  parameter Modelica.SIunits.Length P_l_1=0.022 "Longitudinal tube pitch";
  parameter Modelica.SIunits.Length P_t_1=0.0254 "Transverse tube pitch";

  parameter Modelica.SIunits.Length delta_f_1=0.0002 "Fin thickness";

  //heat exchanger variables geometry no.2

  parameter Modelica.SIunits.Length D_c_2=0.01042 "Fin collar diameter";
  parameter Modelica.SIunits.Length F_p_2=0.00205
    "Fin pitch, fin spacing + fin thickness";
  parameter Modelica.SIunits.Length L_2=N_2*P_l_2 "Heat exchanger length";
  parameter Modelica.SIunits.Length L_h_2=0.0014 "Louver height";
  parameter Modelica.SIunits.Length L_p_2=0.0024 "Louver pitch";
  parameter Integer N_2=2 "Number of tube rows";
  parameter Modelica.SIunits.Length P_l_2=0.01905 "Longitudinal tube pitch";
  parameter Modelica.SIunits.Length P_t_2=0.0254 "Transverse tube pitch";

  parameter Modelica.SIunits.Length delta_f_2=0.0001 "Fin thickness";

  //heat exchanger variables geometry no.3

  parameter Modelica.SIunits.Length D_c_3=0.01034 "Fin collar diameter";
  parameter Modelica.SIunits.Length F_p_3=0.00246
    "Fin pitch, fin spacing + fin thickness";
  parameter Modelica.SIunits.Length L_3=N_3*P_l_3 "Heat exchanger length";
  parameter Integer N_3=2 "Number of tube rows";
  parameter Modelica.SIunits.Length P_l_3=0.022 "Longitudinal tube pitch";
  parameter Modelica.SIunits.Length P_t_3=0.0254 "Transverse tube pitch";

  parameter Modelica.SIunits.Length delta_f_3=0.00012 "Fin thickness";

  //heat exchanger variables geometry no.4

  parameter Modelica.SIunits.Length D_c_4=0.0103 "Fin collar diameter";
  parameter Modelica.SIunits.Length F_p_4=0.00169
    "Fin pitch, fin spacing + fin thickness";
  parameter Modelica.SIunits.Length L_4=N_4*P_l_4 "Heat exchanger length";
  parameter Integer N_4=2 "Number of tube rows";
  parameter Modelica.SIunits.Length P_d_4=0.0015
    "Pattern depth of wavy fin, wave height";
  parameter Modelica.SIunits.Length P_l_4=0.01905 "Longitudinal tube pitch";
  parameter Modelica.SIunits.Length P_t_4=0.0254 "Transverse tube pitch";
  parameter Modelica.SIunits.Length X_f_4=0.0047625
    "Half wave length of wavy fin";

  parameter Modelica.SIunits.Length delta_f_4=0.0001 "Fin thickness";

  //fluid property variables
  Modelica.SIunits.DynamicViscosity eta=18.2e-6 "Dynamic viscosity of fluid";
  Modelica.SIunits.Density rho=1.19 "Density of fluid";

  //input VARIABLES
  Modelica.SIunits.ReynoldsNumber Re=input_Re.y "Reynolds number"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow_1=abs(Re)*eta*A_c[1]/D_c_1 "mass flow"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow_2=abs(Re)*eta*A_c[2]/D_c_2 "mass flow"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow_3=abs(Re)*eta*A_c[3]/D_c_3 "mass flow"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow_4=abs(Re)*eta*A_c[4]/D_c_4 "mass flow"
    annotation (Dialog(group="Input"));

  //output variables
  Modelica.SIunits.Pressure DP[n] "Pressure loss in [bar]"
                                    annotation (Dialog(group="Output"));
  Real zeta_TOT[n]={2*abs(DP[i])/(max(rho*(v_c[i])^2, MIN)) for i in 1:n}
    "Pressure loss coefficients" annotation (Dialog(group="Output"));
  Real lambda_FRI[n]={zeta_TOT[i]*D_h[i]/L[i] for i in 1:n}
    "Frictional resistance coefficient";
      //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

protected
  constant Real MIN=Modelica.Constants.eps;

  Modelica.SIunits.Velocity v_c[n]={abs(Re)*eta/(rho*D_c_1),abs(Re)*eta/(rho*
      D_c_2),abs(Re)*eta/(rho*D_c_3),abs(Re)*eta/(rho*D_c_4)}
    "Velocity at minimum flow cross-sectional area";

  Modelica.SIunits.Area A_c[n]={A_fr*((F_p_1*P_t_1 - F_p_1*D_c_1 - (P_t_1 -
      D_c_1)*delta_f_1)/(F_p_1*P_t_1)),A_fr*((F_p_2*P_t_2 - F_p_2*D_c_2 - (
      P_t_2 - D_c_2)*delta_f_2)/(F_p_2*P_t_2)),A_fr*((F_p_3*P_t_3 - F_p_3*D_c_3
       - (P_t_3 - D_c_3)*delta_f_3)/(F_p_3*P_t_3)),A_fr*((F_p_4*P_t_4 - F_p_4*
      D_c_4 - (P_t_4 - D_c_4)*delta_f_4)/(F_p_4*P_t_4))}
    "Minimum flow cross-sectional area";

  Modelica.SIunits.Area A_tot[n]={A_fr*((N_1*Modelica.Constants.pi*D_c_1*(F_p_1
       - delta_f_1) + 2*(P_t_1*L_1 - N_1*Modelica.Constants.pi*D_c_1^2/4))/(
      P_t_1*F_p_1)),A_fr*((N_2*Modelica.Constants.pi*D_c_2*(F_p_2 - delta_f_2)
       + 2*(P_t_2*L_2 - N_2*Modelica.Constants.pi*D_c_2^2/4))/(P_t_2*F_p_2)),
      A_fr*((N_3*Modelica.Constants.pi*D_c_3*(F_p_3 - delta_f_3) + 2*(P_t_3*L_3
       - N_3*Modelica.Constants.pi*D_c_3^2/4))/(P_t_3*F_p_3)),A_fr*((N_4*
      Modelica.Constants.pi*D_c_4*(F_p_4 - delta_f_4) + 2*(P_t_4*L_4 - N_4*
      Modelica.Constants.pi*D_c_4^2/4)*(sqrt(X_f_4^2 + P_d_4^2)/X_f_4))/(P_t_4*
      F_p_4))} "Total heat transfer area";

  Modelica.SIunits.Length D_h[n]={4*A_c[i]*L[i]/A_tot[i] for i in 1:n}
    "Hydraulic diameter";

  Modelica.SIunits.Length L[n]={L_1,L_2,L_3,L_4} "Heat exchanger length";

  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_con
    m_flow_IN_con_1(
    A_fr=A_fr,
    D_c=D_c_1,
    F_p=F_p_1,
    N=N_1,
    P_t=P_t_1,
    L=L_1,
    delta_f=delta_f_1,
    P_l=P_l_1,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.PlainFin)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_con
    m_flow_IN_con_2(
    A_fr=A_fr,
    D_c=D_c_2,
    F_p=F_p_2,
    L_h=L_h_2,
    L_p=L_p_2,
    N=N_2,
    P_l=P_l_2,
    P_t=P_t_2,
    L=L_2,
    delta_f=delta_f_2,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.LouverFin)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_con
    m_flow_IN_con_3(
    A_fr=A_fr,
    D_c=D_c_3,
    F_p=F_p_3,
    N=N_3,
    P_l=P_l_3,
    P_t=P_t_3,
    L=L_3,
    delta_f=delta_f_3,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.SlitFin)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_con
    m_flow_IN_con_4(
    A_fr=A_fr,
    D_c=D_c_4,
    F_p=F_p_4,
    N=N_4,
    P_d=P_d_4,
    P_t=P_t_4,
    X_f=X_f_4,
    L=L_4,
    delta_f=delta_f_4,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_roundTubes.WavyFin)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_var
    m_flow_IN_var_1(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_var
    m_flow_IN_var_2(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_var
    m_flow_IN_var_3(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_IN_var
    m_flow_IN_var_4(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
public
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    height=10000,
    offset=0) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
equation
  //target == DP (incompressible)
  DP[1] = FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP(
      m_flow_IN_con_1,
      m_flow_IN_var_1,
      m_flow_1);

  DP[2] = FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP(
      m_flow_IN_con_2,
      m_flow_IN_var_2,
      m_flow_2);

  DP[3] = FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP(
      m_flow_IN_con_3,
      m_flow_IN_var_3,
      m_flow_3);

  DP[4] = FluidDissipation.PressureLoss.HeatExchanger.dp_roundTube_DP(
      m_flow_IN_con_4,
      m_flow_IN_var_4,
      m_flow_4);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/heatExchanger/dp_roundTube_DP.mos"
        "Verification of dp_roundTube_DP"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
            extent={{-100,50},{100,75}},
            lineColor={0,0,255},
            textString=
            "Pressure loss of heat exchangers with round tubes and various fin geometries"),
          Text(
          extent={{-60,16},{-20,8}},
          lineColor={0,0,255},
          textString="Round tube and plain fin"), Text(
          extent={{-60,-44},{-20,-52}},
          lineColor={0,0,255},
          textString="Round tube and slit fin"),Text(
          extent={{20,-44},{60,-52}},
          lineColor={0,0,255},
          textString="Round tube and wavy fin"), Text(
          extent={{20,16},{60,8}},
          lineColor={0,0,255},
          textString="Round tube and louver fin")}));
end dp_roundTube_DP;
