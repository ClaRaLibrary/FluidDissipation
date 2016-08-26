within FluidDissipation.Examples.Verifications.PressureLoss.StraightPipe;
model dp_turbulent "Verification of function dp_turbulent"

  Real MIN=Modelica.Constants.eps;

  parameter Integer n=size(K, 1);

  //straight pipe variables
  SI.Area A_cross=PI*d_hyd^2/4 "Circular cross sectional area of straight pipe";
  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered "Choice of considering surface roughness"
    annotation (Dialog(group="Straight pipe"));
  SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="Straight pipe"));
  SI.Length K[4]={2e-5*d_hyd,2e-4*d_hyd,2e-3*d_hyd,2e-2*d_hyd} "Roughness (average height of surface asperities)"
    annotation (Dialog(group="Straight pipe"));
  SI.Length L=1 "Length" annotation (Dialog(group="Straight pipe"));

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n} "(Input) pressure loss (for intended compressible case)";

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

  //output variables
  SI.Pressure DP[n] "pressure loss" annotation (Dialog(group="Output"));
  SI.MassFlowRate M_FLOW[n] "mass flow rate" annotation (Dialog(group="Output"));

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP[n](m_flow=
       input_mdot, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-110,-8},{-90,12}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW[n](dp=
        input_dp, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{90,-6},{110,14}})));

  //plotting
  SI.Velocity velocity[n]={abs(input_mdot[i])/(rho*A_cross) for i in 1:n} "Mean velocity";
  SI.ReynoldsNumber Re[n]={rho*abs(velocity[i])*d_hyd/eta for i in 1:n};

  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";
  Real zeta_TOT[n]={2*abs(DP_plot[i])/max(MIN, rho*(velocity[i])^2) for i in 1:
      n} "Pressure loss coefficients";
  Real lambda_FRI[n]={zeta_TOT[i]*d_hyd/L for i in 1:n} "Frictional resistance coefficient";

  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    offset=0,
    duration=1,
    height=100) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=100) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=100) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));
equation
  for i in 1:n loop
    (,M_FLOW[i],,,,) = FluidDissipation.PressureLoss.StraightPipe.dp_turbulent(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,,,,) = FluidDissipation.PressureLoss.StraightPipe.dp_turbulent(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/straightPipe/dp_turbulent.mos" "Verification of dp_turbulent"),
                                         Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Pressure loss of STRAIGHT PIPE for TURBULENT flow regime"),
          Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)")}));
end dp_turbulent;
