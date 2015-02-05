unit lazExt_BTF_CodeExplorer;

{$mode objfpc}{$H+}

interface

{$I in0k_lazExt_BTF_CodeExplorer_INI.ini}
{$ifDef in0k_lazExt_DEBUG_mode}
    {$define _DEBUG_}
{$else}
    {$undef  _DEBUG_}
{$endIf}
{$ifDef _DEBUG_}
    {$undef  _INLINE_}
{$else}
    {$define _INLINE_}
{$endIf}

uses {$ifDEF _DEBUG_}sysutils, lazExt_BTF_CodeExplorer_debug,{$endIf}
    SrcEditorIntf, IDECommands,  Classes, Forms, windows;


const
  cCodeExplorerView_classallName='TCodeExplorerView';


type

 tLazExt_BTF_CodeExplorer=class
  {%region --- CodeExplorer Window IDECommand --------------------- /fold}
  strict private
   _IDECommand_OpnCE_:TIDECommand; //< это комманда для открытия
    procedure _IDECommand_OpnCE_FIND_;
    function  _IDECommand_OpnCE_present_:boolean;
    function  _IDECommand_OpnCE_execute_:boolean;
  {%endRegion}
  {%region --- ActiveSrcWND event onDestroy ----------------------- /fold}
  protected //< полезная нагрузка
   _ide_ActSrc_wnd_onDeactivate_original:TNotifyEvent;
    procedure _wnd_onDeactivate_myCustom(Sender:TObject);
    procedure _ide_ActiveSrcWND_rePlace_onDeactivate(const wnd:tForm);
    procedure _ide_ActiveSrcWND_reStore_onDeactivate(const wnd:tForm);
  {%endRegion}
  {%region --- ВСЯ СУТь ------------------------------------------- /fold}
  protected //< полезная нагрузка
    function _do_BTF_CodeExplorer_do_WndCE_OPN:boolean;
    function _do_BTF_CodeExplorer_do_wndSE_BTF:boolean;
    function _do_BTF_CodeExplorer_use_ideLaz:boolean;



    function _do_BTF_CodeExplorer_use_winAPI:boolean;
  {%endRegion}
  {%region --- IdeEVENT ------------------------------------------- /fold}
  strict private //< обработка событий
    // текущee АКТИВНОЕ окно редактирования
   _ideEvent_Window_:TSourceEditorWindowInterface;
   _ideEvent_Editor_:TSourceEditorInterface;
    procedure _ideEvent_exeEvent_;
    procedure _ideEvent_semEditorActivate(Sender:TObject);
    procedure _ideEvent_semWindowFocused (Sender:TObject);
  strict private //< регистрация событий
    procedure _ideEvent_register_;
  {%endRegion}
  {%region --- wndCodeExplorer------------------------------------ /fold}
  strict private
   _ide_Window_CEV_:tForm
   _ide_Window_CEV_onClose_original_:
    procedure _CEV_onClose_myCustom_
    procedure _ideWnd_codeExplr_onClose_myCustom(Sender:TObject);
    function  _wndCodeExplorer_findInScreen:TForm;
  strict private //< регистрация событий
  {%endRegion}
  public
    constructor Create;
    destructor DESTROY; override;
  public
    procedure RegisterInIdeLAZARUS;
  end;

implementation

constructor tLazExt_BTF_CodeExplorer.Create;
begin
   _IDECommand_OpnCE_:=NIL;
   _ideEvent_Window_ :=nil;
end;

destructor tLazExt_BTF_CodeExplorer.DESTROY;
begin
    inherited;
end;

procedure tLazExt_BTF_CodeExplorer.RegisterInIdeLAZARUS;
begin
   _ideEvent_register_;
end;

{%region --- CodeExplorer Window IDECommand ----------------------- /fold}

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
    {$ifDEF _DEBUG_}
    if not result then DEBUG('ER','IDECommand NOT found');
    {$endIf}
end;

function tLazExt_BTF_CodeExplorer._IDECommand_OpnCE_execute_:boolean;
var tmp:TForm;
begin
    (*if Assigned(_IDECommand_OpnCE_) then begin
        result:=_IDECommand_OpnCE_.Execute(nil);
        {$ifDEF _DEBUG_}
        if result     then DEBUG('CodeExplorer','BringToFront OK')
                      else DEBUG('CodeExplorer','BringToFront ER');
        {$endIf}
    end
    else begin
        result:=false;
        {$ifDEF _DEBUG_}
        if not result then DEBUG('CodeExplorer','BringToFront ER : IDECommand _IDECommand_OpnCE_==nil');
        {$endIf}
    end;*)
    tmp:=_wndCodeExplorer_findInScreen;
    if tmp<>nil then tmp.BringToFront;


end;

{%endRegion}

{%region --- ActiveSrcWND event onDestroy ------------------------- /fold}

{info: Идея: отловить момент "выхода" из окна редактирования.
    Используем "грязны" метод: аля "сабКлассинг", заменяем на СОБСТВЕННУЮ
    реализацию событие `onDeactivate`.
}

