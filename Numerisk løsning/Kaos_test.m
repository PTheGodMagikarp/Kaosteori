% Definer filnavnet (vigtigt med ' ' omkring pga. mellemrum)
filename = '50 Hz - 1,5 t.csv';

% Læs filen ind som en tabel
data = readtable(filename);

% Vis de første par rækker i kommandovinduet
head(data)