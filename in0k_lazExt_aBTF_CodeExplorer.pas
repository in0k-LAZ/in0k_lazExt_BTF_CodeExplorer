{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_lazExt_aBTF_CodeExplorer;

interface

uses
  in0k_LazarusIdeEXT__REGISTER, lazExt_aBTF_CodeExplorer, 
  lazExt_aBTF_CodeExplorer_DEBUG, 
  in0k_lazarusIdePLG__wndSatellite_CodeExplorer4SourceEditor, 
  in0k_lazarusIdeSRC__wndSatellite_templates__4FormDesigner, 
  in0k_lazarusIdeSRC__wndSatellite_templates__4SourceWindow, 
  in0k_lazarusIdeSRC__ideForm_CodeExplorerView, in0k_lazarusIdeSRC__B2SP, 
  in0k_bringToSecondPlane_LazLCL, in0k_bringToSecondPlane_WinAPI, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_LazarusIdeEXT__REGISTER', 
    @in0k_LazarusIdeEXT__REGISTER.Register);
end;

initialization
  RegisterPackage('in0k_lazExt_aBTF_CodeExplorer', @Register);
end.
