program ProStr;

uses
  Forms,
  UniStr in 'UniStr.pas' {fmStr};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�ظ����������';
  Application.CreateForm(TfmStr, fmStr);
  Application.Run;
end.
