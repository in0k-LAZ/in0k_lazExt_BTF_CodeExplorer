unit in0k_lazExt_BTF_CodeExplorer_MAIN;

{$mode objfpc}{$H+}

interface

uses BTF_CodeExplorer;

procedure REGISTER;


procedure lazExt_BTF_CodeExplorer_SET(const value:tBTF_CodeExplorer);

implementation

var _BTF_CodeExplorer_:tBTF_CodeExplorer;

procedure lazExt_BTF_CodeExplorer_SET(const value:tBTF_CodeExplorer);
begin
   if not Assigned(_BTF_CodeExplorer_) then _BTF_CodeExplorer_:=value;
end;

procedure REGISTER;
begin
   _BTF_CodeExplorer_:=tBTF_CodeExplorer.Create;
   _BTF_CodeExplorer_.RegisterInIdeLAZARUS;
end;

initialization
 _BTF_CodeExplorer_:=NIL;
finalization
 _BTF_CodeExplorer_.FREE;
end.

