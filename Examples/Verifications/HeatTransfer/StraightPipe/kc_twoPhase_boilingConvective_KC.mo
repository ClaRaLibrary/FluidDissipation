within FluidDissipation.Examples.Verifications.HeatTransfer.StraightPipe;
model kc_twoPhase_boilingConvective_KC
  "Verification of function kc_twoPhase_boilingConvectiveSteiner_KC"

  SI.CoefficientOfHeatTransfer kc_l[4] "Heat transfer coefficient of liquid phase";
  SI.CoefficientOfHeatTransfer kc_g[4] "Heat transfer coefficient of gasous phase";
  SI.CoefficientOfHeatTransfer kc_conv[4] "Convective two phase heat transfer coefficient";
  Real kc_norm[4] "Normalised convective two phase heat transfer coefficient";

  //Boundary conditions
  parameter SI.MassFlowRate m_flow[4]={232,380,734,1353};
  parameter SI.Pressure p=0.007*220.6e5 "Pressure";
  SI.MassFraction x_flow "Steam quality";

  //Geometry
  parameter SI.Length d_hyd=0.0254 "Hydraulic diameter of pipe";

  //Media data
  parameter SI.SpecificHeatCapacityAtConstantPressure cp_l=4231.48 "Specific heat capacity of liquid phase";
  parameter SI.SpecificHeatCapacityAtConstantPressure cp_g=2135.34 "Specific heat capacity of gasous phase";

  parameter SI.DynamicViscosity eta_l=0.000249248 "Dynamic viscosity of liquid phase";
  parameter SI.DynamicViscosity eta_g=1.26567e-5 "Dynamic viscosity of gasous phase";

  parameter SI.ThermalConductivity lambda_l=0.680874 "Thermal conductivity of liquid phase";
  parameter SI.ThermalConductivity lambda_g=0.025812 "Thermal conductivity of gasous phase";

  parameter SI.Density rho_l=949.243 "Density of liquid phase";
  parameter SI.Density rho_g=0.886356 "Density of gasous phase";

  parameter SI.Pressure p_crit=220.6e5 "Critical pressure of fluid";



equation
  x_flow=time;
for i in 1:4 loop
  kc_l[i]=FluidDissipation.HeatTransfer.StraightPipe.kc_overall(
      FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con(
        roughness=FluidDissipation.Utilities.Types.Roughness.Considered,
        d_hyd=d_hyd,
        K=0,
        L=100),
      FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var(
        cp=cp_l,
        eta=eta_l,
        lambda=lambda_l,
        rho=rho_l,
        m_flow=m_flow[i]));
  kc_g[i]=FluidDissipation.HeatTransfer.StraightPipe.kc_overall(
      FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_con(
        roughness=FluidDissipation.Utilities.Types.Roughness.Considered,
        d_hyd=d_hyd,
        K=0,
        L=100),
      FluidDissipation.HeatTransfer.StraightPipe.kc_overall_IN_var(
        cp=cp_g,
        eta=eta_g,
        lambda=lambda_g,
        rho=rho_g,
        m_flow=m_flow[i]));
  kc_conv[i] = FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase.kc_twoPhase_boilingConvectiveSteiner_KC(FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowConvectiveBoiling_IN_con(p_crit=p_crit, orientation="Vertical", d_hyd=d_hyd),FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowConvectiveBoiling_IN_var(kc_l=kc_l[i], kc_g=kc_g[i], rho_l=rho_l, rho_g=rho_g, p=p, x_flow=x_flow));
  kc_norm[i]=kc_conv[i]/kc_l[i];
  end for;
  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/heatTransfer/straightPipe/kc_twoPhase_boilingConvective_KC.mos"
        "Verification of kc_twoPhase_boilingConvective_KC"),
      Diagram(graphics={Text(
          extent={{-100,52},{100,77}},
          lineColor={0,0,255},
          textString=
            "Two phase heat transfer in straight pipe for convective flow regime ")}),
    experiment(StopTime=100));
end kc_twoPhase_boilingConvective_KC;