// НАШЕ событие, при `onDeactivate` ActiveSrcWND
procedure tLazExt_BTF_CodeExplorer._wnd_onDeactivate_myCustom(Sender:TObject);
begin
    {$ifDEF _DEBUG_}
    DEBUG('onDeactivate_myCustom','--->>> Sender$'+IntToHex(PtrUInt(Sender),sizeOf(PtrUInt)*2));
    {$endIf}
    //----------------------------------------------------------------------

    // отмечаем что ВЫШЛИ из окна
   _ideEvent_Window_:=NIL;
    // восстановить событие `onDeactivate` на исходное, и выполнияем его
    if Assigned(Sender) then begin
        if Sender is TSourceEditorWindowInterface then begin
           _ide_ActiveSrcWND_reStore_onDeactivate(tForm(Sender));
            with TSourceEditorWindowInterface(Sender) do begin
                if Assigned(OnDeactivate) then OnDeactivate(Sender);
            end;
            {$ifDEF _DEBUG_}
            DEBUG('OK','executed');
            {$endIf}
        end
        else begin
            {$ifDEF _DEBUG_}
            DEBUG('ER','Sender is NOT TSourceEditorWindowInterface');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('ER','Sender==NIL');
        {$endIf}
    end;

    //----------------------------------------------------------------------
    {$ifDEF _DEBUG_}
    DEBUG('onDeactivate_myCustom','---<<<');
    {$endIf}
end;

//------------------------------------------------------------------------------

// ЗАМЕНЯЕМ `onDeactivate` на собственное
procedure tLazExt_BTF_CodeExplorer._ide_ActiveSrcWND_rePlace_onDeactivate(const wnd:tForm);
begin
    if wnd.OnDeactivate<>(@_wnd_onDeactivate_myCustom) then begin
        {$ifDEF _DEBUG_}
        DEBUG('rePlace_onDeactivate','rePALCE wnd$'+IntToHex(PtrUInt(wnd),sizeOf(PtrUInt)*2));
        {$endIf}
       _ide_ActSrc_Wnd_onDeactivate_original:=wnd.OnDeactivate;
        wnd.OnDeactivate:=@_wnd_onDeactivate_myCustom;
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('rePlace_onDeactivate','SKIP wnd$'+IntToHex(PtrUInt(wnd),sizeOf(PtrUInt)*2));
        {$endIf}
    end
end;

// ВОСТАНАВЛИВАЕМ `onDeactivate` на то что было
procedure tLazExt_BTF_CodeExplorer._ide_ActiveSrcWND_reStore_onDeactivate(const wnd:tForm);
begin
    if wnd.OnDeactivate=(@_wnd_onDeactivate_myCustom) then begin
        {$ifDEF _DEBUG_}
        DEBUG('reStore_onDeactivate','wnd$'+IntToHex(PtrUInt(wnd),sizeOf(PtrUInt)*2));
        {$endIf}
        wnd.OnDeactivate:=_ide_ActSrc_Wnd_onDeactivate_original;
       _ide_ActSrc_Wnd_onDeactivate_original:=NIL;
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('reStore_onDeactivate','SKIP wnd$'+IntToHex(PtrUInt(wnd),sizeOf(PtrUInt)*2));
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
        {$ifDEF _DEBUG_}
        DEBUG('ActiveSourceWindow','BringToFront OK');
        {$endIf}
    end
    else begin
        result:=false;
        {$ifDEF _DEBUG_}
        DEBUG('ActiveSourceWindow','BringToFront ER');
        {$endIf}
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_use_ideLaz:boolean;
begin // Еники Беники, костыли и велики ...
    // вызываем окно `CodeExplorerView`, оно встанет на ПЕРЕДНИЙ план
    // потом на передний план перемещаем окно `ActiveSourceWindow`
    //---
    // все это приводит к излишним дерганиям и как-то через Ж.
    result:=_do_BTF_CodeExplorer_do_WndCE_OPN
            and
            _do_BTF_CodeExplorer_do_wndSE_BTF;
end;


function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_use_winAPI:boolean;
var dwp:HDWP;
  _wnd_CE:tForm;
  _wnd_SE:tForm;
begin
   _wnd_CE:=_wndCodeExplorer_findInScreen;
   _wnd_SE:=_ideEvent_Window_;
    if Assigned(_wnd_CE) and Assigned(_wnd_SE) then begin
        dwp:=BeginDeferWindowPos(1);
        //DeferWindowPos(dwp,_wnd_CE.Handle,_wnd_SE.Handle,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE {or SWP_NOACTIVATE});
        //DeferWindowPos(dwp,_wnd_SE.Handle, HWND_TOP ,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
        DeferWindowPos(dwp,_wnd_CE.Handle,_wnd_SE.Handle,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE );
        if EndDeferWindowPos(dwp) then begin
            {$ifDEF _DEBUG_}
            DEBUG('ActiveSourceWindow','TRUE');
            {$endIf}
        end
        else begin
            {$ifDEF _DEBUG_}
            DEBUG('ActiveSourceWindow','FALSE');
            {$endIf}
        end;
    end;
