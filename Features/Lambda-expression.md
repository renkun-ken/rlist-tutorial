

# Lambda expression

Although the fields of each list element are directly accessible in the expression, sometimes we still need to access the list element itself, usually for its meta-information. Lambda expressions provide a mechanism that allows you to use default or customized meta-symbols to access the meta-information of the list element.

In rlist package, all functions that work with expressions support implicit lambda expressions, that is, an ordinary expression with no special syntax yet the fields of elements are directly accessible. All functions working with expressions except `list.select()` also support explicit lambda expression including

- Univariate lambda expression: In contrast to implicit lambda expression, the symbol that refers to the element is customized in the following formats:
  * `x ~ expression`
  * `f(x) ~ expression`
- Multivariate lambda expression: In contrast to univariate lambda expression, the symbols of element, index, and member name are customized in the following formats:
  * `f(x,i) ~ expression`
  * `f(x,i,name) ~ expression`


```r
library(rlist)
```


## Implicit lambda expression

Implicit lambda expression is an ordinary expression with no special syntax like `~`. In this case, meta symbols are implicitly defined in default, that is, `.` represents the element, `.i` represents the index, and `.name` represents the name of the element.

For example,


```r
x <- list(a=list(x=1,y=2),b=list(x=2,y=3))
list.map(x,y)
```

```
# $a
# [1] 2
# 
# $b
# [1] 3
```

```r
list.map(x,sum(as.numeric(.)))
```

```
# $a
# [1] 3
# 
# $b
# [1] 5
```

In the second mapping above, `.` represents each element. For the first member, the meta-symbols take the following values:

```r
. = x[[1]] = list(x=1,y=2)
.i = 1
.name = "a"
```

## Explicit lambda expression

To use other symbols to represent the metadata of a element, we can use explicit lambda expressions.


```r
x <- list(a=list(x=1,y=2),b=list(x=2,y=3))
list.map(x, f(item,index) ~ unlist(item) * index)
```

```
# $a
# x y 
# 1 2 
# 
# $b
# x y 
# 4 6
```

```r
list.map(x, f(item,index,name) ~ list(name=name,sum=sum(unlist(item))))
```

```
# $a
# $a$name
# [1] "a"
# 
# $a$sum
# [1] 3
# 
# 
# $b
# $b$name
# [1] "b"
# 
# $b$sum
# [1] 5
```

For unnamed vector members, it is almost necessary to use lambda expressions.


```r
x <- list(a=c(1,2),b=c(3,4))
list.map(x,sum(.))
```

```
# $a
# [1] 3
# 
# $b
# [1] 7
```

```r
list.map(x,item ~ sum(item))
```

```
# $a
# [1] 3
# 
# $b
# [1] 7
```

```r
list.map(x,f(m,i) ~ m+i)
```

```
# $a
# [1] 2 3
# 
# $b
# [1] 5 6
```

For named vector members, their name can also be directly used in the expression.


```r
x <- list(a=c(x=1,y=2),b=c(x=3,y=4))
list.map(x,sum(y))
```

```
# $a
# [1] 2
# 
# $b
# [1] 4
```

```r
list.map(x,x*y)
```

```
# $a
# [1] 2
# 
# $b
# [1] 12
```

```r
list.map(x,.i)
```

```
# $a
# [1] 1
# 
# $b
# [1] 2
```

```r
list.map(x,x+.i)
```

```
# $a
# [1] 2
# 
# $b
# [1] 5
```

```r
list.map(x,f(.,i) ~ . + i)
```

```
# $a
# x y 
# 2 3 
# 
# $b
# x y 
# 5 6
```

```r
list.map(x,.name)
```

```
# $a
# [1] "a"
# 
# $b
# [1] "b"
```

> NOTE: `list.select` does not support explicit lambda expressions.
