#!/usr/bin/python3

import os
import matplotlib.pyplot as plt

fig_dir = "./pyplot/"

def plot_media_graph(fn,nodes,flwrs):
	gen = range(0,len(nodes))

	fig = plt.figure()

	plt.plot(gen,nodes)
	plt.title('Path sizes mean')
	plt.tight_layout()

	fn = fn.split('.')[0]
	plt.savefig(fig_dir + fn + ".png")
	
	plt.close()

def plot_graphs(fn,nodes,flwrs):
	gen = range(0,len(nodes))

	fig = plt.figure()

	plt.subplot(2,1,1)
	plt.plot(gen,nodes,'o', color='black')
	plt.title('Path sizes')

	gen = range(0,len(flwrs))
	plt.subplot(2,1,2)
	plt.plot(gen,flwrs)
	plt.title('Node rankings')

	plt.tight_layout()

	fn = fn.split('.')[0]
	plt.savefig(fig_dir + fn + ".png")
	
	plt.close()


files = os.listdir("./Results")
for fn in files:

	if ".csv" in fn:
		paths = []
		ranks = []
		media = []
		fd = open("./Results/" + fn,"r")
		lines = fd.readlines()
		try:
			os.mkdir("./pyplot/" + fn.replace(".csv",""))
		except:
			pass

		# Run trough the population generations
		for ln in lines:
			ln = ln.strip().split(";")
			if ln[0] == "LK":
				aux = 0
				for size in ln[2:len(ln) - 1]:
					paths.append(int(size))
					aux += int(size)
				media.append(aux/len(ln[2:len(ln) - 1]))
			else:
				for rank in ln[2:len(ln) - 1]:
					ranks.append(float(rank))
#				plot_graphs(fn.replace(".csv","") + "/" + ln[1] + "_" + fn,paths,ranks)
				paths = []
				ranks = []

		plot_media_graph(fn.replace(".csv","") + "/" + "mean" + "_" + fn,media,ranks)
#		plot_graphs(fn,paths,nodes)
