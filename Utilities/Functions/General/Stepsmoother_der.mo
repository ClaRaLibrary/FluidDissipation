within FluidDissipation.Utilities.Functions.General;
function Stepsmoother_der "derivative of continouus interpolation for x"

  extends Modelica.Icons.Function;
  input Real func "input for that result = 100%";
  input Real nofunc "input for that result = 0%";
  input Real dfunc "derivative of func";
  input Real dnofunc "derivative of nofunc";
  input Real x "input for interpolation";
  input Real dx "derivative of x";
  output Real dresult;

protected
  Real m=Modelica.Constants.pi/(func - nofunc);
  Real b=-Modelica.Constants.pi/2 - m*nofunc;

algorithm
dresult := if x >= func and func > nofunc or x <= func and nofunc > func or x <= nofunc and func > nofunc or x >= nofunc
     and nofunc > func then 0 else (1 - Modelica.Math.tanh(Modelica.Math.tan(m*
    x + b))^2)*(1 + Modelica.Math.tan(m*x + b)^2)*(-m^2/Modelica.Constants.pi*(dfunc - dnofunc)*x + m*dx + m^2/Modelica.Constants.pi*(dfunc - dnofunc)*nofunc - m*dnofunc)/2;
  annotation (Documentation(revisions="<html>
  2014-05-15 Stefan Wischhusen: Moved boundaries to func and nofunc. Introduced dfunc and dnofunc in derivative.
</html>"));
end Stepsmoother_der;
