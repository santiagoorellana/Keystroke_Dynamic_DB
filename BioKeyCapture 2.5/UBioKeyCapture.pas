unit UBioKeyCapture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ToolWin, ActnList, UKdEditAlphaNumeric,
  Buttons, ImgList, Grids, Menus;

//-----------------------------------------------------------------------------
const CListaDeNombres  = 'Usuarios.txt';          //Nombre del fichero de lista de nombres de usuarios.
const CUltimaCaptura   = 'UltimaCaptura.txt';     //Fecha y hora de la última captura realizada.
const CColorDeFondo    = 'ColorDeFondo.txt';      //Color de fondo de la aplicación.
const CColorDeFuente   = 'ColorDeFuente.txt';     //Color de la fuente.
const CDatos           = 'Datos';                 //Nombre de la carpeta de datos.

//-----------------------------------------------------------------------------
type TDirInfo = record
                Tamano: Int64;
                NumDirectorios: Integer;
                NumArchivos: Integer;
                end;

//-----------------------------------------------------------------------------
type
  TFormPrincipal = class(TForm)
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ActionGuardar: TAction;
    ActionProcedencia: TAction;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    LabelTexto1: TLabel;
    KdEditAlphaNumeric1: TKdEditAlphaNumeric;
    LabelTexto2: TLabel;
    KdEditAlphaNumeric2: TKdEditAlphaNumeric;
    LabelTexto3: TLabel;
    KdEditAlphaNumeric3: TKdEditAlphaNumeric;
    LabelTexto4: TLabel;
    KdEditAlphaNumeric4: TKdEditAlphaNumeric;
    LabelTexto5: TLabel;
    KdEditAlphaNumeric5: TKdEditAlphaNumeric;
    ActionAyuda: TAction;
    BitBtn3: TBitBtn;
    ActionEstado: TAction;
    ActionBorrar: TAction;
    ActionSalvar: TAction;
    ActionCerrar: TAction;
    ActionColorDeFondo: TAction;
    ColorDialogFondo: TColorDialog;
    ColorDialogFuente: TColorDialog;
    ActionColorDeFuente: TAction;
    PopupMenu1: TPopupMenu;
    Colordefondo1: TMenuItem;
    Colordefuente1: TMenuItem;
    ActionColoresOriginales: TAction;
    Coloresoriginales1: TMenuItem;
    procedure ActionGuardarExecute(Sender: TObject);
    procedure ActionProcedenciaExecute(Sender: TObject);
    procedure ActionAyudaExecute(Sender: TObject);
    procedure KdEditAlphaNumericPressEnterKey(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GuardarDatos(NumeroDelTexto: Integer);
    procedure ActionSalvarExecute(Sender: TObject);
    procedure ActionBorrarExecute(Sender: TObject);
    procedure ActionEstadoExecute(Sender: TObject);
    procedure ActionCerrarExecute(Sender: TObject);
    procedure KdEditAlphaNumeric1Back(Sender: TObject);
    procedure KdEditAlphaNumeric2Back(Sender: TObject);
    procedure KdEditAlphaNumeric3Back(Sender: TObject);
    procedure KdEditAlphaNumeric4Back(Sender: TObject);
    procedure KdEditAlphaNumeric5Back(Sender: TObject);
    procedure ActionColorDeFondoExecute(Sender: TObject);
    procedure ActionColorDeFuenteExecute(Sender: TObject);
    procedure ActionColoresOriginalesExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FColorDeFondoOriginal: TColor;
    FColorDeFuenteOriginal: TColor;

    Guardado: Boolean;
    function EntradasValidas: Boolean;
    function CrearNombre(Usuario: String; Anno: Integer; Mes: Integer; Dia: Integer;
                         Hora: Integer; Minuto: Integer; Segundo: Integer): String; overload;
  public
    function BorrarDirectorio(Nombre: String): Boolean;
    function BorrarContenidoDeDirectorio(Nombre: String): Boolean;
    procedure CopiarDirectorio(Origen, Destino: string);
    function CrearNombre(Usuario: String; FechaHora: TDateTime): String; overload;
    function EspacioLibre(const Drive: Char): Int64;
    function InformacionDeDirectorio(Nombre: string ): TDirInfo;
    function FiltrarNumeros(Numero: String): String;
    procedure GuardarColor(valor: TColor; Fichero: String);
    function LeerColor(Fichero: String): TColor;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses UProcedencia, StrUtils, UAyuda, USalvarDatos;

{$R *.dfm}

//-----------------------------------------------------------------------------
// Filtra una cadena dejando solo los números.
//-----------------------------------------------------------------------------
function TFormPrincipal.FiltrarNumeros(Numero: String): String;
var n: Integer;
begin
Result := '';
if Length(Numero) > 0 then
   for n := 1 to Length(Numero) do
       if Numero[n] in ['0'..'9'] then
          Result := Result + Numero[n];
end;

//-----------------------------------------------------------------------------
// Inicia el formulario.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.FormShow(Sender: TObject);
var DirectorioBase: String;
    tit, msg, Dir: String;
begin
Guardado := False;

//Busca el directorio de la aplicación.
DirectorioBase := ExtractFilePath(Application.ExeName);

//Verifica si la carpeta "Datos" existe.
Dir := DirectorioBase  + CDatos;
if not DirectoryExists(Dir) then
   if not CreateDir(Dir) then
      begin
      tit := 'Error...';
      msg := 'No se puede crear el directorio de datos:' + #13;
      msg := msg + DirectorioBase  + CDatos + #13;
      MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
      Close;
      end;

//Verifica si las carpetas de textos existen.
if DirectoryExists(Dir) then
   begin
   Dir := DirectorioBase + CDatos + '\' + LabelTexto1.Caption;
   if not DirectoryExists(Dir) then CreateDir(Dir);

   Dir := DirectorioBase + CDatos + '\' + LabelTexto2.Caption;
   if not DirectoryExists(Dir) then CreateDir(Dir);

   Dir := DirectorioBase + CDatos + '\' + LabelTexto3.Caption;
   if not DirectoryExists(Dir) then CreateDir(Dir);

   Dir := DirectorioBase + CDatos + '\' + LabelTexto4.Caption;
   if not DirectoryExists(Dir) then CreateDir(Dir);

   Dir := DirectorioBase + CDatos + '\' + LabelTexto5.Caption;
   if not DirectoryExists(Dir) then CreateDir(Dir);
   end;

//Lee la lista de nombres.
Dir := DirectorioBase  + CDatos + '\' + CListaDeNombres;
if FileExists(Dir) then ComboBox1.Items.LoadFromFile(Dir);

end;

//-----------------------------------------------------------------------------
// Muestra la procedencia del programa.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionProcedenciaExecute(Sender: TObject);
begin
with TFormProcedencia.Create(Self) do ShowModal;
end;

//-----------------------------------------------------------------------------
// Muestra la ayuda del programa.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionAyudaExecute(Sender: TObject);
begin
with TFormAyuda.Create(Self) do ShowModal;
end;

//-----------------------------------------------------------------------------
// Agrega el nombre de usuario a la lista.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ComboBox1Exit(Sender: TObject);
begin
if (ComboBox1.ItemIndex = -1) and                              //Si no se ha seleccionado un componente,
   (ComboBox1.Text <> '') then                                 //y hay algún texto disponible:
   begin
   if ComboBox1.Items.IndexOfName(ComboBox1.Text) = -1 then    //Si en la lista no existe el texto:
      ComboBox1.Items.Add(ComboBox1.Text);                     //Lo guarda en la lista.
   end;
end;

//-----------------------------------------------------------------------------
// Para salir del ComboBox con Enter como si fuera Tab.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then
   begin
   Key := #0;
   Perform(WM_NEXTDLGCTL, 0, 0);
   end
end;

//-----------------------------------------------------------------------------
// Para pasar entre los KdEditAlphaNumeric con Enter como si fuera Tab.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.KdEditAlphaNumericPressEnterKey(Sender: TObject);
begin
Perform(WM_NEXTDLGCTL, 0, 0);
end;

//-----------------------------------------------------------------------------
// Verifica si el texto de entrada introducido por el usuario es correcto.
//-----------------------------------------------------------------------------
function TFormPrincipal.EntradasValidas: Boolean;
var Incompleto: Boolean;
    tit, msg: String;
begin
Result := False;
if (KdEditAlphaNumeric1.Text <> '') and
   (KdEditAlphaNumeric2.Text <> '') and
   (KdEditAlphaNumeric3.Text <> '') and
   (KdEditAlphaNumeric4.Text <> '') and
   (KdEditAlphaNumeric5.Text <> '') then
   begin
   Incompleto := False;
   if (KdEditAlphaNumeric1.Text <> LabelTexto1.Caption) then
      begin
      KdEditAlphaNumeric1.Reset;
      Incompleto := True;
      end;
   if (KdEditAlphaNumeric2.Text <> LabelTexto2.Caption) then
      begin
      KdEditAlphaNumeric2.Reset;
      Incompleto := True;
      end;
   if (KdEditAlphaNumeric3.Text <> LabelTexto3.Caption) then
      begin
      KdEditAlphaNumeric3.Reset;
      Incompleto := True;
      end;
   if (KdEditAlphaNumeric4.Text <> LabelTexto4.Caption) then
      begin
      KdEditAlphaNumeric4.Reset;
      Incompleto := True;
      end;
   if (KdEditAlphaNumeric5.Text <> LabelTexto5.Caption) then
      begin
      KdEditAlphaNumeric5.Reset;
      Incompleto := True;
      end;
   if Incompleto then
      begin
      tit := 'Se encontraron errores en los textos';
      msg := 'Por favor, introduzca correctamente los textos que se le piden.';
      MessageBox(0, PChar(msg), PChar(tit), MB_ICONEXCLAMATION);
      end
   else
      Result := True;
   end
else
   begin
   tit := 'Faltan textos por introducir';
   msg := 'Por favor, introduzca todos los textos que se le piden.';
   MessageBox(0, PChar(msg), PChar(tit), MB_ICONEXCLAMATION);
   end;
end;

//-----------------------------------------------------------------------------
// Crea un nombre de fichero con el formato de nombres GA a
// partir de los datos parámetros pasados.
//-----------------------------------------------------------------------------
function TFormPrincipal.CrearNombre(Usuario: String;
                                    Anno: Integer;
                                    Mes: Integer;
                                    Dia: Integer;
                                    Hora: Integer;
                                    Minuto: Integer;
                                    Segundo: Integer
                                    ): String;
var R: String;
begin
R := AnsiReplaceStr(Usuario, Chr($20), '');  //Nombre de usuario sin espacios.
R := R + '_' + IntToStr(Anno);               //Establece el año.
R := R + '_' + IntToStr(Mes);                //El més.
R := R + '_' + IntToStr(Dia);                //El día.
R := R + '_' + IntToStr(Hora);               //La hora.
R := R + '_' + IntToStr(Minuto);             //Los minutos.
R := R + '_' + IntToStr(Segundo);            //los segundos y...
Result := R;
end;

//-----------------------------------------------------------------------------
function TFormPrincipal.CrearNombre(Usuario: String; FechaHora: TDateTime): String;
var DT: TSystemTime;
begin
DateTimeToSystemTime(FechaHora, DT);
Result := CrearNombre(Usuario,
                      DT.wYear,
                      DT.wMonth,
                      DT.wDay,
                      DT.wHour,
                      DT.wMinute,
                      DT.wSecond
                      );
end;

//-----------------------------------------------------------------------------
procedure TFormPrincipal.GuardarDatos(NumeroDelTexto: Integer);
var DirectorioBase: String;
    Ruta, RutaCompleta, CSV: String;
    Tiempo: TDateTime;
    ALMenosUno: Boolean;
    FicheroTexto: TextFile;
begin
//Busca primero los datos que necesita.
Tiempo := Now;                                             //Guarda el tiempo y fecha actual.
DirectorioBase := ExtractFilePath(Application.ExeName);    //Guarda la ruta del directorio de la aplicación.

//Guarda la lista de los nombres introducidos.
ComboBox1.Items.SaveToFile(DirectorioBase + CDatos + '\' + CListaDeNombres);

//Guarda los datos recolectados.
CSV := CrearNombre(ComboBox1.Text, Tiempo) + '.csv';
Ruta := DirectorioBase + CDatos + '\';
ALMenosUno := False;

if (KdEditAlphaNumeric1.Text <> '') and
   ((NumeroDelTexto = 0) or (NumeroDelTexto = 1)) then
   begin
   RutaCompleta := Ruta + LabelTexto1.Caption;
   if DirectoryExists(RutaCompleta) then
      begin
      if KdEditAlphaNumeric1.Text = LabelTexto1.Caption then
         KdEditAlphaNumeric1.TimingVectorToFileCSV(RutaCompleta + '\' + CSV)
      else
         KdEditAlphaNumeric1.TimingVectorToFileCSV(RutaCompleta + '\_' + CSV);
      ALMenosUno := True;
      end;
   end;

if (KdEditAlphaNumeric2.Text <> '') and
   ((NumeroDelTexto = 0) or (NumeroDelTexto = 2)) then
   begin
   RutaCompleta := Ruta + LabelTexto2.Caption;
   if DirectoryExists(RutaCompleta) then
      begin
      if KdEditAlphaNumeric2.Text = LabelTexto2.Caption then
         KdEditAlphaNumeric2.TimingVectorToFileCSV(RutaCompleta + '\' + CSV)
      else
         KdEditAlphaNumeric2.TimingVectorToFileCSV(RutaCompleta + '\_' + CSV);
      ALMenosUno := True;
      end;
   end;

if (KdEditAlphaNumeric3.Text <> '') and
   ((NumeroDelTexto = 0) or (NumeroDelTexto = 3))  then
   begin
   RutaCompleta := Ruta + LabelTexto3.Caption;
   if DirectoryExists(RutaCompleta) then
      begin
      if KdEditAlphaNumeric3.Text = LabelTexto3.Caption then
         KdEditAlphaNumeric3.TimingVectorToFileCSV(RutaCompleta + '\' + CSV)
      else
         KdEditAlphaNumeric3.TimingVectorToFileCSV(RutaCompleta + '\_' + CSV);
      ALMenosUno := True;
      end;
   end;

if (KdEditAlphaNumeric4.Text <> '') and
   ((NumeroDelTexto = 0) or (NumeroDelTexto = 4))  then
   begin
   RutaCompleta := Ruta + LabelTexto4.Caption;
   if DirectoryExists(RutaCompleta) then
      begin
      if KdEditAlphaNumeric4.Text = LabelTexto4.Caption then
         KdEditAlphaNumeric4.TimingVectorToFileCSV(RutaCompleta + '\' + CSV)
      else
         KdEditAlphaNumeric4.TimingVectorToFileCSV(RutaCompleta + '\_' + CSV);
      ALMenosUno := True;
      end;
   end;

if (KdEditAlphaNumeric5.Text <> '') and
   ((NumeroDelTexto = 0) or (NumeroDelTexto = 5))  then
   begin
   RutaCompleta := Ruta + LabelTexto5.Caption;
   if DirectoryExists(RutaCompleta) then
      begin
      if KdEditAlphaNumeric5.Text = LabelTexto5.Caption then
         KdEditAlphaNumeric5.TimingVectorToFileCSV(RutaCompleta + '\' + CSV)
      else
         KdEditAlphaNumeric5.TimingVectorToFileCSV(RutaCompleta + '\_' + CSV);
      ALMenosUno := True;
      end;
   end;

//Guarda en un fichero la fecha y hora de la última captura.
if ALMenosUno and DirectoryExists(Ruta) then
   begin
   AssignFile(FicheroTexto, Ruta + '' + CUltimaCaptura);
   Rewrite(FicheroTexto);
   Writeln(FicheroTexto, DateTimeToStr(Tiempo));
   CloseFile(FicheroTexto);
   end;
Guardado := True;
end;

//-----------------------------------------------------------------------------
// Valida y guarda los datos introducidos por el usuario.
// Si los datos son incorrectos, le pide que los introduzca nuevamente.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionGuardarExecute(Sender: TObject);
begin
if EntradasValidas then       //Si los datos son válidos:
   begin
   GuardarDatos(0);           //El cero significa "guardar todos".
   Close;                     //Cierra la ventana.
   end;
end;

//-----------------------------------------------------------------------------
// Si el usuario no copió todos los datos, guarda lo que puede.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if not Guardado then GuardarDatos(0);
end;

//-----------------------------------------------------------------------------
// Cierra el programa.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionCerrarExecute(Sender: TObject);
begin
Close;
end;

//-----------------------------------------------------------------------------
// Copia un directorio completo en otro.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.CopiarDirectorio(Origen, Destino: string);
var Ficheros: Integer;
    FOrigen, FDestino: string;
    Copiado, Creado: Boolean;
    Busqueda: TSearchRec;
    tit, msg: String;
begin
Ficheros := FindFirst(Origen + '\*.*', faAnyFile, Busqueda);
while Ficheros = 0 do
      begin
      if Busqueda.Attr <> faDirectory then
         begin
         FOrigen := Origen + '\' + Busqueda.Name;
         FDestino := Destino + '\' + Busqueda.Name;
         Copiado := CopyFile(PChar(FOrigen),PChar(FDestino), false);
         if not Copiado then
            begin
            tit := 'Error de funcionamiento...';
            msg := 'No se pudo copiar el fichero: ' + #13 + Busqueda.Name;
            MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
            end;
         end
      else
         begin
         if (Busqueda.Name <> '.') and (Busqueda.Name <> '..') then
            begin
            Creado := CreateDir(Destino + '\' + Busqueda.Name);
            if not Creado then
               begin
               tit := 'Error de funcionamiento...';
               msg := 'No se pudo crear el directorio: ' + #13 + Busqueda.Name;
               MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
               end
            else
               begin
               CopiarDirectorio(Origen + '\' + Busqueda.Name, Destino + Busqueda.Name);
               end;
            end;
         end;
      Ficheros := FindNext(Busqueda);
      end;
FindClose(Busqueda);
end;

//-----------------------------------------------------------------------------
// Borra un directorio completo y todo su contenido.
//-----------------------------------------------------------------------------
function TFormPrincipal.BorrarDirectorio(Nombre: String): Boolean;
var Busqueda: TSearchRec;
    Ficheros: Integer;
    tit, msg: String;
begin
Result := True;
Ficheros := FindFirst(Nombre + '*.*', FaAnyfile, Busqueda);
while Ficheros = 0 do
      begin
      if ((Busqueda.Attr and FaDirectory <> FaDirectory) and
          (Busqueda.Attr and FaVolumeId <> FaVolumeID)) then
          begin
          if DeleteFile(pChar(Nombre + Busqueda.Name)) = False then
             begin
             tit := 'Error de funcionamiento...';
             msg := 'No se puede borrar el fichero: ' + #13 + Nombre + Busqueda.Name;
             MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
             Result := False;
             Exit;
             end;
          end
      else
          begin
          if ((Busqueda.Attr and FaDirectory = FaDirectory) and
              (Busqueda.Name <> '.') and
              (Busqueda.Name <> '..')) then
              if not BorrarDirectorio(Nombre + Busqueda.Name + '\') then Exit;
          end;
      Ficheros := FindNext(Busqueda);
      end;
SysUtils.FindClose(Busqueda);
if RemoveDirectory(PChar(Nombre)) = false then
   begin
   tit := 'Error de funcionamiento...';
   msg := 'No se puede borrar el directorio: ' + #13 + Nombre;
   MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
   Result := False;
   end;
end;

//-----------------------------------------------------------------------------
// Borra un directorio completo y todo su contenido.
//-----------------------------------------------------------------------------
function TFormPrincipal.BorrarContenidoDeDirectorio(Nombre: String): Boolean;
var Busqueda: TSearchRec;
    Ficheros: Integer;
    tit, msg: String;
begin
Result := True;
Ficheros := FindFirst(Nombre + '*.*', FaAnyfile, Busqueda);
while Ficheros = 0 do
      begin
      if ((Busqueda.Attr and FaDirectory <> FaDirectory) and
          (Busqueda.Attr and FaVolumeId <> FaVolumeID)) then
          begin
          if DeleteFile(pChar(Nombre + Busqueda.Name)) = False then
             begin
             tit := 'Error de funcionamiento...';
             msg := 'No se puede borrar el fichero: ' + #13 + Nombre + Busqueda.Name;
             MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
             Result := False;
             Exit;
             end;
          end
      else
          begin
          if ((Busqueda.Attr and FaDirectory = FaDirectory) and
              (Busqueda.Name <> '.') and
              (Busqueda.Name <> '..')) then
              if not BorrarDirectorio(Nombre + Busqueda.Name + '\') then Exit;
          end;
      Ficheros := FindNext(Busqueda);
      end;
SysUtils.FindClose(Busqueda);
end;

//-----------------------------------------------------------------------------
// Guarda los datos capturados en el directorio que se especifique.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionSalvarExecute(Sender: TObject);
begin
with TFormSalvarDatos.Create(Self) do ShowModal;
end;

//-----------------------------------------------------------------------------
// Borra todos los datos capturados.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionBorrarExecute(Sender: TObject);
var tit, msg, Dir: String;
begin
tit := 'Confirmar';
msg := 'Desea borrar todos los datos capturados.';
if MessageBox(0, PChar(msg), PChar(tit), MB_OKCANCEL) = ID_OK then
   begin
   Dir := ExtractFilePath(Application.ExeName) + CDatos + '\';
   if DirectoryExists(Dir) then BorrarContenidoDeDirectorio(Dir);
   ComboBox1.Items.SaveToFile(Dir + CListaDeNombres);
   end;
end;

//-----------------------------------------------------------------------------
// Devuelve el espacio libre en el disco.
//-----------------------------------------------------------------------------
function TFormPrincipal.EspacioLibre(const Drive: Char): Int64;
var lpRP: PChar;    //Root path
    lpSPC: DWORD;   //Sectores por clusters
    lpBPS: DWORD;   //Bytes por sectores.
    lpNFC: DWORD;   //Número de clusters libres.
    lpTNC: DWORD;   //Número total de clusters.
begin
lpRP := PChar( Drive + ':\' );
if Windows.GetDiskFreeSpace(lpRP, lpSPC, lpBPS, lpNFC, lpTNC) then
    Result := Int64(lpNFC) * lpBPS * lpSPC
else
    Result := -1;
end;

//-----------------------------------------------------------------------------
// Devuelve información de un directorio.
//-----------------------------------------------------------------------------
function TFormPrincipal.InformacionDeDirectorio(Nombre: string ): TDirInfo;
var Archivo: tSearchRec;    //Archivo o carpeta con el que se trabaja en cada momento.
    Retorno: Integer;       //Valor de retorno de las Funciones FindFirst y FindNext.
    Path: String;           //Path del archivo.
    InfoTemp: TDirInfo;     //Registro con la Información temporal del directorio.
    InfoTemp2: TDirInfo;    //Registro con la Información temporal del directorio que devuelve la función.
begin
//Inicialización de las variables.
InfoTemp.Tamano := 0;
InfoTemp.NumDirectorios := 0;
InfoTemp.NumArchivos := 0;

//Si se introduce un nombre de directorio acabado en '\' se le quita,
// ya que si no no funciona Finfirst y findnext.
if Nombre[Length(Nombre)] = '\' then Nombre := Copy(Nombre, 1, Length(Nombre)-1);

Path := ExtractFilePath(Nombre);
Retorno := FindFirst(Nombre, faAnyFile, Archivo);
if Retorno = NO_ERROR then
   try
      while Retorno = NO_ERROR do
            begin
            Inc(InfoTemp.Tamano, Archivo.Size);                              // Se incrementa el tamaño en bytes del fichero/directorio.
            if ((Archivo.Attr and faDirectory) = faDirectory) and            // Si es un directorio y no es el '.' o '..'.
                (Archivo.Name[1] <> '.') then
                begin
                InfoTemp2 := InformacionDeDirectorio(Path + Archivo.Name + '\*.*');   //Se busca la información del directorio.
                Inc(InfoTemp.Tamano, InfoTemp2.Tamano);                               //Se suman los datos devueltos al registro temporal.
                Inc(InfoTemp.NumDirectorios, InfoTemp2.NumDirectorios + 1);           //Se suman los datos devueltos al registro temporal.
                Inc(InfoTemp.NumArchivos, InfoTemp2.NumArchivos);                     //Se suman los datos devueltos al registro temporal.
                end
            else
                if Archivo.Name[1] <> '.' then                               //Si es un archivo:
                   Inc(InfoTemp.NumArchivos);                                //Se incrementa en 1 el número de archivos.
            Retorno := FindNext(Archivo);                                    //Se busca el siguiente archivo.
            end;
   finally
      FindClose(Archivo);                                                    //Se libera la memoria.
   end;
Result := InfoTemp;
end;

//-----------------------------------------------------------------------------
// Muestra el estado de los datos capturados.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionEstadoExecute(Sender: TObject);
var tit, msg, Dir: String;
    Lista: TStrings;
    Espacio: Int64;
    InfoDatos: TDirInfo;
begin
Dir := ExtractFilePath(Application.ExeName) + CDatos + '\';
Lista := TStringList.Create;

tit := 'Estado de los datos:';
msg := '';

InfoDatos := InformacionDeDirectorio(Dir);
msg := msg + 'DIRECTORIO DE DATOS:' + #13;
msg := msg + 'Tamaño: ' + FloatToStrF(InfoDatos.Tamano / Sqr(1024), ffFixed, 15, 2) + ' Mb' + #13;
msg := msg + 'Directorios: ' + IntToStr(InfoDatos.NumDirectorios - 1) + #13;
msg := msg + 'Ficheros: ' + IntToStr(InfoDatos.NumArchivos) + #13#13;

Espacio := EspacioLibre('C');
//Espacio := EspacioLibre(Dir[1]);
if Espacio <> -1 then
   begin
   msg := msg + 'ESPACIO LIBRE EN EL DISCO:' + #13;
   msg := msg + FloatToStrF(Espacio / Sqr(1000), ffFixed, 15, 2) + ' Mb' + #13#13;
   end;

if FileExists(Dir + CUltimaCaptura) then
   begin
   Lista.LoadFromFile(Dir + CUltimaCaptura);
   msg := msg + 'ÚLTIMA CAPTURA:' + #13;
   msg := msg + Lista.Text + #13;
   end;

if FileExists(Dir + CListaDeNombres) then
   begin
   Lista.LoadFromFile(Dir + CListaDeNombres);
   msg := msg + 'USUARIOS DEL PROGRAMA:' + #13;
   msg := msg + Lista.Text;
   end;

MessageBox(0, PChar(msg), PChar(tit), MB_OK);
end;

//-----------------------------------------------------------------------------
// Guardan los textos introducidos con errores.
//-----------------------------------------------------------------------------

procedure TFormPrincipal.KdEditAlphaNumeric1Back(Sender: TObject);
begin
GuardarDatos(1);
end;

procedure TFormPrincipal.KdEditAlphaNumeric2Back(Sender: TObject);
begin
GuardarDatos(2);
end;

procedure TFormPrincipal.KdEditAlphaNumeric3Back(Sender: TObject);
begin
GuardarDatos(3);
end;

procedure TFormPrincipal.KdEditAlphaNumeric4Back(Sender: TObject);
begin
GuardarDatos(4);
end;

procedure TFormPrincipal.KdEditAlphaNumeric5Back(Sender: TObject);
begin
GuardarDatos(5);
end;

//-----------------------------------------------------------------------------
// Guarda un color en un fichero.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.GuardarColor(valor: TColor; Fichero: String);
var FicheroTexto: TextFile;
    Ruta: String;
begin
if DirectoryExists(ExtractFilePath(Fichero)) then
   try
      AssignFile(FicheroTexto, Fichero);
      Rewrite(FicheroTexto);
      Writeln(FicheroTexto, IntToStr(GetRValue(valor)));
      Writeln(FicheroTexto, IntToStr(GetGValue(valor)));
      Writeln(FicheroTexto, IntToStr(GetBValue(valor)));
   finally
      CloseFile(FicheroTexto);
   end;
end;

//-----------------------------------------------------------------------------
// Leer un color desde un fichero.
//-----------------------------------------------------------------------------
function TFormPrincipal.LeerColor(Fichero: String): TColor;
var clR, clG, clB: Integer;
    DirectorioBase: String;
    Lista: TStrings;
    tit, msg, Dir: String;
begin
Result := clBlack;
Lista := TStringList.Create;
if FileExists(Fichero) then
   try
      Lista.LoadFromFile(Fichero);
      clR := StrToInt(FiltrarNumeros(Lista[0]));
      clG := StrToInt(FiltrarNumeros(Lista[1]));
      clB := StrToInt(FiltrarNumeros(Lista[2]));
      Result := RGB(clR, clG, clB);
      Lista.Free;
   except
      tit := 'Error...';
      msg := 'No se puede leer el color.' + #13;
      MessageBox(0, PChar(msg), PChar(tit), MB_ICONERROR);
   end;
end;
//-----------------------------------------------------------------------------
// Le permite al usuario seleccionar el color de fondo.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionColorDeFondoExecute(Sender: TObject);
var FicheroTexto: TextFile;
    Ruta: String;
begin
Ruta := ExtractFilePath(Application.ExeName);
ColorDialogFondo.Color := Color;
if ColorDialogFondo.Execute then
   begin
   Color := ColorDialogFondo.Color;
   GuardarColor(ColorDialogFondo.Color, Ruta + CColorDeFondo);
   end;
end;

//-----------------------------------------------------------------------------
// Le permite al usuario seleccionar el color de la fuente.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionColorDeFuenteExecute(Sender: TObject);
var FicheroTexto: TextFile;
    Ruta: String;
begin
Ruta := ExtractFilePath(Application.ExeName);
ColorDialogFuente.Color := Font.Color;
if ColorDialogFuente.Execute then
   begin
   Font.Color := ColorDialogFuente.Color;
   GuardarColor(ColorDialogFuente.Color, Ruta + CColorDeFuente);
   end;
end;

//-----------------------------------------------------------------------------
// Restablece los colores originales de la aplicación.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.ActionColoresOriginalesExecute(Sender: TObject);
var FicheroTexto: TextFile;
    Ruta: String;
begin
Ruta := ExtractFilePath(Application.ExeName);

Color := FColorDeFondoOriginal;
GuardarColor(Color, Ruta + CColorDeFondo);

Font.Color := FColorDeFuenteOriginal;
GuardarColor(Font.Color, Ruta + CColorDeFuente);
end;

//-----------------------------------------------------------------------------
// Establece los colores de la aplicación.
//-----------------------------------------------------------------------------
procedure TFormPrincipal.FormCreate(Sender: TObject);
var DirectorioBase: String;
begin
//Busca el directorio de la aplicación.
DirectorioBase := ExtractFilePath(Application.ExeName);

FColorDeFondoOriginal := RGB(213, 225, 230);
FColorDeFuenteOriginal := clBlack;

//Establece el color del fondo de la aplicación.
Color := LeerColor(DirectorioBase + CColorDeFondo);
if Color = clBlack then Color := FColorDeFondoOriginal;

//Establece el color de la fuente.
Font.Color := LeerColor(DirectorioBase + CColorDeFuente);
end;


end.
