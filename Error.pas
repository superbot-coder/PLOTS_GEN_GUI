Unit Error;

interface

Uses Windows;

function SystemErrorMessage(ErrorCode: Integer): string;
function GetSysErrorMessage(ErrorCode: Integer): String;
procedure SaveErrorMessage(DebugMsg: String);

var
  LAST_ERROR_MESSAGE : String;

implementation

procedure SaveErrorMessage(DebugMsg: String);
begin
  if DebugMsg <> '' then
    LAST_ERROR_MESSAGE := DebugMsg+' '+GetSysErrorMessage(GetLastError)
  else LAST_ERROR_MESSAGE := GetSysErrorMessage(GetLastError)
end;

{------------------------- GetSysErrorMessage ---------------------------------}
function GetSysErrorMessage(ErrorCode: Integer): String;
Var s: string;
begin
  Str(ErrorCode:0,S);
  Result:='System Error. Code: '+s+' '+SystemErrorMessage(ErrorCode)+'.';
end;

{------------------------- SystemErrorMessage ---------------------------------}
function SystemErrorMessage(ErrorCode: Integer): string;
var
  Buffer : array[0..255] of Char;
  Len    : Integer;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or
                       FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
                       SizeOf(Buffer), nil);
  while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do Dec(Len);
  SetString(Result, Buffer, Len);
end;

end.