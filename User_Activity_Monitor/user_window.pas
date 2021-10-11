unit user_window;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm4 = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormCreate(Sender: TObject);
begin
 Bevel1.Align:=alClient;
 Bevel1.Align:=alNone;
 Form4.FormStyle:=fsStayOnTop;
 Form4.BorderStyle:=bsNone;
 Form4.BorderIcons:=[];
end;

procedure TForm4.FormShow(Sender: TObject);
begin
 Form4.FormStyle:=fsStayOnTop;
end;

end.
