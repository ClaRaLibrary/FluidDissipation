within FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase;
function dp_twoPhaseGeodetic_DP "Geodetic pressure loss of straight pipe for two phase flow | calculate pressure loss"
  extends Modelica.Icons.Function;
  //SOURCE_1: VDI-Waermeatlas, 10th edition, Springer-Verlag, 2006.

  import PI = Modelica.Constants.pi;

  input FluidDissipation.Utilities.Types.VoidFractionApproach voidFractionApproach=
      FluidDissipation.Utilities.Types.VoidFractionApproach.Homogeneous "Choice of void fraction approach";

  input Boolean crossSectionalAveraged=true "true == cross sectional averaged void fraction | false == volumetric"
    annotation (Dialog);

  //geometry
  input SI.Length length=1 "Length in fluid flow direction"
    annotation (Dialog(group="Geometry"));
  input SI.Angle phi=0 "Tilt angle to horizontal"
    annotation (Dialog(group="Geometry"));

  //fluid properties
  input SI.Density rho_g(min=Modelica.Constants.eps) = 1.1220 "Density of gaseous phase"
                               annotation (Dialog(group="Fluid properties"));
  input SI.Density rho_l(min=Modelica.Constants.eps) = 943.11 "Density of liquid phase"
                              annotation (Dialog(group="Fluid properties"));
  input Real x_flow(
    min=0,
    max=1) = 0 "Mass flow rate quality"
    annotation (Dialog(group="Fluid properties"));

  output SI.Pressure DP_geo "Geodetic pressure loss";

protected
  Real xflow=min(1, max(0, abs(x_flow))) "Mass flow rate quality";
  Real eps=
      FluidDissipation.Utilities.Functions.PressureLoss.TwoPhase.VoidFraction(
      voidFractionApproach,
      crossSectionalAveraged,
      rho_g,
      rho_l,
      xflow) "Void fraction";

algorithm
  //SOURCE_1: p.Lbb 1, eq. 4: Considering geodetic pressure loss assuming constant void fraction for flow length
  DP_geo := (eps*rho_g + (1 - eps)*rho_l)*9.81*length*sin(phi);

  annotation (Inline=false, Documentation(revisions="<html>
2012-11-07        Removed erroneous angle limitation for phi. Stefan Wischhusen.
</html>"));
end dp_twoPhaseGeodetic_DP;
