unit in0k_lazarusIdePLG__wndSatellite_CodeExplorer4SourceEditor;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_LazarusIdeEXT__DEBUG}in0k_lazarusIdeSRC__wndDEBUG,{$endIf}
   in0k_lazarusIdeSRC__wndSatellite_templates__4SourceWindow,
   in0k_lazarusIdeSRC__ideForm_CodeExplorerView,
   in0k_lazarusIdeSRC__B2SP,
   //---
     IDECommands,
Forms,
   Classes;
   //Classes, SysUtils;


type
 tIn0k_LazIdeEXT__wndStllte_CodeExplorer4SourceEditor=class(tIn0k_LazIdeEXT__wndStllte_TMPLTs_4SourceWindow)
  protected
    procedure _wrkEvent_; override;
  end;

implementation
{%region --- возня с ДЕБАГОМ -------------------------------------- /fold}
{$if declared(in0k_lazarusIdeSRC_DEBUG)}
    // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
    //                              моя "система"
    {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
{$endIf}
{%endregion}



procedure tIn0k_LazIdeEXT__wndStllte_CodeExplorer4SourceEditor._wrkEvent_;
var tmpWnd:TCustomForm;
begin   // ecToggleCodeExpl

 //    _IDECommand_OpnCEV_:=IDECommandList.FindIDECommand(_c_IDECommand_OpnCE_IdeCODE);


  inherited;
    // тут ВСЕ просто ... найти окно AnchorEditor и вытащить его на ВТОРОЙ план
    tmpWnd:=in0k_lazarusIdeSRC__ideForm_CodeExplorerView.Form_FindInIDE;
    if Assigned(tmpWnd) then begin
        if tmpWnd.Visible then begin  //< оно ВИДИМО
            if (NOT (csDestroying in tmpWnd.ComponentState)) //< оно НЕ уничтожается
            then begin
                In0k_lazIdeSRC___B2SP(tmpWnd);
            end
        end
        else begin
            {$ifDef _debugLOG_}
            DEBUG('_wrkEvent_', 'CodeExplorerView NOT visible');
            {$endIf};
        end;
    end
    else begin
        {$ifDef _debugLOG_}
        DEBUG('_wrkEvent_', 'CodeExplorerView NOT found');
        {$endIf};
    end
end;


end.

