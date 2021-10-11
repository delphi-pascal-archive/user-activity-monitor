unit ustrmon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, ExtCtrls, ComCtrls, SyncObjs, getcl,
  ShellAPI, Mask, DDEMan, Registry, Menus;

const
 WM_MYTRAYNOTIFY=WM_USER+123;

type
  // для хука на клавиши
  TStartHook = function(MemoHandle, AppHandle: HWND): Byte;
  TStopHook = function: Boolean;

type
  TForm1 = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Bevel1: TBevel;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Edit1: TEdit;
    Label2: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    SpeedButton3: TSpeedButton;
    Button1: TButton;
    Edit2: TEdit;
    SpeedButton4: TSpeedButton;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Timer5: TTimer;
    Label3: TLabel;
    Timer6: TTimer;
    CheckBox1: TCheckBox;
    MaskEdit1: TMaskEdit;
    Bevel6: TBevel;
    Edit3: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Label4: TLabel;
    Memo2: TMemo;
    Timer4: TTimer;
    Timer7: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SpeedButton5: TSpeedButton;
    Image1: TImage;
    Bevel7: TBevel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    {-------------------------------------}
    procedure CreateTrayIcon(n: integer);
    procedure DeleteTrayIcon(n: integer);
    procedure WMICON(var msg: TMessage); message WM_MYTRAYNOTIFY;    
    procedure HideMainForm;
    procedure RestoreMainForm;
    procedure WMSYSCOMMAND(var msg: TMessage); message WM_SYSCOMMAND;
    procedure Restore1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure MaskEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer7Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MaskEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    hLib2: THandle;
    DllStr: string;
    procedure crypt(cryptstr: string);
    procedure uncrypt(cryptstr: string);    
    procedure KillProgram(ClassName: PChar; WindowTitle: PChar);
    procedure DllMessage(var Msg: TMessage); message WM_USER + 1678;
    procedure WMEndSession(var Msg: TWMEndSession); message WM_ENDSESSION;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  r: TRect;
  pr: PRect;
  t_us, t_adm: integer;
  f: integer=0;
  fle: textfile;
  count: integer;
  key: string='no_nul';
  curpos,curchange: TPoint;
  Str,Str2,Str3: TStringList;
  stop_traf,cancl,dllmes,fl,flog: boolean;
  last_user,cryptstr,cryptstr_res,username,admin,adminpsw,url,url_ex,url_op: string;

implementation

uses print_user, paswds, user_window, timer_otkl;

{$R *.DFM}

// оповещение о завершинии работы Windows
procedure TForm1.WMEndSession(var Msg: TWMEndSession);
begin
 if Msg.EndSession=true
 then
  begin
   Timer1.Enabled:=false;
   SpeedButton1.Click;
   cancl:=true;   
  end;
 inherited;
end;

