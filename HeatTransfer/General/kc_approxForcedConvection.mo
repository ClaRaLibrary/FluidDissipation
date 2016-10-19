within FluidDissipation.HeatTransfer.General;
function kc_approxForcedConvection
  "Mean convective heat transfer coefficient for forced convection | approximation | turbulent regime | hydrodynamically developed fluid flow"
  extends Modelica.Icons.Function;
  //SOURCE: A Bejan and A.D. Kraus. Heat Transfer handbook.John Wiley & Sons, 2nd edition, 2003. (p.424 ff)
  //Notation of equations according to SOURCE

  //input records
  input FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con IN_con
    "Input record for function kc_approxForcedConvection"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var IN_var
    "Input record for function kc_approxForcedConvection"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output SI.CoefficientOfHeatTransfer kc "Convective heat transfer coefficient"
    annotation (Dialog(group="Output"));
  output SI.PrandtlNumber Pr "Prandtl number" annotation (Dialog(group="Output"));
  output SI.ReynoldsNumber Re "Reynolds number"
    annotation (Dialog(group="Output"));
  output SI.NusseltNumber Nu "Nusselt number"
    annotation (Dialog(group="Output"));
  output Real failureStatus
    "0== boundary conditions fulfilled | 1== failure >> check if still meaningful results"
    annotation (Dialog(group="Output"));

protected
  type TYP = Modelica.Fluid.Dissipation.Utilities.Types.kc_general;

  Real MIN=Modelica.Constants.eps "Limiter";

  Real prandtlMax[3]={120,16700,500} "Maximum Prandtl number";
  Real prandtlMin[3]={0.7,0.7,1.5} "Minimum Prandtl number";
  Real reynoldsMax[3]={1.24e5,1e6,1e6} "Maximum Reynolds number";
  Real reynoldsMin[3]={2500,1e4,3e3} "Minimum Reynolds number";

  SI.Diameter d_hyd=max(MIN, 4*IN_con.A_cross/max(MIN, IN_con.perimeter))
    "Hydraulic diameter";

  //failure status
  Real fstatus[2] "Check of expected boundary conditions";

algorithm
  Pr := FluidDissipation.Utilities.Functions.General.PrandtlNumber(
    IN_var.cp,
    IN_var.eta,
    IN_var.lambda);
  Re := FluidDissipation.Utilities.Functions.General.ReynoldsNumber(
    IN_con.A_cross,
    IN_con.perimeter,
    IN_var.rho,
    IN_var.eta,
    abs(IN_var.m_flow)) "Reynolds number";
  kc := FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC(
    IN_con, IN_var);
  Nu := kc*d_hyd/max(MIN, IN_var.lambda);

  //failure status
  fstatus[1] := if IN_con.target == TYP.Rough then if Pr > prandtlMax[1] or Pr
     < prandtlMin[1] then 1 else 0 else if IN_con.target == TYP.Middle then if
    Pr > prandtlMax[2] or Pr < prandtlMin[2] then 1 else 0 else if IN_con.target
     == TYP.Finest then if Pr > prandtlMax[3] or Pr < prandtlMin[3] then 1 else
          0 else 0;
  fstatus[2] := if IN_con.target == TYP.Rough then if Re > reynoldsMax[1] or Re
     < reynoldsMin[1] then 1 else 0 else if IN_con.target == TYP.Middle then
    if Re > reynoldsMax[2] or Re < reynoldsMin[2] then 1 else 0 else if IN_con.target
     == TYP.Finest then if Re > reynoldsMax[3] or Re < reynoldsMin[3] then 1 else
          0 else 0;

  failureStatus := 0;
  for i in 1:size(fstatus, 1) loop
    if fstatus[i] == 1 then
      failureStatus := 1;
    end if;
  end for;

  annotation (Inline=false, smoothOrder(normallyConstant=IN_con) = 2, Documentation(
        info="<html>
<p>
Approximate calculation of the mean convective heat transfer coefficient <b> kc </b> for forced convection with a fully developed fluid flow in a turbulent regime.
</p>

</p>
A detailed documentation for this convective heat transfer calculation can be found in its underlying function <a href=\"Modelica://FluidDissipation.HeatTransfer.General.kc_approxForcedConvection_KC\">kc_approxForcedConvection_KC</a>.

Note that additionally a failure status is observed in this function to check if the intended boundary conditions are fulfilled.
</p>
</html>", revisions="<html>
</html>"));
end kc_approxForcedConvection;
