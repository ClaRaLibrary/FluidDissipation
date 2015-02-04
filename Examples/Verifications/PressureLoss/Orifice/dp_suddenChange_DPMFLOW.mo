within FluidDissipation.Examples.Verifications.PressureLoss.Orifice;
model dp_suddenChange_DPMFLOW
  "Verification of function dp_suddenChange_DP AND dp_suddenChange_MFLOW"

  constant Real MIN=Modelica.Constants.eps;

  parameter Real dpoo=1;

  Real frac_A1toA2 "Ratio of small to large cross sectional area";

  //orifice variables
  SI.Area A_1=A_2*frac_A1toA2 "Small cross sectional area of orifice";
  SI.Area A_2=1e-2 "Large cross sectional area of orifice";
  SI.Length C_1=sqrt(4*A_1/PI)*PI
    "Perimeter of small cross sectional area of orifice";
  SI.Length C_2=sqrt(4*A_2/PI)*PI
    "Perimeter of large cross sectional area of orifice";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //intended input variables for records
  SI.MassFlowRate input_mdot(start=0)
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp(start=0) = dpoo*input_DP.y
    "(Input) pressure loss (for intended compressible case)";

  //intended output variables for records
  SI.MassFlowRate M_FLOW(start=0)
    "(Output) mass flow rate (for intended compressible case)";
  SI.Pressure DP(start=0) = input_dp
    "(Output) pressure loss (for intended incompressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_con dp_IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_var dp_IN_var(eta=eta,
      rho=rho) annotation (Placement(transformation(extent={{50,20},{70,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_con m_flow_IN_con(
    A_1=A_1,
    A_2=A_2,
    C_1=C_1,
    C_2=C_2) annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  FluidDissipation.PressureLoss.Orifice.dp_suddenChange_IN_var m_flow_IN_var(eta=eta,
      rho=rho)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  //plotting
  SI.Diameter d_hyd=4*A_1/max(MIN, C_1)
    "Hydraulic diameter of small cross sectional area of orifice";
  SI.Velocity velocity=abs(M_FLOW)/(rho*max(MIN, A_1))
    "Mean velocity in small cross sectional area";
  SI.ReynoldsNumber Re=rho*velocity*d_hyd/eta;

  Real DP_plot=DP "Pressure loss [Pa]";
  Real zeta_TOT=2*abs(DP_plot)/max(MIN, rho*(velocity)^2)
    "Pressure loss coefficients";

  Modelica.Blocks.Sources.Ramp input_DP(
    startTime=0,
    offset=0,
    duration=1,
    height=836) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));
equation
  //orifice variables
  der(frac_A1toA2) = 1;

  //incompressible fluid flow
  DP = FluidDissipation.PressureLoss.Orifice.dp_suddenChange_DP(
    m_flow_IN_con,
    m_flow_IN_var,
    input_mdot);

  //compressible fluid flow
  M_FLOW = FluidDissipation.PressureLoss.Orifice.dp_suddenChange_MFLOW(
    dp_IN_con,
    dp_IN_var,
    input_dp);

  annotation (
    __Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/orifice/dp_suddenChange_DPMFLOW.mos"
        "Verification of dp_suddenChange_DPMFLOW"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of SMOOTH orifice with SUDDEN CHANGE in cross sectional area for TURBULENT flow regime (inverse)"),
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
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}),
    experiment(Interval=0.0002));
end dp_suddenChange_DPMFLOW;
