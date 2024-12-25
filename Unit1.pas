unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxPDFCore, dxPDFBase, dxPDFText,
  dxPDFRecognizedObject, dxPDFDocument, dxBarBuiltInMenu, Vcl.StdCtrls,
  dxShellDialogs, dxCustomPreview, dxPDFDocumentViewer, dxPDFViewer,
  Vcl.ExtCtrls, Vcl.ComCtrls, dxGDIPlusClasses, Vcl.Buttons, ShellApi, System.Threading, Clipbrd,
  System.ImageList, Vcl.ImgList;

type
  TmainForm = class(TForm)
    PDF: TdxPDFViewer;
    input: TEdit;
    lblFound: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label4: TLabel;
    Image2: TImage;
    BitBtn5: TBitBtn;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    listPDF: TListView;
    ImageList1: TImageList;
    listOutput: TListView;
    Icon32: TImageList;
    listExecute: TListBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure inputClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure salvandoHistorial;
    procedure listOutputClick(Sender: TObject);
    procedure listOutputDblClick(Sender: TObject);
    procedure ejecutarAPP(Execute :String);
  private
    procedure WMDropFiles ( var Msg : TMessage ) ; message WM_DropFiles;
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

procedure TmainForm.BitBtn1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Begin
      for var I := 0 to OpenDialog1.Files.Count -1 do
        with listPDF.Items.Add do
          Begin
            ImageIndex := 0;
            Caption := OpenDialog1.Files[I];
          end;
    End;

  Label2.Caption  := 'TOTAL: (' + InttoStr(listPDF.Items.Count) + ')';
end;

procedure TmainForm.BitBtn2Click(Sender: TObject);
var
  Visto, Encontrado : Integer;
begin
  input.SetFocus;
  Visto :=  0;
  Encontrado  := 0;
  listOutput.Clear;
  lblFound.Caption	:= 'FOUNDS: ';

  if ( (input.Text = '') Or (listPDF.Items.Count = 0) ) then
      Application.MessageBox('You must write something to search, or add the PDF.',
     'Reintent', MB_OK + MB_ICONWARNING)
  else
       Begin
         mainForm.WindowState := wsMinimized;
         for var I := 0 to listPDF.Items.Count -1 do
              Begin
                PDF.LoadFromFile(listPDF.Items[I].Caption);
                Memo1.Clear;
                PDF.Selection.SelectAll;
                Memo1.Lines.text := PDF.Selection.AsText;

                 if (AnsiPos(Trim(input.Text) ,
                        Trim(Memo1.Lines.Text)) <>0 ) then
                    Begin
                       with listOutput.Items.Add do
                          Begin
                            ImageIndex := 0;
                            Caption := ExtractFileName( listPDF.Items[I].Caption);
                          end;
                       listExecute.Items.Add( listPDF.Items[I].Caption );
                       lblFound.Caption	:= 'FOUNDS: (' + IntToSTr( listOutput.Items.Count ) + ')';
                    End;

                Memo1.Clear;
                Visto :=  Visto + 1;
                Label2.Caption := 'Total: (' + InttoStr( Visto ) + '/'+ InttoStr(listPDF.Items.Count) + ')';
              End;

          Application.MessageBox(PCHAR('¡COMPLETED REVIEW!' + slinebreak + slinebreak +
          'FOUNDS: ( ' + IntToSTr(listOutput.Items.Count)+' )'),
          'SUCCESS', MB_OK + MB_ICONINFORMATION);

         salvandoHistorial;
         mainForm.WindowState := wsNormal;
       End;
END;

procedure TmainForm.BitBtn3Click(Sender: TObject);
begin
  listPDF.Clear;
end;

procedure TmainForm.BitBtn4Click(Sender: TObject);
begin
  listOutput.Clear;
end;

procedure TmainForm.BitBtn5Click(Sender: TObject);
begin
  var execute := ExtractFilePath(Application.Exename)+'LOG.TXT';
  ejecutarAPP(execute);
end;

procedure TmainForm.inputClick(Sender: TObject);
begin
  input.Clear;
end;

procedure TmainForm.FormCreate(Sender: TObject);
begin
  DragAcceptFiles( Handle,True );
end;

procedure TmainForm.listOutputClick(Sender: TObject);
begin
  listExecute.ItemIndex := listOutput.ItemIndex;
end;

procedure TmainForm.listOutputDblClick(Sender: TObject);
Var
  Seleccion: Integer; Execute: String;
begin
  Seleccion := listExecute.ItemIndex;
  Execute := listExecute.Items[Seleccion];
  ejecutarAPP(execute);
end;

procedure TmainForm.WMDropFiles(var Msg: TMessage);
var
  hDrop: THandle;
  fName: array [0 .. Max_Path] of char;
  FileCount: Integer;
  i, J: Integer;
begin
  hDrop := Msg.WParam;
  FileCount := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
  for i := 0 to FileCount - 1 do
    begin
      DragQueryFile(hDrop, i, fName, 254);
       for J := 0 to listPDF.Items.Count -1 do
         if listPDF.Items[J].Caption = fName then Exit;
         listPDF.Items.Add.Caption := (fName);
    end;
 DragFinish(hDrop);
 Label2.Caption := 'TOTAL: ('+ InttoStr(listPDF.Items.Count) + ')';
end;

procedure TmainForm.salvandoHistorial;
Begin
  Memo1.Clear;
  Try
    Memo1.Lines.LoadFromFile(
    ExtractFilePath(Application.Exename) + 'LOG.TXT');
  Except End;

    Memo1.Lines.add('Search criteria: [ '+ input.Text + ' ]');
     for var I := 0 to listOutput.Items.Count -1 do
      Memo1.Lines.add(' - '+ listOutput.Items[I].Caption);

    if listOutput.Items.Count = 0 then
       Memo1.Lines.add('-> NO COINCIDENCES WERE FOUND .');

    Memo1.Lines.add('-------------------------------------');
    Memo1.Lines.SaveToFile(
    ExtractFilePath(Application.Exename) + 'LOG.TXT');
End;

procedure TmainForm.ejecutarAPP(Execute: string);
Begin
 ShellExecute(mainForm.Handle,nil,PChar(Execute),'','',SW_SHOWNORMAL);
End;

end.
