# Objective

This project consist in the use of the ant colony algorithm to try to solve the problem of vertex cover.

# Algoritmo

* Inicializar feromonio (tudo 0 não é bom)
	- Criar um vetor de feromonio em que cada posição corresponde ao feromonio no vetor de nos
	- Trocar keys por um vetor de vetores com duas posições a primeira sendo o no e a segunda o feromonio nele
* Atribuir uma origem para as formigas
	- Cada formiga começa no mesmo no
	- Cada formiga começa em um no diferente
* Ir adicionando nos ao caminho da formiga até chegar ao objetivo (o caminho conseguir alcançar os 81306 nos do grafo)

