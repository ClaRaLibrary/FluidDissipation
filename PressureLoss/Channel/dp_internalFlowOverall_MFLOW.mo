within FluidDissipation.PressureLoss.Channel;
function dp_internalFlowOverall_MFLOW "Pressure loss of internal flow | calculate mass flow rate | overall flow regime | surface roughness | several geometries"
  extends Modelica.Icons.Function;
  import FD = FluidDissipation.PressureLoss.Channel;
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_con IN_con "Input record for function dp_internalFlowOverall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_IN_var IN_var "Input record for function dp_internalFlowOverall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));

  //output variables
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";

  import TYP1 = FluidDissipation.Utilities.Types.GeometryOfInternalFlow;
  import TYP2 = FluidDissipation.Utilities.Types.Roughness;

protected
  Real MIN=Modelica.Constants.eps;

  SI.Area A_cross=max(MIN, if IN_con.geometry == TYP1.Annular then (PI/4)*((
      IN_con.D_ann)^2 - (IN_con.d_ann)^2) else if IN_con.geometry == TYP1.Circular then
            PI/4*(IN_con.d_cir)^2 else if IN_con.geometry == TYP1.Elliptical then
            PI*IN_con.a_ell*IN_con.b_ell else if IN_con.geometry == TYP1.Rectangular then
            IN_con.a_rec*IN_con.b_rec else if IN_con.geometry == TYP1.Isosceles then
            0.5*(IN_con.a_tri*IN_con.h_tri) else 0) "Cross sectional area";
  SI.Length perimeter=max(MIN, if IN_con.geometry == TYP1.Annular then PI*(
      IN_con.D_ann + IN_con.d_ann) else if IN_con.geometry == TYP1.Circular then
            PI*IN_con.d_cir else if IN_con.geometry == TYP1.Elliptical then PI*
      (IN_con.a_ell + IN_con.b_ell) else if IN_con.geometry == TYP1.Rectangular then
            2*(IN_con.a_rec + IN_con.b_rec) else if IN_con.geometry == TYP1.Isosceles then
            IN_con.a_tri + 2*((IN_con.h_tri)^2 + (IN_con.a_tri/2)^2)^0.5 else 0) "Perimeter";
  SI.Diameter d_hyd=4*A_cross/perimeter "Hydraulic diameter";
  Real beta=IN_con.beta*180/PI "Top angle";

  //SOURCE_2: p.138, sec 8.5
  Real Dd_ann=min(max(MIN, IN_con.d_ann), IN_con.D_ann)/max(MIN, max(IN_con.d_ann,
      IN_con.D_ann)) "Ratio of small to large diameter of annular geometry";
  Real CF_ann=98.7378*Dd_ann^0.0589 "Correction factor for annular geometry";
  Real ab_rec=min(IN_con.a_rec, IN_con.b_rec)/max(MIN, max(IN_con.a_rec, IN_con.b_rec)) "Aspect ratio of rectangular geometry";
  Real CF_rec=-59.85*(ab_rec)^3 + 148.67*(ab_rec)^2 - 128.1*(ab_rec) + 96.1 "Correction factor for rectangular geometry";
  Real ab_ell=min(IN_con.a_ell, IN_con.b_ell)/max(MIN, max(IN_con.a_ell, IN_con.b_ell)) "Ratio of small to large length of annular geometry";
  Real CF_ell=-169.2211*(ab_ell)^4 + 260.9028*(ab_ell)^3 - 113.7890*(ab_ell)^2
       + 9.2588*(ab_ell)^1 + 78.7124 "Correction factor for elliptical geometry";
  Real CF_tri=-0.0013*(min(90, beta))^2 + 0.1577*(min(90, beta)) + 48.5575 "Correction factor for triangular geometry";
  Real CF_lam=if IN_con.geometry == TYP1.Annular then CF_ann else if IN_con.geometry
       == TYP1.Circular then 64 else if IN_con.geometry == TYP1.Elliptical then
            CF_ell else if IN_con.geometry == TYP1.Rectangular then CF_rec else
            if IN_con.geometry == TYP1.Isosceles then CF_tri else 0 "Correction factor for laminar flow";

  //SOURCE_1: p.81, fig. 2-3, sec 21-22: definition of flow regime boundaries
  Real k=max(MIN, abs(IN_con.K)/d_hyd) "Relative roughness";
  SI.ReynoldsNumber Re_lam_min=1e3 "Minimum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_lam_max=2090*(1/max(0.007, k))^0.0635 "Maximum Reynolds number for laminar regime";
  SI.ReynoldsNumber Re_turb_min=4e3 "Minimum Reynolds number for turbulent regime";

  SI.ReynoldsNumber Re_lam_leave=min(Re_lam_max, max(Re_lam_min, 754*
      Modelica.Math.exp(if k <= 0.007 then 0.0065/0.007 else 0.0065/k))) "Start of transition regime for increasing Reynolds number (leaving laminar regime)";

  //determining Darcy friction factor out of pressure loss calculation for straight pipe:
  //dp = lambda_FRI*L/d_hyd*(rho/2)*velocity^2 and assuming lambda_FRI == lambda_FRI_calc/Re^2
  TYP.DarcyFrictionFactor lambda_FRI_calc=2*abs(dp)*d_hyd^3*IN_var.rho/(IN_con.L
      *IN_var.eta^2) "Adapted Darcy friction factor";

  //SOURCE_3: p.Lab 1, eq. 5: determine Re assuming laminar regime
  SI.ReynoldsNumber Re_lam=lambda_FRI_calc/CF_lam "Reynolds number assuming laminar regime";

  //SOURCE_3: p.Lab 2, eq. 10: determine Re assuming turbulent regime (Colebrook-White)
  SI.ReynoldsNumber Re_turb=if IN_con.roughness == TYP2.Neglected then (max(MIN,
      lambda_FRI_calc)/0.3164)^(1/1.75) else -2*sqrt(max(lambda_FRI_calc, MIN))
      *Modelica.Math.log10(2.51/sqrt(max(lambda_FRI_calc, MIN)) + k/3.7) "Reynolds number assuming turbulent regime";

  //determine actual flow regime
  SI.ReynoldsNumber Re_check=if Re_lam < Re_lam_leave then Re_lam else Re_turb;
  //determine Re for transition regime
  SI.ReynoldsNumber Re_trans=if Re_lam >= Re_lam_leave then
      FluidDissipation.Utilities.Functions.General.CubicInterpolation_DP(
      Re_check,
      Re_lam_leave,
      Re_turb_min,
      k,
      lambda_FRI_calc) else 0;
  //determine actual Re
  SI.ReynoldsNumber Re=if Re_lam < Re_lam_leave then Re_lam else if Re_turb >
      Re_turb_min then Re_turb else Re_trans;

  FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_con IN_2_con(
    final roughness=IN_con.roughness,
    final d_hyd=d_hyd,
    final K=IN_con.K,
    final L=IN_con.L) "Input record for turbulent regime"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  FluidDissipation.PressureLoss.StraightPipe.dp_overall_IN_var IN_2_var(final eta=
       IN_var.eta, final rho=IN_var.rho) "Input record for turbulent regime"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  //Documentation

