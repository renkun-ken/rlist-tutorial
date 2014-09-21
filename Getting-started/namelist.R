library(rlist)
library(pipeR)
library(babynames)

interests <- c("reading","writing","movies","music","sports","hiking",
  "cooking")
languages <- c("R","Python","CSharp","Cpp","Java","Ruby","Scala")
probs <- c(0.6,0.5,0.1,0.1,0.3,0.2,0.1)

set.seed(123)

people <- 1:500 %>>%
  list.map(list(
    Name = babynames$name %>>% sample(1),
    Age = 20 + ceiling(rnorm(1,8,3)),
    Interests = interests %>>% sample(rbinom(1,4,0.5)),
    Expertise = rbinom(1,4,0.6) %>>%
      rbinom(5,0.5) %>>%
      as.list %>>%
      setNames(sample(languages,length(.),FALSE,probs)))
    ) %>>%
  list.save("Getting-started/people.json",
    auto_unbox = TRUE, pretty = TRUE)
