unit DataUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;
type
  TDataCell= record
    LabelT: string;
    Value: integer;
  end;

  { TDataSource }

  TDataSource= class
    constructor Create;
    procedure ReadData(AData: string);
    function IndexOf(AMark: string):integer;
    public
      Input: string;
      StartMark,EndMark: string;
      ValueStart,ValueEnd: string;
      Data: array of TDataCell;
      DataQuant: integer;
  end;
var
  DataSource: TDataSource;
const
  ConfFilePath = 'data/conf/data_conf_file.txt';
implementation

{ TDataSource }

constructor TDataSource.Create;
var InputList: TStringList;
  X: integer;
begin
  InputList:= TStringList.Create;
  InputList.LoadFromFile(ConfFilePath);
  DataQuant:= InputList.Count;
  SetLength(Data,DataQuant);
  for X:= 0 to DataQuant - 1 do begin
    Data[X].LabelT:=InputList.Strings[X];
  end;
  StartMark:='P';
  EndMark:='K';
  ValueStart:='=';
  ValueEnd:=';';
end;

procedure TDataSource.ReadData(AData: string);
var mark,data_id,x:integer;
  temp_data_s:string;
  end_of_int,end_of_data:boolean;
begin
  Input:=AData;
  end_of_data:= false;
  end_of_int:= false;
  if ((Input[1]=StartMark)) then begin
    mark:=2;
    while not end_of_data do begin
      data_id:= IndexOf(Input[mark]);
      if data_id>-1 then begin
        inc(mark);
        if Input[mark]=ValueStart then begin
          end_of_int:= false;
          temp_data_s:= rightstr(Input,Length(Input)-mark);
          x:=0;
          while not end_of_int do begin
            inc(x);
            if temp_data_s[x]=ValueEnd then begin
              temp_data_s:= leftstr(temp_data_s,x-1);
              Data[data_id].Value:=StrToInt(temp_data_s);
              end_of_int:=true;
            end;
            if x>length(input)+2 then end_of_int:=true;
          end;
        end;
      end;
      if Input[Mark]=EndMark then end_of_data := true;
      inc(mark);
      if mark>length(input)+2 then end_of_data:=true;
    end;
  end else begin
    ShowMessage('Wrong input data format.');
  end;
end;

function TDataSource.IndexOf(AMark: string): integer;
var X:integer;
begin
  Result:= -1;
  for X:= 0 to DataQuant - 1 do begin
    if Data[X].LabelT =AMark then begin
      Result:= X;
    end;
  end;
end;

end.

