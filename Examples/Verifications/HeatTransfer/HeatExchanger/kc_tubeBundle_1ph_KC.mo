within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_tubeBundle_1ph_KC "Verification of function kc_tubeBundle_1ph_KC"

  parameter Integer n=2 "number of variants";

  //Heat exchanger variables
  parameter Modelica.SIunits.Area A_front(min=1e-6)=1
    "Cross sectional area in front of the tube row or bundle";
  parameter Modelica.SIunits.Length d(min=1e-6) = 0.0164
    "Outer diameter of tubes";

protected
  parameter SI.Length s[n]={d*1.25, d*2.0};

public
  parameter Boolean staggeredAlignment[n] = {true, false}
    "True, if the tubes are aligned staggeredly, false otherwise | don't care for single row"
    annotation (Dialog(group="Geometry"));
  parameter Integer n_rows[n](min=1) = {10, 10}
    "Number of pipe rows in flow direction";

protected
  parameter Modelica.SIunits.Length L = Modelica.Constants.pi/2*d;

public
  SI.PrandtlNumber Pr=eta*cp/lambda;

  //fluid property variables

  parameter SI.SpecificHeatCapacityAtConstantPressure cp=1007
    "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta=18.04e-6 "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda=25.3e-3
    "Thermal conductivity of fluid";
  parameter SI.Density rho=1.217 "Density of fluid";

  //here: Nusselt number as input for inverse calculation
  SI.NusseltNumber Nu = input_Nu.y;
  SI.MassFlowRate m_flow[n](start=ones(n)*1e-6);

  //input records

  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con
                                                                 m_flow_IN_con_1(
    A_front=A_front,
    d=d,
    s_1=s[1],
    s_2=s[1],
    n=n_rows[1],
    staggeredAlignment=staggeredAlignment[1])
    annotation (Placement(transformation(extent={{-70,-8},{-50,12}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var
                                                                 m_flow_IN_var_1(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    cp_w=cp,
    eta_w=eta,
    lambda_w=lambda,
    m_flow=m_flow[1])
                  annotation (Placement(transformation(extent={{-50,-8},{-30,12}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con
                                                                 m_flow_IN_con_2(
    A_front=A_front,
    d=d,
    s_1=s[2],
    s_2=s[2],
    n=n_rows[2],
    staggeredAlignment=staggeredAlignment[2])
    annotation (Placement(transformation(extent={{30,-8},{50,12}})));
  FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var
                                                                 m_flow_IN_var_2(
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    cp_w=cp,
    eta_w=eta,
    lambda_w=lambda,
    m_flow=m_flow[2])
                  annotation (Placement(transformation(extent={{50,-8},{70,12}})));

  SI.ReynoldsNumber Re_1=abs(m_flow_IN_var_1.m_flow)/m_flow_IN_con_1.A_front/m_flow_IN_var_1.rho*L/psi[1]/m_flow_IN_var_1.eta*m_flow_IN_var_1.rho;
  SI.ReynoldsNumber Re_2=abs(m_flow_IN_var_2.m_flow)/m_flow_IN_con_2.A_front/m_flow_IN_var_2.rho*L/psi[2]/m_flow_IN_var_2.eta*m_flow_IN_var_2.rho;

  Real psi[n] = {if b[i] >= 1 or b[i] <= 0 then 1 - Modelica.Constants.pi/4/a[i] else 1 - Modelica.Constants.pi/4/a[i]/b[i] for i in 1:n};

  Real a[n] = {m_flow_IN_con_1.s_1/m_flow_IN_con_1.d, m_flow_IN_con_2.s_1/m_flow_IN_con_2.d};
  Real b[n] = {m_flow_IN_con_1.s_2/m_flow_IN_con_1.d, m_flow_IN_con_2.s_2/m_flow_IN_con_2.d};

  //output variables
  SI.CoefficientOfHeatTransfer[n] kc = {Nu*lambda/L for i in 1:n}
    "Heat transfer coefficient";

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    offset=1,
    height=5e3)
              annotation (Placement(transformation(
          extent={{50,-80},{70,-60}})));
equation
  //heat transfer calculation
  kc[1] =
   FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC(
    m_flow_IN_con_1, m_flow_IN_var_1);
  kc[2] =
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC(
    m_flow_IN_con_2, m_flow_IN_var_2);

  annotation (Diagram(graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of heat exchanger tube bundles and SINGLE phase fluids (inline)"),
                                                                          Text(
          extent={{-150,21},{50,16}},
          lineColor={0,0,255},
          textString="staggered tubes"),                                  Text(
          extent={{-50,21},{150,16}},
          lineColor={0,0,255},
          textString="in-line tubes")}),
          __Dymola_Commands(file="modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_tubeBundle_1ph_KC.mos"
        "Verification of kc_tubeBundle_1ph_KC"));
end kc_tubeBundle_1ph_KC;
