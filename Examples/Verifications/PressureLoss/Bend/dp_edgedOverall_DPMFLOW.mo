within FluidDissipation.Examples.Verifications.PressureLoss.Bend;
model dp_edgedOverall_DPMFLOW "Verification of function dp_edgedOverall_DP AND dp_edged_Overall_MFLOW"

  constant Real MIN=Modelica.Constants.eps;

  parameter Integer n=size(delta, 1) "Number of different angles of turning of bend";

  //bend variables
  parameter SI.Area A_cross=PI*d_hyd^2/4 "Circular cross sectional area of bend";
  parameter SI.Conversions.NonSIunits.Angle_deg delta[4]={30,45,90,180} "Angle of turning";
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter";
  parameter SI.Length K=2e-5 "Roughness (average height of surface asperities)";
  parameter SI.Length L=d_hyd*10 "Length of bend along axis";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n](start=zeros(n)) = ones(n)*input_DP.y "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW[n](start=zeros(n)) "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP[n](start=zeros(n)) = {input_dp[i] for i in 1:n} "(Output) pressure loss (for intended incompressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con m_flow_IN_con[n](
    delta=delta*PI/180,
    each d_hyd=d_hyd,
    each K=K,
    each L=L) annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_var m_flow_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_con dp_IN_con[n](
    delta=delta*PI/180,
    each d_hyd=d_hyd,
    each K=K,
    each L=L) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.PressureLoss.Bend.dp_edgedOverall_IN_var dp_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";
  SI.Velocity velocity[n]={input_mdot[i]/(rho*A_cross) for i in 1:n} "Mean velocity";
  SI.ReynoldsNumber Re[n]={rho*velocity[i]*d_hyd/eta for i in 1:n};
  Real zeta_TOT[n]={2*abs(DP_plot[i])/(max(rho*(velocity[i])^2, 1e-5)) for i in
          1:n} "Pressure loss coefficients";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    duration=1,
    offset=0,
    height=276270) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));

equation
  //target == DP (incompressible)
  DP = {FluidDissipation.PressureLoss.Bend.dp_edgedOverall_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {FluidDissipation.PressureLoss.Bend.dp_edgedOverall_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/bend/dp_edgedOverall_DPMFLOW.mos" "Verification of dp_edgedOverall_DPMFLOW"),
                                                    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of EDGED bend for OVERALL flow regime (considering surface roughness | inlining)"),
          Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-100,-46},{100,-21}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end dp_edgedOverall_DPMFLOW;
