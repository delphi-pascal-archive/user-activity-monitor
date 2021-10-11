unit paswds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TForm3 = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ListBox2: TListBox;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  numus: integer;

implementation

uses ustrmon, view_all_users;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
 Edit1.Text:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
 // íåîáû÷íûé øğèôò
 ListBox1.Font.Name:='Wingdings';
end;

procedure TForm3.FormShow(Sender: TObject);
Label M;
var
 i,j,k,j1,x,n,s,s1,tt: integer;
 st,a: string;
begin
 Button2.Enabled:=false;
 //
 Edit2.Text:='';
 Edit3.Text:=''; 
 ListBox1.Items.LoadFromFile(ExtractFilePath(Application.ExeName)+'userp.utm');
 ListBox2.Items.Assign(ListBox1.Items);
 Form3.Caption:='Èçìåíåíèå ïàğîëåé (ïîëüçîâàòåëåé âñåãî: '+IntToStr(ListBox1.Items.Count)+')';
 //
 if Form1.Edit3.Text='Admin'
 then
  begin
   Button3.Enabled:=true;
   Button4.Enabled:=true;
   N1.Enabled:=true;
  end
 else
  begin
   Button3.Enabled:=false;
   Button4.Enabled:=false;
   N1.Enabled:=false;
  end;
 //
 st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
 for k:=0 to ListBox2.Items.Count-1 do
  begin
   a:=ListBox2.Items.Strings[k];
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
   ListBox2.Items.Strings[k]:=a;
  end;
end;

procedure TForm3.ListBox1Click(Sender: TObject);
Label M;
Label M1;
var
 i,j,j1,x,n,s,s1,tt: integer;
 st,a: string;
begin
 Edit2.Text:='';
 Edit3.Text:='';
 //
 if Form1.Edit3.Text='Admin'
 then
  begin
   Edit2.Enabled:=true;
   for i:=0 to Listbox1.Items.Count-1 do
    if Listbox1.Selected[i]
    then
     begin
      a:=Listbox1.Items.Strings[i];
      Break;
     end;
   //
   j:=6789;
   j1:=j;
   st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
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
   i:=pos(' - ',a);
   Delete(a,i,100);
   Edit2.Text:=Trim(a);
   Edit3.Text:='Ïàğîëü...';
  end
 else // åñëè ïîëüçîâàòåëü íå Admin
  begin
   Edit2.Enabled:=false;
   for i:=0 to ListBox2.Items.Count-1 do
    begin
     if pos(Form1.Edit3.Text,ListBox2.Items.Strings[i])<>0
     then
      begin
       numus:=i;
       ListBox1.Selected[i]:=true;
       a:=Listbox2.Items.Strings[i];
       j:=pos(' - ',a);
       st:=Trim(Copy(a,j+3,20));
       Edit3.Text:=st;
       Delete(a,j,100);
       Edit2.Text:=Trim(a);
       Break;
      end;
    end;
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
Label M;
var
 i,x,j,j1,n,s,s1,tt: integer;
 st,a: string;
begin
 j:=6789;
 j1:=j;
 st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
 if (Edit2.Text='') or (Edit3.Text='')
 then
  begin
   ShowMessage('Ïîëÿ íå çàïîëíåíû!');
   Exit;
  end;
 a:=Edit2.Text+' - '+Edit3.Text;
 x:=length(a);
 for i:=1 to x do
  begin
   if pos(a[i],Edit1.Text)<>0
   then
    begin
     Edit1.SelStart:=pos(a[i],Edit1.Text)-1;
     n:=Edit1.SelStart;
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
 for i:=0 to Listbox1.Items.Count-1 do
 if Listbox1.Selected[i]
 then ListBox1.Items.Strings[i]:=Trim(a);
end;

procedure TForm3.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   if (Edit2.Text<>'') and (Edit3.Text<>'')
   then
    begin
     Button2.Enabled:=true;
     Key:=#0;
     Button1.Click;
    end;
  end;
end;

procedure TForm3.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   if (Edit2.Text<>'') and (Edit3.Text<>'')
   then
    begin
     Button2.Enabled:=true;
     Key:=#0;
     Button1.Click;
    end;
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
Label M;
var
 i,ii,x,j,j1,n,s,s1,tt: integer;
 st,a: string;
