within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_pressureLossCoefficient_DPMFLOW "Verification of function dp_pressureLossCoefficient_DP and dp_pressureLossCoefficient_MFLOW"

  //general variables
  parameter Integer n=3 "Number of grid points";

  parameter SI.Area A_cross=Modelica.Constants.pi*0.1^2/4 "Circular cross sectional area";
  parameter TYP.PressureLossCoefficient zeta_TOT[n]={0.01,0.1,1} "Pressure loss coefficient";

  //fluid property variables
  SI.Density rho=1.2 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n](start=zeros(n)) = ones(n)*input_DP.y "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW[n](start=zeros(n)) "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP[n](start=zeros(n)) = {input_dp[i] for i in 1:n} "(Output) pressure loss (for intended incompressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con m_flow_IN_con[n](each
      A_cross=A_cross)
    annotation (Placement(transformation(extent={{-70,20},{-50,42}})));

  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var m_flow_IN_var[n](each
      rho=rho, zeta_TOT=zeta_TOT)
    annotation (Placement(transformation(extent={{-50,20},{-30,42}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con dp_IN_con[n](each
      A_cross=A_cross)
    annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var dp_IN_var[n](each
      rho=rho, zeta_TOT=zeta_TOT)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    offset=0,
    duration=1,
    height=6757) annotation (Placement(
        transformation(extent={{60,-80},{80,-60}})));

equation
  //target == DP (incompressible)
  DP = {FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {
    FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_pressureLossCoefficient_DPMFLOW.mos" "Verification of dp_pressureLossCoefficient_DP and dp_pressureLossCoefficient_MFLOW"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (pressure loss coefficient dependence | inverse)"),
          Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)"),Text(
          extent={{-98,-50},{102,-25}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end dp_pressureLossCoefficient_DPMFLOW;
