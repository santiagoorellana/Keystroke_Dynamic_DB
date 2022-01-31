unit UKdEditGetIntervalsDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UKdEditAlphaNumeric, ActnList, UKdIntervalCreator,
  ComCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Menus, ToolWin,
  ULista, ImgList;

//-----------------------------------------------------------------------------
// Tipos de intervalos que se miden.
//-----------------------------------------------------------------------------

type TIntervalo = (Duracion, DiGraph, TriGraph, TetraGraph, PentaGraph);

//-----------------------------------------------------------------------------
type
  TForm1 = class(TForm)
    KdIntervalCreator1: TKdIntervalCreator;
    OpenDialogCSV: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MemoValores: TMemo;
    TabSheet2: TTabSheet;
    Chart1: TChart;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    ActionMostrarLeyenda: TAction;
    ActionMostrarMalla: TAction;
    ActionCargarFicherosCSV: TAction;
    Inicio1: TMenuItem;
    Ayuda1: TMenuItem;
    Vista1: TMenuItem;
    Mostrarleyenda1: TMenuItem;
    Mostrarmalla1: TMenuItem;
    CargarficherosCSV1: TMenuItem;
    ActionProcedencia: TAction;
    Procedencia1: TMenuItem;
    ActionExportarValoresCSV: TAction;
    ActionExportarGrafico: TAction;
    SaveDialogValoresCSV: TSaveDialog;
    SaveDialogGrafico: TSaveDialog;
    Resultados1: TMenuItem;
    Exportargrfico1: TMenuItem;
    ExportarvalorescomoCSV1: TMenuItem;
    StatusBar1: TStatusBar;
    ActionDuracion: TAction;
    ActionDiGraph: TAction;
    ActionTriGraph: TAction;
    ActionTetraGraph: TAction;
    ActionPentaGraph: TAction;
    Calcular1: TMenuItem;
    Duracin1: TMenuItem;
    DiGraph1: TMenuItem;
    riGraph1: TMenuItem;
    etraGraph1: TMenuItem;
    PentaGraph1: TMenuItem;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ActionNuevo: TAction;
    Nuevo1: TMenuItem;
    ListBox1: TListBox;
    ImageList1: TImageList;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    TabSheet4: TTabSheet;
    ListBoxUsuarios: TListBox;
    TabSheet5: TTabSheet;
    PaintBox1: TPaintBox;
    procedure KdEditAlphaNumeric1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal);
    procedure KdIntervalCreator1Duration(Sender: TObject; Key: Byte;
      Tiempo: Cardinal);
    procedure KdIntervalCreator1DiGraph(Sender: TObject; Key1, Key2: Byte;
      Tiempo: Cardinal);
    procedure KdIntervalCreator1PentaGraph(Sender: TObject; Key1, Key2,
      key3, Key4, Key5: Byte; Tiempo: Cardinal);
    procedure KdIntervalCreator1TetraGraph(Sender: TObject; Key1, Key2,
      key3, Key4: Byte; Tiempo: Cardinal);
    procedure KdIntervalCreator1TriGraph(Sender: TObject; Key1, Key2,
      key3: Byte; Tiempo: Cardinal);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure ActionMostrarLeyendaExecute(Sender: TObject);
    procedure ActionMostrarMallaExecute(Sender: TObject);
    procedure ActionCargarFicherosCSVExecute(Sender: TObject);
    procedure ActionMostrarLeyendaUpdate(Sender: TObject);
    procedure ActionMostrarMallaUpdate(Sender: TObject);
    procedure ActionProcedenciaExecute(Sender: TObject);
    procedure ActionExportarGraficoExecute(Sender: TObject);
    procedure ActionExportarValoresCSVExecute(Sender: TObject);
    procedure ActionDuracionExecute(Sender: TObject);
    procedure ActionDiGraphExecute(Sender: TObject);
    procedure ActionTriGraphExecute(Sender: TObject);
    procedure ActionTetraGraphExecute(Sender: TObject);
    procedure ActionPentaGraphExecute(Sender: TObject);
    procedure ActionNuevoExecute(Sender: TObject);
    procedure ListBoxUsuariosDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PageControl1Resize(Sender: TObject);
  private
    Lista: TLista;
    Usuarios: TStrings;
    Serie: Integer;
    ColorSerie: TColor;
    bmp: TBitmap;
    TMax: TDateTime;
    TMin: TDateTime;

    Linea: String;
    Intervalo: TIntervalo;
    procedure Calcular;
    procedure ReiniciarCalculos;
    function DescomponerNombre(Nombre: String; var Datos: TDatoFichero): Boolean;
    function InterpolarDosColores(fraction:Double; Color1, Color2:TColor): TColor;
    function InterpolarVariosColores(valor: Double): TColor;
    procedure DibujarDistribucionTemporal;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UProcedencia, DateUtils, Types;

