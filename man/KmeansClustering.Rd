% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kmeans-clustering-method.R
\docType{class}
\name{KmeansClustering}
\alias{KmeansClustering}
\title{Build clusters using kmeans()}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
KmeansClustering(object, df, grainCol, labelCol, numOfClusters, 
  usePCA, numOfPCA,impute, debug)
}
\arguments{
\item{object}{of UnsupervisedModelParams class for $new() constructor}

\item{df}{Dataframe whose columns are used for calc.}

\item{grainCol}{Optional. The dataframe's column that has IDs pertaining to 
the grain. No ID columns are truly needed for this step. If left blank, row
numbers are used for identification.}

\item{labelCol}{Optional. Labels will not be used for clustering. Labels can
be can be used for validation. The number of clusters should be the same as
the number of labels. Functions getClusterLabels() and getConfusionMatrix()
are only available if labelCol is provided. Generally, supervised models
are a better choice if your goal is classification.}

\item{numOfClusters}{Number of clusters you want to build. If left blank,
will be determined automatically from the elbow plot.}

\item{usePCA}{Optional. TRUE or FALSE. Default is FALSE. If TRUE, the
method will use principle components as the new features to perform K-means
clustering. This may accelerate convergence on high-dimension datasets.}

\item{numOfPCA}{Optional. If using principle components, you may specify
the number to use to perform K-means clustering. If left blank, it will be
determined automatically from the scree (elbow) plot.}

\item{impute}{Set all-column imputation to FALSE or TRUE. This uses mean
replacement for numeric columns and most frequent for factorized columns. 
FALSE leads to removal of rows containing NULLs.}

\item{debug}{Provides the user extended output to the console, in order to
monitor the calculations throughout. Use TRUE or FALSE.}
}
\description{
This step allows you to use kmeans clustering to explore and
  group your data.
}
\details{
This is an unsupervised method for clustering data. That is, no
  response variable is needed or used. If you want to examine how the data
  clusters by some labeled grouping, you can specify the grouping in
  \code{labelCol}, but the labels are not used in
  the clustering process. If you want to use labels to train the model 
  see \code{\link{LassoDevelopment}} or \code{\link{RandomForestDevelopment}}.
}
\section{Methods}{
 The above describes params for initializing a new
  KmeansClustering class with \code{$new()}. Individual methods are
  documented below.
}

\section{\code{$new()}}{
 Initializes a new Kmeans Clustering class using the 
  parameters saved in \code{p}, documented above. This method loads, cleans,
  and prepares data for clustering. \cr \emph{Usage:} \code{$new(p)}
}

\section{\code{$run()}}{
 Calculates clusters, displays performance. \cr 
  \emph{Usage:}\code{$run()}
}

\section{\code{$get2DClustersPlot()}}{
 Displays the data and assigned
  clusters. PCA is used to visualize the top two priciple components for
  plotting. This is unrelated to variable reduction for clustering. Passing 
  TRUE to this function will display grain IDs on the plot. \cr 
  \emph{Usage:} \code{$get2DClustersPlot()} \cr
}

\section{\code{$getOutDf()}}{
 Returns the output dataframe for writing to SQL
  or CSV. \cr \emph{Usage:} \code{$getOutDf()} \cr
}

\section{\code{$getConfusionMatrix()}}{
 Returns a confusion matrix of assigned
  cluster vs. provided labels. Clusters are named based on maximum overlap
  with label. Only available if labelCol is specified. Rows are true labels,
  columns are assigned clusters. \cr 
\emph{Usage:} \code{$getConfusionMatrix()} \cr
}

\section{\code{$getElbowPlot()}}{
 Plots total within cluster error vs. number
  of clusters. Available if the number of clusters is unspecified. \cr 
  \emph{Usage:} \code{$getElbowPlot()} \cr
}

\section{\code{$getScreePlot()}}{
 Plots total variance explained vs. number of
  principle components. Available if the number of principle components is
  unspecified. \cr \emph{Usage:} \code{$getScreePlot()} \cr
}

\section{\code{$getKmeansFit()}}{
 Returns all attributes of the kmeans fit
  object. \cr \emph{Usage:} \code{$getKmeansFit()} \cr
}

\examples{

#### Example using Diabetes dataset ####
ptm <- proc.time()
# Can delete this line in your work
csvfile <- system.file("extdata", 
                       "HCRDiabetesClinical.csv", 
                       package = "healthcareai")
# Replace csvfile with 'your/path'
df <- read.csv(file = csvfile, 
               header = TRUE, 
               na.strings = c("NULL", "NA", ""))
head(df)
df$PatientID <- NULL

set.seed(42)
p <- UnsupervisedModelParams$new()
p$df <- df
p$impute <- TRUE
p$grainCol <- "PatientEncounterID"
p$debug <- FALSE
p$cores <- 1
p$numOfClusters <- 3

# Run k means clustering
cl <- KmeansClustering$new(p)
cl$run()

# Get the 2D representation of the cluster solution
cl$get2DClustersPlot()

# Get the output data frame
dfOut <- cl$getOutDf()
head(dfOut) 

print(proc.time() - ptm)




#### Example using iris dataset with labels ####
ptm <- proc.time()
library(healthcareai)

data(iris)
head(iris)

set.seed(2017)

p <- UnsupervisedModelParams$new()
p$df <- iris
p$labelCol <- 'Species'
p$impute <- TRUE
p$debug <- FALSE
p$cores <- 1

# Run k means clustering
cl <- KmeansClustering$new(p)
cl$run()

# Get the 2D representation of the cluster solution
cl$get2DClustersPlot()

# Get the output data frame
dfOut <- cl$getOutDf()
head(dfOut) 

## Write to CSV (or JSON, MySQL, etc) using plain R syntax
## write.csv(dfOut,'path/clusteringresult.csv')

print(proc.time() - ptm)

}
\references{
\url{http://hctools.org/}

\url{https://github.com/bryanhanson/ChemoSpecMarkeR/blob/master/R/findElbow.R}
}
\seealso{
\code{\link{healthcareai}}
}
\keyword{datasets}