// cворачивание всех окон кроме своего
function EnumProc(WinHandle: HWnd; Param: LongInt): Boolean; stdcall;
begin
 if (GetParent(WinHandle)=0)
   and (not IsIconic(WinHandle)) // если окно не свернуто
    and (IsWindowVisible(WinHandle)) // если окно видимо
     and (WinHandle<>Form1.Handle) // если это не наша программа
 then
  begin
   // ShowWindow(WinHandle, SW_MINIMIZE); // свернем его
   PostMessage(WinHandle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
   inc(count);
  end;
 EnumProc:=true;
end;

// расшифрование строки
procedure TForm1.uncrypt(cryptstr: string);
Label M;
var
 i,j,j1,x,n,s,s1,tt: integer;
 st,a: string;
begin
 if cryptstr=''
 then Exit;
 //
 j:=6789;
 j1:=j;
 st:='1234567890АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_№<>()[]{}`';
 a:=cryptstr;
 x:=length(a);
 for i:=1 to x do
  begin
   if pos(a[i],Edit2.Text)<>0 then
    begin
     Edit2.SelStart:=pos(a[i],Edit2.Text)-1;
     n:=Edit2.SelStart;
     s1:=n+1;
     j:=j1;
     s:=s1-j;
     if ((s<=159) and (s>=0)) then
      begin
       s:=s1-j;
       a[i]:=st[s];
       goto M;
      end;
     j:=j1-n-1;
     repeat
      tt:=j-159;
      s:=abs(tt);
      j:=s;
     until (s<=159);
     s:=159-s;
     a[i]:=st[s];
     M:
    end
   else
  end;
 cryptstr_res:=a;
end;

// шифрование строки
procedure TForm1.crypt(cryptstr: string);
Label M;
var
 i,x,j,j1,n,s,s1,tt: integer;
 st,a: string;
begin
 if cryptstr=''
 then Exit;
 //
 j:=6789;
 j1:=j;
 st:='1234567890АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_№<>()[]{}`';
 a:=cryptstr;
 x:=length(a);
 for i:=1 to x do
  begin
   if pos(a[i],Edit2.Text)<>0 then
    begin
     Edit2.SelStart:=pos(a[i],Edit2.Text)-1;
     n:=Edit2.SelStart;
     s1:=n+1;
     j:=j1;
     s:=s1+j;
     if (s<=159) then
      begin
       s:=s1+j;
       a[i]:=st[s];
       goto M;
      end;
     s:=159-(n+1);
     j:=j1-s;
     repeat
      tt:=j-159;
      s:=abs(tt);
      j:=s;
     until (s<=159);
     a[i]:=st[s];
     M:
    end
   else
  end;
 cryptstr_res:=a;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 s,sh,a: string;
 i: integer;
 prog: hWnd;
 f: textfile;
 reg: TRegistry;
 hTaskBar: THandle;
 CheckEvent: TEvent;
 Strl: TStringList;
begin
 // автозагрузка
 Reg:=TRegistry.Create;
 Reg.RootKey:=HKEY_LOCAL_MACHINE;
 Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',true);
 if not Reg.ValueExists('Usactmon')
 then Reg.WriteString('Usactmon',Application.ExeName);
 Reg.CloseKey;
 Reg.Free;
 // отключаем Alt-Ctrl-Del и редактирование реестра
 reg:=TRegistry.Create;
 reg.RootKey:=HKEY_CURRENT_USER;
 Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\System', true);
 reg.WriteInteger('DisableTaskMgr', 1); // блокиреум
 reg.WriteInteger('DisableRegistryTools', 1); // блокируем
 reg.CloseKey;
 //
 Form1.Caption:='User Activity Monitor 1.5';
 // загрузка времени отключения компьютера
 AssignFile(f,ExtractFilePath(Application.ExeName)+'utm_time.utm');
 if FileExists(ExtractFilePath(Application.ExeName)+'utm_time.utm')=false
 then
  begin
   Rewrite(f); // создание нового файла
   CloseFile(f);
   MaskEdit1.Text:='17:25';
   Memo2.Clear;
   Memo2.Lines.Add('17:25');
   Memo2.Lines.SaveToFile('utm_time.utm');
  end;
 try
  Memo2.Clear;
  Memo2.Lines.LoadFromFile('utm_time.utm');
  MaskEdit1.Text:=Trim(Memo2.Lines.Strings[0]);
 except
  MaskEdit1.Text:='17:25';
  Memo2.Clear;
  Memo2.Lines.Add('17:25');
  Memo2.Lines.SaveToFile('utm_time.utm');
 end;
 //
 Label4.Caption:=''; // 'Осталось '+''+' секунд';
 // для выключения компьютера по времени
 fl:=true;
 // чтобы при просмотре лога игнорировалось нажатие клавиш
 dllmes:=true;
 // пароль как при входе в Win XP
 Edit1.Font.Name:='Wingdings';
 Edit1.PasswordChar:='l'; // символ "точка"
 //
 cancl:=false; // для выключения компьютера
 SpeedButton1.Enabled:=false;
 SpeedButton2.Enabled:=true;
 SpeedButton3.Enabled:=false;
 SpeedButton4.Enabled:=false;
 Image1.Enabled:=false;
 //
 Edit2.Text:='1234567890АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_№<>()[]{}`';
 // интервал проверки координат мыши (60000 - примерно 1,5 минуты)
 Strl:=TStringList.Create;
 try
  Strl.LoadFromFile(ExtractFilePath(Application.ExeName)+'time_admus.utm');
  s:=Strl.Strings[0];
  uncrypt(s);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,1,i);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,i,100);
  t_adm:=StrToInt(cryptstr_res);
  //
  s:=Strl.Strings[1];
  uncrypt(s);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,1,i);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,i,100);
  t_us:=StrToInt(cryptstr_res);
 except
  t_adm:=5;
  t_us:=2;
  a:='1234567890АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~.,:;"-=+\|!?@#$%^&*_№<>()[]{}`';
  Strl.Clear;
  //
  sh:='';
  for i:=0 to 25 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=sh+'/5/';
  sh:='';
  for i:=0 to 45 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=s+sh;
  crypt(s);
  Str.Add(cryptstr_res); // администратор
  sh:='';
  for i:=0 to 55 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=sh+'/2/';
  sh:='';
  for i:=0 to 15 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=s+sh;
  crypt(s);
  Str.Add(cryptstr_res); // пользователи
  //
  Strl.SaveToFile(ExtractFilePath(Application.ExeName)+'time_admus.utm');
 end;
 Strl.Free;
 Timer1.Interval:=40000*t_us; // 160000 - 6 минут 30 секунд (10000 - 16 секунд)
 // убрать курсор
 Timer2.Enabled:=true;
 //
 CheckEvent:=TEvent.Create(nil, false, true, 'User_Act_Mon_CHECKEXIST');
 if CheckEvent.WaitFor(10)<>wrSignaled
 then Halt;
 //
 DllStr:='';
 last_user:='';
 Form1.FormStyle:=fsStayOnTop;
 //
 Prog:=FindWindow('ProgMan',nil); // Windows Program Manager
 ShowWindow(Prog,SW_HIDE); // Убрать иконки
 hTaskbar:=FindWindow('Shell_TrayWnd', nil); // Убрать Taskbar
 ShowWindow(hTaskBar, SW_HIDE);
 // поставить хук на выключение конопок клавиатуры
 try
  if not SetKeyboardHook
  then ShowMessage('Невозможно поставить Hook!');
 except

 end; 
 // поставить хук на нажатие клавиш
 Button2.Click;
