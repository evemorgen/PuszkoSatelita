unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, Menus, SdpoSerial, SerialList,
  DataUnit;
procedure ProccessData;
type

  { TMainForm }

  TMainForm = class(TForm)
    AltitudePanel: TPanel;
    CenterPanel: TPanel;
    ChartSection: TPanel;
    COMIntervalLabel: TLabel;
    COMReader: TTimer;
    ConnStatus: TShape;
    ConsolePanel: TPanel;
    CurrFrame: TLabel;
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
    Temperature: TLineSeries;
    InputConsole: TMemo;
    ReadInterval: TSpinEdit;
    SerialPortsComboBox: TComboBox;
    SerialPort: TSdpoSerial;
    TemperaturePanel: TPanel;
    TopStatusBar: TPanel;
    Wind: TLineSeries;
    TemperatureChart: TChart;
    WindChart: TChart;
    WindPanel: TPanel;
    procedure COMReaderTimer(Sender: TObject);
    procedure ConnBtnClick(Sender: TObject);
    procedure ConnInterBtnClick(Sender: TObject);
    procedure ConnSwitchClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InputConsoleChange(Sender: TObject);
    procedure QuitBtnClick(Sender: TObject);
    procedure ReadIntervalChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  Transmission: boolean;
  TransmissionStart: integer;
  ReceivedData: string;
  ProcessedLine: integer;
  MeasureData: array [1..7] of integer;
  DataPart: integer;
  TimeRun: integer;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  GetSerialPortNames;
  SerialPortsComboBox.Items := SerialPortList;
  ProcessedLine:= 0;
  ReceivedData:='No data to display';
  DataSource:= TDataSource.Create;
  FileMenu.Visible:=true;
end;

procedure TMainForm.InputConsoleChange(Sender: TObject);
begin

end;

procedure TMainForm.QuitBtnClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.ReadIntervalChange(Sender: TObject);
begin
  COMReader.Interval:= ReadInterval.Value;
end;

procedure TMainForm.ConnBtnClick(Sender: TObject);
begin

end;

procedure TMainForm.ConnInterBtnClick(Sender: TObject);
begin

end;

procedure TMainForm.ConnSwitchClick(Sender: TObject);
begin
  SerialPort.Device:= SerialPortsComboBox.Items[SerialPortsComboBox.ItemIndex];
  SerialPort.Active:= true;
  COMReader.Enabled:=true;
  with ConnStatus do begin
    Brush.Color:= clGreen;
    Pen.Color:= clGreen;
  end;
  ConnSwitch.Caption:='Disconnect (not yet operable)';
end;

procedure TMainForm.FileMenuClick(Sender: TObject);
begin

end;

procedure TMainForm.COMReaderTimer(Sender: TObject);
var S:string;
  X: integer;
begin
  S:= SerialPort.ReadData;
  if S<>'' then begin
    InputConsole.Lines.Add(S);
  end;
  ProccessData;
  PacksCounter.Caption:='Received frames: '+IntToStr(DataPart);
  CurrFrame.Caption:= ReceivedData;
  inc(TimeRun);
  Temperature.AddXY(TimeRun,DataSource.Data[DataSource.IndexOf('T')].Value,IntToStr(TimeRun),clRed);
  if Temperature.Count>100 then Temperature.Delete(0);
  Wind.AddXY(TimeRun,DataSource.Data[DataSource.IndexOf('W')].Value,IntToStr(TimeRun),clGreen);
  if Wind.Count>100 then Wind.Delete(0);
end;

procedure ProccessData;
var X: integer;
begin
  with MainForm do begin
    if(InputConsole.Lines.Count > ProcessedLine) then begin
      if not Transmission then begin
        if Length(InputConsole.Lines[ProcessedLine])>0 then
        if InputConsole.Lines[ProcessedLine][1] = 'P' then begin
          DataPart:= DataPart + 1;
          Transmission:= true;
          TransmissionStart:= ProcessedLine;
          ReceivedData:=InputConsole.Lines[ProcessedLine];
          if InputConsole.Lines[ProcessedLine][Length(InputConsole.Lines[ProcessedLine])]= 'K' then begin
            Transmission:= false;
            if DataPart>2 then
              DataSource.ReadData(ReceivedData);
              for X:= 0 to DataSource.DataQuant-1 do begin
                //InputConsole.Lines.Add(DataSource.Data[X].LabelT+': '+IntToStr(DataSource.Data[X].Value));
              end;
          end;
          //ShowMessage('Poczatek transmisji');
        end;
      ProcessedLine:= ProcessedLine + 1;
      end else begin
        ReceivedData:= ReceivedData+InputConsole.Lines[ProcessedLine];
        if Length(InputConsole.Lines[ProcessedLine])>0 then
        if InputConsole.Lines[ProcessedLine][Length(InputConsole.Lines[ProcessedLine])]= 'K' then begin
          Transmission:= false;
          //ShowMessage('Zakończono transmisje');
          if DataPart>15 then
            DataSource.ReadData(ReceivedData);
          for X:= 0 to DataSource.DataQuant-1 do begin
           // InputConsole.Lines.Add(DataSource.Data[X].LabelT+': '+IntToStr(DataSource.Data[X].Value));
          end;
        end;
      ProcessedLine:= ProcessedLine + 1;
      end;
    end;
  if InputConsole.Lines.Count > ProcessedLine then ProccessData;
  end;

end;

end.

