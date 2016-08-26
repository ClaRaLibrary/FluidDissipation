within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_idealGas "Verification of function dp_idealGas"

  parameter Integer n=size(dp_nom, 1);

  //general variables
  parameter Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));

  parameter Real p_1=1.1e5 "MEASURED pressure at input [Pa]";
  parameter Real dp_nom[3]={0.5e3,2e3,3e3} "Nominal pressure loss [Pa]";
  parameter Real p_2[n]={p_1 - dp_nom[i] for i in 1:n} "MEASURED pressure at output [Pa]";

  parameter Real m_flow_nom[n]=ones(n)*10 "Nominal mass flow rate [kg/s]";
  Real Km[n]={R_s*(p_1 - (p_2[i]))/((m_flow_nom[i])^exp/rho_m) for i in 1:n} "Coefficient for pressure loss law [(Pa)^2/{(kg/s)^exp*K}]";

  //fluid property variables
  parameter SI.SpecificHeatCapacity R_s=287 "Specific gas constant of ideal gas"
    annotation (Dialog(group="Fluid properties"));
  parameter SI.Density rho_m=p_m/(R_s*T_m) "Mean density of ideal gas"
    annotation (Dialog(group="Fluid properties"));
  parameter SI.Temp_K T_m=(293 + 293)/2 "Mean temperature of ideal gas"
    annotation (Dialog(group="Fluid properties"));
  parameter SI.Pressure p_m=(1e5 + 1e5)/2 "Mean pressure of ideal gas"
    annotation (Dialog(group="Fluid properties"));

  //linearisation
  parameter SI.Pressure dp_smooth=1e-6 "Start linearisation for smaller pressure loss"
    annotation (Dialog(group="Linearisation"));

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n} "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.General.dp_idealGas_IN_con m_flow_IN_con[n](
    each exp=exp,
    each R_s=R_s,
    Km=Km) annotation (Placement(transformation(extent={{-70,20},{-50,42}})));

  FluidDissipation.PressureLoss.General.dp_idealGas_IN_var m_flow_IN_var[n](
    each rho_m=rho_m,
    each T_m=T_m,
    each p_m=p_m)
    annotation (Placement(transformation(extent={{-50,20},{-30,42}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.General.dp_idealGas_IN_con dp_IN_con[n](
    each exp=exp,
    each R_s=R_s,
    Km=Km) annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_idealGas_IN_var dp_IN_var[n](
    each rho_m=rho_m,
    each T_m=T_m,
    each p_m=p_m)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //output variables
  //compressible fluid flow
  SI.MassFlowRate M_FLOW[n] "mass flow rate" annotation (Dialog(group="Output"));

  //incompressible fluid flow
  SI.Pressure DP[n] "pressure loss" annotation (Dialog(group="Output"));

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
    (,M_FLOW[i],,,,) = FluidDissipation.PressureLoss.General.dp_idealGas(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,,,,) = FluidDissipation.PressureLoss.General.dp_idealGas(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_idealGas.mos" "Verification of dp_idealGas"),
                                        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (ideal gas law dependence)"),
          Text(
          extent={{-85,16},{-10,6}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{11,16},{86,6}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)")}));
end dp_idealGas;
