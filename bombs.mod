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

maximize Target_hits: 
	sum{t in Targets}target_hit[t];

solve;



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

