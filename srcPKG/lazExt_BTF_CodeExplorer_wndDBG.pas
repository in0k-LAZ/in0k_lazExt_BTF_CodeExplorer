unit lazExt_BTF_CodeExplorer_wndDBG;

{$mode objfpc}{$H+}

interface

uses MenuIntf,
  SysUtils, Forms, StdCtrls, ActnList;

procedure RegisterInIDE(const Name,Caption:string);

type

  Tin0kLazExtWndDBG = class(TForm)
    a_Clear: TAction;
    a_Save: TAction;
    ActionList1: TActionList;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure a_ClearExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  public
    procedure Message(const TextMSG:string);
    procedure Message(const msgTYPE,msgTEXT:string);
  end;

procedure in0kLazExtWndDBG_SHOW;
procedure in0kLazExtWndDBG_Message(const TextMSG:string);
procedure in0kLazExtWndDBG_Message(const msgTYPE,msgTEXT:string);

implementation

{%region --- for IDE lazarus -------------------------------------- /fold}

procedure _onClickIdeMenuItem_(Sender: TObject);
begin
    in0kLazExtWndDBG_SHOW;
end;

procedure RegisterInIDE(const Name,Caption:string);
begin
    RegisterIDEMenuCommand(itmViewIDEInternalsWindows, Name,Caption,nil,@_onClickIdeMenuItem_);
end;

{%endregion}

var in0kLazExtWndDBG:Tin0kLazExtWndDBG;

procedure in0kLazExtWndDBG_SHOW;
begin
    if not Assigned(in0kLazExtWndDBG) then begin
        in0kLazExtWndDBG:=Tin0kLazExtWndDBG.Create(Application);
        in0kLazExtWndDBG.Show;
    end;
    in0kLazExtWndDBG.BringToFront;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure in0kLazExtWndDBG_Message(const TextMSG:string);
begin
    if Assigned(in0kLazExtWndDBG) then in0kLazExtWndDBG.Message(TextMSG);
end;

procedure in0kLazExtWndDBG_Message(const msgTYPE,msgTEXT:string);
begin
    if Assigned(in0kLazExtWndDBG) then in0kLazExtWndDBG.Message(msgTYPE,msgTEXT);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$R *.lfm}

procedure Tin0kLazExtWndDBG.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    CloseAction:=caFree;
    in0kLazExtWndDBG.ActionList1:=NIL;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure Tin0kLazExtWndDBG.a_ClearExecute(Sender: TObject);
begin
    memo1.Clear;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const
  _c_bOPN_='[';
  _c_bCLS_=']';
  _c_PRBL_=' '; //< ^-) изменить имя

procedure Tin0kLazExtWndDBG.Message(const TextMSG:string);
var tmp:string;
begin
    DateTimeToString(tmp,'hh:mm:ss`zzz',now);
    with memo1 do begin
        Lines.Insert(0,tmp+_c_PRBL_+TextMSG);
        SelLength:=0;
        SelStart:=0;
    end;
end;

procedure Tin0kLazExtWndDBG.Message(const msgTYPE,msgTEXT:string);
begin
    if msgTYPE<>''
    then Message(_c_bOPN_+msgTYPE+_c_bCLS_+_c_PRBL_+msgTEXT)
    else Message(                                   msgTEXT);
end;

end.

