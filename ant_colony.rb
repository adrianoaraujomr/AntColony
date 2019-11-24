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

	# Star with full nodes and remove some (higher the weight less the chance of being removed)
	#  1 - sample
	#  2 - run sequentialy
	def create_path_decrescent_rnd(node_hash,graph,cum_sum,alfa,beta)
		@path = node_hash.keys # Array
		@stop = graph.neighbours(@path)
		# Sample
		while @stop == graph.n_nodes
			j = @path.sample       # probale new node
			r = rand()                  # "randomness control"
			if r < (node_hash[j]**alfa)/cum_sum # probability of chosing the j node
				rm = @path.delete(j)
				@stop = graph.neighbours(@path)
			end
		end
		@path.push(rm)

	end
	def create_path_decrescent_seq(node_hash,graph,cum_sum,alfa,beta)
		@path = node_hash.keys # Array
		@stop = graph.neighbours(@path)
		# Sequentialy
		i = 0
		while @stop == graph.n_nodes
			i = (i + 1).modulo @path.length
			j = @path[i]                # probale new node
			r = rand()                  # "randomness control"
			if r < (node_hash[j]**alfa)/cum_sum # probability of chosing the j node
				rm = @path.delete(j)
				@stop = graph.neighbours(@path)
			end
		end
		@path.push(rm)
	end

	# Build the path one by one
	#  1 - sample
	#  2 - run sequentialy
	def create_path_crescent(node_hash,graph,cum_sum,alfa,beta)
		while @stop < graph.n_nodes
			j = node_hash.keys.sample # probale new node
			r = rand()                # "randomness control"

			if r > (node_hash[j]**alfa)/cum_sum # probability of chosing the j node
				@path.add(j)
				@stop = graph.neighbours(@path)
			end
		end
#		@path = @path.to_a
	end

	def path()
		return @path
	end

	def path_lenght()
		return @path.size
	end
end

# Get solutions to a csv format
#	at each iteration :
#		- the size of the path of each ant
#		- the ranking of vertex (by probability/feromonio)

class AntColonyAlgorithm
	def initialize(graph,nodes,iterations,n_ants)
		@alfa   = 7
		@beta   = 3
		@best   = [0,graph.n_nodes]
		@graph  = graph
		@iter   = iterations
		@n_ants = n_ants
		@nodes  = Hash.new
		@answer = []

		# Initialize pheromone
		#  maybe put some heuristic (number of neighbours)
		aux = 0
		for i in 0..(nodes.size - 1)
			r = rand()
#			h = (1.0 - (1.0/graph.neighbours_list(nodes[i]).size))
#			@nodes[nodes[i]] = [r,h]
			@nodes[nodes[i]] = r
#			aux += (r**@alfa) * (h**@beta)
			aux += r**@alfa
		end
		@nodes_f_sum = aux
	end

	def run()
		for i in 1..@iter
			puts "Iteration " + i.to_s

			# Ant initialization
			ants = Array.new
			for j in 0..(@n_ants - 1)
				aux = @nodes.keys.sample
				ants.push(Ant.new(aux,@graph))
			end

			# Selection method
			starting = Time.now
			for a in ants
				a.create_path_decrescent_seq(@nodes,@graph,@nodes_f_sum,@alfa,@beta)
#				a.create_path_decrescent_rnd(@nodes,@graph,@nodes_f_sum,@alfa,@beta)
#				a.create_path_crescent(@nodes,@graph,@nodes_f_sum,@alfa,@beta)
			end
			ending = Time.now

#			# Pheromone evaportaion
#			for j in @nodes.keys
#				@nodes[j] *= (1 - rand())
##				@nodes[j] *= (1 - 0.05)
#			end

			# Solution quality/Pheromone update
			media = 0
			lks   = []
			for a in ants
				lk = a.path_lenght()
				for idx in a.path
#					@nodes[idx][0] += (1.0/lk)
					@nodes[idx] += (1.0/lk)
				end

			# Extra (statistics)
				media += lk
				lks.push(lk)
				if lk < @best[1]
					@best[0] = i
					@best[1] = lk
					@answer  = a.path # in decrescent thre return is an array (crescent is a set)
				end
			end

			# Update the cumulative sum
			att_nodes_f_sum

			# Execution statistics
			stats(media,ending,starting)

			# i                     = iteration
			# lks                   = the lenght of the path of each ant
			# @nodes + @nodes_f_sum = the "rank" of each node
			write_stats(i,lks,@nodes,@nodes_f_sum)
		end
		puts "\nThe Best : "
		puts @best.inspect
		update_file()
	end

	private
	def att_nodes_f_sum()
		aux = 0
		for i in @nodes.keys
#			aux += (r**@alfa) * (h**@beta)
			aux += @nodes[i]**@alfa
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
	init_file()
	graph = SocialNetwork.new
	saco  = AntColonyAlgorithm.new(graph,graph.keys,1000,20)
	saco.run()
}