end;

///////////////////////// в системный Tray
procedure TForm1.CreateTrayIcon(n: integer);
var
 nidata: TNotifyIconData; // икона
 s: string;
begin
 with nidata do
  begin
   cbSize:=SizeOf(TNotifyIconData);
   Wnd:=Self.Handle;
   uID:=n;
   uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
   uCallBackMessage:=WM_MYTRAYNOTIFY;
   hIcon:=Application.Icon.Handle;
   s:='User Activity Monitor 1.5';
   StrPCopy(szTip,s+' - '+username); // StrPCopy(@szTip,s+' - '+username);
  end;
 Shell_NotifyIcon(NIM_ADD, @nidata);
end;

procedure TForm1.DeleteTrayIcon(n: integer);
var
 nidata: TNotifyIconData;
begin
 with nidata do
  begin
   cbSize:=SizeOf(TNotifyIconData);
   Wnd:=Self.Handle;
   uID:=n;
  end;
 Shell_NotifyIcon(NIM_DELETE, @nidata);
end;

procedure TForm1.WMICON(var msg: TMessage);
var
 P: TPoint;
begin
 case msg.LParam of
  WM_LBUTTONDOWN:
   begin
    GetCursorPos(p);
    SetForegroundWindow(Application.MainForm.Handle);
    RestoreMainForm; // восстановление
    Sleep(300); // чтобы иконка в трее не исчезала сразу
    DeleteTrayIcon(1);
   end;
  WM_LBUTTONUP:
 end;
end;

procedure TForm1.HideMainForm;
begin
 Application.ShowMainForm:=false; // форму не видно
 ShowWindow(Application.Handle, SW_HIDE);
 ShowWindow(Application.MainForm.Handle, SW_HIDE);
end;

procedure TForm1.RestoreMainForm;
begin
 Application.ShowMainForm:=true; // восстановление формы
 ShowWindow(Application.Handle, SW_RESTORE);
 ShowWindow(Application.MainForm.Handle, SW_RESTORE);
end;

procedure TForm1.WMSYSCOMMAND(var msg: TMessage);
begin
 inherited;
 if (msg.WParam=SC_MINIMIZE) then //  минимизируемся
  begin
   HideMainForm;
   CreateTrayIcon(1);
  end;
end;

procedure TForm1.Restore1Click(Sender: TObject);
begin
 RestoreMainForm; // восстановление
 DeleteTrayIcon(1);
end;

/////////////////////////

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
 prog: hWnd;
 reg: TRegistry;
 hTaskBar: THandle;
