within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger;
package RoundTubeBundle "FluidDissipation: Heat Exchanger with tube bundles"
  extends FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT;

  redeclare function extends coefficientOfHeatTransfer

    //Input record for heat exchanger
    input FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTubeBundle.HeatTransferHeatExchanger_con
      IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    input FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTubeBundle.HeatTransferHeatExchanger_var
      IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  algorithm
  kc := FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_KC(IN_con,
    IN_var);

  end coefficientOfHeatTransfer;

  model RoundTubeBundleHeatTransferModel "Round tube bundle heat exchanger: Application heat transfer model for staggered or inline tube bundle function in Modelica.Fluid"
    extends FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT.BaseHeatExchangerModelWallState;

    parameter Modelica.SIunits.Area A_front(min=1e-6)=1 "Cross sectional area in front of the tube row or bundle"
  annotation (Dialog(group="HeatExchanger"));
    parameter Modelica.SIunits.Length d(min=1e-6) = 0.02 "Outer diameter of tubes"
  annotation (Dialog(group="HeatExchanger"));
    parameter Modelica.SIunits.Length s_1(min=2*1e-6) = 0.03 "Distance between tubes (center to center) orthogonal to flow direction"
  annotation (Dialog(group="HeatExchanger"));
    parameter Modelica.SIunits.Length s_2(min=0) = 0.026 "Distance between tubes (center to center) parallel to flow direction"
  annotation (Dialog(group="HeatExchanger"));
    parameter Modelica.SIunits.Length L_pipe(min=1e-6) = 1 "Distance between tubes (center to center) parallel to flow direction"
  annotation (Dialog(group="HeatExchanger"));
    parameter Boolean staggeredAlignment=true "True, if the tubes are aligned staggeredly, false otherwise | don't care for single row"
  annotation (Dialog(group="HeatExchanger"));
    parameter Integer n(min=1) = 1 "Number of pipe rows in flow direction"
  annotation (Dialog(group="HeatExchanger"));
    parameter Integer z(min=1) = 5 "Number of pipes in one row"
  annotation (Dialog(group="HeatExchanger"));

    HeatTransferHeatExchanger_con IN_con(
    A_front = A_front,
    d = d,
    s_1 = s_1,
    s_2 = s_2,
    staggeredAlignment = staggeredAlignment,
    n = n)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    HeatTransferHeatExchanger_var IN_var(
      cp=cp,
      eta=eta,
      lambda=lambda,
      rho = rho,
      cp_w=cp_w,
      eta_w=eta_w,
      lambda_w=lambda_w,
      m_flow=m_flow)
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

    SI.Area A_cross=A_front "Cross-sectional area";
    SI.Area A_kc=2*L_Re*L_pipe*z*n "Heat transfer area for convective heat transfer coefficient (kc)";
    SI.Velocity velocity=abs(m_flow)/max(Modelica.Constants.eps, (IN_var.rho*A_cross)) "Mean velocity in free flow area";
    SI.Length L_Re=0.5*Modelica.Constants.pi*d "Characteristic length of a tube";
    Real a = s_1/d "Longitudinal alignment ratio";
    Real b = s_2/d "Perpendicular alignment ratio";
    Real psi = if b >= 1 or b <= 0 then 1 - Modelica.Constants.pi/4/a
   else
       1 - Modelica.Constants.pi/4/a/b "Void ratio";
    SI.ReynoldsNumber Re_psi=IN_var.rho*velocity*L_Re/psi/IN_var.eta "Reynolds number for the void cross-sectional area";
    SI.NusseltNumber Nu=kc*L_Re/IN_var.lambda "Nusselt number";

  equation
    kc = coefficientOfHeatTransfer(IN_con, IN_var);

    thermalPort.T = T_w;

    //heat transfer rate is negative if outgoing out of system
    thermalPort.Q_flow = kc*A_kc*(T_w - T);

  end RoundTubeBundleHeatTransferModel;

  record HeatTransferHeatExchanger_con "input record for heat exchanger functions"

    extends FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_con;

  end HeatTransferHeatExchanger_con;

  record HeatTransferHeatExchanger_var "input record for heat exchanger functions"

    extends FluidDissipation.HeatTransfer.HeatExchanger.kc_tubeBundle_1ph_IN_var;

  end HeatTransferHeatExchanger_var;
end RoundTubeBundle;