{$R *.dfm}

//-----------------------------------------------------------------------------
// Inicia el formulario.
//-----------------------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
begin
bmp := TBitmap.Create;
bmp.Width := PaintBox1.Width;
bmp.Height := PaintBox1.Height;
Lista := TLista.Create;
Usuarios := TStringList.Create;
ActionNuevoExecute(Self);
Chart1.Legend.Visible := False;
StatusBar1.Panels[1].Text := '';
DibujarDistribucionTemporal;
end;

//-----------------------------------------------------------------------------
// Descompone un nombre de fichero del tipo GA y extrae los
// datos datos de referencia y los devuelve en una
// estructura de datos TDatosDeReferencia.
//-----------------------------------------------------------------------------
function TForm1.DescomponerNombre(Nombre: String; var Datos: TDatoFichero): Boolean;
const Sep = '_';
var s: Integer;
    c: String;
begin
Result := False;

//Detecta si el fichero contiene error.
Datos.ConError := False;
if Nombre[1] = Sep then
   begin
   Datos.ConError := True;                     //Indica que este fichero es de error.
   Delete(Nombre, 1, 1);                       //Borra el indicador de error.
   end;

//Extrae la longitud
s := Pos(Sep, Nombre);                         //Busca la posición del separador.
if s > 0 then                                  //Si encuentra el separador:
   begin
   Datos.Usuario := Copy(Nombre, 1, s - 1);    //Copia la latitud excluyendo al separador.
   Delete(Nombre, 1, s);                       //Desecha el nombre del usuario y el separador.
   end
else
   Exit;

//Extrae el número del año.
s := Pos(Sep, Nombre);                         //Busca la posición del separador.
if s > 0 then                                  //Si encuentra el separador:
   begin
   c := Copy(Nombre, 1, s - 1);
   try
      Datos.Anno := StrToInt(c);
   except
      Exit;
   end;
   Delete(Nombre, 1, s);
   end
else
   Exit;

//Extrae el número del més.
s := Pos(Sep, Nombre);                         //Busca la posición del separador.
if s > 0 then                                  //Si encuentra el separador:
   begin
   c := Copy(Nombre, 1, s - 1);
   try
      Datos.Mes := StrToInt(c);
   except
      Exit;
   end;
   Delete(Nombre, 1, s);
   end
else
   Exit;

//Extrae el número del día.
s := Pos(Sep, Nombre);                         //Busca la posición del separador.
if s > 0 then                                  //Si encuentra el separador:
   begin
   c := Copy(Nombre, 1, s - 1);
   try
      Datos.Dia := StrToInt(c);
   except
      Exit;
   end;
   Delete(Nombre, 1, s);
   end
else
   Exit;

//Extrae el número de la hora.
s := Pos(Sep, Nombre);                         //Busca la posición del separador.
if s > 0 then                                  //Si encuentra el separador:
   begin
   c := Copy(Nombre, 1, s - 1);
   try
      Datos.Hora := StrToInt(c);
   except
      Exit;
   end;
   Delete(Nombre, 1, s);
   end
else
   Exit;

//Extrae el número los minutos
s := Pos(Sep, Nombre);                         //Busca la posición del separador.
if s > 0 then                                  //Si encuentra el separador:
   begin
   c := Copy(Nombre, 1, s - 1);
   try
      Datos.Minuto := StrToInt(c);
   except
      Exit;
   end;
   Delete(Nombre, 1, s);
   end
else
   Exit;

//Extrae el número los segundos.
try
   Datos.Segundo := StrToInt(Nombre);
except
   Exit;
end;

Result := True;
end;

//-----------------------------------------------------------------------------
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
MemoValores.Clear;
KdIntervalCreator1.Reset;
end;

