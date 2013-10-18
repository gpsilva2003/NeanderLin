unit uSimula;

{$MODE Delphi}

interface

const               { códigos das instruções }
    _NOP  = 0;
    _STA  = 1;
    _LDA  = 2;
    _ADD  = 3;
    _OR   = 4;
    _AND  = 5;
    _NOT  = 6;
    _SUB  = 7;
    _JMP  = 8;
    _JN   = 9;
    _JZ   = 10;
    _JNZ  = 11;
    _IN   = 12;
    _OUT  = 13;
    _LDI  = 14;
    _HLT  = 15;

const
    tabInstrucoes: array [0..15] of string[8] =
        ('NOP', 'STA', 'LDA', 'ADD', 'OR',  'AND', 'NOT', 'SUB',
         'JMP', 'JN',  'JZ',  'JNZ', 'IN',  'OUT', 'LDI', 'HLT');

const
    MAXMEMORIA = $ff;

type
    int4  = integer;
    int8  = integer;

var
    ACC: int8;
    PC:  int8;

    ALU_N: boolean;
    ALU_Z: boolean;

    instReg: int4;
    operandReg: int8;
    endIndireto: boolean;

    displayReg: int8;      // endereço 0 de E/S
    keyReg: int8;          // endereço 0
    keyStatusReg: int8;    // endereço 1
    bannerReg: string;     // endereço 2

    memoria: array [0..MAXMEMORIA] of int8;

    running: boolean;

procedure zeraMemoria;
procedure inicMaquina (zerando: boolean);
procedure executaInstrucao;

implementation

procedure zeraMemoria;
var i: integer;
begin
    for i := 0 to $FF do
        memoria[i] := 0;
end;

procedure inicMaquina (zerando: boolean);
begin
    if zerando then zeraMemoria;
    PC := 0;
    ACC := 0;
    ALU_N := false;
    ALU_Z := false;

    displayReg := 0;
    keyReg:= 0;
    keyStatusReg:= 0;
end;

{----------------------------------------------------}

procedure atualizaNZ;
begin
    ALU_N := (ACC and $80) <> 0;
    ALU_Z := ACC = 0;
end;

{----------------------------------------------------}

procedure executaInstrucao;
begin
    instReg     := memoria[PC] shr 4;       { busca instrucao e decodifica }
    endIndireto := boolean(memoria[PC] and 1);
    PC := (PC + 1) and $FF;                { incrementa PC }

    operandReg := 0;
    if not (instReg in [_NOP, _NOT, _HLT]) then
        begin
            operandReg := memoria[PC] and $FF;
            if endIndireto then
                operandReg := memoria [operandReg];
            PC := (PC + 1) and $FF;                { incrementa PC }
        end;


    case instReg of
        _NOP :  ;
        _STA :  memoria [operandReg] := ACC;
        _LDA :  begin
                    ACC := memoria [operandReg];
                    atualizaNZ;
                end;
        _ADD :  begin
                    ACC := (ACC + memoria [operandReg]) and $FF;
                    atualizaNZ;
                end;
        _OR  :  begin
                    ACC := ACC or memoria [operandReg];
                    atualizaNZ;
                end;
        _AND :  begin
                    ACC := ACC and memoria [operandReg];
                    atualizaNZ;
                end;
        _NOT :  begin
                    ACC := ACC xor $ff;
                    atualizaNZ;
                end;
        _SUB :  begin
                    ACC := (ACC - memoria [operandReg]) and $FF;
                    atualizaNZ;
                end;
        _JMP :  PC := operandReg;
        _JN  :  if ALU_N then PC := operandReg;
        _JZ  :  if ALU_Z then PC := operandReg;
        _JNZ :  if not ALU_Z then PC := operandReg;

        _LDI :   begin
                     ACC := operandReg;
                     atualizaNZ;
                 end;
        _IN  :   case operandReg of
                        0: begin
                                ACC := keyReg;
                                keyStatusReg := 0;
                           end;
                        1: ACC := keyStatusReg;
                  end;
        _OUT  :   case operandReg of
                        0: displayReg := ACC;
                        2: begin
                               BannerReg := BannerReg + chr(ACC);
                               while length (BannerReg) > 20 do
                                   delete (BannerReg, 1, 1);
                           end;
                        3: BannerReg := '';
                  end;
        _HLT  :   begin
                        running := false;
                        PC := (PC - 1) and $FFF;
                  end;
    end;
end;

end.
