unit Unitgenalgess;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

(******************************************************************)
(* Paul Koop M.A. Raeuber Beute System                            *)
(* Die Simulation wurde ursprunglich entwickelt,                  *)
(* um die Verwendbarkeit von Zellularautomaten                     *)
(* fuer die Algorithmisch Rekursive Sequanzanalyse                *)
(* zu ueberpruefen								*)
(* Modellcharakter hat allein der Quelltext. Eine Compilierung    *)
(* dient nur als Falsifikationsversuch                            *)
(******************************************************************)

CONST
     Fn = 1; (* gen nahrung      *)
     Fg = 2; (* gen gefahr       *)
     Rn = 3; (* gen fressen      *)
     Rg = 4; (* gen verteidigung *)

     Fk = 5; (* gen andere weider erkennen          *)
     Rk = 6; (* gen mit anderen weidern kooperieren *)
     maxfit = 80;
     stoffwechsel = -1;
(*----------------------- Type-Definitionen------------*)

TYPE
    Tzahl    = ^inhalt;
    inhalt  = RECORD
               i:integer;
               v,
               n:Tzahl;
              END;

   Tfeld    = array[1..6] of CHAR;

   TPgen     = ^gen;

   gen      = RECORD
               vor,nach:TPgen;
               g:Tfeld;
              END;

   TPzelle = ^zelle;
   Ttorus  = array[1..80,1..24] of TPzelle;
   zelle   = OBJECT
              constructor init;
              destructor done;virtual;
              function nnahrung(VAR x,y:Tzahl;VAR t:Ttorus):boolean;virtual;
              function nrauber(VAR x,y:Tzahl;VAR t:Ttorus):boolean;virtual;
              function nweider(VAR x,y:Tzahl;VAR t:Ttorus):boolean;virtual;

             END;

   TPweider= ^weider; (* Froesche nur duie Froesche werden optimiert *)
   weider  = OBJECT(zelle)
              vor,nach                      :TPweider;
              gen                           :TPgen;
              fit                           :integer;
              Fg,
              Fn,
              Rg,
              Rn,
              Fk,
              Rk,
              verteidigen,
              gefahr,
              futter,
              weidererkennen,
              kooperieren                       :boolean;
              constructor init;
              destructor  done;              virtual;
              Procedure   leer;              virtual;
              procedure   Bgefahr
                          (VAR x,y:Tzahl;VAR t:Ttorus);
                                             virtual;
              procedure   Bfutter
                          (VAR x,y:Tzahl;VAR t:Ttorus);
                                             virtual;
              procedure   Rfressen
                          (VAR x,y:Tzahl;VAR t:Ttorus);
                                             virtual;
              procedure   Rverteidigung;     virtual;
              procedure   Rkooperieren;      virtual;
              procedure   Rfit
                          (zahl:integer);    virtual;
              function    getfit            :integer;
                                             virtual;
              function    getgefahr         :boolean;
                                             virtual;
              function    getverteidigen    :boolean;
                                             virtual;
              function    getfressen        :boolean;
                                             virtual;
              procedure Rweidererkennen
                        (VAR x,y:Tzahl;VAR t:Ttorus);
                                             virtual;
              function    getkooperatoren
                          (VAR x,y:Tzahl;
                          VAR t:Ttorus)     :integer;
                                             virtual;

              function     nloeschen
                           (VAR x,y:Tzahl;
                            VAR t:Ttorus)   :boolean;
                                             virtual;
             END;

   TPrauber= ^rauber; (* Voegel Feinde der Froesche *)
   rauber  = OBJECT(zelle)
              constructor init;
              destructor done;virtual;
              function rloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;virtual;
             END;

   TPnahrung=^nahrung;(* INSEKTEN Nahrung der Froesche *)
   nahrung = OBJECT(zelle)
              constructor init;
              destructor done;virtual;
              function nloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;virtual;
             END;


(*----------------------- Var-Definitionen -----------*)
VAR
 n,x,y,xa,ya:Tzahl;
 Wzelle     :TPzelle;
 Wweider,
 Aweider,
 Nweider    :TPweider;
 Wnahrung   :TPnahrung;
 Wrauber    :TPrauber;
 Wgen,
 Agen,
 Ngen       :TPgen;

 bilda,
 bildb      :Ttorus;


  (* Forward Begin *)


