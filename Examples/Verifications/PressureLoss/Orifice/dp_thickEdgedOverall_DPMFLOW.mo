within FluidDissipation.Examples.Verifications.PressureLoss.Orifice;
model dp_thickEdgedOverall_DPMFLOW "Verification of function dp_thickEdgedOverall_DP AND dp_thickEdgedOverall_MFLOW"

  constant Real MIN=Modelica.Constants.eps;

  parameter Integer n=size(A0_2_A1, 1) "Number of different ratios of cross sectional areas";

  //orifice variables
  parameter SI.Area A_0=1e-3 "Cross sectional area of vena contraction";
  parameter SI.Area A_1[n]={A_0/A0_2_A1[i] for i in 1:n} "Large cross sectional area of orifice";
  parameter SI.Length C_0=sqrt(4*A_0/PI)*PI "Perimeter of vena contraction";
  parameter SI.Length C_1[n]=sqrt(4*A_1/PI)*PI "Perimeter of large cross sectional area of orifice";
  parameter Real A0_2_A1[6]={0.02,0.08,0.20,0.40,0.70,0.90} "Ratio of cross sectional areas";

  SI.Length L(start=0) "Length of thick edged orifice";
  Real l_bar=L/sqrt(4*A_0/PI) "Relative length of orifice";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid"
    annotation (Dialog(group="Fluid properties"));
  SI.Density rho=1000 "Density of fluid"
    annotation (Dialog(group="Fluid properties"));

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n](start=zeros(n)) = ones(n)*input_DP.y "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW[n](start=zeros(n)) "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP[n](start=zeros(n)) = {input_dp[i] for i in 1:n} "(Output) pressure loss (for intended incompressible case)";

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

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";
  Real A_cross[n]={A_1[i] for i in 1:n};
  Real velocity[n]={input_mdot[1]/max(MIN, (rho*A_cross[i])) for i in 1:n};
  Real zeta_TOT[n]={2*DP[i]/max(MIN, (rho*(velocity[i]^2))) for i in 1:n};

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    duration=1,
    height=836,
    offset=0) annotation ( Placement(transformation(
          extent={{60,-80},{80,-60}})));

equation
  //orifice variables
  der(L) = 0.39;

  //target == DP (incompressible)
  DP = {FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {FluidDissipation.PressureLoss.Orifice.dp_thickEdgedOverall_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/orifice/dp_thickEdgedOverall_DPMFLOW.mos" "Verification of dp_thickEdgedOverall_DP and dp_thickEdgedOverall_MFLOW"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of THICK EDGED ORIFICE in cross sectional area for OVERALL flow regime (inverse)"),
          Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{-100,-50},{100,-25}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end dp_thickEdgedOverall_DPMFLOW;
