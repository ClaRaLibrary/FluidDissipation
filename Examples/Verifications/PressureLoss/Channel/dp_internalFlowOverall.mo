within FluidDissipation.Examples.Verifications.PressureLoss.Channel;
model dp_internalFlowOverall
  "Verification of function dp_internalFlowOverall_DP AND dp_internalFlowOverall_MFLOW"

  type TYP =
      FluidDissipation.Utilities.Types.GeometryOfInternalFlow;

  parameter Integer n=size(geometry, 1) "Number of different geometries";

  //channel variables
  FluidDissipation.Utilities.Types.Roughness roughness=FluidDissipation.Utilities.Types.Roughness.Considered
    "Choice of considering surface roughness";
  SI.Length K=0 "Roughness (average height of surface asperities)";
  SI.Length L=1 "Length";
  FluidDissipation.Utilities.Types.GeometryOfInternalFlow geometry[5]={TYP.Annular,
      TYP.Circular,TYP.Elliptical,TYP.Rectangular,TYP.Isosceles}
    "Choice of geometry for internal flow";
  SI.Diameter d_ann=d_hyd "Small diameter";
  SI.Diameter D_ann=2*d_ann "Large diameter";
  SI.Diameter d_cir=d_hyd "Internal diameter";
  SI.Length a_ell=(3/4)*d_hyd "Half length of long base line";
  SI.Length b_ell=0.5*a_ell "Half length of short base line";
  SI.Length a_rec=d_hyd "Horizontal length";
  SI.Length b_rec=a_rec "Vertical length";
  SI.Length a_tri=d_hyd*(1 + 2^0.5) "Length of base line";
  SI.Length h_tri=0.5*a_tri "Height to top angle perpendicular to base line";
  Real beta=tan((a_tri)/2/h_tri) "Top angle";

  //fluid property variables
  SI.DynamicViscosity eta=1e-3 "Dynamic viscosity of fluid";
  SI.Density rho=1000 "Density of fluid";

  //target variables (here: mass flow rate as input for inverse calculation)
  //intended input variables for records
  SI.MassFlowRate input_mdot_1[n](start=zeros(n)) = {input_mflow_0.y*(d_hydT[2]
    /d_hydT[i])*(A_crossT[i]/A_crossT[2]) for i in 1:n}
    "(Input) mass flow rate (for intended incompressible case)";
  SI.Pressure input_dp_1[n]={DP_1[i] for i in 1:n}
    "(Input) pressure loss (for intended compressible case)";

  //input record
  //target == DP (incompressible)
  FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_con m_flow_IN_con_1[n](
    each roughness=roughness,
    geometry=geometry,
    each d_ann=d_ann,
    each D_ann=D_ann,
    each d_cir=d_cir,
    each a_ell=a_ell,
    each b_ell=b_ell,
    each a_rec=a_rec,
    each b_rec=b_rec,
    each a_tri=a_tri,
    each h_tri=h_tri,
    each beta=beta,
    each K=K,
    each L=L) annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_var m_flow_IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  //target == M_FLOW (compressible)
  FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_con dp_IN_con_1[n](
    each roughness=roughness,
    geometry=geometry,
    each K=K,
    each L=L,
    each d_ann=d_ann,
    each D_ann=D_ann,
    each d_cir=d_cir,
    each a_ell=a_ell,
    each b_ell=b_ell,
    each a_rec=a_rec,
    each b_rec=b_rec,
    each a_tri=a_tri,
    each h_tri=h_tri,
    each beta=beta)
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_var dp_IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_crossT[n]={max(MIN, if geometry[i] == TYP.Annular then
      (Modelica.Constants.pi/4)*((D_ann)^2 - (d_ann)^2) else if
      geometry[i] == TYP.Circular then Modelica.Constants.pi/4*(d_cir)^2 else if
      geometry[i] == TYP.Elliptical then Modelica.Constants.pi*a_ell*b_ell else if
      geometry[i] == TYP.Rectangular then a_rec*b_rec else if geometry[i] == TYP.Isosceles then
      0.5*(a_tri*h_tri) else 0) for i in 1:n} "Cross sectional area";
  SI.Length perimeterT[n]={max(MIN, if geometry[i] == TYP.Annular then
            Modelica.Constants.pi*(D_ann + d_ann) else if geometry[i]
       == TYP.Circular then Modelica.Constants.pi*d_cir else if geometry[i] == TYP.Elliptical then
            Modelica.Constants.pi*(2*((a_ell)^2) + (b_ell)^2)^0.5 else
      if geometry[i] == TYP.Rectangular then 2*(a_rec + b_rec) else if geometry[i]
       == TYP.Isosceles then a_tri + 2*((h_tri)^2 + (a_tri/2)^2)^0.5 else 0) for i in
          1:n} "Perimeter";
  SI.Diameter d_hydT[n]={4*A_crossT[i]/perimeterT[i] for i in 1:n}
    "Hydraulic diameter";
  SI.Area A_cross=(PI/4)*d_hyd^2;
  SI.Diameter d_hyd=0.1;
  SI.Diameter perimeter=4*A_cross/d_hyd;

  SI.Velocity velocity_1[n]={input_mdot_1[i]/(rho*A_crossT[i]) for i in 1:n}
    "Mean velocity";
  SI.ReynoldsNumber Re_1[n]={rho*velocity_1[i]*d_hydT[i]/eta for i in 1:n};

  Real DP_plot_1[n]={DP_1[i] for i in 1:n} "Pressure loss [Pa]";
  Real lambda_FRI[n]={(d_hydT[i]/L)*2*abs(DP_plot_1[i])/(max(rho*(velocity_1[i])
      ^2, MIN)) for i in 1:n} "Darcy friction factor";

public
  Modelica.Blocks.Sources.Ramp input_mflow_0(
    startTime=0,
    offset=0,
    duration=1,
    height=100) annotation ( Placement(
        transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Sine input_mflow_1(
    offset=0,
    phase=0,
    startTime=0,
    freqHz=1,
    amplitude=100) annotation (Placement(
        transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Exponentials input_mflow_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=100) annotation (Placement(transformation(
          extent={{0,-80},{20,-60}})));
  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_DP[n](m_flow=
       input_mdot_1, each target=FluidDissipation.Utilities.Types.PressureLossTarget.PressureLoss)
    annotation (Placement(transformation(extent={{-70,1},{-50,21}})));

  SI.Pressure DP_1[n] "pressure loss" annotation (Dialog(group="Output"));
  SI.MassFlowRate M_FLOW_1[n] "mass flow rate"
    annotation (Dialog(group="Output"));

  FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget_MFLOW[n](
                dp=input_dp_1, each target=FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate)
    annotation (Placement(transformation(extent={{60,1},{80,21}})));
equation
  //target == DP (incompressible)
  for i in 1:n loop
    (DP_1[i],,,,,) =
      FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall(
      m_flow_IN_con_1[i],
      m_flow_IN_var_1[i],
      chosenTarget_DP[i]);
  end for;

  //target == M_FLOW (compressible)
  for i in 1:n loop
    (,M_FLOW_1[i],,,,) =
      FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall(
      dp_IN_con_1[i],
      dp_IN_var_1[i],
      chosenTarget_MFLOW[i]);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/channel/dp_internalFlowOverall.mos"
        "Verification of dp_internalFlowOverall"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-100,50},{100,75}},
          lineColor={0,0,255},
          textString=
            "Pressure loss of CHANNEL for OVERALL flow regime (different geometries | inverse)"),
          Text(
          extent={{-43,22},{48,2}},
          lineColor={0,0,255},
          textString="different geometries as target")}));
end dp_internalFlowOverall;
