program BioKeyAnalice;

uses
  Forms,
  UKdEditGetIntervalsDemo in 'UKdEditGetIntervalsDemo.pas' {Form1},
  UProcedencia in 'UProcedencia.pas' {FormProcedencia},
  ULista in 'ULista.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BioKeyAnalice';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
