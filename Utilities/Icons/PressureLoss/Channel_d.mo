within FluidDissipation.Utilities.Icons.PressureLoss;
partial model Channel_d "Icon for channel"

  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
          Line(
          points={{-92,80},{-60,80}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot),Ellipse(
          extent={{20,80},{-20,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward),Ellipse(
          extent={{80,74},{40,46}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward),Ellipse(
          extent={{14,74},{-14,46}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Line(
          points={{0,74},{0,46}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled}),Rectangle(
          extent={{-10,66},{10,56}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{-9,66},{10,58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="d_cir"),Ellipse(
          extent={{-40,80},{-80,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),Ellipse(
          extent={{-46,74},{-74,46}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward),Line(
          points={{0,14},{0,-14}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={-60,36},
          rotation=90),Line(
          points={{-92,40},{-60,40}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot),Line(
          points={{-90,80},{-90,40}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled}),Rectangle(
          extent={{-98,64},{-82,54}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{-99,63},{-82,56}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="D_ann"),Line(
          points={{-16,0},{16,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={-74,46},
          rotation=270),Line(
          points={{-16,0},{16,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={-46,46},
          rotation=90),Rectangle(
          extent={{-68,38},{-52,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{-69,39},{-52,32}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="d_ann"),Ellipse(
          extent={{78,72},{42,48}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Line(
          points={{-22,0},{22,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={60,60},
          rotation=90),Line(
          points={{0,4},{0,-14}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={46,42},
          rotation=90),Rectangle(
          extent={{46,46},{55,39}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{46,43},{54,41}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="a_ell"),Line(
          points={{0,0},{22,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={42,38},
          rotation=90),Line(
          points={{60,72},{92,72}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot),Line(
          points={{38,60},{92,60}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot),Line(
          points={{0,4},{0,-8}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={88,68},
          rotation=360),Rectangle(
          extent={{82,68},{94,65}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{83,69},{95,63}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="b_ell"),Rectangle(
          extent={{-60,24},{-20,-6}},
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward,
          lineColor={0,0,0},
          lineThickness=0.5),Rectangle(
          extent={{-56,20},{-24,-2}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=0.5),Line(
          points={{-16,0},{16,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={-56,-2},
          rotation=270),Line(
          points={{-16,0},{16,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={-24,-2},
          rotation=270),Line(
          points={{0,14},{0,-18}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={-42,-14},
          rotation=90),Rectangle(
          extent={{-50,-10},{-30,-20}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{-48,-10},{-32,-17}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="a_rec"),Line(
          points={{-16,0},{16,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={-31,20},
          rotation=360),Line(
          points={{-16,0},{16,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={-31,-2},
          rotation=360),Line(
          points={{0,12},{0,-10}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={-16,10},
          rotation=180),Rectangle(
          extent={{-19,15},{0,3}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{-18,13},{-2,6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="b_rec"),Polygon(
          points={{20,-10},{40,30},{60,-10},{20,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Forward),Polygon(
          points={{26,-6},{40,22},{54,-6},{26,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Line(
          points={{-16,0},{-4,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={26,-22},
          rotation=270),Line(
          points={{0,20},{0,-8}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={46,-16},
          rotation=90),Line(
          points={{-16,0},{-4,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={54,-22},
          rotation=270),Line(
          points={{-16,0},{12,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={56,22},
          rotation=360),Line(
          points={{-16,0},{12,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          origin={56,-6},
          rotation=360),Line(
          points={{0,20},{0,-8}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled},
          origin={64,14},
          rotation=180),Rectangle(
          extent={{55,15},{74,3}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{56,13},{73,4}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="h_tri"),Rectangle(
          extent={{31,-11},{50,-23}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Text(
          extent={{32,-11},{49,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="a_tri"),Line(
          points={{36,14},{38,12},{42,12},{44,14}},
          color={0,0,0},
          thickness=0.5),
          Line(
          points={{-12,-2},{0,-8}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.None},
          origin={40,24},
          rotation=360),Text(
          extent={{12,27},{29,18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          textString="beta")}));

end Channel_d;
