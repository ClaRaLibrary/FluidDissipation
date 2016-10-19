within FluidDissipation.PressureLoss.General;
function dp_nominalPressureLossLawDensity_DP
  "Generic pressure loss | calculate pressure loss | nominal operation point | pressure loss law (coefficient and exponent) | density dependence"
  extends Modelica.Icons.Function;

  import FD = FluidDissipation.PressureLoss.General;

  //input records
  input
    FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_con
    IN_con "Input record for function dp_nominalPressureLossLawDensity_DP"
    annotation (Dialog(group="Constant inputs"));
  input
    FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_IN_var
    IN_var "Input record for function dp_nominalPressureLossLawDensity_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));

  //output variables
  output SI.Pressure DP
    "Output for function dp_nominalPressureLossLawDensity_yesAJac_DP";

protected
  Real exp_density=if IN_con.target ==FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate
                                                                                               then
            1 - IN_con.exp else 1 "Exponent of density fraction (rho/rho_nom)";
  SI.MassFlowRate m_flow_nom=if IN_con.target ==FluidDissipation.Utilities.Types.MassOrVolumeFlowRate.MassFlowRate
                                                                                               then
            IN_con.m_flow_nom else IN_var.rho*IN_con.V_flow_nom
    "Nominal mean flow velocity at operation point";

  SI.MassFlowRate m_flow_linear=(0.01*(IN_con.zeta_TOT_nom/IN_var.zeta_TOT)*(
      IN_con.rho_nom/IN_var.rho)^(exp_density)*(IN_con.A_cross/IN_con.A_cross_nom)
      ^(IN_con.exp)*IN_con.m_flow_nom)^(1/IN_con.exp)
    "Start of approximation for decreasing mass flow rate";

  //Documentation

