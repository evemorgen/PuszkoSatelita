unit JJChart;

{$mode objfpc}{$H+}

{ Low level chart library v0.1 }
{ Copyright 2017 by Karol Oleszek }

interface

uses
  Classes, SysUtils, Graphics;
const
  DefaultChartWidth = 128;
  DefaultChartHeight = 128;
  DefaultGridQuant = 10;
  DefaultGridColor = clHighlight;
  DefaultLineColor = clRed;
  DefaultBackgroundColor = clBlack;
  DefaultShowLast = 300;
function RelativePoint(Min,Max,AValue: double;ASize:integer): integer;
type

  { TJJChart }

  TJJChart = class
    constructor Create;
    procedure Refresh;
    procedure Resize(AX,AY: integer);
    procedure AddY(AY: double);
    public
      Display: TPortableNetworkGraphic;
      Points: array of double;
      PointsQuant: integer;
      GridColor, BackgroundColor, LineColor: TColor;
      GridQuant: integer;
      ShowLast: integer;
  end;

implementation

function RelativePoint(Min, Max, AValue: double; ASize: integer): integer;
begin
  if Max <> Min then
    Result:=Round(((AValue-Min)/(Max-Min))*ASize)
  else Result:= 0;
end;

{ TJJChart }

constructor TJJChart.Create;
begin
  inherited;
  Display:= TPortableNetworkGraphic.Create;
  Resize(DefaultChartWidth,DefaultChartHeight);
  GridQuant:= DefaultGridQuant;
  GridColor:= DefaultGridColor;
  BackgroundColor:= DefaultBackgroundColor;
  LineColor:= DefaultLineColor;
  ShowLast:= DefaultShowLast;
end;

procedure TJJChart.Refresh;
var X, LastP,FromLastP: integer;
  Min, Max, SumP: double;
begin
  { Creatin scale for chart }
  Min:=4294967296;
  Max:=0;
  for X:=0 to PointsQuant-1 do begin
    if Points[X]<Min then Min:=Points[X];
    if Points[X]>Max then Max:=Points[X];
  end;
  with Display.Canvas do begin
    { Canvas cleaning }
    Brush.Color:= BackgroundColor;
    Clear;
    { Grid drawing }
    with Pen do begin
      Color:= GridColor;
      Style:= psDot;
    end;
    Font.Color:= GridColor;
    for X:= 0 to GridQuant do begin
      { Horizontal }
      Line(0,RelativePoint(0,GridQuant,X,Display.Height),Display.Width,RelativePoint(0,GridQuant,X,Display.Height));
      TextOut(4,RelativePoint(0,GridQuant,X,Display.Height)+1,FloatToStr(Min+(GridQuant-X)*(Max-Min)/GridQuant));
      { Vertical }
      Line(RelativePoint(0,GridQuant,X,Display.Width),0,RelativePoint(0,GridQuant,X,Display.Width),Display.Height);
      TextOut(RelativePoint(0,GridQuant,X,Display.Width),4,FloatToStr(X*PointsQuant/GridQuant));
    end;
    { Line drawing }
    with Pen do begin
      Color:= LineColor;
      Style:= psSolid;
    end;
    MoveTo(0,RelativePoint(Min,Max,Points[0],Display.Height));
    if PointsQuant < Display.Width then begin
      for X:=1 to PointsQuant-1 do begin
        LineTo(RelativePoint(0,PointsQuant,X,Display.Width),RelativePoint(Min,Max,Points[X],Display.Height));
      end;
    end else begin
      LastP:=0;
      FromLastP:=1;
      SumP:=0;
      for X:=0 to PointsQuant-1 do begin
        if RelativePoint(0,PointsQuant,X,Display.Width) = LastP then begin
          SumP:= SumP + Points[X];
          inc(FromLastP);
        end else begin
          inc(LastP);
          if FromLastP <> 0 then
            LineTo(LastP,RelativePoint(Min,Max,Round(SumP/FromLastP),Display.Height));
          SumP:= 0;
          FromLastP:= 1;
        end;
      end;
    end;
  end;
end;

procedure TJJChart.Resize(AX, AY: integer);
begin
  with Display do begin
    Width:= AX;
    Height:= AY;
  end;
end;

procedure TJJChart.AddY(AY: double);
var X: integer;
begin
  if not (PointsQuant > ShowLast-1) then begin
    inc(PointsQuant);
    SetLength(Points,PointsQuant);
    Points[PointsQuant-1]:= AY;
  end else begin
    for X:= 0 to PointsQuant-2 do begin
      Points[X]:= Points[X+1];
    end;
    Points[PointsQuant-1]:=AY;
  end;
end;

end.

