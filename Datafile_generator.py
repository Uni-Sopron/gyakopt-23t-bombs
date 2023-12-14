import random

num_bombs = 3
num_targets = 10

Bombs = sorted({f"B{i}" for i in range(1, num_bombs + 1)}, key=lambda x: int(x[1:]))
Targets = sorted({f"T{i}" for i in range(1, num_targets + 1)}, key=lambda x: int(x[1:]))


print(Bombs)
print(Targets)

bombsize = {bomb: random.randint(1, 10) for bomb in Bombs}
xtarget = {target: random.randint(1, 10) for target in Targets}
ytarget = {target: random.randint(1, 10) for target in Targets}

with open("generated_bombs.dat", "w") as file:
    file.write("set Bombs :=\n")
    file.write('\n'.join(Bombs))
    file.write("\n;\n\n")

    file.write("param bombsize :=\n")
    for bomb in Bombs:
        file.write(f"{bomb}\t{bombsize[bomb]}\n")
    file.write(";\n\n")

    file.write("set Targets :=\n")
    file.write('\n'.join(Targets))
    file.write("\n;\n\n")

    file.write("param xtarget :=\n")
    for target in Targets:
        file.write(f"{target}\t{xtarget[target]}\n")
    file.write(";\n\n")

    file.write("param ytarget :=\n")
    for target in Targets:
        file.write(f"{target}\t{ytarget[target]}\n")
    file.write(";\n")
    