#!/usr/bin/ruby -w

#END {
#	init_file
#	update_file
#}

$test_nro   = 0
$file_name  = "./Results/results_"

def init_file()
	fd = File.open("./test_nro.txt","r")
	$test_nro  = fd.read.strip
	$file_name = $file_name + $test_nro + ".csv"  
	fd.close
end

def update_file()
	fd = File.open("./test_nro.txt","w")
	puts $test_nro.to_i + 1
	fd.write($test_nro.to_i + 1)
	fd.close
end

def write_parameters(params)
	fd = File.open($file_name,"w+")
	fd.write(params)
	fd.write("\n")
	fd.close
end

def write_fitness(i,fitness)
	fd = File.open($file_name,"a")
	
	fd.write(i.to_s + ";")
	for i in fitness
		fd.write(i)
		fd.write(";")
	end
	fd.write("\n")
	fd.close
end
