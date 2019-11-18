#!/usr/bin/ruby -w

require "./social_graph"
require "./write_results"

# (X) Ant initialization
# (X) Selection Method
#	Node selection probabilite
# (X) Solution quality
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

	def create_path_decrescent(node_hash,graph,cum_sum)
		@path = node_hash.keys
		@stop = graph.neighbours(@path)
		while @stop == graph.n_nodes
			j = @path.sample       # probale new node
			r = rand()                  # "randomness control"
			if r < node_hash[j]/cum_sum # probability of chosing the j node
				rm = @path.delete(j)
				@stop = graph.neighbours(@path)
			end
		end
		@path.push(rm)
	end

	def create_path_crescent(node_hash,graph,cum_sum)
		while @stop < graph.n_nodes
			j = node_hash.keys.sample # probale new node
			r = rand()                # "randomness control"

			if r > node_hash[j]/cum_sum # probability of chosing the j node
				@path.add(j)
				@stop = graph.neighbours(@path)
			end
		end
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
		@best   = [0,graph.n_nodes]
		@graph  = graph
		@iter   = iterations
		@n_ants = n_ants
		@nodes  = Hash.new

		# Initialize pheromone
		#  maybe put some heuristic (number of neighbours)
		aux = 0
		for i in 0..(nodes.size - 1)
			r = rand().round(2)
			@nodes[nodes[i]] = rand().round(2)
			aux += r
		end
		@nodes_f_sum = aux
	end

	def run()
		for i in 1..@iter
			puts "Iteration " + i.to_s

			# Ant initialization
			ants = Array.new
			for i in 0..(@n_ants - 1)
				aux = @nodes.keys.sample
				ants.push(Ant.new(aux,@graph))
			end

			# Selection method
			#   Measure time to create path comparing the two types of creation
			starting = Time.now
			for a in ants
			# Obs : There is no significant difference in using
				a.create_path_decrescent(@nodes,@graph,@nodes_f_sum)
#				a.create_path_crescent(@nodes,@graph,@nodes_f_sum)
			end
			ending = Time.now

			# Pheromone evaportaion
			#  ;-; it's so slow
			#  seems like its decreasing too much
			for i in @nodes.keys
#				@nodes[i] *= (1 - rand())
				@nodes[i] *= (1 - 0.05)
			end

			# Solution quality/Pheromone atualization
			media = 0
			for a in ants
				lk = a.path_lenght()
				media += lk
				if lk < @best[1]
					@best[0] = i
					@best[1] = lk
				end
#				puts lk
				for idx in a.path
					@nodes[idx] += 1/lk
				end
			end

			# Atualize the cumulative sum
			att_nodes_f_sum

			# Execution statistics
			stats(media,ending,starting)
		end
		puts "\nThe Best : "
		puts @best.inspect
	end

	private
	def att_nodes_f_sum()
		aux = 0
		for i in @nodes.keys
			aux += @nodes[i]
		end
		@nodes_f_sum = aux # remember to atualize it

	end

	private
	def stats(media,ending,starting)
		print "Media : "
		puts media/@n_ants

		print "Time : "
		puts (ending - starting)

		puts "Top 10 :"
		top_10
	end

	def top_10()
		i = 0
		aux = @nodes.sort_by {|x| -1*x[1]}
		for tupla in aux
			puts tupla.inspect
			i += 1
			if i == 10; break end
		end
	end

end

END{
#	init_file()
	graph = SocialNetwork.new
#	puts graph.keys.map{|x| x.to_i}.sort
	saco  = AntColonyAlgorithm.new(graph,graph.keys,100,20)
	saco.run()
}
