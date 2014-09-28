

# Searching

rlist provides searching capabilities, that is, find values within a list recursively. `list.search()` handles a variety of search demands. The following is the definition of this function.

```r
list.search(.data, expr, classes = "ANY", n = Inf, unlist = FALSE)
```

Definition of arguments:

- `.data`: the list to be searched
- `expr`: a lambda expression. In the expression, `equal()` is designed for robust logical and fuzzy comparison between two objects.
- `classes`: a character vector of class names that restrict the search. By default, the range is unrestricted by taking value `"ANY"`.
- `n`: an integer indicating the maximum number of results to return.
- `unlist`: should the final result be unlisted?

`list.search()` evaluates an expression (`expr`) recursively along a list (`.data`). 

If the expression results in a single-valued logical vector and its value is `TRUE`, the whole vector will be collected If it results in multi-valued or non-logical vector, the non-`NA` values resulted from the expression will be collected. 

To search whole vectors that meet certain condition, specify the expression that returns a single logical value. 

To search the specific values within the vectors, use subsetting in the expression, that is, `.[cond]` or lambda expression like `x ~ x[cond]` where `cond` is a logical vector used to select the elements in the vector.

## Exact search

Exact search is to find values only by logical examinations. Suppose we search the following list.


```r
x <- list(p1 = list(type="A",score=c(c1=9)),
  p2 = list(type=c("A","B"),score=c(c1=8,c2=9)),
  p3 = list(type=c("B","C"),score=c(c1=9,c2=7)),
  p4 = list(type=c("B","C"),score=c(c1=8,c2=NA)))
```

### Search exact values

First, we search all values in the list that is exactly identical to "A".


```r
list.search(x, equal("A",exactly = TRUE))
```

```
# $p1
# $p1$type
# [1] "A"
```

Only values that are identical to character vector `"A"` will be put in the resulting list. We can also unlist the result.


```r
list.search(x, equal("A",exactly = TRUE), unlist = TRUE)
```

```
# p1.type 
#     "A"
```

Then, we search all values identical to `c("A","B")`.


```r
list.search(x, equal(c("A","B"), exactly = TRUE))
```

```
# $p2
# $p2$type
# [1] "A" "B"
```

Next, we search values exactly identical to numeric vector `c(9,7)`.


```r
list.search(x, equal(c(9,7),exactly = TRUE))
```

```
# named list()
```

The result is none. If you are familiar with how function `identical` works, you should not feel surprised since this may be the strongest comparer to tell whether two objects are the same: Two objects are identical when and only when they have absolutely the same structure including values and names. And `exact()` is a wrapper function of `identical()`. That explains why there is no numeric vector exactly identical to `c(9,7)` because all numeric vectors in `x` also have names `c1` and `c2`.

To compare values between atomic vectors just like using `==`, we can use `equal` as comparer function, which only compare vectors with the same mode and equal length.

### Seach equal values

Search length-1 numeric vectors equal to 9.


```r
list.search(x, equal(9))
```

```
# $p1
# $p1$score
# c1 
#  9
```

Search length-2 numeric vectors all values equal to `c(8,9)` respectively.


```r
list.search(x, all(equal(c(8,9))))
```

```
# $p2
# $p2$score
# c1 c2 
#  8  9
```

Search length-2 numeric vectors all equal to `c(8,9)` ignoring `NA`.


```r
list.search(x, all(equal(c(8,9)), na.rm = TRUE))
```

```
# $p2
# $p2$score
# c1 c2 
#  8  9 
# 
# 
# $p4
# $p4$score
# c1 c2 
#  8 NA
```

Search length-1 character vectors equal to "A".


```r
list.search(x, equal("A"))
```

```
# $p1
# $p1$type
# [1] "A"
```

Search length-1 numeric vectors equal to 8.


```r
list.search(x, equal(8))
```

```
# named list()
```

Search length-2 numeric vectors `c(x,y)` for which any correspondent values are equal, that is, `any(c(x,y)==c(8,9))` is `TRUE`.


```r
list.search(x, any(equal(c(8,9))))
```

```
# $p2
# $p2$score
# c1 c2 
#  8  9 
# 
# 
# $p4
# $p4$score
# c1 c2 
#  8 NA
```

Search all numeric vectors in which both 8 and 9 are included.


```r
list.search(x, all(equal(c(8,9),include = TRUE)))
```

```
# $p2
# $p2$score
# c1 c2 
#  8  9
```

Search all numeric vectors in which any of 7, 8, or 10 is included.


```r
list.search(x, any(equal(c(7,8,10),include = TRUE)))
```

```
# $p2
# $p2$score
# c1 c2 
#  8  9 
# 
# 
# $p3
# $p3$score
# c1 c2 
#  9  7 
# 
# 
# $p4
# $p4$score
# c1 c2 
#  8 NA
```

