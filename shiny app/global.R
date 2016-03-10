library(tm)
library(wordcloud)
library(memoise)

airlines <- list("air-canada-rouge",
     "sunwing-airlines",
     "spirit-airlines",
     "american-airlines",
     "united-airlines",
     "top")

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(airline) {
    # Careful not to let just any name slip in here; a
    # malicious user could manipulate this value.
    if (!(airline %in% airlines))
        stop("Unknown Airline")
    
    text <- readLines(sprintf("./%s.txt", airline),
                      encoding="UTF-8")
    
    myCorpus = Corpus(VectorSource(text))
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    myCorpus = tm_map(myCorpus, removePunctuation)
    myCorpus = tm_map(myCorpus, removeNumbers)
    myCorpus = tm_map(myCorpus, removeWords,
                      c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but", "flight", "plane","air","canada","rouge","spirit","united","american","sunwing","toronto","dallas","airline","airlines"))
    
    myDTM = TermDocumentMatrix(myCorpus,
                               control = list(minWordLength = 1))
    
    m = as.matrix(myDTM)
    
    sort(rowSums(m), decreasing = TRUE)
})