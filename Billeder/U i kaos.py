import numpy as np
import matplotlib.pyplot as plt

#400 punkter jævnt fordelt fra -10 til 10.
x = np.linspace(-10, 10, 400)

#Formlen
U = 47.73  * np.cos(x) + 3.9855* x**2 - 0*3.9855*np.pi*3/4*x

#Plot resultatet
plt.figure(figsize=(10, 6))
plt.plot(x, U, label=r"$U/I = -\alpha \theta^2 +\alpha \theta_0 \theta + \beta cos(\theta)$", color="blue")

#Detaljer til grafen   #$\theta_0$=135°
#plt.title(r"Potential well", color="black")
plt.xlabel(r"$\theta$ (rad/s)", color="black")
plt.ylabel(r"U/I  ($J/kg \cdot m^2$)", color="black")
plt.grid(True)
plt.tick_params(colors='black')
#plt.legend(labelcolor='blue')

# Hent den aktuelle akse (ax)
ax = plt.gca()

# Skift farve på alle fire sider af rammen (f.eks. til blå)
ax.spines["bottom"].set_color("black")
ax.spines["top"].set_visible(False)
ax.spines["left"].set_color("black")
ax.spines["right"].set_visible(False)

plt.savefig("/Users/chris\OneDrive\Documents\Svininger/potential_well.png", transparent=True)
plt.show()
