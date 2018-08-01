# DataSkewProfiler

Data Skew Profiler for HPCC Systems

#Project Overview

The purpose of the project is to analyze the execution graphs for various jobs and find a correlation between the data skew and performance skew.
Data skew : How the data is distributed on the cluster.
Performance skew : How much more load a single node has to take in processing the data in comparison with other nodes

Once that is done the performance skew is minimized by redistributing the data in the most efficient way possible.

#Cluster Details

Hosted on AWS
Number of Thor master nodes:1
Number of Thor slave nodes: 3

#Dataset Details

Dataset: IMDB dataset 
The dataset contains a list of actors and actresses and a list of Movies/TV shows each actor has performed in.
Dataset download link : (ftp server) ftp://ftp.fu-berlin.de/pub/misc/movies/database/ 

#Query Details

The queries used to runs jobs which are used to build and test the model are explained in the "Six Degrees of Kevin Bacon" pdf.
Link: cdn.hpccsystems.com/releases/CE-Candidate-5.0.2/docs/IMDB-5.0.2-1.pdf.

After running the jobs, the graphs were analyzed and 7 types of queries were identified that take the longest to execute (these in theory have the maximum chance to produce skew).
1.) Disk Write
2.) Lookup Join	
3.) Inner Join
4.) Spill
5.) Disk Read
6.) Hash Dedup
7.) Sort

A dataset is created using these query types as features upon which the model will be trained.

#Random Forest Model

The program employs a random forest emsemble which is trained by the data and the corresponding skew from the dataset that was created in the previous stage. 
Takes the frequency of each of the 7 types of queries in a workunit as input, and profile the relative impact of skew on the impact in 3 levels.
1) Skew level 0 - Low amount of skew.
2) Skew level 1 - Medium amount of skew.
3) Skew level 2 - High amount of skew.

The model also ouputs the relative importance of features within the random forest. By redistributing the data around the type of query with the maximum impact of skew, the amount of time taken to execute the job decreases. The process is repeated for different initial distributions of data, with varying initial skews and the time taken for each workunit is documented.

Care has to be taken that the amount of time taken to redistribute the data does not outweigh the benefit. If too much redistribution is done the performance may end up being worse than that of skewed data.
