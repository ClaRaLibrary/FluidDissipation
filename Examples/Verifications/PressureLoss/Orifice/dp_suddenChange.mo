within FluidDissipation.Examples.Verifications.PressureLoss.Orifice;
model dp_suddenChange
  "Verification of function dp_suddenChange_DP AND dp_suddenChange_MFLOW"

  constant Real MIN=Modelica.Constants.eps;

  parameter Real m_flowoo=1;

  Real frac_A1toA2 "Ratio of small to large cross sectional area";

  //orifice variables
  SI.Area A_1=A_2*frac_A1toA2 "Small cross sectional area of orifice";
  SI.Area A_2=1e-2 "Large cross sectional area of orifice";
  SI.Length C_1=sqrt(4*A_1/PI)*PI
    "Perimeter of small cross sectional area of orifice";
  SI.Length C_2=sqrt(4*A_2/PI)*PI
    "Perimeter of large cross sectional area of orifice";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //intended input variables for records
  SI.MassFlowRate input_mdot(start=0) = m_flowoo*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp=DP
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_con dp_IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_var dp_IN_var(eta=eta,
      rho=rho) annotation (Placement(transformation(extent={{50,20},{70,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_con m_flow_IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2) annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_var m_flow_IN_var(eta=eta,
      rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  //output variables
  //target == DP (incompressible)
  SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));
  Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient"
    annotation (Dialog(group="Output"));

  //target == M_FLOW (compressible)
  SI.MassFlowRate M_FLOW "mass flow rate" annotation (Dialog(group="Output"));

  //plotting
  SI.Diameter d_hyd=4*A_1/max(MIN, C_1)
    "Hydraulic diameter of small cross sectional area of orifice";
  SI.Velocity velocity=abs(M_FLOW)/(rho*max(MIN, A_1))
    "Mean velocity in small cross sectional area";
  SI.ReynoldsNumber Re=rho*velocity*d_hyd/eta;

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP(m_flow=
        input_mdot, target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-110,-8},{-90,12}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW(dp=
        input_dp, target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{90,-6},{110,14}})));

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    duration=1,
    offset=0,
    height=400) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=200,
    offset=200) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=400) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));
equation
  //orifice variables
  der(frac_A1toA2) = 1;

  //incompressible fluid flow
  (DP,,zeta_TOT,,,) = FluidDissipation.PressureLoss.Orifice.dp_suddenChange(
    m_flow_IN_con,
    m_flow_IN_var,
    chosenTarget_DP);

  //compressible fluid flow
  (,M_FLOW,,,,) = FluidDissipation.PressureLoss.Orifice.dp_suddenChange(
    dp_IN_con,
    dp_IN_var,
    chosenTarget_MFLOW);

  annotation (
    __Dymola_Commands(file="modelica://FluidDissipation/Extras/Scripts/pressureLoss/orifice/dp_suddenChange.mos"
        "Verification of dp_suddenChange"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of SMOOTH orifice with SUDDEN CHANGE in cross sectional area for TURBULENT flow regime (inverse)"),
          Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)")}),
    experiment(Interval=0.0002));
end dp_suddenChange;
