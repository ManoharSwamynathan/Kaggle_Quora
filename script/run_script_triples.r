# Created on Sun Jun  4 20:43:43 2017
# @author: manohar swamynathan

# set working directory, change this to your folder path where all files are dumped
setwd('/home/manohar/Documents/Quora/script')

# load triples extraction function
source('extract_triples.r')

# Load data
train <- read.csv('../input/train.csv', sep = ',', header=T, nrows = 100) #loading first 100 records only
test <- read.csv('../input/train.csv', sep = ',', header=T, nrows = 100) #loading first 100 records only

# Loop through question 1 & 2 of train dataset to extract triples
for (i in 1:nrow(train)){
  # create progress bar
  pb <- txtProgressBar(min = 0, max = nrow(train), style = 3)
  
  q1_triple <- as.String(paste(extract_triples(train$question1[i]), sep=","))
  train$q1_triples[i] <- if (length(q1_triple)>0){q1_triple} else {'NA'}
  q2_triple <- as.String(paste(extract_triples(train$question2[i]), sep=","))
  train$q2_triples[i] <- if (length(q2_triple)>0){q2_triple} else {'NA'}
  
  close(pb)
}


# Loop through question 1 & 2 of test dataset to extract triples
for (i in 1:nrow(test)){
  # create progress bar
  pb <- txtProgressBar(min = 0, max = nrow(test), style = 3)
  
  q1_triple <- as.String(paste(extract_triples(test$question1[i]), sep=","))
  test$q1_triples[i] <- if (length(q1_triple)>0){q1_triple} else {'NA'}
  q2_triple <- as.String(paste(extract_triples(test$question2[i]), sep=","))
  test$q2_triples[i] <- if (length(q2_triple)>0){q2_triple} else {'NA'}
  
  close(pb)
}

write.csv(train, file = 'train_triples.csv')
write.csv(test, file = 'test_triples.csv')