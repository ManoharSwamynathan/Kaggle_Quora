# Created on Sun Jun  4 20:43:43 2017
# @author: manohar swamynathan

# Learn more about triples concept from my following blog
# http://www.mswamynathan.com/2017/01/21/triplets-for-concept-extraction-from-english-sentence-deep-nlp/

### Install required packages ###
# install.packages("devtools", dependencies = T)
# install.packages("rJava", dependencies = T)
# install.packages("tm", dependencies = T)
# install.packages("qdap", dependencies = T)
# install.packages("NLP", dependencies = T)
# install.packages("openNLP", dependencies = T)
# install.packages("StanfordCoreNLP", repos="http://datacube.wu.ac.at/", type="source")
# install.packages("SnowballC", dependencies = T)
#################################

# Load required packages
# Please change the JAVA_HOME to suite system configuration
Sys.setenv(JAVA_HOME='/usr/lib/jvm/java-8-oracle') 
library(rJava)
library(tm)
library(qdap)
library(NLP)
library(openNLP)
library(StanfordCoreNLP)
library(SnowballC)
library(data.table)
.jinit()

# Function to extract triples in the form subject:predicate[modifier]:object from sentences. 
# Note that a given sentence can have multiple subject/predicate/object, this function extracts max of 3 triples
# s: Sentence for which triples to be extracted 
# returns triples or set of triples
extract_triples <- function(s){
  tryCatch({
    s <- as.String(s) 

    # Data preprocessing i.e., convert to lowercase and remove numbers and special characters
    s <- tolower(s)
    s <- gsub( "[?.;!B!B?B7',0123456789[:punct:]]", "", s)
    
    # placeholder for variable/output    
    p <- c()
    y <- c()
    ptexts <- c()
    ptrees <- c()
    depends <- c()
    subj <- c()
    pred <- c()
    objt <- c()
    negt <- c()
    advm <- c()
    mwe <- c()
    actn <- c()
    predicate <- c()
    object <- c()
    T1 <- c()
    T2 <- c()
    T3 <- c()
    
    ## Annotators: ssplit, tokenize, parse:
    p <- StanfordCoreNLP_Pipeline("parse")
    y <- p(s)
    
    ## Respective formatted parse trees using Penn Treebank notation
    ## (see <http://www.cis.upenn.edu/~treebank/>):
    ptexts <- sapply(subset(y, type == "sentence")$features, `[[`, "parse")
    
    ## Read into NLP Tree objects.
    ptrees <- lapply(ptexts, Tree_parse)
    
    ## Basic dependencies:
    depends <- lapply(subset(y, type == "sentence")$features, `[[`, "basic-dependencies")
    
    df <- as.data.frame(depends)
    # extract subject  
    if (length(df$dependent[df$type == "nsubj"])>0 ) {subj = df$dependent[df$type == "nsubj"]}
    
    # extract predicate
    action <- if(length(df$governor[df$type == "dobj"])>0){df$governor[df$type == "dobj"]} else if(length(df$governor[df$type == "xcomp"])>0) {df$governor[df$type == "xcomp"]} else {df$governor[df$type == "nsubj"]}
    
    # extract object
    objt <- if(length(df$dependent[df$type == "dobj"])>0){df$dependent[df$type == "dobj"]} else if (length(df$dependent[df$type == "xcomp"])>0) {df$dependent[df$type == "xcomp"]} else if (length(df$dependent[df$type == "pobj"])>0) {df$dependent[df$type == "pobj"]}
    actn <- c()
    
    # if its a passive sentence subject will not be available so extract predicate and object
    predicate <- df$dependent[df$type=="prep"]
    object <- df$dependent[df$governor %in% df$dependent[df$type=="prep"]]
    
    # extract modifiers
    if (length(df$dependent[df$type == "neg"])>0) {negt = paste0("[",df$dependent[df$type == "neg"],"]")} else {negt <- c()} # negation modifier
    if (length(df$dependent[df$type == "advmod"])>0) {advm = paste0("[",df$dependent[df$type == "advmod"],"]")} else {advm <- c()} # adverb modifier
    if (length(df$dependent[df$type == "mwe"])>0) {mwe = paste0("[",df$dependent[df$type == "mwe"],"]")} else {mwe <- c()}
    
    if (length(action>0)){
      for (i in 1:length(action)){
        # For passive sentence
        if (length(df$governor[df$type == "neg"])>0 && df$governor[df$type == "neg"] == action[i]) {actn[i] <- print(paste0(action[i],negt))} else {actn[i] <- print(action[i])}
        if (length(df$governor[df$type == "advmod"])>0 && df$governor[df$type == "advmod"] == action[i]) {actn[i] <- print(paste0(actn[i],advm))} 
        if (length(df$governor[df$type == "mwe"])>0 && df$governor[df$type == "mwe"] == action[i]) {actn[i] <- print(paste0(actn[i],mwe))}}
    } else if (length(df$dependent[df$type == "nsubjpass"])>0) {subj = df$dependent[df$type == "agent"]; objt = df$dependent[df$type == "nsubjpass"] ; if (length(df$dependent[df$type == "root"])>0) {actn = df$dependent[df$type == "root"]}} 
    
    
    T1 <- if (length(subj) > 0 | length(actn) > 0 | length(objt) > 0) {paste0(subj,":",actn,":",objt)}
    T2 <- if(length(predicate)>0){paste0(subj,":",if(predicate[1] %in% c("with","to")) {paste0(actn,":",predicate[1])} else {predicate[1]},":",object[1])}
    T3 <- if(length(predicate)>1){paste0(subj,":",if(predicate[2] %in% c("with","to")) {paste0(actn,":",predicate[2])} else {predicate[2]},":",object[2])}
    
    triples.string <- paste0(T1,T2,T3, sep="|")
    }, error = function(e) {rm(triples.string)})
    rm(subj)
    rm(pred)
    rm(objt)
    rm(negt)
    rm(advm)
    rm(mwe)
    rm(actn)
    rm(predicate)
    rm(object)
    rm(T1)
    rm(T2)
    rm(T3)
    #flush.console()
    return(triples.string)
}
