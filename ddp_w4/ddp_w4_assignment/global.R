library(tm)
library(wordcloud)
library(memoise)

# The list of valid books
# books <<- list("A Mid Summer Night's Dream" = "summer",
#                "The Merchant of Venice" = "merchant",
#                "Romeo and Juliet" = "romeo")

funcs <<- list("Quantity" = "cant",
               "log()" = "log",
               "sqrt()" = "sqrt")

getTermMatrix <- memoise(function(func) {
  
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(func %in% funcs))
    stop("Unknown function.")
  
  book <- "words"
  
  file <- sprintf("./%s.txt.gz", book)
  dfPueblos <- read_delim(file, delim=";", col_type = cols(
    nombre = col_character(),
    Cant = col_integer()
  )) %>%
    arrange(desc(Cant))
  
  v <- dfPueblos$Cant
  
  if (func == "log") {
    ret <- round(log(v))
  } else { 
    if (func == "sqrt")
      ret <- round(sqrt(v))
    else
      ret <- v
  }
  
  names(ret) <- dfPueblos$nombre

  ret  
})



# Using "memoise" to automatically cache the results
getTermMatrix_orig <- memoise(function(book) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(book %in% books))
    stop("Unknown book")
  
  text <- readLines(sprintf("./%s.txt.gz", book),
                    encoding="UTF-8")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

