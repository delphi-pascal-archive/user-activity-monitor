program Utm;

uses
  Forms,
  ustrmon in 'ustrmon.pas' {Form1},
  print_user in 'print_user.pas' {Form2},
  paswds in 'paswds.pas' {Form3},
  user_window in 'user_window.pas' {Form4},
  view_all_users in 'view_all_users.pas' {Form5},
  timer_otkl in 'timer_otkl.pas' {Form6};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