(*CONSTRUCTOR zelle.init;
DESTRUCTOR zelle.done;*)
(* FUNCTION zelle.nnahrung(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
FUNCTION zelle.nrauber(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
FUNCTION zelle.nweider(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
CONSTRUCTOR weider.init;
PROCEDURE weider.leer;
DESTRUCTOR weider.done;
PROCEDURE weider.Bgefahr(VAR x,y:Tzahl;VAR t:Ttorus);
PROCEDURE weider.Bfutter(VAR x,y:Tzahl;VAR t:Ttorus);
function weider.nloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
procedure weider.Rweidererkennen(VAR x,y:Tzahl;VAR t:Ttorus);
function weider.getkooperatoren(VAR x,y:Tzahl;VAR t:Ttorus):integer;
procedure weider.Rkooperieren;
PROCEDURE weider.Rfressen (VAR x,y:Tzahl;VAR t:Ttorus);
PROCEDURE weider.Rverteidigung;
PROCEDURE weider.Rfit (zahl:integer);
FUNCTION weider.getfit:integer;
FUNCTION weider.getgefahr:boolean;
FUNCTION weider.getverteidigen:boolean;
FUNCTION weider.getfressen:boolean;
CONSTRUCTOR rauber.init;
DESTRUCTOR rauber.done;
function rauber.rloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
CONSTRUCTOR nahrung.init;
DESTRUCTOR nahrung.done;
function nahrung.nloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean; *)
FUNCTION test:CHAR;
PROCEDURE aufbaugene;
PROCEDURE abbaugene(z:TPgen);
PROCEDURE crossing_over;
PROCEDURE aufbauweider;
PROCEDURE abbauweider(z:TPweider);
PROCEDURE aufbaurauber;
PROCEDURE abbaurauber;
PROCEDURE aufbaunahrung;
PROCEDURE abbaunahrung;
PROCEDURE aufbauzelle;
PROCEDURE abbauzelle;
PROCEDURE aufbau;
PROCEDURE abbaux(x:Tzahl);
PROCEDURE abbauy(y:Tzahl);
FUNCTION neu (VAR r:Ttorus; VAR x,y:Tzahl):TPzelle;
PROCEDURE spiel(VAR von,nach :Ttorus);
PROCEDURE zufall(VAR a:Ttorus);
 (* Forward End *)

implementation


USES dos,crt;

CONSTRUCTOR zelle.init;
   BEGIN
   END;

  DESTRUCTOR zelle.done;
   BEGIN
   END;

  FUNCTION zelle.nnahrung(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
   VAR z:integer;
   BEGIN
    Z := 0;
    IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;

     If z > 0
     THEN nnahrung:=true ELSE nnahrung:=false;
   END;

   FUNCTION zelle.nrauber(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
   VAR Z:integer;
   BEGIN
    z := 0;
    IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(rauber)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z + 1;

     IF z > 0
     THEN nrauber :=true ELSE nrauber :=false;
   END;

  FUNCTION zelle.nweider(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
   VAR Z:integer;
   BEGIN
    z := 0;
    IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z + 1;

     IF z > 0
     THEN nweider :=true ELSE nweider :=false;
   END;

  CONSTRUCTOR weider.init;
   BEGIN
   END;
  PROCEDURE weider.leer;
   BEGIN
    Fg              := false;
    Fn              := false;
    Rg              := false;
    Rn              := false;
    Fk              := false;
    Rk              := false;
    verteidigen     := false;
    gefahr          := false;
    futter          := false;
    weidererkennen  := false;
    kooperieren     := false;
    fit             := maxfit;
   END;

  DESTRUCTOR weider.done;
   BEGIN
   END;

  PROCEDURE weider.Bgefahr(VAR x,y:Tzahl;VAR t:Ttorus);
   VAR z : integer;
   BEGIN
    Z := 0;
    IF Fg
    THEN
    BEGIN
    IF TypeOF(t(.x^.v^.v^.i,y^.v^.v^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.v^.v^.i,y^.v^.i   .)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.v^.v^.i,y^.i      .)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.v^.v^.i,y^.n^.i   .)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.v^.v^.i,y^.n^.n^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.v^.i   ,y^.v^.v^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.v^.i   ,y^.n^.n^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.i      ,y^.v^.v^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.i      ,y^.n^.n^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.i   ,y^.v^.v^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.i   ,y^.n^.n^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.n^.i,y^.v^.v^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.n^.i,y^.v^.i   .)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.n^.i,y^.i      .)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.n^.i,y^.n^.i   .)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF TypeOF(t(.x^.n^.n^.i,y^.n^.n^.i.)^)=TypeOf(rauber)
    THEN z := z + 1;
    IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z+1;

    END;

    IF Z > 0
    THEN gefahr := true ELSE gefahr := false;

   END;

   PROCEDURE weider.Bfutter(VAR x,y:Tzahl;VAR t:Ttorus);
    VAR z :integer;
    BEGIN

     z := 0;
     IF Fn
     THEN
     BEGIN
     IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(nahrung)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z + 1;
     END;

     IF Z > 0
     THEN futter  := true ELSE futter  := false;


    END;

function weider.nloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
   VAR z:integer;
   BEGIN
     z := 0;
     IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(weider)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z+1;
     IF z> 3 THEN nloeschen := true
             ELSE nloeschen := false;

   END;

procedure weider.Rweidererkennen(VAR x,y:Tzahl;VAR t:Ttorus);
   VAR Z:integer;
   BEGIN
    z := 0;
    IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(weider)
     THEN z := z + 1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN z := z + 1;

     IF ((z > 0) AND Fk)
     THEN weidererkennen :=true ELSE weidererkennen :=false;
   END;

function weider.getkooperatoren(VAR x,y:Tzahl;VAR t:Ttorus):integer;
   VAR z:integer;
   BEGIN
     z := 0;
     IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.v^.i,y^.v^.i.)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;

     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.v^.i,y^.i   .)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;


     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.v^.i,y^.n^.i.)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;


     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.i   ,y^.v^.i.)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;


     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.i   ,y^.n^.i.)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;


     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.n^.i,y^.v^.i.)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;


     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.n^.i,y^.i   .)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;


     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(weider)
     THEN
      BEGIN
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@t(.x^.n^.i,y^.n^.i.)^;
              IF Aweider^.kooperieren THEN z:=z+1;
      END;

     (*IF Z>0 THEN z:=1 ELSE z:=-1;*)
     getkooperatoren :=z;
   END;

    procedure weider.Rkooperieren;
     BEGIN
      IF(weidererkennen and Rk)
      THEN kooperieren:=true;
     END;

    PROCEDURE weider.Rfressen (VAR x,y:Tzahl;VAR t:Ttorus);
     BEGIN
      IF(futter and Rn)
      THEN
       BEGIN
        fit := fit + 1+weider.getkooperatoren(x,y,t);
        IF NOT(kooperieren) THEN fit := fit + 1;
       END;
     END;

    PROCEDURE weider.Rverteidigung;
     BEGIN
      IF (gefahr and Rg)
      THEN verteidigen := true
      ELSE verteidigen := false
     END;

    PROCEDURE weider.Rfit (zahl:integer);
     BEGIN
      fit := fit + zahl;
     END;

    FUNCTION weider.getfit:integer;
     BEGIN
      getfit := fit;
     END;

    FUNCTION weider.getgefahr:boolean;
     BEGIN
      getgefahr := gefahr;
     END;


    FUNCTION weider.getverteidigen:boolean;
     BEGIN
      getverteidigen := verteidigen;
     END;

    FUNCTION weider.getfressen:boolean;
     BEGIN
      getfressen := Rn;
     END;

  CONSTRUCTOR rauber.init;
   BEGIN
   END;

  DESTRUCTOR rauber.done;
   BEGIN
   END;

  function rauber.rloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
   VAR z:integer;
   BEGIN
     z := 0;
     IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(rauber)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(rauber)
     THEN z := z+1;
     IF z > 3 THEN rloeschen := true
              ELSE rloeschen := false;

   END;
  CONSTRUCTOR nahrung.init;
   BEGIN
   END;

  DESTRUCTOR nahrung.done;
   BEGIN
   END;

  function nahrung.nloeschen(VAR x,y:Tzahl;VAR t:Ttorus):boolean;
   VAR z:integer;
   BEGIN
     z := 0;
     IF  TypeOF(t(.x^.v^.i,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.i   .)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.v^.i,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.i   ,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.v^.i.)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.i   .)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF  TypeOF(t(.x^.n^.i,y^.n^.i.)^)=TypeOF(nahrung)
     THEN z := z+1;
     IF z> 3 THEN nloeschen := true
             ELSE nloeschen := false;

   END;




