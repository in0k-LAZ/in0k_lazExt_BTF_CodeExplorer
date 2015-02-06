unit lazExt_BTF_CodeExplorer;

{$mode objfpc}{$H+}

interface

{$I in0k_lazExt_BTF_CodeExplorer_INI.ini}

//-----

{$undef _lazExt_BTF_CodeExplorer_API_001_}
{$undef _lazExt_BTF_CodeExplorer_API_002_}
{$undef _lazExt_BTF_CodeExplorer_API_003_}
{$undef _lazExt_BTF_CodeExplorer_API_004_}

//----
{$ifDef lazExt_BTF_CodeExplorer_Auto_SHOW}
    {$define _lazExt_BTF_CodeExplorer_API_001_}
{$endif}
{$ifDef lazExt_BTF_CodeExplorer_WinAPI_mode}
    //---- под Виндой
    {$undef  _lazExt_BTF_CodeExplorer_API_002_}
    {$define _lazExt_BTF_CodeExplorer_API_003_}
    {$define _lazExt_BTF_CodeExplorer_API_004_}
{$else}
    //---- стандартный (через IDE Lazarus) метод работы
    {$define _lazExt_BTF_CodeExplorer_API_002_}
    {$define _lazExt_BTF_CodeExplorer_API_001_}
{$endif}


uses {$ifDEF _DEBUG_}sysutils, lazExt_BTF_CodeExplorer_debug,{$endIf}
    SrcEditorIntf, IDECommands,  Classes, Forms, windows;




type

 tLazExt_BTF_CodeExplorer=class
  {%region --- CodeExplorer Window IDECommand --------------------- /fold}
  {$ifDef _lazExt_BTF_CodeExplorer_API_001_}
  strict private
   _IDECommand_OpnCEV_:TIDECommand; //< это комманда для открытия
    procedure _IDECommand_OpnCEV_FIND_;
    function  _IDECommand_OpnCEV_present_:boolean;
    function  _IDECommand_OpnCEV_execute_:boolean;
  {$endIf}
  {%endRegion}
  {%region --- Active SourceEditorWindow -------------------------- /fold}
  protected
   _ide_Window_SEW_:TSourceEditorWindowInterface; //< текущee АКТИВНОЕ окно редактирования
   _ide_Window_SEW_onDeactivate_original:TNotifyEvent;    //< его событие
    procedure _SEW_onDeactivate_myCustom(Sender:TObject); //< моя подстава
    procedure _SEW_rePlace_onDeactivate(const wnd:tForm);
    procedure _SEW_reStore_onDeactivate(const wnd:tForm);
    //---
    procedure _SEW_SET(const wnd:TSourceEditorWindowInterface);
  {%endRegion}
  {%region --- ВСЯ СУТь ------------------------------------------- /fold}
  protected
    function _do_BTF_CodeExplorer_:boolean;
  protected
    {$ifDef _lazExt_BTF_CodeExplorer_API_002_}
    function _do_BTF_CodeExplorer_do_WndCE_OPN:boolean;
    function _do_BTF_CodeExplorer_do_wndSE_BTF:boolean;
    function _do_BTF_CodeExplorer_use_ideLaz:boolean; {$ifDEF _INLINE_}inline;{$endIf}
    {$endIf}
    {$ifDef _lazExt_BTF_CodeExplorer_API_003_}
    function _do_BTF_CodeExplorer_use_winAPI:boolean; {$ifDEF _INLINE_}inline;{$endIf}
    {$endIf}
  {%endRegion}
  {%region --- ide_Window_CEV : API_004 --------------------------- /fold}
  {$ifDef _lazExt_BTF_CodeExplorer_API_004_}
  strict private
   _ide_Window_CEV_:tForm;                        //< найденное окно
   _ide_Window_CEV_onClose_original_:TCloseEvent; //< его событие при выходе
    procedure _CEV_onClose_myCustom_(Sender:TObject; var CloseAction:TCloseAction);
    procedure _CEV_rePlace_onClose(const wnd:tForm);
    procedure _CEV_reStore_onClose(const wnd:tForm);
    //---
    function  _CEV_findInScreen:TForm;
  strict private //< регистрация событий
  {$endIf}
  {%endRegion}
  {%region --- IdeEVENT ------------------------------------------- /fold}
  strict private //< обработка событий
   _ideEvent_Editor_:TSourceEditorInterface;
    procedure _ideEvent_exeEvent_;
    procedure _ideEvent_semEditorActivate(Sender:TObject);
    procedure _ideEvent_semWindowFocused (Sender:TObject);
  strict private //< регистрация событий
    procedure _ideEvent_register_;
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
    {$ifDef _lazExt_BTF_CodeExplorer_API_001_}
   _IDECommand_OpnCEV_:=NIL;
    {$endIf}
   _ide_Window_SEW_ :=nil;
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

