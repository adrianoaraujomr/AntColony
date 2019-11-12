#!/usr/bin/ruby -w

class SimpleSel
	def run(node_hash):
		for k in node_hash.keys
			r = rand()
			if r <= node_hash[k]
				return k
			end
		end
	end
end
