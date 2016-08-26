within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_nominalPressureLossLawDensity "Verification of function dp_nominalPressureLossLawDensity"

  parameter Integer n=size(rho, 1) "number of different fluid density values";

  //general variables
  FluidDissipation.Utilities.Types.MassOrVolumeFlowRate target=FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate "1 == use nominal mass flow rate | 2 == use nominal volume flow rate"
    annotation (Dialog(group="Generic variables"));
  SI.Area A_cross=A_cross_nom "Cross sectional area"
    annotation (Dialog(group="Generic variables"));
  SI.Area A_cross_nom=Modelica.Constants.pi*0.1^2/4 "Nominal cross sectional area"
    annotation (Dialog(group="Generic variables"));
  SI.Pressure dp_nom=50 "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  SI.MassFlowRate m_flow_nom=1 "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  SI.VolumeFlowRate V_flow_nom=m_flow_nom/rho_nom "Nominal volume flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=0.05*1/0.1 "Pressure loss coefficient"
                                annotation (Dialog(group="Generic variables"));
  FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT_nom=1 "Nominal pressure loss coefficient (for nominal values)"
    annotation (Dialog(group="Generic variables"));
  SI.Density rho_nom=1e3 "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));

  //fluid property variables
  SI.Density rho[:]={1e3,1.5e3,2e3} "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n)) = ones(n)*input_mflow_0.y "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n]={DP[i] for i in 1:n} "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_con
    m_flow_IN_con[n](
    each exp=exp,
    each m_flow_nom=m_flow_nom,
    each A_cross=A_cross,
    each A_cross_nom=A_cross_nom,
    each dp_nom=dp_nom,
    each V_flow_nom=V_flow_nom,
    each zeta_TOT_nom=zeta_TOT_nom,
    each rho_nom=rho_nom,
    each target=target)
    annotation (Placement(transformation(extent={{-70,20},{-50,42}})));

  FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_var
    m_flow_IN_var[n](each zeta_TOT=zeta_TOT, rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,42}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_con
    dp_IN_con[n](
    each exp=exp,
    each m_flow_nom=m_flow_nom,
    each rho_nom=rho_nom,
    each target=target,
    each A_cross=A_cross,
    each A_cross_nom=A_cross_nom,
    each dp_nom=dp_nom,
    each V_flow_nom=V_flow_nom,
    each zeta_TOT_nom=zeta_TOT_nom)
    annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_var
    dp_IN_var[n](rho=rho, each zeta_TOT=zeta_TOT)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //output record
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
    outMax=1) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";
equation
  for i in 1:n loop
    (,M_FLOW[i],,,,) =
      FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity(
      dp_IN_con[i],
      dp_IN_var[i],
      chosenTarget_MFLOW[i]);
  end for;

  for i in 1:n loop
    (DP[i],,,,,) =
      FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity(
      m_flow_IN_con[i],
      m_flow_IN_var[i],
      chosenTarget_DP[i]);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_nominalPressureLossLawDensity.mos" "Verification of dp_nominalPressureLossLawDensity"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (pressure loss law dependence)"),
          Text(
          extent={{-83,14},{-8,4}},
          lineColor={0,0,255},
          textString="Target == DP (incompressible)"),Text(
          extent={{13,14},{88,4}},
          lineColor={0,0,255},
          textString="Target == M_FLOW (compressible)")}),
    experiment(Interval=0.0002, Tolerance=1e-005),
    __Dymola_experimentSetupOutput(events=false));
end dp_nominalPressureLossLawDensity;
