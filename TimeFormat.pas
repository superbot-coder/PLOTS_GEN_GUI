unit TimeFormat;

interface

Uses SysUtils, Windows;

function GetMilisecondsFormat(Milliseconds: Cardinal): String;

implementation

function GetMilisecondsFormat(Milliseconds: Cardinal): String;
var
 H, M, S, ATime: Cardinal;
begin
 ATime := Milliseconds div 1000;
 H := ATime div 3600;
 M := (ATime - H * 3600) div 60;
 S := ATime - H * 3600 - M * 60;
 Result := Format('%d h %d m %d s', [H, M, S]);
end;

end.