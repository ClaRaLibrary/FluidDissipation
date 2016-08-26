within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.Bend.BaseBendPL;
partial model BaseBendModel "Base flow model for bend functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=true, final allowFlowReversal=
       true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.Bend_i;

equation
  dp = dp_tot;

end BaseBendModel;
