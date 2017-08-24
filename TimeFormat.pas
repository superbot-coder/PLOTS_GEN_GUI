unit TimeFormat;

////////////////////////////////////////////////////////
///    Autor: SUPERBOT  (21.08.2017)
///    Https://GitHub.com/Superbot-coder
////////////////////////////////////////////////////////

interface

Uses SysUtils, Windows;

Type TimeShow = (TS_MINUTE, TS_HOUR, TS_DAY);
Type TimeSpliter = (TS_Alfa, TS_Colon); //00d_00s_00m_00s 00:00:00:00

function GetMilisecondsFormat(Milliseconds: Cardinal; TimeShow: TimeShow; Splitter: TimeSpliter): String;

implementation

function GetMilisecondsFormat(Milliseconds: Cardinal; TimeShow: TimeShow; Splitter: TimeSpliter): String;
var
 D, H, M, S, ATime: Cardinal;
 mask: String;
begin

  ATime := Milliseconds div 1000;
  case TimeShow of

    TS_MINUTE:
      begin
        case Splitter of
          TS_Alfa  : mask := '%.2dm %.2ds';
          TS_Colon : mask := '%.2d:%.2d';
        end;
        M := (ATime div 60);
        S := (ATime - (M * 60));
        Result := Format(mask, [M, S]);
      end;

    TS_HOUR:
      begin
        case Splitter of
          TS_Alfa  : mask := '%.2dh %.2dm %.2ds';
          TS_Colon : mask := '%.2d:%.2d:%.2d';
        end;
        H := ATime div 3600;
        M := (ATime - H * 3600) div 60;
        S := ATime - H * 3600 - M * 60;
        Result := Format(mask, [H, M, S]);
      end;

    TS_DAY:
      begin
        case Splitter of
          TS_Alfa  : mask := '%.2dd %.2dh %.2dm %.2ds';
          TS_Colon : mask := '%.2d:%.2d:%.2d:%.2d';
        end;
        D := ATime div 86400;
        H := (ATime - D*86400) div 3600;
        M := (ATime - D*86400 - H*3600) div 60;
        S := ATime - D*86400 - H*3600 - M*60;
        Result := Format(mask, [D, H, M, S]);
      end;
  end;

end;

end.