unit uAutoPrg;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uNeander, Clipbrd;

type
  TformAutoMonta = class(TForm)
    b_nop: TButton;
    b_sta: TButton;
    b_lda: TButton;
    b_add: TButton;
    b_or: TButton;
    b_and: TButton;
    b_not: TButton;
    b_sub: TButton;
    b_jmp: TButton;
    b_jn: TButton;
    b_jz: TButton;
    b_ldi: TButton;
    b_in: TButton;
    b_out: TButton;
    b_jnz: TButton;
    b_hlt: TButton;
    Label1: TLabel;
    l_descricao: TLabel;
    l_oper: TLabel;
    e_operando: TEdit;
    b_incluir: TButton;
    b_org: TButton;
    b_equ: TButton;
    b_end: TButton;
    b_ds: TButton;
    b_db: TButton;
    e_comentario: TEdit;
    b_coment: TButton;
    b_rotulo: TButton;
    l_instr: TLabel;
    c_indireto: TCheckBox;
    e_rotulo: TEdit;
    l_rotulo: TLabel;
    procedure b_nopClick(Sender: TObject);
    procedure b_staClick(Sender: TObject);
    procedure b_incluirClick(Sender: TObject);
    procedure b_ldaClick(Sender: TObject);
    procedure b_addClick(Sender: TObject);
    procedure b_orClick(Sender: TObject);
    procedure b_andClick(Sender: TObject);
    procedure b_notClick(Sender: TObject);
    procedure b_subClick(Sender: TObject);
    procedure b_jmpClick(Sender: TObject);
    procedure b_jnClick(Sender: TObject);
    procedure b_jzClick(Sender: TObject);
    procedure b_ldiClick(Sender: TObject);
    procedure b_inClick(Sender: TObject);
    procedure b_outClick(Sender: TObject);
    procedure b_jnzClick(Sender: TObject);
    procedure b_hltClick(Sender: TObject);
    procedure b_orgClick(Sender: TObject);
    procedure b_equClick(Sender: TObject);
    procedure b_endClick(Sender: TObject);
    procedure b_dsClick(Sender: TObject);
    procedure b_dbClick(Sender: TObject);
    procedure b_comentClick(Sender: TObject);
    procedure b_rotuloClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formAutoMonta: TformAutoMonta;

implementation

var
  operador: string;

{$R *.lfm}

procedure TformAutoMonta.b_incluirClick(Sender: TObject);
var s: string;
begin
    s := '';
    if operador = ';' then
        s := '; ' + e_comentario.text
    else
    if operador = ':' then
        s := e_operando.text + ':'
    else
        begin
            if e_rotulo.visible then
                begin
                    s := e_rotulo.text;
                    if operador <> 'EQU ' then s := s + ':';
                end;
            s := copy (s+ '          ', 1, 10);

            if c_indireto.visible and c_indireto.checked then
                s := s + operador + ' @' + e_operando.text
            else
                s := s + operador + ' ' + e_operando.text;
        end;

    if (operador <> ';') and (e_comentario.Text <> '') then
    begin
        while length (s) < 30 do s := s + ' ';
        s := s + '; ' + e_comentario.text;
    end;

    s := s + #$0d + #$0a;
    Clipboard.SetTextBuf(@s[1]);
    formPrincipal.editor.PasteFromClipboard;

    e_operando.text := '';
    e_comentario.text := '';
end;

procedure TformAutoMonta.b_nopClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := false;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := false;

    l_descricao.caption :=
        'O comando NOP é usado apenas para gastar tempo.';
    operador := 'NOP ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_staClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando STA transfere o valor do acumulador para a ' +
        'posição de memória indicada pelo operando.';
    operador := 'STA ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_ldaClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando LDA atribui ao acumulador o conteúdo da posição de ' +
        'memória indicada pelo operando.';
    operador := 'LDA ';
end;

