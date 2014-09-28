

# Grouping

rlist supports multiple types of grouping. 

First, we load the sample data.


```r
library(rlist)
library(pipeR)
people <- list.load("http://renkun.me/rlist-tutorial/data/sample.json")
```

## list.group

`list.group()` is used to classify the list members into different groups by evaluating a given expression and see what value it takes. The expression often produces a scalar value such as a logical value, a character value, and a number. Each group denotes a unique value that expression takes for at least one list member, and all members are put into one and only one group.

We divide all elements into groups by their ages:


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

The result is another list whose first-level elements are the groups whose elements are exactly those who belong to the group.

To get the names of people in each group, we can map each group to the names in it.


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

The mapping runs at the first-level, that is, for each group. The maper expression `. %>>% list.mapv(Name)` means that each group maps to the names of the people in it.

The same logic allows us to do another grouping by the number of Interestss and then to see their names.


```r
people %>>%
  list.group(length(Interests)) %>>%
  list.map(. %>>% list.mapv(Name))
```

```
# $`3`
# [1] "Ken"
# 
# $`2`
# [1] "James" "Penny"
```

## list.ungroup

`list.group()` produces a nested list in which the first level are groups and the second level are the original list members put into different groups. 

`list.ungroup()` reverts this process, or eradicate the group level of a list.


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

In non-relational data structures, a field can be a vector of multiple values. `list.cases()` is used to find out all possible cases by evaluating a vector-value expression for each list member.

In data `people`, field `Interestss` is usually a character vector of multiple values. The following code will find out all possible Interestss for all list members.


```r
list.cases(people, Interests)
```

```
# [1] "movies"  "music"   "reading" "sports"
```

Or use similar code to find out all programming Expertiseuages the developers use.


```r
list.cases(people, names(Expertise))
```

```
# [1] "Cpp"    "CSharp" "Java"   "Python" "R"
```

## list.class

To group by cases, use `list.class` function. This function basically classify all list members case by case. Therefore, a long and nested list will be produces, in which the first-level denotes all the cases, and the second-level includes the original list members.

Note that each list member may belong to multiple cases, therefore the classification of the cases for each member is not exclusive. You may find one list member belong to multiple cases in the resulted list.

Case classification by `Interests`:


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

Get the people's names in each class.


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

Another example is case classification by the programming languages people use:


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

This function returns the common cases by evaluting a given expression for all list members.

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

`table()` is often used to create a table with multiple dimensions. `list.table()` is its counterpart that creates a table in which each dimension results from an expression.


```r
list.table(people, Interests=length(Interests), Age)
```

```
#          Age
# Interests 24 25
#         2  1  1
#         3  1  0
```
