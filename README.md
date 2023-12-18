# Gyakorlati optimalizálás módszerei
## Bombatalálatok maximalizálása
### Feladat célja
M darab bombával minél többet szeretnék eltalálni az N darab célpont közül.
### Feladat leírása
Először ki kellett találni a feladat megoldásához milyen változók szükségesek. Kellettek bombák, célpontok és az ezekhez tartozó paraméterek. Ezen felül kellettek változók, amiket optimalizálni tud a megoldó. A célpontokhoz tartozik egy xtarget és egy ytarget érték, 
amik koordinátákat fejeznek ki. A bombáknak van egy mérete (bombsize), ami azt jelzi mekkora területet robbantanak fel. A bombák úgy robbanak, hogy a becsapódásuktól (xbomb, ybomb) x és y irányban is a bombák méretének megfelelő terület robban fel és a robbanás alakja négyzet.
Ha a robbanás négyzete érinti a célpontot akkor a célpont el van találva.
Ezeknek a paramétereknek az értéke adott és egy python kód segítségével (Datafile_generator.py) is le lehet őket generálni, a felhasználónak csak a bombák számát, a célpontok számát és az intervallumot amin belül legyenek a célpontok x és y paraméterei és a bombák méretei.
Ezzel a kóddal meg is van a probláma megoldásához szükséges .dat file, de ezt a file-t manuálisan is meg lehet írni, csak nagy számú célpontnál és bombánál már időigényes eléggé. A modellhez tartoziknak még azok a változók is, amiknek majd a megoldó ad értéket.
Emellett kellett egy M az if then feltételek leírásához használt segédváltozó, ami bármilyen elég nagy szám lehetne. A változók közül az xbomb és az ybomb jelöli hova lenne érdemes dobni a bombát. A target_hit megadja, hogy az adott célpont el lett-e találva. A bomb_hit_target pedig
azt írja le, hogy az adott bomba eltalálta-e az adott célpontot.
#### Az összes változó:
```
set Targets;
set Bombs;
param bombsize{Bombs};
param xtarget{Targets};
param ytarget{Targets};
param M := 1000;
var xbomb{Bombs} integer;
var ybomb{Bombs} integer;
var target_hit{Targets} binary;
var bomb_hit_target{Bombs, Targets} binary;
```
#### Korlátozások
A változókon kívül különféle korlátozásokat is meg kellett adni. Le kellett írni egy bomba mikor talál el egy célpontot aztán, hogy egy célpont akkor van eltalálva, ha legalább egy bomba eltalálta.
Ezek kódban a következők:
```
s.t. Bomb_hit1{t in Targets, b in Bombs}: 
  xbomb[b] <= xtarget[t] + M * (1 - bomb_hit_target[b, t]);
s.t. Bomb_hit2{t in Targets, b in Bombs}: 
  ybomb[b] <= ytarget[t] + M * (1 - bomb_hit_target[b, t]);
s.t. Bomb_hit3{t in Targets, b in Bombs}: 
  xbomb[b] + bombsize[b] >= xtarget[t] - M * (1 - bomb_hit_target[b, t]);
s.t. Bomb_hit4{t in Targets, b in Bombs}: 
  ybomb[b] + bombsize[b] >= ytarget[t] - M * (1 - bomb_hit_target[b, t]);
s.t. Target_hit{t in Targets}:
	sum{b in Bombs}bomb_hit_target[b, t] >= 1 - M * (1 - target_hit[t]);
```
#### Objective function
Végül szükség volt egy objective functionre, ami azt definiálja mit szeretnénk maximalizálni vagy minimalizálni. Ennek a feladatnak az esetében az eltalált célpontok számát kellett maximalizálni:
```
maximize Target_hits: 
	sum{t in Targets}target_hit[t];
solve;
```
### Feladat megoldása
A fent leírtakat tartalmazza a bombs.mod file. A paraméterek értékei a .dat file-okban vannak. A problámat command prompt-ba a következő parancs használatával lehet megoldatni: glpsol -m bombs.mod -d bombs.dat -y useful_values.json. 
A parancs -y része a végső megoldást, a bombák helyeit, méreteit és a célpontok helyeit is kimenti egy külön file-ba. 
A .JSON file-ba író rész a következő:
```
printf'{\n\t\"Bombs\": [';
for {b in Bombs}
{
	printf'\"%s\",', b;
}
printf '],\n';
printf '\t\"bombsize\": {\n';
for {b in Bombs}
{
	printf '\t\t\"%s\": %d,\n', b, bombsize[b];
}
printf'\t},\n';
printf '\t\"xbomb\": {\n';
for {b in Bombs}
{
	printf '\t\t\"%s\": %d,\n', b, xbomb[b];
}
printf'\t},\n';
printf '\t\"ybomb\": {\n';
for {b in Bombs}
{
	printf '\t\t\"%s\": %d,\n', b, ybomb[b];
}
printf'\t},\n\t\"Targets\": [';
for {t in Targets}
{
	printf'\"%s\",', t;
}
printf '],\n';
printf '\t\"xtarget\": {\n';
for {t in Targets}
{
	printf '\t\t\"%s\": %d,\n', t, xtarget[t];
}
printf'\t},\n';
printf '\t\"ytarget\": {\n';
for {t in Targets}
{
	printf '\t\t\"%s\": %d,\n', t, ytarget[t];
}
printf'\t},\n';
printf"}\n";

end;
```
Ezzel az egyetlen probléma, hogy a for ciklusok végén mindenhova kerül egy plusz vessző amit a .JSON file feldolgozásakor manuálisan ki kell törölni, hogy valid legyen a file.
A mentett .JSON file Python-ba beolvasásával és a benne szereplő adatok megjelenítésével tudom  ellenőrizni a megoldás helyességét. A megjelenítéshez tartozó Python kódot a visualization.py file tartalmazza.
Egy ilyen megjelenítésre és ellenőrzésre példa a következő:

![Példa1](https://github.com/Uni-Sopron/gyakopt-23t-bombs/blob/main/Figure_1.png)
### Tesztelés
Több .dat file-ra is megnéztem a megoldást. Ezek között volt olyan .dat file ami olyan paramétereket tartalmazott, amikkel csak egy optimális megoldás létezett és ezzel is teszteltem a modellt. Az erre használt file a bombs2.dat.
A kapott eredmény pedig a következő:

![Példa2](https://github.com/Uni-Sopron/gyakopt-23t-bombs/blob/main/Figure_2.png)
### Konklúzió
A vizualizált ábrákból látszik, hogy a probláma megoldása során a megfelelő megoldások születnek, tehát a felállított modell az helyes.






