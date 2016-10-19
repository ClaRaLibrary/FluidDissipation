within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Orifice.BaseOrificePL;
partial model BaseOrificeModel
  "Base flow model for orifice functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=true, final allowFlowReversal=
       true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.Orifice_i;

end BaseOrificeModel;
