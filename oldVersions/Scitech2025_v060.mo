model IDETC_v060
  CellStackTC_adapted stack1(CycleLife = 37.5,RUL(fixed = true, start = 1), SOCini = 1, cellParameters = cellParams, np = 12, ns = 96)  annotation(
    Placement(transformation(origin = {-118, 404}, extent = {{10, -10}, {-10, 10}})));
  CellStackTC_adapted stack2(CycleLife = 37.5,RUL(fixed = true, start = 1), SOCini = 1, cellParameters = cellParams, np = 12, ns = 96)  annotation(
    Placement(visible = true, transformation(origin = {-118, 356}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalCurrent load1 annotation(
    Placement(visible = true, transformation(origin = {-194, 402}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.Analog.Sources.SignalCurrent load2 annotation(
    Placement(visible = true, transformation(origin = {-194, 354}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  dividingmodel loadsplitter annotation(
    Placement(visible = true, transformation(origin = {-238, 376}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter ElectricalEnergyStorage.CellRecords.StaticResistance.StaticResistanceParameters cellParams(Rs = ElectricalEnergyStorage.CellRecords.Components.Resistance(R0 = 0.013164915387846383),SOCOCV = ElectricalEnergyStorage.CellRecords.Components.SOCOCV(OCVtableOnFile = true, OCVtableName = "18650SOCvOVC", OCVfileName = "/media/nate/External/IDETC_2024/186650Data/SOC%20Pulse%20Test/20C/20C_SOCOCV.csv"), capacity = ElectricalEnergyStorage.CellRecords.Components.ChargeCapacity(C0 = 12600))  annotation(
    Placement(visible = true, transformation(origin = {-112, 378}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-204, 380}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.MultiSensor meter1 annotation(
    Placement(visible = true, transformation(origin = {-160, 404}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.MultiSensor meter2 annotation(
    Placement(visible = true, transformation(origin = {-160, 354}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.TerminateSimulation terminateSimulation(condition = stack2.RUL <= 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-152, 440}, extent = {{-40, -4}, {40, 4}}, rotation = 0)));
  flight_cycle flightCycle(chargeCurrent = -20, cruiseP = 48000, cruiseTime = 2870, fallingTime = 20, maxP = 65000, maxTime = 90, risingTime = 20, taxiCurrent = 0, taxiTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {-238, 342}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor totalVolts annotation(
    Placement(visible = true, transformation(origin = {-80, 380}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  parameter Boolean split = true;
  
algorithm
  flightCycle.SOC1 := loadsplitter.SOC1;
  flightCycle.SOC2 := loadsplitter.SOC2;
  flightCycle.V := totalVolts.v;

equation
  stack1.staticResistance.cellCalculator.SOC = loadsplitter.SOC1;
  stack2.staticResistance.cellCalculator.SOC = loadsplitter.SOC2;
  loadsplitter.Load = flightCycle.current;
  stack1.RUL = loadsplitter.RUL1;
  stack2.RUL = loadsplitter.RUL2;
//  if split then
//    if flightCycle.flight then
//      load1.i = loadsplitter.Bat1Load;
//      load2.i = loadsplitter.Bat2Load;
//    else
//      load1.i = flightCycle.current/2;
//      load2.i = load1.i;
//    end if;
//  else
//    load1.i = flightCycle.current/2;
//    load2.i = load1.i;
//  end if;
  load1.i = if split then loadsplitter.Bat1Load else flightCycle.current/2;
  load2.i = if split then loadsplitter.Bat2Load else load1.i;
  connect(meter1.nc, stack1.pin_pStack) annotation(
    Line(points = {{-150, 404}, {-144, 404}, {-144, 418}, {-118, 418}, {-118, 414}}, color = {0, 0, 255}));
  connect(meter1.pv, stack1.pin_pStack) annotation(
    Line(points = {{-160, 414}, {-160, 418}, {-118, 418}, {-118, 414}}, color = {0, 0, 255}));
  connect(meter1.nv, stack1.pin_nStack) annotation(
    Line(points = {{-160, 394}, {-160, 386}, {-118, 386}, {-118, 394}}, color = {0, 0, 255}));
  connect(meter2.nc, stack2.pin_pStack) annotation(
    Line(points = {{-150, 354}, {-140, 354}, {-140, 365}, {-118, 365}}, color = {0, 0, 255}));
  connect(meter2.pv, stack2.pin_pStack) annotation(
    Line(points = {{-160, 364}, {-160, 370}, {-118, 370}, {-118, 365}}, color = {0, 0, 255}));
  connect(meter2.nv, stack2.pin_nStack) annotation(
    Line(points = {{-160, 344}, {-160, 338}, {-118, 338}, {-118, 347}}, color = {0, 0, 255}));
  connect(load2.n, stack2.pin_nStack) annotation(
    Line(points = {{-194, 344}, {-194, 338}, {-118, 338}, {-118, 347}}, color = {0, 0, 255}));
  connect(load2.p, ground.p) annotation(
    Line(points = {{-194, 364}, {-194, 380}}, color = {0, 0, 255}));
  connect(load1.n, ground.p) annotation(
    Line(points = {{-194, 392}, {-194, 380}}, color = {0, 0, 255}));
  connect(load2.p, meter2.pc) annotation(
    Line(points = {{-194, 364}, {-194, 370}, {-180, 370}, {-180, 354}, {-170, 354}}, color = {0, 0, 255}));
  connect(load1.p, meter1.pc) annotation(
    Line(points = {{-194, 412}, {-194, 418}, {-180, 418}, {-180, 404}, {-170, 404}}, color = {0, 0, 255}));
  connect(stack1.pin_nStack, load1.n) annotation(
    Line(points = {{-118, 394}, {-118, 386}, {-194, 386}, {-194, 392}}, color = {0, 0, 255}));
  connect(totalVolts.p, stack1.pin_pStack) annotation(
    Line(points = {{-80, 390}, {-80, 418}, {-118, 418}, {-118, 414}}, color = {0, 0, 255}));
  connect(totalVolts.n, stack2.pin_nStack) annotation(
    Line(points = {{-80, 370}, {-80, 338}, {-118, 338}, {-118, 347}}, color = {0, 0, 255}));
  annotation(
    uses(ElectricalEnergyStorage(version = "3.2.2"), Modelica(version = "3.2.3"), PowerSystems(version = "1.0.1")),
    Diagram(coordinateSystem(extent = {{-1000, -1000}, {1000, 1000}})),
    Icon(coordinateSystem(extent = {{-1000, -1000}, {1000, 1000}})),
    version = "");
end IDETC_v060;