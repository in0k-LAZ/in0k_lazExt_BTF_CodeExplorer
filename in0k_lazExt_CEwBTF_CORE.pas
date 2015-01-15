unit in0k_lazExt_CEwBTF_CORE;

{$mode objfpc}{$H+}

interface

uses BTF_CodeExplorer,
  Classes, SysUtils;

procedure Register;

implementation

var asd:tBTF_CodeExplorer;


procedure Register;
begin
   asd:=tBTF_CodeExplorer.Create;
end;

end.

