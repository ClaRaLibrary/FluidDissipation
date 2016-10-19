within FluidDissipation.Examples.Applications.PressureLoss.BaseClasses.StraightPipe.BaseStraightPipePL;
partial model BaseStraightPipeModel
  "Base flow model for straight pipe functions in Modelica.Fluid"

  extends BaseClasses.BaseFlowModel(final from_dp=true, final allowFlowReversal=
       true);

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.StraightPipe_i;
equation
  dp = dp_tot;

end BaseStraightPipeModel;
