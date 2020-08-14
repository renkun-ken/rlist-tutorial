

# Joining

`list.join()` joins two lists by certain expressions and `list.merge()` merges a series of named lists.


```r
library(rlist)
library(pipeR)
people <- list.load("https://renkun-ken.github.io/rlist-tutorial/data/sample.json") %>>%
  list.names(Name)
```


## list.join

`list.join()` is used to join two lists by a key evaluated from either a common expression for the two lists or two separate expressions for each list.


```r
newinfo <-
  list(
    list(Name="Ken", Email="ken@xyz.com"),
    list(Name="Penny", Email="penny@xyz.com"),
    list(Name="James", Email="james@xyz.com"))
str(list.join(people, newinfo, Name))
```

```
# List of 3
#  $ Ken  :List of 5
#   ..$ Name     : chr "Ken"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:3] "reading" "music" "movies"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 2
#   .. ..$ CSharp: int 4
#   .. ..$ Python: int 3
#   ..$ Email    : chr "ken@xyz.com"
#  $ James:List of 5
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 3
#   .. ..$ R   : int 3
#   .. ..$ Java: int 2
#   .. ..$ Cpp : int 5
#   ..$ Email    : chr "james@xyz.com"
#  $ Penny:List of 5
#   ..$ Name     : chr "Penny"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:2] "movies" "reading"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 1
#   .. ..$ Cpp   : int 4
#   .. ..$ Python: int 2
#   ..$ Email    : chr "penny@xyz.com"
```

## list.merge

`list.merge()` is used to recursively merge a series of lists with the later always updates the former. It works with two lists, as shown in the example below, in which a revision is merged with the original list.

More specifically, the merge works in a way that lists are partially updated, which allows us to specify only the fields we want to update or add for a list element, or use `NULL` to remove a field.


```r
rev1 <-
  list(
    Ken = list(Age=25),
    James = list(Expertise = list(R=2, Cpp=4)),
    Penny = list(Expertise = list(R=2, Python=NULL)))
str(list.merge(people,rev1))
```

```
# List of 3
#  $ Ken  :List of 4
#   ..$ Name     : chr "Ken"
#   ..$ Age      : num 25
#   ..$ Interests: chr [1:3] "reading" "music" "movies"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 2
#   .. ..$ CSharp: int 4
#   .. ..$ Python: int 3
#  $ James:List of 4
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 3
#   .. ..$ R   : num 2
#   .. ..$ Java: int 2
#   .. ..$ Cpp : num 4
#  $ Penny:List of 4
#   ..$ Name     : chr "Penny"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:2] "movies" "reading"
#   ..$ Expertise:List of 2
#   .. ..$ R  : num 2
#   .. ..$ Cpp: int 4
```

The function also works with multiple lists. When the second revision is obtained, the three lists can be merged in order.


```r
rev2 <-
  list(
    James = list(Expertise=list(CSharp = 5)),
    Penny = list(Age = 24,Expertise=list(R = 3)))
str(list.merge(people,rev1, rev2))
```

```
# List of 3
#  $ Ken  :List of 4
#   ..$ Name     : chr "Ken"
#   ..$ Age      : num 25
#   ..$ Interests: chr [1:3] "reading" "music" "movies"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 2
#   .. ..$ CSharp: int 4
#   .. ..$ Python: int 3
#  $ James:List of 4
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 4
#   .. ..$ R     : num 2
#   .. ..$ Java  : int 2
#   .. ..$ Cpp   : num 4
#   .. ..$ CSharp: num 5
#  $ Penny:List of 4
#   ..$ Name     : chr "Penny"
#   ..$ Age      : num 24
#   ..$ Interests: chr [1:2] "movies" "reading"
#   ..$ Expertise:List of 2
#   .. ..$ R  : num 3
#   .. ..$ Cpp: int 4
```

Note that `list.merge()` only works with lists with names; otherwise the merging function will not know the correspondence between the list elements to merge.
