{*******************************************************}
{                                                       } 
{       软件名称：重复字符生成器                        } 
{       功能描述：用于批量生成有规律的字符              }
{                                                       }
{       项目目录：D:\Program\Delphi\StrMaker\V2\        }
{       创建时间：2007年07月18日                        }
{       作者：new                                       }
{                                                       } 
{       版权所有 (C) 2007 街坊公社                      }
{                                                       }
{*******************************************************}
program ProStr;

uses
  Forms,
  UniStr in 'UniStr.pas' {fmStr};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '楷方重复语句生成器';
  Application.CreateForm(TfmStr, fmStr);
  Application.Run;
end.
