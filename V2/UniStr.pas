{*******************************************************}
{                                                       }
{       功能描述：主界面窗体                            }
{                                                       }
{       单元名称：UniStr.pas                            }
{       项目名称：ProStr                                }
{                                                       }
{       作者：Alex                                      }
{       创建时间:2007年07月18日                         }
{                                                       }
{       版权所有 (C) 2007 街坊公社                      }
{                                                       }
{*******************************************************}
unit UniStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, ImgList, Buttons, 
  StrUtils, ToolWin, WinSkinData;

type
  //储存参数的记录
  TrData=record
    bType:Boolean;   //True - 数字  False - 文本
    slMem:TStringList;  //文本
    iStart:Integer;     //开始数
    iEnd:Integer;       //结束数
    iSep:Integer;       //数字间距
  end;

  TfmStr = class(TForm)
    MnuMain: TMainMenu;
    mnuFile: TMenuItem;
    N3: TMenuItem;
    mBtnExit: TMenuItem;
    PC: TPageControl;
    tsDes: TTabSheet;
    GroupBox2: TGroupBox;
    memDis: TMemo;
    SB: TStatusBar;
    IL: TImageList;
    mBtnMake: TMenuItem;
    mnuIns: TMenuItem;
    mnuOpt: TMenuItem;
    mBtnSave: TMenuItem;
    mBtnOpen: TMenuItem;
    N4: TMenuItem;
    mBtnClearCur: TMenuItem;
    mnuHellp: TMenuItem;
    mBtnAbout: TMenuItem;
    OD: TOpenDialog;
    SD: TSaveDialog;
    N2: TMenuItem;
    mBtnOtherSave: TMenuItem;
    mbtnV1: TMenuItem;
    mbtnV2: TMenuItem;
    mbtnV3: TMenuItem;
    mbtnV4: TMenuItem;
    mbtnV5: TMenuItem;
    mbtnV6: TMenuItem;
    mbtnV7: TMenuItem;
    mbtnV8: TMenuItem;
    mbtnV9: TMenuItem;
    N5: TMenuItem;
    tsMaker: TTabSheet;
    CoolBar: TCoolBar;
    tbStd: TToolBar;
    tbnMaker: TToolButton;
    ToolButton5: TToolButton;
    tbnSave: TToolButton;
    ToolButton1: TToolButton;
    tbnClear: TToolButton;
    tbn1: TToolButton;
    tbnExit: TToolButton;
    il48TB: TImageList;
    pnlSet: TPanel;
    tbcVal: TTabControl;
    grpVal: TGroupBox;
    grpRule: TGroupBox;
    edtTo: TEdit;
    lblSep: TLabel;
    edtSep: TEdit;
    lblTo: TLabel;
    edtFrom: TEdit;
    lblFrom: TLabel;
    splMk: TSplitter;
    MemList: TMemo;
    tbnClearAll: TToolButton;
    tbnOpen: TToolButton;
    mBtnClearAll: TMenuItem;
    btnWrite: TButton;
    pnlCenter: TPanel;
    reSrc: TRichEdit;
    grpCount: TGroupBox;
    edtCount: TEdit;
    mBtnClearTmp: TMenuItem;
    N1: TMenuItem;
    btnAppend: TButton;
    sdK: TSkinData;
    procedure BtnMakerClick(Sender: TObject);
    procedure mBtnExitClick(Sender: TObject);
    procedure reSrcKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtRuleExit(Sender: TObject);
    procedure edtCountExit(Sender: TObject);
    procedure mBtnOpenClick(Sender: TObject);
    procedure mBtnSaveClick(Sender: TObject);
    procedure mBtnClearCurClick(Sender: TObject);
    procedure edtCountKeyPress(Sender: TObject; var Key: Char);
    procedure mBtnAboutClick(Sender: TObject);
    procedure mBtnOtherSaveClick(Sender: TObject);
    procedure mbtnV9Click(Sender: TObject);
    procedure reSrcProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure pnlSetResize(Sender: TObject);
    procedure tbcValChange(Sender: TObject);
    procedure tbnExitClick(Sender: TObject);
    procedure tbcValChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemListChange(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure mBtnClearAllClick(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure mBtnClearTmpClick(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
  private
    slVal:array [0..8] of TStringList;    //储存变量
  protected
    procedure SaveTBParam;        //保存现显示页面的参数
    procedure LoadTBParam;        //载入新显示页面的参数
  public
  end;

var
  fmStr: TfmStr;

implementation
{$R *.dfm}

{-------------------------------------------------------------------------------
  过程功能： 生成语句
  过程名称： TfmStr.BtnMakerClick
  作者：     new
  日期：     2007年08月16日
  参数：     Sender: TObject
-------------------------------------------------------------------------------}
procedure TfmStr.BtnMakerClick(Sender: TObject);
var
  i,j,iMax,iPar,iPos,iLeg:Integer;
  sSrc,sRtn,sTmp,sLoc,sVal:String;
begin
  if reSrc.Text='' then
  begin
    ShowMessage('请先输入源语句，否则无法生成！');
    Exit;
  end;

  SaveTBParam;                          //先保存当前参数
  Self.Enabled:=False;
  memDis.Lines.Clear;
  sSrc:=reSrc.Text;                     //源语句

  iMax:=StrToIntDef(edtCount.Text,2);   //生成语句数量
  iPar:=tbcVal.Tabs.Count;              //参数数量

  for i:=1 to iMax do          //生成语句数量
  begin
    sLoc:=sSrc;
    for j:=1 to iPar do        //参数数量
    begin
      sVal:='[V'+IntToStr(j)+']';
      iLeg:=Length(sVal);
      if slVal[j-1].Count>(i-1) then  //检查要求的memo是否越界
        sTmp:=slVal[j-1][i-1]  //提取将要写入的文本
      else
        sTmp:=' ';

      //写入文本
      While Pos(sVal,sLoc)>0 do
      begin
        iPos:=Pos(sVal,sLoc);
        sLoc:=Copy(sLoc,0,iPos-1)+sTmp+Copy(sLoc,iPos+iLeg,Length(sLoc));
      end;
    end;
    sRtn:=sRtn+sLoc+#13+#10;
  end;

  memDis.Text:=sRtn;
  Self.Enabled:=True;

  memDis.SelectAll;
  memDis.CopyToClipboard;
  memDis.SelStart:=0;
  memDis.SelLength:=0;

  PC.ActivePageIndex:=1;
end;

procedure TfmStr.mBtnExitClick(Sender: TObject);
begin
  Close;
end;

{-------------------------------------------------------------------------------
  过程功能： 处理整个变量删除
  过程名称： TfmStr.reSrcKeyDown
  作者：     new
  日期：     2007年07月18日
  参数：     Sender: TObject; var Key: Word; Shift: TShiftState
-------------------------------------------------------------------------------}
procedure TfmStr.reSrcKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  ciCount=4;  //变量的总字符长度
var
  i:Integer;
begin
  with reSrc do
  begin
    if Key=8 then   //按退格键
    begin
      SelStart:=SelStart-1;
      SelLength:=1;
      if Not(SelAttributes.Protected) then
      begin
        SelStart:=SelStart+1;
        SelLength:=0;
      end;
    end
    else if Key=46 then  //按DEL键
    begin
      SelStart:=SelStart+1;
      SelLength:=1;
      if Not(SelAttributes.Protected) then
      begin
        SelStart:=SelStart-1;
        SelLength:=0;
      end;
    end;

    //如果字符是变量，则开始整个删除
    if (SelAttributes.Protected) and ((Key=8) or (Key=46)) then
    begin
      Tag:=1;   //允许取消保护状态，详情请看reSrcProtectChange()
      Key:=0;
      for i:=0 to ciCount do
      begin
        SelLength:=1;
        if SelText='[' then
        begin
          SelLength:=ciCount;
          SelText:='';
          Break;
        end
        else
          SelStart:=SelStart-1;
      end;
      Tag:=0;
    end;
  end;
end;

procedure TfmStr.edtRuleExit(Sender: TObject);
begin
  TEdit(Sender).Text:=IntToStr(StrToIntDef(TEdit(Sender).Text,1));
end;

procedure TfmStr.edtCountExit(Sender: TObject);
begin
  if StrToIntDef(TEdit(Sender).Text,0)<2 then
    TEdit(Sender).Text:='2';
end;

procedure TfmStr.mBtnOpenClick(Sender: TObject);
begin
  try
    OD.FileName:='Templet';
    if OD.Execute then
    begin
      try
        reSrc.Lines.LoadFromFile(OD.FileName);
      except
        ShowMessage('文件路径不正确，打开文件失败！');
      end;
    end;
  except
  end;
end;

procedure TfmStr.mBtnSaveClick(Sender: TObject);
begin
  try
    SD.Title:='保存源语句模板';
    SD.FileName:='Templet';
    SD.Filter:='模板文件(*.NCT)|*.nct';
    if SD.Execute then
    begin
      try
        reSrc.Lines.SaveToFile(SD.FileName);
      except
        ShowMessage('保存路径不正确，保存失败！');
      end;
    end;
  except
  end;
end;

procedure TfmStr.mBtnClearCurClick(Sender: TObject);
begin
  MemList.Lines.Clear;
end;

procedure TfmStr.edtCountKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    Key:=#0;
    PostMessage(TWinControl(Sender).Handle,WM_KEYDOWN,VK_TAB,0);
  end;
end;

procedure TfmStr.mBtnAboutClick(Sender: TObject);
begin
  ShowMessage('软件名称：楷方重复语句批量生成器'+#13+#10+#13+#10+
              '版本：V 2.0 Release'+#13+#10+#13+#10+
              '作者：Alex Lam'+#13+#10+
              'E-Mail：Alex1225@21cn.com'+#13+#10+#13+#10+
              '版权所有(C) 2007-2008 Neighbor Community');
end;

procedure TfmStr.mBtnOtherSaveClick(Sender: TObject);
begin
  SD.Title:='另存生成语句到文件';
  SD.Filename:='Result';
  SD.Filter:='文本文件(*.TXT)|*.txt';
  if SD.Execute then
  begin
    try
      memDis.Lines.SaveToFile(SD.FileName);
    except
      ShowMessage('保存路径不正确，保存失败！');
    end;
  end;
end;

procedure TfmStr.mbtnV9Click(Sender: TObject);
var
  iStar:Integer;
begin
  With reSrc do
  begin
    iStar:=SelStart;
    SelAttributes.Color:=clRed;
    SelText := '[V'+IntToStr(TMenuItem(Sender).Tag)+']';
    SelStart := iStar;
    SelLength:=4;
    SelAttributes.Protected:=True;
    SelStart:=istar+4;
    SetFocus;

    if Pos(IntToStr(TMenuItem(Sender).Tag),tbcVal.Tabs.Text)=0 then
    begin
      tbcVal.Tabs.Add('变量V'+IntToStr(TMenuItem(Sender).Tag));
    end;
  end;
end;

procedure TfmStr.reSrcProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  if reSrc.Tag=1 then
    AllowChange:=True;
end;

procedure TfmStr.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  //初始化
  tbcVal.Tabs.Clear;
  tbcVal.Tabs.Add('变量V1');
  for i:=0 to 8 do
    slVal[i]:=TStringList.Create;
//  sdMain.Active:=True;
end;

{-------------------------------------------------------------------------------
  过程功能： 控件位置适应
  过程名称： TfmStr.pnlSetResize
  作者：     new
  日期：     2007年07月19日
  参数：     Sender: TObject
-------------------------------------------------------------------------------}
procedure TfmStr.pnlSetResize(Sender: TObject);
var
  iTextWidth:Integer;
begin
 // if pnlSet.Width<150 then Exit;
//    pnlSet.Width:=160;
//  if splMk.Left<160 then
//    splMk.Left:=160;

  edtCount.Width:=grpCount.Width-8;

  iTextWidth:=(grpRule.Width-lblFrom.Width-lblTo.Width-lblSep.Width) div 3;
  edtFrom.Width:=iTextWidth;
  edtTo.Width:=iTextWidth;
  edtSep.Width:=iTextWidth;

  lblFrom.Left:=0;
  edtFrom.Left:=lblFrom.Left+lblFrom.Width;
  lblTo.Left:=edtFrom.Left+edtFrom.Width;
  edtTo.Left:=lblTo.Left+lblTo.Width;
  lblSep.Left:=edtTo.Left+edtTo.Width;
  edtSep.Left:=lblSep.Left+lblSep.Width-4;
//  btnWrite.Width:=grpRule.Width-16;
end;

procedure TfmStr.tbcValChange(Sender: TObject);
begin
  grpVal.Caption:='['+Rightstr(tbcval.Tabs[tbcVal.TabIndex],2)+']设置';
  LoadTBParam;
  MemListChange(Self);
end;

procedure TfmStr.tbnExitClick(Sender: TObject);
begin
  Close;
end;

{-------------------------------------------------------------------------------
  过程功能： 保存现显示页面的参数
  过程名称： TfmStr.SaveTBParam
  作者：     new
  日期：     2007年07月19日
  参数：     无
-------------------------------------------------------------------------------}
procedure TfmStr.SaveTBParam;
begin
  slVal[tbcVal.TabIndex].Text:=MemList.Text;
end;

{-------------------------------------------------------------------------------
  过程功能： 载入新显示页面的参数
  过程名称： TfmStr.LoadTBParam
  作者：     new
  日期：     2007年07月19日
  参数：     无
-------------------------------------------------------------------------------}
procedure TfmStr.LoadTBParam;
begin
  MemList.Text := slVal[tbcVal.TabIndex].Text;
end;


procedure TfmStr.tbcValChanging(Sender: TObject; var AllowChange: Boolean);
begin
  SaveTBParam;
end;

procedure TfmStr.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i:Integer;
begin
  for i:=0 to 8 do
  begin
    slVal[i]:=nil;
    slVal[i].Free;
  end;
end;

procedure TfmStr.MemListChange(Sender: TObject);
begin
  SB.Panels[1].Text:=tbcVal.Tabs.Strings[tbcVal.tabIndex]+
                      '共：'+IntToStr(MemList.Lines.Count)+'行';

  if MemList.Lines.Count>StrToIntDef(edtCount.Text,0) then
    edtCount.Text:=IntToStr(MemList.Lines.Count);
end;

procedure TfmStr.btnWriteClick(Sender: TObject);
var
  i,j,k:Integer;
begin
  i:=StrToInt(edtFrom.Text);
  j:=StrToInt(edtTo.Text);
  k:=StrToInt(edtSep.Text);
  while i<=j do
  begin
    MemList.Lines.Add(IntToStr(i));
    i:=k+i;
  end;
end;

procedure TfmStr.mBtnClearAllClick(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 8 do
  begin
    slVal[i].Clear;
//    if Pos(,reSrc.Text)
  end;
  tbnCLear.Click;

  tbcVal.Tabs.Clear;
  tbcVal.Tabs.Add('变量V1');
end;

procedure TfmStr.PCChange(Sender: TObject);
begin
  case PC.TabIndex of
    0:MemListChange(Self);
    1:SB.Panels[1].Text:='共生成 '+IntToStr(memDis.Lines.Count)+' 行语句';
  end;
end;

procedure TfmStr.mBtnClearTmpClick(Sender: TObject);
begin
  reSrc.Clear;
end;
                                         
procedure TfmStr.btnAppendClick(Sender: TObject);
var
  i,j,k,l:Integer;
begin
  i:=StrToInt(edtFrom.Text);
  j:=StrToInt(edtTo.Text);
  k:=StrToInt(edtSep.Text);
  l:=0;
  while i<=j do
  begin
    if MemList.Lines.Count<l+1 then
      MemList.Lines.Add(IntToStr(i))
    else
      MemList.Lines[l]:=MemList.Lines[l]+IntToStr(i);    
    Inc(l);
    i:=k+i;
  end;
end;

end.
