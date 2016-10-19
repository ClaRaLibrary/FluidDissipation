within FluidDissipation.Examples.Verifications.HeatTransfer.StraightPipe;
model kc_twoPhaseOverall_KC "Verification of function kc_twoPhaseOverall_KC"
  import FluidDissipation;
  import Modelica.Math.log10;
  parameter Integer n=size(m_flow_1, 1);
  parameter Integer m=size(m_flow_3, 1);

  //boiling in a horizontal pipe (KC=1)
  parameter SI.Diameter d_hyd_1=0.01092;
  parameter SI.Area A_cross_1=PI*d_hyd_1^2/4;
  parameter SI.Length perimeter_1=PI*d_hyd_1;

  parameter SI.SpecificHeatCapacityAtConstantPressure cp_1[n]={1341.222455,
      1341.222455,1341.222455,1346,1346,1346};
  parameter SI.DynamicViscosity eta_l_1[n]={0.2589963793e-3,0.2589963793e-3,
      0.2589963793e-3,0.181e-3,0.181e-3,0.181e-3};
  parameter SI.DynamicViscosity eta_g_1[n]={1.1732415e-5,1.1732415e-5,
      1.1732415e-5,1.172546e-5,1.172546e-5,1.172546e-5};
  parameter SI.ThermalConductivity lambda_1[n]={0.09296757,0.09296757,
      0.09296757,0.0816653,0.0816653,0.0816653};
  parameter SI.Density rho_l_1[n]={1280.569453,1280.569453,1280.569453,1164,
      1164,1164};
  parameter SI.Density rho_g_1[n]={16.89048514,16.89048514,16.89048514,32.9,
      32.9,32.9};
  parameter FluidDissipation.Utilities.Types.MolarMass_gpmol M_1[n]={102.032,102.032,102.032,97.6,97.6,97.6};
  parameter SI.SpecificEnthalpy dh_lg_1[n]={193865.4,193865.4,193865.4,
      166298.02,166298.02,166298.02};
  parameter SI.HeatFlux qdot_A_1[n]={5000,4000,1200,10000,7000,5000};
  parameter SI.Pressure p_1[n]={342402.623,342402.623,342402.623,660500,660500,
      660500};
  parameter SI.Pressure p_crit_1[n]={4056000,4056000,4056000,3732000,3732000,
      3732000};
  SI.MassFlowRate m_flow_1[6]={0.028003115,0.018637525,0.009365590,0.009552902,
      0.009552902,0.009552902};
  Real mdot_A1[n]={m_flow_1[i]/A_cross_1 for i in 1:n};

  //boiling in a vertical pipe (KC=2)
  parameter SI.Diameter d_hyd_2=0.0061;
  parameter SI.Area A_cross_2=PI*d_hyd_2^2/4;
  parameter SI.Length perimeter_2=PI*d_hyd_2;

  parameter SI.SpecificHeatCapacityAtConstantPressure cp_2=1128.7126;
  parameter SI.DynamicViscosity eta_l_2=0.000264104448;
  parameter SI.DynamicViscosity eta_g_2=1.126785138e-5;
  parameter SI.ThermalConductivity lambda_2=0.107525;
  parameter SI.Density rho_l_2=1334.01138;
  parameter FluidDissipation.Utilities.Types.MolarMass_gpmol M_2=86.47;
  parameter SI.Density rho_g_2=12.8808;
  parameter SI.SpecificEnthalpy dh_lg_2=216811.5384;
  parameter SI.HeatFlux qdot_A_2=10000;
  parameter SI.Pressure p_2=295700;
  parameter SI.Pressure p_crit_2=4986000;
  SI.MassFlowRate m_flow_2=0.011689866;

  //condensation in a horizontal pipe (KC=3)
  parameter SI.Diameter d_hyd_3=0.00704;
  parameter SI.Area A_cross_3=PI*d_hyd_3^2/4;
  parameter SI.Length perimeter_3=PI*d_hyd_3;

  parameter SI.SpecificHeatCapacityAtConstantPressure cp_3[m]={1301.76461,
      1902.75,1301.76461,1471,1471,1471};
  parameter SI.DynamicViscosity eta_l_3[m]={0.0001889385508,0.106e-3,
      0.0001889385508,0.0001734,0.0001734,0.0001734};
  parameter SI.ThermalConductivity lambda_3[m]={0.082775,0.0825,0.082775,
      0.07798,0.07798,0.07798};
  parameter SI.Density rho_l_3[m]={1153.0466,1016.75,1153.0466,1167.5,1167.5,
      1167.5};
  parameter SI.Pressure p_3[m]={1354785.871,2189950,1354785.871,886980,886980,
      886980};
  parameter SI.Pressure p_crit_3[m]={4977400,4893000,4977400,4056000,4056000,
      4056000};
  SI.MassFlowRate m_flow_3[6]={0.0087583,0.02530163,0.02530163,0.02530163,
      0.01167768,0.00291942};

  //mass flow rate quality from 0 to 1
  SI.MassFraction x_flow=input_x_0.y "Mass flow rate quality";

  //plotting
  SI.NusseltNumber Nu_1[n]={kc_1[i]*d_hyd_1/lambda_1[i] for i in 1:n}
    "Local Nusselt number";
  SI.NusseltNumber NU_2=kc_2*d_hyd_2/lambda_2 "Local Nusselt number";
  SI.NusseltNumber Nu_3[m]={kc_3[i]*d_hyd_3/lambda_3[i] for i in 1:m}
    "Local Nusselt number";

  //input records
  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_con
    IN_con_1[n](
    each A_cross=A_cross_1,
    each perimeter=perimeter_1,
    p_crit=p_crit_1,
    MM=M_1) annotation (Placement(transformation(extent={{-70,14},{-50,34}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var
    IN_var_1[n](
    cp_l=cp_1,
    eta_l=eta_l_1,
    eta_g=eta_g_1,
    lambda_l=lambda_1,
    rho_l=rho_l_1,
    rho_g=rho_g_1,
    each x_flow=x_flow,
    qdot_A=qdot_A_1,
    dh_lg=dh_lg_1,
    m_flow=m_flow_1,
    pressure=p_1)
    annotation (Placement(transformation(extent={{-50,14},{-30,34}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_con
    IN_con_2(
    each A_cross=A_cross_2,
    each perimeter=perimeter_2,
    p_crit=p_crit_2,
    MM=M_2) annotation (Placement(transformation(extent={{-20,14},{0,34}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var
    IN_var_2(
    cp_l=cp_2,
    eta_l=eta_l_2,
    eta_g=eta_g_2,
    lambda_l=lambda_2,
    rho_l=rho_l_2,
    rho_g=rho_g_2,
    each x_flow=x_flow,
    qdot_A=qdot_A_2,
    each dh_lg=dh_lg_2,
    m_flow=m_flow_2,
    pressure=p_2)
    annotation (Placement(transformation(extent={{0,14},{20,34}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_con
    IN_con_3[m](
    each A_cross=A_cross_3,
    each perimeter=perimeter_3,
    p_crit=p_crit_3)
    annotation (Placement(transformation(extent={{30,14},{50,34}})));

  FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC_IN_var
    IN_var_3[m](
    cp_l=cp_3,
    eta_l=eta_l_3,
    lambda_l=lambda_3,
    rho_l=rho_l_3,
    each x_flow=x_flow,
    m_flow=m_flow_3,
    pressure=p_3)
    annotation (Placement(transformation(extent={{50,14},{70,34}})));

  //output variables
  SI.CoefficientOfHeatTransfer kc_1[n];
  SI.CoefficientOfHeatTransfer kc_2;
  SI.CoefficientOfHeatTransfer kc_3[m];

  Modelica.Blocks.Sources.Ramp input_x_0(duration=1, height=1)
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
  Modelica.Blocks.Sources.Sine input_x_1(freqHz=1, amplitude=100)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Exponentials input_x_2(
    riseTimeConst=1e-1,
    outMax=100,
    riseTime=1e-1)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.Ramp input_mflow_0(duration=1, height=100)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(freqHz=1, amplitude=100)
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

equation
  kc_1 = {FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC(
    IN_con_1[i], IN_var_1[i]) for i in 1:n};
  kc_2 = FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC(
    IN_con_2, IN_var_2);
  kc_3 = {FluidDissipation.HeatTransfer.StraightPipe.kc_twoPhaseOverall_KC(
    IN_con_3[i], IN_var_3[i]) for i in 1:m};
  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/straightPipe/kc_twoPhaseOverall_KC.mos"
        "Verification of kc_twoPhaseOverall_KC"),
      Diagram(graphics={Text(
          extent={{-100,52},{100,77}},
          lineColor={0,0,255},
          textString=
            "Two phase heat transfer in straight pipe for overall  flow regime ")}),
    Documentation(revisions="<html>
<p>2011-03-28        XRG Simulation GmbH, Stefan Wischhusen: Changed unit for molar mass.</p>
</html>"));
end kc_twoPhaseOverall_KC;
