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



# printf("{\n");
# for {b in Bombs}
# {
# 	printf('"%s": ["%s", "%s"]', (b, xbomb[b], ybomb[b]));
# 	#printf("\n");
# }
# printf("}\n");

end;

