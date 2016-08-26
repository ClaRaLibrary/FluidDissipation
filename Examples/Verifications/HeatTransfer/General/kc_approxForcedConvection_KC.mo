within FluidDissipation.Examples.Verifications.HeatTransfer.General;
model kc_approxForcedConvection_KC "Verification of function kc_approxForcedConvection_KC"
  parameter Integer n=size(cp, 1);

  //generic variables
  parameter SI.Area A_cross=Modelica.Constants.pi*0.1^2/4 "Cross sectional area";
  parameter SI.Length perimeter=Modelica.Constants.pi*0.1 "Wetted perimeter";
  //parameter SI.Diameter d_hyd=4*A_cross/perimeter "Hydraulic diameter";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550} "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114} "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387} "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu[n]=ones(n)*input_Nu.y;
  SI.MassFlowRate m_flow_1[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_2[3](start=ones(n)*1e-6);
  SI.MassFlowRate m_flow_3[3](start=ones(n)*1e-6);

  SI.CoefficientOfHeatTransfer kc_1[n]={Nu[i]*lambda[i]/perimeter for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_2[n]={Nu[i]*lambda[i]/perimeter for i in 1:n};
  SI.CoefficientOfHeatTransfer kc_3[n]={Nu[i]*lambda[i]/perimeter for i in 1:n};

  //input record
  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con m_flow_IN_con_1[n](
    each A_cross=A_cross,
    each perimeter=perimeter,
    each final target=FluidDissipation.Utilities.Types.kc_general.Rough)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow_1,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con m_flow_IN_con_2[n](
    each A_cross=A_cross,
    each perimeter=perimeter,
    each final target=FluidDissipation.Utilities.Types.kc_general.Middle)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var m_flow_IN_var_2[n](
    m_flow=m_flow_2,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    eta_wall=eta)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con m_flow_IN_con_3[n](
    each A_cross=A_cross,
    each perimeter=perimeter,
    each final target=FluidDissipation.Utilities.Types.kc_general.Finest)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var m_flow_IN_var_3[n](
    m_flow=m_flow_3,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{60,20},{80,40}})));

  SI.ReynoldsNumber Re_1[n]={abs(m_flow_1[i])*(perimeter/PI)/(eta[i]*A_cross)
      for i in 1:n};
  SI.ReynoldsNumber Re_2[n]={abs(m_flow_2[i])*(perimeter/PI)/(eta[i]*A_cross)
      for i in 1:n};
  SI.ReynoldsNumber Re_3[n]={abs(m_flow_3[i])*(perimeter/PI)/(eta[i]*A_cross)
      for i in 1:n};

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    height=1e6,
    offset=1000) annotation (Placement(
        transformation(extent={{52,-80},{72,-60}})));
equation
  //heat transfer calculation
  kc_1 = {FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};
  kc_2 = {FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC(
    m_flow_IN_con_2[i], m_flow_IN_var_2[i]) for i in 1:n};
  kc_3 = {FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC(
    m_flow_IN_con_3[i], m_flow_IN_var_3[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/general/kc_approxForcedConvection_KC.mos" "Verification of kc_approxForcedConvection_KC"),
                                                        Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={Text(
           extent={{-92,12},{-32,6}},
           lineColor={0,0,255},
          textString="Target == Rough "),
                                      Text(
           extent={{-34,12},{28,6}},
           lineColor={0,0,255},
          textString="Target == Middle"),
                                     Text(
           extent={{34,12},{80,6}},
           lineColor={0,0,255},
          textString="Target == Finest"),
                                     Text(
           extent={{-102,50},{98,75}},
           lineColor={0,0,255},
           textString=
             "Heat transfer of GENERIC calculation for forced convection for TURBULENT flow regime (inlining)"),
                                                 Text(
          extent={{-100,-44},{100,-19}},
          lineColor={0,0,255},
          textString=
            "Here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}),
     experiment(StopTime=1.01));
end kc_approxForcedConvection_KC;
