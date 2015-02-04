within FluidDissipation.Utilities.Icons.PressureLoss;
partial model Diffuser_d "Icon for a diffuser"

  annotation ( Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-100,90},{-40,90}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled}),
        Rectangle(
          extent={{-94,-82},{-72,-92}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,40},{-40,20}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-20},{-40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{40,80},{100,60}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{40,-60},{100,-80}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{-40,40},{40,80},{40,60},{-40,20},{-40,20},{-40,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{-40,-20},{40,-60},{40,-80},{-40,-40},{-40,-40},{-40,-20}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-106,0},{108,0}},
          pattern=LinePattern.Dash,
          thickness=0.5,
          smooth=Smooth.None,
          color={0,0,0}),
        Line(
          points={{-40,90},{40,90}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{40,90},{100,90}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{-70,20},{-70,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{70,60},{70,-60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{-40,90},{-40,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,90},{40,-60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-8,98},{8,86}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-9,96},{9,86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L_d"),
        Rectangle(
          extent={{-78,94},{-62,82}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{62,98},{78,86}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-78,96},{-60,86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L_1"),
        Text(
          extent={{61,96},{79,86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L_2"),
        Rectangle(
          extent={{-84,6},{-56,-6}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-83,8},{-56,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="d_hyd_1"),
        Rectangle(
          extent={{56,6},{84,-6}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{57,8},{84,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="d_hyd_2"),
        Line(
          points={{-52,14},{-8,36}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-52,20},{-10,20}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-11,34},{-7,30},{-7,24},{-11,20}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-3,36},{24,20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="alpha"),
        Ellipse(
          extent={{-20,26},{-18,24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-20,26},{-4,28}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5)}));

end Diffuser_d;