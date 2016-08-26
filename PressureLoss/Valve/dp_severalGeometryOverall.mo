within FluidDissipation.PressureLoss.Valve;
function dp_severalGeometryOverall "Pressure loss of internal flow | overall flow regime | surface roughness | several geometries"
  extends Modelica.Icons.Function;
  //SOURCE_1: Idelchik, I.E.: HANDBOOK OF HYDRAULIC RESISTANCE, 3rd edition, 2006.
  //SOURCE_2: Miller, D.S.: INTERNAL FLOW SYSTEMS, 1978.
  //SOURCE_3: VDI-Waermeatlas, 9th edition, Springer-Verlag, 2002
  //Notation of equations according to SOURCES

  //input records
  input FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_con IN_con "Input record for function dp_severalGeometryOverall"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_IN_var IN_var "Input record for function dp_severalGeometryOverall"
    annotation (Dialog(group="Variable inputs"));
  input FluidDissipation.Utilities.Records.PressureLoss.PressureLossInput chosenTarget "Target variable of calculation"
                                     annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP "Pressure loss" annotation (Dialog(group="Output"));
  output SI.MassFlowRate M_FLOW "Mass flow rate"
    annotation (Dialog(group="Output"));
  output Utilities.Types.PressureLossCoefficient zeta_TOT "Pressure loss coefficient"
                                annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(group="Output"));
  final output SI.PrandtlNumber Pr=0 "Prandtl number"
    annotation (Dialog(group="Output"));
  output Real failureStatus "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

  import TYP = FluidDissipation.Utilities.Types.ValveCoefficient;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=if IN_con.valveCoefficient == TYP.AV then IN_con.Av else if
      IN_con.valveCoefficient == TYP.KV then IN_con.Kv*27.7e-6 else if IN_con.valveCoefficient
       == TYP.CV then IN_con.Cv*24e-6 else if IN_con.valveCoefficient == TYP.OP then
            IN_con.m_flow_nominal/max(MIN, IN_con.opening_nominal*(IN_con.rho_nominal
      *IN_con.dp_nominal)^0.5) else MIN "Av (metric) flow coefficient [Av]=m^2";
  SI.Length perimeter=PI*(4*A_cross/PI)^0.5 "Assuming circular cross sectional area at entrance";

  SI.Velocity velocity "Mean velocity";

  //failure status
  Real fstatus[1] "Check of expected boundary conditions";

  //Documentation

algorithm
  if chosenTarget.target == FluidDissipation.Utilities.Types.PressureLossTarget.MassFlowRate then
    DP := chosenTarget.dp;
    M_FLOW :=
      FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW(
      IN_con,
      IN_var,
      chosenTarget.dp);
  else
    M_FLOW := chosenTarget.m_flow;
    DP := FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP(
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
Calculation of pressure loss for a valve with different geometries at overall flow regime for incompressible and single-phase fluid flow in dependence of its opening.
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
 <li>
      <b> ball valve </b>
 </li>
 <li>
      <b> diaphragm valve </b>
 </li>
 <li>
      <b> butterfly valve </b>
 </li>
</ul>
 
<p> 
<h4><font color=\"#EF9B13\">Geometry</font></h4> 
</p>
Wide variations in valve geometry are possible and a manufacturer will not necessarily maintain geometric similarity between valves of the same type but of different size. Here pressure loss can be estimated for the following types of a valve:
<ul>
 <li>
      <b> ball valve </b>
 </li>
 <li>
      <b> diaphragm valve </b>
 </li>
 <li>
      <b> butterfly valve </b>
 </li>
</ul> 
 
<h4><font color=\"#EF9B13\">Calculation</font></h4>
The pressure loss calculation of valves can be found in the documentation for the <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_DP\">incompressible case</a> or the <a href=\"Modelica://FluidDissipation.PressureLoss.Valve.dp_severalGeometryOverall_MFLOW\">compressible case</a>.

</html>"));
end dp_severalGeometryOverall;
