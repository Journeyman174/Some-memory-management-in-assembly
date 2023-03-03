# Some-memory-management-in-assembly

1. Reversed One Time Pad

Folosindu-ne de valorile registrilor de 32 de biti edx, esi, edi, ecx, pentru implementarea
algoritmului am utilizat instructiunea loop care decrementeaza automat ecx-lungimea 
textului, realizand o bucla in interiorul careia se face xor primul caracter din 
plaintext (memorat in registrul de 8 biti al) si ultimul caracter al cheii (memorat
in registrul de 8 biti bl). 
Rezultatul din registrul al este memorat corespunzator in ciphertext. 

2. Ages

Pentru a calcula varsta colegilor a caror data de nastere se gaseste intr-un 
vector de structura my_date, am folosit o bucla next_age in care am calculat
varsta prin scaderea din anul datei din prezent a anului nasterii. Am verificat
toate cazurile pozibile respectiv luna prezenta mai mica decat luna nasterii (ani
impliniti), respectiv daca e mai mare (ani neimpliniti) scad 1 din varsta calculata.
Daca data nasterii este dupa data prezenta, varsta este 0.
Varstele calculate le-am copiat in vectorul all_ages (vector de valori pe 32 de biti).
Pentru accesarea câmpului unui element din vectorul dates am folosit adresarea normală
(my_date.day, my_date.month, my_date.year).

3. Columnar Transposition Cipher

Pentru implementarea algoritmului de codare precizat, am folosit urmatoarele variabile
statice : matrice - vector de 200 octeti initializat cu valoarea 255, pentru a 
marca celulele goale;
	  nr_linii - numarul de linii al matricei plaintext;
	  linii - numarul de caractere prelucrate din matricea plaintext;
	  vect - index vector de ordonare cheie.

Dupa reinitializarea matricei plaintext, am incarcat-o cu caracterele din 
haystack. Numarul de coloane l_key, numarul de caractere din haystack len_haystack
le-am folosit pentru calcularea numarului de linii ale matricei, implementand
functia ceil(x) care intoarce cea mai mica valoare intreaga, mai mare sau egal cu x.
Pe ultima linie raman celule goale (dar initializate cu 255) care participa la 
algoritmul de codare.
In registrul edi se gaseste adresa vectorului ce contine ordinea coloanelor de 
prelucrare a cheii. Fiecare valoare din vectorul de ordine reprezinta index-ul
primului element din coloana. Daca esi este adresa de inceput a matricei haystack,
valoarea 2 din vector (esi + 2) este adresa elementului din linia 1 si coloana 3.
Copierea din matricea haystack in matricea ciphertext se face pe coloana al carei
numar de ordine este in vectorul key. Numarul de elemente copiate pe coloana este
dat de nr_linii si se trece pe coloana urmatoare. Citirea pe coloane a matricei
haystack se face adunand la adresa primului element al coloanei un index 
reprezentand lungimea cheii (numarul de coloane). 
Pentru utilizarea registrilor am folosit secventa push, pop de salvare in 
stiva a valorii registrului si refacerea lui dupa secventa de prelucrare,
datorita numarului limitat de registri.

4. Cache Load Simulation

Pentru implementarea algoritmului de simulare a memoriei cache, am folosit
variabilele locale pe 32 de biti offset, tag si address0 care este adresa
de inceput a grupului de 8 octeti consecutivi din memorie. Datorita 
numarului limitat de registri, am folosit secventa push, pop pentru 
salvarea in stiva a valorii registrului si refacerea lui.
Adresa pe 32 de biti citita din registrul edx a fost prelucrata 
extragandu-se tag-ul format din primii 29 de biti si memorat
in variabila tag. Offset-ul obtinut prin instructiunea and si valoarea 
0x00000007 l-am memorat in variabila offset. Adresa de inceput a grupului 
de 8 biti consecutivi (offset = 0) am memorat-o in address0.
Dupa calculul tag-ului am cautat in matricea tags (ebx), valoarea lui
si daca am gasit-o am executat secventa CACHE_HIT si se copiaza
in reg valoarea de la adresa initiala. Daca este gasit tag-ul in vector
execut secventa CACHE_MISS in care copiez de la address0 8 octeti
consecutivi (inclusiv octetul cerut) in cache dupa care pregatesc 
linia (to_replace) si coloana (offset) pentru a scrie in registrul 
valoarea data. De asemenea se completeaza vectorul tags pe pozitia
to_replace cu valoarea offset-ului.
