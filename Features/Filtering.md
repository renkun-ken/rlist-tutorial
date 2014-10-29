

# Filtering

List filtering is to select list elements by given criteria. In rlist package, more than ten functions are related with list filtering. Basically, they all perform mapping first but then aggregate the results in different ways.

First, we load the sample data.


```r
library(rlist)
people <- list.load("http://renkun.me/rlist-tutorial/data/sample.json")
```

## list.filter

`list.filter()` filters a list by an expression that returns `TRUE` or `FALSE`. The results only contain the list elements for which the value of that expression turns out to be `TRUE`.

Different from list mapping which evaluates an expression given each list element, list filtering evaluates an expression to decide whether to include *the entire element* in the results.


```r
str(list.filter(people, Age >= 25))
```

```
# List of 1
#  $ :List of 4
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 3
#   .. ..$ R   : int 3
#   .. ..$ Java: int 2
#   .. ..$ Cpp : int 5
```

Note that `list.filter()` filters the data with given conditions and the list elements that satisfy the conditions will be returned. We call `str()` on the results to shorten the output.

Using pipeline, we can first filter the data and then map the resulted elements by expression. For example, we can get the names of those whose age is no less than 25.


```r
library(pipeR)
people %>>%
  list.filter(Age >= 25) %>>%
  list.mapv(Name)
```

```
# [1] "James"
```

If one has to write the code in traditional approach, it can be 

```r
list.mapv(list.filter(people, Age >= 25), Name)
```

or 

```r
people_filtered <- list.filter(people, Age >= 25)
list.mapv(people_filtered, Name)
```

It is obvious that both versions are quite redundant. Therefore, we will heavily use pipeline in the demonstration the features from now on to make the data processing look more elegant, and reduce the amount of information in the output.

Similarly, we can also get the names of those who are interested in music.


```r
people %>>%
  list.filter("music" %in% Interests) %>>%
  list.mapv(Name)
```

```
# [1] "Ken"   "James"
```

We can get the names of those who have been using programming languages for at least three years on average.


```r
people %>>%
  list.filter(mean(as.numeric(Expertise)) >= 3) %>>%
  list.mapv(Name)
```

```
# [1] "Ken"   "James"
```

Meta-symbols like `.`, `.i`, and `.name` can also be used. The following code will pick up the list element whose index is even.


```r
people %>>%
  list.filter(.i %% 2 == 0) %>>%
  list.mapv(Name)
```

```
# [1] "James"
```

## list.find

In some cases, we don't need to find all the instances given the criteria. Rather, we only need to find a few, sometimes only one. `list.find()` avoids searching across all list element but stops at a specific number of items found.


```r
people %>>%
  list.find(Age >= 25, 1) %>>%
  list.mapv(Name)
```

```
# [1] "James"
```

## list.findi

Similar with `list.find()`, `list.findi()` only returns the index of the elements found.


```r
list.findi(people, Age >= 23, 2)
```

```
# [1] 1 2
```

You may verify that if the number of instances to find is greater than the actual number of instances in the data, all qualified instances will be returned.

## list.first, list.last

`list.first()` and `list.last()` are used to find the first and last element that meets certain condition if specified, respectively.


```r
str(list.first(people, Age >= 23))
```

```
# List of 4
#  $ Name     : chr "Ken"
#  $ Age      : int 24
#  $ Interests: chr [1:3] "reading" "music" "movies"
#  $ Expertise:List of 3
#   ..$ R     : int 2
#   ..$ CSharp: int 4
#   ..$ Python: int 3
```


```r
str(list.last(people, Age >= 23))
```

```
# List of 4
#  $ Name     : chr "Penny"
#  $ Age      : int 24
#  $ Interests: chr [1:2] "movies" "reading"
#  $ Expertise:List of 3
#   ..$ R     : int 1
#   ..$ Cpp   : int 4
#   ..$ Python: int 2
```

These two functions also works when the condition is missing. In this case, they simply take out the first/last element from the list or vector.


```r
list.first(1:10)
```

```
# [1] 1
```

```r
list.last(1:10)
```

```
# [1] 10
```

## list.take

`list.take()` takes at most a given number of elements from a list. If the number is even larger than the length of the list, the function will by default return all elements in the list.


```r
list.take(1:10, 3)
```

```
# [1] 1 2 3
```

```r
list.take(1:5, 8)
```

```
# [1] 1 2 3 4 5
```

## list.skip

As opposed to `list.take()`, `list.skip()` skips at most a given number of elements in the list and take all the rest as the results. If the number of elements to skip is equal or greater than the length of that list, an empty one will be returned.


```r
list.skip(1:10, 3)
```

```
# [1]  4  5  6  7  8  9 10
```

```r
list.skip(1:5, 8)
```

```
# integer(0)
```

## list.takeWhile

Similar to `list.take()`, `list.takeWhile()` is also designed to take out some elements from a list but subject to a condition. Basically, it keeps taking elements while a condition holds true.


```r
people %>>%
  list.takeWhile(Expertise$R >= 2) %>>%
  list.map(list(Name = Name, R = Expertise$R)) %>>%
  str
```

