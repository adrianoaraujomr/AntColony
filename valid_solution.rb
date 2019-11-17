#!/usr/bin/ruby -w

BEGIN{
	require 'set'

	fd  = File.new("./solution.in","r")
	sol = Array.new

	while (i = fd.gets)
		sol.push(i.gsub("\n",""))
	end
#	puts sol
#	sol = sol.gsub("\"","").gsub(" ","")
#	sol = sol.split(",")
#	puts sol

	fd = File.new("./Graphs/benchmark_graph_1.txt","r")
	st = Set.new
	while (line = fd.gets)
		edge = line.split(" ")
		if sol.include? edge[0]
#			puts edge[0]
			st.add(edge[0])
			st.add(edge[1])
#			puts edge[1]
		end
	end
	puts st.to_a.size
#	puts st.to_a
}