begin
 Closefile(fle);
 //
 try
  Form2.Hide;
  Form2.Close;
  //
  Form3.Hide;
  Form3.Close;
  //
  Form1.Activate;
  Form1.BringToFront;
  // с этой строкой хук на нажатие клавиш
  // не работает после "выхода" из программы
  // Form1.Position:=poScreenCenter;
 except
  Form1.Activate;
  Form1.BringToFront;
  // с этой строкой хук на нажатие клавиш
  // не работает после "выхода" их программы
  // Form1.Position:=poScreenCenter;
 end;
 // время ожидания пользователя
 // интервал проверки координат мыши (60000 - примерно 1,5 минуты)
 Timer1.Interval:=40000*t_us; // 160000 - 6 минут 30 секунд (10000 - 16 секунд)
 Timer1.Enabled:=false;
 // убрать курсор
 Timer2.Enabled:=true;
 // поставить хук на выключение конопок клавиатуры
 Timer3.Enabled:=true;
 // отключение закрытия Netscape и Mozilla Firefox
 Timer4.Enabled:=false;
 // отключение ведения лога посещения сайтов
 Timer7.Enabled:=false;
 Str.Free;
 //
 count:=0;
 EnumWindows(@EnumProc, 0);
 //
 cryptstr:='- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -';
 Form2.RichEdit3.Lines.Add(cryptstr);
 crypt(cryptstr);
 Writeln(fle,cryptstr_res);
 cryptstr:='Пользователь: '+last_user+' "ВЫШЕЛ" - '+TimeTostr(Time)+' ('+DateToStr(Date)+')';
 Form2.RichEdit3.Lines.Add(cryptstr);
 crypt(cryptstr);
 Writeln(fle,cryptstr_res);
 CloseFile(fle);
 // минимизировать все приложения
 prog:=FindWindow('ProgMan',nil);
 ShowWindow(Prog,SW_HIDE); // Убрать иконки
 hTaskbar:=FindWindow('Shell_TrayWnd', nil); // Убрать Taskbar
 ShowWindow(hTaskBar, SW_HIDE);
 //
 ComboBox1.Enabled:=true;
 Edit1.Enabled:=true;
 SpeedButton1.Enabled:=false;
 SpeedButton2.Enabled:=true;
 Form1.Caption:='User Activity Monitor 1.5';
 Application.Title:=Form1.Caption;
 SpeedButton3.Enabled:=false;
 SpeedButton4.Enabled:=false;
 Image1.Enabled:=false;
 Form2.RichEdit1.ReadOnly:=false;
 //
 if CheckBox1.Checked=false
 then CheckBox1.Checked:=true;
 if ComboBox1.CanFocus
 then ComboBox1.SetFocus;
 // отключаем Alt-Ctrl-Del и редактирование реестра
 reg:=TRegistry.Create;
 reg.RootKey:=HKEY_CURRENT_USER;
 Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\System', true);
 reg.WriteInteger('DisableTaskMgr', 1); // блокируем
 reg.WriteInteger('DisableRegistryTools', 1); // блокируем
 reg.CloseKey;
{
 // окно с пустым именем
 Form4.Label1.Caption:='Пользователь: None';
 Form4.Width:=Form4.Label1.Width+32;
 Form4.Height:=Form4.Label1.Top+26;
 Form4.Bevel1.Width:=Form4.Width-1;
 Form4.Bevel1.Height:=Form4.Height-1;
 Form4.Top:=2;
 Form4.Left:=(Screen.Width div 2)-(Form4.Width div 2);
 Form4.FormStyle:=fsStayOnTop;
 Form4.Show;
} 
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
 prog: hWnd;
 i,j: integer;
 reg: TRegistry;
 hTaskBar: THandle;
 s,userpas: string;
