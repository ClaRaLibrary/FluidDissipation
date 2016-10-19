within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_pressureLossCoefficient
  "Verification of function dp_pressureLossCoefficient"

  //general variables
  parameter Integer n=3 "number of grid points";

  parameter SI.Area A_cross=Modelica.Constants.pi*0.1^2/4
    "Circular cross sectional area";
  parameter TYP.PressureLossCoefficient zeta_TOT[n]={0.01,0.1,1}
    "Pressure loss coefficient";

  //fluid property variables
  SI.Density rho=1.2 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n}
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //incompressible fluid flow
  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con m_flow_IN_con[n](each
      A_cross=A_cross)
    annotation (Placement(transformation(extent={{-70,20},{-50,42}})));

  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var m_flow_IN_var[n](each
      rho=rho, zeta_TOT=zeta_TOT)
    annotation (Placement(transformation(extent={{-50,20},{-30,42}})));

  //compressible fluid flow
  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_con dp_IN_con[n](each
      A_cross=A_cross)
    annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient_IN_var dp_IN_var[n](each
      rho=rho, zeta_TOT=zeta_TOT)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //output variables
  //target == DP (incompressible)
  SI.Pressure DP[n] "pressure loss" annotation (Dialog(group="Output"));

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
  for i in 1:n loop
    (,M_FLOW[i],,,,) =
      FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,,,,) =
      FluidDissipation.PressureLoss.General.dp_pressureLossCoefficient(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_pressureLossCoefficient.mos"
        "Verification of dp_pressureLossCoefficient"), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (pressure loss coefficient dependence)"),
          Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)")}));
end dp_pressureLossCoefficient;
