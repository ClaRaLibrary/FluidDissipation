within FluidDissipation.Utilities.Functions.General;
function SmoothPower_der "Function from ThermoFluid"
  extends Modelica.Icons.Function;
  input Real x "input variable";
  input Real deltax "range of interpolation";
  input Real pow "exponent for x";
  input Real dx "derivative of x";
  output Real dy "derivative of SmoothPower";
protected
  Real C3;
  Real C1;
  Real adeltax;

algorithm
  adeltax := abs(deltax);
  if noEvent(x >= adeltax) then
    dy := dx*pow*x^(pow - 1);
  elseif noEvent(x <= -adeltax) then
    dy := dx*pow*(-x)^(pow - 1);
  else
    C3 := (pow - 1)/2*adeltax^(pow - 3);
    C1 := (3 - pow)/2*adeltax^(pow - 1);
    dy := (C1 + 3*C3*x*x)*dx;
  end if;
  annotation (Documentation(revisions="<html>
2014-03-30 Stefan Wischhusen: Removed dpow and ddeltax.
</html>"));
end SmoothPower_der;
