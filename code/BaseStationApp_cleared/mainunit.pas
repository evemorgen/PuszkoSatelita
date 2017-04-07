unit MainUnit;

{$mode objfpc}{$H+}

{ JJ CanSat Team Base Station application v0.3 }
{ Copyright 2017 by Karol Oleszek }

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,

  Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, SdpoSerial, SerialList,
  DataUnit, JSONDataUnit, JJChart;
procedure ProccessData;
procedure UpdateCharts;
const
  DefaultChartRange = 50;
  ChartQuantity = 7;

type

  { TMainForm }

  TMainForm = class(TForm)
    ALT_CAN: TLineSeries;
    AltitudePanel: TPanel;
    CenterPanel: TPanel;
    ChartSection: TPanel;
    TEMP_CAN_Chart: TPanel;
    COMReader: TTimer;
    ConnStatus: TShape;
    ConsolePanel: TPanel;
    CurrFrame: TLabel;
    GPS_E: TLineSeries;
    RescanBtn: TMenuItem;
    PRESS_BASE: TLineSeries;
    Y_ROT: TLineSeries;
    Z_ROT: TLineSeries;
    TEMP_BASE: TLineSeries;
    GPSPanel: TPanel;
    HumidityPanel: TPanel;
    LeftPanel: TPanel;
    MainContainer: TPanel;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    ConnMenu: TMenuItem;
    COMBtn: TMenuItem;
    ConnNameBtn: TMenuItem;
    ConnSwitch: TMenuItem;
    ConnInterBtn: TMenuItem;
    ConnStatBtn: TMenuItem;
    PressurePanel: TPanel;
    QuitBtn: TMenuItem;
    RightPanel: TPanel;
    RotationPanel: TPanel;
    SaveBtn: TMenuItem;
    OpenBtn: TMenuItem;
    ChartExportBtn: TMenuItem;
    PacksCounter: TLabel;
    TEMP_CAN: TLineSeries;
    InputConsole: TMemo;
    SerialPort: TSdpoSerial;
    TemperaturePanel: TPanel;
    TopStatusBar: TPanel;
    WIND_SPEED: TLineSeries;
    TemperatureChart: TChart;
    AIR_HUM: TLineSeries;
    PRESS_CAN: TLineSeries;
    ALT_BASE: TLineSeries;
    X_ROT: TLineSeries;
    GPS_N: TLineSeries;
    WindChart: TChart;
    HumidityChart: TChart;
    PressureChart: TChart;
    AltitudeChart: TChart;
    RotationChart: TChart;
    GPSChart: TChart;
    WindPanel: TPanel;
    procedure COMBtnClick(Sender: TObject);
    procedure COMReaderTimer(Sender: TObject);
    procedure ConnBtnClick(Sender: TObject);
    procedure ConnInterBtnClick(Sender: TObject);
    procedure ConnNameBtnClick(Sender: TObject);
    procedure ConnSwitchClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HumidityChartDblClick(Sender: TObject);
    procedure InputConsoleChange(Sender: TObject);
    procedure QuitBtnClick(Sender: TObject);
    procedure COMPortClick(Sender: TObject);
    procedure RescanBtnClick(Sender: TObject);
    procedure TEMP_CAN_ChartResize(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  TimeRun: integer;
  { JSON data }
  JSONData: TJSONInputEngine;
  { Choosed COM port }
  ChoosedDevice: string;
  COMBuffer: string;
  FrameOpened: boolean;
  FrameOpenedAt: integer;
  { Data misc }
  LastFrame: string;
  ReceivedFrames: integer;
  { Chart settings }
  DataRange: array[1..ChartQuantity] of integer;
  { Charts }
  TEMP_CAN_JJChart: TJJChart;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var X: integer;
begin
  for X:=1 to ChartQuantity do begin
    DataRange[X]:= DefaultChartRange;
  end;
  RescanBtn.Click;
  { Object allocation }
  JSONData:= TJSONInputEngine.Create;
  DataSource:= TDataSource.Create;
  { VAR initialization }
  ChoosedDevice:= '';
  COMBuffer:= '';
  FrameOpened:= false;
  FrameOpenedAt:= 0;
  { Chart initialization }
  TEMP_CAN_JJChart:= TJJChart.Create;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  RightPanel.Width:=Round(ChartSection.Width/4);
  LeftPanel.Width:=RightPanel.Width;
  HumidityPanel.Height:=Round(ChartSection.Height/3);
  PressurePanel.Height:=HumidityPanel.Height;
  RotationPanel.Height:=Round(ChartSection.Height/2);
  TemperaturePanel.Height:=RotationPanel.Height;
end;

procedure TMainForm.HumidityChartDblClick(Sender: TObject);
var S:string;
  X: integer;
begin
 if InputQuery('Chart configuration','Set number of displayed frames',S) then begin
   DataRange[1]:= StrToInt(S);
   if ReceivedFrames > DataRange[1] then
     if DataRange[1] <> 0 then begin
       AIR_HUM.Clear;
       for X:= ReceivedFrames-DataRange[1] to ReceivedFrames-1 do begin
         AIR_HUM.AddXY(X+1,JSONData.InData[X].Floats['AIR_HUM'],'Air humidity',clRed);
       end;
     end else begin
       for X:= 0 to ReceivedFrames-1 do begin
         AIR_HUM.AddXY(X+1,JSONData.InData[X].Floats['AIR_HUM'],'Air humidity',clRed);
       end;
     end;
 end;
end;

procedure TMainForm.InputConsoleChange(Sender: TObject);
begin

end;

procedure TMainForm.QuitBtnClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.COMPortClick(Sender: TObject);
begin
  ChoosedDevice:= (Sender as tMenuItem).Caption;
end;

procedure TMainForm.RescanBtnClick(Sender: TObject);
var COMMenuItem: TMenuItem;
  X: integer;
begin
  COMBtn.Clear;
  GetSerialPortNames;
  for X:=0 to SerialPortList.Count-1 do begin
    COMMenuItem := nil;
    COMMenuItem:= TMenuItem.Create(COMBtn);
    with COMMenuItem do begin
      Caption:=SerialPortList.Strings[X];
      Name:=SerialPortList.Strings[X]+'btn';
      OnClick:= @COMPortClick;
    end;
    COMBtn.Add(COMMenuItem);
  end;
end;

procedure TMainForm.TEMP_CAN_ChartResize(Sender: TObject);
begin
  TEMP_CAN_JJChart.Resize(TEMP_CAN_Chart.Width,TEMP_CAN_Chart.Height);
end;

procedure TMainForm.ConnBtnClick(Sender: TObject);
begin

end;

procedure TMainForm.ConnInterBtnClick(Sender: TObject);
var S: string;
begin
  if InputQuery('Port configuration','Enter port reading interval',S) then COMReader.Interval:= StrToInt(S);
end;

procedure TMainForm.ConnNameBtnClick(Sender: TObject);
var S: string;
begin
  if InputQuery('Port configuration','Enter port name',S) then ChoosedDevice:= S;
end;

procedure TMainForm.ConnSwitchClick(Sender: TObject);
begin
  if ChoosedDevice <>'' then begin
    SerialPort.Device:= ChoosedDevice;
    SerialPort.Active:= true;
    COMReader.Enabled:=true;
    with ConnStatus do begin
      Brush.Color:= clGreen;
      Pen.Color:= clGreen;
    end;
    ConnSwitch.Caption:='Disconnect (not yet operable)';
  end else ShowMessage('Choose COM port first!');
end;

procedure TMainForm.FileMenuClick(Sender: TObject);
begin

end;

procedure TMainForm.COMReaderTimer(Sender: TObject);
var S:string;
begin
  S:= SerialPort.ReadData;
  if S<>'' then begin
    InputConsole.Lines.Add(S);
    COMBuffer:= COMBuffer + S;
  end;
  ProccessData;
  PacksCounter.Caption:='Received frames: '+IntToStr(ReceivedFrames);
  CurrFrame.Caption:= LastFrame;
  inc(TimeRun);
end;

procedure TMainForm.COMBtnClick(Sender: TObject);
begin

end;

procedure ProccessData;
var X: integer;
begin
  if not FrameOpened then begin
    if COMBuffer<>'' then
    for X:=1 to Length(COMBuffer) do begin
      if COMBuffer[X] = '{' then begin
        FrameOpened:= true;
        FrameOpenedAt:= X;
      end;
    end;
  end else begin
    for X:=FrameOpenedAt to Length(COMBuffer) do begin
      if COMBuffer <>'' then
        if COMBuffer[X] = '}' then begin
          FrameOpened:= false;
          LastFrame:= '{'+RightStr(LeftStr(COMBuffer,X),Length(COMBuffer)-FrameOpenedAt);
          if JSONData.AddIn(LastFrame) then begin
            inc(ReceivedFrames);
            UpdateCharts;
          end;
          COMBuffer:= RightStr(COMBuffer,Length(COMBuffer)-X);
        end;
    end;
  end;
end;

procedure UpdateCharts;
var X: integer;
begin
  with MainForm do begin
    { Deleting old data points }
    for X:=1 to ChartQuantity do begin
      if DataRange[X] <> 0 then if ReceivedFrames > DataRange[X] then begin
        if TEMP_CAN.Tag = X then TEMP_CAN.Delete(0);
        if TEMP_BASE.Tag = X then TEMP_BASE.Delete(0);
        if PRESS_CAN.Tag = X then PRESS_CAN.Delete(0);
        if WIND_SPEED.Tag = X then WIND_SPEED.Delete(0);
        if PRESS_BASE.Tag = X then PRESS_BASE.Delete(0);
        if X_ROT.Tag = X then X_ROT.Delete(0);
        if Y_ROT.Tag = X then Y_ROT.Delete(0);
        if Z_ROT.Tag = X then Z_ROT.Delete(0);
        if AIR_HUM.Tag = X then AIR_HUM.Delete(0);
        if GPS_N.Tag = X then GPS_N.Delete(0);
        if GPS_E.Tag = X then GPS_E.Delete(0);
        if ALT_BASE.Tag = X then ALT_BASE.Delete(0);
        if ALT_CAN.Tag = X then ALT_CAN.Delete(0);
      end;
    end;
    { Updating all chart data series }
    with TEMP_CAN_JJChart do begin
      AddY(JSONData.InData[ReceivedFrames-1].Floats['TEMP_CAN']);
      Refresh;
      TEMP_CAN_Chart.Canvas.Draw(0,0,Display);
    end;
    TEMP_CAN.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['TEMP_CAN'],'CanSat temperature',clRed);
    TEMP_BASE.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['TEMP_BASE'],'Base station temperature',clYellow);
    WIND_SPEED.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['WIND_SPEED'],'Wind speed',clRed);
    PRESS_CAN.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['PRESS_CAN'],'CanSat pressure',clRed);
    PRESS_BASE.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['PRESS_BASE'],'Base station pressure',clYellow);
    X_ROT.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['X_ROT'],'x rotation',clRed);
    Y_ROT.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['Y_ROT'],'y rotation',clRed);
    Z_ROT.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['Z_ROT'],'z rotation',clYellow);
    AIR_HUM.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['AIR_HUM'],'Air humidity',clRed);
    GPS_N.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['GPS_N'],'GPS n position',clYellow);
    GPS_E.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['GPS_E'],'GPS e position',clRed);
    ALT_BASE.AddXY(ReceivedFrames,JSONData.InData[ReceivedFrames-1].Floats['ALT_BASE'],'Base altitude',clYellow);
    ALT_CAN.AddXY(ReceivedFrames,Random(4),'CanSat altitude',clRed);

  end;
end;

end.

