within FluidDissipation.Utilities.Functions.General;
function LambertW
  "Closed approximation of Lambert's w function for solving f(x) = x exp(x) for x"
  extends Modelica.Icons.Function;
  input Real y "f(x)";
  output Real x "W(y)";
protected
  Real xl;

algorithm
  if (y <= 500.0) then
    xl := Modelica.Math.log(y + 1.0);
    x := 0.665*(1 + 0.0195*xl)*xl + 0.04;
  else
    xl := 0;
    x := Modelica.Math.log(y - 4.0) - (1.0 - 1.0/Modelica.Math.log(y))*
      Modelica.Math.log(Modelica.Math.log(y));
  end if;

  assert(y > -1/Modelica.Math.exp(1),
    "Lambert-w-function is only valid for inputs y > -1/Modelica.Math.exp(1)!");

  annotation (Inline=false, smoothOrder=5, Documentation(info="<html>
 
<p>
This function calculates an approximation of the <b> inverse </b> for
 
<center>
<pre>
f(x) = y = x * exp( x )
</pre>
</center>
 
within &infin; > y > -1/e.  The relative deviation of this approximation for lambert's w function <b>x = W(y)</b> is diplayed in the following graph.
</p>
 
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/utilities/LambertW_deviation.png\">
</p>
 
<p>
For y > 10 and higher values the relative deviation is smaller 2%.
</p>
 
</html>"));
end LambertW;