begin
 AssignFile(fle,ExtractFilePath(Application.ExeName)+'utmlog.dat');
 if FileExists(ExtractFilePath(Application.ExeName)+'utmlog.dat')=false
 then Rewrite(fle) // создание нового файла
 else Append(fle); // открытие файла для редактирования
 // для ведения лога посещения сайтов
 Str:=TStringList.Create;
 Str.Add('qlfp56mf83nxgakti6');
 Memo1.Clear;
 username:=ComboBox1.Text;
 Edit3.Text:=ComboBox1.Text; // для Form3
 last_user:=ComboBox1.Text;
 //
 for i:=0 to Str3.Count-1 do
  begin
   s:=Copy(Str3.Strings[i],1,pos(' - ',Str3.Strings[i])-1);
   if (pos(username,Str3.Strings[i])<>0) and
    (Length(username)=Length(s))
   then
    begin
     userpas:=Str3.Strings[i];
     Str3.SaveToFile('r.txt');
     j:=pos(' - ',userpas);
     Delete(userpas,1,j+2);
     j:=666;
     Break;
    end;
   end;
 //
 if j<>666
 then
   begin
    cryptstr:='-->';
    Form2.RichEdit3.Lines.Add(cryptstr);
    crypt(cryptstr);
    Writeln(fle,cryptstr_res);
    //
    cryptstr:='Пользователь: "Неизвестный" (попытка входа)'+' - '+TimeTostr(Time)+' ('+DateToStr(Date)+')';
    Form2.RichEdit3.Lines.Add(cryptstr);
    crypt(cryptstr);
    Writeln(fle,cryptstr_res);
    //
    cryptstr:='<--';
    Form2.RichEdit3.Lines.Add(cryptstr);
    crypt(cryptstr);
    Writeln(fle,cryptstr_res);
    //
    Form1.Caption:='User Activity Monitor 1.5 - "Неизвестный"';
    Application.Title:=Form1.Caption;
    //
    ComboBox1.Text:='';
    if ComboBox1.CanFocus then ComboBox1.SetFocus;
    ComboBox1.Enabled:=true;
    Edit1.Text:='';
    Edit1.Enabled:=true;
    SpeedButton1.Enabled:=false;
    SpeedButton2.Enabled:=true;
    //
    Closefile(fle);
    //
    Exit;
   end;
 //
 if ((ComboBox1.Text=username) and (Edit1.Text=userpas))
 then
  begin
   SpeedButton3.Enabled:=true;
   // отключаем Alt-Ctrl-Del и редактирование реестра
   reg:=TRegistry.Create;
   reg.RootKey:=HKEY_CURRENT_USER;
   Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\System', true);
   reg.WriteInteger('DisableTaskMgr', 1); // блокируем
   reg.WriteInteger('DisableRegistryTools', 1); // блокируем
   reg.CloseKey;
   //
   if (username=admin) and (Edit1.Text=adminpsw)
   then // если вошел Administrator
    begin
     Timer1.Interval:=40000*t_adm;
     SpeedButton4.Enabled:=true;
     Image1.Enabled:=true;     
     // включаем Alt-Ctrl-Del и редактирование реестра
     reg:=TRegistry.Create;
     reg.RootKey:=HKEY_CURRENT_USER;
     Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\System', true);
     reg.WriteInteger('DisableTaskMgr', 0); // разблокируем
     reg.WriteInteger('DisableRegistryTools', 0); // разблокируем
     reg.CloseKey;
    end;
   cryptstr:='- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -';
   Form2.RichEdit3.Lines.Add(cryptstr);
   crypt(cryptstr);
   Writeln(fle,cryptstr_res);
   cryptstr:='Пользователь: '+last_user+' "ВОШЕЛ" - '+TimeTostr(Time)+' ('+DateToStr(Date)+')';
   Form2.RichEdit3.Lines.Add(cryptstr);
   crypt(cryptstr);
   Writeln(fle,cryptstr_res);
   cryptstr:='- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -';
   Form2.RichEdit3.Lines.Add(cryptstr);
   crypt(cryptstr);
   Writeln(fle,cryptstr_res);
   //
   Prog:=FindWindow('ProgMan',nil);
   ShowWindow(Prog,SW_SHOW); // Показать иконки
   hTaskbar:=FindWindow('Shell_TrayWnd', nil); // Показать taskbar
   ShowWindow(hTaskBar, SW_SHOWNORMAL);
   //
   ComboBox1.Text:='';
   ComboBox1.Enabled:=false;
   Edit1.Text:='';
   Edit1.Enabled:=false;
   SpeedButton1.Enabled:=true;
   SpeedButton2.Enabled:=false;
   //
   Form1.Caption:='User Activity Monitor 1.5'+' - '+last_user;
{
   // окно с именем пользователя

   Form4.Label1.Caption:='Пользователь: '+last_user;
   Form4.Width:=Form4.Label1.Width+32;
   Form4.Height:=Form4.Label1.Top+26;
   Form4.Bevel1.Width:=Form4.Width-1;
   Form4.Bevel1.Height:=Form4.Height-1;
   Form4.Top:=2;
   Form4.Left:=(Screen.Width div 2)-(Form4.Width div 2);
   Form4.FormStyle:=fsStayOnTop;
   Form4.Show;
}
   //
   Application.Title:=Form1.Caption;
   // время ожидания пользователя
   Timer1.Enabled:=true;
   // показать курсор
   Timer2.Enabled:=false;
   // снять хук на включение кнопок клавиатуры
   Timer3.Enabled:=false;
   // закрытие Netscape и Mozilla Firefox
   Timer4.Enabled:=true;
   // ведение лога посещения сайтов
   Timer7.Enabled:=true;
   // в системный Tray
   HideMainForm;
   CreateTrayIcon(1);
  end
 else
  begin
   cryptstr:='-->';
   Form2.RichEdit3.Lines.Add(cryptstr);
   crypt(cryptstr);
   Writeln(fle,cryptstr_res);
   //
   cryptstr:='Пользователь: "Неизвестный" (попытка входа)'+' - '+TimeTostr(Time)+' ('+DateToStr(Date)+')';
   Form2.RichEdit3.Lines.Add(cryptstr);
   crypt(cryptstr);
   Writeln(fle,cryptstr_res);
   //
   cryptstr:='<--';
   Form2.RichEdit3.Lines.Add(cryptstr);
   crypt(cryptstr);
   Writeln(fle,cryptstr_res);
   //
   Form1.Caption:='User Activity Monitor 1.5 - "Неизвестный"';
   Application.Title:=Form1.Caption;
   //
   ComboBox1.Text:='';
   if ComboBox1.CanFocus then ComboBox1.SetFocus;
   ComboBox1.Enabled:=true;
   Edit1.Text:='';
   Edit1.Enabled:=true;
   SpeedButton1.Enabled:=false;
   SpeedButton2.Enabled:=true;
   //
   Closefile(fle);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Str2.Free;
 UnRegisterHotkey(Handle,1); // для "Alt-Shift-F9"
 Action:=caFree;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   SpeedButton2.Click;
  end;