{todo: план развития
    - НАЙТИ способ ПРЯМОГО обращения к окну, что лежит в переменной
      $(LazarusDir)/ide/codeexplorer.pas->CodeExplorerView:TCodeExplorerView
    - написать заявку на добавление в IDEIntf или самому сделать правку
}

{$ifDef _lazExt_BTF_CodeExplorer_API_001_}

{info: жестко спрятанное Окно.
    присутствует ТОЛЬКО в исходниках `$(LazarusDir)/ide/codeexplorer.pas`
    единтсвенный способ достучаться до него нашёл только через комманду IDE.
    это конечноже через ЗАДНИЦА.
}

const //< тут возможно придется определять относительно ВЕРСИИ ЛАЗАРУСА
  _c_IDECommand_OpnCE_IdeCODE=ecToggleCodeExpl;

procedure tLazExt_BTF_CodeExplorer._IDECommand_OpnCEV_FIND_;
begin
   _IDECommand_OpnCEV_:=IDECommandList.FindIDECommand(_c_IDECommand_OpnCE_IdeCODE);
    {$ifDEF _DEBUG_}
    if Assigned(_IDECommand_OpnCEV_)
    then DEBUG('OK','IDECommand_OpnCEV "ToggleCodeExpl" FOUND')
    else DEBUG('ER','IDECommand_OpnCEV "ToggleCodeExpl" NOT found')
    {$endIf}
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function tLazExt_BTF_CodeExplorer._IDECommand_OpnCEV_present_:boolean;
begin
    result:=Assigned(_IDECommand_OpnCEV_);
    if not result then begin
       _IDECommand_OpnCEV_FIND_;
        result:=Assigned(_IDECommand_OpnCEV_);
    end;
end;

function tLazExt_BTF_CodeExplorer._IDECommand_OpnCEV_execute_:boolean;
begin
    if _IDECommand_OpnCEV_present_ then begin
        result:=_IDECommand_OpnCEV_.Execute(nil);
        {$ifDEF _DEBUG_}
        if result then DEBUG('OK','IDECommand_OpnCEV.execute')
                  else DEBUG('ER','IDECommand_OpnCEV.execute');
        {$endIf}
    end
end;

{$endIf}

{%endRegion}

{%region --- Active SourceEditorWindow ---------------------------- /fold}

{Идея: отловить момент "выхода" из окна редактирования.
    Используем "грязны" метод: аля "сабКлассинг", заменяем на СОБСТВЕННУЮ
    реализацию событие `onDeactivate`.
}

