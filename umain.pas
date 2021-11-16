unit UMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, StdCtrls, Unitgenalgess;

type
  (* Datentyp fuer die virtuelle Welt*)


  { TfrmMain }

  TfrmMain = class(TForm)
    btnNext: TButton;
    btnStart: TButton;
    btnStopp: TButton;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Spielfeld: TDrawGrid;
    pnlBottom: TPanel;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StatusMonitor: TStringGrid;
    tmrAnimation: TTimer;
    procedure Auswerten(Sender: TObject);
    procedure btnStoppClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnZufallClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpielfeldDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    { private declarations }

    (* virtuelle Spielwelt *)


  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
aufbau;
aufbaugene;
aufbauweider;
aufbaunahrung;
aufbaurauber;
aufbauzelle;
randomize;
zufall(bilda);
end;







procedure TfrmMain.SpielfeldDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin

  if TypeOf(bilda[aCol+1, aRow+1]^) = TypeOf(rauber) then
    Spielfeld.Canvas.Brush.Color := clRed
  else
   if TypeOf(bilda[aCol+1, aRow+1]^) = TypeOF(weider) then
    Spielfeld.Canvas.Brush.Color := clGreen
  else
    if TypeOf(bilda[aCol+1, aRow+1]^) = TYPEOF(nahrung) then
    Spielfeld.Canvas.Brush.Color := clYellow
  else
    Spielfeld.Canvas.Brush.Color := clWhite;

 Spielfeld.Canvas.FillRect(aRect);
end;








procedure TfrmMain.Auswerten(Sender: TObject);
 var z,aRow:integer;
begin

  zufall(bilda);
  Z := 0;
  REPEAT
     spiel(bilda,bildb);
     Spielfeld.Refresh;
     bilda:= bildb;
     z := z + 1;
   aRow:= 1;
   Aweider := Wweider;

   with StatusMonitor do
   repeat
    Cells[0, aRow] := Aweider^.gen^.g;
    Cells[2, aRow] := IntToStr(Aweider^.fit);
    aRow:=aRow+1;
    Aweider := Aweider^.nach;
   until aRow = rowCount;
   StatusMonitor.Refresh;
  Until (z = 10);
  crossing_over;

end;

procedure TfrmMain.btnStoppClick(Sender: TObject);
begin
  tmrAnimation.Enabled := false;
  bilda:=bildb;
  Spielfeld.Refresh;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  tmrAnimation.Enabled := true;
end;

procedure TfrmMain.btnZufallClick(Sender: TObject);
begin
  abbaux(x);
  Agen := Wgen;
  abbaugene(Agen);
  Aweider := Wweider;
  abbauweider(Aweider);
  abbaunahrung;
  abbaurauber;
  abbauzelle;
  y:=ya;
  abbauy(y);

  aufbau;
  aufbaugene;
  aufbauweider;
  aufbaunahrung;
  aufbaurauber;
  aufbauzelle;

  zufall(bilda);
  Spielfeld.Repaint;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  tmrAnimation.Enabled := false;
  x := xa;
  abbaux(x);
  Agen := Wgen;
  abbaugene(Agen);
  Aweider := Wweider;
  abbauweider(Aweider);
  abbaunahrung;
  abbaurauber;
  abbauzelle;
  y:=ya;
  abbauy(y);
end;

end.