//-----------------------------------------------------------------------------
procedure TForm1.KdEditAlphaNumeric1KeyUpTiming(Sender: TObject; Event: Char; Key: Byte; Time: Cardinal);
begin
KdIntervalCreator1.AddEvent(Event, Key, Time);
end;

//-----------------------------------------------------------------------------
// Muestran los intervalos entre los eventos KeyDown y KeyUp. 
//-----------------------------------------------------------------------------

procedure TForm1.KdIntervalCreator1Duration(Sender: TObject; Key: Byte; Tiempo: Cardinal);
begin
if Intervalo <> Duracion then Exit;
Linea := Linea + IntToStr(Tiempo) + ';';
Chart1.Series[Serie].AddY(Tiempo, Chr(Key), ColorSerie);
end;

procedure TForm1.KdIntervalCreator1DiGraph(Sender: TObject; Key1, Key2: Byte; Tiempo: Cardinal);
begin
if Intervalo <> DiGraph then Exit;
Linea := Linea + IntToStr(Tiempo) + ';';
Chart1.Series[Serie].AddY(Tiempo, Chr(Key1)+Chr(Key2) , ColorSerie);
end;

procedure TForm1.KdIntervalCreator1TriGraph(Sender: TObject; Key1, Key2, key3: Byte; Tiempo: Cardinal);
begin
if Intervalo <> TriGraph then Exit;
Linea := Linea + IntToStr(Tiempo) + ';';
Chart1.Series[Serie].AddY(Tiempo, Chr(Key1)+Chr(Key2)+Chr(key3) , ColorSerie);
end;

procedure TForm1.KdIntervalCreator1TetraGraph(Sender: TObject; Key1, Key2, key3, Key4: Byte; Tiempo: Cardinal);
begin
if Intervalo <> TetraGraph then Exit;
Linea := Linea + IntToStr(Tiempo) + ';';
Chart1.Series[Serie].AddY(Tiempo, Chr(Key1)+Chr(Key2)+Chr(key3)+Chr(Key4) , ColorSerie);
end;

procedure TForm1.KdIntervalCreator1PentaGraph(Sender: TObject; Key1, Key2, key3, Key4, Key5: Byte; Tiempo: Cardinal);
begin
if Intervalo <> PentaGraph then Exit;
Linea := Linea + IntToStr(Tiempo) + ';';
Chart1.Series[Serie].AddY(Tiempo, Chr(Key1)+Chr(Key2)+Chr(key3)+Chr(Key4)+Chr(Key5), ColorSerie);
end;

//-----------------------------------------------------------------------------
// Carga varios ficheros de datos biométricos de un usuario.
//-----------------------------------------------------------------------------
procedure TForm1.ActionCargarFicherosCSVExecute(Sender: TObject);
var n: Integer;
    Fichero: TFicheroBiometrico;
    Datos: TDatoFichero;
    Nombre: String;
begin
if OpenDialogCSV.Execute then
   if OpenDialogCSV.Files.Count > 0 then
      begin
      StatusBar1.Panels[0].Text := '';
      for n := 0 to OpenDialogCSV.Files.Count - 1 do           //Para cada uno de los ficheros seleccionados:
          begin
          Nombre := ExtractFileName(OpenDialogCSV.Files[n]);   //Obtiene el nombre.
          Nombre := Copy(Nombre, 1, Length(Nombre) - 4);       //Le quita la extensión.
          if DescomponerNombre(Nombre, Datos) then             //Si puede obtener los datos:
             begin
             if Usuarios.IndexOf(Datos.Usuario) = -1 then
                Usuarios.Add(Datos.Usuario);
             Fichero.Ruta := OpenDialogCSV.Files[n];           //Agrega el fichero y
             Fichero.Datos := Datos;                           //sus datos a la lista.
             TryEncodeDateTime(Fichero.Datos.Anno,
                               Fichero.Datos.Mes,
                               Fichero.Datos.Dia,
                               Fichero.Datos.Hora,
                               Fichero.Datos.Minuto,
                               Fichero.Datos.Segundo,
                               0,
                               Fichero.FechaTiempo
                               );
             if CompareDateTime(TMin, Fichero.FechaTiempo) = 1 then
                TMin := Fichero.FechaTiempo;
             if CompareDateTime(TMax, Fichero.FechaTiempo) = -1 then
                TMax := Fichero.FechaTiempo;
             Lista.InsertarOrdenadoPorFechaHora(Fichero);
             end;
          ListBoxUsuarios.Items := Usuarios;
          end;
      StatusBar1.Panels[0].Text := 'Ficheros cargados: ' + IntToStr(Lista.Insertados);
      DibujarDistribucionTemporal;
      end;
