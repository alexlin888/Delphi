unit UniStr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, ImgList, Buttons, ToolWin,
  WinSkinData;

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
    mBtnNum: TMenuItem;
    mBtnChr: TMenuItem;
    N3: TMenuItem;
    mBtnExit: TMenuItem;
    PC: TPageControl;
    tsSrc: TTabSheet;
    tsDes: TTabSheet;
    gbMaker: TGroupBox;
    gb: TGroupBox;
    GroupBox2: TGroupBox;
    memDis: TMemo;
    Sp: TSplitter;
    SB: TStatusBar;
    IL: TImageList;
    TC: TTabControl;
    rg: TRadioGroup;
    Panel1: TPanel;
    bbCrt: TBitBtn;
    txtCol: TEdit;
    Label2: TLabel;
    reSrc: TRichEdit;
    txtMax: TEdit;
    Label4: TLabel;
    mBtnMake: TMenuItem;
    N1: TMenuItem;
    O1: TMenuItem;
    mBtnSave: TMenuItem;
    mBtnOpen: TMenuItem;
    N4: TMenuItem;
    ToolBar1: TToolBar;
    tBtnNum: TToolButton;
    tBtnChr: TToolButton;
    ToolButton3: TToolButton;
    tBtnMake: TToolButton;
    mBtnClear: TMenuItem;
    H1: TMenuItem;
    mBtnAbout: TMenuItem;
    OD: TOpenDialog;
    SD: TSaveDialog;
    gbParm: TGroupBox;
    MemList: TMemo;
    panNum: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    txt1: TEdit;
    txt2: TEdit;
    txtBtw: TEdit;
    N2: TMenuItem;
    mBtnOtherSave: TMenuItem;
    sdMain: TSkinData;
    procedure BtnMakerClick(Sender: TObject);
    procedure rgClick(Sender: TObject);
    procedure mBtnNumClick(Sender: TObject);
    procedure mBtnChrClick(Sender: TObject);
    procedure mBtnExitClick(Sender: TObject);
    procedure bbCrtClick(Sender: TObject);
    procedure TCChanging(Sender: TObject; var AllowChange: Boolean);
    procedure TCChange(Sender: TObject);
    procedure reSrcKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txt2Exit(Sender: TObject);
    procedure txtMaxExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mBtnOpenClick(Sender: TObject);
    procedure mBtnSaveClick(Sender: TObject);
    procedure mBtnClearClick(Sender: TObject);
    procedure txtMaxKeyPress(Sender: TObject; var Key: Char);
    procedure mBtnAboutClick(Sender: TObject);
    procedure mBtnOtherSaveClick(Sender: TObject);
  private
    rData:array of TrData;
  protected
    procedure SaveParam;      //载入新显示页面的参数
    procedure LoadParam;      //载入新显示页面的参数
    procedure RstParam;       //重置参数列表
    procedure ChgSt;          //改变设置栏的状态
  public
    { Public declarations }
  end;

var
  fmStr: TfmStr;

implementation

{$R *.dfm}
{$R windowsxp.res}

procedure TfmStr.BtnMakerClick(Sender: TObject);
var
  i,j,iMax,iPar,iPos,iLeg,iSign,iAns:Integer;
  sSrc,sRtn,sTmp,sLoc,sType:String;
