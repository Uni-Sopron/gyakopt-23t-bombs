import json
import matplotlib.pyplot as plt
import matplotlib.patches as patches

try:
    f = open("useful_values.json")
    data = json.load(f)
    print("JSON file is valid.")

    bombs = data["Bombs"]
    bombsize = data["bombsize"]
    xbomb = data["xbomb"]
    ybomb = data["ybomb"]
    targets = data["Targets"]
    xtarget = data["xtarget"]
    ytarget = data["ytarget"]
    bombsize_values = list(data["bombsize"].values())
    xbomb_values = list(data["xbomb"].values())
    ybomb_values = list(data["ybomb"].values())
    xtarget_values = list(data["xtarget"].values())
    ytarget_values = list(data["ytarget"].values())


    print("Bombs:", bombs)
    print("Bombsize:", bombsize)
    print("Xbomb:", xbomb)
    print("Ybomb:", ybomb)
    print("Targets:", targets)
    print("Xtarget:", xtarget)
    print("Ytarget:", ytarget)

    fig, ax = plt.subplots()
    ax.scatter(xtarget_values, ytarget_values, color = 'black', marker='o', label = "Targets")
    ax.scatter(xbomb_values, ybomb_values, color = 'red', marker = 'x', label = "Bombs")

    explosion_label_added = 0
    for x, y, bombsize in zip(xbomb_values, ybomb_values, bombsize_values):
        if explosion_label_added == 0:
            square = patches.Rectangle((x, y), bombsize, bombsize, linewidth = 1, edgecolor = "orange", facecolor = "none", label = "Explosion")
            explosion_label_added = 1
        else:
            square = patches.Rectangle((x, y), bombsize, bombsize, linewidth = 1, edgecolor = "orange", facecolor = "none")
        ax.add_patch(square)

    ax.set_xlabel("X Coordinates")
    ax.set_ylabel("Y Coordinates")
    ax.set_title("Targets, Bombs and Explosions")
    ax.legend()
    plt.show()

except json.JSONDecodeError as e:
    print(f"Error decoding JSON: {e}")
    print("JSON file is not valid.")
except KeyError as e:
    print(f"Error accessing key: {e}")
    print("Make sure the required keys are present in the JSON file.")
