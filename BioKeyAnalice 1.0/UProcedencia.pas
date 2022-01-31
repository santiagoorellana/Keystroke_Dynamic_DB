unit UProcedencia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, jpeg, ExtCtrls, ImgList, Buttons;

type
  TFormProcedencia = class(TForm)
    Label1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    ActionList2: TActionList;
    ActionSalir: TAction;
    ImageList2: TImageList;
    Timer1: TTimer;
    procedure ActionSalirExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  FormProcedencia: TFormProcedencia;

implementation

uses UKdEditGetIntervalsDemo;

{$R *.dfm}

//-----------------------------------------------------------------------------
// Inicia el formulario.
//-----------------------------------------------------------------------------
procedure TFormProcedencia.FormCreate(Sender: TObject);
begin
Color := Form1.Color;
end;

//-----------------------------------------------------------------------------
// Cierra la ventana.
//-----------------------------------------------------------------------------
procedure TFormProcedencia.ActionSalirExecute(Sender: TObject);
begin
Close;
end;


end.
