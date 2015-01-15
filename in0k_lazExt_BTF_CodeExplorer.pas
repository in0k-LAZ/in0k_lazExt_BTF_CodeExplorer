{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_lazExt_BTF_CodeExplorer;

interface

uses
  BTF_CodeExplorer, in0k_lazExt_CEwBTF_CORE, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_lazExt_CEwBTF_CORE', @in0k_lazExt_CEwBTF_CORE.Register);
end;

initialization
  RegisterPackage('in0k_lazExt_BTF_CodeExplorer', @Register);
end.
