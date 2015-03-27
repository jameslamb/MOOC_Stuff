## Tokenization

    ## package loading
    library(tm)
    library(qdap)

    ## read the data (start with blogs)
    url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    
    con <- file(".\\Coursera-SwiftKey\\final\\en_US\\en_US.blogs.txt", open="rb")
    data <- readLines(con, n = 4000, encoding="UTF-8")
    close(con); rm(con);
    
    ## do some whitespace stripping
    data <- stripWhitespace(data)
    
    ## preliminary frequency table
    freqs <- termFreq(Corpus(VectorSource(data)))
    
    ## first pass (premade functions)
    pass1a <- scan_tokenizer(data)
    pass1b <- MC_tokenizer(data) ## returns more elements
    
## Profanity Filtering
    
    ## One approach (prebuilt function from tm package)
    cleandata <- removeWords(x=data, words=c("the","bad","words"))
    
## Other Stuff
    
    ## find frequent terms
    
## References
    
    [1] http://stackoverflow.com/questions/12626637/reading-a-text-file-in-r-line-by-line