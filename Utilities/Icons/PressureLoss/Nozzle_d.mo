within FluidDissipation.Utilities.Icons.PressureLoss;
partial model Nozzle_d "Icon for a nozzle"

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
          extent={{-100,80},{-40,60}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-60},{-40,-80}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{40,40},{100,20}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{40,-20},{100,-40}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{40,40},{-40,80},{-40,60},{40,20},{40,20},{40,40}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{40,-20},{-40,-60},{-40,-80},{40,-40},{40,-40},{40,-20}},
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
          points={{70,20},{70,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{-70,60},{-70,-60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.Filled,Arrow.Filled}),
        Line(
          points={{40,90},{40,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,90},{-40,-60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,98},{18,84}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-16,96},{15,86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="L_trans"),
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
          extent={{-92,6},{-48,-8}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-95,4},{-44,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="d_hyd_1"),
        Rectangle(
          extent={{48,6},{94,-6}},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{47,6},{96,-4}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="d_hyd_2"),
        Line(
          points={{52,14},{8,36}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{50,20},{8,20}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{13,34},{9,30},{9,24},{13,20}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-69,38},{30,22}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="alpha"),
        Ellipse(
          extent={{17,25},{15,27}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Line(
          points={{16,26},{0,28}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5)}));

end Nozzle_d;
