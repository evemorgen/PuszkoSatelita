unit JSONDataUnit;

{$mode objfpc}{$H+}

{ JJ CanSat Team Base Station application v0.3 }
{ Copyright 2017 by Karol Oleszek }

interface

uses
  Classes, SysUtils, fpjson, jsonparser, Dialogs;
const
  BackupInterval = 30;
  BackupFilePath = 'data/backup/';
  BackupErrMess = 'A problem occured during backup creation.';
  JSONErrMess = 'Incorrect JSON frame received';
function CorrectJSONFrame(AFrame: string): boolean;
type

  { TJSONInputEngine }

  TJSONInputEngine= class
    constructor Create;
    function AddIn(A: string): boolean;
    procedure SaveToFile(FileName: string);
    private
      ToNextBackup: integer;
    public
      InData: array of TJSONObject;
      LastBackup: integer;
      FrameCount: integer;
  end;

implementation

function CorrectJSONFrame(AFrame: string): boolean;
var X,QuotQuant: integer;
  Opened,Closed: boolean;
begin
  Opened:= false;
  Closed:= false;
  QuotQuant:= 0;
  for X:= 1 to Length(AFrame) do begin
    if ((AFrame[X] = '{') and (Opened)) then begin
      Result:= false;
      exit;
    end;
    if ((AFrame[X] = '{') and (not Opened)) then Opened:= true;
    if (((AFrame[X] = '}') and (not Closed))and(Opened)) then Closed:= true;
    if AFrame[X] = '"' then inc(QuotQuant);
  end;
  if ((QuotQuant=28)and(Opened and Closed)) then Result:= true else Result:= false;
end;

{ TJSONInputEngine }

constructor TJSONInputEngine.Create;
begin
  FrameCount:=0;
end;

function TJSONInputEngine.AddIn(A: string): boolean;
var TempJData:TJSONData;
  S: string;
begin
  Result:= false;
  if CorrectJSONFrame(A) then begin
    try
      try
        TempJData:=  GetJSON(A);
      finally

      end;
      SetLength(InData, FrameCount+1);
      InData[FrameCount]:= TJSONObject(TempJData);
      inc(FrameCount);
      dec(ToNextBackup);
      if ToNextBackup<0 then begin
         ToNextBackup:= BackupInterval;
         DateTimeToString (S,'ddddd',Time);
         SaveToFile(BackupFilePath+S+'_backup_at_frame_'+IntToStr(FrameCount)+'_data.txt');
      end;
      Result:= true;
    except
      ShowMessage(JSONErrMess);
    end;
  end else ShowMessage(JSONErrMess);
end;

procedure TJSONInputEngine.SaveToFile(FileName: string);
var OutputFile: TStringList;
  X: integer;
begin
  OutputFile:= TStringList.Create;
  try
    try
     for X:=LastBackup to FrameCount-1 do begin
      OutputFile.Add(InData[X].AsJSON);
     end;
     OutputFile.SaveToFile(FileName);
    finally
      LastBackup:= FrameCount;
      OutputFile.Free;
    end;
  except
    ShowMessage(BackupErrMess);
  end;
end;

end.

