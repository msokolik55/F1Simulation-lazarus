program project1;
uses crt, dos;

type
  pretekar = record
    meno: string;
    id, cas: integer;
  end;

  pretekarCelkovo = record
    meno: string;
    id, cas, body: integer;
  end;

var
  pretekari: array [1..10] of pretekar;
  pretekariCelkovo: array [1..10] of pretekarCelkovo;
  i: integer;

  miesta: array [1..3] of string;

// CELKOVA SUTAZ
procedure inicPretekariCelkovo();
var i: integer;
begin 
  for i := 1 to length(pretekari) do
  begin                     
    pretekariCelkovo[i].id := i;
    pretekariCelkovo[i].meno := chr(ord('a') - 1 + i);
    pretekariCelkovo[i].cas := 0;
    pretekariCelkovo[i].body := 0;
  end;
end;

procedure zoradPretekarovCelkovo();
var i, j: integer;
    zavodnik: pretekarCelkovo;
begin
  i := 1;

  repeat
    j := i;

    zavodnik.meno := pretekariCelkovo[i].meno;
    zavodnik.body := pretekariCelkovo[i].body;

    while((zavodnik.body > pretekariCelkovo[j - 1].body) or (
            (zavodnik.body = pretekariCelkovo[j - 1].body) and
            (zavodnik.cas < pretekariCelkovo[j - 1].cas))) and
          (j > 1) do
    begin
      pretekariCelkovo[j].meno := pretekariCelkovo[j - 1].meno;
      pretekariCelkovo[j].body := pretekariCelkovo[j - 1].body;
      j := j - 1;
    end;

    pretekariCelkovo[j].meno := zavodnik.meno;
    pretekariCelkovo[j].body := zavodnik.body;

    i := i + 1;
  until i > length(pretekariCelkovo);
end;

procedure vyhodnotSutaz();
var i: integer;
begin 
  zoradPretekarovCelkovo();
  clrscr();

  writeln('Celkove vysledky F1');
  for i := 1 to 3 do
  begin
    write(i, '.miesto - ', pretekariCelkovo[i].meno);
    writeln(' (', pretekariCelkovo[i].body, ' bodov)');
  end;
end;

// PRETEKY
procedure inicPreteky(); 
var i: integer;
begin  
  for i := 1 to length(pretekari) do
  begin            
    pretekari[i].id := pretekariCelkovo[i].id;
    pretekari[i].meno := pretekariCelkovo[i].meno;
    pretekari[i].cas := 0;
  end;
end;

procedure pridajNahodnyCas();
var i: integer;
begin
  for i := 1 to length(pretekari) do
  begin
    if(random(10) = 0) then
      pretekari[i].cas := 100000
    else
      pretekari[i].cas := pretekari[i].cas + (random(6) + 5);
  end;
end;

procedure zoradPretekarov();
var i, j: integer;
    zavodnik: pretekar;
begin
  i := 1;

  repeat
    j := i;

    zavodnik.id := pretekari[i].id;
    zavodnik.meno := pretekari[i].meno;
    zavodnik.cas := pretekari[i].cas;

    while(zavodnik.cas < pretekari[j - 1].cas) and (j > 1) do
    begin
      pretekari[j].id := pretekari[j - 1].id;
      pretekari[j].meno := pretekari[j - 1].meno;
      pretekari[j].cas := pretekari[j - 1].cas;
      j := j - 1;
    end;
                                       
    pretekari[j].id := zavodnik.id;
    pretekari[j].meno := zavodnik.meno;
    pretekari[j].cas := zavodnik.cas;

    i := i + 1;
  until i > length(pretekari);
end;

procedure vypisPretekarov(kolo: integer);
var i: integer;
begin
  clrscr();
  writeln(kolo, '. preteky - ', miesta[kolo]);
  writeln();

  writeln('1. ', pretekari[1].meno, ' ', pretekari[1].cas);
  for i := 2 to length(pretekari) do
  begin
    if(pretekari[i].cas < 100000) then
      writeln(i, '. ', pretekari[i].meno, ' +', pretekari[i].cas - pretekari[1].cas)
    else
      writeln(i, '. ', pretekari[i].meno, ' DNS');
  end;
end;

procedure vyhodnotPreteky(); 
var i, j: integer;
begin
  for i := 1 to length(pretekari) do
    for j := 1 to length(pretekariCelkovo) do
      if(pretekari[i].id = pretekariCelkovo[j].id) then
      begin
        pretekariCelkovo[j].cas := pretekariCelkovo[j].cas + pretekari[i].cas;

        if(pretekari[i].cas < 100000) then
          pretekariCelkovo[j].body := pretekariCelkovo[j].body + 11 - i;
      end;
end;

procedure simulujPreteky(kolo: integer);
var w, s, s0: word;
    aktCas: integer;
begin  
  aktCas := 0;

  inicPreteky();
  vypisPretekarov(kolo); 

  gettime(w, w, s0, w);

  repeat
    gettime(w, w, s, w);

    if(s <> s0) then
    begin
      pridajNahodnyCas();
      zoradPretekarov();
      vypisPretekarov(kolo);

      aktCas := aktCas + 1;
      s0 := s;
    end;

  until aktCas >= 30;

  vyhodnotPreteky();
end;

begin
  randomize();

  miesta[1] := 'Francuzsko';
  miesta[2] := 'Madarsko';
  miesta[3] := 'Abu Dhabi';

  inicPretekariCelkovo();

  for i := 1 to length(miesta) do
  begin
    simulujPreteky(i);

    writeln();
    if(i < length(miesta)) then write('Dalsie preteky sa spustia po stlaceni klavesu.')
    else write('Celkove vysledky sa zobrazia po stlaceni klavesu.');

    readkey();
  end;

  vyhodnotSutaz();
  readkey();
end.