end;

//-----------------------------------------------------------------------------
// Reinicia el programa para realizar un nuevo análisis.
//-----------------------------------------------------------------------------
procedure TForm1.ActionNuevoExecute(Sender: TObject);
begin
Usuarios.Clear;
TMin := $0fffffff;
TMax := 0;
Serie := 0;
Chart1.RemoveAllSeries;
Lista.Vaciar;
MemoValores.Clear;
StatusBar1.Panels[0].Text := '';
StatusBar1.Panels[1].Text := '';

//Dibuja el area de fondo del gráfico temporal.
bmp.Canvas.Brush.Style := bsSolid;
bmp.Canvas.Pen.Style := psSolid;
bmp.Canvas.Brush.Color := clWhite;
bmp.Canvas.Pen.Color := clBlack;
bmp.Canvas.Pen.Width := 1;
bmp.Canvas.Rectangle(Rect(0, 0, bmp.Width, bmp.Height));
PaintBox1.Invalidate;
end;

//-----------------------------------------------------------------------------
// Borra los gráfiocos y resultados.
//-----------------------------------------------------------------------------
procedure TForm1.ReiniciarCalculos;
begin
Serie := 0;
Chart1.RemoveAllSeries;
MemoValores.Clear;
end;

//-----------------------------------------------------------------------------
// Muestra u oculta la leyenda.
//-----------------------------------------------------------------------------
procedure TForm1.ActionMostrarLeyendaExecute(Sender: TObject);
begin
//Chart1.Legend.Visible := not ActionMostrarLeyenda.Checked;
end;

procedure TForm1.ActionMostrarLeyendaUpdate(Sender: TObject);
begin
//ActionMostrarLeyenda.Checked := Chart1.Legend.Visible;
end;

//-----------------------------------------------------------------------------
// Muestra u oculta la malla del gráfico.
//-----------------------------------------------------------------------------
procedure TForm1.ActionMostrarMallaExecute(Sender: TObject);
begin
Chart1.LeftAxis.Grid.Visible := not ActionMostrarMalla.Checked;
Chart1.BottomAxis.Grid.Visible := not ActionMostrarMalla.Checked;
end;

procedure TForm1.ActionMostrarMallaUpdate(Sender: TObject);
begin
ActionMostrarMalla.Checked := Chart1.LeftAxis.Grid.Visible;
end;

//-----------------------------------------------------------------------------
// Muestra la procedencia de la aplicación.
//-----------------------------------------------------------------------------
procedure TForm1.ActionProcedenciaExecute(Sender: TObject);
begin
with TFormProcedencia.Create(Self) do ShowModal;
end;

//-----------------------------------------------------------------------------
// Permite exportar la gráfica en un fichero BMP.
//-----------------------------------------------------------------------------
procedure TForm1.ActionExportarGraficoExecute(Sender: TObject);
begin
if SaveDialogGrafico.Execute then
   Chart1.SaveToBitmapFile(SaveDialogGrafico.FileName);
end;

//-----------------------------------------------------------------------------
// Permite exportar los valores de los datos a un fichero CSV.
//-----------------------------------------------------------------------------
procedure TForm1.ActionExportarValoresCSVExecute(Sender: TObject);
begin
if SaveDialogValoresCSV.Execute then
   MemoValores.Lines.SaveToFile(SaveDialogValoresCSV.FileName);
end;

//-----------------------------------------------------------------------------
// Calcula los intervalos entre los eventos de tecla KeyDown y KeyUp.
//-----------------------------------------------------------------------------
procedure TForm1.Calcular;
var n, Indice: Integer;
    Nombre: String;
    Fichero: TFicheroBiometrico;