algorithm
  DP := if IN_con.exp > 1.0 or IN_con.exp < 1.0 then
    FluidDissipation.Utilities.Functions.General.SmoothPower(
    m_flow,
    m_flow_linear,
    IN_con.exp)*IN_con.dp_nom*(IN_var.zeta_TOT/IN_con.zeta_TOT_nom)*(IN_var.rho
    /IN_con.rho_nom)^(exp_density)*(IN_con.A_cross_nom/IN_con.A_cross)^(IN_con.exp)
    *(1/IN_con.m_flow_nom)^(IN_con.exp) else IN_con.dp_nom*(IN_var.zeta_TOT/
    IN_con.zeta_TOT_nom)*(IN_var.rho/IN_con.rho_nom)^(exp_density)*(IN_con.A_cross_nom
    /IN_con.A_cross)^(1)*(m_flow/IN_con.m_flow_nom)^(1);

  annotation (Inline=false,
    smoothOrder(normallyConstant=IN_con) = 2,
    inverse(m_flow=FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_MFLOW(
          IN_con,
          IN_var,
          DP)),
    Documentation(info="<html>
<p>Calculation of a generic pressure loss in dependence of nominal fluid variables (e.g. nominal density) via interpolation from an operation point. This generic function considers the pressure loss law via a nominal pressure loss (dp_nom), a pressure loss coefficient (zeta_TOT) and a pressure loss law exponent (exp) as well as the influence of density on pressure loss. The function can be used to calculate pressure loss at known mass flow rate <b>or </b>mass flow rate at known pressure loss. </p>
<p>This function can be used to calculate both the pressure loss at known mass flow rate <b>or </b>mass flow rate at known pressure loss within one function in dependence of the known variable (dp or m_flow). </p>
<p>Generally this function is numerically best used for the <b>incompressible case </b>, where the mass flow rate (m_flow) is known (as state variable) in the used model and the corresponding pressure loss (DP) has to be calculated. On the other hand the function <a href=\"Modelica://FluidDissipation.PressureLoss.General.dp_nominalPressureLossLawDensity_MFLOW\">dp_nominalPressureLossLawDensity_MFLOW</a> is numerically best used for the <b>compressible case </b>if the pressure loss (dp) is known (out of pressures as state variable) and the mass flow rate (M_FLOW) has to be calculated. </p>
<p><h4><font color=\"#ef9b13\">Calculation</font></h4></p>
<p>The geometry parameters of energy devices necessary for the pressure loss calculations are often not exactly known. Therefore the modelling of the detailed pressure loss calculation have to be simplified. This function uses nominal variables (e.g. nominal pressure loss) at a known operation point of the energy device to interpolate the actual pressure loss according to a pressure loss law (exponent). </p>
<p>In the following the pressure loss <b>dp </b>is generally determined from a known operation point via a law of similarity: </p>
<p><code>   dp/dp_nom = (zeta_TOT/zeta_TOT_nom)*(rho/rho_nom)*(v/v_nom)^exp</code> </p>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>dp </h4></p></td>
<td><p>as pressure loss [Pa],</p></td>
</tr>
<tr>
<td><p><h4>dp_nom </h4></p></td>
<td><p>as nominal pressure loss [Pa],</p></td>
</tr>
<tr>
<td><p><h4>m_flow </h4></p></td>
<td><p>as mass flow rate [kg/s],</p></td>
</tr>
<tr>
<td><p><h4>m_flow_nom </h4></p></td>
<td><p>as nominal mass flow rate [kg/s],</p></td>
</tr>
<tr>
<td><p><h4>exp </h4></p></td>
<td><p>as exponent of pressure loss calculation [-],</p></td>
</tr>
<tr>
<td><p><h4>rho </h4></p></td>
<td><p>as fluid density [kg/m3],</p></td>
</tr>
<tr>
<td><p><h4>rho_nom </h4></p></td>
<td><p>as nominal fluid density [kg/m3],</p></td>
</tr>
<tr>
<td><p><h4>v </h4></p></td>
<td><p>as mean flow velocity [m/s],</p></td>
</tr>
<tr>
<td><p><h4>v_nom </h4></p></td>
<td><p>as nominal mean flow velocity [m/s],</p></td>
</tr>
<tr>
<td><p><h4>zeta_TOT </h4></p></td>
<td><p>as pressure loss coefficient [-],</p></td>
</tr>
<tr>
<td><p><h4>zeta_TOT_nom </h4></p></td>
<td><p>as nominal pressure loss coefficient [-].</p></td>
</tr>
</table>
<p><br/>The fraction of mean flow velocities (v/v_nom) can be calculated through its corresponding <b>mass flow rates </b>, densities and cross sectional areas: </p>
<p><code>   v/v_nom = (m_flow/m_flow_nom)*(A_cross_nom/A_cross)*(rho_nom/rho)</code> </p>
<p><b>or </b>through its corresponding <b>volume flow rates </b>, densities and cross sectional areas: </p>
<p><code>    v/v_nom = (V_flow/V_flow_nom)*(A_cross_nom/A_cross).</code> </p>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>A_cross </h4></p></td>
<td><p>as cross sectional area [m2],</p></td>
</tr>
<tr>
<td><p><h4>A_cross_nom </h4></p></td>
<td><p>as nominal cross sectional area [m2],</p></td>
</tr>
<tr>
<td><p><h4>rho </h4></p></td>
<td><p>as fluid density [kg/m3],</p></td>
</tr>
<tr>
<td><p><h4>rho_nom </h4></p></td>
<td><p>as nominal fluid density [kg/m3],</p></td>
</tr>
<tr>
<td><p><h4>v </h4></p></td>
<td><p>as mean flow velocity [m/s],</p></td>
</tr>
<tr>
<td><p><h4>v_nom </h4></p></td>
<td><p>as nominal mean flow velocity [m/s],</p></td>
</tr>
<tr>
<td><p><h4>V_flow </h4></p></td>
<td><p>as volume flow rate [m3/s],</p></td>
</tr>
<tr>
<td><p><h4>V_flow_nom </h4></p></td>
<td><p>as nominal volume flow rate [m3/s].</p></td>
</tr>
</table>
<p><br/>Here the <b>incompressible case </b>[Pressure loss = f(m_flow)] calculates the unknown pressure loss out of a given mass flow rate: </p>
<p><code>   dp = dp_nom*(zeta_TOT/zeta_TOT_nom)*(rho/rho_nom)^(exp_density)*(A_cross_nom/A_cross)^(exp)*(m_flow/m_flow_nom)^(exp)</code> </p>
<p>where the exponent for the fraction of densities is determined w.r.t. the chosen nominal mass flow rate or nominal volume flow rate to: </p>
<p><code>  exp_density = if NominalMassFlowRate == 1 then 1-exp else 1</code> </p>
<p>with </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p><h4>NominalMassFlowRate </h4></p></td>
<td><p>as reference of pressure loss law (mass flow rate of volume flow rate),</p></td>
</tr>
<tr>
<td><p><h4>exp </h4></p></td>
<td><p>as exponent of pressure loss calculation [-],</p></td>
</tr>
<tr>
<td><p><h4>exp_density </h4></p></td>
<td><p>as exponent for density [-].</p></td>
</tr>
</table>
<p><br/>To avoid numerical difficulties this pressure loss function is linear smoothed for small mass flow rates, with </p>
<p><code>m_flow &le; [0.01*(zeta_TOT_nom/zeta_TOT)*(rho_nom/rho)^(exp_density)*(A_cross/A_cross_nom)^(exp)*m_flow_nom]^(1/exp)</code> </p>
<p>Note that the input and output arguments for functions throughout this library always use mass flow rates. Here you can choose <b>NominalMassFlowRate == 1 </b>for using a nominal mass flow rate or <b>NominalMassFlowRate == 2 </b>for using a nominal volume flow rate. The output argument will always be a mass flow rate for further use as flow model in a thermo-hydraulic framework. </p>
<p>Note that the pressure loss coefficients (zeta_TOT,zeta_TOT_nom) refer to its mean flow velocities (v,v_nom) in the pressure loss law to obtain its corresponding pressure loss. </p>
<p><h4><font color=\"#ef9b13\">Verification</font></h4></p>
<p><b>Incompressible case </b>[Pressure loss = f(m_flow)]: The generic pressure loss <b>DP </b>in dependence of the mass flow rate <b>m_flow </b>with different fluid densities as parameter is shown for a turbulent pressure loss regime (exp == 2) in the figure below. </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/pressureLoss/general/fig_general_dp_nominalPressureLosslawDensity_DPvsMFLOW.png\"/> </p>
<p><b><font style=\"color: #ef9b13; \">References</font></b> </p>
<dl><dt>Elmquist, H., M.Otter and S.E. Cellier: </dt>
<dd><b>Inline integration: A new mixed symbolic / numeric approach for solving differential-algebraic equation systems.</b>. In Proceedings of European Simulation MultiConference, Praque, 1995.</dd>
<dt>Wischhusen, S.: </dt>
<dd><b>Dynamische Simulation zur wirtschaftlichen Bewertung von komplexen Energiesystemen.</b>. PhD thesis, Technische Universit&auml;t Hamburg-Harburg, 2005. </dd>
</dl></html>"));
end dp_nominalPressureLossLawDensity_DP;
