unit uassemb;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uHex, uSimula;

type
  TformAssembler = class(TForm)
    listagem: TMemo;
    b_clipboard: TButton;
    procedure FormCreate(Sender: TObject);
    procedure b_clipboardClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure mostraErro (s: string);
  end;

var
  formAssembler: TformAssembler;
  numErros: integer;

procedure compila (nome: string);

implementation

uses uNeander;

type
    TTipoOper = (nulo, operacao, org, equ, ds, db, _end, coment, invalido);

    TInfoSimbolo = class
        linha: integer;
        ender: integer;
    end;

{$R *.lfm}

var
    tabOper: TStringList;
    tabSimbolos: TStringList;

    lc: integer;    {location counter}
    nomeArq: string;
    passo: integer;

procedure TformAssembler.FormCreate(Sender: TObject);
begin
    tabOper := TStringList.create;
end;

procedure TformAssembler.mostraErro (s: string);
begin
    listagem.lines.add ('********* Erro: ' + s);
    numErros := numErros + 1;
end;

procedure inicAssembler;
begin
    tabSimbolos := TStringList.create;
    tabSimbolos.sorted := true;
    numErros := 0;
end;

function pegaToken (var s: string): string;
var
    p: integer;
    token: string;
begin
    p := pos (' ', s);
    if p = 0 then p := length(s)+1;
    token := copy (s, 1, p-1);
    delete (s, 1, p);
    s := trim (s);

    for p := 1 to length (token) do
        token[p] := upcase (token[p]);

    pegaToken := token;
end;

function compilaLinha (s: string; var tipoInstrucao: TTipoOper;
                        var rotulo: string;
                        var instrucao: integer;
                        var operando: string;
                        var indireto: boolean ;
                        var exigeOperando: boolean): boolean;
var i: integer;
    token, salva: string;
    erro: boolean;

label checaOperando, veSeTerminou, fimTokens;

begin
    erro := false;
    tipoInstrucao := nulo;
    rotulo := '';
    instrucao := -1;
    operando := '';
    indireto := false;
    exigeOperando := false;

// verifica rótulo

    token := pegaToken (s);
    if (token = '') or (token[1] = ';') then goto fimTokens;
    if token [length(token)] = ':' then
        begin
            rotulo := copy (token, 1, length(token)-1);
            token := pegaToken (s);
        end;

// verifica operação

    if (token = '') or (token[1] = ';') then goto fimTokens;

    for i := 0 to 15 do
        if tabInstrucoes[i] = token then
            begin
                instrucao := i;
                tipoInstrucao := operacao;
                exigeOperando := (token <> 'NOP') and
                                 (token <> 'NOT') and
                                 (token <> 'HLT');
                goto checaOperando;
            end;

    if token = 'ORG' then
        begin
            if rotulo <> '' then
                begin
                    if passo = 2 then
                        formAssembler.mostraErro ('Rótulo não pode vir em END ou ORG');
                    erro := true;
                end;
            tipoInstrucao := org;
            exigeOperando := true;
            goto checaOperando;
        end;

    if token = 'DS' then
        begin
            tipoInstrucao := ds;
            exigeOperando := true;
            goto checaOperando;
        end;

    if token = 'DB' then
        begin
            tipoInstrucao := db;
            exigeOperando := true;
            goto checaOperando;
        end;

    if token = 'END' then
        begin
            if rotulo <> '' then
                begin
                    if passo = 2 then
                        formAssembler.mostraErro ('Rótulo não pode vir em END ou ORG');
                    erro := true;
                end;
            tipoInstrucao := _end;
            exigeOperando := true;
            goto checaOperando;
        end;

    salva := token;    // pode ser um equ
    token := pegaToken (s);
    if token = 'EQU' then
        begin
            rotulo := salva;
            tipoInstrucao := equ;
            exigeOperando := true;
            goto checaOperando;
        end;

    tipoInstrucao := invalido;
    if passo = 2 then
        formAssembler.mostraErro ('Instrução não reconhecida');
    erro := true;
    goto fimTokens;

// verifica operando

checaOperando:
    token := pegaToken (s);
    if (token <> '') and (token [1] = '@') then
        begin
            indireto := true;
            delete (token, 1, 1);
        end;

    if (token = '') or (token[1] = ';') then
        if exigeOperando then
            begin
                if passo = 2 then
                    formAssembler.mostraErro ('Faltou operando');
                erro := true;
            end
        else
            goto fimTokens
    else
        if not exigeOperando then
            begin
                if passo = 2 then
                    formAssembler.mostraErro ('Instrução não usa operando');
                erro := true;
            end;

    operando := token;

