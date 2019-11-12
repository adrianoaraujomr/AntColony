#!/usr/bin/ruby -w

require 'set'
require "./file_to_hash"

# Social Network Graph
#	It will deal with operations involving directly the graph
class SocialNetwork
	@@graph = read_transform()

	def show_graph()
		return @@graph
	end

	def keys()
		return @@graph.keys
	end

	# This will define when the ant will get to its objective
	def n_nodes()
		return @@graph.keys.size
	end

	# This will define the path length
	def neighbours(nodes)
		neigh = Set.new

		for v in nodes
			aux = Set.new @@graph[v] 
			neigh.merge aux
		end

		return neigh.length
	end
end