begin
  if reSrc.Text='' then
  begin
    ShowMessage('请先输入源语句，否则无法生成！');
    Exit;
  end;
  SaveParam;  //先保存当前参数
  Self.Enabled:=False;
  memDis.Lines.Clear;
  sSrc:=reSrc.Text;                  //源语句

  iMax:=StrToIntDef(txtMax.Text,2);   //生成语句数量
  iPar:=StrToIntDef(txtCol.Text,1);   //参数数量

  for i:=1 to iMax do          //生成语句数量
  begin
    sLoc:=sSrc;
    for j:=1 to iPar do        //参数数量
    begin
      if rData[j-1].bType then //如果是数字
      begin
        //判断数字递增或递减
        if (rData[j-1].iEnd-rData[j-1].iStart)>=0 then
          iSign:=1
        else
          iSign:=-1;
        //计算应该填入的数字
        iAns:=(i-1)*iSign*rData[j-1].iSep+rData[j-1].iStart;


        //判断数字是否超出范围
        if iSign=1 then
        begin
          if (iAns<rData[j-1].iStart) or (iAns>rData[j-1].iEnd) then
            sTmp:=' '
          else
            sTmp:=IntToStr(iAns);
        end
        else
        begin
          if (iAns>rData[j-1].iStart) or (iAns<rData[j-1].iEnd) then
            sTmp:=' '
          else
            sTmp:=IntToStr(iAns);
        end;

        iLeg:=Length('[%d#'+IntToStr(j)+']');
        sType:='[%d#'+IntToStr(j)+']';
      end
      else      //如果是文本
      begin
        iLeg:=Length('[%s#'+IntToStr(j)+']');
        if rData[j-1].slMem.Count>(i-1) then  //检查要求的memo是否越界
          sTmp:=rData[j-1].slMem[i-1]  //提取将要写入的文本
        else
          sTmp:=' ';
        sType:='[%s#'+IntToStr(j)+']';
      end;

      //写入数字或文本
      While Pos(sType,sLoc)>0 do
      begin
        iPos:=Pos(sType,sLoc);
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

procedure TfmStr.rgClick(Sender: TObject);
begin
  ChgSt;
end;

procedure TfmStr.mBtnNumClick(Sender: TObject);
begin
  if rg.ItemIndex=0 then
  begin
    reSrc.SelAttributes.Color:=clRed;
    reSrc.SelText := '[%d#'+IntToStr(Tc.TabIndex+1)+']';
    reSrc.SetFocus;
  end
  else
    ShowMessage('本参数类型只能插入文本变量');
end;

procedure TfmStr.mBtnChrClick(Sender: TObject);
begin
  if rg.ItemIndex=1 then
  begin
    reSrc.SelAttributes.Color:=clRed;
    reSrc.SelText := '[%s#'+IntToStr(Tc.TabIndex+1)+']';
    reSrc.SetFocus;
  end
  else
    ShowMessage('本参数类型只能插入数字变量');
end;

procedure TfmStr.mBtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmStr.bbCrtClick(Sender: TObject);
var
  i:Integer;
begin
  i:=StrToIntDef(txtCol.Text,0);
  if ((i<1) or (i>50)) then
  begin
    ShowMessage('输入的参数数量范围只能是(1-50)，请输入正确的列数!');
    Exit;
  end;

  if Application.MessageBox(PChar('你输入的所有数据将会丢失，是否继续？'),
    '重置列表',MB_YesNo or MB_ICONWARNING)=ID_No then
      Exit;
  RstParam;
end;

procedure TfmStr.TCChanging(Sender: TObject; var AllowChange: Boolean);
begin
  SaveParam; //保存旧页面的参数
end;

procedure TfmStr.TCChange(Sender: TObject);
begin
  LoadParam; //载入新页面的参数
end;

procedure TfmStr.reSrcKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if reSrc.SelAttributes.Color<>clBlack then
    reSrc.SelAttributes.Color:=clBlack;
end;

procedure TfmStr.txt2Exit(Sender: TObject);
begin
  TEdit(Sender).Text:=IntToStr(StrToIntDef(TEdit(Sender).Text,0));
end;

procedure TfmStr.txtMaxExit(Sender: TObject);
begin
  if StrToIntDef(txtMax.Text,0)<2 then
    txtMax.Text:='2';
end;

//载入新显示页面的参数
procedure TfmStr.LoadParam;
begin
  With rData[TC.TabIndex] do
  begin
    //载入Memo
    if slMem=nil then
      MemList.Lines.Clear
    else
      MemList.Lines:=TStrings(slMem);

    //载入类型
      if bType then
        rg.ItemIndex:=0
      else
        rg.ItemIndex:=1;
    //载入起止数字
      txt1.Text:=IntToStr(iStart);
      txt2.Text:=IntToStr(iEnd);
      txtBtw.Text:=IntToStr(iSep);
  end;

  ChgSt;