## Fuzzy search

The comparison is flexible enough to support fuzzy searching using functions provided by [`stringdist`](http://cran.r-project.org/web/packages/stringdist/index.html) package. Consider the following list.


```r
x <- list(
    p1 = list(name="Ken",age=24),
    p2 = list(name="Kent",age=26),
    p3 = list(name="Sam",age=24),
    p4 = list(name="Keynes",age=30),
    p5 = list(name="Kwen",age=31))
```

rlist's built-in function `equal()` calls `stringdist::stringdist` internally to handle fuzzy search demands when `dist =` is given a numeric value. It tells whether the difference between two strings is no greater than a given value. Here are some examples for the function.


```r
equal("a","b",dist = 1)
```

```
# [1] TRUE
```

This is true because, basically speaking, "a" can be transformed to "b" in no more than 1 elementary steps in terms of [restricted Damerau-Levenshtein distance](http://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance).


```r
equal("a","hello",dist = 1)
```

```
# [1] FALSE
```

If you prefer other distance measure, you can specify `method=` argument. All possible values are listed in the documentation of `stringdist` package.


```r
equal("a","hello",dist = 4, method = "dl")
```

```
# [1] FALSE
```

For example, if we want to find out names similar with `"ken"` with maximum distance 1, we can write like


```r
list.search(x, equal("ken", dist = 1), "character", unlist = TRUE)
```

```
# p1.name 
#   "Ken"
```

Argument `y` of `equal()` is not explicitly specified but it can automatically take the current value in examination in `list.search()`. Note that we specify `classes = "character"` because `like` will coarse all values to character values, which can be verified by


```r
equal(12345,"1234",dist = 1)
```

```
# [1] TRUE
```

If the distance constraint is too tight, set a greater value.


```r
list.search(x, equal("ken", dist = 2), "character", unlist = TRUE)
```

```
# p1.name p2.name p5.name 
#   "Ken"  "Kent"  "Kwen"
```

Suppose we are working with the following data in which names becomes length-2 character vectors.


```r
x <- list(
    p1 = list(name=c("Ken", "Ren"),age=24),
    p2 = list(name=c("Kent", "Potter"),age=26),
    p3 = list(name=c("Sam", "Lee"),age=24),
    p4 = list(name=c("Keynes", "Bond"),age=30),
    p5 = list(name=c("Kwen", "Hu"),age=31))
```

Search all character vectors in which any element is like "Ken" within string distance 1.


```r
list.search(x, any(equal("Ken", dist = 1)), "character")
```

```
# $p1
# $p1$name
# [1] "Ken" "Ren"
# 
# 
# $p2
# $p2$name
# [1] "Kent"   "Potter"
# 
# 
# $p5
# $p5$name
# [1] "Kwen" "Hu"
```

Search all character vectors in which all elements are unlike "Ken" due to string distance no less than 2.


```r
list.search(x, all(!equal("Ken", dist = 2)), "character")
```

```
# $p4
# $p4$name
# [1] "Keynes" "Bond"
```

Search all character vectors `c(x,y)` like `c("Ken","Hu")` with both string distances no greater than 2, that is, the distances between `x` and "Ken" as well as that between `y` and "Hu" should be no greater than 2.


```r
list.search(x, all(equal(c("Ken","Hu"), dist = 2)), "character")
```

```
# $p5
# $p5$name
# [1] "Kwen" "Hu"
```

Search the terms in the character vectors like `Ken` with distance 1 and single out the values alike.


```r
list.search(x, .[equal("Ken", dist = 1)], "character")
```

```
# $p1
# $p1$name
# [1] "Ken" "Ren"
# 
# 
# $p2
# $p2$name
# [1] "Kent"
# 
# 
# $p5
# $p5$name
# [1] "Kwen"
```

Only values like "Ken" are returned.


## Fuzzy filtering

The fuzzy search functions also work with filtering functions.

Consider the following data.


```r
x <- list(
    p1 = list(name=c("Ken", "Ren"),age=24),
    p2 = list(name=c("Kent", "Potter"),age=26),
    p3 = list(name=c("Sam", "Lee"),age=24),
    p4 = list(name=c("Keynes", "Bond"),age=30),
    p5 = list(name=c("Kwen", "Hu"),age=31))
```

We can also use fuzzy search compares with `list.filter`. For example, filter all list members whose `name` has any character value like `Ken` with maximum distance 1, and output their pasted names as a named character vector. Here we use pipeline.


```r
library(pipeR)
x %>>%
  list.filter(any(equal("Ken",name,dist = 1))) %>>%
  list.mapv(paste(name,collapse = " "))
```

```
#            p1            p2            p5 
#     "Ken Ren" "Kent Potter"     "Kwen Hu"
```