begin
ReiniciarCalculos;
if Lista.Insertados > 0 then
   begin
   StatusBar1.Panels[0].Text := 'Leyendo ficheros...';
   MemoValores.Clear;
   for n := 0 to Lista.Insertados - 1 do
       begin
       Serie := n;
       Fichero := Lista.Obtener(n);
       Indice := ListBoxUsuarios.Items.IndexOf(Fichero.Datos.Usuario);
       ColorSerie := InterpolarVariosColores(Indice / ListBoxUsuarios.Count);
       Linea := Fichero.Datos.Usuario + ';' +
                IntToStr(Fichero.Datos.Dia) + '/' +
                IntToStr(Fichero.Datos.Mes) + '/' +
                IntToStr(Fichero.Datos.Anno) + ';' +
                IntToStr(Fichero.Datos.Hora) + ':' +
                IntToStr(Fichero.Datos.Minuto) + ':' +
                IntToStr(Fichero.Datos.Segundo) + ';';
       Chart1.AddSeries(TLineSeries.Create(Self));
       Chart1.Series[Serie].Clear;
       Chart1.Series[Serie].Title := Fichero.Datos.Usuario + ' ' +
                                     IntToStr(Fichero.Datos.Dia) + '/' +
                                     IntToStr(Fichero.Datos.Mes) + '/' +
                                     IntToStr(Fichero.Datos.Anno) + ' ' +
                                     IntToStr(Fichero.Datos.Hora) + ':' +
                                     IntToStr(Fichero.Datos.Minuto) + ':' +
                                     IntToStr(Fichero.Datos.Segundo);
       Chart1.Series[Serie].Identifier := Chart1.Series[Serie].Title;
       KdIntervalCreator1.AddEventsFromFile(Fichero.Ruta);
       MemoValores.Lines.Add(Linea);
       end;
   StatusBar1.Panels[0].Text := 'Muestras cargadas: ' + IntToStr(Lista.Insertados);
   end;
end;

procedure TForm1.ActionDuracionExecute(Sender: TObject);
begin
Intervalo := Duracion;
Calcular;
StatusBar1.Panels[1].Text := 'Tipo de intervalos: Duracion';
end;

procedure TForm1.ActionDiGraphExecute(Sender: TObject);
begin
Intervalo := DiGraph;
Calcular;
StatusBar1.Panels[1].Text := 'Tipo de intervalos: Di-Graph';
end;

procedure TForm1.ActionTriGraphExecute(Sender: TObject);
begin
Intervalo := TriGraph;
Calcular;
StatusBar1.Panels[1].Text := 'Tipo de intervalos: Tri-Graph';
end;

procedure TForm1.ActionTetraGraphExecute(Sender: TObject);
begin
Intervalo := TetraGraph;
Calcular;
StatusBar1.Panels[1].Text := 'Tipo de intervalos: Tetra-Graph';
end;

procedure TForm1.ActionPentaGraphExecute(Sender: TObject);
begin
Intervalo := PentaGraph;
Calcular;
StatusBar1.Panels[1].Text := 'Tipo de intervalos: Penta-Graph';
end;

//-------------------------------------------------------------------
// Devuelve la interpolación de dos colores.
//-----------------------------------------------------------------------------
function TForm1.InterpolarDosColores(fraction:Double; Color1, Color2:TColor): TColor;
var complement: Double;
    R1, R2, G1, G2, B1, B2: BYTE;
begin
if fraction <= 0 then
   Result := Color1
else
   if fraction >= 1.0 then
      Result := Color2
   else
      begin
      R1 := GetRValue(Color1);
      G1 := GetGValue(Color1);
      B1 := GetBValue(Color1);
      R2 := GetRValue(Color2);
      G2 := GetGValue(Color2);
      B2 := GetBValue(Color2);
      complement := 1.0 - fraction;
      Result := RGB(Round(complement*R1 + fraction*R2),
                    Round(complement*G1 + fraction*G2),
                    Round(complement*B1 + fraction*B2));
      end;
end;

//-----------------------------------------------------------------------------
// Devuelve la interpolación de varios colores.
//-----------------------------------------------------------------------------
function TForm1.InterpolarVariosColores(valor: Double): TColor;
var p: Double;
begin
p := 6 * valor;
case Trunc(p) of
     0: Result := InterpolarDosColores(Frac(p), $0000FF, $0080FF);
     1: Result := InterpolarDosColores(Frac(p), $0080FF, $00FFFF);
     2: Result := InterpolarDosColores(Frac(p), $00FFFF, $00FF00);
     3: Result := InterpolarDosColores(Frac(p), $00FF00, $FFFF00);
     4: Result := InterpolarDosColores(Frac(p), $FFFF00, $FF0000);
     5: Result := InterpolarDosColores(Frac(p), $FF0000, $FF0080);
     6: Result := InterpolarDosColores(Frac(p), $FF0080, $FF00FF);
     else Result := clBlack;
     end;
