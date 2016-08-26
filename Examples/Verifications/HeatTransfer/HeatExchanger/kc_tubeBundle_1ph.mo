within FluidDissipation.Examples.Verifications.HeatTransfer.HeatExchanger;
model kc_tubeBundle_1ph "Verification of function kc_tubeBundle_1ph"

  parameter Integer n=2 "number of variants";

  //Heat exchanger variables
  parameter Modelica.SIunits.Area A_front(min=1e-6)=1 "Cross sectional area in front of the tube row or bundle";
  parameter Modelica.SIunits.Length d(min=1e-6) = 0.0164 "Outer diameter of tubes";

protected
  parameter SI.Length s[n]={d*2.0, d*2.0};

public
  parameter Boolean staggeredAlignment[n] = {true, false} "True, if the tubes are aligned staggeredly, false otherwise | don't care for single row"
    annotation (Dialog(group="Geometry"));
  parameter Integer n_rows[n](min=1) = {10, 10} "Number of pipe rows in flow direction";

  SI.PrandtlNumber Pr=eta*cp/lambda;

  //fluid property variables

  parameter SI.SpecificHeatCapacityAtConstantPressure cp=1007 "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta=18.04e-6 "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda=25.3e-3 "Thermal conductivity of fluid";
  parameter SI.Density rho=1.217 "Density of fluid";

  //input variables
  SI.ReynoldsNumber Re = input_Re.y "Reynolds number" annotation (Dialog(group="Input"));

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

  //output variables
  SI.MassFlowRate m_flow[n] "Mass flow rate" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu[n] "Nusselt number" annotation (Dialog(group="Output"));
  SI.CoefficientOfHeatTransfer[n] kc "Heat transfer coefficient";

public
  Modelica.Blocks.Sources.Ramp input_Re(
    duration=1,
    startTime=0,
    offset=1,
    height=1000000)
              annotation (Placement(transformation(
          extent={{-80,-80},{-60,-60}})));

equation
  //heat transfer calculation
  (kc[1],,Re,Nu[1],) =
   FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph(
    m_flow_IN_con_1, m_flow_IN_var_1);
  (kc[2],,Re,Nu[2],) =
    FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph(
    m_flow_IN_con_2, m_flow_IN_var_2);

  annotation (Diagram(graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of heat exchanger tube bundles and SINGLE phase fluids"),
                                                                          Text(
          extent={{-150,21},{50,16}},
          lineColor={0,0,255},
          textString="staggered tubes"),                                  Text(
          extent={{-50,21},{150,16}},
          lineColor={0,0,255},
          textString="in-line tubes")}),
          __Dymola_Commands(file="modelica://FluidDissipation/Extras/Scripts/heatTransfer/heatExchanger/kc_tubeBundle_1ph.mos" "Verification of kc_tubeBundle_1ph"),
    experiment(Interval=2e-005),
    __Dymola_experimentSetupOutput);
end kc_tubeBundle_1ph;
