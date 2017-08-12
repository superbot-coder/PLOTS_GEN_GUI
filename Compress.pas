unit Compress;

//////////////////////////////////////////////////////////////////////////////
///  Module EXTRACT COMPRESION RESOURCE
///        Autor by SUPERBOT
///  Https://GitHub.com/Superbot-coder
//////////////////////////////////////////////////////////////////////////////


interface

Uses Classes, Windows, dialogs , SysUtils, ZLib;

Type TResType = MakeIntResource;

type TArrayBuffer = array of Byte;
     PArrayBuffer = ^TArrayBuffer;

Function CompressFile(InpFile: String; OutFile: String; N: Integer): boolean;
Function DecompressFile(InpFile: String; OutFile: String): boolean;

function CompressBufferToBuffer(InBuffer: Pointer; szInBuffer: integer; OutBuffer: Pointer; var OutBytes: Integer; Level: Shortint): Boolean;
function DecompressBufferToBuffer(InBuffer: Pointer; szInBuffer: Integer; var OutBuffer; var OutBytes: Integer): Boolean;

function FindResName(ResName: String; ResType: TResType): Boolean;
function FindResId(ResId: DWORD; ResType: TResType): Boolean;
Function DecompressResNameToFile(ResName: String; ResType: PChar; OutFile: String): Boolean;
Function DecompressResIdToFile(ResId: Integer; ResType: PChar; OutFile: String): Boolean;
function DecompressResNameToBuffer(ResName: String; ResType: TResType; var PBuffer; var OutBytes: Integer): Boolean;
function DecompressResIdToBuffer(ResId: WORD; ResType: TResType; var PBuffer; var OutBytes: Integer): Boolean;
function CompressFileToBuffer(FileName: String; CompressLevel: ShortInt; Var OutBuff: TArrayBuffer): integer;

Var
  ENABLED_RAISE_ERROR : Boolean = false;


implementation

procedure RaiseMessage;
begin
  if ENABLED_RAISE_ERROR then RaiseLastOSError;
end;

{----------------------------- FindResId --------------------------------------}
function FindResId(ResId: DWORD; ResType: TResType): Boolean;
var hResInfo: THandle;
begin
  Result:=false;
  hResInfo := FindResource(HInstance,PChar(ResId),ResType);
  if hResInfo = 0 then begin
    result := false;
    if ENABLED_RAISE_ERROR then RaiseLastOSError;
    exit;
  end;
  result := true;
end;
{---------------------------- FindResName -------------------------------------}
function FindResName(ResName: String; ResType: TResType): Boolean;
var hResInfo: THandle;
begin
  Result:=false;
  hResInfo := FindResource(HInstance,PChar(ResName),ResType);
  if hResInfo = 0 then begin
    Result:=false;
    if ENABLED_RAISE_ERROR then RaiseLastOSError;
  end;
  result:=true;
end;

{-------------------------------- CompressFile --------------------------------}
Function CompressFile(InpFile: String; OutFile: String; N: Integer): boolean;
Var
  Buffer      : Array[0..1023] of char;
  ByteRaed    : Integer;
  InFileStrm  : TFileStream;
  OutFileStrm : TFileStream;
  CompStrm    : TCompressionStream;
Begin
  try
    InFileStrm  := TFileStream.Create(InpFile, fmOpenRead);
    OutFileStrm := TFileStream.Create(OutFile, fmCreate);
    if N > 3 then N:=3;
    if N < 0 then N:=0;
    CompStrm := TCompressionStream.Create(TCompressionLevel(N),OutFileStrm);
    repeat
      ByteRaed := InFileStrm.Read(Buffer, SizeOf(Buffer));
      CompStrm.Write(Buffer, ByteRaed);
    until ByteRaed < 1024;
    Result:=True;
  finally
    CompStrm.Free;
    InFileStrm.Free;
    OutFileStrm.Free;
  end;
end;
{------------------------------ DecompressFile --------------------------------}
Function DecompressFile(InpFile: String; OutFile: String): boolean;
Var 
  Buffer      : Array[0..1023] of char;
  ByteRaed    : Integer;
  InFileStrm  : TFileStream;
  OutFileStrm : TFileStream;
  DecompStrm  : TDecompressionStream;
Begin
  try
    try
      InFileStrm  := TFileStream.Create(InpFile, fmOpenRead);
      OutFileStrm := TFileStream.Create(OutFile, fmCreate);
      DecompStrm  := TDecompressionStream.Create(InFileStrm);
      repeat
        ByteRaed := DecompStrm.Read(Buffer, SizeOf(Buffer));
        OutFileStrm.Write(Buffer, ByteRaed);
      until ByteRaed < 1024;
      Result:=True;
    except
      if ENABLED_RAISE_ERROR then RaiseLastOSError;
    end;
  finally
    DecompStrm.Free;
    InFileStrm.Free;
    OutFileStrm.Free;
  end;
