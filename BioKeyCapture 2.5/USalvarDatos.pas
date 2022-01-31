unit USalvarDatos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, StdCtrls, Buttons, FileCtrl;

type
  TFormSalvarDatos = class(TForm)
    ImageList2: TImageList;
    ActionList2: TActionList;
    ActionAceptar: TAction;
    ActionCancelar: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    procedure ActionAceptarExecute(Sender: TObject);
    procedure ActionCancelarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSalvarDatos: TFormSalvarDatos;

implementation

uses UBioKeyCapture;

{$R *.dfm}

//-----------------------------------------------------------------------------
// Inicia el formulario.
//-----------------------------------------------------------------------------
procedure TFormSalvarDatos.FormCreate(Sender: TObject);
begin
Color := FormPrincipal.Color;
end;

//-----------------------------------------------------------------------------
// Cierra el formulario sin hacer nada.
//-----------------------------------------------------------------------------
procedure TFormSalvarDatos.ActionCancelarExecute(Sender: TObject);
begin
Close;
end;

//-----------------------------------------------------------------------------
// Copia los datos en el directorio seleccionado colocándolos
// dentro de una carpeta con la fecha y hora de la copia.
//-----------------------------------------------------------------------------
procedure TFormSalvarDatos.ActionAceptarExecute(Sender: TObject);
var Fuente, Destino: String;
    tit, msg: String;
begin
//Busca el directorio de la aplicación.
Fuente := ExtractFilePath(Application.ExeName) + CDatos;

//Realiza la copia de los datos en un directorio contenedor.
Destino := DirectoryListBox1.Directory + CDatos + FormPrincipal.CrearNombre('', Now) + '\';
if CreateDir(Destino) then
   begin
   FormPrincipal.CopiarDirectorio(Fuente, Destino);
   Close;
   end
else
   begin
   tit := 'No se puede realizar la copia...';
   msg := 'Ya existe un directorio con el mismo nombre.';
   MessageBox(0, PChar(msg), PChar(tit), MB_ICONEXCLAMATION);
   end;
end;


end.
