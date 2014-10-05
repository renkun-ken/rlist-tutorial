

# Updating

`list.update()` partially modifies the given list by a number of lists resulted from expressions.

First, we load the data without any modification.


```r
library(rlist)
library(pipeR)
people <- list.load("http://renkun.me/rlist-tutorial/data/sample.json")
people %>>%
  list.select(Name, Age) %>>%
  list.stack
```

```
#    Name Age
# 1   Ken  24
# 2 James  25
# 3 Penny  24
```

`list.stack()` converts a list to a data frame with equivalent structure. We will introduce this function later.

Suppose we find that the age of each people is mistakenly recorded, say, 1 year less than their actual ages, respectively, we need to update the original data by refresh the age of each element.


```r
people %>>%
  list.update(Age = Age + 1) %>>%
  list.select(Name, Age) %>>%
  list.stack
```

```
#    Name Age
# 1   Ken  25
# 2 James  26
# 3 Penny  25
```

`list.update()` can also be used to exclude certain fields of the elements. Once we update the fields we want to exclude to `NULL`, those fields are removed.


```r
people %>>%
  list.update(Interests = NULL, Expertise = NULL, N = length(Expertise)) %>>%
  list.stack
```

```
#    Name Age N
# 1   Ken  24 3
# 2 James  25 3
# 3 Penny  24 3
```
