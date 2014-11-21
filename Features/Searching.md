

# Searching

rlist provides searching capabilities, that is, to find values within a list recursively. `list.search()` handles a variety of search demands. 


```r
library(rlist)
library(pipeR)
friends <- list.load("http://renkun.me/rlist-tutorial/data/friends.json")
```

If the expression results in a single-valued logical vector and its value is `TRUE`, the whole vector will be collected. If it results in multi-valued non-logical vector, the non-`NA` results will be collected. 

Search all elements equal to *Ken* recursively.


```r
list.search(friends, . == "Ken")
```

```
# $Ken.Name
# [1] "Ken"
```

Note that `.` represents every atomic vector in the list and sublists. For single-valued vector, the search expression results in `TRUE` or `FALSE` indicating whether or not to return the text of the character vector. For multi-valued vector, the search expression instead results in mutli-valued logical vector which will be considered invalid as search results.

To find out all vectors that includes *Ken*, we can use `%in%`, which always returns `TRUE` or `FALSE` for this dataset.


```r
list.search(friends, "Ken" %in% .)
```

```
# $Ken.Name
# [1] "Ken"
# 
# $James.Friends
# [1] "Ken"   "Penny"
```

If the search expression returns a non-logical vector with non-`NA` values, then these values are returned. For example, search all values of *Ken*.


```r
list.search(friends, .[. == "Ken"])
```

```
# $Ken.Name
# [1] "Ken"
# 
# $James.Friends
# [1] "Ken"
```

The selector can be very flexible. We can use regular expression in the search expression. For example, search all values that matches the pattern *en*, that is, includes *en* in the text.


```r
list.search(friends, .[grepl("en",.)])
```

```
# $Ken.Name
# [1] "Ken"
# 
# $James.Friends
# [1] "Ken"   "Penny"
# 
# $Penny.Name
# [1] "Penny"
# 
# $David.Friends
# [1] "Penny"
```

The above examples demonstrate how searching can be done recursively using `list.search()`. However, the function by defaults evaluate with all types of sub-elements. For example, if we look for character values of *24*,


```r
list.search(friends, . == "24")
```

```
# $Ken.Age
# [1] 24
# 
# $Penny.Age
# [1] 24
```

the integer value will be returned too. It is because when R evaluates the following expression


```r
24 == "24"
```

```
# [1] TRUE
```

number 24 is coerced to string *24* which then are equal. This is also known as the result of comparison of atomic vectors. However, this behavior is not always desirable in practice. If we want to limit the search to the range of character vectors rather than any, we have to specify `classes =` argument for `list.search()`.


```r
list.search(friends, . == "24", classes = "character")
```

```
# named list()
```

This time no character value is found to equal *24*. To improve the search performance and safety, it is always recommended to explicitly specify the classes to search so as to avoid undesired coercion which might lead to unexpected results.

In some cases, the search results are deeply nested. In this case, we need to unlist it so that the results are better viewed. In this case, we can set `unlist = TRUE` so that an atomic vector will be returned.


```r
list.search(friends, .[grepl("en",.)], "character", unlist = TRUE)
```

```
#       Ken.Name James.Friends1 James.Friends2     Penny.Name  David.Friends 
#          "Ken"          "Ken"        "Penny"        "Penny"        "Penny"
```

Sometimes, we don't need that many results to be found. We can set `n =` to limit the number of results to show.


```r
list.search(friends, .[grepl("en",.)], "character", n = 3, unlist = TRUE)
```

```
#       Ken.Name James.Friends1 James.Friends2     Penny.Name 
#          "Ken"          "Ken"        "Penny"        "Penny"
```

Like other rlist functions, the search expression can be a lambda expression. However, `list.search()` does not name meta-sybmol in search expression yet. In other words, you cannot use `.name` to represent the name of the element. You can use `.i` to represent the number of vectors that has been checked, and `.n` to represent the number of vectors that satisfy the condition.

