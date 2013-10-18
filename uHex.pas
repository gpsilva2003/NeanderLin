unit uHex;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TformHex = class(TForm)
    Edit1: TEdit;
    l_resposta: TLabel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    de_binario: TRadioButton;
    de_decimal: TRadioButton;
    de_hexa: TRadioButton;
    GroupBox2: TGroupBox;
    para_binario: TRadioButton;
    para_decimal: TRadioButton;
    para_hexa: TRadioButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formHex: TformHex;

function hexToInt (s: string): integer;

implementation

{$R *.lfm}

function hexToInt (s: string): integer;
var i, b: integer;
    valor: integer;
begin
    trim(s);
    valor := 0;
    for i := 1 to length (s) do
        begin
            b := ord(upcase(s[i]));
            if b >= ord('A') then b := b - 7;
            b := b and $f;
            valor := (valor shl 4) or b;
        end;
    hexToInt := valor;
end;

procedure TformHex.Button1Click(Sender: TObject);
var s: string;
    i, valor: integer;
const
    tabbin: set of char = ['0', '1'];
    tabdec: set of char = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    tabhex: set of char = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                           'A', 'B', 'C', 'D', 'E', 'F'];
label erro;
begin
    s := edit1.text;
    trim (s);

    if de_binario.checked then
        begin
            valor := 0;
            for i := 1 to length (s) do
               begin
                   if not (s[i] in tabbin) then goto erro;
                   valor := (valor shl 1) or (ord(s[i]) and 1);
               end;
        end
    else
    if de_decimal.checked then
        begin
            for i := 1 to length (s) do
               if not (s[i] in tabdec) then goto erro;
            valor := strToInt(s)
        end
    else
        begin
            for i := 1 to length (s) do
               if not (upcase(s[i]) in tabhex) then goto erro;
            valor := hexToInt (s);
        end;

    if para_binario.Checked then
        begin
            s := '';
            for i := 1 to 16 do
                begin
                    s := chr (valor and 1 + ord('0')) + s;
                    valor := valor shr 1;
                end;
        end
    else
    if para_decimal.Checked then
        s := intToStr (valor)
    else
        s := intToHex (valor, 4);

    l_resposta.caption := s;
    exit;

erro:
    showMessage ('Valor digitado inconsistente com a base especificada');
end;

end.
