within FluidDissipation.Examples.Verifications.PressureLoss.HeatExchanger;
model dp_flatTube_DP "Verification of function dp_flatTube_DP"
  import FluidDissipation;

  parameter Integer n=2 "Number of various fin geometries";

  //heat exchanger variables
  parameter Modelica.SIunits.Area A_fr=0.1 "Frontal area";

  //heat exchanger variables geometry no.1

  parameter Modelica.SIunits.Length D_m_1=0.005 "Major tube diameter for flat tube";
  parameter Modelica.SIunits.Length F_l_1=0.019 "Fin length";
  parameter Modelica.SIunits.Length F_d_1=0.026 "Fin depth";
  parameter Modelica.SIunits.Length F_p_1=0.0018 "Fin pitch, fin spacing + fin thickness";
  parameter Modelica.SIunits.Length L_1=F_d_1 "Heat exchanger length";
  parameter Modelica.SIunits.Length L_l_1=0.01607 "Louver length";
  parameter Modelica.SIunits.Length L_p_1=0.001534 "Louver pitch";
  parameter Modelica.SIunits.Length T_p_1=0.0197 "Tube pitch";

  parameter Modelica.SIunits.Length delta_f_1=0.0001 "Fin thickness";

  parameter Modelica.SIunits.Angle Phi_1=28*Modelica.Constants.pi/180 "Louver angle";

  //heat exchanger variables geometry no.2
  parameter Modelica.SIunits.Length D_h_2=0.002383 "Hydraulic diameter";
  parameter Modelica.SIunits.Length D_m_2=0.002 "Major tube diameter for flat tube";
  parameter Modelica.SIunits.Length L_2=0.025 "Heat exchanger length";
  parameter Real alpha_2=0.244 "Lateral fin spacing (s) / free flow height (h)";
  parameter Real gamma_2=0.067 "Fin thickness (t) / lateral fin spacing (s)";
  parameter Real delta_2=0.032 "Fin thickness (t) / fin length (l)";

  //fluid property variables
  Modelica.SIunits.DynamicViscosity eta=18.2e-6 "Dynamic viscosity of fluid";
  Modelica.SIunits.Density rho=1.19 "Density of fluid";

  //input VARIABLES
  Modelica.SIunits.ReynoldsNumber Re=input_Re.y "Reynolds number"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow_1=abs(Re)*eta*A_c[1]/L_p_1 "mass flow"
    annotation (Dialog(group="Input"));
  Modelica.SIunits.ReynoldsNumber m_flow_2=abs(Re)*eta*A_c[2]/D_h_2 "mass flow"
    annotation (Dialog(group="Input"));

  //output variables
  Modelica.SIunits.Pressure DP[n] "Pressure loss in [bar]"
                                    annotation (Dialog(group="Output"));
  Real zeta_TOT[n]={2*abs(DP[i])/(max(rho*(v_c[i])^2, MIN)) for i in 1:n} "Pressure loss coefficients"
                                 annotation (Dialog(group="Output"));
  Real lambda_FRI[n]={zeta_TOT[i]*D_h[i]/L[i] for i in 1:n} "Frictional resistance coefficient";

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

protected
  constant Real MIN=Modelica.Constants.eps;

  Modelica.SIunits.Velocity v_c[n]={abs(Re)*eta/(rho*L_p_1),abs(Re)*eta/(rho*
      D_h_2)} "Velocity at minimum flow cross-sectional area";

  Modelica.SIunits.Area A_c[n]={A_fr*((F_l_1 - delta_f_1)*(F_p_1 - delta_f_1)/(
      (F_l_1 + D_m_1)*F_p_1)),A_fr*(h_2*s_2/((h_2 + t_2 + D_m_2)*(s_2 + t_2)))} "Minimum flow cross-sectional area";

  Modelica.SIunits.Length D_h[n]={4*A_c[1]/(A_fr*(2*(F_p_1 - delta_f_1 + F_l_1
       - delta_f_1)/(F_p_1*(F_l_1 + D_m_1)))),D_h_2} "Hydraulic diameter";

  Modelica.SIunits.Length L[n]={L_1,L_2} "Heat exchanger length";

  Modelica.SIunits.Length h_2=D_h_2*(1 + alpha_2)/(2*alpha_2) "Free flow height";
  Modelica.SIunits.Length l_2=t_2/delta_2 "Fin length";
  Modelica.SIunits.Length s_2=h_2*alpha_2 "Lateral fin spacing (free flow width)";
  Modelica.SIunits.Length t_2=s_2*gamma_2 "Fin thickness";

  FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_con
    m_flow_IN_con_1(
    A_fr=A_fr,
    D_m=D_m_1,
    F_d=F_d_1,
    F_l=F_l_1,
    F_p=F_p_1,
    L_l=L_l_1,
    L_p=L_p_1,
    T_p=T_p_1,
    Phi=Phi_1,
    L=L_1,
    delta_f=delta_f_1,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.LouverFin)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_var
    m_flow_IN_var_1(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_con
    m_flow_IN_con_2(
    A_fr=A_fr,
    D_h=D_h_2,
    D_m=D_m_2,
    alpha=alpha_2,
    gamma=gamma_2,
    delta=delta_2,
    L=L_2,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin)
           annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_IN_var
    m_flow_IN_var_2(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
public
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    height=10000,
    offset=0) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
equation
  //target == DP (incompressible)
  DP[1] = FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_DP(
      m_flow_IN_con_1,
      m_flow_IN_var_1,
      m_flow_1);

  DP[2] = FluidDissipation.PressureLoss.HeatExchanger.dp_flatTube_DP(
      m_flow_IN_con_2,
      m_flow_IN_var_2,
      m_flow_2);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/heatExchanger/dp_flatTube_DP.mos" "Verification of dp_flatTube_DP"),
                                           Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
            extent={{-58,-22},{-22,-30}},
            lineColor={0,0,255},
            textString="Flat tube and louver fin"),Text(
            extent={{22,-22},{58,-30}},
            lineColor={0,0,255},
            textString="Flat tube and slit fin"),Text(
            extent={{-100,50},{100,75}},
            lineColor={0,0,255},
            textString=
            "Pressure loss of heat exchangers with flat tubes and various fin geometries")}));
end dp_flatTube_DP;
