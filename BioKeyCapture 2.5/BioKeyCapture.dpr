program BioKeyCapture;

uses
  Forms,
  UBioKeyCapture in 'UBioKeyCapture.pas' {FormPrincipal},
  UProcedencia in 'UProcedencia.pas' {FormProcedencia},
  UAyuda in 'UAyuda.pas' {FormAyuda},
  USalvarDatos in 'USalvarDatos.pas' {FormSalvarDatos};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BioKeyPassword';
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
