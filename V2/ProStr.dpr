{*******************************************************}
{                                                       } 
{       ������ƣ��ظ��ַ�������                        } 
{       �����������������������й��ɵ��ַ�              }
{                                                       }
{       ��ĿĿ¼��D:\Program\Delphi\StrMaker\V2\        }
{       ����ʱ�䣺2007��07��18��                        }
{       ���ߣ�new                                       }
{                                                       } 
{       ��Ȩ���� (C) 2007 �ַ�����                      }
{                                                       }
{*******************************************************}
program ProStr;

uses
  Forms,
  UniStr in 'UniStr.pas' {fmStr};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�����ظ����������';
  Application.CreateForm(TfmStr, fmStr);
  Application.Run;
end.
