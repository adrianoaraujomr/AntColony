#!/usr/bin/ruby -w

require 'set'
require "./file_to_hash"

# Social Network Graph
#	It will deal with operations involving directly the graph
class SocialNetwork
	@@graph = edge_list_to_hash()
#	@@graph = read_transform()

	def show_graph()
		return @@graph
	end

	def keys()
		return @@graph.keys
	end

	def neighbours_list(node)
		@@graph[node]
	end

	# This will define when the ant will get to its objective
	def n_nodes()
		return @@graph.keys.size
	end

	def neighbours_2(nodes)
		neigh = Set.new
		for v in nodes
			neigh.add(v)
			neigh = neigh | @@graph[v].to_set
		end
		return neigh
	end

	# This will define the path length
	def neighbours(nodes)
		neigh = Set.new
		for v in nodes
			neigh.add(v)
			neigh = neigh | @@graph[v].to_set
		end
		return neigh.length
	end
end