algorithm
  M_FLOW := SMOOTH(
    Re_lam_min,
    Re_turb,
    Re)*IN_var.rho*A_cross*(dp*(2/CF_lam)*(d_hyd^2/IN_con.L)*(1/IN_var.eta)) +
    SMOOTH(
    Re_turb,
    Re_lam_min,
    Re)*(A_cross/((PI/4)*d_hyd^2))*
    FluidDissipation.PressureLoss.StraightPipe.dp_turbulent_MFLOW(
    IN_2_con,
    IN_2_var,
    dp);
  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(dp=FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_DP(
          IN_con,
          IN_var,
          M_FLOW)),
    Documentation(info="<html>
<p>
Calculation of pressure loss for an internal flow through different geometries at overall flow regime for incompressible and single-phase fluid flow considering surface roughness.
</p>
 
<p>
This function can be used to calculate both the pressure loss at known mass flow rate <b> or </b> mass flow rate at known pressure loss within one function in dependence of the known 
variable (dp or m_flow).
</p>
 
<p>
Generally this function is numerically best used for the <b> compressible case </b> if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.Channel.dp_internalFlowOverall_DP\">dp_internalFlowOverall_DP</a> is numerically best used for the <b> incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. 
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
end dp_internalFlowOverall_MFLOW;
