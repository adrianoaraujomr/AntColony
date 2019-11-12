#!/usr/bin/ruby -w

def read_transform()
	hs = Hash.new
	fd = File.new("./graph.csv", "r")

	while (line = fd.gets)
		root  = line.split(",")[0].to_i
		nodes = line.split("[")[1]
		nodes = nodes.gsub("\"","").gsub("]","").gsub("\'","").gsub("\r\n","")
		nodes = nodes.split(",")
#		nodes = nodes.map{|x| x.to_i}

		hs[root] = nodes
	end

	return hs
end
