import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress

#Definer konstanter og data fra billederne
I = 0.00016  # Inertimoment [kgm^2]

#Vinkelhastigheder (x-værdier)
vinkelhastighed = np.array([
    8.330, 9.153, 18.096, 14.834, 14.546, 25.086, 23.871
])

#Dæmpningsfaktorer B
B_faktor = np.array([
    0.43, 0.42, 0.28, 0.32, 0.31, 0.22, 0.23
])

#Dæmpning b ud fra b = B2I
b_daempning = B_faktor * 2 * I

#Lineær regression (y = b_daempning, x = vinkelhastighed)
slope, intercept, r_value, p_value, std_err = linregress(vinkelhastighed, b_daempning)

#Plot datapunkterne
plt.scatter(vinkelhastighed, b_daempning, , color="blue", label="Data points", zorder=5)

#Generer værdier til regressionslinjen
x_line = np.linspace(min(vinkelhastighed) - 2, max(vinkelhastighed) + 2, 100)
y_line = slope * x_line + intercept

#Plot regressionslinjen
plt.plot(x_line, y_line, color="red", linestyle="--", 
         label=f"linear regression (R² = {r_value**2:.4f})")

#Detaljer til grafen
plt.title("Damping constant $b$ as a function of maximum angular velocity $\\theta\'_{max}$")
plt.xlabel("Angular velocity $\\theta\'_{max}$ [rad/s]")
plt.ylabel("Damping constant $b$ $(kg\\cdot m^2/s)$")
plt.grid(True, linestyle=":", alpha=0.6)
plt.legend()
plt.show()