```
# List of 2
#  $ :List of 2
#   ..$ Name: chr "Ken"
#   ..$ R   : int 2
#  $ :List of 2
#   ..$ Name: chr "James"
#   ..$ R   : int 3
```

## list.skipWhile

`list.skipWhile()` keeps skipping elements while a condition holds true.


```r
people %>>%
  list.skipWhile(Expertise$R <= 2) %>>%
  list.map(list(Name = Name, R = Expertise$R)) %>>%
  str
```

```
# List of 2
#  $ :List of 2
#   ..$ Name: chr "James"
#   ..$ R   : int 3
#  $ :List of 2
#   ..$ Name: chr "Penny"
#   ..$ R   : int 1
```

## list.is

`list.is()` returns a logical vector that indicates whether a condition holds for each member of a list.


```r
list.is(people, "music" %in% Interests)
```

```
# [1]  TRUE  TRUE FALSE
```

```r
list.is(people, "Java" %in% names(Expertise))
```

```
# [1] FALSE  TRUE FALSE
```

## list.which

`list.which()` returns a integer vector of the indices of the elements of a list that meet a given condition.


```r
list.which(people, "music" %in% Interests)
```

```
# [1] 1 2
```

```r
list.which(people, "Java" %in% names(Expertise))
```

```
# [1] 2
```

## list.all

`list.all()` returns `TRUE` if all the elements of a list satisfy a given condition, or `FALSE` otherwise.


```r
list.all(people, mean(as.numeric(Expertise)) >= 3)
```

```
# [1] FALSE
```

```r
list.all(people, "R" %in% names(Expertise))
```

```
# [1] TRUE
```

## list.any

`list.any()` returns `TRUE` if at least one of the elements of a list satisfies a given condition, or `FALSE` otherwise.


```r
list.any(people, mean(as.numeric(Expertise)) >= 3)
```

```
# [1] TRUE
```

```r
list.any(people, "Python" %in% names(Expertise))
```

```
# [1] TRUE
```

## list.count

`list.count()` return a scalar integer that indicates the number of elements of a list that satisfy a given condition.


```r
list.count(people, mean(as.numeric(Expertise)) >= 3)
```

```
# [1] 2
```

```r
list.count(people, "R" %in% names(Expertise))
```

```
# [1] 3
```

## list.match

`list.match()` filters a list by matching the names of the list elements by a regular expression pattern.


```r
data <- list(p1 = 1, p2 = 2, a1 = 3, a2 = 4)
list.match(data, "p[12]")
```

```
# $p1
# [1] 1
# 
# $p2
# [1] 2
```

## list.remove

`list.remove()` removes list elements by index or name.


```r
list.remove(data, c("p1","p2"))
```

```
# $a1
# [1] 3
# 
# $a2
# [1] 4
```

```r
list.remove(data, c(2,3))
```

```
# $p1
# [1] 1
# 
# $a2
# [1] 4
```

## list.exclude

`list.exclude()` removes list elements that satisfy given condition.


```r
people %>>%
  list.exclude("sports" %in% Interests) %>>%
  list.mapv(Name)
```

```
# [1] "Ken"   "Penny"
```

## list.clean

`list.clean()` is used to clean a list by a function either recursively or not. The function can be built-in function like `is.null()` to remove all `NULL` values from the list, or can be user-defined function like `function(x) length(x) == 0` to remove all empty objects like `NULL`, `character(0L)`, etc.


```r
x <- list(a=1, b=NULL, c=list(x=1,y=NULL,z=logical(0L),w=c(NA,1)))
str(x)
```

```
# List of 3
#  $ a: num 1
#  $ b: NULL
#  $ c:List of 4
#   ..$ x: num 1
#   ..$ y: NULL
#   ..$ z: logi(0) 
#   ..$ w: num [1:2] NA 1
```

To clear all `NULL` values in the list recursively, we can call


```r
str(list.clean(x, recursive = TRUE))
```

```
# List of 2
#  $ a: num 1
#  $ c:List of 3
#   ..$ x: num 1
#   ..$ z: logi(0) 
#   ..$ w: num [1:2] NA 1
```

To remove all empty values including `NULL` and zero-length vectors, we can call


```r
str(list.clean(x, function(x) length(x) == 0L, recursive = TRUE))
```

```
# List of 2
#  $ a: num 1
#  $ c:List of 2
#   ..$ x: num 1
#   ..$ w: num [1:2] NA 1
```

The function can also be related to missing values. For example, exclude all empty values and vectors with at least `NA`s.


```r
str(list.clean(x, function(x) length(x) == 0L || anyNA(x), recursive = TRUE))
```

```
# List of 2
#  $ a: num 1
#  $ c:List of 1
#   ..$ x: num 1
```

## subset

`subset()` is implemented for list object in a way that combines `list.filter()` and `list.map()`. This function basically filters a list while at the same time maps the qualified list elements by an expression.


```r
people %>>%
  subset(Age >= 24, Name)
```

```
# [[1]]
# [1] "Ken"
# 
# [[2]]
# [1] "James"
# 
# [[3]]
# [1] "Penny"
```

```r
people %>>%
  subset("reading" %in% Interests, sum(as.numeric(Expertise)))
```

```
# [[1]]
# [1] 9
# 
# [[2]]
# [1] 7
```
