

# Updating

`list.update()` partially modifies the given list by a number of lists resulted from expressions.


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
