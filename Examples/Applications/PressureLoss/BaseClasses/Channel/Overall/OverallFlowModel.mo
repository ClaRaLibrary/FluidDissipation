within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall;
model OverallFlowModel
  "Channel (overall): Application flow model for channel function in Modelica.Fluid"

  //base flow model
  extends
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.BaseChannelPL.BaseChannelModel;

  //pressure loss calculation
  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered
    "Choice of considering surface roughness"
    annotation (Dialog(group="Channel"));
  FluidDissipation.Utilities.Types.GeometryOfInternalFlow geometry=
      FluidDissipation.Utilities.Types.GeometryOfInternalFlow.Circular
    "Choice of geometry for internal flow" annotation (Dialog(group="Channel"));
  parameter SI.Length K=0 "Roughness (average height of surface asperities)"
    annotation (Dialog(group="Channel"));
  parameter SI.Length L=1 "Length" annotation (Dialog(group="Channel"));
  parameter SI.Diameter d_ann=d_cir "Small diameter"
    annotation (Dialog(group="Channel"));
  parameter SI.Diameter D_ann=2*d_ann "Large diameter"
    annotation (Dialog(group="Channel"));
  parameter SI.Diameter d_cir=0.1 "Internal diameter"
    annotation (Dialog(group="Channel"));
  parameter SI.Length a_ell=(3/4)*d_cir "Half length of long base line"
    annotation (Dialog(group="Channel"));
  parameter SI.Length b_ell=0.5*a_ell "Half length of short base line"
    annotation (Dialog(group="Channel"));
  parameter SI.Length a_rec=d_cir "Horizontal length"
    annotation (Dialog(group="Channel"));
  parameter SI.Length b_rec=a_rec "Vertical length"
    annotation (Dialog(group="Channel"));
  parameter SI.Length a_tri=d_cir*(1 + 2^0.5) "Length of base line"
    annotation (Dialog(group="Channel"));
  parameter SI.Length h_tri=0.5*a_tri
    "Height to top angle perpendicular to base line"
    annotation (Dialog(group="Channel"));
  parameter Real beta=90 "Top angle" annotation (Dialog(group="Channel"));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.PressureLossInput_con
    IN_con(
    roughness=roughness,
    geometry=geometry,
    K=K,
    L=L,
    d_ann=d_ann,
    D_ann=D_ann,
    d_cir=d_cir,
    a_ell=a_ell,
    b_ell=b_ell,
    a_rec=a_rec,
    b_rec=b_rec,
    a_tri=a_tri,
    h_tri=h_tri,
    beta=beta)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.PressureLossInput_var
    IN_var(eta=eta, rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  m_flow =
    FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Channel.Overall.massFlowRate_dp(
    IN_con,
    IN_var,
    dp);

  annotation (Diagram(graphics));
end OverallFlowModel;
