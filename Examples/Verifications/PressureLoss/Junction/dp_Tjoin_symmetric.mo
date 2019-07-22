within FluidDissipation.Examples.Verifications.PressureLoss.Junction;
model dp_Tjoin_symmetric "verification of function dp_Tjoin_symmetric"

  import minimum = Modelica.Constants.eps;
  import SI = Modelica.SIunits;

  //T-junction variables
  parameter Integer alpha=90;
  parameter SI.Diameter d_hyd[3]={((4/PI*1e-3))^0.5,((4/PI*1e-3))^0.5,
      (4/PI*1e-3)^0.5} "hydraulic diameter";

  //fluid property variables
  parameter SI.Density rho=1e3 "density of fluid"
    annotation (Dialog(group="FluidProperties"));

  //input variable (mass flow rate) for joint
  SI.MassFlowRate m_flow[3]={sign(input_m_flow)*input_m_flow,1 - sign(
      input_m_flow)*input_m_flow,-1} "mass flow rate"
    annotation (Dialog(group="Input"));

  //input record
  //incompressible fluid flow
  FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric_IN_con m_flow_IN_con(
    d_hyd=d_hyd,
    final m_flow_min=1e-6,
    final v_max=343,
    zeta_TOT_max=10)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric_IN_var m_flow_IN_var(rho=rho)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  //output record
  //incompressible fluid flow

  Real frac_Vflow13=M_FLOW[1]/max(abs(M_FLOW[3]),
      minimum);
  Real M_FLOW[3];
  Real DP_plot[2];
  Real zeta_LOC[2];

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
    startTime=0)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    outMax=100,
    riseTime=1e-1,
    riseTimeConst=1e-1,
    offset=0,
    startTime=0) annotation (Placement(
        transformation(extent={{0,-80},{20,-60}})));

equation
  (DP_plot,M_FLOW,zeta_LOC,,) =
    FluidDissipation.PressureLoss.Junction.dp_Tjoin_symmetric(
    m_flow_IN_con,
    m_flow_IN_var,
    m_flow);
  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/junction/dp_Tjoin_symmetric.mos"
        "verification of dp_Tjoin_symmetric"),  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
                    extent={{-100,50},{100,75}},
                    lineColor={0,0,255},
                    textString=
            "Pressure loss of SMOOTH T-junction for SYMMETRIC JOINING at TURBULENT flow regime"),
          Text(     extent={{-33,4},{42,-6}},
                    lineColor={0,0,255},
                    textString="A_cross_total =  A_cross_branches")}));
end dp_Tjoin_symmetric;
