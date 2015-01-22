unit lazExt_BTF_CodeExplorer;

{$mode objfpc}{$H+}

interface

uses SrcEditorIntf, IDECommands, PropEdits,
  lazExt_BTF_CodeExplorer_debug;

type

 tLazExt_BTF_CodeExplorer=class
  {%region --- CodeExplorer WINDOW -------------------------------- /fold}
  strict private
   _IDECommand_OpnCE_:TIDECommand; //< это комманда для открытия
    procedure _IDECommand_OpnCE_FIND_;
    function  _IDECommand_OpnCE_present_:boolean;
    function  _IDECommand_OpnCE_execute_:boolean;
  {%endRegion}
  {%region --- ВСЯ СУТь ------------------------------------------- /fold}
  protected //< полезная нагрузка
    function _do_BTF_CodeExplorer_do_WndCE_OPN:boolean;
    function _do_BTF_CodeExplorer_do_wndSE_BTF:boolean;
    function _do_BTF_CodeExplorer:boolean;
  {%endRegion}
  {%region --- IdeEVENT semEditorActivate ------------------------- /fold}
  strict private
    // текущий ОБРАБАТЫВАЕМЫЙ или ПОСЛЕДНИЙ обработанный
   _ideEvent_semEditorActivate_lastProc_:TSourceEditorInterface;
    procedure _ideEvent_semEditorActivate_exeEvent_(Sender:TObject);
    procedure _ideEvent_semEditorActivate_register_;
  {%endRegion}
  public
    constructor Create;
    destructor DESTROY; override;
  public
    procedure RegisterInIdeLAZARUS;
    //procedure sdfsdf(const Name: String);
  end;

implementation

{procedure tLazExt_BTF_CodeExplorer.sdfsdf(const Name: String) ;
begin
    DEBUG('asdf',Name);
end;}

constructor tLazExt_BTF_CodeExplorer.Create;
begin
   _IDECommand_OpnCE_:=NIL;
   _ideEvent_semEditorActivate_lastProc_:=nil;
end;

destructor tLazExt_BTF_CodeExplorer.DESTROY;
begin
    inherited;
end;

procedure tLazExt_BTF_CodeExplorer.RegisterInIdeLAZARUS;
begin
   _ideEvent_semEditorActivate_register_;
    // GlobalDesignHook.AddHandlerShowMethod(@sdfsdf);
end;

{%region --- CodeExplorer WINDOW ---------------------------------- /fold}

