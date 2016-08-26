within FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger;
package RoundTube "FluidDissipation: Heat Exchanger with round tubes"
  extends FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.BaseHeatExchangerHT;


  redeclare function extends coefficientOfHeatTransfer

    //Input record for heat exchanger
    input FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTube.HeatTransferHeatExchanger_con
    IN_con annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    input FluidDissipation.Examples.Applications.HeatTransfer.BaseClasses.HeatExchanger.RoundTube.HeatTransferHeatExchanger_var
    IN_var annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  algorithm
  kc := FluidDissipation.HeatTransfer.HeatExchanger.kc_roundTube_KC(IN_con,
    IN_var);

  end coefficientOfHeatTransfer;

end RoundTube;
