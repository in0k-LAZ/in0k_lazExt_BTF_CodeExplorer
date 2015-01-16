{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_lazExt_BTF_CodeExplorer;

interface

uses
  lazExt_BTF_CodeExplorer, in0k_lazExt_BTF_CodeExplorer_MAIN, 
  lazExt_BTF_CodeExplorer_debug, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_lazExt_BTF_CodeExplorer_MAIN', 
    @in0k_lazExt_BTF_CodeExplorer_MAIN.Register);
end;

initialization
  RegisterPackage('in0k_lazExt_BTF_CodeExplorer', @Register);
end.