(*----------------------- Prozeduren -----------------*)
FUNCTION test:CHAR;
 VAR Z:integer;
 BEGIN
  z := random(2);
  IF z = 0
   THEN test := '0'
   ELSE test := '1'
 END;
PROCEDURE aufbaugene;
 VAR z,z1 :integer;
 BEGIN
  NEW(Wgen);
  NEW(Agen);
  Wgen := Agen;
  FOR z1 := 1 TO 6 DO Agen^.g(.z1.) := test;
  NEW(Ngen);
  Ngen^.vor := Agen;
  Agen^.nach := Ngen;
  Agen := Ngen;
  FOR z := 1 TO 15
   DO
    BEGIN
     FOR z1 := 1 TO 6 DO Agen^.g(.z1.) := test;
     NEW(Ngen);
     Ngen^.vor := Agen;
     Agen^.nach := Ngen;
     Agen := Ngen;
    END;
  Agen^.nach := Wgen;
  Wgen^.vor := Agen;
 END;
PROCEDURE abbaugene(z:TPgen);
 BEGIN
  IF z <> Wgen THEN abbaugene(z^.nach);
  dispose(z)
 END;

PROCEDURE crossing_over;
 VAR
  max1,max2,
  fit,
  co1,co2  :TPweider;
  g1,g2    :TPgen;
  ch       :CHAR;
  z1,z2,z3,z4:Integer;
 BEGIN
 sound(440);delay(100);nosound;
 NEW(max1,init);
 NEW(max2,init);
 NEW(fit,init);
 NEW(co1,init);
 NEW(co2,init);
 NEW(g1);
 NEW(g2);
 max1 := Wweider;
 max2 := Wweider^.nach;
 fit^.fit := 0;
 fit^.gen := max1^.gen;
 REPEAT
  IF fit^.getfit < max1^.getfit
   THEN BEGIN
         fit^.fit := max1^.getfit;
         fit^.gen   := max1^.gen;
        END;
  Max1 := max1^.nach;
  UNTIL max1 = Wweider;
  Wweider^.gen := fit^.gen;
  max1 := Wweider;
  fit^.fit  := 0;
  fit^.gen  := max2^.gen;
  REPEAT
  IF fit^.getfit < max2^.getfit
   THEN BEGIN
         fit^.fit := max2^.getfit;
         fit^.gen   := max2^.gen;
        END;
  max2 := max2^.nach;
  UNTIL max2 = Wweider;
  Wweider^.nach^.gen := fit^.gen;
  max2 := Wweider^.nach;
  co1 := max2^.nach;
  co2 := co1^.nach;
  g1^.g := max1^.gen^.g;
  g2^.g := max2^.gen^.g;
  max1^.fit := maxfit;
  max2^.fit := maxfit;
  REPEAT
  z1 := random(6)+1;
  z2 := random(6)+1;
  Co1^.gen^.g := g1^.g;
  co1^.fit := maxfit;
  Co2^.gen^.g := g2^.g;
  co2^.fit := maxfit;
  ch:=co1^.gen^.g(.z1.);
  co1^.gen^.g(.z1.):=co2^.gen^.g(.z2.);
  co2^.gen^.g(.z2.):= ch;
  z1 := random(3);
  IF z1 = 0
   THEN
    BEGIN
     sound(1000);delay(100);nosound;
     z1 := random(6)+1;
     z2 := random(6)+1;
     z3 :=random(2);
     z4 := random(2);
     IF z3 = 1
      THEN
        BEGIN
         IF co1^.gen^.g(.z1.)='1'
         THEN  co1^.gen^.g(.z1.):='0'
         ELSE co1^.gen^.g(.z1.):='1';
        END;

     IF z4 = 1
      THEN
        BEGIN
         IF co1^.gen^.g(.z2.)='1'
         THEN  co1^.gen^.g(.z2.):='0'
         ELSE co1^.gen^.g(.z2.):='1';
        END;
    END;
  co1 := co2^.nach;
  co2 := co2^.nach^.nach;
  UNTIL co1 = Wweider;
  Aweider := Wweider;
  REPEAT
    IF Aweider^.gen^.g(.Fn.) = '1' THEN Aweider^.Fn := true
                                   ELSE Aweider^.Fn := false;
    IF Aweider^.gen^.g(.Fg.) = '1' THEN Aweider^.Fg  := true
                                   ELSE Aweider^.Fg  := false;
    IF Aweider^.gen^.g(.Rn.) = '1' THEN Aweider^.Rn := true
                                   ELSE Aweider^.Rn := false;
    IF Aweider^.gen^.g(.Rg.) = '1' THEN Aweider^.Rg := true
                                   ELSE Aweider^.Rg := false;
    IF Aweider^.gen^.g(.Fk.) = '1' THEN Aweider^.Fk := true
                                   ELSE Aweider^.Fk := false;
    IF Aweider^.gen^.g(.Rk.) = '1' THEN Aweider^.Rk := true
                                   ELSE Aweider^.Rk := false;
    Aweider := Aweider^.nach;
  UNTIL Aweider = Wweider;
 END;

