within FluidDissipation.Examples.Verifications.PressureLoss.General;
model dp_nominalPressureLossLawDensity_DPMFLOW
  "Verification of function dp_nominalPressureLossLawDensity_DP and dp_nominalPressureLossLawDensity_MFLOW"

  parameter Integer n=size(rho, 1) "number of different fluid density values";

  //general variables
  SI.Area A_cross=A_cross_nom "Cross sectional area"
    annotation (Dialog(group="Generic variables"));
  SI.Area A_cross_nom=Modelica.Constants.pi*0.1^2/4
    "Nominal cross sectional area"
    annotation (Dialog(group="Generic variables"));
  SI.Pressure dp_nom=50
    "Nominal pressure loss (at nominal values of mass flow rate and density)"
    annotation (Dialog(group="Generic variables"));
  SI.MassFlowRate m_flow_nom=1
    "Nominal mass flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  Real exp=2 "Exponent of pressure loss law"
    annotation (Dialog(group="Generic variables"));
  Integer NominalMassFlowRate=1
    "true == use nominal mass flow rate | false == nominal volume flow rate"
    annotation (Dialog(group="Generic variables"));
  SI.VolumeFlowRate V_flow_nom=m_flow_nom/rho_nom
    "Nominal volume flow rate (at nominal values of pressure loss and density)"
    annotation (Dialog(group="Generic variables"));
  FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT=0.05*1/0.1
    "Pressure loss coefficient" annotation (Dialog(group="Generic variables"));
  FluidDissipation.Utilities.Types.PressureLossCoefficient zeta_TOT_nom=1
    "Nominal pressure loss coefficient (for nominal values)"
    annotation (Dialog(group="Generic variables"));
  SI.Density rho_nom=1e3
    "Nominal density (at nominal values of mass flow rate and pressure loss)"
    annotation (Dialog(group="Generic variables"));

  //fluid property variables
  SI.Density rho[:]={1e3,1.5e3,2e3} "density of fluid"
    annotation (Dialog(group="FluidProperties"));

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot[n](start=zeros(n))
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp[n](start=zeros(n)) = ones(n)*input_DP.y
    "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW[n](start=zeros(n))
    "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP[n](start=zeros(n)) = {input_dp[i] for i in 1:n}
    "(Output) pressure loss (for intended incompressible case)";

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
    each rho_nom=rho_nom)
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
    each A_cross=A_cross,
    each A_cross_nom=A_cross_nom,
    each dp_nom=dp_nom,
    each V_flow_nom=V_flow_nom,
    each zeta_TOT_nom=zeta_TOT_nom)
    annotation (Placement(transformation(extent={{30,20},{50,42}})));

  FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_var
    dp_IN_var[n](rho=rho, each zeta_TOT=zeta_TOT)
    annotation (Placement(transformation(extent={{50,20},{70,42}})));

  //plotting
  Real DP_plot[n]={DP[i] for i in 1:n} "Pressure loss [Pa]";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    offset=0,
    duration=1,
    height=2.5e5) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));
equation
  //target == DP (incompressible)
  DP = {
    FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_DP(
    m_flow_IN_con[i],
    m_flow_IN_var[i],
    input_mdot[i]) for i in 1:n};

  //target == M_FLOW (compressible)
  M_FLOW = {
    FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_MFLOW(
    dp_IN_con[i],
    dp_IN_var[i],
    input_dp[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/general/dp_nominalPressureLossLawDensity_DPMFLOW.mos"
        "Verification of dp_nominalPressureLossLawDensity_DPMFLOW"), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of GENERIC geometry (pressure loss law dependence | inverse)"),
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
end dp_nominalPressureLossLawDensity_DPMFLOW;
