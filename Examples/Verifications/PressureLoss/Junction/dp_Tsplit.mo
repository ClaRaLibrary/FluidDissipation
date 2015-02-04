within FluidDissipation.Examples.Verifications.PressureLoss.Junction;
model dp_Tsplit "verification of function dp_Tsplit"

  parameter Integer alpha[1]={90} "angle of branching"
    annotation (Dialog(group="T-junction"));

  parameter SI.Diameter d_hyd_conv[3]={((4/PI*1e-3)/2)^0.5,((4/PI*
      1e-3)/2)^0.5,(4/PI*1e-3)^0.5}
    "hydraulic diameter united_converging_crossection=true"
    annotation (Dialog(group="T-junction"));
  parameter Real d_hyd_noconv[3]={((4/PI*1e-3))^0.5,((4/PI*1e-3))^0.5,
      (4/PI*1e-3)^0.5} "hydraulic diameter united_converging_crossection=false";
  parameter SI.MassFlowRate m_flow_min=1e-6
    "restriction for smoothing at reverse fluid flow"
    annotation (Dialog(group="restriction"));
  parameter SI.Velocity v_max=343 "restriction for maximum fluid flow velocity"
    annotation (Dialog(group="restriction"));
  parameter TYP.PressureLossCoefficient zeta_TOT_max=1000
    "restriction for maximum value of pressure loss coefficient"
    annotation (Dialog(group="restriction"));

  //fluid property variables
  SI.Density rho=1000 "density of fluid"
    annotation (Dialog(group="Fluid properties"));
  Real eta=1e-3 "dynamic viscosity of fluid"
    annotation (Dialog(group="Fluid properties"));

  //input variable (mass flow rate) for split
  SI.MassFlowRate m_flow[3]={-sign(input_m_flow)*input_m_flow,-(1 -
      sign(input_m_flow)*input_m_flow),+1} "mass flow rate"
    annotation (Dialog(group="Input"));

  //input record
  //incompressible fluid flow (A_side + A_straight = A_total)
  FluidDissipation.PressureLoss.Junction.dp_Tsplit_IN_con m_flow_IN_con_1(
    united_converging_crossection=true,
    alpha=alpha[1],
    d_hyd=d_hyd_conv,
    m_flow_min=m_flow_min,
    v_max=v_max,
    zeta_TOT_max=zeta_TOT_max)
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  FluidDissipation.PressureLoss.Junction.dp_Tsplit_IN_var m_flow_IN_var_1(rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  //incompressible fluid flow (A_side + A_straight > A_total)
  FluidDissipation.PressureLoss.Junction.dp_Tsplit_IN_con m_flow_IN_con_2(
    alpha=alpha[1],
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    m_flow_min=m_flow_min,
    v_max=v_max,
    zeta_TOT_max=zeta_TOT_max)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

   FluidDissipation.PressureLoss.Junction.dp_Tsplit_IN_var m_flow_IN_var_2(rho=rho)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Real DP_plot1[2];
  Real zeta_LOC1[2];
  Real DP_plot2[2];
  Real zeta_LOC2[2];

  //boundary condition
  Real input_m_flow=input_mflow.y;
public
  Modelica.Blocks.Sources.Ramp input_mflow(
    offset=0,
    startTime=0,
    height=1,
    duration=1) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    amplitude=100,
    freqHz=1/100,
    phase=0,
    offset=0,
    startTime=0) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1,
    offset=0,
    startTime=0) annotation (Placement(
        transformation(extent={{0,-80},{20,-60}})));
equation
  //incompressible fluid flow (A_side + A_straight = A_total)
  (DP_plot1,,zeta_LOC1,,) = FluidDissipation.PressureLoss.Junction.dp_Tsplit(
    m_flow_IN_con_1,
    m_flow_IN_var_1,
    m_flow);

  //incompressible fluid flow (A_side + A_straight > A_total)
  (DP_plot2,,zeta_LOC2,,) = FluidDissipation.PressureLoss.Junction.dp_Tsplit(
    m_flow_IN_con_2,
    m_flow_IN_var_2,
    m_flow);

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/junction/dp_Tsplit.mos"
        "verification dp_Tsplit"), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={Text(
                    extent={{-98,64},{102,89}},
                    lineColor={0,0,255},
                    textString=
            "Pressure loss of SMOOTH T-junction for SPLITTING at TURBULENT flow regime"),
          Text(     extent={{13,14},{88,4}},
                    lineColor={0,0,255},
                    textString="A_side + A_straight  > A_total"),Text(
                    extent={{-83,14},{-8,4}},
                    lineColor={0,0,255},
                    textString="A_side + A_straight = A_total")}));
end dp_Tsplit;
