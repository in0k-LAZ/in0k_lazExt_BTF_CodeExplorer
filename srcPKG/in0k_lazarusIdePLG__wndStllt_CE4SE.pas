unit in0k_lazarusIdePLG__wndStllt_CE4SE;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_LazarusIdeEXT__DEBUG}in0k_lazarusIdeSRC__wndDEBUG,{$endIf}
   in0k_lazarusIdeSRC__TMPLT_4SourceWindow,
   in0k_lazarusIdeSRC__ideForm_CodeExplorerView,
   uBringToSecond,
   //---
   Forms, Classes;

type
 tIn0k_LazIdeEXT__wndStllte_CE4SE=class(tIn0k_lazIdeSRC__TMPLT_4SourceWindow)
  protected
    procedure _wrkEvent_onActivate_(const sender:tObject); override;
  end;

implementation
{%region --- возня с ДЕБАГОМ -------------------------------------- /fold}
{$if declared(in0k_lazarusIdeSRC_DEBUG)}
    // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
    //                              моя "система"
    {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
{$endIf}
{%endregion}

// Окно! с редактором ИсходногоКода БЫЛО активировано.
procedure tIn0k_LazIdeEXT__wndStllte_CE4SE._wrkEvent_onActivate_(const sender:tObject);
var tmpWnd:TCustomForm;
begin
    inherited;
    // тут ВСЕ просто ... найти окно CodeExplorerView
    tmpWnd:=in0k_lazarusIdeSRC__ideForm_CodeExplorerView.Form_FindInIDE;
    // проверить что с ним ВСЕ хорошо
    if NOT Assigned(tmpWnd) then begin
        {$ifDef _debugLOG_}
        DEBUG('_wrkEvent_', 'CodeExplorerView NOT found');
        {$endIf}
        EXIT;
    end;
    if csDestroying in tmpWnd.ComponentState then begin
        {$ifDef _debugLOG_}
        DEBUG('_wrkEvent_', 'CodeExplorerView is csDestroying');
        {$endIf};
        EXIT;
    end;
    if NOT tmpWnd.Visible then begin
        {$ifDef _debugLOG_}
        DEBUG('_wrkEvent_', 'CodeExplorerView is NOT Visible');
        {$endIf};
        EXIT;
    end;
    // вытащить его на ВТОРОЙ план
    {$ifDef _debugLOG_}
    DEBUG('_wrkEvent_', 'bringToSecond('+tmpWnd.ClassName+addr2txt(tmpWnd)+')');
    {$endIf};
    bringToSecond(tmpWnd);
end;

end.

