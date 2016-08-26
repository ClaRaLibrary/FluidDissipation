within FluidDissipation.Examples.Verifications.PressureLoss.Nozzle;
model dp_conicalOverall_DPMFLOW "Verification of function dp_concialOverall_DP"

  Real MIN=Modelica.Constants.eps;
  SI.ReynoldsNumber input_Re=input_Re_0.y;

  //Nozzle variables
  Real AR[6]={0.64,0.45,0.25,0.16,0.125,0.10};

  //fluid property variables
  SI.DynamicViscosity eta=17.1e-6 "Dynamic viscosity of fluid";
  SI.Density rho=1.2 "Density of fluid";

  //target 1: zeta_loc_lam = f(Re_lam) for different alpha at constant AR
  SI.Angle alpha_1[5]={2.5,5,10,15,20}*PI/180;
  SI.Angle alpha[5]={10,20,40,60,80}*PI/180;
  parameter Integer n=size(alpha, 1);
  SI.Diameter d_hyd_1_1=40e-3;
  Real AR_1=5/10;
  SI.Diameter d_hyd_2_1=d_hyd_1_1*AR_1^0.5;
  SI.Area A_1_1=PI*(d_hyd_1_1)^2/4;
  SI.Area A_2_1=AR_1*A_1_1;
  SI.Length C_1_1=PI*d_hyd_1_1;
  SI.Length C_2_1=PI*d_hyd_2_1;
  SI.Length L_1_1=0*d_hyd_1_1;
  SI.Length L_2_1=0*d_hyd_1_1;
  SI.Length L_trans_1[n]={0.5*abs(d_hyd_2_1 - d_hyd_1_1)/max(MIN, tan(alpha_1[i])) for i in
          1:n};
  SI.ReynoldsNumber Re_1=input_Re*999 + 1;
  SI.MassFlowRate input_mdot_1[n]=ones(n)*Re_1*eta*A_2_1/d_hyd_2_1;

  SI.Pressure DP_1[n];
  Real DP_plot_1[n]={DP_1[i] for i in 1:n};
  SI.Velocity velocity_1[n]={input_mdot_1[i]/(rho*A_2_1) for i in 1:n};
  Real zeta_loc_1[n]={2*abs(DP_plot_1[i])/(max(rho*(velocity_1[i])^2, IN_con_1[
      1].velocity_small)) for i in 1:n};

  //target 2: zeta_tot = f(Re) for different alpha at constant AR
  SI.Diameter d_hyd_1_2=40e-3;
  Real AR_2=50/100;
  SI.Diameter d_hyd_2_2=d_hyd_1_2*AR_2^0.5;
  SI.Area A_1_2=PI*(d_hyd_1_2)^2/4;
  SI.Area A_2_2=AR_1*A_1_2;
  SI.Length C_1_2=PI*d_hyd_1_2;
  SI.Length C_2_2=PI*d_hyd_2_2;
  SI.Length L_1_2=0*d_hyd_1_2;
  SI.Length L_2_2=0*d_hyd_2_2;
  SI.Length L_trans_2[n]={0.5*abs(d_hyd_2_2 - d_hyd_1_2)/max(MIN, tan(alpha[i])) for i in
          1:n};
  SI.ReynoldsNumber Re_2=input_Re*(1e7 - 1) + 1;
  SI.MassFlowRate input_mdot_2[n]=ones(n)*Re_2*eta*A_2_2/d_hyd_2_2;
  SI.Pressure DP_2[n];
  Real DP_plot_2[n]={DP_2[i] for i in 1:n};
  SI.Velocity velocity_2[n]={input_mdot_2[i]/(rho*A_2_2) for i in 1:n};
  Real zeta_tot_2[n]={2*abs(DP_plot_2[i])/(max(rho*(velocity_2[i])^2, IN_con_2[
      1].velocity_small)) for i in 1:n};

  //target 3: zeta_tot = f(alpha) for different Re at constant AR
  SI.ReynoldsNumber Re_3[5]={1e5,2e5,6e5,1e6,1e7};
  parameter Integer m=size(Re_3, 1);
  SI.Diameter d_hyd_1_3=40e-3;
  Real AR_3=50/100;
  SI.Diameter d_hyd_2_3=d_hyd_1_3*AR_3^0.5;
  SI.Angle alpha_3=(input_Re*80 + 1)*PI/180;
  SI.Angle alpha_3_plot=alpha_3*180/PI;
  SI.Area A_1_3=PI*(d_hyd_1_3)^2/4;
  SI.Area A_2_3=AR_3*A_1_3;
  SI.Length C_1_3=PI*d_hyd_1_3;
  SI.Length C_2_3=PI*d_hyd_2_3;
  SI.Length L_1_3=0*d_hyd_1_3;
  SI.Length L_2_3=0*d_hyd_1_3;
  SI.Length L_trans_3=0.5*abs(d_hyd_2_3 - d_hyd_1_3)/max(MIN, tan(alpha_3));
  Real L_trans_3ToR_3=L_trans_3/(d_hyd_1_3/2);

  SI.MassFlowRate input_mdot_3[m]={Re_3[i]*eta*A_2_3/d_hyd_2_3 for i in 1:m};
  SI.Pressure DP_3[m];
  Real DP_plot_3[m]={DP_3[i] for i in 1:m};
  SI.Velocity velocity_3[m]={input_mdot_3[i]/(rho*A_2_3) for i in 1:m};
  Real zeta_tot_3[m]={2*abs(DP_plot_3[i])/(max(rho*(velocity_3[i])^2, IN_con_3[
      1].velocity_small)) for i in 1:m};

  //target 4: dp_tot = f(m_flow) for different alpha at constant AR
  SI.Diameter d_hyd_1_4=4e-1;
  Real AR_4=64/100;
  SI.Diameter d_hyd_2_4=d_hyd_1_4*AR_4^0.5;
  SI.Area A_1_4=PI*(d_hyd_1_4)^2/4;
  SI.Area A_2_4=AR_4*A_1_4;
  SI.Length C_1_4=PI*d_hyd_1_4;
  SI.Length C_2_4=PI*d_hyd_2_4;
  SI.Length L_1_4=1*d_hyd_1_4;
  SI.Length L_2_4=1*d_hyd_1_4;
  SI.Length L_trans_4[n]={0.5*abs(d_hyd_2_4 - d_hyd_1_4)/max(MIN, tan(alpha[i])) for i in
          1:n};
  SI.ReynoldsNumber Re_4=input_Re*(1e4 - 1) + 1;
  SI.MassFlowRate input_mdot_4[n]=ones(n)*Re_4*eta*A_2_4/d_hyd_2_4;
  SI.Pressure DP_4[n];
  Real DP_plot_4[n]={DP_4[i] for i in 1:n};
  SI.Velocity velocity_4[n]={input_mdot_4[i]/(rho*A_2_4) for i in 1:n};
  Real zeta_tot_4[n]={2*abs(DP_plot_4[i])/(max(rho*(velocity_4[i])^2, IN_con_4[
      1].velocity_small)) for i in 1:n};

  //record
  //target 1: zeta_loc_lam = f(Re_lam) for different alpha at constant AR
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_con IN_con_1[n](
    each L_1=L_1_1,
    each A_1=A_1_1,
    each C_1=C_1_1,
    each A_2=A_2_1,
    each C_2=C_2_1,
    L_trans=L_trans_1,
    each L_2=L_2_1,
    each K=0) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_var IN_var_1[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  //target 2: zeta_tot = f(Re) for different alpha at constant AR
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_con IN_con_2[n](
    each L_1=L_1_2,
    each A_1=A_1_2,
    each C_1=C_1_2,
    each A_2=A_2_2,
    each C_2=C_2_2,
    L_trans=L_trans_2,
    each K=0,
    each L_2=L_2_2)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_var IN_var_2[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  //target 3: zeta_tot = f(alpha) for different Re at constant AR
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_var IN_var_3[m](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_con IN_con_3[m](
    each L_1=L_1_3,
    each A_1=A_1_3,
    each C_1=C_1_3,
    each A_2=A_2_3,
    each C_2=C_2_3,
    each L_trans=L_trans_3,
    each L_2=L_2_3,
    each K=0) annotation (Placement(transformation(extent={{0,20},{20,40}})));

  //target 4: dp_tot = f(m_flow) for different alpha at constant AR
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_con IN_con_4[n](
    each A_1=A_1_4,
    each A_2=A_2_4,
    each C_1=C_1_4,
    each C_2=C_2_4,
    each L_1=L_1_4,
    L_trans=L_trans_4,
    each K=0,
    each L_2=L_2_4)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_IN_var IN_var_4[n](each
      eta=eta, each rho=rho)
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Modelica.Blocks.Sources.Ramp input_mflow(
    startTime=0,
    duration=1,
    height=1e7) annotation ( Placement(
        transformation(extent={{60,-80},{80,-60}})));

  Modelica.Blocks.Sources.Ramp input_Re_0(
    offset=0,
    startTime=0,
    duration=1) annotation (Placement(
        transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.Sine input_Re_1(
    offset=0,
    startTime=0,
    freqHz=1) annotation (Placement(transformation(
          extent={{-66,-80},{-46,-60}})));
  Modelica.Blocks.Sources.Exponentials input_Re_2(
    offset=0,
    startTime=0,
    riseTime=1e-2,
    riseTimeConst=1e-2,
    outMax=1) annotation (Placement(transformation(
          extent={{-30,-80},{-10,-60}})));
equation
  //target 1: zeta_loc_lam = f(Re_lam) for different alpha at constant AR
  DP_1 = {FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_DP(
    IN_con_1[i],
    IN_var_1[i],
    input_mdot_1[i]) for i in 1:n};

  //target 2: zeta_tot = f(Re) for different alpha at constant AR
  DP_2 = {FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_DP(
    IN_con_2[i],
    IN_var_2[i],
    input_mdot_2[i]) for i in 1:n};

  //target 3: zeta_tot = f(alpha) for different Re at constant AR
  DP_3 = {FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_DP(
    IN_con_3[i],
    IN_var_3[i],
    input_mdot_3[i]) for i in 1:m};

  //target 4: dp_tot = f(m_flow) for different alpha at constant AR
  DP_4 = {FluidDissipation.PressureLoss.Nozzle.dp_conicalOverall_DP(
    IN_con_4[i],
    IN_var_4[i],
    input_mdot_4[i]) for i in 1:n};

  annotation (__Dymola_Commands(file=
          "modelica://FluidDissipation/Extras/Scripts/pressureLoss/nozzle/dp_conicalOverall_DPMFLOW.mos" "Verification of dp_conicalOverall_DP"),
                                                 Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-101,51},{99,76}},
          lineColor={0,0,255},
          textString=
              "Total pressure loss of CONICAL Nozzle for OVERALL flow regime"),
        Text(
          extent={{-98,4},{-18,30}},
          lineColor={0,0,255},
          textString=
              "zeta_loc_lam = f(Re_lam) for different alpha at constant AR "),
        Text(
          extent={{-77,-35},{-4,-14}},
          lineColor={0,0,255},
          textString="zeta_tot = f(Re) for different alpha at constant AR "),
        Text(
          extent={{-17,3},{56,24}},
          lineColor={0,0,255},
          textString="zeta_tot = f(alpha) for different Re at constant AR"),
        Text(
          extent={{21,-35},{94,-14}},
          lineColor={0,0,255},
          textString="dp_tot= f(m_flow) for different alpha at constant AR"),
                                                        Text(
          extent={{-100,-54},{100,-29}},
          lineColor={0,0,255},
          textString=
            "here: unintended input variables for creation of nonlinear equations (proof analytical Jacobians)")}));
end dp_conicalOverall_DPMFLOW;
