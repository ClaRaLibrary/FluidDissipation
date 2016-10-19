within FluidDissipation.Utilities.Icons.HeatTransfer;
partial model Plate1_d "icon for plate"

  annotation ( Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-100,10},{100,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Forward,
          fillColor={255,255,170}),Line(
          points={{-100,-20},{100,-20}},
          color={0,0,0},
          arrow={Arrow.Filled,Arrow.Filled}),Text(
          extent={{-14,-20},{12,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L"),Line(
          points={{-20,16},{20,16}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),Text(
          extent={{-14,26},{12,16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="velocity")}));

end Plate1_d;
