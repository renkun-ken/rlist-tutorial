

# Comparers

`list.filter()` and `list.search()` are two major functions to find values that meet certain conditions. The condition is most likely to be a comparison, which can be done by exact comparing, atomic comparing, pattern matching by regular expression, string distance comparing, and so on.

In this page, we will introduce the usage of these comparers with filtering and searching functions and you will know more about how to perform logical and fuzzy data selection.


```r
library(rlist)
library(pipeR)
people <- list.load("https://renkun-ken.github.io/rlist-tutorial/data/sample.json")
friends <- list.load("https://renkun-ken.github.io/rlist-tutorial/data/friends.json")
```

## Precise comparers

Precise comparers include functions that compare the source value and target value precisely and see whether they are equal. The target value represents a certain value.

### Exact comparer

Exact comparing can be done with `identical()` which is built-in function that tells if two objects are exactly the same in terms of type, value, and attributes.

> NOTE: `identical()` is perhaps the strictest comparer that returns `FALSE` if any difference is spotted.

Two vectors that have equal values may not be identical: they may not have the same type or the same attributes. For example, two vectors having equal values


```r
c(1,2,3) == 1:3
```

```
# [1] TRUE TRUE TRUE
```

may not be identical.


```r
identical(c(1,2,3), 1:3)
```

```
# [1] FALSE
```

This happens because `c(1,2,3)` is a numeric vector while `1:3` produces an integer vector. `==` first coerce the integer vector to numeric vector and then compare the values but `identical()` will directly check if they are exactly the same.

In addition, the names of the vector make a difference too. Even if the values are exactly the same, a difference in names will also fails the check in `identical()`.


```r
c(a=1,b=2,c=3) == c(1,2,3)
```

```
#    a    b    c 
# TRUE TRUE TRUE
```


```r
identical(c(a=1,b=2,c=3), c(1,2,3))
```

```
# [1] FALSE
```

This happens because the names is in fact one of the common attributes of a vector object, which is in the checklist of `identical()`.

Having known the difference between exact comparing (`identical()`) and value comparing (`==`), we filter the people by whether their `Name` is exactly identical to *Ken*.


```r
people %>>%
  list.filter(identical(Name, "Ken")) %>>%
  str
```

```
# List of 1
#  $ :List of 4
#   ..$ Name     : chr "Ken"
#   ..$ Age      : int 24
#   ..$ Interests: chr [1:3] "reading" "music" "movies"
#   ..$ Expertise:List of 3
#   .. ..$ R     : int 2
#   .. ..$ CSharp: int 4
#   .. ..$ Python: int 3
```

Only people whose `Name` is exactly the same with character vector `"Ken"` will be singled out.

We can also use it in searching. For example, search all vectors exactly identical to `"Ken"`.


```r
list.search(friends, identical(., "Ken"))
```

```
# $Ken.Name
# [1] "Ken"
```

Only values that are identical to character vector `"Ken"` will be put in the resulting list. We can also unlist the result.


```r
list.search(friends, identical(., "Ken"), unlist = TRUE)
```

```
# Ken.Name 
#    "Ken"
```

Then, we search all values identical to `c("Ken","Penny")`.


```r
list.search(friends, identical(., c("Ken","Penny")))
```

```
# $James.Friends
# [1] "Ken"   "Penny"
```

Next, we search values exactly identical to numeric value `24`.


```r
list.search(friends, identical(., 24))
```

```
# named list()
```

The result is none. If you are familiar with how function `identical()` works as we described, you should not feel surprised. If you take a look at the data,


```r
str(friends)
```

```
# List of 4
#  $ Ken  :List of 3
#   ..$ Name   : chr "Ken"
#   ..$ Age    : int 24
#   ..$ Friends: chr "James"
#  $ James:List of 3
#   ..$ Name   : chr "James"
#   ..$ Age    : int 25
#   ..$ Friends: chr [1:2] "Ken" "Penny"
#  $ Penny:List of 3
#   ..$ Name   : chr "Penny"
#   ..$ Age    : int 24
#   ..$ Friends: chr [1:2] "James" "David"
#  $ David:List of 3
#   ..$ Name   : chr "David"
#   ..$ Age    : int 25
#   ..$ Friends: chr "Penny"
```

you will find that the ages are all stored as integers rather than numerics. Therefore, searching exact integers will work.


```r
list.search(friends, identical(., 24L))
```

```
# $Ken.Age
# [1] 24
# 
# $Penny.Age
# [1] 24
```

### Value comparer

`==` compares two atomic vectors by value and returns a logical vector indicating whether each pair of value coerced to a common type equal to each other. This comparison mechanism allows for more flexibility and can be useful in a wide range of situations.

For example, we search all values at least include one of `"Ken"` and `"Penny"`.


```r
list.search(friends, any(c("Ken","Penny") %in% .), unlist = TRUE)
```

```
#       Ken.Name James.Friends1 James.Friends2     Penny.Name  David.Friends 
#          "Ken"          "Ken"        "Penny"        "Penny"        "Penny"
```

Similarly, we search all numeric and integer values equal to `24`.


