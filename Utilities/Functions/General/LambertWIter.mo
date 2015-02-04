within FluidDissipation.Utilities.Functions.General;
function LambertWIter
  "Iterative form of Lambert's w function for solving f(x) = x exp(x) for x"
  extends Modelica.Icons.Function;
  input Real y "f(x)";
  output Real x "W(y)";
  output Integer iter;
protected
  Real w;
  Real prec=1e-12;
  Real c1;
  Real c2;
  Real dw;
  Real w1;
  /*Real wTimesExpW;
  Real wPlusOneTimesExpW;*/
  Real dev;
  Integer i;

algorithm
  w := if y > 0.1 then FluidDissipation.Utilities.Functions.General.LambertW(y)
     else sqrt(5.43656*max(y, -1/Modelica.Math.exp(1)) + 2) - 1;
  dev := 1;
  i := 0;
  while prec < dev and i < 100 loop
    /*wTimesExpW := w*Modelica.Math.exp(w);
                wPlusOneTimesExpW := (w+1)*Modelica.Math.exp(w);
                w := w-(wTimesExpW-y)/(wPlusOneTimesExpW-(w+2)*(wTimesExpW-y)/(2*w+2));
                dev := abs((y-wTimesExpW)/wPlusOneTimesExpW);
                i := i+1;*/

    c1 := Modelica.Math.exp(w);
    c2 := w*c1 - y;
    w1 := if w <> 1 then w + 1 else w;
    dw := c2/(c1*w1 - ((w + 2)*c2/(2*w1)));
    w := w - dw;
    //dev := abs(dw)/(2+abs(w));
    dev := abs((y - w*c1)/(w + 1)*c1);
    i := i + 1;
  end while;
  x := w;
  iter := i;

  annotation (Inline=false, smoothOrder=5, Documentation(info="<html>
 
<p>
This function calculates an approximation of the <b> inverse </b> for
 
<center>
<pre>
f(x) = y = x * exp( x )
</pre>
</center>
 
within &infin; > y > -1/e. Please note, that for negative inputs <b>two</b> solutions exists. The function currently delivers the result x = -1 ... 0 for that particular range.
</p>
 
</html>"));
end LambertWIter;
