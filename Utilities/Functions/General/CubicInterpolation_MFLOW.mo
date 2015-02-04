within FluidDissipation.Utilities.Functions.General;
function CubicInterpolation_MFLOW
  extends Modelica.Icons.Function;
  import Modelica.Math;
  input SI.ReynoldsNumber Re;
  input SI.ReynoldsNumber Re1;
  input SI.ReynoldsNumber Re2;
  input Real Delta;
  output Real lambda2;
  // point lg(lambda2(Re1)) with derivative at lg(Re1)
protected
  Real x1=Math.log10(Re1);
  Real y1=Math.log10(64*Re1);
  Real yd1=1;

  // Point lg(lambda2(Re2)) with derivative at lg(Re2)
  Real aux1=(0.5/Math.log(10))*5.74*0.9;
  Real aux2=Delta/3.7 + 5.74/Re2^0.9;
  Real aux3=Math.log10(aux2);
  Real L2=0.25*(Re2/aux3)^2;
  Real aux4=2.51/sqrt(L2) + 0.27*Delta;
  Real aux5=-2*sqrt(L2)*Math.log10(aux4);
  Real x2=Math.log10(Re2);
  Real y2=Math.log10(L2);
  Real yd2=2 + 4*aux1/(aux2*aux3*(Re2)^0.9);

  // Constants: Cubic polynomial between lg(Re1) and lg(Re2)
  Real diff_x=x2 - x1;
  Real m=(y2 - y1)/diff_x;
  Real c2=(3*m - 2*yd1 - yd2)/diff_x;
  Real c3=(yd1 + yd2 - 2*m)/(diff_x*diff_x);
  Real dx=Math.log10(Re/Re1);

algorithm
  lambda2 := 64*Re1*(Re/Re1)^(1 + dx*(c2 + dx*c3));
  annotation (Inline=false, smoothOrder=5);
end CubicInterpolation_MFLOW;
