unit uNeander;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, Buttons, uSimula, ExtCtrls, ExtDlgs;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    Simulador: TMainMenu;
    Arquivo1: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    SalvarComo1: TMenuItem;
    Sair1: TMenuItem;
    N1: TMenuItem;
    dumpMem: TListBox;
    editor: TMemo;
    Compilar1: TMenuItem;
    GroupBox1: TGroupBox;
    b_PC: TButton;
    l_PC: TLabel;
    b_ACC: TButton;
    l_ACC: TLabel;
    Assistente1: TMenuItem;
    GroupBox2: TGroupBox;
    b_executar: TButton;
    b_passoAPasso: TButton;
    b_parar: TButton;
    l_display: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    l_teclado: TLabel;
    b_entrar: TButton;
    ledOff_dado: TSpeedButton;
    DecHex1: TMenuItem;
    GroupBox3: TGroupBox;
    LedOn_dado: TSpeedButton;
    b_reset: TButton;
    ledOn_exec: TSpeedButton;
    ledOff_exec: TSpeedButton;
    Label4: TLabel;
    Timer1: TTimer;
    Label3: TLabel;
    Label8: TLabel;
    b_recua: TButton;
    b_avanca: TButton;
    e_ender: TEdit;
    e_valor: TEdit;
    l_instrucao: TLabel;
    l_operInstrucao: TLabel;
    AbrirLingMquina1: TMenuItem;
    SalvarLingMquina1: TMenuItem;
    Ajuda1: TMenuItem;
    Sobreoprograma1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Novo1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    b_zera: TButton;
    b_Z: TButton;
    b_N: TButton;
    l_Z: TLabel;
    l_N: TLabel;
    ch128on: TSpeedButton;
    ch64on: TSpeedButton;
    ch32on: TSpeedButton;
    ch16on: TSpeedButton;
    ch8on: TSpeedButton;
    ch4on: TSpeedButton;
    ch2on: TSpeedButton;
    ch1on: TSpeedButton;
    ch128off: TSpeedButton;
    ch64off: TSpeedButton;
    ch32off: TSpeedButton;
    ch16off: TSpeedButton;
    ch8off: TSpeedButton;
    ch4off: TSpeedButton;
    ch2off: TSpeedButton;
    ch1off: TSpeedButton;
    Shape1: TShape;
    Label1: TLabel;
    cb_rapido: TCheckBox;
    Zerarmemria1: TMenuItem;
    Editar1: TMenuItem;
    Copiar1: TMenuItem;
    cOlar1: TMenuItem;
    Recortar1: TMenuItem;
    Desfazer1: TMenuItem;
    Panel1: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    CutBtn: TSpeedButton;
    CopyBtn: TSpeedButton;
    PasteBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    SpeedButton1: TSpeedButton;
    NewBnt: TSpeedButton;
    Ajuda2: TMenuItem;
    p_banner: TPanel;
    procedure b_pararClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure b_executarClick(Sender: TObject);
    procedure b_resetClick(Sender: TObject);
    procedure e_enderExit(Sender: TObject);
    procedure b_PCClick(Sender: TObject);
    procedure b_ACCClick(Sender: TObject);
    procedure b_recuaClick(Sender: TObject);
    procedure b_avancaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure e_valorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure e_valorExit(Sender: TObject);
    procedure b_passoAPassoClick(Sender: TObject);
    procedure DecHex1Click(Sender: TObject);
    procedure b_entrarClick(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Sobreoprograma1Click(Sender: TObject);
    procedure Assistente1Click(Sender: TObject);
    procedure Ajuda1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure SalvarComo1Click(Sender: TObject);
    procedure Novo1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure SalvarLingMquina1Click(Sender: TObject);
    procedure AbrirLingMquina1Click(Sender: TObject);
    procedure Compilar1Click(Sender: TObject);
    procedure b_zeraClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure b_ZClick(Sender: TObject);
    procedure b_NClick(Sender: TObject);
    procedure click_desliga(Sender: TObject);
    procedure click_liga(Sender: TObject);
    procedure cb_rapidoClick(Sender: TObject);
    procedure Zerarmemria1Click(Sender: TObject);
    procedure CutBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure Desfazer1Click(Sender: TObject);
    procedure Ajuda2Click(Sender: TObject);
    procedure limpaEditor;
  private
    { Private declarations }
    minWidth, minHeight: integer;
  public
    { Public declarations }
    procedure atualizaInterface;
    procedure mostraAlterado;
    procedure geraDump (ender: integer);
    procedure atualizaDump;
    procedure atualizaLeds;
  end;

var
  formPrincipal: TformPrincipal;
  enderAlterado: integer;
  nomeArq: string;
  execucaoRapida: boolean;

implementation

uses uHex, uAbout, uAutoPrg, uAjuda, uAssemb;

{$R *.lfm}

procedure TformPrincipal.atualizaInterface;
var instr, ender: integer;
    indir: string[1];
begin
    l_display.caption := intToHex (displayReg, 2);
    l_teclado.caption := intToHex (keyReg, 2);
    atualizaLeds;
    l_display.caption := intToHex (displayReg, 2);

    instr := (memoria[PC] shr 4) and $f;
    l_instrucao.caption := tabInstrucoes[instr];
    if instr in [0, 6, 15] then
        begin
            l_operInstrucao.Caption := '';
        end
    else
        begin
            indir := '';
            if (memoria[PC] and $1) <> 0 then indir := '@';
            ender := memoria[(PC+1) and $FF];
            l_operInstrucao.Caption := indir+intToHex (ender, 2);
        end;

    l_PC.caption := intToHex (PC, 2);
    l_ACC.caption := intToHex (ACC, 2);
    if ALU_N then l_N.Caption := '1' else l_N.Caption := '0';
    if ALU_Z then l_Z.Caption := '1' else l_Z.Caption := '0';

    p_banner.Caption := bannerReg;

    mostraAlterado;
    atualizaDump;
end;

procedure TformPrincipal.b_pararClick(Sender: TObject);
begin
    running := false;
    atualizaInterface;
end;

procedure TformPrincipal.Timer1Timer(Sender: TObject);
var i: integer;
begin
    if running then
        begin
            if execucaoRapida then
                begin
                    i := 0;
                    while running and (i <> 100) do
                        begin
                            executaInstrucao;
                            i := i + 1;
                        end;
                end
            else
                executaInstrucao;

            atualizaInterface;
        end
    else
        timer1.enabled := false;
end;

procedure TformPrincipal.b_executarClick(Sender: TObject);
begin
    running := true;
    atualizaInterface;
    timer1.enabled := true;
end;

procedure TformPrincipal.b_resetClick(Sender: TObject);
var salva: string;
begin
    running := false;
    salva := l_teclado.caption;   // não pode mudar o valor das chaves
    inicMaquina (false);
    keyReg := hexToInt (salva);
    bannerReg := '';

    atualizaInterface;
    dumpMem.TopIndex := 0;
    dumpMem.ItemIndex := 0;
end;

procedure TformPrincipal.b_PCClick(Sender: TObject);
var s: string;
begin
    running := false;
    atualizaLeds;
    s := intToHex (PC, 2);
    l_PC.caption := s;
    if inputQuery ('Informe', 'Novo valor do PC', s) then
        PC := hexToInt (s);
    atualizaInterface;
end;

procedure TformPrincipal.b_ACCClick(Sender: TObject);
var s: string;
begin
    running := false;
    atualizaLeds;
    s := intToHex (ACC, 2);
    l_ACC.caption := s;
    if inputQuery ('Informe', 'Novo valor do ACC', s) then
        ACC := hexToInt (s);
    atualizaInterface;
end;

procedure TformPrincipal.geraDump (ender: integer);
var
   enderInic: integer;
   s: string;
   i: integer;
begin
    enderInic := ender and $F8;
    s := intToHex (enderInic, 2) + ': ';
    for i := 0 to 7 do
        s := s + intToHex (memoria[enderInic+i], 2) + ' ';
    dumpMem.items [enderInic div 8] := s;
end;

procedure TformPrincipal.atualizaDump;
var enderInic: integer;
begin
    for enderInic := 0 to $ff do
        if enderInic mod 8 = 0 then
            geraDump (enderInic);
end;

procedure TformPrincipal.mostraAlterado;
begin
    e_ender.text := intToHex (enderAlterado, 2);
    e_valor.text := intToHex (memoria [enderAlterado], 2);
    e_valor.SelectAll;
    geraDump (enderAlterado);
    dumpMem.Selected [enderAlterado div 8] := true;
end;

procedure TformPrincipal.e_enderExit(Sender: TObject);
begin
    enderAlterado := hexToInt (e_ender.text) and $FF;
    mostraAlterado;
end;

procedure TformPrincipal.e_valorExit(Sender: TObject);
begin
    memoria [enderAlterado] := hexToInt (e_valor.text) and $FF;
    atualizaInterface;
end;

procedure TformPrincipal.b_recuaClick(Sender: TObject);
begin
    enderAlterado := (enderAlterado - 1) and $FF;
    mostraAlterado;
end;

procedure TformPrincipal.b_avancaClick(Sender: TObject);
begin
    enderAlterado := (enderAlterado + 1) and $FF;
    mostraAlterado;
end;

procedure TformPrincipal.e_valorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key = VK_RETURN then
        begin
            e_valorExit (Sender);
            b_avancaClick (Sender);
        end;
end;

procedure TformPrincipal.FormActivate(Sender: TObject);
begin
    atualizaInterface;
end;

procedure TformPrincipal.FormCreate(Sender: TObject);
var i: integer;
begin
    minWidth := width;
    minHeight := height;

    inicMaquina (true);

    dumpMem.clear;
    for i := 0 to $FF do
        if (i mod 8) = 0 then
             begin
                  dumpMem.AddItem ('', NIL);
                  geraDump (i);
             end;

    execucaoRapida := cb_rapido.Checked;
    limpaEditor;
end;

procedure TformPrincipal.b_passoAPassoClick(Sender: TObject);
begin
    running := false;

    executaInstrucao;
    atualizaInterface;
end;

procedure TformPrincipal.DecHex1Click(Sender: TObject);
begin
    formHex.visible := true;
end;

procedure TformPrincipal.atualizaLeds;
begin
    if running then
        begin
            ledOn_exec.Visible := true;
            ledOff_exec.Visible := false;
        end
    else
        begin
            ledOn_exec.Visible := false;
            ledOff_exec.Visible := true;
        end;

    if keyStatusReg <> 0 then
        begin
            ledOn_dado.Visible := true;
            ledOff_dado.Visible := false;
        end
    else
        begin
            ledOn_dado.Visible := false;
            ledOff_dado.Visible := true;
        end;
end;

procedure TformPrincipal.b_entrarClick(Sender: TObject);
begin
    keyStatusReg := 1;
    atualizaLeds;
end;

procedure TformPrincipal.Sair1Click(Sender: TObject);
begin
    if MessageDlg('Tudo foi salvo?',
              mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        Close;
end;

procedure TformPrincipal.Sobreoprograma1Click(Sender: TObject);
begin
    aboutBox.visible := true;
end;

procedure TformPrincipal.Assistente1Click(Sender: TObject);
begin
    formAutoMonta.visible := true;
end;

procedure TformPrincipal.Ajuda1Click(Sender: TObject);
begin
    formAjuda.visible := true;
end;

procedure TformPrincipal.Abrir1Click(Sender: TObject);
begin
    if openDialog1.Execute then
        begin
            nomeArq := openDialog1.FileName;
            editor.lines.LoadFromFile(nomeArq);
            caption := nomeArq + ' - Simulador do processador Neander/X';
        end;
end;

procedure TformPrincipal.SalvarComo1Click(Sender: TObject);
begin
    if nomeArq <> '' then
        SaveDialog1.FileName := nomeArq;

    if SaveDialog1.execute then
        begin
            nomeArq := SaveDialog1.FileName;
            if nomeArq <> '' then
                begin
                    editor.Lines.SaveToFile(nomeArq);
                    caption := nomeArq + ' - Simulador do processador Neander/X';
                end;
        end;
end;

procedure TformPrincipal.limpaEditor;
begin
    editor.clear;
    editor.lines.add (';---------------------------------------------------');
    editor.lines.add ('; Programa:');
    editor.lines.add ('; Autor:');
    editor.lines.add ('; Data:');
    editor.lines.add (';---------------------------------------------------');
    editor.SelStart := editor.GetTextLen;
end;

procedure TformPrincipal.Novo1Click(Sender: TObject);
begin
    if MessageDlg('Tudo foi salvo?',
              mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
    nomeArq := '';
    caption := 'Simulador do processador Neander/X';
    limpaEditor;
end;

procedure TformPrincipal.Salvar1Click(Sender: TObject);
begin
    if nomeArq <> '' then
        editor.Lines.SaveToFile(nomeArq)
    else
        salvarComo1Click (sender);
end;

procedure TformPrincipal.SalvarLingMquina1Click(Sender: TObject);
var i, ultEnderValido: integer;
    arq: textFile;
begin
    if saveDialog2.execute then
        begin
            if saveDialog2.filename = '' then exit;

            assignFile (arq, saveDialog2.filename);
            try
                rewrite (arq);
                ultEnderValido := 0;
                for i := $FF downto 1 do
                    if memoria[i] <> 0 then
                        begin
                            ultEnderValido := i;
                            break;
                        end;

                for i := 0 to ultEnderValido do
                    begin
                        write (arq, intToHex (memoria[i], 2));
                        if (i mod 8) = 7 then writeln (arq);
                    end;
                writeln (arq);
            finally
                closefile (arq);
            end;
        end;
end;

procedure TformPrincipal.AbrirLingMquina1Click(Sender: TObject);
var
    arq: textFile;
    x, s: string;
    ender: integer;
begin
    if openDialog2.execute then
        begin
            assignFile (arq, openDialog2.filename);
            try
                reset (arq);
                ender := 0;
                while not eof (arq) do
                    begin
                        readln (arq, s);
                        trim (s);
                        while s <> '' do
                            begin
                                x := copy (s, 1, 2);
                                delete (s, 1, 2);
                                memoria [ender] := hexToInt (x);
                                ender := ender + 1;
                            end;
                    end;
            finally
                closefile (arq);
            end;
        end;

    atualizaInterface;
end;

procedure TformPrincipal.Compilar1Click(Sender: TObject);
begin
    formAssembler.visible := true;
    compila (nomeArq);
    atualizaInterface;
end;

procedure TformPrincipal.b_zeraClick(Sender: TObject);
begin
    keyStatusReg := 0;
    atualizaInterface;
end;

procedure TformPrincipal.FormResize(Sender: TObject);
begin
    if width  < minWidth  then width  := minWidth;
    if height < minHeight then height := minHeight;
end;

procedure TformPrincipal.b_ZClick(Sender: TObject);
var s: string;
begin
    running := false;
    atualizaLeds;
    s := boolToStr (ALU_Z);
    if s[1] = '-' then delete (s, 1, 1);
    l_Z.caption := s;
    if inputQuery ('Informe', 'Novo valor do flag Z', s) then
        ALU_Z := s = '1';
    atualizaInterface;
end;

procedure TformPrincipal.b_NClick(Sender: TObject);
var s: string;
begin
    running := false;
    atualizaLeds;
    s := boolToStr (ALU_N);
    if s[1] = '-' then delete (s, 1, 1);
    l_N.caption := s;
    if inputQuery ('Informe', 'Novo valor do flag N', s) then
        ALU_N := s = '1';
    atualizaInterface;
end;

procedure TformPrincipal.click_desliga(Sender: TObject);
var b: integer;
begin
    b := (sender as TSpeedButton).tag;
    keyReg := keyReg and (not b);
    l_teclado.caption := intToHex (keyReg, 2);
    case b of
        128:  ch128off.Visible := true;
        64:   ch64off.Visible  := true;
        32:   ch32off.Visible  := true;
        16:   ch16off.Visible  := true;
        8:    ch8off.Visible   := true;
        4:    ch4off.Visible   := true;
        2:    ch2off.Visible   := true;
        1:    ch1off.Visible   := true;
    end;

    case b of
        128:  ch128on.Visible := false;
        64:   ch64on.Visible  := false;
        32:   ch32on.Visible  := false;
        16:   ch16on.Visible  := false;
        8:    ch8on.Visible   := false;
        4:    ch4on.Visible   := false;
        2:    ch2on.Visible   := false;
        1:    ch1on.Visible   := false;
    end;
end;

procedure TformPrincipal.click_liga(Sender: TObject);
var b: integer;
begin
    b := (sender as TSpeedButton).tag;
    keyReg := keyReg or b;
    l_teclado.caption := intToHex (keyReg, 2);
    case b of
        128:  ch128off.Visible := false;
        64:   ch64off.Visible  := false;
        32:   ch32off.Visible  := false;
        16:   ch16off.Visible  := false;
        8:    ch8off.Visible   := false;
        4:    ch4off.Visible   := false;
        2:    ch2off.Visible   := false;
        1:    ch1off.Visible   := false;
    end;

    case b of
        128:  ch128on.Visible := true;
        64:   ch64on.Visible  := true;
        32:   ch32on.Visible  := true;
        16:   ch16on.Visible  := true;
        8:    ch8on.Visible   := true;
        4:    ch4on.Visible   := true;
        2:    ch2on.Visible   := true;
        1:    ch1on.Visible   := true;
    end;
end;

procedure TformPrincipal.cb_rapidoClick(Sender: TObject);
begin
    execucaoRapida := (Sender as TCheckBox).checked;
end;

procedure TformPrincipal.Zerarmemria1Click(Sender: TObject);
begin
   zeraMemoria;
   atualizaInterface;
   dumpmem.Selected[0] := true;
end;

procedure TformPrincipal.CutBtnClick(Sender: TObject);
begin
    editor.CutToClipboard;
end;

procedure TformPrincipal.CopyBtnClick(Sender: TObject);
begin
    editor.CopyToClipboard;
end;

procedure TformPrincipal.PasteBtnClick(Sender: TObject);
begin
    editor.PasteFromClipboard;
end;

procedure TformPrincipal.Desfazer1Click(Sender: TObject);
begin
    editor.Undo;
end;

procedure TformPrincipal.Ajuda2Click(Sender: TObject);
begin
     OpenDocument('neanderwin.chm'); { *Converted from ShellExecute*  }
end;

end.
