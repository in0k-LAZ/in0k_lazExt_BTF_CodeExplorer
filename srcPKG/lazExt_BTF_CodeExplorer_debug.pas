unit lazExt_BTF_CodeExplorer_debug;

{$mode objfpc}{$H+}

interface

uses sysutils, in0kLazExt_wndDBG;

procedure DEBUG(const msgTYPE,msgTEXT:string);

function _addr2str_(const p:pointer):string; inline;
function _addr2txt_(const p:pointer):string; inline;

implementation

function _addr2str_(const p:pointer):string;
begin
    result:=IntToHex({%H-}PtrUint(p),sizeOf(PtrUint)*2);
end;

const _c_addr2txt_SMB_='$';

function _addr2txt_(const p:pointer):string;
begin
    result:=_c_addr2txt_SMB_+_addr2str_(p);
end;

procedure DEBUG(const msgTYPE,msgTEXT:string);
begin
    in0kLazExtWndDBG_Message(msgTYPE,msgTEXT);
end;

end.

