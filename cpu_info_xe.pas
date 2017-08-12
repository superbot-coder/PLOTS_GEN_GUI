unit cpu_info_xe;

interface


USES Winapi.Windows, System.SysUtils, System.Win.Registry, Vcl.Dialogs;

Type
  TCPUInstruction = (cpu_UNKNOWN, cpu_MMX, cpu_SSE, cpu_SSE2, cpu_SSE3, cpu_SSSE3,
                     cpu_SSE_4_1, cpu_SSE_4_2, cpu_AVX, cpu_AVX2, cpu_AVX512, cpu_AES);

Type TRegisterName = (EBX, ECX, EDX);

const
  strCPUFeature : array [TCPUInstruction] of string =
   ('UNKNOWN', 'MMX', 'SSE', 'SSE2', 'SSE3', 'SSSE3', 'SSE4.1', 'SSE4.2',
     'AVX', 'AVX2','AVX512', 'AES');


function GetProcessorNameStr: String;
function DetectCPUFeature(CPUInstruction: TCPUInstruction): Boolean;
function CPUFeature(EAX_Leaf: LongWord; Register_Name: TRegisterName; Bit: ShortInt): boolean;
function IsCPUIDSuported: boolean;
function GetCPUVendor: AnsiString;


implementation

function IsCPUIDSuported: boolean;
begin
  // Result:= false;
  asm
   {$IFDEF CPUX86}
     push edi;
     push eax
     mov eax, edi
     btc edi, 21 //200000h
     xor eax, edi
     shr eax, 21
     mov Result, al
     pop eax
     pop edi
   {$ENDIF}
   {$IFDEF CPUX64}
     push rdi
     push rax
     mov rax, rdi
     btc rdi, 21
     xor rax, rdi
     shr rax, 21
     mov Result, al
     pop rax
     pop rdi
   {$ENDIF}
  end;

end;

function GetCPUVendor: AnsiString;
var _bx, _dx, _cx: LongWord;
begin

  SetLength(Result, 12);
  FillChar(result[1], length(Result), #0);

  asm
  {$IFDEF CPUX86}
    PUSHAD
    xor eax, eax
    mov eax, 0
    CPUID
    mov _bx, ebx
    mov _dx, edx
    mov _cx, ecx
    POPAD
  {$ENDIF}
  {$IFDEF CPUX64}
    push rad
    push rbx
    push rdx
    push rcx
    xor rax, rax
    CPUID
    mov _bx, rax
    mov _dx, rdx
    mov _cx, rcx
    pop rcx
    pop rdx
    pop rbx
    pop rad
  {$ENDIF}
  end;

  move(_bx, Result[1], 4);
  move(_dx, Result[5], 4);
  move(_cx, Result[9], 4);
end;

function CPUFeature(EAX_Leaf: LongWord; Register_Name: TRegisterName; Bit: ShortInt): boolean;
var _Result: Longword;
begin
  //try
  Case Register_Name of
    EDX:
      asm
       {$IFDEF CPUX86}
         pushad
         mov eax, EAX_Leaf // https://en.wikipedia.org/wiki/CPUID
         cpuid
         mov _Result, edx
         popad
       {$ENDIF}
       {$IFDEF CPUX64}
         push rax
         push rbx
         push rcx
         push rdx
         //mov r10, rbx
         mov rax, EAX_Leaf // https://en.wikipedia.org/wiki/CPUID
         cpuid
         mov _Result, rdx
         pop rdx
         pop rcx
         pop rbx
         pop rax
          //mov rbx, r10
       {$ENDIF}
      end;

    ECX:
      asm
       {$IFDEF CPUX86}
         pushad
         mov eax, EAX_Leaf
         cpuid
         mov _Result, ecx
         popad
       {$ENDIF}
       {$IFDEF CPUX64}
         push rax
         push rbx
         push rcx
         push rdx
          //mov r10, rbx
         mov rax, EAX_Leaf // https://en.wikipedia.org/wiki/CPUID
         cpuid
         mov _Result, rcx
         pop rdx
         pop rcx
         pop rbx
         pop rax
         //mov rbx, r10
       {$ENDIF}
      end;

    EBX:
      asm
       {$IFDEF CPUX86}
         pushad
         mov eax, EAX_Leaf
         mov ecx, 0
         cpuid
         mov _Result, ebx
         popad
       {$ENDIF}
       {$IFDEF CPUX64}
         push rax
         push rbx
         push rcx
         push rdx
          //mov r10, rbx
         mov rax, EAX_Leaf
         mov rcx, 0
         cpuid
         mov _Result, rbx
         pop rdx
         pop rcx
         pop rbx
         pop rax
         //mov rbx, r10
       {$ENDIF}
      end;
  End;

  if (_Result and (1 shl bit)) = (1 shl bit) then Result := true
  else Result := false;

end;

function DetectCPUFeature(CPUInstruction: TCPUInstruction): Boolean;
var
  _Result: Longword;
begin
  // https://en.wikipedia.org/wiki/CPUID
  Case CPUInstruction of
    cpu_MMX:     Result := CPUFeature(1, EDX, 23); // MMX instructions EAX=1 EDX=23
    cpu_SSE:     Result := CPUFeature(1, EDX, 25); // SSE instructions EAX=1 EDX=25
    cpu_SSE2:    Result := CPUFeature(1, EDX, 26); // SSE2 instructions EAX=1 EDX=26
    cpu_SSE3:    Result := CPUFeature(1, ECX, 0);  // SSE3 instructions ECX=1 ECX=0
    cpu_SSSE3:   Result := CPUFeature(1, ECX, 9);  // SSSE3 instructions EAX=1 ECX=9
    cpu_SSE_4_1: Result := CPUFeature(1, ECX, 19); // SSE4.1 instructions EAX=1 ECX=19
    cpu_SSE_4_2: Result := CPUFeature(1, ECX, 20); // SSE4.2 instructions EAX=1 ECX=20
    cpu_AVX:     Result := CPUFeature(1, ECX, 28); // AVX instructions EAX=1 EDX=28
    cpu_AVX2:    Result := CPUFeature(7, EBX, 5);  // AVX2 instructions EAX=7 EBX=5
    cpu_AES:     Result := CPUFeature(1, ECX, 25); // AES instructions EAX=1 ECX=25
  End;

end;

function GetProcessorNameStr: String;
var reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('\HARDWARE\DESCRIPTION\System\CentralProcessor\0') then
    begin
      Result := reg.ReadString('ProcessorNameString');
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

end.
