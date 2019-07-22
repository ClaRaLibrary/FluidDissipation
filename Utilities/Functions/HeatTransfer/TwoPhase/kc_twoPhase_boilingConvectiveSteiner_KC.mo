within FluidDissipation.Utilities.Functions.HeatTransfer.TwoPhase;
function kc_twoPhase_boilingConvectiveSteiner_KC
  "Heat transfer coefficient for saturated fluid in convective boiling regime from VDI Heat Atlas (Steiner-Taborek model)"
  import SMOOTH = FluidDissipation.Utilities.Functions.General.Stepsmoother;
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowConvectiveBoiling_IN_con IN_con;
  input FluidDissipation.Utilities.Records.HeatTransfer.TwoPhaseFlowConvectiveBoiling_IN_var IN_var;

  output Modelica.SIunits.CoefficientOfHeatTransfer kc "Local two phase heat transfer coefficient";
  output Real failure "digits: |density ratio failure|presusre failure|";

protected
  Real p_red=IN_var.p/IN_con.p_crit "Reduced pressure";
  Real failure_rho "Density ratio failure";
  Real failure_p "Pressure failure";

  Real Phi "Normalized wetted radius";
  Real Psi "Factor psi";
  Real M "Fin number (Rippenkennzahl)";
  Modelica.SIunits.CoefficientOfHeatTransfer kc_Lb "Heat transfer coefficient of wettet radius";
  Real a "Ratio of heat transfer coefficients";
  Real f1 "Factor 1";
  Real f2 "Factor 2";