// vê se terminou

veSeTerminou:
    token := pegaToken (s);
    if (token <> '') and (token[1] <> ';') then
        begin
            if passo = 2 then
                formAssembler.mostraErro ('Comentário mal formado');
            erro := true;
        end;

fimTokens:
    compilaLinha := not erro;
end;

procedure fimAssembler;
var i: integer;
begin
    if numErros <> 0 then
        begin
            formAssembler.listagem.lines.add ('');
            formAssembler.listagem.lines.add ('Número de erros encontrados: ' +
                 intToStr (numErros));
        end;

    for i := 0 to tabSimbolos.count-1 do
        tabSimbolos.Objects[i].Free;
    tabSimbolos.Free;
end;

function pegaValor (s: string; valorMaximo: integer;
                    var erro: boolean): integer;
var i, valor: integer;
begin
    pegaValor := 0;
    erro := true;
    if s = '' then exit;

    if not (upcase(s[1]) in ['0'..'9']) then exit;

    if upcase (s[length(s)]) = 'H' then
        begin
            delete (s, length(s), 1);
            for i := 2 to length (s)-1 do
                if not (upcase(s[i]) in ['0'..'9', 'A'..'F']) then exit;
            valor := hexToInt (s);
        end
    else
        begin
            for i := 2 to length (s) do
                if not (upcase(s[i]) in ['0'..'9']) then exit;
            valor := strToInt (s);
        end;

    if valor > valorMaximo then exit;

    erro := false;
    pegaValor := valor;
end;

procedure insereTabSimb (rotulo: string; linha, valor: integer);
var infoSimb: TInfoSimbolo;
    i: integer;
begin
    infoSimb := TInfoSimbolo.create;
    infoSimb.linha := linha;
    infoSimb.Ender := valor;

    if tabSimbolos.Find(rotulo, i) then
        formAssembler.mostraErro (rotulo + ' - rótulo duplicado')
    else
       tabSimbolos.AddObject(rotulo, infoSimb);
end;

procedure passo1;
var l: integer;
    s: string;
    tipoInstrucao: TTipoOper;
    rotulo, operando: string;
    instrucao: integer;
    exigeOperando: boolean;
    indireto: boolean;
    erro: boolean;
begin
    passo := 1;
    lc := 0;
    with formPrincipal do
        for l := 0 to editor.Lines.Count-1 do
            begin
                s := editor.lines[l];
                s := trim (s);
                if (s = '') or (s[1] = ';') then continue;

                compilaLinha (s, tipoInstrucao, rotulo, instrucao, operando, indireto, exigeOperando);

                if tipoInstrucao <> equ then
                    if rotulo <> '' then
                        insereTabSimb (rotulo, l, lc);

                case tipoInstrucao of
                    operacao:  if exigeOperando then
                                   lc := lc + 2
                               else
                                   lc := lc + 1;
                    org:       lc := pegaValor (operando, $ff, erro);
                    equ:       insereTabSimb (rotulo, l, pegaValor (operando, $ff, erro));
                    ds:        lc := lc + pegaValor (operando, $ff, erro);
                    db:        lc := lc + 1;
                end;
            end;
end;

function pegaValorOuSimbolo (operando: string): integer;
var i: integer;
    erro: boolean;
begin
    erro := false;
    if operando = '' then
        pegaValorOuSimbolo := 0
    else
        if tabSimbolos.Find(operando, i) then
            pegaValorOuSimbolo := (tabSimbolos.Objects[i] as TInfoSimbolo).ender
        else
            begin
                i := pegaValor (operando, $ff, erro);
                if erro then
                    begin
                        formAssembler.mostraErro('Operando inválido ou não encontrado');
                        pegaValorOuSimbolo := 0;
                    end
                else
                    pegaValorOuSimbolo := i;
            end;
end;

procedure passo2 (listagem: TMemo);
var l: integer;
    s, numS, enderS, codS: string;
    tipoInstrucao: TTipoOper;
    rotulo, operando: string;
    instrucao: integer;
    indireto: boolean;
    exigeOperando: boolean;
    x: integer;
    erro: boolean;
