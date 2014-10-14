

# Misc functions

rlist provides miscellaneous functions to assist data manipulation. These functions are mainly designed to alter the structure of an list object.

## list.append, list.prepend

`list.append()` appends an element to a list and `list.prepend()` prepends an element to a list.


```r
library(rlist)
list.append(list(a=1, b=1), c=1)
```

```
# $a
# [1] 1
# 
# $b
# [1] 1
# 
# $c
# [1] 1
```

```r
list.prepend(list(b=1, c=2), a=0)
```

```
# $a
# [1] 0
# 
# $b
# [1] 1
# 
# $c
# [1] 2
```

The function also works with vector.


```r
list.append(1:3, 4)
```

```
# [1] 1 2 3 4
```

```r
list.prepend(1:3, 0)
```

```
# [1] 0 1 2 3
```

The names of the vector can be well handled.


```r
list.append(c(a=1,b=2), c=3)
```

```
# a b c 
# 1 2 3
```

```r
list.prepend(c(b=2,c=3), a=1)
```

```
# a b c 
# 1 2 3
```

## list.reverse

`list.reverse()` simply reverses a list or vector.


```r
list.reverse(1:10)
```

```
#  [1] 10  9  8  7  6  5  4  3  2  1
```

## list.zip

`list.zip()` combines multiple lists element-wisely. In other words, the function takes the first element from all parameters, and then the second, and so on.


```r
str(list.zip(a=c(1,2,3), b=c(4,5,6)))
```

```
# List of 3
#  $ :List of 2
#   ..$ a: num 1
#   ..$ b: num 4
#  $ :List of 2
#   ..$ a: num 2
#   ..$ b: num 5
#  $ :List of 2
#   ..$ a: num 3
#   ..$ b: num 6
```

The list elements need not be atomic vectors. They can be any lists.


```r
str(list.zip(x=list(1,"x"), y=list("y",2)))
```

```
# List of 2
#  $ :List of 2
#   ..$ x: num 1
#   ..$ y: chr "y"
#  $ :List of 2
#   ..$ x: chr "x"
#   ..$ y: num 2
```

The parameters do not have to be the same type.


```r
str(list.zip(x=c(1,2), y=list("x","y")))
```

```
# List of 2
#  $ :List of 2
#   ..$ x: num 1
#   ..$ y: chr "x"
#  $ :List of 2
#   ..$ x: num 2
#   ..$ y: chr "y"
```

## list.rbind, list.cbind

`list.rbind()` binds atomic vectors by row and `list.cbind()` by column.


```r
scores <- list(score1=c(10,9,10),score2=c(8,9,6),score3=c(9,8,10))
list.rbind(scores)
```

```
#        [,1] [,2] [,3]
# score1   10    9   10
# score2    8    9    6
# score3    9    8   10
```

```r
list.cbind(scores)
```

```
#      score1 score2 score3
# [1,]     10      8      9
# [2,]      9      9      8
# [3,]     10      6     10
```

Note that the two functions finally call `rbind()` and `cbind()`, respectively, which result in matrix or data frame.

If a list of lists are supplied, then a matrix of `list` will be created.


```r
scores2 <- list(score1=list(10,9,10),
  score2=list(8,9,6),type=list("a","b","a"))
rscores2 <- list.rbind(scores2)
rscores2
```

```
#        [,1] [,2] [,3]
# score1 10   9    10  
# score2 8    9    6   
# type   "a"  "b"  "a"
```

`rscores2` is a matrix of *lists* rather than atomic values.


```r
rscores2[1,1]
```

```
# $score1
# [1] 10
```

```r
rscores2[,1]
```

```
# $score1
# [1] 10
# 
# $score2
# [1] 8
# 
# $type
# [1] "a"
```

This is not a common practice and may lead to unexpected mistakes if one is not fully aware of it and take for granted that the extracted value should be an atomic value like a number or string. Therefore, it is not recommended to either `list.rbind()` or `list.cbind()` a list of lists.

## list.stack

To create a `data.frame` from a list of lists, use `list.stack()`. It is particularly useful when we want to transform a non-tabular data to a stage where it actually fits a tabular form.

For example, a list of lists with the same single-entry fields can be transformed to a equivalent data frame.


```r
nontab <- list(list(type="A",score=10),list(type="B",score=9))
list.stack(nontab)
```

```
#   type score
# 1    A    10
# 2    B     9
```

For non-tabular data, we can select fields or columns in the data and *stack* the records together to create a data frame.


```r
library(pipeR)
list.load("http://renkun.me/rlist-tutorial/data/sample.json") %>>%
  list.select(Name, Age) %>>%
  list.stack
```

```
#    Name Age
# 1   Ken  24
# 2 James  25
# 3 Penny  24
```

## list.flatten

`list` is powerful in its recursive nature. Sometimes, however, we don't need its recursive feature but want to *flatten* it so that all its child elements are put to the first level. 

`list.flatten()` recursively extract all elements at all levels and put them to the first level.


```r
data <- list(list(a=1,b=2),list(c=1,d=list(x=1,y=2)))
str(data)
```

```
# List of 2
#  $ :List of 2
#   ..$ a: num 1
#   ..$ b: num 2
#  $ :List of 2
#   ..$ c: num 1
#   ..$ d:List of 2
#   .. ..$ x: num 1
#   .. ..$ y: num 2
```

```r
list.flatten(data)
```

```
# $a
# [1] 1
# 
# $b
# [1] 2
# 
# $c
# [1] 1
# 
# $d.x
# [1] 1
# 
# $d.y
# [1] 2
```

## list.sample



## list.names



