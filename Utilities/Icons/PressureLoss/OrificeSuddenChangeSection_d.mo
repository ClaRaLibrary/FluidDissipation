within FluidDissipation.Utilities.Icons.PressureLoss;
partial model OrificeSuddenChangeSection_d
  "icon for orifice with sudden change of cross sectional area"

  annotation ( Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,20},{0,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,40},{100,-42}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-48,94},{46,74}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="sudden expansion"),
        Text(
          extent={{-44,-74},{50,-94}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="sudden contraction"),
        Line(
          points={{-20,0},{20,0}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled},
          origin={0,-72},
          rotation=180),
        Line(
          points={{-20,0},{20,0}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={-48,0},
          rotation=90),
        Line(
          points={{-62,0},{20,0}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={52,20},
          rotation=90),
        Rectangle(
          extent={{42,6},{62,-8}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{38,4},{64,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="A_2"),
        Rectangle(
          extent={{-58,6},{-38,-8}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-62,4},{-36,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="A_1"),
        Rectangle(
          extent={{0,20},{0,-20}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-44,12},{40,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="design flow direction"),
        Line(
          points={{-24,-4},{16,-4}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-20,70},{20,70}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled})}));

end OrificeSuddenChangeSection_d;
