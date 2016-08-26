within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.General.BaseGeneralPL;
partial model BaseGeneralModel "Base flow model for generic functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=true, final allowFlowReversal=
       true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.General_i;

equation
  dp = dp_tot;

end BaseGeneralModel;
