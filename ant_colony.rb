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
	def initialize(origin,graph)
		@path = Set.new
		@path.add(origin)
		@stop = graph.neighbours(@path)
	end

	def create_path(node_hash,graph,cum_sum)
#		puts @path.inspect
		while @stop < graph.n_nodes
			j = node_hash.keys.sample # probale new node
			r = rand()                # "randomness control"

			if r > node_hash[j]/cum_sum # probability of chosing the j node
				@path.add(j)
				@stop = graph.neighbours(@path)
#				puts @stop
#				puts @path.size
#				puts @path.map{|x| x.to_i}.sort.inspect
#				sleep 1
			end
		end
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
		#  maybe put some heuristic (number of neighbours)
		aux = 0
		for i in 0..(nodes.size - 1)
			r = rand().round(2)
			@nodes[nodes[i]] = rand().round(2)
			aux += r
		end
		@nodes_f_sum = aux # remember to atualize it

#		puts @nodes
	end

	def run()
		for i in 1..@iter
			# Ant initialization
			ants = Array.new

			for i in 0..(@n_ants - 1)
				aux = @nodes.keys.sample
				ants.push(Ant.new(aux,@graph))
			end

			# Selection method
			for a in ants
				a.create_path(@nodes,@graph,@nodes_f_sum)
				puts a.path.size
			end

			# Pheromone evaportaion
			# ;-; it's so slow
#			for i in 0..(@nodes.size - 1)
#				idx = @nodes.keys[i]
#				@nodes[idx] *= (1 - rand().round(2)/100)
#			end

			# Solution quality/Pheromone atualization
#			for a in ants
#				lk = ants.path_lenght()
#				for idx in a.path
#					@nodes[idx] += 1/lk
#				end
#			end
		end
	end
end

END{
#	init_file()
	graph = SocialNetwork.new
#	puts graph.keys.map{|x| x.to_i}.sort
	saco  = AntColonyAlgorithm.new(graph,graph.keys,2,5)
	saco.run()
}
