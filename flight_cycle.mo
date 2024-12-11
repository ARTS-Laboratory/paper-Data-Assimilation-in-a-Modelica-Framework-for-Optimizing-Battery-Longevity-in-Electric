model flight_cycle

  Boolean flight(start=true);
  Real current;
  Real startFlight(start=0);
  Real endFlight(start=flightTime);
  Real t(start=0);
  Real SOC1;
  Real SOC2;
  Real now;
  Real V;
  
  parameter Real taxiCurrent;
  parameter Real taxiTime;
  parameter Real risingTime;
  parameter Real maxP;
  parameter Real maxTime;
  parameter Real cruiseP(start=0.75*maxP);
  parameter Real cruiseTime;
  parameter Real fallingTime;
  parameter Real chargeCurrent;
  parameter Real flightTime = 2*taxiTime+risingTime+maxTime+cruiseTime+fallingTime;
  
algorithm
  now := time;
  
  when now<=endFlight then
      flight := true;
  elsewhen now>endFlight then
      flight := false;
  end when;
  
  if flight then
    if now<t+taxiTime+risingTime then
      current := ((maxP/V-taxiCurrent)/risingTime)*(time-t+taxiTime)+taxiCurrent;
    elseif now<t+taxiTime+risingTime+maxTime then
      current := maxP/V;
    elseif now<t+taxiTime+risingTime+maxTime+cruiseTime then
      current := cruiseP/V;
    elseif now<t+taxiTime+risingTime+maxTime+cruiseTime+fallingTime then
     current := -((cruiseP/V-taxiCurrent)/fallingTime)*(time-(t+taxiTime+risingTime+maxTime+cruiseTime))+cruiseP/V;
    else
      current := taxiCurrent;
    end if;
  else
    current := chargeCurrent;
  end if;
  
  when not flight and SOC1>=0.9 and SOC2>=0.9 then
    startFlight := now;
    endFlight := startFlight+flightTime;
    t := now;
    flight:=true;
  end when;

end flight_cycle;