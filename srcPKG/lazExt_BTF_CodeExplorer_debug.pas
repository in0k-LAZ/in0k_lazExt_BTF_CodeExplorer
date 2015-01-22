unit lazExt_BTF_CodeExplorer_debug;

{$mode objfpc}{$H+}

interface

uses in0kLazExt_wndDBG;

procedure DEBUG(const msgTYPE,msgTEXT:string);

implementation

procedure DEBUG(const msgTYPE,msgTEXT:string);
begin
    in0kLazExtWndDBG_Message(msgTYPE,msgTEXT);
end;

end.

