unit lazExt_aBTF_CodeExplorer;

{$mode objfpc}{$H+}

interface
(*
{$I in0k_lazExt_aBTF_CodeExplorer_INI.inc}

{%region --- setUp INLINE SETTINGs for Compile     ---------------- /fold}
{$undef _lazExt_aBTF_CodeExplorer_API_001_}
{$undef _lazExt_aBTF_CodeExplorer_API_002_}
{$undef _lazExt_aBTF_CodeExplorer_API_003_}
{$undef _lazExt_aBTF_CodeExplorer_API_004_}
{$undef _lazExt_aBTF_CodeExplorer_API_005_}
//----
{$ifDef lazExt_aBTF_CodeExplorer_Auto_SHOW}
    {$define _lazExt_aBTF_CodeExplorer_API_001_}
{$endif}
{$ifDef lazExt_aBTF_CodeExplorer_WinAPI_mode}
    //---- под Виндой
    {$undef  _lazExt_aBTF_CodeExplorer_API_002_}
    {$define _lazExt_aBTF_CodeExplorer_API_003_}
    {$ifdef lazExt_aBTF_CodeExplorer_cacheCodeExplorer}
    {$define _lazExt_aBTF_CodeExplorer_API_004_}
    {$endif}
    {$define _lazExt_aBTF_CodeExplorer_API_005_}
{$else}
    //---- стандартный (через IDE Lazarus) метод работы
    {$define _lazExt_aBTF_CodeExplorer_API_002_}
    {$define _lazExt_aBTF_CodeExplorer_API_001_}
{$endif}
{$ifDef lazExt_aBTF_CodeExplorer_EventLOG_mode}
    {$define _EventLOG_}
{$else}
    {$undef  _EventLOG_}
{$endIf}
{$define _INLINE_}
{%endRegion}
{%region --- Hint about Global SETTINGs on Compile ---------------- /fold}
{$hint 'SETTINGs info: ---------------------------->>>'}
{$ifDef lazExt_aBTF_CodeExplorer_EventLOG_mode}
    {$hint 'lazExt_aBTF_CodeExplorer_EventLOG_mode On'}
{$else}
    {$hint 'lazExt_aBTF_CodeExplorer_EventLOG_mode OFF'}
{$endif}
{$ifDef lazExt_aBTF_CodeExplorer_Auto_SHOW}
    {$hint 'lazExt_aBTF_CodeExplorer_Auto_SHOW On'}
{$else}
    {$hint 'lazExt_aBTF_CodeExplorer_Auto_SHOW OFF'}
{$endif}
{$ifDef lazExt_aBTF_CodeExplorer_WinAPI_mode}
    {$hint 'lazExt_aBTF_CodeExplorer_WinAPI_mode On'}
{$else}
    {$hint 'lazExt_aBTF_CodeExplorer_WinAPI_mode OFF'}
{$endif}
{$ifDef lazExt_aBTF_CodeExplorer_cacheCodeExplorer}
    {$hint 'lazExt_aBTF_CodeExplorer_cacheCodeExplorer On'}
{$else}
    {$hint 'lazExt_aBTF_CodeExplorer_cacheCodeExplorer OFF'}
{$endif}
{$hint '<<<---------------------------------------->>>'}
{%endRegion}
*)
(*uses {$ifDEF lazExt_aBTF_CodeExplorer_EventLOG_mode}
        sysutils, Dialogs, lazExt_aBTF_CodeExplorer_DEBUG,
     {$endIf}
     {$ifDEF lazExt_aBTF_CodeExplorer_WinAPI_mode}
        windows, Controls,
     {$endIf}
     SrcEditorIntf, IDECommands,
     Classes, Forms;

type

 tLazExt_BTF_CodeExplorer=class
  {%region --- CodeExplorer Window IDECommand --------------------- /fold}
  {$ifDef _lazExt_aBTF_CodeExplorer_API_001_}
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
  private
    procedure _SEW_SET(const wnd:TSourceEditorWindowInterface);
  {%endRegion}
  {%region --- ВСЯ СУТь ------------------------------------------- /fold}
  protected
    function _do_BTF_CodeExplorer_:boolean;
  protected
    {$ifDef _lazExt_aBTF_CodeExplorer_API_002_}
    function _do_BTF_CodeExplorer_do_wndCE_OPN:boolean;
    function _do_BTF_CodeExplorer_do_wndSE_BTF:boolean;
    function _do_BTF_CodeExplorer_use_ideLaz:boolean; {$ifDEF _INLINE_}inline;{$endIf}
    {$endIf}
    {$ifDef _lazExt_aBTF_CodeExplorer_API_003_}
    function _do_BTF_CodeExplorer_use_winAPI:boolean; {$ifDEF _INLINE_}inline;{$endIf}
    {$endIf}
  {%endRegion}
  {%region --- ide_Window_CEV : API_004 --------------------------- /fold}
  {$ifDef _lazExt_aBTF_CodeExplorer_API_004_}
  strict private
   _ide_Window_CEV_:tForm;                        //< найденное окно
   _ide_Window_CEV_onClose_original_:TCloseEvent; //< его событие при выходе
    procedure _CEV_onClose_myCustom_(Sender:TObject; var CloseAction:TCloseAction);
    procedure _CEV_rePlace_onClose(const wnd:tForm);
    procedure _CEV_reStore_onClose(const wnd:tForm);
  private
    procedure _CEV_SET_(const wnd:tForm);
  {$endIf}
  {%endRegion}
  {%region --- ide_Window_CEV : API_005 --------------------------- /fold}
  {$ifDef _lazExt_aBTF_CodeExplorer_API_005_}
  strict private
    function  _CEV_find_inSCREEN:TForm;
    function  _CEV_find_:TForm;
  private
    function  _CEV_GET:TForm;
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
*)
implementation
(*
{$ifDEF _EventLOG_}
const
   _cPleaseReport_=
        LineEnding+
        'EN: Please report this error to the developer.'+LineEnding+
        'RU: Пожалуйста, сообщите об этой ошибке разработчику.'+
        LineEnding;
{$endIf}

constructor tLazExt_BTF_CodeExplorer.Create;
begin
    {$ifDef _lazExt_aBTF_CodeExplorer_API_001_}
   _IDECommand_OpnCEV_:=NIL;
    {$endIf}
    {$ifDef _lazExt_aBTF_CodeExplorer_API_004_}
   _ide_Window_CEV_:=NIL;
    {$endIf}
   _ide_Window_SEW_:=NIL;
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

{$ifDef _lazExt_aBTF_CodeExplorer_API_001_}

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
    {$ifDEF _EventLOG_}
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
        {$ifDEF _EventLOG_}
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
    {$ifDEF _EventLOG_}
    DEBUG('_SEW_onDeactivate_myCustom','--->>> Sender'+addr2txt(Sender));
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
                {$ifDEF _EventLOG_}
                DEBUG('OK','TSourceEditorWindowInterface('+addr2txt(sender)+').OnDeactivate executed');
                {$endIf}
            end;
        end
        else begin
            {$ifDEF _EventLOG_}
            DEBUG('ER','Sender is NOT TSourceEditorWindowInterface');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('ER','Sender==NIL');
        {$endIf}
    end;

    {$ifDEF _EventLOG_}
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
        {$ifDEF _EventLOG_}
        DEBUG('_SEW_rePlace_onDeactivate','rePALCE wnd'+addr2txt(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('_SEW_rePlace_onDeactivate','SKIP wnd'+addr2txt(wnd));
        {$endIf}
    end
end;

// ВОСТАНАВЛИВАЕМ `onDeactivate` на то что было
procedure tLazExt_BTF_CodeExplorer._SEW_reStore_onDeactivate(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnDeactivate=@_SEW_onDeactivate_myCustom) then begin
        wnd.OnDeactivate:=_ide_Window_SEW_onDeactivate_original;
       _ide_Window_SEW_onDeactivate_original:=NIL;
        {$ifDEF _EventLOG_}
        DEBUG('_SEW_reStore_onDeactivate','wnd'+addr2txt(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('_SEW_reStore_onDeactivate','SKIP wnd'+addr2txt(wnd));
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._SEW_SET(const wnd:TSourceEditorWindowInterface);
begin
    if wnd<>_ide_Window_SEW_ then begin
        if Assigned(_ide_Window_SEW_)
        then begin
           _SEW_reStore_onDeactivate(_ide_Window_SEW_);
            {$ifDEF _EventLOG_}
            DEBUG('ERROR','_SEW_SET inline var _ide_Window_SEW_<>NIL');
            ShowMessage('_SEW_SET inline var _ide_Window_SEW_<>NIL'+_cPleaseReport_);
            {$endIf}
        end;
       _SEW_rePlace_onDeactivate(wnd);
       _ide_Window_SEW_:=wnd;
    end;
end;

{%endRegion}

{%region --- ВСЯ СУТь --------------------------------------------- /fold}

{$ifDef _lazExt_aBTF_CodeExplorer_API_002_}

// открыть и вытащить на передний план окно `CodeExplorerView`
function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_do_wndCE_OPN:boolean;
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
        {$ifDEF _EventLOG_}
        DEBUG('ok','ActiveSourceWindow.BringToFront');
        {$endIf}
    end
    else begin
        result:=false;
        {$ifDEF _EventLOG_}
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
   _SEW_reStore_onDeactivate(_ide_Window_SEW_);
    result:=_do_BTF_CodeExplorer_do_wndCE_OPN
            and
            _do_BTF_CodeExplorer_do_wndSE_BTF;
   _SEW_rePlace_onDeactivate(_ide_Window_SEW_);
end;

{$endIf}

//==============================================================================

{$ifDef _lazExt_aBTF_CodeExplorer_API_003_}

function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_use_winAPI:boolean;
var dwp:HDWP;
    cev:tForm;
begin
    cev:=_CEV_GET;
    if Assigned(cev) and Assigned(_ide_Window_SEW_) then begin
        dwp:=BeginDeferWindowPos(1);
        DeferWindowPos(dwp,cev.Handle,_ide_Window_SEW_.Handle,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
        result:=EndDeferWindowPos(dwp);
    end
    else begin
        result:=false;
        {$ifDEF _EventLOG_}
        if not Assigned(_ide_Window_SEW_) then DEBUG('EVENT','_ide_Window_SEW_==nil');
        if not Assigned(cev)              then DEBUG('EVENT','_ide_Window_CEV_==nil');
        {$endIf}
    end;
end;

{$endIf}

//==============================================================================

function tLazExt_BTF_CodeExplorer._do_BTF_CodeExplorer_:boolean;
begin
    {$ifDef lazExt_aBTF_CodeExplorer_WinAPI_mode}
        result:=_do_BTF_CodeExplorer_use_winAPI;
    {$else} //< "стандартными" средствами IDE lazarus
        result:=_do_BTF_CodeExplorer_use_ideLaz;
    {$endIf}
    {$ifDEF _EventLOG_}
    if result then DEBUG('BTF_CodeExplorer','OK')
              else DEBUG('BTF_CodeExplorer','ER');
    {$endIf}
end;

{%endRegion}

{%region --- ide_Window_CEV : API_004 ----------------------------- /fold}

{$ifDef _lazExt_aBTF_CodeExplorer_API_004_}

procedure tLazExt_BTF_CodeExplorer._CEV_onClose_myCustom_(Sender:TObject; var CloseAction:TCloseAction);
begin
    {$ifDEF _EventLOG_}
    DEBUG('_CEV_onClose_myCustom_','--->>> Sender'+addr2txt(Sender));
    {$endIf}

    if Sender=_ide_Window_CEV_ then begin
        // отмечаем что ВЫШЛИ из окна
       _ide_Window_CEV_:=NIL;
        // восстановить событие `onDeactivate` на исходное, и выполнияем его
        if Assigned(Sender) then begin
            if Sender is TForm then begin
               _CEV_reStore_onClose(tForm(Sender));
                with tForm(Sender) do begin
                    if Assigned(OnClose) then OnClose(Sender,CloseAction);
                    {$ifDEF _EventLOG_}
                    DEBUG('OK','TForm('+addr2txt(sender)+').onClose executed');
                    {$endIf}
                end;
            end
            else begin
                {$ifDEF _EventLOG_}
                DEBUG('ER','Sender is NOT TForm');
                {$endIf}
            end;
        end
        else begin
            {$ifDEF _EventLOG_}
            DEBUG('ER','Sender==NIL');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('ER','Sender<>_ide_Window_CEV_');
        {$endIf}
    end;

    {$ifDEF _EventLOG_}
    DEBUG('_CEV_onClose_myCustom_','---<<<');
    {$endIf}
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._CEV_rePlace_onClose(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnClose<>@_CEV_onClose_myCustom_) then begin
       _ide_Window_CEV_onClose_original_:=wnd.OnClose;
        wnd.OnClose:=@_CEV_onClose_myCustom_;
        {$ifDEF _EventLOG_}
        DEBUG('_CEV_rePlace_onClose','rePALCE wnd'+addr2txt(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('_CEV_rePlace_onClose','SKIP wnd'+addr2txt(wnd));
        {$endIf}
    end
end;

procedure tLazExt_BTF_CodeExplorer._CEV_reStore_onClose(const wnd:tForm);
begin
    if Assigned(wnd) and (wnd.OnClose=@_CEV_onClose_myCustom_) then begin
        wnd.OnClose:=_ide_Window_CEV_onClose_original_;
       _ide_Window_CEV_onClose_original_:=NIL;
        {$ifDEF _EventLOG_}
        DEBUG('_CEV_reStore_onClose','wnd'+addr2txt(wnd));
        {$endIf}
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('_CEV_reStore_onClose','SKIP wnd'+addr2txt(wnd));
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._CEV_SET_(const wnd:tForm);
begin
    if wnd<>_ide_Window_CEV_ then begin
        if Assigned(_ide_Window_CEV_)
        then begin
           _CEV_reStore_onClose(_ide_Window_CEV_);
            {$ifDEF _EventLOG_}
            DEBUG('ERROR','_CEV_SET_ inline var _ide_Window_CEV_==NIL');
            ShowMessage('_SEW_SET inline var _ide_Window_SEW_<>NIL'+_cPleaseReport_);
            {$endIf}
        end;
       _CEV_rePlace_onClose(wnd);
       _ide_Window_CEV_:=wnd;
    end;
end;

{$endIf}

{%endRegion}

{%region --- ide_Window_CEV : API_005 ----------------------------- /fold}

{$ifDef _lazExt_aBTF_CodeExplorer_API_005_}

const //< тут возможно придется определять относительно ВЕРСИИ ЛАЗАРУСА
  cWndCEV_className='TCodeExplorerView';

function tLazExt_BTF_CodeExplorer._CEV_find_inSCREEN:TForm;
var i:integer;
    f:TForm;
begin
    result:=nil;
    for i:=0 to Screen.FormCount-1 do begin
        f:=Screen.Forms[i];
        {$ifDEF _EventLOG_}
        DEBUG('CEV','Find in SCREEN '+f.ClassName);
        {$endIf}
        if f.ClassNameIs(cWndCEV_className) then begin
            result:=f;
            {$ifDEF _EventLOG_}
            DEBUG('CEV','FOUND '+cWndCEV_className+addr2txt(f));
            {$endIf}
            break;
        end;
    end;
end;


// исчем ЭКЗЕМПЛЯР окна
//  поиск по ИМЕНИ класса в хранилище открытых окон `Screen.Form`
function tLazExt_BTF_CodeExplorer._CEV_find_:TForm;
begin
    {$ifDef _lazExt_aBTF_CodeExplorer_API_004_}
    if not Assigned(_ide_Window_CEV_) then begin
        result:=_CEV_find_inSCREEN;
       _CEV_SET_(result);
    end
    else begin
        result:=_ide_Window_CEV_;
    end;
    {$else}
    result:=_CEV_find_inSCREEN;
    {$endIf}
end;

//------------------------------------------------------------------------------

function tLazExt_BTF_CodeExplorer._CEV_GET:TForm;
begin
    result:=_CEV_find_;
    {$ifDef lazExt_aBTF_CodeExplorer_Auto_SHOW}
    if (not Assigned(result))or(not result.Visible) then begin
        {$ifDEF _EventLOG_}
        DEBUG('CEV','NOT FOUND, mast by CREATE');
        {$endIf}
        // вызываем окно `CodeExplorerView`, оно встанет на ПЕРЕДНИЙ план
        // все это приводит к излишним дерганиям и как-то через Ж.
       _SEW_reStore_onDeactivate(_ide_Window_SEW_);
       _IDECommand_OpnCEV_execute_;
       _SEW_rePlace_onDeactivate(_ide_Window_SEW_);
        // теперь сного его поисчем
        result:=_CEV_find_;
        {$ifDEF _EventLOG_}
        if not Assigned(result) then begin
            DEBUG('CEV','NOT FOUND !!! BIG ERROR: possible name "'+cWndCEV_className+'" is WRONG');
            ShowMessage('_CEV_GET:NOT FOUND !!! BIG ERROR: possible name "'+cWndCEV_className+'" is WRONG'+_cPleaseReport_);
        end;
        {$endIf}
    end;
    {$endIf}
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
                {$ifDEF _EventLOG_}
                DEBUG('SKIP','already processed');
                {$endIf}
            end;
        end
        else begin
           _ideEvent_Editor_:=nil;
            {$ifDEF _EventLOG_}
            DEBUG('ER','ActiveEditor is NULL');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('ER','IDE not ready');
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tLazExt_BTF_CodeExplorer._ideEvent_semEditorActivate(Sender:TObject);
begin
    {$ifDEF _EventLOG_}
    DEBUG('ideEVENT:semEditorActivate','--->>>'+' sender'+addr2txt(Sender));
    {$endIf}

    if assigned(_ide_Window_SEW_) //< запускаемся только если окно
    then _ideEvent_exeEvent_      //  редактирования в ФОКУСЕ
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('SKIP','ActiveSourceWindow is UNfocused');
        {$endIf}
    end;

    {$ifDEF _EventLOG_}
    DEBUG('ideEVENT:semEditorActivate','---<<<');
    {$endIf}
end;

procedure tLazExt_BTF_CodeExplorer._ideEvent_semWindowFocused(Sender:TObject);
begin
    {$ifDEF _EventLOG_}
    DEBUG('ideEVENT:semWindowFocused','--->>>'+' sender'+addr2txt(Sender));
    {$endIf}

    if Assigned(Sender) and (Sender is TSourceEditorWindowInterface) then begin
       _SEW_SET(TSourceEditorWindowInterface(Sender));
        if Assigned(_ide_Window_SEW_) then begin
           _ideEvent_exeEvent_;
        end
        else begin
            {$ifDEF _EventLOG_}
            DEBUG('SKIP WITH ERROR','BIG ERROR: ower _ide_Window_SEW_ found');
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('SKIP','Sender undef');
        {$endIf}
    end;

    {$ifDEF _EventLOG_}
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
*)
end.
