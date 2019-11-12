#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"

# (X) Ant initialization
# ( ) Selection Method
#	Node selection probabilite
# ( ) Solution quality
#	path_length (the smaller the better)
# (X) Pheromone evaporation
#	pheromone *= (1 - rand)
# (X) Pheromone atualization
#	pheromone += 1/path_length

class Ant
	def initialize(origin)
		@path = Array.new
		@path.push(origin)
	end

	def path()
		return @path
	end

	def path_lenght()
		return @path.size
	end
end

class AntColonyAlgorithm
	def initialize(graph,nodes,iterations,n_ants)
		@graph  = graph
		@iter   = iterations
		@n_ants = n_ants
		@nodes  = Hash.new

		# pheromone initialize
		for i in 0..(nodes.size - 1)
#			aux = Array.new
#			aux.push(nodes[i])
#			aux.push(1.0)
#			@nodes.push(aux)
			@nodes[nodes[i]] = 1.0
		end
	end

	def run()
		# Ant initialization
		ants = Array.new

		for i in 0..(@n_ants - 1)
			aux = @nodes.keys.sample
			puts aux
			ants.push(Ant.new(aux))
		end

		# Selection method
#		for i in 1..@iter
#		end

		# Pheromone evaportaion
		# ;-; it's so slow
		for i in 0..(@nodes.size - 1)
			idx = @nodes.keys[i]
			@nodes[idx] *= (1 - rand())
		end

		# Solution quality/Pheromone atualization
		for i in 0..(@n_ants - 1)
			lk = ants[i].path_lenght()
			for idx in ants[i].path
				@nodes[idx] += 1/lk
			end
		end


	end
end

END{
#	init_file()
	graph = SocialNetwork.new
	puts graph.n_nodes
	saco  = AntColonyAlgorithm.new(graph,graph.keys,50,10)
	saco.run()
}
