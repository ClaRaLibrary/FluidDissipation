within FluidDissipation.Utilities.Icons.HeatTransfer;
partial model Plate2_d "icon for plate"

  annotation ( Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-100,-20},{60,-40}},
          fillPattern=FillPattern.Forward,
          fillColor={255,255,170},
          lineThickness=0.5,
          lineColor={0,0,0}),Polygon(
          points={{-100,-20},{-60,20},{100,20},{60,-20},{-100,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward,
          lineThickness=0.5),Polygon(
          points={{60,-20},{60,-40},{100,0},{100,20},{60,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward),Line(
          points={{-20,0},{20,0}},
          thickness=1,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled}),Text(
          extent={{-14,10},{12,0}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="v"),Line(
          points={{-100,-48},{60,-48}},
          color={0,0,0},
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.Filled}),Rectangle(
          extent={{-26,-44},{-18,-54}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=1,
          pattern=LinePattern.None),Text(
          extent={{-34,-44},{-8,-54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L")}));
end Plate2_d;