algorithm
  Phi:= IN_var.phi/(2*Modelica.Constants.pi);
  if IN_con.orientation == "Vertical" then
    kc := IN_var.kc_l*((1 - IN_var.x_flow)^0.01*((1 - IN_var.x_flow)^1.5 + 1.9*IN_var.x_flow^0.6*(IN_var.rho_l/IN_var.rho_g)^0.35)^(-2.2) + IN_var.x_flow^0.01*(IN_var.kc_g/IN_var.kc_l*(1 + 8*(1 - IN_var.x_flow)^0.7*(IN_var.rho_l/IN_var.rho_g)^0.67))^(-2))^(-0.5) "eqn. 38 in source 2";
    kc_Lb := kc;
    failure_rho := if (IN_var.rho_l/IN_var.rho_g) < 3.5 or (IN_var.rho_l/IN_var.rho_g) > 5000 then 10 else 0;
    failure_p := if p_red < 1e-3 or p_red > 0.8 then 1 else 0;
    M := kc_Lb*IN_con.d_hyd*Modelica.Constants.pi^2*(IN_con.d_hyd+IN_con.s)/(IN_var.lambda_wall*4*IN_con.s);
    a := IN_var.kc_g/kc_Lb;
    f1 := 1;
    f2 := 1;
    Psi := 1;

  else    // horizontal (tilt angle < 30)
    M := kc_Lb*IN_con.d_hyd*Modelica.Constants.pi^2*(IN_con.d_hyd+IN_con.s)/(IN_var.lambda_wall*4*IN_con.s);
    kc_Lb := IN_var.kc_l*((1 - IN_var.x_flow)^0.01*((1 - IN_var.x_flow) + 1.2*IN_var.x_flow^0.4*(IN_var.rho_l/IN_var.rho_g)^0.37)^(-2.2) + IN_var.x_flow^0.01*(IN_var.kc_g/IN_var.kc_l*(1 + 8*(1 - IN_var.x_flow)^0.7*(IN_var.rho_l/IN_var.rho_g)^0.67))^(-2))^(-0.5) "eqn. 40 in source 2";
    a := IN_var.kc_g/kc_Lb;
     if IN_con.boundary=="Fixed heating" and M>1 then
        f1 := (a*sqrt(M)*Phi*(1-Phi)*cosh(sqrt(M)*(1-Phi))/sinh(sqrt(M)*(1-Phi)))*SMOOTH(3,4,IN_var.flowPattern)+1*SMOOTH(
         4,
         3,
         IN_var.flowPattern);
        f2 := (sqrt(M*a)*Phi*(1-Phi)*cosh(sqrt(M*a)*Phi)/sinh(sqrt(M*a)*Phi))*SMOOTH(3,4,IN_var.flowPattern)+1*SMOOTH(
         4,
         3,
         IN_var.flowPattern);//formula has changed in 11th edition, however the resulting graph in an example was not changed and resulting phi can be <1 which is not a pysical meaningful result, therefore it was stuck to the old version from the 9th edition
        Psi := (1+Phi*(1-Phi)*(1-a)^2/a*(1-((1-(1-a)*Phi)/max(f1+f2,Modelica.Constants.eps))))*SMOOTH(3,4,IN_var.flowPattern)+1*SMOOTH(
         4,
         3,
         IN_var.flowPattern);
        kc := (kc_Lb*(1-(1-a)*Phi)/Psi)*SMOOTH(3,4,IN_var.flowPattern)+kc_Lb*SMOOTH(
         4,
         3,
         IN_var.flowPattern);
     else
         Psi := 1;
         f1 := 1;
         f2 := 1;
         kc := (kc_Lb*(1-Phi)+IN_var.kc_g*Phi)*SMOOTH(3,4,IN_var.flowPattern)+kc_Lb*SMOOTH(
         4,
         3,
         IN_var.flowPattern);
     end if;

    failure_rho := if (IN_var.rho_l/IN_var.rho_g) < 3.5 or (IN_var.rho_l/IN_var.rho_g) > 1500 then 10 else 0;
    failure_p := if p_red < 1e-3 or p_red > 0.8 then 1 else 0;
  end if;
  failure := failure_rho + failure_p;
  // Source 2: Verein Deutscher Ingenieure, VDI Gesellschaft fr Verfahrenstechnik und Chemieingenieurwesen, ed, VDI Heat Atlas, 9th edition, 2002, in German, section Hbb "Convective Boiling af Saturated Fluids".
  annotation (Documentation(info="<html>
<p><br><br><b>The model calculates the convective boiling heat transfer coefficient for straight pipes. For horizontal pipes the flow pattern influences the coefficient.</b> </p>
<p><b><span style=\"font-size: 12pt; color: #ef9b13;\">Vertical</span></b> </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation013.png\"/></p>
<p>valid for</p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation015.png\"/></p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation016.png\"/></p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation017.png\"/> </p>
<p><br><b><span style=\"font-size: 12pt; color: #ef9b13;\">Horizontal</span></b> </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation014.png\"/> </p>
<p>For wavy and stratified flows the upper pipe wall is not wet completely. Thus, the perimeter-averaged heat transfer coefficient is reduced: </p>
<p><br>The normalised unwet radius is defined as:</p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation060.png\"/></p>
<p><br>The ratio of the local heat transfer coefficients for the wet (B1b) and the dry wall</p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation061.png\"/></p>
<p><br>The fin number is defined as</p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation062.png\"/></p>
<p><br>for constant heat flux as boundary condition and M&gt;1:</p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation063.png\"/></p>
<p><br>with</p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation064.png\"/></p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation065.png\"/></p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation066.png\"/></p>
<p><br>for constant heat flux as boundary condition and M&lt;1 or constant temperature as boundary condition :</p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation067.png\"/></p>
<p><br><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation068.png\"/> </p>
<p><br><b><span style=\"font-size: 12pt; color: #ef9b13;\">Numerical treatment</span></b> </p>
<p>A transition of the flow pattern from wavy to slug/plug flow or annular flow causes a sudden wetting of the upper tube wall. Thus, the perimeter-averaged rises suddenly. To make this transition numerical stable, the FluidDissipation stepsmoother is combined with equation (B5). Input of the stepsmoother is the real variable flowPattern, which is calculated in the FlowPatternMap subfunction. We get</p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation202.png\"/></p>
<p>The result is the wet heat transfer coefficient for <img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation203.png\"/> , which can mean the following flow patterns: plug/slug, annular, bubble, mist. For <img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation204.png\"/> (i.e. stratified or wavy flow) the result is the dry heat transfer coefficient from eq. (B5). In the transition zone, i.e. <img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/equation205.png\"/> the result is smoothed between the result of eq. (B1b) and (B5). The same procedure is applied to equation (B10). </p>
<p><br><b><span style=\"font-size: 12pt; color: #ef9b13;\">Validation</span></b> </p>
<p><img src=\"modelica://FluidDissipation/Extras/Images/heatTransfer/straightPipe/convectiveBoiling/HT_ConvectiveBoiling.png\"/></p>
<p>Data for verification is taken from [1]. </p>
<p><b><span style=\"font-size: 12pt; color: #ef9b13;\">References</span></b> </p>
<p>[1] <b>VDI W&auml;rmeatlas (VDI Heat Atlas)</b>, Chapter H3.4, 11th edition 2013</p>
<p>[2] <b>VDI W&auml;rmeatlas (VDI Heat Atlas)</b>, Chapter Hbb, 9th edition 2002 </p>
</html>"));
end kc_twoPhase_boilingConvectiveSteiner_KC;
