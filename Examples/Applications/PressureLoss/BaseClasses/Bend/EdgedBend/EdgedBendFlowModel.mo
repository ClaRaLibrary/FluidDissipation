within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend;
model EdgedBendFlowModel "Edged bend: Application flow model for bend function in Modelica.Fluid"

  //base flow model
  extends FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.BaseBendPL.BaseBendModel;

  //pressure loss calculation
  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered "Choice of considering surface roughness"
                                              annotation (Dialog(group="Bend"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg delta=90 "Angle of turning" annotation (Dialog(group="Bend"));
  parameter SI.Diameter d_hyd=0.1 "Hydraulic diameter"
    annotation (Dialog(group="Bend"));
  parameter SI.Length K=0 "Roughness (average height of surface asperities)"
    annotation (Dialog(group="Bend"));
  parameter SI.Length L=1 "Length of the straight starting section before the bend"
    annotation (Dialog(group="Bend"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.PressureLossInput_con
    IN_con(
    roughness=roughness,
    delta=delta*Modelica.Constants.pi/180,
    d_hyd=d_hyd,
    K=K,
    L=L) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.PressureLossInput_var
    IN_var(final eta=eta, final rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.EdgedBend.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

end EdgedBendFlowModel;