{info: жестко спрятанное Окно.
    присутствует ТОЛЬКО в исходниках `$(LazarusDir)/ide/codeexplorer.pas`
    единтсвенный способ достучаться до него нашёл только через комманду IDE.
    это конечноже через ЗАДНИЦА.
}
{todo: план развития
    - НАЙТИ способ ПРЯМОГО обращения к окну, что лежит в переменной
      $(LazarusDir)/ide/codeexplorer.pas->CodeExplorerView:TCodeExplorerView
    - написать заявку на добавление в IDEIntf или самому сделать правку
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tLazExt_BTF_CodeExplorer._IDECommand_OpnCE_FIND_;
begin
    if not Assigned(_IDECommand_OpnCE_) then begin
       _IDECommand_OpnCE_:=IDECommandList.FindIDECommand(ecToggleCodeExpl);
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tLazExt_BTF_CodeExplorer._IDECommand_OpnCE_present_:boolean;
begin
   _IDECommand_OpnCE_FIND_;
    result:=Assigned(_IDECommand_OpnCE_);
    {$ifOpt D+}
    if not result then DEBUG('ER','IDECommand NOT found');
    {$endIf}
end;

function tLazExt_BTF_CodeExplorer._IDECommand_OpnCE_execute_:boolean;
begin
    if Assigned(_IDECommand_OpnCE_) then begin
        result:=_IDECommand_OpnCE_.Execute(nil);
        {$ifOpt D+}
        if not result then DEBUG('ER','IDECommand err execute');
        {$endIf}
    end
    else begin
        result:=false;
        {$ifOpt D+}
        if not result then DEBUG('ER','IDECommand _IDECommand_OpnCE_==nil');
        {$endIf}
    end;
end;

{%endRegion}

{%region --- ВСЯ СУТь --------------------------------------------- /fold}

// открыть и вытащить на передний план окно `CodeExplorerView`
function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_do_WndCE_OPN:boolean;
begin
    result:=_IDECommand_OpnCE_present_ and _IDECommand_OpnCE_execute_;
end;

// переместить на передний план окно `ActiveSourceWindow`
function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_do_wndSE_BTF:boolean;
var tmp:TSourceEditorWindowInterface;
begin
    tmp:=SourceEditorManagerIntf.ActiveSourceWindow;
    if Assigned(tmp) then begin
        tmp.BringToFront;
        result:=true;
    end
    else begin
        result:=false;
        {$ifOpt D+}
        DEBUG('EXECdfsd','_sdfsdfsdfdo_BTF_CodeExplorer==FALSE');
        {$endIf}
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer:boolean;
begin // Еники Беники, костыли и велики ...
    // вызываем окно `CodeExplorerView`, оно встанет на ПЕРЕДНИЙ план
    // потом на передний план перемещаем окно `ActiveSourceWindow`
    //---
    // все это приводит к излишним дерганиям и как-то через Ж.
    result:=_do_BTF_CodeExplorer_do_WndCE_OPN
            and
            _do_BTF_CodeExplorer_do_wndSE_BTF;
end;

{%endRegion}

{%region --- IdeEVENT semEditorActivate --------------------------- /fold}

procedure tLazExt_BTF_CodeExplorer._ideEvent_semEditorActivate_exeEvent_(Sender:TObject);
var tmpEdt:TSourceEditorInterface;
begin
    {*1> причины использования `_lastProc_SrcEditor_`
        механизм с `_lastProcessed` приходится использовать из-за того, что
        при переключение "Вкладок Редактора Исходного Кода" вызов данного
        события происходит аж 3(три) раза. Используем только ПЕРВЫЙ вход.
        -----
        еще это событие происходит КОГДА идет навигация (прыжки по файлу)
    }
    if Assigned(SourceEditorManagerIntf) then begin //< запредельной толщины презерватив
        tmpEdt:=SourceEditorManagerIntf.ActiveEditor;
        if Assigned(tmpEdt) then begin //< чуть потоньше, но тоже толстоват
            if tmpEdt<>_ideEvent_semEditorActivate_lastProc_ then begin
               _ideEvent_semEditorActivate_lastProc_:=tmpEdt;
                // МОЖНО попробовать выполнить ПОЛЕЗНУЮ нагрузку
                if _do_BTF_CodeExplorer then begin //< что и делаем
                    {$ifOpt D+}
                    DEBUG('EXEC','_do_BTF_CodeExplorer==OK');
                    {$endIf}
                end
                else begin
                   _ideEvent_semEditorActivate_lastProc_:=nil;
                    {$ifOpt D+}
                    DEBUG('SKIP','_do_BTF_CodeExplorer==FALSE');
                    {$endIf}
                end;
            end
            else begin
                {$ifOpt D+}
                DEBUG('SKIP','already processed');
                {$endIf}
            end;
        end
        else begin
           _ideEvent_semEditorActivate_lastProc_:=nil;
            {$ifOpt D+}
            DEBUG('ER','ActiveEditor is NULL');
            {$endIf}
        end;
    end
    else begin
       _ideEvent_semEditorActivate_lastProc_:=nil;
        {$ifOpt D+}
        DEBUG('ER','IDE not ready');
        {$endIf}
    end;
end;

procedure tLazExt_BTF_CodeExplorer._ideEvent_semEditorActivate_register_;
begin
    SourceEditorManagerIntf.RegisterChangeEvent(semEditorActivate, @_ideEvent_semEditorActivate_exeEvent_);
end;

{%endRegion}

end.

//DoBringToFrontFormOrUnit
//DoShowDesignerFormOfCurrentSrc
