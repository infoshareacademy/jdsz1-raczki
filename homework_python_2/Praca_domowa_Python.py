#Instrukcje - Zadanie 1

n = 5
l = [(1, 2, 100), (2, 5, 100), (3, 4, 100)]
suma = 0

for a, b, c in l:
        suma += (b - a + 1) * c

print(suma)
print(suma / n)

#Instrukcje - Zadanie 2

x = 'Szczebrzeszyn'

litery = []
for line in x:
    for c in line:
        litery.append(c)

print(litery)
print(set(map(lambda x: (x, list(litery).count(x)), litery)))

#Instrukcje - Zadanie 3

l = []
for i in range(2000, 3201):
    if i % 7 == 0 and i % 5 != 0:
        l.append(i)
print(l)

#Konstrukcje składane - Zadanie 2

napis = 'qwerty123!@$'
if 'x' or '^' or '@' in napis:
    print("True")
else:
    print("False")

#Konstrukcje składane - Zadanie 3

a = [[5, 3, 7], [1, 8, 1, 2], [5, 9]]
b = [item for sublist in a for item in sublist]
print(b)

#Funkcje - Zadanie 1

def maks(l):
    x = max(l)
    print(x)

maks([1,2,3,4,5,6,-7,-8,-9,0])

#Funkcje - Zadanie 2

def suma(d):
    dd = int(str(d) * 2)
    ddd = int(str(d) * 3)
    dddd = int(str(d) * 4)
    x = d + dd + ddd + dddd
    print(x)

suma(4)

