within FluidDissipation.Examples.Verifications.HeatTransfer.General;
model kc_approxForcedConvection
  "Verification of function kc_approxForcedConvection"
  parameter Integer n=size(cp, 1);

  //generic variables
  parameter SI.Area A_cross=Modelica.Constants.pi*0.1^2/4
    "Cross sectional area";
  parameter SI.Length perimeter=Modelica.Constants.pi*0.1 "Wetted perimeter";
  //parameter SI.Diameter d_hyd=4*A_cross/perimeter "Hydraulic diameter";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550}
    "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114}
    "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387}
    "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //input record
  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con m_flow_IN_con_1[n](
    each A_cross=A_cross,
    each perimeter=perimeter,
    each final target=FluidDissipation.Utilities.Types.kc_general.Rough)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow,
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
    m_flow=m_flow,
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
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{60,20},{80,40}})));

  //output variables
  SI.ReynoldsNumber Re_1[n] "Reynolds number"
    annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_1[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_2[n] "Nussel number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_3[n] "Nussel number" annotation (Dialog(group="Output"));
public
  Modelica.Blocks.Sources.Ramp input_mflow_0(
    duration=1,
    offset=0,
    height=1e4) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(amplitude=1, freqHz=1)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    riseTime=1e-1,
    riseTimeConst=1e-1,
    outMax=1) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));

protected
  SI.MassFlowRate m_flow[n]={input_mflow_0.y*eta[1]/eta[3],input_mflow_0.y*eta[
      2]/eta[3],input_mflow_0.y} "Mass flow rate";
equation
  //heat transfer calculation
  for i in 1:n loop
    (,,Re_1[i],Nu_1[i],) =
      FluidDissipation.HeatTransfer.General.kc_approxForcedConvection(
      m_flow_IN_con_1[i], m_flow_IN_var_1[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_2[i],) =
      FluidDissipation.HeatTransfer.General.kc_approxForcedConvection(
      m_flow_IN_con_2[i], m_flow_IN_var_2[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_3[i],) =
      FluidDissipation.HeatTransfer.General.kc_approxForcedConvection(
      m_flow_IN_con_3[i], m_flow_IN_var_3[i]);
  end for;
  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/general/kc_approxForcedConvection.mos"
        "Verification of kc_approxForcedConvection"),Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
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
            "Heat transfer of GENERIC calculation for forced convection for TURBULENT flow regime")}),
    experiment(StopTime=1.01));
end kc_approxForcedConvection;
