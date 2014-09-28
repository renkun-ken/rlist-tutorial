

# Input/Output

rlist provides various mechanisms for list data input/output. 

## list.parse

`list.parse()` is used to convert an object to list. For example, this function can convert `data.frame`, `matrix` to a list with identical structure.


```r
library(rlist)
df1 <- data.frame(name=c("Ken","Ashley","James"),
  age=c(24,25,23),stringsAsFactors = FALSE)
str(list.parse(df1))
```

```
# List of 3
#  $ 1:List of 2
#   ..$ name: chr "Ken"
#   ..$ age : num 24
#  $ 2:List of 2
#   ..$ name: chr "Ashley"
#   ..$ age : num 25
#  $ 3:List of 2
#   ..$ name: chr "James"
#   ..$ age : num 23
```

This function also parses JSON or YAML format text.


```r
jsontext <- '
[{ "name": "Ken", "age": 24 },
 { "name": "Ashley", "age": 25},
 { "name": "James", "age": 23 }]'
str(list.parse(jsontext,type="json"))
```

```
# List of 3
#  $ :List of 2
#   ..$ name: chr "Ken"
#   ..$ age : int 24
#  $ :List of 2
#   ..$ name: chr "Ashley"
#   ..$ age : int 25
#  $ :List of 2
#   ..$ name: chr "James"
#   ..$ age : int 23
```


```r
yamltext <- "
p1:
  name: Ken
  age: 24
p2:
  name: Ashley
  age: 25
p3:
  name: James
  age: 23
"
str(list.parse(yamltext,type="yaml"))
```

```
# List of 3
#  $ p1:List of 2
#   ..$ name: chr "Ken"
#   ..$ age : int 24
#  $ p2:List of 2
#   ..$ name: chr "Ashley"
#   ..$ age : int 25
#  $ p3:List of 2
#   ..$ name: chr "James"
#   ..$ age : int 23
```

## list.load, list.save

`list.load()` is used to load list data from a JSON, YAML, or RData file. Its default behavior is to first look at file extension and then determine which data loader is used. If the file extension does not match JSON or YAML, it will use RData loader.

`list.save()` is used to save a list to a JSON, YAML, or RData file. Its default behavior is similar with that of `list.load()`.

If the data are read or written by these two functions in JSON or YAML format, the data will be human-readable. However, if a list contains complex objects such as S4 objects and language objects, the text-based format may not be appropriate to store such objects. You should consider storing them in binary format, i.e. RData file or serialize the object.

## list.serialize, list.unserialize

Serialization is the process that stores an object into fully-recoverable data format. `list.serialize()` and `list.deserialize()` provides the mechanism to capitalize the R native serializer/unserializer and JSON serializer/unserializer provided by `jsonlite`.