```r
list.search(friends, . == 24, c("numeric","integer"), unlist = TRUE)
```

```
#   Ken.Age Penny.Age 
#        24        24
```

When the code above is being evaluated, all numeric vectors and integer vectors are evaluated by `. == 24` recursively in `friends` where `.` represents the vector.

## Fuzzy comparers

Fuzzy comparers can be useful in a wide range of situations. In many cases, the filtering of data, mainly string data, is not clear-cut, that is, we don't know exactly the value or range to select. We will cover two main types of fuzzy comparers.

### Regular expression

One type of fuzzy filtering device is string pattern. It uses meta-symbols to represent a range of possible strings. Then all values that match this pattern can be selected.

For example, if we need to find all companies in a list with a domain name that ends up with `.com` or `.org`, we can use regular expression to tell whether a string matches a specific pattern. 

For `people` dataset, we can find out the names and ages of all those who have a name that includes `"en"` using `grepl()` which returns `TRUE` or `FALSE` indicating whether the string matches a given pattern.


```r
people %>>%
  list.filter(grepl("en", Name)) %>>%
  list.select(Name, Age) %>>%
  list.stack
```

```
#    Name Age
# 1   Ken  24
# 2 Penny  24
```

Regular expression is flexible enough to represent a wide range of string patterns. There are plentiful websites introducing regular expressions:

1. [RegexOne](http://regexone.com/): An interative tutorial
2. [RegExr](http://www.regexr.com/): An online string pattern tester

If you get to know more about it, it would certainly be rewarding in string-related data manipulation.

### String distance

The other type of fuzzy comparer is string distance measure. It is particularly useful if the quality of the data source is not high enough to only contain consistent texts. For example, if an object has a rich variants of names with very close spellings but slight differences or mis-spellings, a string-distance comparer can be useful.

[stringdist](https://github.com/markvanderloo/stringdist) is an R package that implements a rich collection of string distance measures. Basically, a string distance measure can tell you if two strings are close or not.


```r
library(stringdist)
stringdist("a","b")
```

```
# [1] 1
```

The distance between `"a"` and `"b"` is 1 because, basically speaking, "a" can be transformed to "b" in no more than 1 elementary steps in terms of [restricted Damerau-Levenshtein distance](http://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance) which is the default string distance meausres chosen by `stringdist()` function.


```r
stringdist("helo","hello")
```

```
# [1] 1
```

The distance between `"helo"` and `"hello"` is also 1 because one only needs to add a letter to transform the first string to the second, or vice versa. The string distance measure largely tolerates minor mis-spellings or slight variants between strings.

If you prefer other distance measure, you can specify `method=` argument. All possible values are listed in the documentation of `stringdist` package.


```r
stringdist("hao","hello",method = "dl")
```

```
# [1] 3
```

The string distance functions work with filtering functions in rlist. Consider the following data.


```r
people1 <- list(
    p1 = list(name="Ken",age=24),
    p2 = list(name="Kent",age=26),
    p3 = list(name="Sam",age=24),
    p4 = list(name="Keynes",age=30),
    p5 = list(name="Kwen",age=31))
```

We can use `stringdist()` in `stringdist` with `list.filter()`. For example, find all list elements whose `name` is like `"Ken"` with maximum distance 1, and output their pasted names as a named character vector.


```r
people1 %>>%
  list.filter(stringdist(name,"Ken") <= 1) %>>%
  list.mapv(name)
```

```
#     p1     p2     p5 
#  "Ken" "Kent" "Kwen"
```

Consider the following list.


```r
people2 <- list(
    p1 = list(name=c("Ken", "Ren"),age=24),
    p2 = list(name=c("Kent", "Potter"),age=26),
    p3 = list(name=c("Sam", "Lee"),age=24),
    p4 = list(name=c("Keynes", "Bond"),age=30),
    p5 = list(name=c("Kwen", "Hu"),age=31))
```

If we want to find out names either is similar with `"ken"` with maximum distance 2, we can run


```r
people2 %>>%
  list.search(any(stringdist(., "ken") <= 2), "character") %>>%
  str
```

```
# List of 4
#  $ p1.name: chr [1:2] "Ken" "Ren"
#  $ p2.name: chr [1:2] "Kent" "Potter"
#  $ p3.name: chr [1:2] "Sam" "Lee"
#  $ p5.name: chr [1:2] "Kwen" "Hu"
```

We can also search the terms in the character vectors like `"Ken"` with distance 1 and single out the values alike.


```r
people2 %>>%
  list.search(.[stringdist(., "Ken") <= 1], "character") %>>%
  str
```

```
# List of 3
#  $ p1.name: chr [1:2] "Ken" "Ren"
#  $ p2.name: chr "Kent"
#  $ p5.name: chr "Kwen"
```

`stringdist` even provides a Soundex-based string distance measure. We can use use it to find texts that sounds alike. For example, we can find out all people whose first name or last name sounds like Li.


```r
people2 %>>%
  list.filter(any(stringdist(name, "Li", method = "soundex") == 0)) %>>%
  list.mapv(name %>>% paste0(collapse = " "))
```

```
#        p3 
# "Sam Lee"
```
