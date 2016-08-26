within FluidDissipation.Examples.Verifications.HeatTransfer.Plate;
model kc_turbulent "Verification of function kc_turbulent"

  parameter Integer n=size(cp, 1);

  //plate variable
  parameter SI.Length L=1 "Length of plate";

  //fluid property variables
  parameter SI.SpecificHeatCapacityAtConstantPressure cp[:]={1007,4189,3384.550} "Specific heat capacity at constant pressure of fluid";
  parameter SI.DynamicViscosity eta[:]={18.24e-6,1001.6e-6,0.114} "Dynamic viscosity of fluid";
  parameter SI.ThermalConductivity lambda[:]={25.69e-3,598.5e-3,0.387} "Thermal conductivity of fluid";
  parameter SI.Density rho[:]={1.188,998.21,1037.799} "Density of fluid";

  //target variables
  //here: mass flow rate as input for normal calculation
  Modelica.SIunits.Velocity velocity[n]={input_v_0.y*eta[1]/eta[3]*rho[3]/rho[1],
      input_v_0.y*eta[2]/eta[3]*rho[3]/rho[2],input_v_0.y};

  //input record
  FluidDissipation.HeatTransfer.Plate.kc_turbulent_IN_con IN_con[n](each L=L)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  FluidDissipation.HeatTransfer.Plate.kc_turbulent_IN_var IN_var[n](
    cp=cp,
    eta=eta,
    lambda=lambda,
    rho=rho,
    velocity=velocity)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  //output variables
  SI.NusseltNumber Nu[n] "Nussel number" annotation (Dialog(group="Output"));

  SI.PrandtlNumber Pr[n]={eta[i]*cp[i]/lambda[i] for i in 1:n} "Prandtl number";
  SI.ReynoldsNumber Re[n]={rho[i]*abs(velocity[i])*L/eta[i] for i in 1:n} "Reynolds number";

public
  Modelica.Blocks.Sources.Ramp input_v_0(
    duration=1,
    startTime=0,
    height=1e4,
    offset=1e-6) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_v_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=10) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_v_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=10) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));
equation
  //heat transfer calculation
  for i in 1:n loop
    (,,,Nu[i],) = FluidDissipation.HeatTransfer.Plate.kc_turbulent(IN_con[i],
      IN_var[i]);
  end for;

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/plate/kc_turbulent.mos" "Verification of kc_turbulent"),
                                         Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString="Heat transfer of plate for TURBULENT flow regime"),
                                                                       Text(
          extent={{-100,11},{100,6}},
          lineColor={0,0,255},
          textString="Target: kc == f(m_flow)")}));
end kc_turbulent;
