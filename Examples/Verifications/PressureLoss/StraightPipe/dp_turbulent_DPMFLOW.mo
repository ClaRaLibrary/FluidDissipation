within FluidDissipation.Examples.Verifications.PressureLoss.StraightPipe;
model dp_turbulent_DPMFLOW "Verification of function dp_turbulent_DP AND dp_turbulent_MFLOW"

  Real MIN=Modelica.Constants.eps;

  parameter Integer n=size(K, 1);

  //straight pipe variables
  SI.Area A_cross=PI*d_hyd^2/4 "Circular cross sectional area of straight pipe";
  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered "Choice of considering surface roughness"
    annotation (Dialog(group="Straight pipe"));
  SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="Straight pipe"));
  SI.Length K[4]={0,2e-4*d_hyd,2e-3*d_hyd,2e-2*d_hyd} "Roughness (average height of surface asperities)"
    annotation (Dialog(group="Straight pipe"));
  SI.Length L=1 "Length" annotation (Dialog(group="Straight pipe"));

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
  FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_con m_flow_IN_con[n](
    each d_hyd=d_hyd,
    each L=L,
    K=K,
    each roughness=roughness)
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_var m_flow_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_con dp_IN_con[n](
    each d_hyd=d_hyd,
    each L=L,
    K=K,
    each roughness=roughness)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_IN_var dp_IN_var[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  //plotting
  SI.Velocity velocity[n]={M_FLOW[i]/(rho*A_cross) for i in 1:n} "Mean velocity";
  SI.ReynoldsNumber Re[n]={rho*velocity[i]*d_hyd/eta for i in 1:n};

  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";
  Real zeta_TOT[n]={2*abs(DP_plot[i])/max(MIN, rho*(velocity[i])^2) for i in 1:
      n} "Pressure loss coefficients";
  Real lambda_FRI[n]={zeta_TOT[i]*d_hyd/L for i in 1:n} "Frictional resistance coefficient";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    offset=0,
    duration=1,
    height=4e4) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));
equation
  //target == DP (incompressible)
  DP = {FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/straightPipe/dp_turbulent_DPMFLOW.mos" "Verification of dp_turbulent_DPMFLOW"),
                                                 Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of STRAIGHT PIPE for TURBULENT flow regime (inverse)"),
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
end dp_turbulent_DPMFLOW;