PROCEDURE aufbauweider;
 VAR z :integer;
 BEGIN
 NEW(Wweider,init);
 NEW(Aweider,init);
 NEW(Nweider,init);
 NWEIDER^.leer;
 Nweider := Wweider;
 Aweider := Nweider;
 Agen := Wgen;
 Aweider^.fit := maxfit;
 Aweider^.gen := Agen;
 IF Aweider^.gen^.g(.Fn.) = '1' THEN Aweider^.Fn := true
                                ELSE Aweider^.Fn := false;
 IF Aweider^.gen^.g(.Fg.) = '1' THEN Aweider^.Fg  := true
                                ELSE Aweider^.Fg  := false;
 IF Aweider^.gen^.g(.Rn.) = '1' THEN Aweider^.Rn := true
                                ELSE Aweider^.Rn := false;
 IF Aweider^.gen^.g(.Rg.) = '1' THEN Aweider^.Rg := true
                                ELSE Aweider^.Rg := false;
 IF Aweider^.gen^.g(.Fk.) = '1' THEN Aweider^.Fk := true
                                ELSE Aweider^.Fk := false;
 IF Aweider^.gen^.g(.Rk.) = '1' THEN Aweider^.Rk := true
                                ELSE Aweider^.Rk := false;
 FOR z := 1 TO 15
  DO
   BEGIN
    NEW(Nweider,init);
    Nweider^.leer;
    Aweider^.nach := Nweider;
    Nweider^.vor  := Aweider;
    Aweider := Nweider;
    Agen := Agen^.nach;
    Aweider^.gen  := Agen;
    IF Aweider^.gen^.g(.Fn.) = '1' THEN Aweider^.Fn := true
                                   ELSE Aweider^.Fn := false;
    IF Aweider^.gen^.g(.Fg.) = '1' THEN Aweider^.Fg  := true
                                   ELSE Aweider^.Fg  := false;
    IF Aweider^.gen^.g(.Rn.) = '1' THEN Aweider^.Rn := true
                                   ELSE Aweider^.Rn := false;
    IF Aweider^.gen^.g(.Rg.) = '1' THEN Aweider^.Rg := true
                                   ELSE Aweider^.Rg := false;
    IF Aweider^.gen^.g(.Fk.) = '1' THEN Aweider^.Fk := true
                                   ELSE Aweider^.Fk := false;
    IF Aweider^.gen^.g(.Rk.) = '1' THEN Aweider^.Rk := true
                                   ELSE Aweider^.Rk := false;

   END;
    Aweider^.nach := Wweider;
    Wweider^.vor  := Aweider;
 END;
