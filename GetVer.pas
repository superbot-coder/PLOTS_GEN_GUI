unit GetVer;

interface

uses Windows, SysUtils;

function Get_vertionInfo(FileName: String; FullVer: Boolean): string;

implementation

function Get_vertionInfo(FileName: String; FullVer: Boolean): string;
Var
  buf:Pointer;
  nSize:Integer;
  vi:^vs_fixedfileinfo;
  p:pointer absolute vi;
  l:cardinal;
  l1,l2:cardinal;
  vs1:array [1..2] of word absolute l1;
  vs2:array [1..2] of word absolute l2;
Begin
  try
    nSize:=GetFileVersionInfoSize(PChar(FileName),l);
    GetMem(buf,nSize);
    GetFileVersionInfo(PChar(FileName),l,nSize,Buf);
    VerQueryValue(Buf,'\',p,l);

    l1:=vi.dwFileVersionMS;
    l2:=vi.dwFileVersionLS;
    
    Result:=IntToStr(vs1[2])+'.'+IntToStr(vs1[1]);
    if FullVer then Result:=Result+'.'+IntToStr(vs2[2])+'.'+IntToStr(vs2[1]); 
  Except FreeMem(buf); end;
end;

end.
