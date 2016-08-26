within FluidDissipation.Examples.Verifications.PressureLoss.StraightPipe;
model dp_twoPhaseOverall_DP "Verification of function dp_twoPhaseOverall_DP"

  import PI = Modelica.Constants.pi;

  //straight pipe variables
  parameter Integer n=size(eta_l, 1);
  parameter SI.Diameter d_hyd=0.000787;
  parameter SI.Area A_cross=PI*d_hyd^2/4;
  parameter SI.Length perimeter=PI*d_hyd;
  parameter SI.Length length=0.503;

  //fluid property variables for CO2 at saturation temperatures of 0degC, 10degC, 20degC
  SI.DynamicViscosity eta_l[5]={9.835980551e-5,8.77888107e-5,7.368173278e-5,
      8.77888107e-5,8.77888107e-5};
  SI.DynamicViscosity eta_g[n]={1.547810104e-5,1.732575635e-5,2.007174653e-5,
      1.732575635e-5,1.732575635e-5};
  SI.Density rho_l[n]={928.81004020247,863.41525244853,776.03258981765,
      863.41525244853,863.41525244853};
  SI.Density rho_g[n]={97.475877361949,134.57734207752,192.69422231737,
      134.57734207752,134.57734207752};
  SI.SurfaceTension sigma[n]={4.4317e-3,2.6724e-03,1.1607e-03,2.6724e-03,
      2.6724e-03};

  //Two phase pressure loss w.r.t. equation of Friedel
  FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_IN_con IN_con_1[n](
    each frictionalPressureLoss=FluidDissipation.Utilities.Types.TwoPhaseFrictionalPressureLoss.Friedel,
    each A_cross=A_cross,
    each perimeter=perimeter,
    each length=length,
    each phi=0,
    each momentumPressureLoss=false,
    each voidFractionApproach=FluidDissipation.Utilities.Types.VoidFractionApproach.Energy)
    annotation (Placement(transformation(extent={{-50,14},{-30,34}})));

  FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_IN_var IN_var_1[n](
    eta_l=eta_l,
    eta_g=eta_g,
    rho_l=rho_l,
    rho_g=rho_g,
    sigma=sigma,
    each x_flow_sta=x_flow,
    each x_flow_end=x_flow)
    annotation (Placement(transformation(extent={{-30,14},{-10,34}})));

  //Two phase pressure loss w.r.t. equation of Chisholm
  FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_IN_con IN_con_2[n](
    each frictionalPressureLoss=FluidDissipation.Utilities.Types.TwoPhaseFrictionalPressureLoss.Chisholm,
    each A_cross=A_cross,
    each perimeter=perimeter,
    each length=length,
    each phi=0,
    each momentumPressureLoss=false,
    each voidFractionApproach=FluidDissipation.Utilities.Types.VoidFractionApproach.Energy)
    annotation (Placement(transformation(extent={{10,14},{30,34}})));

  FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_IN_var IN_var_2[n](
    eta_l=eta_l,
    eta_g=eta_g,
    rho_l=rho_l,
    rho_g=rho_g,
    sigma=sigma,
    each x_flow_end=x_flow,
    each x_flow_sta=x_flow)
    annotation (Placement(transformation(extent={{30,14},{50,34}})));

  SI.MassFlowRate input_mdot[n]={0.0001459354,0.0001459354,0.0001459354,
      0.00019458051,0.000097290255} "(Input) mass flow rate (for incompressible case)";
  SI.MassFlowRate m_flow[n]=input_mdot;

  //output variables
  SI.Pressure DP_1[n] "(Output) pressure loss (for incompressible case)";
  SI.Pressure DP_2[n] "(Output) pressure loss (for incompressible case)";
  Real DP_plot_1[n]={DP_1[i]/100000 for i in 1:n} "Pressure loss [Pa]";
  Real DP_plot_2[n]={DP_2[i]/100000 for i in 1:n} "Pressure loss [Pa]";
public
  Modelica.Blocks.Sources.Ramp input_mflow_0[n](
    each startTime=0,
    each offset=0,
    each duration=1,
    each height=100) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1[n](
    each offset=0,
    each phase=0,
    each startTime=0,
    each freqHz=1,
    each amplitude=100) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2[n](
    each offset=0,
    each startTime=0,
    each outMax=100,
    each riseTime=1e-1,
    each riseTimeConst=1e-1) annotation (Placement(
        transformation(extent={{0,-80},{20,-60}})));
  Modelica.Blocks.Sources.Ramp input_x_0(
    duration=1,
    startTime=0,
    height=1)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Sine input_x_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=1)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.Exponentials input_x_2(
    offset=0,
    startTime=0,
    riseTime=1e-1,
    riseTimeConst=1e-1,
    outMax=1) annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

protected
  SI.MassFraction x_flow=input_x_0.y "Mean mass flow rate quality";

equation
  DP_1 = {FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_DP(
    IN_con_1[i],
    IN_var_1[i],
    m_flow[i]) for i in 1:n};
  DP_2 = {FluidDissipation.PressureLoss.StraightPipe.dp_twoPhaseOverall_DP(
    IN_con_2[i],
    IN_var_2[i],
    m_flow[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/straightPipe/dp_twoPhaseOverall_DP.mos" "Verification of dp_twoPhaseOverall_DP"),
                                                  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
           Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Two phase pressure loss of STRAIGHT PIPE for OVERALL flow regime"),
          Text(
          extent={{-67,10},{8,0}},
          lineColor={0,0,255},
          textString="Friedel"),                      Text(
          extent={{-7,10},{68,0}},
          lineColor={0,0,255},
          textString="Chisholm")}));
end dp_twoPhaseOverall_DP;
