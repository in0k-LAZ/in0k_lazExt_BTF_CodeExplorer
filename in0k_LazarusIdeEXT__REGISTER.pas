unit in0k_LazarusIdeEXT__REGISTER;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses in0k_lazarusIdePLG__wndStllt_CE4SE;

procedure REGISTER;

implementation

procedure REGISTER;
begin
    // оно САМО "пропишется" в IDE, и так-же САМО "отпишется" при закрытии
    tIn0k_LazIdeEXT__wndStllte_CE4SE.CREATE;
end;

end.

