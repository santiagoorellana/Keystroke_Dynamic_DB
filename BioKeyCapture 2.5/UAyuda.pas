unit UAyuda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, StdCtrls, ComCtrls;

//-----------------------------------------------------------------------------
const CAyuda = 'Ayuda.rtf';

//-----------------------------------------------------------------------------
type
  TFormAyuda = class(TForm)
    ImageList2: TImageList;
    ActionList2: TActionList;
    ActionSalir: TAction;
    RichEdit1: TRichEdit;
    procedure ActionSalirExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAyuda: TFormAyuda;

implementation

uses UBioKeyCapture;

{$R *.dfm}

//-----------------------------------------------------------------------------
// Inicia el formulario.
//-----------------------------------------------------------------------------
procedure TFormAyuda.FormCreate(Sender: TObject);
begin
Color := FormPrincipal.Color;
end;

//-----------------------------------------------------------------------------
// Carga el fichero de ayuda.
//-----------------------------------------------------------------------------
procedure TFormAyuda.FormShow(Sender: TObject);
var DirectorioBase, FileName, tit, msg: String;
begin
//Busca el directorio de la aplicación.
DirectorioBase := ExtractFilePath(Application.ExeName);

//Carga el fichero de ayuda de la aplicación.
FileName := DirectorioBase + '\' + CAyuda;
try
   if FileExists(FileName) then
      RichEdit1.Lines.LoadFromFile(FileName);
except
   RichEdit1.Lines.Add('Error...');
   RichEdit1.Lines.Add('No se puede abrir el fichero de ayuda.');
end;
end;

//-----------------------------------------------------------------------------
// Cierra el formulario de ayuda.
//-----------------------------------------------------------------------------
procedure TFormAyuda.ActionSalirExecute(Sender: TObject);
begin
Close;
end;

//-----------------------------------------------------------------------------
// Actualiza la vista para que no se congele.
//-----------------------------------------------------------------------------
procedure TFormAyuda.FormResize(Sender: TObject);
begin
RichEdit1.Invalidate;
end;


end.
