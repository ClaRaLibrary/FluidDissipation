within FluidDissipation.Examples.Applications.PressureLoss;
model Tjunction "Tjunction model for different constant flow situations"

  import PI = Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.PortFlowDirection;

  //icon
  extends FluidDissipation.Utilities.Icons.PressureLoss.Tjunction_i;

  replaceable package Medium = Modelica.Media.Air.DryAirNasa constrainedby Modelica.Media.Interfaces.PartialMedium "Fluid medium model"
                         annotation (choicesAllMatching=true);

  //fluid flow situation
  FluidDissipation.Utilities.Types.JunctionFlowSituation flowSituation=
      FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left "Fluid flow situation"
    annotation (Dialog(tab="General", group="FlowSituation"));

  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg alpha(min=0, max=90)=90 "branching angle"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter Boolean united_converging_crossection=false "true == A_cross_conv = A_cross_straight + A_cross_side | false == A_cross_conv > A_cross_straight + A_cross_side"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter SI.Length d_hyd_1(min=Modelica.Constants.eps)=1e-1 "diameter of left passage (port_1)"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter SI.Diameter d_hyd_2(min=Modelica.Constants.eps)=1e-1 "diameter of right passage (port_2)"
    annotation (Dialog(tab="General", group="Geometry"));
  parameter SI.Diameter d_hyd_3(min=Modelica.Constants.eps)=1e-1 "diameter of side branch (port_3)"
    annotation (Dialog(tab="General", group="Geometry"));

  //restriction
  parameter SI.Pressure dp_min(min=Modelica.Constants.eps)=1 "restriction for smoothing while changing of fluid flow situation"
    annotation (Dialog(group="Restriction"));
  parameter SI.MassFlowRate m_flow_min(min=Modelica.Constants.eps)=1e-3 "restriction for smoothing at reverse fluid flow"
    annotation (Dialog(group="Restriction"));
  parameter SI.Velocity v_max(min=Modelica.Constants.eps)= 343 "restriction of maximum fluid flow velocity for pressure loss calculation"
    annotation (Dialog(group="Restriction"));
  parameter Real zeta_TOT_max(min=Modelica.Constants.eps)=100 "restriction for maximum value of total resistance coefficient"
    annotation (Dialog(group="Restriction",enable=velocity_reference_branches));

  //interfaces
  Modelica.Fluid.Interfaces.FluidPort_b port_3(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-100,0}), iconTransformation(extent={{-110,-10},{-90,10}})));

  //pressure loss of junction
  //side branch
  BaseClasses.pressureLoss_Tjunction dp_3(
    redeclare package Medium = Medium,
    final united_converging_crossection=united_converging_crossection,
    final alpha=alpha,
    final d_hyd=d_hyd,
    final dp_min=dp_min,
    final m_flow_min=m_flow_min,
    final v_max=v_max,
    final zeta_TOT_max=zeta_TOT_max,
    final flowSituation=flowSituation,
    dp_start=0,
    final dp_i=3,
    final m_flow_junction={port_1.m_flow,port_2.m_flow,port_3.m_flow})
    annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=270,
        origin={0,-30})));

  //right passage according to general geometry of T-junction
  BaseClasses.pressureLoss_Tjunction dp_2(
    redeclare package Medium = Medium,
    final united_converging_crossection=united_converging_crossection,
    final alpha=alpha,
    final d_hyd=d_hyd,
    final dp_i=2,
    final dp_min=dp_min,
    final m_flow_min=m_flow_min,
    final v_max=v_max,
    final zeta_TOT_max=zeta_TOT_max,
    final flowSituation=flowSituation,
    dp_start=0,
    final m_flow_junction={port_1.m_flow,port_2.m_flow,port_3.m_flow})
    annotation (Placement(transformation(extent={{20,-10},
            {40,10}})));

  //left passage according to general geometry of T-junction
  BaseClasses.pressureLoss_Tjunction dp_1(
    redeclare package Medium = Medium,
    final united_converging_crossection=united_converging_crossection,
    final alpha=alpha,
    final d_hyd=d_hyd,
    final dp_min=dp_min,
    final m_flow_min=m_flow_min,
    final v_max=v_max,
    final zeta_TOT_max=zeta_TOT_max,
    final flowSituation=flowSituation,
    dp_start=0,
    final dp_i=1,
    final m_flow_junction={port_1.m_flow,port_2.m_flow,port_3.m_flow})
           annotation (Placement(transformation(
          extent={{-40,-10},{-20,10}})));

