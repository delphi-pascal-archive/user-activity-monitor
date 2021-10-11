unit print_user;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Printers, ExtCtrls;

type
  TForm2 = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Button5: TButton;
    RichEdit2: TRichEdit;
    Button6: TButton;
    FindDialog1: TFindDialog;
    RichEdit3: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  stop: boolean;

implementation

uses ustrmon, RichEdit;

{$R *.DFM}

const
 csCryptFirst = 20;
 csCryptSecond = 230;
 csCryptHeader = '';

procedure TForm2.FormCreate(Sender: TObject);
begin
 RichEdit3.Lines.Add('[     User Activity Monitor 1.3 - ����� �� ��������� ������     ]');
 RichEdit3.Lines.Add(' ');
 //
 RichEdit1.HideSelection:=false; // ��� ������
 Edit1.Text:='1234567890����������������������������������������������������������������ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_�<>()[]{}`';
 Button4.Enabled:=false; 
end; 

// ���� ���� �� ����������, �� ������ ������� �����
// ������� ������ -1
function GetFileSize(FileName: String): Integer;
var
 FS: TFileStream;
begin
 try
  FS:=TFileStream.Create(Filename, fmOpenRead);
 except
  Result:=-1;
 end;
 if Result<>-1
 then Result:=FS.Size;
 FS.Free;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
 fle: textfile;
begin
 if MessageDlg('�� ������������� ������ �������� ���-����?', mtConfirmation,
    [mbYes, mbNo],0)=mrYes
 then
  begin
   AssignFile(fle,ExtractFilePath(Application.ExeName)+'utmlog.dat');
   Rewrite(fle); // �������� ������ �����
   CloseFile(fle);
   RichEdit1.Clear;
   Form2.Caption:='��������/������ �������������';
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
Label M;
const
 OneKB=1000;
 OneMB=OneKB*1000;
 OneGB=OneMB*1000;
var
 st,a,errorstr: string;
 i,j,j1,x,n,s,s1,tt,k,rec,ie: integer;
