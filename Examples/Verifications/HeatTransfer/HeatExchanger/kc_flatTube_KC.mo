within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_flatTube_KC "Verification of function kc_flatTube_KC"
  import FluidDissipation;

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

  SI.Length h_2=D_h_2*(1 + alpha_2)/(2*alpha_2) "Free flow height";
  SI.Length l_2=t_2/delta_2 "Fin length";
  SI.Length s_2=h_2*alpha_2 "Lateral fin spacing (free flow width)";
  SI.Length t_2=s_2*gamma_2 "Fin thickness";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp=1007 "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta=18.24e-6 "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda=25.69e-3 "Thermal conductivity of fluid";
  parameter SI.Density rho=1.188 "Density of fluid";

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu=input_Nu.y;
  SI.MassFlowRate m_flow[n](start=ones(n)*1e-6);

  SI.CoefficientOfHeatTransfer kc_1=Nu*lambda/L_p_1;
  SI.CoefficientOfHeatTransfer kc_2=Nu*lambda/D_h_2;

  //input record
  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_con
    m_flow_IN_con_1(
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
  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_var
    m_flow_IN_var_1(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[1])
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_con
    m_flow_IN_con_2(
    A_fr=A_fr,
    D_h=D_h_2,
    alpha=alpha_2,
    gamma=gamma_2,
    delta=delta_2,
    D_m=D_m_2,
    geometry=FluidDissipation.Utilities.Types.HTXGeometry_flatTubes.RectangularFin)
               annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_IN_var
    m_flow_IN_var_2(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    m_flow=m_flow[2])
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  SI.ReynoldsNumber Re_1=abs(m_flow[1])*L_p_1/(eta*A_fr*((F_l_1 - delta_f_1)*(
      F_p_1 - delta_f_1)/((F_l_1 + D_m_1)*F_p_1)));
  SI.ReynoldsNumber Re_2=abs(m_flow[2])*D_h_2/(eta*A_fr*(h_2*s_2/((h_2 + t_2 +
      D_m_2)*(s_2 + t_2))));

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e3,
    offset=1) annotation (Placement(transformation(
          extent={{50,-80},{70,-60}})));
equation
  //heat transfer calculation
  kc_1 = FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_KC(
    m_flow_IN_con_1, m_flow_IN_var_1);
  kc_2 = FluidDissipation.HeatTransfer.HeatExchanger.kc_flatTube_KC(
    m_flow_IN_con_2, m_flow_IN_var_2);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_flatTube_KC.mos" "Verification of kc_flatTube_KC"),
                                           Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
              "Heat transfer of heat exchangers with FLAT tubes and various fin geometries (inlining)"),
          Text(
          extent={{-58,-22},{-22,-30}},
          lineColor={0,0,255},
          textString="Flat tube and louver fin"),Text(
          extent={{22,-22},{58,-30}},
          lineColor={0,0,255},
          textString="Flat tube and slit fin"),
          Text(
          extent={{-100,-54},{100,-29}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end kc_flatTube_KC;
