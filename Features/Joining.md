

# Joining

`list.join()` joins two lists by certain expressions and `list.merge()` merges  a series of lists.


```r
library(rlist)
library(pipeR)
people <- list.load("http://renkun.me/rlist-tutorial/data/sample.json")
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
#  $ :List of 5
#   ..$ Name     : chr "Ken"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:3] "reading" "music" "movies"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 2
#   .. ..$ CSharp: int 4
#   .. ..$ Python: int 3
#   ..$ Email    : chr "ken@xyz.com"
#  $ :List of 5
#   ..$ Name     : chr "James"
#   ..$ Age      : int 25
#   ..$ Interests: chr [1:2] "sports" "music"
#   ..$ Expertise:List of 3
#   .. ..$ R   : int 3
#   .. ..$ Java: int 2
#   .. ..$ Cpp : int 5
#   ..$ Email    : chr "james@xyz.com"
#  $ :List of 5
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

```r
rev1 <-
  list(
    list(Age=25),
    list(Expertise=list(R=2,Cpp=4)),
    list(Expertise=list(R=2,Python=NULL)))
str(list.merge(people,rev1))
```

The function also works with multiple lists. When the second revision is obtained, the three lists can be merged in order.

```r
rev2 <-
  list(
    NULL,
    list(lang=list(csharp=5)),
    list(age=24,lang=list(r=3)))
str(list.merge(people,rev1,rev2))
```
