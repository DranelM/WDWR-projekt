# Maciej Lenard #
# WDWR 19304    #
# zadanie 2     #

#==============#
#    Zbiory    #
#==============#
set FABRYKI;
set MAGAZYNY;
set KLIENCI;
set Z_FM;
set DO_MK;
set DYSTRYBUCJA within {Z_FM , DO_MK};
set PUSTE_POLA within {Z_FM , DO_MK};
set SCENARIUSZE = {1..1000};
set R; 

#==============#
#  Parametry   #
#==============#
param puste_pola {PUSTE_POLA};
param koszty_dystrybucji_oczekiwane {DYSTRYBUCJA};
param koszty_dystrybucji_scenariusze {DYSTRYBUCJA, SCENARIUSZE};
param max_produkcja_fabryk {FABRYKI};
param max_magazynow {MAGAZYNY};
param zapotrzebowanie_klientow {KLIENCI};
param polowa_mozliwosci_fabryk {FABRYKI};
param kara_malej_produkcji;
param prawd_scenariusza;
param scenariuszeR {SCENARIUSZE, R};
param waga_kosztu; 
param odchylenie_przecietne {(z,d) in DYSTRYBUCJA} = sum {s in SCENARIUSZE} abs(koszty_dystrybucji_oczekiwane[z,d] - koszty_dystrybucji_scenariusze[z,d,s])*prawd_scenariusza;

#==============#
#    Zmienne   #
#==============#
var b {f in FABRYKI} binary;
var dystrybucja {Z_FM, DO_MK} integer >= 0;
var koszty_kary_malej_produkcji = sum {f in FABRYKI} b[f] * kara_malej_produkcji;
var koszt_oczekiwany = sum {(z, d) in DYSTRYBUCJA} (koszty_dystrybucji_oczekiwane[z,d] * dystrybucja[z,d]) + koszty_kary_malej_produkcji;
var ryzyko = sum {(z,d) in DYSTRYBUCJA} (odchylenie_przecietne[z,d] * dystrybucja[z,d] + koszty_kary_malej_produkcji);

#==============#
# Ograniczenia #
#==============#
s.t. produkcja_fabryk {f in FABRYKI}: sum {d in DO_MK} dystrybucja[f, d] <= max_produkcja_fabryk[f]; 
s.t. fabryka_magazyn_klient {m in MAGAZYNY}: sum {z in Z_FM} dystrybucja[z, m] = sum {d in DO_MK} dystrybucja[m,d];
s.t. limit_magazynow {m in MAGAZYNY} : sum {z in Z_FM} dystrybucja [z, m] <= max_magazynow[m];
s.t. podaz {k in KLIENCI}: zapotrzebowanie_klientow[k] <= sum {z in Z_FM} dystrybucja[z, k];
s.t. zachowanie_poprawnosci_dystrybucji {(z, d) in PUSTE_POLA}: dystrybucja[z,d] <= 0;  
s.t. wielkosc_produkcji_1 {f in FABRYKI}: polowa_mozliwosci_fabryk[f] <= sum {d in DO_MK} dystrybucja[f, d] + polowa_mozliwosci_fabryk[f]*b[f];
s.t. wielkosc_produkcji_2 {f in FABRYKI}: polowa_mozliwosci_fabryk[f] * (1- b[f]) - sum {d in DO_MK} dystrybucja[f, d] <= 0;




