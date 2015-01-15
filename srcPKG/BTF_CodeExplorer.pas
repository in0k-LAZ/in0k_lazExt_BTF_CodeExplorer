unit BTF_CodeExplorer;

{$mode objfpc}{$H+}

interface

uses SrcEditorIntf, LazIDEIntf, MenuIntf, IDECommands,
  Classes, SysUtils;

type

 tBTF_CodeExplorer=class
  strict private
   _lastProc:TSourceEditorInterface; //< последний ОБРАБОТАННЫЙ
  protected //<
    procedure _do_BTF_CodeExplorer;
  protected //<
    function  _ideLaz_get_ActvEDT:TSourceEditorInterface;
  protected //< СОБЫТИЯ
    procedure _ideEvent_semEditorActivate(Sender: TObject);
    procedure _ideEvent_closeIDE(Sender: TObject);
  protected //< и их РЕГИСТРАЦИЯ
    procedure _ideEvents_Register;
    procedure _ideEvents_unRegister;
  public
    constructor Create;
    destructor DESTROY; override;
 end;

implementation

constructor tBTF_CodeExplorer.Create;
begin              //itmViewCodeExplorer
   _lastProc:=nil;  // itmCustomTools
   _ideEvents_Register;

   //
end;

destructor tBTF_CodeExplorer.DESTROY;
begin
    inherited;
end;

//------------------------------------------------------------------------------

procedure tBTF_CodeExplorer._do_BTF_CodeExplorer;
var ccc:TIDECommand;
    sss:TSourceEditorWindowInterface;
begin
   ccc:=IDECommandList.FindIDECommand(ecToggleCodeExpl) ;
   if Assigned(ccc) then ccc.Execute(nil);

   sss:=SourceEditorManagerIntf.ActiveSourceWindow;
   if Assigned(sss) then sss.BringToFront;


   //

    //if Assigned(CodeExplorerMenuRoot) and Assigned(CodeExplorerMenuRoot.OnClick)
    //then CodeExplorerMenuRoot.OnClick(nil);
end;

//------------------------------------------------------------------------------

function tBTF_CodeExplorer._ideLaz_get_ActvEDT:TSourceEditorInterface;
begin
    result:=SourceEditorManagerIntf.ActiveEditor;
    {$ifOpt D+}
    //if not Assigned(result) then DEBUG('ER','ActiveEditor is NULL');
    {$endIf}
end;


procedure tBTF_CodeExplorer._ideEvent_closeIDE(Sender: TObject);
begin {***> причины использования `_closeIDE`
            не понятно по какому принципу необходимо отписываться от событий.
            но без этого Lazarus завершается с утечкой памяти или вообще падает.
      }
    {$ifOpt D+}
    //DEBUG('ideEvent','closeIDE');
    {$endIf}
   _ideEvents_unRegister;
end;

procedure tBTF_CodeExplorer._ideEvent_semEditorActivate(Sender: TObject);
var ActvEdt:TSourceEditorInterface;
begin
    ActvEdt:=_ideLaz_get_ActvEDT;
    if Assigned(ActvEdt) then begin
        if ActvEdt<>_lastProc then begin
            {*1> причины использования `_lastProc`
                механизм с `_lastProcessed` приходится использовать из-за того, что
                при переключение "Вкладок Редактора Исходного Кода" вызов данного
                события происходит аж 3(три) раза.
                Почему так происходит - повод для дальнейших разобирательств.
                -----
                еще это событие происходит КОГДА идет навигация (прыжки по файлу)
                -----
                Используем только ПЕРВЫЙ вход
            }
           _do_BTF_CodeExplorer;
           _lastProc:=ActvEdt;
        end
        else begin
            {$ifOpt D+}
            //DEBUG('SKIP','already processed');
            {$endIf}
        end;
    end
    else begin
       _lastProc:=nil;
        {$ifOpt D+}
        //DEBUG('SKIP','IDE not Ready');
        {$endIf}
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const cBTF_CodeExplorer_semEditorActivate=semEditorActivate;

procedure tBTF_CodeExplorer._ideEvents_register;
begin
    LazarusIDE.AddHandlerOnIDEClose(@_ideEvent_closeIDE);
    SourceEditorManagerIntf.RegisterChangeEvent(cBTF_CodeExplorer_semEditorActivate, @_ideEvent_semEditorActivate);
end;

procedure tBTF_CodeExplorer._ideEvents_unRegister;
begin
    LazarusIDE.RemoveHandlerOnIDEClose(@_ideEvent_closeIDE);
    SourceEditorManagerIntf.UnRegisterChangeEvent(cBTF_CodeExplorer_semEditorActivate, @_ideEvent_semEditorActivate);
end;


end.