end;

//保存旧页面的参数
procedure TfmStr.SaveParam;
var
  i:Integer;
begin
  With rData[TC.TabIndex] do
  begin
    if Not(Assigned(slMem)) then
      slMem:=TStringList.Create;
    //写入Memo
    slMem.Clear;
    for i:=0 to MemList.Lines.Count-1 do
      slMem.Add(MemList.Lines[i]);
    //写入类型
      bType:=(rg.ItemIndex=0);
    //写入起止数字
      iStart:=StrToIntDef(txt1.Text,0);
      iEnd:=StrToIntDef(txt2.Text,1);
    //写入间距
      iSep:=StrToIntDef(txtBtw.Text,1);
  end;
end;

procedure TfmStr.FormShow(Sender: TObject);
begin
  RstParam;
end;

procedure TfmStr.RstParam;
var
  i,iTmp:Integer;
begin
  iTmp:=StrToIntDef(txtCol.Text,0);
  TC.Tabs.Clear;
  for i:=1 to iTmp do
    TC.Tabs.Add(IntToStr(i));
  SetLength(rData,iTmp);

  //初始化rData的值
  for i:=0 to iTmp-1 do
  begin
    rData[i].bType:=True;
    rData[i].slMem:=TStringList.Create;
    rData[i].iStart:=0;
    rData[i].iEnd:=9;
    rData[i].iSep:=1;
  end;

  ChgSt;
end;

procedure TfmStr.mBtnOpenClick(Sender: TObject);
begin
  if OD.Execute then
  begin
    try
      reSrc.Lines.LoadFromFile(OD.FileName); 
    except
      ShowMessage('文件路径不正确，打开文件失败！');
    end;
  end;
end;

procedure TfmStr.mBtnSaveClick(Sender: TObject);
begin
  SD.Title:='保存源语句到文件';
  if SD.Execute then
  begin
    try
      reSrc.Lines.SaveToFile(SD.FileName);
    except
      ShowMessage('保存路径不正确，保存失败！');
    end;
  end;
end;

procedure TfmStr.mBtnClearClick(Sender: TObject);
begin
  reSrc.Clear;
  memDis.Lines.Clear;
end;

//改变设置栏的状态
procedure TfmStr.ChgSt;
begin
  panNum.Enabled:=(rg.ItemIndex=0);
  MemList.Enabled:=Not(panNum.Enabled);

  if panNum.Enabled then
  begin
    txt1.Color:=$00E4FAE4;
    txt2.Color:=txt1.Color;
    txtBtw.Color:=txt1.Color;
    MemList.Color:=$00BFB3C6;
  end
  else
  begin
    txt1.Color:=$00BFB3C6;
    txt2.Color:=txt1.Color;
    txtBtw.Color:=txt1.Color;
    MemList.Color:=$00E4FAE4;
  end;
end;

procedure TfmStr.txtMaxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    Key:=#0;
    PostMessage(TWinControl(Sender).Handle,WM_KEYDOWN,VK_TAB,0);
  end;
end;

procedure TfmStr.mBtnAboutClick(Sender: TObject);
begin
  ShowMessage('软件名称：重复语句批量生成器'+#13+#10+#13+#10+
              '作者：Anson Lam'+#13+#10+
              'E-Mail：G3DFB@21cn.com'+#13+#10+#13+#10+
              '版权所有(C) 2004-2005 Neighbor Community');
end;

procedure TfmStr.mBtnOtherSaveClick(Sender: TObject);
begin
  SD.Title:='另存生成语句到文件';
  if SD.Execute then
  begin
    try
      memDis.Lines.SaveToFile(SD.FileName);
    except
      ShowMessage('保存路径不正确，保存失败！');
    end;
  end;
end;

end.
