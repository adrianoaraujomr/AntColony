from random import randint
lista=[]
for i in range (0,5):
 pair=[i]
 for j in range (0,5):
  if(i<j):
   pair.append(j)
   lista.append(pair)
  pair=[i]
for i in range(0,len(lista)):
 print(str(lista[i][0])+" "+str(lista[i][1]))