begin
 j:=-1;
 for i:=0 to ListBox1.Items.Count-1 do
  if ListBox1.Selected[i]=true
  then
   begin
    j:=i;
    Break;
   end;
 ListBox1.DeleteSelected;
 if j>=0 then Button2.Enabled:=true;
 //
 if ListBox1.CanFocus
 then ListBox1.SetFocus;
 //
 if ListBox1.Items.Count=0
 then
  begin
   Edit2.Text:='';
   Edit3.Text:='';
  end;
 //
 try
  if (ListBox1.Items.Count>0) and (i<ListBox1.Items.Count)
  then ListBox1.Selected[i]:=true
  else ListBox1.Selected[i-1]:=true;
 except

 end;
 //
 Form3.Caption:='Èçìåíåíèå ïàğîëåé (âñåãî: '+IntToStr(ListBox1.Items.Count)+' ïîëüçîâàòåëåé)';
 ListBox2.Items.Assign(ListBox1.Items);
 //
 for ii:=0 to ListBox1.Items.Count-1 do
  if ListBox1.Selected[ii]=true
  then
   begin
    j:=6789;
    j1:=j;
    st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
    a:=ListBox1.Items.Strings[ii];
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
    i:=pos(' - ',a);
    st:=Trim(Copy(a,i+3,20));
    Edit3.Text:=st;
    Delete(a,i,20);
    Edit2.Text:=Trim(a);
   end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
 Button1.Click;
 ListBox1.Items.SaveToFile(ExtractFilePath(Application.ExeName)+'userp.utm');
 Form1.OnShow(Sender);
end;

procedure TForm3.Button4Click(Sender: TObject);
Label M;
var
 i,x,j,j1,n,s,s1,tt: integer;
 st,a: string;
begin
 j:=6789;
 j1:=j;
 st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
 ListBox1.OnDblClick(Sender);
 if (Edit2.Text='') or (Edit3.Text='')
 then
  begin
   ShowMessage('Ïîëÿ íå çàïîëíåíû!');
   Exit;
  end;
 a:=Edit2.Text+' - '+Edit3.Text+'_New';
 x:=length(a);
 for i:=1 to x do
  begin
   if pos(a[i],Edit1.Text)<>0 then
    begin
     Edit1.SelStart:=pos(a[i],Edit1.Text)-1;
     n:=Edit1.SelStart;
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
 ListBox1.Items.Add(a);
 Form3.Caption:='Èçìåíåíèå ïàğîëåé (âñåãî: '+IntToStr(ListBox1.Items.Count)+' ïîëüçîâàòåëåé)';
 ListBox2.Items.Assign(ListBox1.Items);
 Button2.Enabled:=true;
 //
 for i:=0 to ListBox1.Items.Count-1 do
  begin
   if Listbox1.Selected[i]=true
   then
    begin
     if i<>ListBox1.Items.Count-1
     then ListBox1.Selected[i+1]:=true;
     Exit;
    end;
  end;
end;

procedure TForm3.ListBox1DblClick(Sender: TObject);
Label M;
Label M1;
var
 i,j,j1,x,n,s,s1,tt: integer;
 st,a: string;
begin
 if Form1.Edit3.Text='Admin'
 then
  begin
   Edit2.Enabled:=true;
   for i:=0 to Listbox1.Items.Count-1 do
    if Listbox1.Selected[i]
    then
     begin
      a:=Listbox1.Items.Strings[i];
      Break;
     end;
   //
   j:=6789;
   j1:=j;
   st:='1234567890ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz~ .,:;"-=+\/|!?@#$%^&*_¹<>()[]{}`';
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
   i:=pos(' - ',a);
   st:=Trim(Copy(a,i+3,20));
   Edit3.Text:=st;
   Delete(a,i,100);
   Edit2.Text:=Trim(a);
  end;
end;

procedure TForm3.N1Click(Sender: TObject);
begin
 Form5.ShowModal;
 Form5.Position:=poMainFormCenter;
 Form5.FormStyle:=fsStayOnTop;
end;

end.