end;

procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   Key:=#0;
   SpeedButton2.Click;
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if cancl=true
 then CanClose:=true;
 if cancl=false
 then CanClose:=false; // нельзя закрыть программу
 HideMainForm;
 CreateTrayIcon(1);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 // определение времени недвижимости курсора
 GetCursorPos(curpos);
 if ((curpos.X=curchange.X) and (curpos.Y=curchange.Y))
  and (key='')
 then
  begin
   Timer1.Enabled:=false;
   SpeedButton1.Click;
   RestoreMainForm; // восстановление программы
   DeleteTrayIcon(1);
   Exit;
  end;
 GetCursorPos(curchange);
 key:='';
end;

// создание границ движения курсора
procedure TForm1.Timer2Timer(Sender: TObject);
var
 r1: TRect;
begin
 GetClipCursor(r);
 r1:=Form1.ClientRect;
 r1.TopLeft:=Form1.ClientToScreen(r1.TopLeft);
 r1.BottomRight:=Form1.ClientToScreen(r1.BottomRight);
 ClipCursor(@r1);
 //
 RestoreMainForm;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
 if (f=0) and (Form1.Active=true)
 then
  begin
   // удаление хука на выключение конопок клавиатуры
   // if not RemoveKeyboardHook
   // then Form1.Caption:='НЕВОЗМОЖНО удалить Hook!';
   RemoveKeyboardHook;
   f:=1;
  end;
 if (f=1) and (Form1.Active=false)
 then
  begin
   // поставить хук на выключение конопок клавиатуры
   // if not SetKeyboardHook
   // then Form1.Caption:='НЕВОЗМОЖНО поставить Hook!';
   SetKeyboardHook;
   f:=0;
  end;
end;

//////////////////////////////////////////////////

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
 CloseFile(fle);
 Form2.ShowModal;
end;

procedure TForm1.Timer5Timer(Sender: TObject);
var
 Layout: array [0..KL_NAMELENGTH] of char;
begin
 GetKeyboardLayoutName(Layout);
 if Layout='00000409'
 then Label3.caption:='Язык: EN'
 else Label3.caption:='Язык: RU';
end;

procedure ShutdownComputer;
var
 rl: dWord;
 ph: THandle;
 tp,prevst: TTokenPrivileges;
begin
 OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,ph);
 LookupPrivilegeValue(nil,'SeShutdownPrivilege',tp.Privileges[0].Luid);
 tp.PrivilegeCount:=1;
 tp.Privileges[0].Attributes:=2;
 AdjustTokenPrivileges(ph,FALSE,tp,SizeOf(prevst),prevst,rl);
 ExitWindowsEx(EWX_SHUTDOWN or EWX_POWEROFF,0);
end;

procedure TForm1.Timer6Timer(Sender: TObject);
var
 i: integer;
 sm: string;
begin
 sm:=TimeToStr(Time+EncodeTime(0,0,1,0)*30); // время+пол минуты
 if Length(sm)<8
 then sm:='0'+sm;
 if (CheckBox1.Checked) and (MaskEdit1.Text+':00'=sm)
 then
  begin
   //
   SetForegroundWindow(Application.MainForm.Handle);
   RestoreMainForm; // восстановление
   Sleep(300); // чтобы иконка в трее не исчезала сразу
   DeleteTrayIcon(1);
   //
   ProgressBar1.Position:=0;
   ProgressBar1.Max:=30;
   for i:=1 to 30 do
    begin
     ProgressBar1.StepIt;
     Label4.Caption:='Осталось '+IntToStr(30-i)+' секунд';
     Sleep(1000);
     if fl=false
     then
      begin
       Label4.Caption:='';
       ProgressBar1.Position:=0;
       Break;
      end;
     Application.ProcessMessages;
    end;
   if (ProgressBar1.Position=30) and (CheckBox1.Checked=true)
   then
    begin
     Label4.Caption:='';
     cancl:=true;
     ShutdownComputer;
     Halt;
    end;
  end;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
 Form3.ShowModal;
 Form3.Position:=poMainFormCenter;
 Form3.FormStyle:=fsStayOnTop;
end;

// загрузка списка пользователей
procedure TForm1.FormShow(Sender: TObject);
Label M;
var
 i,j,k,j1,x,n,s,s1,tt: integer;
 st,a: string;
 Str1: TStringList;
