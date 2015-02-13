unit in0k_lazExt_aBTF_CodeExplorer_REG;

{$mode objfpc}{$H+}

interface

{$I in0k_lazExt_aBTF_CodeExplorer_INI.inc}

uses {$ifDef lazExt_aBTF_CodeExplorer_DEBUG_mode}lazExt_aBTF_CodeExplorer_DEBUG,{$endIf}
     lazExt_aBTF_CodeExplorer;

procedure REGISTER;

implementation

var _BTF_CodeExplorer_:tLazExt_BTF_CodeExplorer;

procedure REGISTER;
begin
   _BTF_CodeExplorer_:=tLazExt_BTF_CodeExplorer.Create;
   _BTF_CodeExplorer_.RegisterInIdeLAZARUS;
    {$ifDef lazExt_aBTF_CodeExplorer_DEBUG_mode}
    lazExt_aBTF_CodeExplorer_DEBUG.RegisterInIdeLAZARUS;
    {$endIf}
end;

initialization
   _BTF_CodeExplorer_:=NIL;
finalization
   _BTF_CodeExplorer_.FREE;
end.

