program ProStr;

uses
  Forms,
  UniStr in 'UniStr.pas' {fmStr};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ÖØ¸´Óï¾äÉú³ÉÆ÷';
  Application.CreateForm(TfmStr, fmStr);
  Application.Run;
end.
