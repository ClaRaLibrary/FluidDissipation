within FluidDissipation.Examples.Verifications.PressureLoss.Orifice;
model dp_thickEdgedOverall "Verification of function dp_thickEdgedOverall"

  constant Real MIN=Modelica.Constants.eps;

  parameter Integer n=size(A0_2_A1, 1)
    "Number of different ratios of cross sectional areas";

  //orifice variables
  parameter SI.Area A_0=1e-3 "Cross sectional area of vena contraction";
  parameter SI.Area A_1[n]={A_0/A0_2_A1[i] for i in 1:n}
    "Large cross sectional area of orifice";
  parameter SI.Length C_0=sqrt(4*A_0/PI)*PI "Perimeter of vena contraction";
  parameter SI.Length C_1[n]=sqrt(4*A_1/PI)*PI
    "Perimeter of large cross sectional area of orifice";
  parameter Real A0_2_A1[6]={0.02,0.08,0.20,0.40,0.70,0.90}
    "Ratio of cross sectional areas";

  SI.Length L(start=0) "Length of thick edged orifice";
  Real l_bar=L/sqrt(4*A_0/PI) "Relative length of orifice";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho=1000 "Density of fluid"
    annotation (Dialog(group="Fluid properties"));

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n}
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_con m_flow_IN_con[n](
    each A_0=A_0,
    A_1=A_1,
    each C_0=C_0,
    C_1=C_1,
    each L=L) annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_var m_flow_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_con dp_IN_con[n](
    each A_0=A_0,
    A_1=A_1,
    each C_0=C_0,
    C_1=C_1,
    each L=L) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_IN_var dp_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  //output variables
  //target == DP (incompressible)
  SI.Pressure DP[n] "Pressure loss [bar]" annotation (Dialog(group="Output"));
  Utilities.Types.PressureLossCoefficient zeta_TOT[n]
    "Pressure loss coefficient" annotation (Dialog(group="Output"));

  //target == M_FLOW (compressible)
  SI.MassFlowRate M_FLOW[n] "mass flow rate" annotation (Dialog(group="Output"));

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP[n](m_flow=
       input_mdot, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-110,-8},{-90,12}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW[n](dp=
        input_dp, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{90,-6},{110,14}})));

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    offset=0,
    duration=1,
    height=1) annotation ( Placement(transformation(
          extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=1) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=1) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

equation
  //orifice variables
  der(L) = 0.39;

  for i in 1:n loop
    (,M_FLOW[i],,,,) =
      FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,zeta_TOT[i],,,) =
      FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/orifice/dp_thickEdgedOverall.mos"
        "Verification of dp_thickEdgedOverall"), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of THICK EDGED ORIFICE in cross sectional area for OVERALL flow regime"),
          Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)")}));
end dp_thickEdgedOverall;
