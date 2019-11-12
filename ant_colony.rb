#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"
require "./selection_method"

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
		@stop = False
	end

	def new_node(node_hash,graph)
		if not @stop
			for k in node_hash.keys
				r = rand()
				if ((r <= node_hash[k]) && (@path.include? k))
					@path.push(k)
				end
			end
			if graph.neighbours(@path) == graph.n_nodes
				@stop = True
			end
		end
		return @stop
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
			@nodes[nodes[i]] = 1.0
		end
	end

	def run()
		for i in 1..@iter
			# Ant initialization
			ants = Array.new

			for i in 0..(@n_ants - 1)
				aux = @nodes.keys.sample
				puts aux
				ants.push(Ant.new(aux))
			end

			# Selection method
			paths = []
			while ants.size > 0
				for a in ants
					if a.new_node(@nodes,@graph)
						paths.push(a.path)
						ants.delete(a)
					end
				end
			end

			# Pheromone evaportaion
			# ;-; it's so slow
			for i in 0..(@nodes.size - 1)
				idx = @nodes.keys[i]
				@nodes[idx] *= (1 - rand())
			end

			# Solution quality/Pheromone atualization
			for i in 0..(@n_ants - 1)
#				lk = ants[i].path_lenght()
				lk = paths[i].size
				for idx in paths[i]
					@nodes[idx] += 1/lk
				end
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
