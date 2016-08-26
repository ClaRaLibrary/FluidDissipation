within FluidDissipation.Examples.Verifications.PressureLoss.Junction;
model dp_Tjunction "verification of function dp_Tjunction"

  import SI = Modelica.SIunits;

  parameter Integer alpha[1]={90} "angle of branching"
    annotation (Dialog(group="T-junction"));

  parameter SI.Diameter d_hyd_conv[3]={((4/PI*1e-3)/2)^0.5,((4/PI*
      1e-3)/2)^0.5,(4/PI*1e-3)^0.5} "hydraulic diameter united_converging_crossection=true"
    annotation (Dialog(group="T-junction"));
  parameter Real d_hyd_noconv[3]={((4/PI*1e-3))^0.5,((4/PI*1e-3))^0.5,
      (4/PI*1e-3)^0.5} "hydraulic diameter united_converging_crossection=false";
  parameter SI.MassFlowRate m_flow_min=1e-6 "restriction for smoothing at reverse fluid flow"
    annotation (Dialog(group="restriction"));
  parameter SI.Velocity v_max=343 "restriction for maximum fluid flow velocity"
    annotation (Dialog(group="restriction"));
  parameter TYP.PressureLossCoefficient zeta_TOT_max=1000 "restriction for maximum value of pressure loss coefficient"
    annotation (Dialog(group="restriction"));
  parameter SI.Pressure dp_min=1 "restriction for smoothing while changing of fluid flow situation"
    annotation (Dialog(group="restriction"));
  parameter SI.Pressure p_junction[4]=zeros(4) "pressures at ports of junction [left,right,bottom,internal]"
    annotation (Dialog(group="restriction"));

  //fluid property variables
  SI.Density rho=1000 "density of fluid"
    annotation (Dialog(group="Fluid properties"));
  Real eta=1e-3 "dynamic viscosity of fluid"
    annotation (Dialog(group="Fluid properties"));

  //split (incompressible)
  //input variable (mass flow rate) for split [left,right,bottom]
  SI.MassFlowRate m_flow_split_1[3]={+1,-(1 - sign(input_m_flow)*
      input_m_flow),-sign(input_m_flow)*input_m_flow} "mass flow rate"
                     annotation (Dialog(group="Input"));
  SI.MassFlowRate m_flow_split_3[3]={-(1 - sign(input_m_flow)*
      input_m_flow),+1,-sign(input_m_flow)*input_m_flow} "mass flow rate"
                     annotation (Dialog(group="Input"));
  SI.MassFlowRate m_flow_split_5[3]={-(1 - sign(input_m_flow)*
      input_m_flow),-sign(input_m_flow)*input_m_flow,+1} "mass flow rate"
                     annotation (Dialog(group="Input"));

  //joint (incompressible)
  //input variable (mass flow rate) for T-join
  SI.MassFlowRate m_flow_joint_2[3]={-1,1 - sign(input_m_flow)*
      input_m_flow,sign(input_m_flow)*input_m_flow} "mass flow rate"
    annotation (Dialog(group="Input"));
  SI.MassFlowRate m_flow_joint_4[3]={1 - sign(input_m_flow)*
      input_m_flow,-1,sign(input_m_flow)*input_m_flow} "mass flow rate"
                     annotation (Dialog(group="Input"));
  SI.MassFlowRate m_flow_joint_6[3]={1 - sign(input_m_flow)*
      input_m_flow,sign(input_m_flow)*input_m_flow,-1} "mass flow rate"
                     annotation (Dialog(group="Input"));

  //input record
  //A_side == A_straight == A_total
  //split (incompressible)
  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con_1(
    alpha=alpha[1],
    zeta_TOT_max=zeta_TOT_max,
    dp_min=dp_min,
    m_flow_min=m_flow_min,
    v_max=v_max,
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var_1(rho=rho)
    annotation (Placement(transformation(extent={{-60,13},{-40,33}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con_3(
    alpha=alpha[1],
    zeta_TOT_max=zeta_TOT_max,
    dp_min=dp_min,
    m_flow_min=m_flow_min,
    v_max=v_max,
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var_3(rho=rho)
    annotation (Placement(transformation(extent={{-10,13},{10,33}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con_5(
    alpha=alpha[1],
    zeta_TOT_max=zeta_TOT_max,
    dp_min=dp_min,
    m_flow_min=m_flow_min,
    v_max=v_max,
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
   FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var_5(rho=rho)
    annotation (Placement(transformation(extent={{40,13},{60,33}})));

  //joint (incompressible)
  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con_2(
    alpha=alpha[1],
    zeta_TOT_max=zeta_TOT_max,
    dp_min=dp_min,
    m_flow_min=m_flow_min,
    v_max=v_max,
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left)
    annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var_2(rho=rho)
    annotation (Placement(transformation(extent={{-60,-68},{-40,-48}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con_4(
    alpha=alpha[1],
    zeta_TOT_max=zeta_TOT_max,
    dp_min=dp_min,
    m_flow_min=m_flow_min,
    v_max=v_max,
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right)
    annotation (Placement(transformation(extent={{-10,-34},{10,-14}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var_4(rho=rho)
    annotation (Placement(transformation(extent={{-10,-68},{10,-48}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_con m_flow_IN_con_6(
    alpha=alpha[1],
    zeta_TOT_max=zeta_TOT_max,
    dp_min=dp_min,
    m_flow_min=m_flow_min,
    v_max=v_max,
    united_converging_crossection=false,
    d_hyd=d_hyd_noconv,
    flowSituation=FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric)
    annotation (Placement(transformation(extent={{40,-34},{60,-14}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjunction_IN_var m_flow_IN_var_6(rho=rho)
    annotation (Placement(transformation(extent={{40,-68},{60,-48}})));

  //output record
  //split (incompressible)

  //joint (incompressible)

  //boundary condition
  Real input_m_flow=input_mflow.y;

  Modelica.Blocks.Sources.Ramp input_mflow(
    offset=0,
    startTime=0,
    height=1,
    duration=1) annotation ( Placement(
        transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    amplitude=100,
    freqHz=1/100,
    phase=0,
    offset=0,
    startTime=0) annotation (Placement(
        transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1,
    offset=0,
    startTime=0) annotation (Placement(
        transformation(extent={{0,-100},{20,-80}})));

protected
  Real DP_plot1[3];
  Real zeta_LOC1[2] "plotting";
  Real DP_plot2[3];
  Real zeta_LOC2[2] "plotting";
  Real DP_plot3[3];
  Real zeta_LOC3[2] "plotting";
  Real DP_plot4[3];
  Real zeta_LOC4[2] "plotting";
  Real DP_plot5[3];
  Real zeta_LOC5[2] "plotting";
  Real DP_plot6[3];
  Real zeta_LOC6[2] "plotting";

equation
  //split (incompressible)
  //case 1
  (DP_plot1,,zeta_LOC1,,) = FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con_1,
    m_flow_IN_var_1,
    m_flow_split_1);
  //case 3
  (DP_plot3,,zeta_LOC3,,) = FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con_3,
    m_flow_IN_var_3,
    m_flow_split_3);
  //case 5
  (DP_plot5,,zeta_LOC5,,) = FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con_5,
    m_flow_IN_var_5,
    m_flow_split_5);

  //joint (incompressible)
  //case 2
  (DP_plot2,,zeta_LOC2,,) = FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con_2,
    m_flow_IN_var_2,
    m_flow_joint_2);
  //case 5
  (DP_plot4,,zeta_LOC4,,) = FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con_4,
    m_flow_IN_var_4,
    m_flow_joint_4);
  //case 6
  (DP_plot6,,zeta_LOC6,,) = FluidDissipation.PressureLoss.Junction.dp_Tjunction(
    m_flow_IN_con_6,
    m_flow_IN_var_6,
    m_flow_joint_6);

  annotation (
    __Dymola_Commands(file="modelica://FluidDissipation/Extras/Scripts/pressureLoss/junction/dp_Tjunction.mos" "dp_Tjunction"),
              Diagram(graphics={Text(
                  extent={{-34, 108}, {32, 58}},
                  lineColor={0,0,255},
                  textString="Target == DP (incompressible)"),
                Text(
                  extent={{-78, 140}, {80, 44}},
                  lineColor={0,0,255},
                  textString="Pressure loss in T-junction (joint/split)"),
                Text(
                  extent={{-32, 96}, {26, 56}},
                  lineColor={0,0,255},
                  textString="A_side == A_straight == A_total"),
                Text(
                  extent={{-114, 36}, {-62, 26}},
                  lineColor={0,0,255},
                  textString="split"),
                Text(
                  extent={{-116, -38}, {-64, -48}},
                  lineColor={0,0,255},
                  textString="T-join")}),
              experiment(Interval=0.0002, Tolerance=1e-005));
end dp_Tjunction;