begin
 Str1:=TstringList.Create;
 Str2:=TstringList.Create;
 Str3:=TstringList.Create;
 Str1.Clear;
 Str3.Clear;
 try
  Str2.LoadFromFile(ExtractFilePath(Application.ExeName)+'userp.utm');
 except
  cancl:=true;
  Form1.Close;
 end;
 //
 for k:=0 to Str2.Count-1 do
  begin
   a:=Str2.Strings[k];
   //
   j:=6789;
   j1:=j;
   st:='1234567890АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_№<>()[]{}`';
   x:=length(a);
   for i:=1 to x do
    begin
     if pos(a[i],Edit2.Text)<>0 then
      begin
       Edit2.SelStart:=pos(a[i],Edit2.Text)-1;
       n:=Edit2.SelStart;
       s1:=n+1;
       j:=j1;
       s:=s1-j;
       if ((s<=159) and (s>=0)) then
        begin
         s:=s1-j;
         a[i]:=st[s];
         goto M;
        end;
       j:=j1-n-1;
       repeat
        tt:=j-159;
        s:=abs(tt);
        j:=s;
       until (s<=159);
       s:=159-s;
       a[i]:=st[s];
       M:
      end
     else
    end;
   Str1.Add(a);
  end;
 //
 Str3.Assign(Str1);
 Str2.Clear;
 for i:=0 to Str1.Count-1 do
  begin
   st:=Str1.Strings[i];
   j:=pos(' - ',st);
   a:=Trim(Copy(st,j+3,20));
   Str2.Add(a);
   Delete(st,j,20);
   if st='Admin'
   then
    begin
     admin:=Trim(st);
     adminpsw:=a;
    end;
   Str1.Strings[i]:=Trim(st);
  end;
 ComboBox1.Clear;
 for i:=0 to Str1.Count-1 do
  begin
   if (Str1.Strings[i]<>'Admin')
   then ComboBox1.Items.Add(Str1.Strings[i]);
  end;
 Str1.Free;
end;

/////////////////////////////  Отлов нажатия клавиш
procedure TForm1.DllMessage(var Msg: TMessage);
begin
 // чтобы при просмотре лога игнорировалось нажатие клавиш
 if dllmes=true
 then
  begin  // 8 - "Backspace", 13 - "Enter"
   if (Msg.wParam=13) and (DllStr<>'')
   then
    begin
     if Trim(Dllstr)<>''
     then
      begin
       cryptstr:='   Текст: '+Trim(DllStr)+' ('+TimeTostr(Time)+')';
       Form2.RichEdit3.Lines.Add(cryptstr);
       crypt(cryptstr);
       try
        Writeln(fle,cryptstr_res);
       except
        AssignFile(fle,ExtractFilePath(Application.ExeName)+'utmlog.dat');
        if FileExists(ExtractFilePath(Application.ExeName)+'utmlog.dat')=false
        then Rewrite(fle) // создание нового файла
        else Append(fle); // открытие файла для редактирования
        Writeln(fle,cryptstr_res);
        CloseFile(fle);
       end; 
       DllStr:='';
      end
     else
      begin
       DllStr:='';
      end;
    end;
  end;
 //
 if Chr(Msg.wParam)<>''
 then key:=Chr(Msg.wParam);
 DllStr:=DllStr+Chr(Msg.wParam);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 StartHook1: TStartHook;
begin
 hLib2:=LoadLibrary('getcl.dll');
 @StartHook1:=GetProcAddress(hLib2, 'StartHook');
 if @StartHook1=nil
 then Exit;
 StartHook1(Memo1.Handle, Handle);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked=false
 then
  begin
   fl:=false;
   Timer6.Enabled:=false;
   ProgressBar1.Position:=0;
  end
 else
  begin
   Timer6.Enabled:=true;
   fl:=true;
  end;
 Label4.Caption:='';
end;

procedure TForm1.MaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   if MaskEdit1.Text<>''
   then
    begin
     Key:=#0;
     Memo2.Clear;
     Memo2.Lines.Add(MaskEdit1.Text);
     Memo2.Lines.SaveToFile('utm_time.utm');
    end;
  end;
end;

////////////////// уничтожение нежелательных программ

procedure TForm1.KillProgram(ClassName: PChar; WindowTitle: PChar);
const
 PROCESS_TERMINATE = $0001;
var
 ProcessHandle:THandle;
 ProcessID:Integer;
 TheWindow:HWND;
begin
 TheWindow:=FindWindow(Classname, WindowTitle);
 GetWindowThreadProcessID(TheWindow, @ProcessID);
 ProcessHandle:=OpenProcess(PROCESS_TERMINATE, FALSE, ProcessId);
 TerminateProcess(ProcessHandle,4);
end;

procedure TForm1.Timer4Timer(Sender: TObject);
var
 Wnd: hWnd;
 s: string;
 buff: array [0..127] of char;