PROCEDURE abbauweider(z:TPweider);
 BEGIN
  IF z <> Wweider THEN abbauweider(z^.nach);
  DISPOSE(z,done);
 END;
PROCEDURE aufbaurauber;
 BEGIN
  NEW(Wrauber,init)
 END;
PROCEDURE abbaurauber;
 BEGIN
  DISPOSE(Wrauber,done);
 END;
PROCEDURE aufbaunahrung;
 BEGIN
  new(Wnahrung,init);
 END;
PROCEDURE abbaunahrung;
 BEGIN
  DISPOSE(Wnahrung,done);
 END;
PROCEDURE aufbauzelle;
 BEGIN
  NEW(Wzelle,init)
 END;
PROCEDURE abbauzelle;
 BEGIN
  DISPOSE(Wzelle,done)
 END;
PROCEDURE aufbau;
 VAR z:integer;
 BEGIN
  z := 1;
  new(n);
  xa := n;
  x := n;
  x^.i := z;
  REPEAT
   z := z +1;
   new(n);
   x^.n := n;
   n^.v := x;
   x := n;
   x^.i := z;
  UNTIL z = 80;
  x^.n := xa;
  xa^.v := x;

  z := 1;
  new(n);
  ya := n;
  y := n;
  y^.i := z;
  REPEAT
   z := z +1;
   new(n);
   y^.n := n;
   n^.v := y;
   y := n;
   y^.i := z;
  UNTIL z = 24;
  y^.n := ya;
  ya^.v := y;
 END;