// НАШЕ событие, при `onDeactivate` ActiveSrcWND
procedure tLazExt_BTF_CodeExplorer._SEW_onDeactivate_myCustom(Sender:TObject);
begin
    {$ifDEF _DEBUG_}
    DEBUG('_SEW_onDeactivate_myCustom','--->>> Sender'+_addr2txt_(Sender));
    {$endIf}

    // отмечаем что ВЫШЛИ из окна
   _ide_Window_SEW_:=NIL;
   _ideEvent_Editor_:=NIL;
    // восстановить событие `onDeactivate` на исходное, и выполнияем его
    if Assigned(Sender) then begin
        if Sender is TSourceEditorWindowInterface then begin
           _SEW_reStore_onDeactivate(tForm(Sender));
            with TSourceEditorWindowInterface(Sender) do begin
                if Assigned(OnDeactivate) then OnDeactivate(Sender);
                {$ifDEF _DEBUG_}
                DEBUG('OK','TSourceEditorWindowInterface('+_addr2txt_(sender)+').OnDeactivate executed');
                {$endIf}
            end;
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

    {$ifDEF _DEBUG_}
    DEBUG('_SEW_onDeactivate_myCustom','---<<<');
    {$endIf}
end;

//------------------------------------------------------------------------------

// ЗАМЕНЯЕМ `onDeactivate` на собственное
procedure tLazExt_BTF_CodeExplorer._SEW_rePlace_onDeactivate(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnDeactivate<>@_SEW_onDeactivate_myCustom) then begin
       _ide_Window_SEW_onDeactivate_original:=wnd.OnDeactivate;
        wnd.OnDeactivate:=@_SEW_onDeactivate_myCustom;
        {$ifDEF _DEBUG_}
        DEBUG('_SEW_rePlace_onDeactivate','rePALCE wnd'+_addr2txt_(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('_SEW_rePlace_onDeactivate','SKIP wnd'+_addr2txt_(wnd));
        {$endIf}
    end
end;

// ВОСТАНАВЛИВАЕМ `onDeactivate` на то что было
procedure tLazExt_BTF_CodeExplorer._SEW_reStore_onDeactivate(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnDeactivate=@_SEW_onDeactivate_myCustom) then begin
        wnd.OnDeactivate:=_ide_Window_SEW_onDeactivate_original;
       _ide_Window_SEW_onDeactivate_original:=NIL;
        {$ifDEF _DEBUG_}
        DEBUG('_SEW_reStore_onDeactivate','wnd'+_addr2txt_(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('_SEW_reStore_onDeactivate','SKIP wnd'+_addr2txt_(wnd));
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._SEW_SET(const wnd:TSourceEditorWindowInterface);
begin
    if not Assigned(_ide_Window_SEW_) then begin
       _SEW_rePlace_onDeactivate(wnd);
       _ide_Window_SEW_:=wnd;
    end
    else begin
       _ide_Window_SEW_:=nil;
    end;
end;

{%endRegion}

{%region --- ВСЯ СУТь --------------------------------------------- /fold}

{$ifDef _lazExt_BTF_CodeExplorer_API_002_}

// открыть и вытащить на передний план окно `CodeExplorerView`
function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_do_WndCE_OPN:boolean;
begin
    result:=_IDECommand_OpnCEV_present_ and _IDECommand_OpnCEV_execute_;
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
        DEBUG('ok','ActiveSourceWindow.BringToFront');
        {$endIf}
    end
    else begin
        result:=false;
        {$ifDEF _DEBUG_}
        DEBUG('er','ActiveSourceWindow.BringToFront');
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
   _SEW_reStore_onDeactivate(tmpSourceWindow);
    result:=_do_BTF_CodeExplorer_do_WndCE_OPN
            and
            _do_BTF_CodeExplorer_do_wndSE_BTF;
   _SEW_rePlace_onDeactivate(tmpSourceWindow);
end;

{$endIf}

//==============================================================================

{$ifDef _lazExt_BTF_CodeExplorer_API_003_}

function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_use_winAPI:boolean;
var dwp:HDWP;
begin
    if Assigned(_ide_Window_CEV_) and Assigned(_ide_Window_SEW_) then begin
        dwp:=BeginDeferWindowPos(1);
        DeferWindowPos(dwp,_ide_Window_CEV_.Handle,_ide_Window_SEW_.Handle,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE );
        result:=EndDeferWindowPos(dwp);
    end
    else begin
        result:=false;
        {$ifDEF _DEBUG_}
        if not Assigned(_ide_Window_CEV_) then DEBUG('EVENT','_ide_Window_CEV_==nil');
        if not Assigned(_ide_Window_SEW_) then DEBUG('EVENT','_ide_Window_SEW_==nil');
        {$endIf}
    end;
end;

{$endIf}

//==============================================================================

function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_:boolean;
begin
    {$ifDef lazExt_BTF_CodeExplorer_WinAPI_mode}
        result:=_do_BTF_CodeExplorer_use_winAPI;
    {$else} //< "стандартными" средствами IDE lazarus
        result:=_do_BTF_CodeExplorer_use_ideLaz;
    {$endIf}
    {$ifDEF _DEBUG_}
    if result then DEBUG('BTF_CodeExplorer','OK')
              else DEBUG('BTF_CodeExplorer','ER');
    {$endIf}
end;

{%endRegion}

{%region --- ide_Window_CEV : API_004 ----------------------------- /fold}

{$ifDef _lazExt_BTF_CodeExplorer_API_004_}

const //< тут возможно придется определять относительно ВЕРСИИ ЛАЗАРУСА
  cWndCEV_className='TCodeExplorerView';

// исчем ЭКЗЕМПЛЯР окна
//  поиск по ИМЕНИ класса в хранилище открытых окон `Screen.Form`
function tLazExt_BTF_CodeExplorer._CEV_findInScreen:TForm;
var i:integer;
    f:TForm;
begin
    result:=nil;
    for i:=0 to Screen.FormCount-1 do begin
        f:=Screen.Forms[i];
        {$ifDEF _DEBUG_}
        DEBUG('CEV','onFind '+f.ClassName);
        {$endIf}
        if f.ClassNameIs(cWndCEV_className) then begin
            result:=f;
            {$ifDEF _DEBUG_}
            DEBUG('CEV','FOUND '+cWndCEV_className+_addr2txt_(f));
            {$endIf}
        end;
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._CEV_onClose_myCustom_(Sender:TObject; var CloseAction:TCloseAction);
begin
    {$ifDEF _DEBUG_}
    DEBUG('_CEV_onClose_myCustom_','--->>> Sender'+_addr2txt_(Sender));
    {$endIf}

    // отмечаем что ВЫШЛИ из окна
   _ide_Window_CEV_:=NIL;
    // восстановить событие `onDeactivate` на исходное, и выполнияем его
    if Assigned(Sender) then begin
        if Sender is TForm then begin
           _CEV_reStore_onClose(tForm(Sender));
            with tForm(Sender) do begin
                if Assigned(OnClose) then OnClose(Sender,CloseAction);
                {$ifDEF _DEBUG_}
                DEBUG('OK','TForm('+_addr2txt_(sender)+').onClose executed');
                {$endIf}
            end;
        end
        else begin
            {$ifDEF _DEBUG_}
            DEBUG('ER','Sender is NOT TForm');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('ER','Sender==NIL');
        {$endIf}
    end;

    {$ifDEF _DEBUG_}
    DEBUG('_CEV_onClose_myCustom_','---<<<');
    {$endIf}
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._CEV_rePlace_onClose(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnClose<>@_CEV_onClose_myCustom_) then begin
       _ide_Window_CEV_onClose_original_:=wnd.OnClose;
        wnd.OnClose:=@_CEV_onClose_myCustom_;
        {$ifDEF _DEBUG_}
        DEBUG('_CEV_rePlace_onClose','rePALCE wnd'+_addr2txt_(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('_CEV_rePlace_onClose','SKIP wnd'+_addr2txt_(wnd));
        {$endIf}
    end
end;

procedure tLazExt_BTF_CodeExplorer._CEV_reStore_onClose(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnClose=@_CEV_onClose_myCustom_) then begin
        wnd.OnClose:=_ide_Window_CEV_onClose_original_;
       _ide_Window_CEV_onClose_original_:=NIL;
        {$ifDEF _DEBUG_}
        DEBUG('_CEV_reStore_onClose','wnd'+_addr2txt_(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('_CEV_reStore_onClose','SKIP wnd'+_addr2txt_(wnd));
        {$endIf}
    end;
end;

{$endIf}

{%endRegion}

{%region --- IdeEVENT semEditorActivate --------------------------- /fold}

// основное рабочее событие
procedure tLazExt_BTF_CodeExplorer._ideEvent_exeEvent_;
var tmpSourceEditor:TSourceEditorInterface;
begin
    {*1> причины использования _ideEvent_Editor_
        механизм с приходится использовать из-за того, что
        при переключение "Вкладок Редактора Исходного Кода" вызов данного
        события происходит аж 3(три) раза. Используем только ПЕРВЫЙ вход.
        -----
        еще это событие происходит КОГДА идет навигация (прыжки по файлу)
    }
    if Assigned(SourceEditorManagerIntf) then begin //< запредельной толщины презерватив
        tmpSourceEditor:=SourceEditorManagerIntf.ActiveEditor;
        if Assigned(tmpSourceEditor) then begin //< чуть потоньше, но тоже толстоват
            if (tmpSourceEditor<>_ideEvent_Editor_) then begin
                // МОЖНО попробовать выполнить ПОЛЕЗНУЮ нагрузку
                if _do_BTF_CodeExplorer_
                then _ideEvent_Editor_:=tmpSourceEditor
                else _ideEvent_Editor_:=NIL;
            end
            else begin
                {$ifDEF _DEBUG_}
                DEBUG('SKIP','already processed');
                {$endIf}
            end;
        end
        else begin
           _ideEvent_Editor_:=nil;
            {$ifDEF _DEBUG_}
            DEBUG('ER','ActiveEditor is NULL');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('ER','IDE not ready');
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._ideEvent_semEditorActivate(Sender:TObject);
begin
    {$ifDEF _DEBUG_}
    DEBUG('ideEVENT:semEditorActivate','--->>>'+' sender'+_addr2txt_(Sender));
    {$endIf}

    if assigned(_ide_Window_SEW_) //< запускаемся только если окно
    then _ideEvent_exeEvent_      //  редактирования в ФОКУСЕ
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('SKIP','ActiveSourceWindow is UNfocused');
        {$endIf}
    end;

    {$ifDEF _DEBUG_}
    DEBUG('ideEVENT:semEditorActivate','---<<<');
    {$endIf}
end;

procedure tLazExt_BTF_CodeExplorer._ideEvent_semWindowFocused(Sender:TObject);
begin
    {$ifDEF _DEBUG_}
    DEBUG('ideEVENT:semWindowFocused','--->>>'+' sender'+_addr2txt_(Sender));
    {$endIf}

    if Assigned(Sender) and (Sender is TSourceEditorWindowInterface) then begin
       _SEW_SET(TSourceEditorWindowInterface(Sender));
        if Assigned(_ide_Window_SEW_) then begin
           _ideEvent_exeEvent_;
        end
        else begin
            {$ifDEF _DEBUG_}
            DEBUG('SKIP WITH ERROR','BIG ERROR: ower _ide_Window_SEW_ found');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _DEBUG_}
        DEBUG('SKIP','Sender undef');
        {$endIf}
    end;

    {$ifDEF _DEBUG_}
    DEBUG('ideEVENT:semWindowFocused','---<<<');
    {$endIf}
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._ideEvent_register_;
begin
    SourceEditorManagerIntf.RegisterChangeEvent(semWindowFocused,  @_ideEvent_semWindowFocused);
    SourceEditorManagerIntf.RegisterChangeEvent(semEditorActivate, @_ideEvent_semEditorActivate);
end;

{%endRegion}

end.