begin
 // закрытие "Netscape" и "Mozilla Firefox"
 Wnd:=GetWindow(Handle, gw_HWndFirst);
 while Wnd<>0 do
  begin
   if (Wnd<>Application.Handle) and IsWindowVisible(Wnd)
    and (GetWindow(Wnd, gw_Owner)=0) and (GetWindowText(Wnd, buff, sizeof(buff))<>0)
   then
    begin
     GetWindowText(Wnd, buff, sizeof(buff));
     s:=AnsiLowerCase(StrPas(buff));
     if (pos('mozilla firefox',s)<>0) // Mozilla Firefox
      or (pos('netscape',s)<>0) // Netscape
      or (pos('mozilla',s)<>0)
      or (pos('firefox',s)<>0)
     then
      begin
       Killprogram(nil,pchar(StrPas(buff)));
       ShowMessage('Запуск программы "'+StrPas(buff)+'" запрещен!');
      end;
    end;
   Wnd:=GetWindow(Wnd, gw_hWndNext);
  end;
end;

//////////////////////////// ведение лога посещения сайтов

function Get_URL(Servicio: string): string;
var
 Client_DDE: TDDEClientConv;
 temp: PChar;
begin
 Result:='';
 Client_DDE:=TDDEClientConv.Create(nil);
 with Client_DDE do
  begin
   SetLink(Servicio,'WWW_GetWindowInfo');
   temp:=RequestData('0xFFFFFFFF');
   Result:=Trim(StrPas(temp));
   StrDispose(temp); // предотвращаем утечку памяти
   CloseLink;
  end;
 Client_DDE.Free;
end;

procedure TForm1.Timer7Timer(Sender: TObject);
var
 i: integer;
 urlall: string;
begin
 if dllmes=true
 then
  begin
   try
    url_ex:=Get_URL('IExplore'); // Internet Explorer
    url_op:=Get_URL('Opera'); // Opera
    // для Explorer
    for i:=0 to Str.Count-1 do
     begin
      if pos(url_ex,Str.Strings[i])=0
      then flog:=true
      else
       begin
        flog:=false;
        Break;
       end;
     end;
    if (flog=true) and (url_ex<>'')
    then
     begin
      urlall:='        URL Сайта: '+url_ex+' ('+TimeTostr(Time)+')';
      Form2.RichEdit3.Lines.Add(urlall);
      Str.Add(url_ex);
      cryptstr:=urlall;
      crypt(cryptstr);
      Writeln(fle,cryptstr_res);
     end;
    // для Opera
    for i:=0 to Str.Count-1 do
     begin
      if pos(url_op,Str.Strings[i])=0
      then flog:=true
      else
       begin
        flog:=false;
        Break;
       end;
     end;
    if (flog=true) and (url_op<>'')
    then
     begin
      urlall:='        URL Сайта: '+url_op+' ('+TimeTostr(Time)+')';
      Form2.RichEdit3.Lines.Add(urlall);
      Str.Add(url_op);
      cryptstr:=urlall;
      crypt(cryptstr);
      Writeln(fle,cryptstr_res);
     end;
   except

   end;
  end
 else 
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 AssignFile(fle,ExtractFilePath(Application.ExeName)+'utmlog.dat');
 if FileExists(ExtractFilePath(Application.ExeName)+'utmlog.dat')=false
 then Rewrite(fle) // создание нового файла
 else Append(fle); // открытие файла для редактирования
end;

procedure TForm1.MaskEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 MaskEdit1.Hint:='Текущее время: '+TimeToStr(Time);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
 DeleteTrayIcon(1);
 cancl:=true;
 ShutdownComputer;
 Halt; 
end;

procedure TForm1.N1Click(Sender: TObject);
var
 rl: dWord;
 ph: THandle;
 tp,prevst: TTokenPrivileges;
begin
 DeleteTrayIcon(1);
 cancl:=true;
 OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,ph);
 LookupPrivilegeValue(nil,'SeShutdownPrivilege',tp.Privileges[0].Luid);
 tp.PrivilegeCount:=1;
 tp.Privileges[0].Attributes:=2;
 AdjustTokenPrivileges(ph,FALSE,tp,SizeOf(prevst),prevst,rl);
 ExitWindowsEx(EWX_REBOOT or ewx_force,0);
 Halt;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
 ShowMessage('----------------  User Activity Monitor v1.4  ----------------'+#10#13+
             'Программа предназначена для регистрирования'+#10#13+
             'действий пользователей (нажатие клавишь, навигация'+#10#13+
             'в сети Интернет и т.п.), работающих за одним'+#10#13+
             'компьютером.'+#10#13+
             '------------------------------------------------------------------'+#10#13+
             'Вопросы, пожелания и замечания по работе'+#10#13+
             'программы присылайте на адрес:'+#10#13+
             'E-mail: admin_ds@delphisources.ru'+#10#13+
             'Web-site: www.delphisources.ru');
 ShellExecute(0,'open','http://www.delphisources.ru','','',SW_SHOW);
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
 Form6.ShowModal;
end;

end.
