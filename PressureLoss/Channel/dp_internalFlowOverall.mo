within FluidDissipation.PressureLoss.Channel;
function dp_internalFlowOverall "Pressure loss of internal flow | overall flow regime | surface roughness | several geometries"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 1978.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002
  //Notation of equations according to SOURCES

  //input records
  input FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_con IN_con "Input record for function dp_internalFlowOverall"
    annotation (Dialog(group="Constant inputs"));

  input FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_var IN_var "Input record for function dp_internalFlowOverall"
    annotation (Dialog(group="Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget "Target variable of calculation"
                                     annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "pressure loss" annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW "mass flow rate"
    annotation (Dialog(group="Output"));
  output Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient"
                                annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Real failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

  import TYP = FluidDissipation.Utilities.Types.GeometryOfInternalFlow;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, if IN_con.geometry == TYP.Annular then (PI/4)*((
      IN_con.D_ann)^2 - (IN_con.d_ann)^2) else if IN_con.geometry == TYP.Circular then
            PI/4*(IN_con.d_cir)^2 else if IN_con.geometry == TYP.Elliptical then
            PI*IN_con.a_ell*IN_con.b_ell else if IN_con.geometry == TYP.Rectangular then
            IN_con.a_rec*IN_con.b_rec else if IN_con.geometry == TYP.Isosceles then
            0.5*(IN_con.a_tri*IN_con.h_tri) else 0) "Cross sectional area";
  SI.Length perimeter=max(MIN, if IN_con.geometry == TYP.Annular then PI*(
      IN_con.D_ann + IN_con.d_ann) else if IN_con.geometry == TYP.Circular then
            PI*IN_con.d_cir else if IN_con.geometry == TYP.Elliptical then PI*(
      IN_con.a_ell + IN_con.b_ell) else if IN_con.geometry == TYP.Rectangular then
            2*(IN_con.a_rec + IN_con.b_rec) else if IN_con.geometry == TYP.Isosceles then
            IN_con.a_tri + 2*((IN_con.h_tri)^2 + (IN_con.a_tri/2)^2)^0.5 else 0) "Perimeter";
  SI.Diameter d_hyd=4*A_cross/perimeter "Hydraulic diameter";

  SI.Velocity velocity "Mean velocity";

  //failure status
  Real fstatus[1] "Check of expected boundary conditions";

  //Documentation
algorithm

  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW :=
      FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_DP(
      IN_con,
      IN_var,
      chosenTarget.m_flow);
  end if;

  velocity := abs(M_FLOW)/max(MIN, IN_var.rho*A_cross);
  Re := max(1e-3, FluidDissipation.Utilities.Functions.General.ReynoldsNumber(
    A_cross,
    perimeter,
    IN_var.rho,
    IN_var.eta,
    abs(chosenTarget.m_flow))) "Reynolds number";
  zeta_TOT := DP/(0.5*IN_var.rho*max(MIN, velocity^2));

  //failure status
  fstatus[1] := 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;
  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Calculation of pressure loss for an internal flow through different geometries at overall flow regime for incompressible and single-phase fluid flow considering surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<h4><font color=\"#EF9B13\">Restriction</font></h4>
This function shall be used inside of the restricted limits according to the referenced literature.
<ul>
 <li>
      <b> developed fluid flow </b>
 </li>
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
<p>
<img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/channel/pic-pLchannel.png\">
</p>
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation for internal fluid flow in different geometries is further documented <a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_DP\">dp_internalFlowOverall_DP</a>.
</html>"));
end dp_internalFlowOverall;