begin
    passo := 2;
    listagem.lines.add ('');

    lc := 0;
    with formPrincipal do
        for l := 0 to editor.Lines.Count-1 do
            begin
                str (l+1:4, numS);
                enderS := '    ';
                codS   := '        ';

                s := trim (editor.lines[l]);
                if (s <> '') and (s[1] <> ';') then
                    begin
                        compilaLinha (s, tipoInstrucao, rotulo, instrucao, operando, indireto, exigeOperando);
                        if indireto and (tipoInstrucao in [org, equ, ds, db, _end]) then
                            formAssembler.mostraErro('Uso incorreto de operando indireto');

                        case tipoInstrucao of
                            operacao:
                                   begin
                                        memoria[lc] := instrucao shl 4 +
                                                       (integer(indireto) and 1);
                                        enderS := intToHex (lc, 2);
                                        codS := intToHex (memoria[lc],2);
                                        lc := lc + 1;
                                        if exigeOperando then
                                            begin
                                                memoria[lc] := pegaValorOuSimbolo (operando);
                                                codS := codS + ' ' + intToHex (memoria[lc],2);
                                                lc := lc + 1;
                                            end;
                                        codS := copy (codS + '       ', 1, 10);
                                   end;

                            org:   begin
                                       lc := pegaValor (operando, $ff, erro);
                                       if erro then
                                            formAssembler.mostraErro('Origem inválida');
                                   end;
                            equ:   ;
                            ds:    begin
                                        enderS := intToHex (lc, 2);
                                        x := pegaValor (operando, $ff, erro);
                                        if erro then
                                             begin
                                                 formAssembler.mostraErro('Operando inválido');
                                                 x := 1;
                                             end;
                                        lc := lc + x;
                                   end;
                            db:    begin
                                        enderS := intToHex (lc, 2);
                                        x := pegaValor (operando, $ff, erro);
                                        if erro then
                                             formAssembler.mostraErro('Operando inválido')
                                        else
                                            begin
                                                memoria[lc] := x;
                                                codS := copy (intToHex (x, 2) + '       ', 1, 10);
                                            end;
                                        lc := lc + 1;
                                   end;

                            _end:  PC := pegaValorOuSimbolo (operando);
                        end;
                    end;

                s := copy (numS+ '          ', 1, 5);
                s := s + '  ' + copy (enderS + '          ', 1, 5);
                s := s + '  ' + copy (cods   + '          ', 1, 8);
                s := s + '  ' + editor.lines[l];
                listagem.lines.add (s);
            end;
end;

procedure listaTabSimbolos;
var i: integer;
    s1, s2, s3: string;
begin
    formAssembler.listagem.lines.add ('Símbolo         Linha   Endereço');

    for i := 0 to tabSimbolos.count-1 do
        begin
            s1 := tabSimbolos[i];
            s1 := s1 + '               ';
            while length (s1) > 15 do delete (s1, length(s1), 1);

            s2 := intToStr ((tabSimbolos.objects[i] as TInfoSimbolo).linha);
            s2 := '       ' + s2;
            while length (s2) > 6 do delete (s2, 1, 1);

            s3 := intToHex ((tabSimbolos.objects[i] as TInfoSimbolo).ender, 3);
            s3 := '       ' + s3;
            while length (s3) > 6 do delete (s3, 1, 1);

            formAssembler.listagem.lines.add (s1+s2+s3);
        end;
end;

procedure compila (nome: string);
begin
    nomeArq := nome;

    with formAssembler, listagem do
        begin
            listagem.clear;
            lines.add ('Compilação (assembly) do texto ' + nomeArq);
            lines.add ('Em ' + dateTimeToStr(date));

            inicAssembler;

            passo1;               {descobre endereços dos símbolos}
            passo2 (listagem);    {gera código}

            if tabSimbolos.count  <> 0 then
                begin
                    listagem.lines.add ('');
                    listagem.lines.add ('Listagem da tabela de símbolos');
                    listagem.lines.add ('');

                    listaTabSimbolos;
                end;

            fimAssembler;
        end;
end;

procedure TformAssembler.b_clipboardClick(Sender: TObject);
begin
    if listagem.SelLength = 0 then
        begin
            listagem.SelectAll;
            listagem.CopyToClipboard;
            listagem.SelLength := 0;
        end
    else
        listagem.CopyToClipboard;
end;

end.