end;

{---------------------------- CompressBufferToBuffer --------------------------}
function CompressBufferToBuffer(InBuffer: Pointer; szInBuffer: integer; OutBuffer: Pointer; var OutBytes: Integer; Level: Shortint): Boolean;
var
  Buffer: array [1..1024] of byte;
  //InMemStrm    : TMemoryStream;
  OutMemStrm   : TMemoryStream;
  CompressStrm : TCompressionStream;
  ByteRaed     : Integer;
begin
  Result := false;
  if (Not Assigned(InBuffer)) or (szInBuffer = 0) then Exit;
  try
    if Level > 3 then Level := 3;
    if Level < 0 then Level := 0;
    // InMemStrm    := TMemoryStream.Create;
    OutMemStrm   := TMemoryStream.Create;
    CompressStrm := TCompressionStream.Create(TCompressionLevel(Level), OutMemStrm);

    ShowMessage(PChar(InBuffer)^);
    CompressStrm.Write(PChar(InBuffer), szInBuffer);


    if OutMemStrm.Size = 0 then
     begin
     //  ShowMessage('Exit: CompressStrm.Size = 0');
       Exit;
     end;

    OutMemStrm.Position := 0;
    OutMemStrm.ReadBuffer(OutBuffer^, OutMemStrm.Size);
    //Move(OutMemStrm.Memory^, PChar(Result)^, OutMemStrm.Size);

    Result := true;

  finally
    CompressStrm.Free;
    //InMemStrm.Free;
    OutMemStrm.Free;
  end;
end;
{--------------------------- DecompressBufferToBuffer -------------------------}
function DecompressBufferToBuffer(InBuffer: Pointer; szInBuffer: Integer; Var OutBuffer; var OutBytes: Integer): Boolean;
var
  Buffer: array [1..1024] of byte;
  InMemStrm      : TMemoryStream;
  OutMemStrm     : TMemoryStream;
  DecompressStrm : TDecompressionStream;
  ByteRaed       : Integer;
begin
  Result := False;
  if (Not Assigned(InBuffer)) or (szInBuffer = 0) then Exit;
  try
    InMemStrm      := TMemoryStream.Create;
    OutMemStrm     := TMemoryStream.Create;
    DecompressStrm := TDecompressionStream.Create(InMemStrm);

    InMemStrm.Write(InBuffer^, szInBuffer);
    if InMemStrm.Size = 0 then Exit;
    InMemStrm.Position := 0;

    repeat
      ByteRaed := DecompressStrm.Read(Buffer,1024);
      OutMemStrm.Write(buffer,ByteRaed);
    until ByteRaed < 1024;

    if OutMemStrm.Size = 0 then Exit;
    OutBytes := OutMemStrm.Size;
    ReallocMem(Pointer(OutBuffer), OutBytes);
    OutMemStrm.Position := 0;
    OutMemStrm.Read(POinter(OutBuffer)^,OutBytes);

    Result := true;

  finally
    DecompressStrm.Free;
    InMemStrm.Free;
    OutMemStrm.Free;
  end;
end;

{---------------------------- DecompressResNameToFile -------------------------}
Function DecompressResNameToFile(ResName: String; ResType: PChar; OutFile: String): Boolean;
Var
  Buffer     : Array [1..1024] of byte;
  ByteRaed   : Integer;
  ResStrm    : TResourceStream;
  FileStrm   : TFileStream;
  DecompStrm : TDecompressionStream;
Begin
  result := False;
  if Not FindResName(ResName,ResType) then exit;
  Try
    try
    ResStrm    := TResourceStream.Create(HInstance, ResName, ResType);
    FileStrm   := TFileStream.Create(OutFile, fmCreate);
    DecompStrm := TDecompressionStream.Create(ResStrm);
    repeat
      ByteRaed:=DecompStrm.Read(Buffer,1024);
      FileStrm.Write(Buffer,ByteRaed);
    until ByteRaed < 1024;
    Result:=true;
    except
      If ENABLED_RAISE_ERROR then RaiseLastOSError;
    end;
  finally
    DecompStrm.Free;
    ResStrm.Free;
    FileStrm.Free;
  end;
end;

{--------------------------- DecompressResIdToFile ----------------------------}
Function DecompressResIdToFile(ResId: Integer; ResType: PChar; OutFile: String): Boolean;
Var
  Buffer: Array[1..1024] of char;
  ByteRaed: Integer;
  ResStrm    : TResourceStream;
  FileStrm   : TFileStream;
  DecompStrm : TDecompressionStream;
