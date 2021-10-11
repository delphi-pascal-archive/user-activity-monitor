unit view_all_users;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm5 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses paswds;

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
var
 i,j: integer;
 a, st: string;
begin
 for i:=0 to Listbox1.Items.Count-1 do
  if Listbox1.Selected[i]
  then
   begin
    a:=Listbox1.Items.Strings[i];
    j:=pos(' - ',a);
    st:=Trim(Copy(a,j+3,20));
    Form3.Edit3.Text:=st;
    Delete(a,j,100);
    Form3.Edit2.Text:=Trim(a);
    try
     Form3.ListBox1.Selected[i]:=true;
    except
    
    end;
    Break;
   end;
 Close;
end;

procedure TForm5.FormShow(Sender: TObject);
Label M;
var
 i,j,k,j1,x,n,s,s1,tt: integer;
 st,a: string;
begin
 Button1.Enabled:=false;
 ListBox1.Items.Assign(Form3.ListBox1.Items);
 Form5.Caption:='Ïğîñìîòğ ïîëüçîâàòåëåé ('+IntToStr(ListBox1.Items.Count)+' ÷åëîâåêà)';
 //
 st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
 for k:=0 to ListBox1.Items.Count-1 do
  begin
   a:=ListBox1.Items.Strings[k];
   j:=6789;
   j1:=j;
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
   ListBox1.Items.Strings[k]:=a;
  end;
 Button1.Enabled:=true;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
 Edit1.Text:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
end;

end.