end;

//-----------------------------------------------------------------------------
// Establece un color para cada usuario que se muestra en la lista de usuarios.
//-----------------------------------------------------------------------------
procedure TForm1.ListBoxUsuariosDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var cf, ct: TColor;
begin
with (Control as TListBox) do
     begin
     cf := InterpolarVariosColores(Index / Count);
     ct := not cf;
     Canvas.Brush.Color := cf;
     Canvas.Font.Color := ct;
     Canvas.FillRect(Rect);
     Canvas.TextOut(Rect.Left,Rect.Top,Items[Index]);
     end;
end;

//-----------------------------------------------------------------------------
// Dibuja el gráfico de distribución temporal.
//-----------------------------------------------------------------------------
procedure TForm1.DibujarDistribucionTemporal;
const CMargen = 10;
var rl: TRect;
    x, y, px, py, n: Integer;
    fy, fx, d, i: Double;
    FIchero: TFicheroBiometrico;
begin
//Establece el tamaño del bitmap.
bmp.Width := PaintBox1.Width;
bmp.Height := PaintBox1.Height;

//Dibuja el area de fondo.
bmp.Canvas.Brush.Style := bsSolid;
bmp.Canvas.Pen.Style := psSolid;
bmp.Canvas.Brush.Color := clWhite;
bmp.Canvas.Pen.Color := clBlack;
bmp.Canvas.Pen.Width := 1;
bmp.Canvas.Rectangle(Rect(0, 0, bmp.Width, bmp.Height));

//Sale si no existen datos para mostrar.
if Usuarios.Count = 0 then Exit;
if Lista.Insertados = 0 then Exit;

//Dibuja la línea del tiempo de cada usuario.
fy := bmp.Height / Usuarios.Count;          //Fragmento en que se divide el eje Y.
d := DaySpan(TMin, TMax);                   //Cantidad de días del rango del eje X.
for y := 0 to Usuarios.Count - 1 do
    begin
    py := Round(fy * y + (fy / 2));         //Calcula la altura de la línea del tiempo y.
    rl.Left := 1;
    rl.Right := bmp.Width - 1;
    rl.Top := Round(py - (fy / 10));
    rl.Bottom := Round(py + (fy / 10));
    bmp.Canvas.Brush.Color := InterpolarVariosColores(y / Usuarios.Count);
    bmp.Canvas.FillRect(rl);
    bmp.Canvas.MoveTo(0, py);
    bmp.Canvas.LineTo(bmp.Width, py);
    end;

//Dibuja los eventos de cada usuario en la posición que le corresponde.
for n := 0 to Lista.Insertados - 1 do
    begin
    FIchero := Lista.Obtener(n);
    py := Round(fy * (Usuarios.IndexOf(FIchero.Datos.Usuario)) + (fy / 2));               //Calcula la altura de la línea del tiempo y.
    px := Round((bmp.Width - CMargen * 2) * (DaySpan(TMin, FIchero.FechaTiempo) / d));    //Calcula la posición de la marca en el tiempo.
    bmp.Canvas.Pen.Width := 3;
    bmp.Canvas.MoveTo(px + CMargen, Round(py - (fy / 5)));
    bmp.Canvas.LineTo(px + CMargen, Round(py + (fy / 5)));
    end;

//Redibuja el gráfico en el formulario.
PaintBox1.Invalidate;
end;

//-----------------------------------------------------------------------------
// Copia el dibujo del gráfico de distribución temporal en la pantalla.
//-----------------------------------------------------------------------------
procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
PaintBox1.Canvas.Draw(0, 0, bmp);
end;

//-----------------------------------------------------------------------------
// Redibuja las gráficas al cambiar el tamaño del formulario.
//-----------------------------------------------------------------------------
procedure TForm1.PageControl1Resize(Sender: TObject);
begin
DibujarDistribucionTemporal;
end;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
procedure TForm1.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
ShowMessage(Series.Title);
//Series.va
end;


end.