protected
  parameter SI.Diameter d_hyd[3]={d_hyd_1,d_hyd_2,d_hyd_3};

equation
  if flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric
       or flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric then
    assert( sum(d_hyd)<=3*min(min(d_hyd_1, d_hyd_2), d_hyd_3), "The symmetric Join-T is restricted to identical hydraulic diameters at all ports.");
    assert( alpha>=90 and alpha<=90, "The symmetric Join-T is restricted to a branching angle of 90 degrees.");
  end if;

  connect(port_1, dp_1.port_a) annotation (Line(
      points={{-100,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp_2.port_b, port_2) annotation (Line(
      points={{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_3,dp_3. port_b) annotation (Line(
      points={{0,-100},{0,-40},{-1.83697e-015,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp_1.port_b, dp_2.port_a) annotation (Line(
      points={{-20,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp_3.port_a, dp_2.port_a) annotation (Line(
      points={{1.83697e-015,-20},{0,-20},{0,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
<p>
The junction model makes use of the <a href=\"FluidDissipation.PressureLoss.Junction.dp_Tjunction\"> dp_Tjunction </a> pressure drop function. Refer to the documentation of that model.  
</p>
</html>
"), experiment(Interval=0.0002),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
      graphics={
        Polygon(
          points={{80,-42},{100,-50},{80,-58},{80,-42}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric),
        Polygon(
          points={{80,-44},{96,-50},{80,-56},{80,-44}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric),
        Line(
          points={{100,-50},{50,-50}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric),
        Polygon(
          points={{-80,-42},{-100,-50},{-80,-58},{-80,-42}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric),
        Polygon(
          points={{-80,-44},{-96,-50},{-80,-56},{-80,-44}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric),
        Line(
          points={{-100,-50},{-50,-50}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric),
        Polygon(
          points={{-70,-42},{-50,-50},{-70,-58},{-70,-42}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left),
        Polygon(
          points={{-70,-44},{-54,-50},{-70,-56},{-70,-44}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left),
        Line(
          points={{-50,-50},{-100,-50}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right
               or flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric
               or flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left),
        Polygon(
          points={{70,-42},{50,-50},{70,-58},{70,-42}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right),
        Polygon(
          points={{70,-44},{54,-50},{70,-56},{70,-44}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right),
        Line(
          points={{50,-50},{100,-50}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right),
        Polygon(
          points={{-10,8},{10,0},{-10,-8},{-10,8}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric,
          origin={-50,-60},
          rotation=90),
        Polygon(
          points={{-8,6},{8,0},{-8,-6},{-8,6}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric,
          origin={-50,-62},
          rotation=90),
        Line(
          points={{30,0},{-20,6.12325e-016}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Right or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Symmetric,
          origin={-50,-80},
          rotation=90),
        Polygon(
          points={{-10,8},{10,0},{-10,-8},{-10,8}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right,
          origin={-50,-90},
          rotation=270),
        Polygon(
          points={{-8,6},{8,0},{-8,-6},{-8,6}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right,
          origin={-50,-88},
          rotation=270),
        Line(
          points={{30,0},{-20,-7.00461e-015}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Tjoin_Symmetric or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Left or
          flowSituation == FluidDissipation.Utilities.Types.JunctionFlowSituation.Split_Right,
          origin={-50,-70},
          rotation=270),
        Text(
          extent={{-56,80},{56,40}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end Tjunction;
