unit SerialList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, registry;
function GetSerialPortNames: string;
var
  SerialPortList: TStringList;
implementation

function GetSerialPortNames: string;
var
  reg: TRegistry;
  l, v: TStringList;
  n: integer;
begin
  l := TStringList.Create;
  v := TStringList.Create;
  reg := TRegistry.Create;
  try
{$IFNDEF VER100}
    reg.Access := KEY_READ;
{$ENDIF}
    SerialPortList:= TStringList.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM');
    reg.GetValueNames(l);
    for n := 0 to l.Count - 1 do begin
      SerialPortList.Add(reg.ReadString(l[n]));
    end;
    Result := SerialPortList.CommaText;
  finally
    reg.Free;
    l.Free;
    v.Free;
  end;
end;

end.

