within FluidDissipation.Utilities.Functions.General;
function Stepsmoother "Continuous interpolation for x "

  extends Modelica.Icons.Function;
  input Real func "input value for that result = 100%";
  input Real nofunc "input value for that result = 0%";
  input Real x "input variable for continuous interpolation";
  output Real result "output value";

protected
  Real m=Modelica.Constants.pi/(func - nofunc);
  Real b=-Modelica.Constants.pi/2 - m*nofunc;
algorithm
  result := if x >= func and func > nofunc or x
     <= func and nofunc > func then 1 else if x
     <= nofunc and func > nofunc or x >= nofunc and nofunc > func then 0 else (1+Modelica.Math.tanh(Modelica.Math.tan(m*x + b)))/2;
  annotation (derivative = Stepsmoother_der,
    Documentation(info="<html>
<p>
The function is used for continuous fading of variable inputs within a defined range. It allows a differentiable and smooth transition between function outputs, e.g. laminar and turbulent pressure drop or correlations for certain ranges.  
</p>
<h4><font color=\"#EF9B13\">Function </font></h4>
<p>
The tanh-function is used, since it provides an existing derivative and the derivative is zero at the borders [<b>nofunc</b>, <b>func</b>] of the interpolation domain (smooth derivative for transitions).<br>
<br>
In order to work correctly, the internal interpolation range in terms of the external arbitrary input <b> x </b> needs to be scaled such that:
<pre>
f(func)   = 0.5 &pi;
f(nofunc) = -0.5 &pi;
</pre>
</p> 
<h4><font color=\"#EF9B13\">Example </font></h4>
<p>
In the picture below the input x is increased from 0 to 1. The range of interpolation is defined by:

<ul>
<li> func = 0.75</li>
<li> nofunc = 0.25</li>
</ul>
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/utilities/Stepsmoother.png\">
</p>

<h4><font color=\"#EF9B13\">References</font></h4> 
<dl>
<dt>Wischhusen, St.</dt>
    <dd><b>Simulation von K&auml;ltemaschinen-Prozessen mit MODELICA / DYMOLA</b>.
    Diploma thesis, Hamburg University of Technology, Institute of Thermofluiddynamics, 2000.</dd>
</html>", revisions="<html>
2014-03-30 Stefan Wischhusen: Moved boundaries to func and nofunc. Introduced func and nofunc.
</html>"));
end Stepsmoother;
