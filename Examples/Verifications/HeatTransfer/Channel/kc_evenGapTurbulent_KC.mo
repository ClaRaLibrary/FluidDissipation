within FluidDissipation.Examples.Verifications.HeatTransfer.Channel;
model kc_evenGapTurbulent_KC "Verification of function kc_evenGapTurbulent_KC"

  parameter Integer n=size(cp, 1);
  parameter SI.Diameter d_hyd=2*s;

  SI.Velocity velocity[n]={m_flow[i]/(rho[i]*h*s) for i in 1:n};

  //even gap variables
  parameter SI.Length h=0.1 "Height of cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length s=0.05 "Distance between parallel plates in cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length L=1 "Overflowed length of gap"
    annotation (Dialog(group="Geometry"));

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550} "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114} "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387} "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //target variables
  //here: mass flow rate as input for normal calculation
  /*SI.MassFlowRate mflow_test=input_mflow_0.y;
  SI.MassFlowRate m_flow[:]={mflow_test*eta[1]/eta[3],mflow_test*eta[2]/eta[3],
      mflow_test} "mass flow rate" annotation (Dialog(group="Input"));
   SI.NusseltNumber Nu[n]={kc[i]*d_hyd/lambda[i] for i in 1:n};*/

  //here: Nusselt number as input for reverse calculation
  SI.NusseltNumber Nu[n]=ones(n)*input_Nu.y;
  SI.MassFlowRate m_flow[3](start=ones(n)*1e-2);
  SI.CoefficientOfHeatTransfer kc_OUT_1[n]={Nu[i]*lambda[i]/d_hyd for i in 1:n};

  //input record
  FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_IN_con m_flow_IN_con_1[n](
    each h=h,
    each s=s,
    each L=L) annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{0,20},{20,40}})));

  SI.ReynoldsNumber Re[n]={abs(m_flow[i])*d_hyd/(eta[i]*Modelica.Constants.pi*
      d_hyd*d_hyd/4) for i in 1:n};

public
  Modelica.Blocks.Sources.Ramp input_Nu(
    startTime=0,
    duration=1,
    offset=3e2,
    height=0.997e5)
                annotation (Placement(
        transformation(extent={{52,-80},{72,-60}})));
equation
  //heat transfer calculation
  kc_OUT_1 = {FluidDissipation.HeatTransfer.Channel.kc_evenGapTurbulent_KC(
    m_flow_IN_con_1[i], m_flow_IN_var_1[i]) for i in 1:n};

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Heat transfer of EVEN GAP for TURBULENT flow regime (inlining)"),
          Text(
          extent={{-98,-30},{102,-5}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}),
    experiment(StopTime=1.01));
end kc_evenGapTurbulent_KC;
