within FluidDissipation.Utilities.Functions.General;
function SmoothPower "Function from ThermoFluid"
  extends Modelica.Icons.Function;
  input Real x "input variable";
  input Real deltax "range for interpolation";
  input Real pow "exponent for x";
  output Real y "output variable";
protected
  Real adeltax=abs(deltax);
  Real C3=(pow - 1)/2*adeltax^(pow - 3);
  Real C1=(3 - pow)/2*adeltax^(pow - 1);

algorithm
  y := if x >= adeltax then x^pow else if x <= -adeltax then -(-x)^pow else (C1
     + C3*x*x)*x;
  annotation (derivative(zeroDerivative=deltax, zeroDerivative=pow)=SmoothPower_der,
    Inline=false,
    smoothOrder=1,
    Documentation(info="<html>
<p><br/>The function is used to limit the derivative of an inversed function</p>
<p>y = x<sup><b>pow</b></sup>, for <b>pow</b>&GT;1</p>
<p><br/>around -<b>deltax</b>&LT; x &LT; <b>deltax</b>. </p>
<h4><font color=\"#EF9B13\">Example </font></h4>
<p>
In the picture below the input x is increased from -1 to 1. The range of interpolation is defined by the same range. Displayed is the output of the function SmoothPower compared to <br>
<pre>
y=x*|x|
</pre>
<br>
For |x| &gt; 1 both functions return identical results.
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/utilities/SmoothPower.png\">
</p>

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>ThermoFluid Library</dt>
    <dd><b><a href=\"http://sourceforge.net/projects/thermofluid/\"> http://sourceforge.net/projects/thermofluid/</b>.</dd>

</html>", revisions="<html>
2014-03-30 Stefan Wischhusen: Moved boundaries to func and nofunc. Introduced func and nofunc.
</html>"));
end SmoothPower;
