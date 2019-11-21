#!/usr/bin/ruby -w

$test_nro   = 0
$file_name  = "./Results/results_"

def init_file()
	fd = File.open("./Results/test_nro.txt","r")
	$test_nro  = fd.read.strip
	$file_name = $file_name + $test_nro + ".csv"  
	puts $file_name
	fd.close
end

def update_file()
	fd = File.open("./Results/test_nro.txt","w")
	puts $test_nro.to_i + 1
	fd.write($test_nro.to_i + 1)
	fd.close
end

# Remember to remove the file if youre not going to wait the algorithm finish
def write_stats(iter,path_sizes,nodes_hash,cum_sum)
	fd = File.open($file_name,"a+")

	fd.write("LK;" + iter.to_s + ";") # odd lines path lenghts of each iteration
	for lk in path_sizes
		fd.write(lk.to_s + ";")
	end
	fd.write("\n")

	fd.write("PK;" + iter.to_s + ";") # odd lines path lenghts of each iteration
	for j in nodes_hash.keys
		pk = nodes_hash[j]/cum_sum
		fd.write(pk.to_s + ";")
	end
	fd.write("\n")

	fd.close()
end
