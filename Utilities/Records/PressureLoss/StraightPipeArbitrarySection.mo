within FluidDissipation.Utilities.Records.PressureLoss;
record StraightPipeArbitrarySection
  "Input for straight pipe with arbitrary cross-section"
  extends StraightPipe(final d_hyd=d_i);

  import SECTYP = FluidDissipation.Utilities.Types.PipeCrossSectionType;

  parameter SECTYP CrossSectionType annotation(Dialog);
  Modelica.SIunits.Length a=0.01
    "long aspect distance for Rectangle and Ellipse" annotation(Dialog(enable=CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Rectangle or CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Ellipse, groupImage="modelica://FluidDissipation.Extras.Images.pressureLoss.straightPipe.PipeSections.png"));
  Modelica.SIunits.Length b=0.01
    "short aspect distance for Rectangle and Ellipse" annotation(Dialog(enable=CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Rectangle or CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Ellipse));
 // parameter Modelica.SIunits.Length h "length for Trapezoid and Triangle";
 // parameter Modelica.SIunits.Length b1 "length for Trapezoid";
 // parameter Modelica.SIunits.Length b2 "length for Trapezoid";
  Real rstar(min=1e-9, max=1-1e-9)=0.01 "ratio of inner to outer radius"
                                     annotation(Dialog(enable=CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Annular));
  Modelica.SIunits.Diameter d_i(min=1e-9)=0.01
    "hydraulic diameter for circular cross sections"                                              annotation(Dialog(enable=CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Circular or CrossSectionType==FluidDissipation.Utilities.Types.PipeCrossSectionType.Annular));
 // parameter Modelica.SIunits.Length estar "ratio of inner to outer radius";

end StraightPipeArbitrarySection;
