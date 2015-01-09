

# Grouping

rlist supports multiple types of grouping. 

First, we load the sample data.


```r
library(rlist)
library(pipeR)
people <- list.load("http://renkun.me/rlist-tutorial/data/sample.json")
```

## list.group

`list.group()` is used to put list elements into subgroups by evaluating an expression. The expression often produces a scalar value such as a logical value, a character value, or a number. Each group denotes a unique value that expression takes for at least one list element, and all elements are put into one and only one group.

Divide numbers from 1 to 10 into even and odd numbers.


```r
list.group(1:10, . %% 2 == 0)
```

```
# $`FALSE`
# [1] 1 3 5 7 9
# 
# $`TRUE`
# [1]  2  4  6  8 10
```

The result is a list of two elements, which are the two possible outcome of evaluating `. %% 2 == 0L` given each number in `1:10`. `FALSE` group contains all odd numbers in `1:10` and `TRUE` group contains all even numbers in `1:10`. 

This simple example demonstrates that the result of `list.group()` is always a list containing sublists with names of all possible outcomes, and the value of each sub-list is a subset of the original data in which each element evaluates the grouping expression to the same value.

With the same logic, we can divide all elements in `people` into groups by their ages:


```r
str(list.group(people, Age))
```

```
# List of 2
#  $ 24:List of 2
#   ..$ :List of 4
#   .. ..$ Name     : chr "Ken"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:3] "reading" "music" "movies"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 2
#   .. .. ..$ CSharp: int 4
#   .. .. ..$ Python: int 3
#   ..$ :List of 4
#   .. ..$ Name     : chr "Penny"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:2] "movies" "reading"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 1
#   .. .. ..$ Cpp   : int 4
#   .. .. ..$ Python: int 2
#  $ 25:List of 1
#   ..$ :List of 4
#   .. ..$ Name     : chr "James"
#   .. ..$ Age      : int 25
#   .. ..$ Interests: chr [1:2] "sports" "music"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R   : int 3
#   .. .. ..$ Java: int 2
#   .. .. ..$ Cpp : int 5
```

The result is another list whose first-level elements are the groups and the elements in each group are exactly the elements that belong to the group.

Since the grouped result is also a list, we can always use rlist functions on the sublists as groups. Therefore, to get the names of people in each group, we can map each group to the names in it.


```r
people %>>%
  list.group(Age) %>>%
  list.map(. %>>% list.mapv(Name))
```

```
# $`24`
# [1] "Ken"   "Penny"
# 
# $`25`
# [1] "James"
```

The mapping runs at the first-level, that is, for each group. The mapper expression `. %>>% list.mapv(Name)` means that each people in the group maps to the name.

The same logic allows us to do another grouping by the number of Interests and then to see their names.


```r
people %>>%
  list.group(length(Interests)) %>>%
  list.map(. %>>% list.mapv(Name))
```

```
# $`2`
# [1] "James" "Penny"
# 
# $`3`
# [1] "Ken"
```

## list.ungroup

`list.group()` produces a nested list in which the first level are groups and the second level are the original list elements put into different groups. 

`list.ungroup()` reverts this process. In other words, the function eradicates the group level of a list.


```r
ageGroups <- list.group(people, Age)
str(list.ungroup(ageGroups))
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
#   ..$ Name     : chr "Penny"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:2] "movies" "reading"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 1
#   .. ..$ Cpp   : int 4
#   .. ..$ Python: int 2
#  $ :List of 4
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 3
#   .. ..$ R   : int 3
#   .. ..$ Java: int 2
#   .. ..$ Cpp : int 5
```

## list.cases

In non-relational data structures, a field can be a vector of multiple values. `list.cases()` is used to find out all possible cases by evaluating a vector-valued expression for each list element.

In data `people`, field `Interests` is usually a character vector of multiple values. The following code will find out all possible Interests for all list elements.


```r
list.cases(people, Interests)
```

```
# [1] "movies"  "music"   "reading" "sports"
```

Or use similar code to find out all programming Expertise the developers use.


```r
list.cases(people, names(Expertise))
```

```
# [1] "Cpp"    "CSharp" "Java"   "Python" "R"
```

## list.class

`list.class()` groups list elements by cases, that is, it categorizes them by examining if the value of a given expression for each list element *inlcudes* the case. As a result, the function produces a long and nested list in which the first-level denotes all the cases, and the second-level includes the original list elements.

Since each list element may belong to multiple cases, the classification of the cases for each element is not exclusive. You may find one list element belong to multiple cases in the resulted list.