PROCEDURE abbaux(x:Tzahl);
 BEGIN
  IF x^.n <> xa THEN abbaux(x^.n);
  dispose(x);
 END;

PROCEDURE abbauy(y:Tzahl);
 BEGIN
  IF y^.n <> ya THEN abbauy(y^.n);
  dispose(y);
 END;

FUNCTION neu (VAR r:Ttorus; VAR x,y:Tzahl):TPzelle;
 VAR z:TPzelle;
 BEGIN
     z := r(.x^.i,y^.i.);
     IF TypeOF(z^) = TypeOf(rauber)
      THEN
       BEGIN
        IF Wrauber^.rloeschen(x,y,r) THEN neu := Wzelle
                                     ELSE neu := z;
       END
      ELSE
       BEGIN
        IF TypeOF(z^) = TypeOf(nahrung)
         THEN
          BEGIN
           IF Wnahrung^.nloeschen(x,y,r) THEN neu := Wzelle
                                         ELSE neu := z;
          END
         ELSE
          BEGIN
           IF TypeOF(z^) = TypeOf(weider)
            THEN
             BEGIN
               (*neu := z;*)
              Aweider := Wweider;
              REPEAT
              Aweider := Aweider^.nach
              UNTIL @Aweider^ =@z^;
              (*Aweider^.init; schon beim Aufbau Konsturktor aufgerufen*)
              IF Aweider^.nloeschen(x,y,r)
              THEN neu := Wzelle
              ELSE
              IF Aweider^.getfit = 0
               THEN
                 neu:= Wzelle
               ELSE
                BEGIN
                 Aweider^.Rfit(stoffwechsel);
                 Aweider^.Bgefahr(x,y,r);
                 Aweider^.Rverteidigung;
                 Aweider^.Rweidererkennen(x,y,r);
                 Aweider^.Rkooperieren;
                 IF ((Aweider^.getgefahr)AND NOT(Aweider^.getverteidigen))
                  THEN
                   BEGIN
                   Aweider^.Rfit(-1*(Aweider^.getfit));
                   neu := Wzelle;
                   END
                  ELSE
                  BEGIN
                   Aweider^.Bfutter(x,y,r);
                   Aweider^.Rfressen(x,y,r);
                   neu := @Aweider^;
                  END
                END;
             END
            ELSE
             BEGIN
              IF TypeOF(z^) = TypeOf(zelle)
               THEN
                BEGIN
                 IF z^.nnahrung(x,y,r)
                  THEN neu:= Wnahrung
                  ELSE
                   BEGIN
                    IF z^.nrauber(x,y,r)
                     THEN neu:= Wrauber
                     ELSE
                      BEGIN
                       IF z^.nweider(x,y,r)
                       THEN neu:= Aweider
                       ELSE neu := z
                      END;
                   END
                END
             END
          END
       END
 END;


PROCEDURE spiel(VAR von,nach :Ttorus);
 BEGIN
  x:=xa;
  y:=ya;
  REPEAT
   REPEAT
    nach(.x^.i,y^.i.):= neu(von,x,y);
    x := x^.n
   UNTIL x =xa;
   y := y^.n
  UNTIL y =ya;
 END;

PROCEDURE zufall(VAR a:Ttorus);
 VAR z :integer;
 BEGIN

  Aweider := Wweider;
  y :=ya;
  x :=xa;
  REPEAT
   REPEAT
    (*Zufallsbelegung*)
    z := random(100);
    CASE z OF
     0: a(.x^.i,y^.i.) := Wnahrung;
     1: a(.x^.i,y^.i.) := Wrauber;
     2: a(.x^.i,y^.i.) := Wzelle;
     3: BEGIN
         a(.x^.i,y^.i.):= Aweider;
         Aweider := Aweider^.nach;
        END
     ELSE  a(.x^.i,y^.i.) := Wzelle;
    END;
    x := x^.n
   UNTIL x =xa;
   y := y^.n
  UNTIL y =ya;
  Aweider:= Wweider;
 END;




end.