end;

{%endRegion}

{%region --- IdeEVENT semEditorActivate --------------------------- /fold}

// основное рабочее событие
procedure tLazExt_BTF_CodeExplorer._ideEvent_exeEvent_;
var tmpSourceWindow:TSourceEditorWindowInterface;
var tmpSourceEditor:TSourceEditorInterface;
begin
    {*1> причины использования _ideEvent_Window_ _ideEvent_Editor_
        механизм с приходится использовать из-за того, что
        при переключение "Вкладок Редактора Исходного Кода" вызов данного
        события происходит аж 3(три) раза. Используем только ПЕРВЫЙ вход.
        -----
        еще это событие происходит КОГДА идет навигация (прыжки по файлу)
    }
    if Assigned(SourceEditorManagerIntf) then begin //< запредельной толщины презерватив
        tmpSourceWindow:=SourceEditorManagerIntf.ActiveSourceWindow;
        if Assigned(tmpSourceWindow) then begin
            tmpSourceEditor:=SourceEditorManagerIntf.ActiveEditor;
            if Assigned(tmpSourceEditor) then begin //< чуть потоньше, но тоже толстоват
                if (tmpSourceWindow<>_ideEvent_Window_)
                 or(tmpSourceEditor<>_ideEvent_Editor_)
                then begin
                   _ideEvent_Window_:=tmpSourceWindow;
                   _ideEvent_Editor_:=tmpSourceEditor;
                   _ide_ActiveSrcWND_reStore_onDeactivate(tmpSourceWindow);
                   _do_BTF_CodeExplorer_use_winAPI;//< МОЖНО попробовать выполнить ПОЛЕЗНУЮ нагрузку
                   _ide_ActiveSrcWND_rePlace_onDeactivate(tmpSourceWindow);
                end
                else begin
                    {$ifDEF _DEBUG_}
                    DEBUG('SKIP','already processed');
                    {$endIf}
                end;
            end
            else begin
               _ideEvent_Editor_:=nil;
               _ideEvent_Window_:=nil;
                {$ifDEF _DEBUG_}
                DEBUG('ER','ActiveEditor is NULL');
                {$endIf}
            end;
        end
        else begin
           _ideEvent_Editor_:=nil;
           _ideEvent_Window_:=nil;
            {$ifDEF _DEBUG_}
            DEBUG('ER','ActiveSourceWINDOW is NULL');
            {$endIf}
        end;
    end
    else begin
       _ideEvent_Window_:=nil;
        {$ifDEF _DEBUG_}
        DEBUG('ER','IDE not ready');
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._ideEvent_semEditorActivate(Sender:TObject);
begin
    {$ifDEF _DEBUG_}
    DEBUG('semEditorActivate','--->>>'+' sender='+IntToHex(PtrUInt(Sender),sizeOf(PtrUInt)*2));
    {$endIf}
    if assigned(_ideEvent_Window_) //< запускаемся только если окно
    then _ideEvent_exeEvent_      //  редактирования в ФОКУСЕ
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('SKIP','ActiveSourceWindow is UNfocused');
        {$endIf}
    end;
    {$ifDEF _DEBUG_}
    DEBUG('semEditorActivate','---<<<');
    {$endIf}
end;

procedure tLazExt_BTF_CodeExplorer._ideEvent_semWindowFocused(Sender:TObject);
var tmp:TSourceEditorWindowInterface;
begin
    {$ifDEF _DEBUG_}
    DEBUG('semWindowFocused','--->>>'+' sender='+IntToHex(PtrUInt(Sender),sizeOf(PtrUInt)*2));
    {$endIf}
   _ideEvent_exeEvent_;
    {$ifDEF _DEBUG_}
    DEBUG('semWindowFocused','---<<<');
    {$endIf}
    _wndCodeExplorer_findInScreen;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._ideEvent_register_;
begin
    SourceEditorManagerIntf.RegisterChangeEvent(semWindowFocused,  @_ideEvent_semWindowFocused);
    SourceEditorManagerIntf.RegisterChangeEvent(semEditorActivate, @_ideEvent_semEditorActivate);
end;

{%endRegion}

{%region --- wndCodeExplorer--------------------------------------- /fold}

function tLazExt_BTF_CodeExplorer._wndCodeExplorer_findInScreen:TForm;
var i:integer;
  tmp:TForm;
begin
    result:=nil;
    for i:=0 to Screen.FormCount-1 do begin
        tmp:=Screen.Forms[i];
        if tmp.ClassNameIs(cCodeExplorerView_classallName) then begin
            result:=tmp;
            {$ifDEF _DEBUG_}
            DEBUG('FIND','CodeExplorerView');
            {$endIf}
        end;
    end;
end;

{%endRegion}


end.
