

# Sorting

rlist package provides functions for sorting list elements by a series of criteria.


```r
library(rlist)
library(pipeR)
people <- list.load("https://renkun-ken.github.io/rlist-tutorial/data/sample.json")
```

## list.order

`list.order()` evaluates the given lambda expressions and find out the order by default ascending. If the values for some members tie, the next values of the next expression, if any, will count.

To get the order in descending, use `()` to enclose the expression or simply write a minus operator (`-`) before the expression if its value is numeric.

Get the order of people by Age in ascending order.


```r
list.order(people, Age)
```

```
# [1] 1 3 2
```

Get the order of people by number of interests in ascending order.


```r
list.order(people, length(Interests))
```

```
# [1] 2 3 1
```

Get the order of people by the number of years using R in *descending* order.


```r
list.order(people, (Expertise$R))
```

```
# [1] 2 1 3
```

Get the order of people by the maximal number of years using a programming language in ascending order.


```r
list.order(people, max(unlist(Expertise)))
```

```
# [1] 1 3 2
```

Get the order of people by the number of interests in descending order. If two people have the same number of interests, then the one who has been using R for more years should rank higher, thus ordering by R descending.


```r
list.order(people, (length(Interests)), (Expertise$R))
```

```
# [1] 1 2 3
```

## list.sort

`list.sort()` produces a sorted list of the original list members. Its usage is exactly the same as `list.order()`.


```r
people %>>%
  list.sort(Age) %>>%
  list.select(Name, Age) %>>%
  str
```

```
# List of 3
#  $ :List of 2
#   ..$ Name: chr "Ken"
#   ..$ Age : int 24
#  $ :List of 2
#   ..$ Name: chr "Penny"
#   ..$ Age : int 24
#  $ :List of 2
#   ..$ Name: chr "James"
#   ..$ Age : int 25
```

```r
people %>>%
  list.sort(length(Interests)) %>>%
  list.select(Name, nint = length(Interests)) %>>%
  str
```

```
# List of 3
#  $ :List of 2
#   ..$ Name: chr "James"
#   ..$ nint: int 2
#  $ :List of 2
#   ..$ Name: chr "Penny"
#   ..$ nint: int 2
#  $ :List of 2
#   ..$ Name: chr "Ken"
#   ..$ nint: int 3
```

```r
people %>>%
  list.sort((Expertise$R)) %>>%
  list.select(Name, R = Expertise$R) %>>%
  str
```

```
# List of 3
#  $ :List of 2
#   ..$ Name: chr "James"
#   ..$ R   : int 3
#  $ :List of 2
#   ..$ Name: chr "Ken"
#   ..$ R   : int 2
#  $ :List of 2
#   ..$ Name: chr "Penny"
#   ..$ R   : int 1
```

```r
people %>>%
  list.sort(max(unlist(Expertise))) %>>%
  list.mapv(Name)
```

```
# [1] "Ken"   "Penny" "James"
```

```r
people %>>%
  list.sort((length(Interests)), (Expertise$R)) %>>%
  list.select(Name, nint = length(Interests), R = Expertise$R) %>>%
  str
```

```
# List of 3
#  $ :List of 3
#   ..$ Name: chr "Ken"
#   ..$ nint: int 3
#   ..$ R   : int 2
#  $ :List of 3
#   ..$ Name: chr "James"
#   ..$ nint: int 2
#   ..$ R   : int 3
#  $ :List of 3
#   ..$ Name: chr "Penny"
#   ..$ nint: int 2
#   ..$ R   : int 1
```
