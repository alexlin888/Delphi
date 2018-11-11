{*******************************************************}
{                                                       }
{       ���������������洰��                            }
{                                                       }
{       ��Ԫ���ƣ�UniStr.pas                            }
{       ��Ŀ���ƣ�ProStr                                }
{                                                       }
{       ���ߣ�Alex                                      }
{       ����ʱ��:2007��07��18��                         }
{                                                       }
{       ��Ȩ���� (C) 2007 �ַ�����                      }
{                                                       }
{*******************************************************}
unit UniStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, ImgList, Buttons, 
  StrUtils, ToolWin, WinSkinData;

type
  //��������ļ�¼
  TrData=record
    bType:Boolean;   //True - ����  False - �ı�
    slMem:TStringList;  //�ı�
    iStart:Integer;     //��ʼ��
    iEnd:Integer;       //������
    iSep:Integer;       //���ּ��
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
    slVal:array [0..8] of TStringList;    //�������
  protected
    procedure SaveTBParam;        //��������ʾҳ��Ĳ���
    procedure LoadTBParam;        //��������ʾҳ��Ĳ���
  public
  end;

var
  fmStr: TfmStr;

implementation
{$R *.dfm}

{-------------------------------------------------------------------------------
  ���̹��ܣ� �������
  �������ƣ� TfmStr.BtnMakerClick
  ���ߣ�     new
  ���ڣ�     2007��08��16��
  ������     Sender: TObject
-------------------------------------------------------------------------------}
procedure TfmStr.BtnMakerClick(Sender: TObject);
var
  i,j,iMax,iPar,iPos,iLeg:Integer;
  sSrc,sRtn,sTmp,sLoc,sVal:String;
begin
  if reSrc.Text='' then
  begin
    ShowMessage('��������Դ��䣬�����޷����ɣ�');
    Exit;
  end;

  SaveTBParam;                          //�ȱ��浱ǰ����
  Self.Enabled:=False;
  memDis.Lines.Clear;
  sSrc:=reSrc.Text;                     //Դ���

  iMax:=StrToIntDef(edtCount.Text,2);   //�����������
  iPar:=tbcVal.Tabs.Count;              //��������

  for i:=1 to iMax do          //�����������
  begin
    sLoc:=sSrc;
    for j:=1 to iPar do        //��������
    begin
      sVal:='[V'+IntToStr(j)+']';
      iLeg:=Length(sVal);
      if slVal[j-1].Count>(i-1) then  //���Ҫ���memo�Ƿ�Խ��
        sTmp:=slVal[j-1][i-1]  //��ȡ��Ҫд����ı�
      else
        sTmp:=' ';

      //д���ı�
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
  ���̹��ܣ� ������������ɾ��
  �������ƣ� TfmStr.reSrcKeyDown
  ���ߣ�     new
  ���ڣ�     2007��07��18��
  ������     Sender: TObject; var Key: Word; Shift: TShiftState
-------------------------------------------------------------------------------}
procedure TfmStr.reSrcKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  ciCount=4;  //���������ַ�����
var
  i:Integer;
begin
  with reSrc do
  begin
    if Key=8 then   //���˸��
    begin
      SelStart:=SelStart-1;
      SelLength:=1;
      if Not(SelAttributes.Protected) then
      begin
        SelStart:=SelStart+1;
        SelLength:=0;
      end;
    end
    else if Key=46 then  //��DEL��
    begin
      SelStart:=SelStart+1;
      SelLength:=1;
      if Not(SelAttributes.Protected) then
      begin
        SelStart:=SelStart-1;
        SelLength:=0;
      end;
    end;

    //����ַ��Ǳ�������ʼ����ɾ��
    if (SelAttributes.Protected) and ((Key=8) or (Key=46)) then
    begin
      Tag:=1;   //����ȡ������״̬�������뿴reSrcProtectChange()
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
        ShowMessage('�ļ�·������ȷ�����ļ�ʧ�ܣ�');
      end;
    end;
  except
  end;
end;

procedure TfmStr.mBtnSaveClick(Sender: TObject);
begin
  try
    SD.Title:='����Դ���ģ��';
    SD.FileName:='Templet';
    SD.Filter:='ģ���ļ�(*.NCT)|*.nct';
    if SD.Execute then
    begin
      try
        reSrc.Lines.SaveToFile(SD.FileName);
      except
        ShowMessage('����·������ȷ������ʧ�ܣ�');
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
  ShowMessage('������ƣ������ظ��������������'+#13+#10+#13+#10+
              '�汾��V 2.0 Release'+#13+#10+#13+#10+
              '���ߣ�Alex Lam'+#13+#10+
              'E-Mail��Alex1225@21cn.com'+#13+#10+#13+#10+
              '��Ȩ����(C) 2007-2008 Neighbor Community');
end;

procedure TfmStr.mBtnOtherSaveClick(Sender: TObject);
begin
  SD.Title:='���������䵽�ļ�';
  SD.Filename:='Result';
  SD.Filter:='�ı��ļ�(*.TXT)|*.txt';
  if SD.Execute then
  begin
    try
      memDis.Lines.SaveToFile(SD.FileName);
    except
      ShowMessage('����·������ȷ������ʧ�ܣ�');
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
      tbcVal.Tabs.Add('����V'+IntToStr(TMenuItem(Sender).Tag));
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
  //��ʼ��
  tbcVal.Tabs.Clear;
  tbcVal.Tabs.Add('����V1');
  for i:=0 to 8 do
    slVal[i]:=TStringList.Create;
//  sdMain.Active:=True;
end;

{-------------------------------------------------------------------------------
  ���̹��ܣ� �ؼ�λ����Ӧ
  �������ƣ� TfmStr.pnlSetResize
  ���ߣ�     new
  ���ڣ�     2007��07��19��
  ������     Sender: TObject
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
  grpVal.Caption:='['+Rightstr(tbcval.Tabs[tbcVal.TabIndex],2)+']����';
  LoadTBParam;
  MemListChange(Self);
end;

procedure TfmStr.tbnExitClick(Sender: TObject);
begin
  Close;
end;

{-------------------------------------------------------------------------------
  ���̹��ܣ� ��������ʾҳ��Ĳ���
  �������ƣ� TfmStr.SaveTBParam
  ���ߣ�     new
  ���ڣ�     2007��07��19��
  ������     ��
-------------------------------------------------------------------------------}
procedure TfmStr.SaveTBParam;
begin
  slVal[tbcVal.TabIndex].Text:=MemList.Text;
end;

{-------------------------------------------------------------------------------
  ���̹��ܣ� ��������ʾҳ��Ĳ���
  �������ƣ� TfmStr.LoadTBParam
  ���ߣ�     new
  ���ڣ�     2007��07��19��
  ������     ��
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
                      '����'+IntToStr(MemList.Lines.Count)+'��';

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
  tbcVal.Tabs.Add('����V1');
end;

procedure TfmStr.PCChange(Sender: TObject);
begin
  case PC.TabIndex of
    0:MemListChange(Self);
    1:SB.Panels[1].Text:='������ '+IntToStr(memDis.Lines.Count)+' �����';
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
