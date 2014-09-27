

# Mapping

Suppose we load the [data](../data/sample.json) represented by the following table:

| Name | Age | Interests | Expertise |
|------|-----|----------|----------|
| Ken | 24 | reading, music, movies | R:2, C#:4, Python:3 |
| James | 25 | sports, music | R:3, Java:2, C++:5 |
| Penny | 24 | movies, reading | R:1, C++:4, Python:2 |


```r
library(rlist)
people <- list.load("http://renkun.me/rlist-tutorial/data/sample.json")
str(people)
```

```
# List of 3
#  $ :List of 4
#   ..$ Name     : chr "Ken"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:3] "reading" "music" "movies"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 2
#   .. ..$ CSharp: int 4
#   .. ..$ Python: int 3
#  $ :List of 4
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 3
#   .. ..$ R   : int 3
#   .. ..$ Java: int 2
#   .. ..$ Cpp : int 5
#  $ :List of 4
#   ..$ Name     : chr "Penny"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:2] "movies" "reading"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 1
#   .. ..$ Cpp   : int 4
#   .. ..$ Python: int 2
```

To extract the name of each people (list element), traditionally we can we `lapply()` like the following:


```r
people_names <- lapply(people, function(x) {
  x$Name
})
str(people_names)
```

```
# List of 3
#  $ : chr "Ken"
#  $ : chr "James"
#  $ : chr "Penny"
```

`str()` shows the structure of the list. We use it here particularly to shorten the results to show.

Using rlist's `list.map()` the task is made extremely easy:


```r
list.map(people, Name)
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

List mapping is to evaluate an expression for each list member. It is the fundamental operation in rlist functionality. Almost all functions in this package that work with expressions are using mapping but in different ways. The following examples demonstrate several types of mapping in more details.

## list.map

The simplest way of mapping is provided by `list.map()` as we have just demonstrated. Basically, it evaluates an expression for each list member. 

The function makes it easier to query a list by putting all fields of the list member in mapping to the environment where the expression is evaluated. In other words, the expression is evaluated in the context of one list member each time.

For example, the following code maps each list member in `people` by expression `age`. Therefore, it results in a list where each item becomes the value of that expression for each member of `people`.


```r
list.map(people, Age)
```

```
# [[1]]
# [1] 24
# 
# [[2]]
# [1] 25
# 
# [[3]]
# [1] 24
```

Since the expression does not have to be a field name of the list member, we can evaluate whatever we want in the context of a list member.

The following code maps each list member to the sum of years of they use the programming languages they know.


```r
list.map(people, sum(as.numeric(Expertise)))
```

```
# [[1]]
# [1] 9
# 
# [[2]]
# [1] 10
# 
# [[3]]
# [1] 7
```

If we need more than one values for each member, we can evaluate a vector or list expression.

The following code maps each list member to a new list of his or her age and range of number of years using a programming language.


```r
list.map(people, list(age=Age, range=range(as.numeric(Expertise))))
```

```
# [[1]]
# [[1]]$age
# [1] 24
# 
# [[1]]$range
# [1] 2 4
# 
# 
# [[2]]
# [[2]]$age
# [1] 25
# 
# [[2]]$range
# [1] 2 5
# 
# 
# [[3]]
# [[3]]$age
# [1] 24
# 
# [[3]]$range
# [1] 1 4
```

## list.mapv

If we want to get the mapping results as a vector rather than a list, we can use `list.mapv()`, which basically calls `unlist()` to the list resulted from `list.map()`.


```r
list.mapv(people, Age)
```

```
# [1] 24 25 24
```

```r
list.mapv(people, sum(as.numeric(Expertise)))
```

```
# [1]  9 10  7
```

## list.select

In contrast to `list.map()`, `list.select()` provides an easier way to map each list member to a new list. This functions basically evaluates all given expressions and put the results into a list.

If a field name a list member is selected, its name will automatically preserved. If a list item evaluated from other expression is selected, we may better give it a name, or otherwise it will only have an index.


```r
list.select(people, Name, Age)
```

```
# [[1]]
# [[1]]$Name
# [1] "Ken"
# 
# [[1]]$Age
# [1] 24
# 
# 
# [[2]]
# [[2]]$Name
# [1] "James"
# 
# [[2]]$Age
# [1] 25
# 
# 
# [[3]]
# [[3]]$Name
# [1] "Penny"
# 
# [[3]]$Age
# [1] 24
```

```r
list.select(people, Name, Age, nlang=length(Expertise))
```

```
# [[1]]
# [[1]]$Name
# [1] "Ken"
# 
# [[1]]$Age
# [1] 24
# 
# [[1]]$nlang
# [1] 3
# 
# 
# [[2]]
# [[2]]$Name
# [1] "James"
# 
# [[2]]$Age
# [1] 25
# 
# [[2]]$nlang
# [1] 3
# 
# 
# [[3]]
# [[3]]$Name
# [1] "Penny"
# 
# [[3]]$Age
# [1] 24
# 
# [[3]]$nlang
# [1] 3
```

## list.iter

Sometimes we don't really need the result of a mapping but its side effects. For example, if we only need to print out something about each list member, we don't need to carry on the output of mapping.

`list.iter` performs iterations over a list and returns nothing.


```r
list.iter(people, cat(Name, ":", Age, "\n"))
```

```
# Ken : 24 
# James : 25 
# Penny : 24
```

## list.maps

All the previous functions work with a single list. There are scenarios where mapping multiple lists is needed. `list.maps()` evaluates an expression with multiple lists each of which is represented by a user-defined symbol at the function call.


```r
l1 <- list(p1=list(x=1,y=2), p2=list(x=3,y=4), p3=list(x=1,y=3))
l2 <- list(2, 3, 5)
list.maps(a$x*b+a$y, a=l1, b=l2)
```

```
# $p1
# [1] 4
# 
# $p2
# [1] 13
# 
# $p3
# [1] 8
```

`list.maps` does not follow the conventions of many other functions like `list.map` and `list.iter` where the data comes first and expression comes the second. Since `list.maps` supports multi-mapping with a group of lists, only implicit lambda expression is supported to avoid ambiguity. After that the function still allows users to define the symbol that represents each list being mapped in the `...`.

In the example above, `...` means `a = l1, b = l2`, so that `a` and `b` are meaningful in the first expression `a$x*b+a$y` where `a` and `b` mean the current element of each list, respectively.