procedure TformAutoMonta.b_addClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando ADD soma ao acumulador o conteúdo de uma posição de ' +
        'memória indicada pelo operando.';
    operador := 'ADD ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_orClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando OR realiza um "ou" lógico entre o acumulador e o conteúdo ' +
        ' de uma posição de memória indicada pelo operando.';
    operador := 'OR  ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_andClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando AND realiza um "e" lógico entre o acumulador e o conteúdo ' +
        ' de uma posição de memória indicada pelo operando.';
    operador := 'AND ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_notClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := false;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := false;

    l_descricao.caption :=
        'O comando NOT inverte os bits do acumulador';
    operador := 'NOT ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_subClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando SUB subtrai do acumulador o conteúdo de uma posição de ' +
        'memória indicada pelo operando.';
    operador := 'SUB ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_jmpClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando JMP (jump) desvia a execução do programa para ' +
        'o endereço indicado pelo operando.';
    operador := 'JMP ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_jnClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando JN (jump if negative) desvia a execução do programa ' +
        'para o endereço indicado pelo operando, apenas quando a última ' +
        'operação realizada produziu um valor com o bit 7 ligado.';
    operador := 'JN  ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_jzClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando JZ (jump if zero) desvia a execução do programa ' +
        'para o endereço indicado pelo operando, apenas quando a última ' +
        'operação realizada produziu um valor zero';
    operador := 'JZ  ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_ldiClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando LDI (load immediate) carrega no acumulador o valor '+
        'imediato dado pelo operando.';
    operador := 'LDI ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_inClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando IN (input) carrega no acumulador o ' +
        'valor lido num dispositivo externo indicado pelo operando.  Nesse '+
        'simulador os dispositivos são: chaves (endereço 0) e o status ' +
        'de "dado disponível" das chaves (endereço 1).';
    operador := 'IN  ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_outClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando OUT (output) transfere o valor do acumulador para ' +
        'um dispositivo externo indicado pelo operando.  Nesse '+
        'simulador o único dispositivo disponível é um visor '+
        '(endereço 0).';
    operador := 'OUT ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_jnzClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := true;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'O comando JNZ (jump if not zero) desvia a execução do programa ' +
        'para o endereço indicado pelo operando ender, apenas quando a ' +
        'última operação realizada produziu um valor diferente de ' +
        'zero.';
    operador := 'JNZ ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_hltClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := false;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := false;

    l_descricao.caption :=
        'O comando HLT (halt) para a máquina.';
    operador := 'HLT ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_orgClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'A pseudo-instrução ORG (origin) indica ao assembler ' +
        'a posição de memória onde será colocada a próxima instrução.';
    operador := 'ORG ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_equClick(Sender: TObject);
begin
    e_rotulo.visible := true;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := true;
    l_oper.visible := true;

    l_descricao.caption :=
        'A pseudo-instrução EQU (equate) atribui um nome a um certo valor.' +
        'Esse comando é frequentemente usado para especificar variáveis que ' +
        'são posicionadas em certo endereço de memória.'+#$0d+
        'Por exemplo para posicionar a variável x no endereço hexa f0 use:'#$0d+
        '            X EQU 0F0H';
    operador := 'EQU ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_endClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

        l_descricao.caption :=
        'A pseudo-instrução END indica que o programa fonte acabou.  '+
        'O operando é usado para pré-carregar o PC com o endereço inicial de ' +
        'execução do programa.';
    operador := 'END ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_dsClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'A pseudo-instrução DS (define storage) reserva um número de ' +
        'palavras na memória definido pelo operando.';
    operador := 'DS  ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_dbClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'A pseudo-instrução DB (define bytes) carrega nesta palavra ' +
        'de memória o valor definido pelo operando.';
    operador := 'DB  ';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_comentClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := false;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := false;

    l_descricao.caption :=
        'Os comentários são começados por ponto e vírgula.';
    operador := ';';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.b_rotuloClick(Sender: TObject);
begin
    e_rotulo.visible := false;
    e_operando.visible := true;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := true;

    l_descricao.caption :=
        'Um rótulo é um nome dado à próxima posição de memória. ' +
        'O nome é seguido por dois pontos';
    operador := ':';
    l_instr.caption := operador;
end;

procedure TformAutoMonta.FormCreate(Sender: TObject);
begin
    operador := '';

    l_instr.caption := operador;
    e_rotulo.visible := false;
    e_operando.visible := false;
    c_indireto.visible := false;
    l_rotulo.visible := false;
    l_oper.visible := false;
end;

end.
