{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_lazExt_aBTF_CodeExplorer;

interface

uses
  in0k_lazExt_aBTF_CodeExplorer_REG, lazExt_aBTF_CodeExplorer, 
  lazExt_aBTF_CodeExplorer_DEBUG, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_lazExt_aBTF_CodeExplorer_REG', 
    @in0k_lazExt_aBTF_CodeExplorer_REG.Register);
end;

initialization
  RegisterPackage('in0k_lazExt_aBTF_CodeExplorer', @Register);
end.
