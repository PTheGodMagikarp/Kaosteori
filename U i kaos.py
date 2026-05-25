import numpy as np
import matplotlib.pyplot as plt

#400 punkter jævnt fordelt fra 0 til 10.
x = np.linspace(-10, 10, 400)

#Formlen
U = 47.73  * np.cos(x) + 3.9855* x**2 - 3.9855*np.pi*3/4*x

#Plot resultatet
plt.figure(figsize=(10, 6))
plt.plot(x, U, label=r'$U/I = -\alpha \theta^2 +\alpha \theta_0 \theta + \beta cos(\theta)$', color='blue')

#Detaljer til grafen
plt.title(r'Potential well $\theta_0$=135°')
plt.xlabel(r'$\theta$ (rad/s)')
plt.ylabel(r'U/I  ($J/kg \cdot m^2$)')
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()
plt.show()
