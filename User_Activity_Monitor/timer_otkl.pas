unit timer_otkl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TForm6 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Edit2: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure crypt(cryptstr: string);
    procedure uncrypt(cryptstr: string);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  cryptstr_res: string;

implementation

{$R *.dfm}

// øèôğîâàíèå ñòğîêè
procedure TForm6.crypt(cryptstr: string);
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
 st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
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

// ğàñøèôğîâàíèå ñòğîêè
procedure TForm6.uncrypt(cryptstr: string);
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
 st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
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

procedure TForm6.FormCreate(Sender: TObject);
begin
 Edit2.Text:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
end;

procedure TForm6.FormShow(Sender: TObject);
var
 i: integer;
 s,sh,a: string;
 str: TStringList;
begin
 a:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~.,:;"-=+\|!?@#$%^&*_¹<>()[]{}`';
 Str:=TStringList.Create;
 try
  Str.LoadFromFile(ExtractFilePath(Application.ExeName)+'time_admus.utm');
  s:=Str.Strings[0];
  uncrypt(s);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,1,i);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,i,100);
  SpinEdit1.Value:=StrToInt(cryptstr_res);
  s:=Str.Strings[1];
  uncrypt(s);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,1,i);
  i:=pos('/',cryptstr_res);
  Delete(cryptstr_res,i,100);  
  SpinEdit2.Value:=StrToInt(cryptstr_res);
 except
  SpinEdit1.Value:=5;
  SpinEdit2.Value:=2;
  Str.Clear;
  sh:='';
  for i:=0 to 25 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=sh+'/5/';
  sh:='';
  for i:=0 to 45 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=s+sh;
  crypt(s);
  Str.Add(cryptstr_res); // àäìèíèñòğàòîğ
  sh:='';
  for i:=0 to 55 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=sh+'/2/';
  sh:='';
  for i:=0 to 15 do
   sh:=sh+a[Random(Length(a)-1)+1];
  s:=s+sh;
  crypt(s);
  Str.Add(cryptstr_res); // ïîëüçîâàòåëè
  Str.SaveToFile(ExtractFilePath(Application.ExeName)+'time_admus.utm');
 end;
 Str.Free;
end;

procedure TForm6.Button1Click(Sender: TObject);
var
 i: integer;
 s,sh,a: string;
 str: TStringList;
begin
 a:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~.,:;"-=+\|!?@#$%^&*_¹<>()[]{}`';
 Str:=TStringList.Create;
 Str.Clear;
 //
 sh:='';
 for i:=0 to 25 do
  sh:=sh+a[Random(Length(a)-1)+1];
 s:=sh+'/'+IntToStr(SpinEdit1.Value)+'/';
 sh:='';
 for i:=0 to 45 do
  sh:=sh+a[Random(Length(a)-1)+1];
 s:=s+sh;
 crypt(s);
 Str.Add(cryptstr_res);
 //
 sh:='';
 for i:=0 to 55 do
  sh:=sh+a[Random(Length(a)-1)+1];
 s:=sh+'/'+IntToStr(SpinEdit2.Value)+'/';
 sh:='';
 for i:=0 to 15 do
  sh:=sh+a[Random(Length(a)-1)+1];
 s:=s+sh;
 crypt(s);
 Str.Add(cryptstr_res);
 try
  Str.SaveToFile(ExtractFilePath(Application.ExeName)+'time_admus.utm');
 finally
  Str.Free;
 end;
 Close;
end;

initialization
 randomize;

end.