begin
 ie:=0; // ��� ��������� �� ������ ������������� ������
 errorstr:='������ � ��������: ';
 //
 Form2.Caption:='��������/������ �������������';
 if FileExists(ExtractFilePath(Application.ExeName)+'utmlog.dat')=false
 then Exit;
 //
 Button1.Enabled:=false;
 Button2.Enabled:=false;
 Button3.Enabled:=false;
 Button4.Enabled:=true;
 Button5.Enabled:=false;
 Button6.Enabled:=false;
 stop:=false;
 //
 Memo1.Clear;
 Memo1.Lines.BeginUpdate;
 Memo1.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'utmlog.dat');
 //
 RichEdit1.Clear;
 RichEdit1.Lines.BeginUpdate;
 //
 rec:=Memo1.Lines.Count-1;
 //
 ProgressBar1.Position:=0;
 if rec<0 then rec:=0;
 ProgressBar1.Max:=rec;
 //
 for k:=0 to rec do
  begin
   a:=Memo1.Lines.Strings[k];
   j:=6789;
   j1:=j;
   st:='1234567890����������������������������������������������������������������ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_�<>()[]{}`';
   x:=length(a);
   for i:=1 to x do
    begin
     if pos(a[i],Edit1.Text)<>0 then
      begin
       Edit1.SelStart:=pos(a[i],Edit1.Text)-1;
       n:=Edit1.SelStart;
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
   if Trim(a)<>''
   then
    begin
     try
      RichEdit1.Lines.Add(a);
     except
      inc(ie);
      RichEdit1.Lines.Add('   ->->->->->->->->->->->->   [ ---- ������ ������������� ������ N: '+IntToStr(k)+' ---- ]   <-<-<-<-<-<-<-<-<-<-<-<-');
      if ie=1
      then ShowMessage('������ ������������� ������. ������ �� ������������!'+#10#13+'������ ��� � ����� ������...');
      errorstr:=errorstr+IntTostr(k)+', ';
     end;
     ProgressBar1.Position:=k+1;
    end;
   Application.ProcessMessages;
   //
   if stop=true
   then
    begin
     RichEdit1.Lines.EndUpdate;
     Memo1.Lines.EndUpdate;
     Exit;
    end;
   if ProgressBar1.Max=0
   then Form2.Caption:='��������/������ ������������� (���������: 100%)'
   else Form2.Caption:='��������/������ ������������� (���������: '+
    IntToStr(Round(ProgressBar1.Position/ProgressBar1.Max*100))+'%)';
  end;
 Form2.Caption:='��������/������ ������������� (���������: 100%)';
 ProgressBar1.Position:=rec;
 Sleep(100);
 ProgressBar1.Position:=0;
 RichEdit1.Lines.EndUpdate;
 Memo1.Lines.EndUpdate;
 // ��������� ������ ���������������� �����
 if errorstr<>'������ � ��������: '
 then
  begin
   Delete(errorstr,Length(errorstr)-1,2);
   RichEdit1.Lines.Add('-----------------------------------------------------------------------------------------');
   RichEdit1.Lines.Add(errorstr+'.');
   RichEdit1.Lines.Add('-----------------------------------------------------------------------------------------');
  end;
 // ������ ������ �����
 i:=GetFileSize(ExtractFilePath(Application.ExeName)+'utmlog.dat');
 //
 if i<OneKB
 then st:=FormatFloat('#,##0 ����',i)
 else
  if i<OneMB
  then st:=FormatFloat('#,##0.000 �����', i/OneKB)
  else
   if i<OneGB
   then st:=FormatFloat('#,##0.000 �����', i/OneMB);
 //
 Form2.Caption:='��������/������ ������������� (����� ����� = '+st+')';
 //
 Button1.Enabled:=true;
 Button2.Enabled:=true;
 Button3.Enabled:=true;
 Button4.Enabled:=false;
 Button5.Enabled:=true;
 Button6.Enabled:=true; 
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
 stop:=true;
 Button1.Enabled:=true;
 Button2.Enabled:=true;
 Button3.Enabled:=true;
 Button4.Enabled:=false;
 Button5.Enabled:=true;
 Button6.Enabled:=true;
 //
 ProgressBar1.Position:=0;
 //
 Form2.Caption:='��������/������ �������������';
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 // ������ ������� �� ������� �����
 Timer1.Enabled:=false;
 // ����� ��� ��������� ���� �������������� ������� ������
 dllmes:=true;
 // ���������� ��������������� ������ �� ���������
 Form1.Timer1.Enabled:=true;
 // �������� ���-����� �� ��������
 Form1.Button1.Click;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 RichEdit1.Lines.Clear;
 RichEdit1.Lines.Assign(RichEdit3.Lines);
 ProgressBar1.Position:=0;
 Form2.Caption:='��������/������ ������������� - ����� �� ��������� ������';
 // ����� ������ �� ������� �� ������� �����
 Timer1.Enabled:=true;
 // ���������� ��������������� ������ �� ���������
 Form1.Timer1.Enabled:=false;
 // ����� ��� ��������� ���� �������������� ������� ������
 dllmes:=false;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
 r.Left:=Form2.Left;
 r.Right:=Form2.Left+Form2.Width;
 r.Top:=Form2.Top;
 r.Bottom:=Form2.Top+Form2.Height;
 pr:=@r;
 ClipCursor(pr);
end;

procedure TForm2.Button1Click(Sender: TObject);
var
 stroka: textfile;
 i: integer;
begin
 i:=RichEdit1.Lines.Count;
 i:=(i div 82);
 ShowMessage('����� ����� ����������� '+IntToStr(i+1)+' �������(�)');
 try
  AssignPrn(stroka); // ����� ��������� ���������� � ���������
  Rewrite(stroka);
  Printer.Canvas.Font:=RichEdit1.Font;
  Writeln(stroka,' ');
  Writeln(stroka,'[     User Activity Monitor 1.3 - Log-file     ]');
  Writeln(stroka,' ');
  Writeln(stroka,' ');
  for i:=0 to RichEdit1.Lines.Count-1 do
   Writeln(stroka,RichEdit1.Lines[i]); // ���������� ������ �����
  System.Close(stroka);
 except
  ShowMessage('������� �� ���������!');
  System.Close(stroka);
 end;
end;

procedure TForm2.Button5Click(Sender: TObject);
var
 stroka: textfile; // ��� ������
 i: integer;
begin
 RichEdit2.Lines.Clear;
 if RichEdit1.SelLength<>0
 then
  begin
   RichEdit2.Lines.Add(' ');
   RichEdit2.Lines.Add('[     User Activity Monitor 1.3 - Log-file     ]');
   RichEdit2.Lines.Add(' ');
   RichEdit2.Lines.Add(' ');
   RichEdit2.Lines.Add(RichEdit1.SelText);
   i:=RichEdit2.Lines.Count;
   i:=(i div 82);
   ShowMessage('����� ����� ����������� '+IntToStr(i+1)+' �������(�)');
   try
    AssignPrn(stroka);
    Rewrite(stroka);
    Printer.Canvas.Font:=RichEdit2.Font;
    for i:=0 to RichEdit2.Lines.Count-1 do
     Writeln(stroka,RichEdit2.Lines[i]);
    System.Close(stroka);
   except
    ShowMessage('������� �� ���������!');
    System.Close(stroka);
   end;
  end
 else MessageDlg('����� �� �������!',mtInformation,[mbOK],0);
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
 RichEdit1.SelStart:=0;
 FindDialog1.Execute;
end;

procedure TForm2.FindDialog1Find(Sender: TObject);
var
 Buff, P, FT: PChar;
 BuffLen: Longint;
begin
 with Sender as TFindDialog do
  begin
   GetMem(FT, Length(FindText)+1);
   StrPCopy(FT, FindText);
   BuffLen:=RichEdit1.GetTextLen+1;
   GetMem(Buff, BuffLen);
   RichEdit1.GetTextBuf(Buff, BuffLen);
   P:=Buff+RichEdit1.SelStart+RichEdit1.SelLength;
   P:=StrPos(P, FT);
   if P=nil
   then ShowMessage('������ "'+FindText+'" �� �������!')
   else
    begin
     RichEdit1.SelStart:=P-Buff;
     RichEdit1.SelLength:=Length(FindText);
    end;
   FreeMem(FT, Length(FindText)+1);
   FreeMem(Buff, BuffLen);
  end;
end;

end.

