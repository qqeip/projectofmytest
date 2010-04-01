program Project1;

{$APPTYPE CONSOLE}

uses
  WebBroker,
  CGIApp,
  Unit1 in 'Unit1.pas' {WebModule1: TWebModule},
  DemoServicesImpl in 'DemoServicesImpl.pas',
  DemoServicesIntf in 'DemoServicesIntf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TWebModule1, WebModule1);
  Application.Run;
end.
