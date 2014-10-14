

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

## list.sample



## list.zip




## list.rbind, list.cbind




## list.stack




## list.flatten




## list.names



