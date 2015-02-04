within FluidDissipation.Examples.Verifications.HeatTransfer.Channel;
model kc_evenGapLaminar "Verification of function kc_evenGapLaminar"

  parameter Integer n=size(cp, 1);
  parameter SI.Diameter d_hyd=2*s;

  Real abscissa[n]={(length/d_hyd/(max(Re[i], 1e-3)*Pr[i]))^0.5 for i in 1:n};
  SI.Length length=L;
  SI.Length dimlesslength(start=1e-2);
  SI.PrandtlNumber Pr[n]={eta[i]*cp[i]/(lambda[i]) for i in 1:n};
  SI.ReynoldsNumber Re[n]={rho[i]*velocity[i]*d_hyd/eta[i] for i in 1:n};
  SI.Velocity velocity[n]={m_flow[i]/(rho[i]*h*s) for i in 1:n};

  //even gap variables
  parameter SI.Length h=0.1 "Height of cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length s=0.05
    "Distance between parallel plates in cross sectional area"
    annotation (Dialog(group="Geometry"));
  parameter SI.Length L=1 "Overflowed length of gap"
    annotation (Dialog(group="Geometry"));

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550}
    "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114}
    "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387}
    "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //input record
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_1[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.DevOne)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_1[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_2[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.DevBoth)
              annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_2[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_3[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.UndevOne)
              annotation (Placement(transformation(extent={{10,20},{30,40}})));
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_3[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{30,20},{50,40}})));

  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_con m_flow_IN_con_4[n](
    each h=h,
    each s=s,
    each L=L,
    each final target=FluidDissipation.Utilities.Types.kc_evenGap.UndevBoth)
              annotation (Placement(transformation(extent={{60,20},{80,40}})));
  FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar_IN_var m_flow_IN_var_4[n](
    m_flow=m_flow,
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho) annotation (Placement(transformation(extent={{80,20},{100,40}})));

  //output variables
  SI.NusseltNumber Nu_1[n] "Nusselt number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_2[n] "Nusselt number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_3[n] "Nusselt number" annotation (Dialog(group="Output"));
  SI.NusseltNumber Nu_4[n] "Nusselt number" annotation (Dialog(group="Output"));

protected
  SI.MassFlowRate m_flow[n]={0.5*h*lambda[i]*length/(cp[i]*d_hyd*dimlesslength^
      2) for i in 1:n};
equation
  der(dimlesslength) = 1 - 0.01;

  //heat transfer calculation

  for i in 1:n loop
    (,,,Nu_1[i],) = FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar(
      m_flow_IN_con_1[i], m_flow_IN_var_1[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_2[i],) = FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar(
      m_flow_IN_con_2[i], m_flow_IN_var_2[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_3[i],) = FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar(
      m_flow_IN_con_3[i], m_flow_IN_var_3[i]);
  end for;

  for i in 1:n loop
    (,,,Nu_4[i],) = FluidDissipation.HeatTransfer.Channel.kc_evenGapLaminar(
      m_flow_IN_con_4[i], m_flow_IN_var_4[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/channel/kc_evenGapLaminar.mos"
        "Verification of kc_evenGapLaminar"),Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of EVEN GAP for LAMINAR flow regime"),Text(
          extent={{-160,11},{40,6}},
          lineColor={0,0,255},
          textString="Target == DevOne "),Text(
          extent={{-120,11},{80,6}},
          lineColor={0,0,255},
          textString="Target == DevBoth"),Text(
          extent={{-82,11},{118,6}},
          lineColor={0,0,255},
          textString="Target == UndevOne"),Text(
          extent={{-40,11},{160,6}},
          lineColor={0,0,255},
          textString="Target == UndevBoth"),Text(
          extent={{-100,-100},{100,40}},
          lineColor={0,0,255},
          textString=
            "Target == DevOne >>>>>> DEVELOPED fluid flow AND heat transfer at ONE side"),
          Text(
          extent={{-100,-100},{100,30}},
          lineColor={0,0,255},
          textString=
            "Target == DevBoth >>>> DEVELOPED fluid flow AND heat transfer at BOTH sides"),
          Text(
          extent={{-100,-100},{100,20}},
          lineColor={0,0,255},
          textString=
            "Target == UndevOne >>>> UNDEVELOPED fluid flow AND heat transfer at ONE side"),
          Text(
          extent={{-100,-100},{100,10}},
          lineColor={0,0,255},
          textString="Target == UndevBoth >> UNDEVELOPED fluid flow AND heat transfer at BOTH sides")}),
    experiment(StopTime=1.01));
end kc_evenGapLaminar;