begin
  result := False;
  if Not FindResId(ResId,ResType) then Exit;
  Try
    Try
      ResStrm  := TResourceStream.CreateFromID(HInstance,ResId,ResType);
      FileStrm := TFileStream.Create(OutFile, fmCreate);
      DecompStrm := TDecompressionStream.Create(ResStrm);
      repeat
        ByteRaed := DecompStrm.Read(Buffer, 1024);
        FileStrm.Write(Buffer,ByteRaed);
      until ByteRaed < 1024;
      Result:=True;
    Except
      If ENABLED_RAISE_ERROR then exit;
    End;
  finally
    DecompStrm.Free;
    ResStrm.Free;
    FileStrm.Free;
  end;
end;

{---------------------------- decompressResNameToBuffer -----------------------}
function decompressResNameToBuffer(ResName: String; ResType: TResType; var PBuffer; var OutBytes: Integer): Boolean;
Var
  ByteRead   : Integer;
  Buffer     : array[1..1024] of byte;
  MemStrm    : TMemoryStream;
  ResStrm    : TResourceStream;
  DecompStrm : TDecompressionStream;
begin
  Result := false;
  if Not FindResName(ResName,ResType) then exit;
  try
    try
      ResStrm    := TResourceStream.Create(HInstance,ResName,ResType);
      MemStrm    := TMemoryStream.Create;
      DecompStrm := TDecompressionStream.Create(ResStrm);
      Repeat
        ByteRead := DecompStrm.Read(Buffer, 1024);
        MemStrm.Write(Buffer, ByteRead);
      Until ByteRead < 1024;
      if MemStrm.Size = 0 then Exit;
      OutBytes := MemStrm.Size;
      ReallocMem(Pointer(PBuffer), MemStrm.Size);
      MemStrm.Position:=0;
      MemStrm.Read(Pointer(PBuffer)^,MemStrm.Size);
      result := true;
    except
      if ENABLED_RAISE_ERROR then RaiseLastOSError;
    end;
  finally
    DecompStrm.Free;
    ResStrm.Free;
    MemStrm.Free;
  end;
end;

{---------------------------- decompressResIdToBuffer -------------------------}
function DecompressResIdToBuffer(ResId: WORD; ResType: TResType; var PBuffer; var OutBytes: Integer): Boolean;
Var
  ByteRead   : Integer;
  Buffer     : array[1..1024] of byte;
  MemStrm    : TMemoryStream;
  ResStrm    : TResourceStream;
  DecompStrm : TDecompressionStream;
begin
  Result := false;
  if Not FindResId(ResId,ResType) then exit;
  try
    try
      ResStrm    := TResourceStream.CreateFromID(HInstance,ResId,ResType);
      MemStrm    := TMemoryStream.Create;
      DecompStrm := TDecompressionStream.Create(ResStrm);
      Repeat
        ByteRead := DecompStrm.Read(Buffer, 1024);
        MemStrm.Write(Buffer, ByteRead);
      Until ByteRead < 1024;
      if MemStrm.Size = 0 then Exit;
      OutBytes := MemStrm.Size;
      ReallocMem(Pointer(PBuffer), MemStrm.Size);
      MemStrm.Read(Pointer(PBuffer)^,MemStrm.Size);
      result:=true;
    except
      if ENABLED_RAISE_ERROR then RaiseLastOSError;
    end;
  finally
    DecompStrm.Free;
    ResStrm.Free;
    MemStrm.Free;
  end;
end;


function CompressFileToBuffer(FileName: String; CompressLevel: ShortInt; Var OutBuff: TArrayBuffer): integer;
Var
  InFileStrm  : TFileStream;
  OutMemStrm  : TMemoryStream;
  CompStrm    : TCompressionStream;
Begin
  if CompressLevel > 3 then CompressLevel := 3;
  if CompressLevel < 0 then CompressLevel := 0;

  InFileStrm  := TFileStream.Create(FileName, fmOpenRead);
  OutMemStrm  := TMemoryStream.Create;
  CompStrm    := TCompressionStream.Create(TCompressionLevel(CompressLevel), OutMemStrm);

  try
    CompStrm.CopyFrom(InFileStrm, InFileStrm.Size);
  finally
    CompStrm.Free;
    InFileStrm.Free;
  end;

  try
    OutMemStrm.Position := 0;
    Result := OutMemStrm.Size;
    if OutMemStrm.Size = 0 then Exit;
    SetLength(OutBuff, OutMemStrm.Size);
    move(OutMemStrm.Memory^, PArrayBuffer(OutBuff)^, OutMemStrm.Size);
  finally
    OutMemStrm.Free;
  end;
end;

end.
