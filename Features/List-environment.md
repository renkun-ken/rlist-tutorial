

# List environment

List environment is an alternative construct designed for easier command chaining. `List()` function wraps a list within an environment where almost all functions in this package are defined but result in the next List environment for further operations.

Suppose we work with the following list.


```r
library(rlist)
library(pipeR)
people <- list.load("https://renkun-ken.github.io/rlist-tutorial/data/sample.json")
```

To create a `List environment`, run


```r
m <- List(people)
```

then we can operate the environment-based object `m` with `map()`, `filter()` and other functions, or extract the inner data with `m$data`. All inner functions return `List environment`, which facilities command chaining.

For example, map each member to their name.


```r
m$map(Name)
```

```
# $data : list 
# ------
# [[1]]
# [1] "Ken"
# 
# [[2]]
# [1] "James"
# 
# [[3]]
# [1] "Penny"
```

Note that the resulted object is also a `List environment` although its printed results include the inner data. To use the result with external functions, we need to extract the inner data by calling `m$data`.

Get all the possible cases of interests for those whose R experience is longer than 1 year.


```r
m$filter(Expertise$R > 1)$
  cases(Interests)$
  data
```

```
# [1] "movies"  "music"   "reading" "sports"
```

Calculate an integer vector of the average number of years using R for each interest class.


```r
m$class(Interests)$
  map(case ~ length(case))$
  call(unlist)$
  data
```

```
#  movies   music reading  sports 
#       2       2       2       1
```

A more handy way to extract `data` from the List environment is to use `[]`.


```r
m$class(Interests)$
  map(case ~ length(case))$
  call(unlist) []
```

```
#  movies   music reading  sports 
#       2       2       2       1
```

