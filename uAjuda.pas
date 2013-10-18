unit uAjuda;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileUtil;

type
  TformAjuda = class(TForm)
    memoAjuda: TMemo;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formAjuda: TformAjuda;

implementation

{$R *.lfm}

procedure TformAjuda.FormActivate(Sender: TObject);
begin
    if FileExistsUTF8('neanderwin.txt') { *Converted from FileExists*  } then
        memoAjuda.Lines.LoadFromFile ('neanderwin.txt')
    else
        begin
            memoAjuda.Clear;
            memoAjuda.lines.add ('Arquivo neanderwin.txt não foi achado.');
            memoAjuda.lines.add ('Ajuda não está disponível.');
        end;
end;

end.
