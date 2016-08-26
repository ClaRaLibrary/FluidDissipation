within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Laminar;
model LaminarFlowModel "Straight pipe (laminar): Application flow model for straight pipe function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.BaseStraightPipePL.BaseStraightPipeModel;

  //pressure loss calculation
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="Straight pipe"));
  parameter SI.Length L=1 "Length" annotation (Dialog(group="Straight pipe"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Laminar.PressureLossInput_con
    IN_con(d_hyd=d_hyd, L=L)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Laminar.PressureLossInput_var
    IN_var(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.Laminar.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

  annotation (Diagram(graphics));
end LaminarFlowModel;
