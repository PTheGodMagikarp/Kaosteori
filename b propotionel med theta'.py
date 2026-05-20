import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress

# 1. Definer konstanter og data fra billederne
I = 0.00016  # Inertimoment [kg*m^2]

# Vinkelhastigheder (x-værdier)
vinkelhastighed = np.array([
    8.330, 9.153, 18.096, 14.834, 14.546, 25.086, 23.871
])

# Dæmpningsfaktorer B
B_faktor = np.array([
    0.43, 0.42, 0.28, 0.32, 0.31, 0.22, 0.23
])

# 2. Beregn dæmpning b ud fra formlen b = B * 2 * I
b_daempning = B_faktor * 2 * I

# Print de beregnede b-værdier ud, så du kan skrive dem ind i dit skema
print("Beregnede dæmpningsværdier (b):")
for v, b in zip(vinkelhastighed, b_daempning):
    print(f"Vinkelhastighed: {v:7.3f} rad/s  ->  b: {b:.7f} Nm*s/rad")

print("-" * 50)

# 3. Lav lineær regression (y = b_daempning, x = vinkelhastighed)
slope, intercept, r_value, p_value, std_err = linregress(vinkelhastighed, b_daempning)

print(f"Lineær regressionsegenskaber:")
print(f"Hældningskoefficient (a): {slope:.5e}")
print(f"Skæring med y-aksen (b): {intercept:.5e}")
print(f"R²-værdi (forklaringsgrad): {r_value**2:.4f}")

# 4. Plot resultaterne
plt.figure(figsize=(8, 6))

# Plot datapunkterne
plt.scatter(vinkelhastighed, b_daempning, color='blue', label='Datapunkter', zorder=5)

# Generer værdier til regressionslinjen
x_line = np.linspace(min(vinkelhastighed) - 2, max(vinkelhastighed) + 2, 100)
y_line = slope * x_line + intercept

# Plot regressionslinjen
plt.plot(x_line, y_line, color='red', linestyle='--', 
         label=f'Lineær regression (R² = {r_value**2:.4f})')

# Formatering af plottet
plt.title('Dæmpning $b$ som funktion af vinkelhastighed $\\theta\'_{max}$')
plt.xlabel('Vinkelhastighed $\\theta\'_{max}$ [rad/s]')
plt.ylabel('Dæmpning $b$ [$\\frac{Nm\\cdot s}{rad}$]')
plt.grid(True, linestyle=':', alpha=0.6)
plt.legend()

# Vis plottet
plt.show()