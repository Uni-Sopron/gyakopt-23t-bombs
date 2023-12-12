set Targets;
set Bombs;
param bombsize{Bombs};
param xtarget{Targets};
param ytarget{Targets};
param xmin := 0;
param ymin := 0;
param xmax := 10;
param ymax := 10;
param M := 1000;

var bposx{Bombs} integer;
var bposy{Bombs} integer;
var hit{Targets} binary;
var explosion{Bombs, Targets} binary;

#s.t. In_the_area1{b in Bombs}: bposx[b] >= xmin;
#s.t. In_the_area2{b in Bombs}: bposy[b] >= ymin;
#s.t. In_the_area3{b in Bombs}: bposx[b] + bombsize[b] <= xmax;
#s.t. In_the_area4{b in Bombs}: bposy[b] + bombsize[b] <= ymax;


#if bposx[b] <= xtarget[t] <= bposx[b] + bombsize[b] and bposy[b] <= ytarget[t] <= bposy[b] + bombsize[b] then hit[t] = 1 else hit[t]=0;
s.t.Hit_bomb1{t in Targets, b in Bombs}: bposx[b] <= xtarget[t] + M * (1 - explosion[b, t]);
s.t.Hit_bomb2{t in Targets, b in Bombs}: bposy[b] <= ytarget[t] + M * (1 - explosion[b, t]);
s.t.Hit_bomb3{t in Targets, b in Bombs}: bposx[b] + bombsize[b] >= xtarget[t] - M * (1 - explosion[b, t]);
s.t.Hit_bomb4{t in Targets, b in Bombs}: bposy[b] + bombsize[b] >= ytarget[t] - M * (1 - explosion[b, t]);

s.t.Hit_target1{t in Targets}:sum{b in Bombs}explosion[b, t] >= 1 - M * (1 - hit[t]);

# Maximalizálni az eltalált pontokat
maximize Hits: sum{t in Targets}hit[t];
solve;


data;

#ezekkel lesz eredmény
# set Bombs := B1;
# param bombsize := B1 3;
# set Targets := T1 T2  T3;
# param xtarget := T1 1 T2 2 T3 4;
# param ytarget := T1 2 T2 3 T3 4;

set Bombs := B1 B2;
param bombsize := B1 1 B2 2;
set Targets := T1 T2 T3 T4 T5;
param xtarget := T1 1 T2 2 T3 4 T4 1 T5 7;
param ytarget := T1 2 T2 3 T3 4 T4 1 T5 7;

end;


