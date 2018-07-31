# DataSkewProfiler
Data Skew Profiler for HPCC Systems

#Cluster Details

Hosted on AWS
Number of Thor master nodes:1
Number of Thor slave nodes: 3
Present on IP:

#Dataset Details

Dataset: IMDB dataset
Link: cdn.hpccsystems.com/releases/CE-Candidate-5.0.2/docs/IMDB-5.0.2-1.pdf

Dataset: Taxi Dataset
Link: https://github.com/hpcc-systems/Solutions-ECL-Demos/blob/master/Taxi/README.md

#Query Details
Enter Query Details, if anything essential 

#PythonFilenamehere
Takes the <enter parameters here> as input for the queries in a workunit, and profile the impact of skew on the impact as 0(low), 1(medium) or 2(high). 
  
The process is repeated for different initial distributions of data, with varying initial skews and the time taken for each workunit is documented. The number of records in question are accounted for to provide the impact of skew. 

The program employs a random forest emsemble to be trained by the data and the corresponding skew. 

#Interpretability
Will add this if necessary, basically explaining the implications and inferences of the result. 
