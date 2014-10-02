

# Working in pipeline

rlist is by design friendly to pipeline operations. Almost all functions in the package take data from the first argument, which allows easy command chaining to process non-tabular data stored in list objects.

If you are familiar with [dplyr](https://github.com/hadley/dplyr) package, you would probably be familiar with `%>%` it imports from [magrittr](https://github.com/smbache/magrittr) package. For most functionality, `%>%` also works with rlist functions. However, in some cases, the operator may impose  conflicting interpretation on `.` symbol to cause unexpected error.

pipeR is recommended to work with rlist functions since they do not have any conflicting design with rlist. If you are already familiar with the idea of pipeline, you can quickly review pipeR's [project page](/pipeR). If you are not yet familiar with the concept or the package, [pipeR tutorial](/pipeR-tutorial) is strongly recommended.

Pipeline operations will definitely help you write more elegant code that is much easier to read and maintain. For example, without pipeR's `%>>%` operator, the code in previous page can be reverted to a traditional version with many intermediate variables, 

```r
people_filtered <- list.filter(people, Expertise$R >= 1 & Expertise$Python >= 1)
people_classes <- list.class(people_filtered, Interests)
people_classes_sorted <- list.sort(people_classes, -length(.)) %>>%
top_3_classes <- list.take(people_classes_sorted, 3)
top_3_table_age <- list.map(top_3_classes, . %>>% list.table(Age))
```

or a version without any intermediate variable but deeply nested function calls.

```r
list.map(list.take(list.sort(list.class(list.filter(people,
  Expertise$R >= 1 & Expertise$Python >= 1),Interests),
  -length(.)),3), . %>>% list.table(Age))
```

The first version is hard to write (time cost on naming variables). The second version is hard to read (almost a challenge to figure out the logic). Both versions are hard to maintain (imagine we need to add a data filter in the middle).

Let's see the version with `%>>%`.

```r
people %>>%
  list.filter(Expertise$R >= 1 & Expertise$Python >= 1) %>>%
  list.class(Interests) %>>%
  list.sort(-length(.)) %>>%
  list.take(3) %>>%
  list.map(. %>>% list.table(Age))
```

It is not only easy to write (no time wasted on naming variables) but also easy to read (very quickly to figure out what it does), and easy to maintain (very easy to add another data filter in the middle).