If the expression is itself single-valued and thus exclusive, then the result is the same with that produced by `list.group()`. For example,


```r
1:10 %>>%
  list.class(. %% 2 == 0)
```

```
# $`FALSE`
# [1] 1 3 5 7 9
# 
# $`TRUE`
# [1]  2  4  6  8 10
```

If the value of the expression is not single-valued, then `list.class()` and `list.group()` behaves differently. For example, we perform case classification by `Interests`:


```r
str(list.class(people, Interests))
```

```
# List of 4
#  $ movies :List of 2
#   ..$ :List of 4
#   .. ..$ Name     : chr "Ken"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:3] "reading" "music" "movies"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 2
#   .. .. ..$ CSharp: int 4
#   .. .. ..$ Python: int 3
#   ..$ :List of 4
#   .. ..$ Name     : chr "Penny"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:2] "movies" "reading"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 1
#   .. .. ..$ Cpp   : int 4
#   .. .. ..$ Python: int 2
#  $ music  :List of 2
#   ..$ :List of 4
#   .. ..$ Name     : chr "Ken"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:3] "reading" "music" "movies"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 2
#   .. .. ..$ CSharp: int 4
#   .. .. ..$ Python: int 3
#   ..$ :List of 4
#   .. ..$ Name     : chr "James"
#   .. ..$ Age      : int 25
#   .. ..$ Interests: chr [1:2] "sports" "music"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R   : int 3
#   .. .. ..$ Java: int 2
#   .. .. ..$ Cpp : int 5
#  $ reading:List of 2
#   ..$ :List of 4
#   .. ..$ Name     : chr "Ken"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:3] "reading" "music" "movies"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 2
#   .. .. ..$ CSharp: int 4
#   .. .. ..$ Python: int 3
#   ..$ :List of 4
#   .. ..$ Name     : chr "Penny"
#   .. ..$ Age      : int 24
#   .. ..$ Interests: chr [1:2] "movies" "reading"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R     : int 1
#   .. .. ..$ Cpp   : int 4
#   .. .. ..$ Python: int 2
#  $ sports :List of 1
#   ..$ :List of 4
#   .. ..$ Name     : chr "James"
#   .. ..$ Age      : int 25
#   .. ..$ Interests: chr [1:2] "sports" "music"
#   .. ..$ Expertise:List of 3
#   .. .. ..$ R   : int 3
#   .. .. ..$ Java: int 2
#   .. .. ..$ Cpp : int 5
```

We get a list containing sub-lists named by all possible interests, and each sub-lists contains all list elements that whose interests *include* the corresponding interest.

Similar to building nested pipelines in `list.group()` examples, we can get the people's names in each class.


```r
people %>>%
  list.class(Interests) %>>%
  list.map(. %>>% list.mapv(Name))
```

```
# $movies
# [1] "Ken"   "Penny"
# 
# $music
# [1] "Ken"   "James"
# 
# $reading
# [1] "Ken"   "Penny"
# 
# $sports
# [1] "James"
```

The exactly same logic also applies when we want to know the people's names classified by the name of programming languages as expertise:


```r
people %>>%
  list.class(names(Expertise)) %>>%
  list.map(. %>>% list.mapv(Name))
```

```
# $Cpp
# [1] "James" "Penny"
# 
# $CSharp
# [1] "Ken"
# 
# $Java
# [1] "James"
# 
# $Python
# [1] "Ken"   "Penny"
# 
# $R
# [1] "Ken"   "James" "Penny"
```

## list.common

This function returns the common cases by evaluating a given expression for all list elements.

Get the common Interests of all developers.


```r
list.common(people, Interests)
```

```
# character(0)
```

It concludes that no interests are common to every one. Let's see if there is any common programming language they all use.


```r
list.common(people, names(Expertise))
```

```
# [1] "R"
```

## list.table

`table()` builds a contingency table of the counts at each combination of factor levels using cross-classifying factors. `list.table()` is a wrapper that creates a table in which each dimension results from the values for an expression.

The function is very handy to serve as a counter. The following examples shows an easy way to know the remainders and the number of integers from 1 to 1000 when each is divided by 3.


```r
list.table(1:1000, . %% 3)
```

```
# 
#   0   1   2 
# 333 334 333
```

For `people` dataset, we can build a two-dimensional table to show the distribution of number of interests and age.


```r
list.table(people, Interests=length(Interests), Age)
```

```
#          Age
# Interests 24 25
#         2  1  1
#         3  1  0
```
