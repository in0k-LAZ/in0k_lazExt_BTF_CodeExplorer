{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_lazExt_BTF_CodeExplorer;

interface

uses
  in0k_lazExt_BTF_CodeExplorer_REG, lazExt_BTF_CodeExplorer, 
  lazExt_BTF_CodeExplorer_debug, lazExt_BTF_CodeExplorer_wndDBG, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_lazExt_BTF_CodeExplorer_REG', 
    @in0k_lazExt_BTF_CodeExplorer_REG.Register);
end;

initialization
  RegisterPackage('in0k_lazExt_BTF_CodeExplorer', @Register);
end.
