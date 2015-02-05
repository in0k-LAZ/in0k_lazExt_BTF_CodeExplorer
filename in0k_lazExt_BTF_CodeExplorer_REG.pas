unit in0k_lazExt_BTF_CodeExplorer_REG;

{$mode objfpc}{$H+}


interface

{$I in0k_lazExt_BTF_CodeExplorer_INI.ini}
{$ifDef in0k_lazExt_DEBUG_mode}
    {$define _DEBUG_}
{$else}
    {$undef  _DEBUG_}
{$endIf}
{$ifDef _DEBUG_}
    {$undef  _INLINE_}
{$else}
    {$define _INLINE_}
{$endIf}


uses {$ifDef _DEBUG_}in0kLazExt_wndDBG,{$endIf}
     lazExt_BTF_CodeExplorer,
     PropEdits;

procedure REGISTER;

implementation

var _BTF_CodeExplorer_:tLazExt_BTF_CodeExplorer;

procedure REGISTER;
begin
   _BTF_CodeExplorer_:=tLazExt_BTF_CodeExplorer.Create;
   _BTF_CodeExplorer_.RegisterInIdeLAZARUS;
    {$ifDef _DEBUG_}
    in0kLazExt_wndDBG.RegisterInIDE('[DEBUG] lazExt_BTF_CodeExplorer','[DEBUG] lazExt_BTF_CodeExplorer');
    {$endIf}
end;

initialization
   _BTF_CodeExplorer_:=NIL;
finalization
   _BTF_CodeExplorer_.FREE;
end.

