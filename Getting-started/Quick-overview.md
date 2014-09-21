

# Quick overview

In recent years, non-relational data have attracted increasing attention. Roughly speaking, all datasets that are hard to put into a table with rows and columns are non-relational, or non-tabular datasets.

R has great capability in dealing with tabular data. The built-in class `data.frame` is powerful enough to represent a wide variety of relational data stored in rectangular tables. Packages such as [data.table](https://github.com/Rdatatable/data.table) and [dplyr](https://github.com/hadley/dplyr) are developed to make it easier and faster to work with data frames and derived classes with more features. For example, a tabular data may look like

| Name |  Gender | Age | Major |
|------|---------|-----|-------|
| Ken | Male | 24 | Finance |
| Ashley | Female | 25 | Statistics |
| Jennifer | Female | 23 | Computer Science |

It is very easy to deal with such kind of data due to its regularity. In fact, each column has the same type and same length of values.

Although dealing with data frames has been made much easier and faster than ever, we still lack native tools in R to easily deal with non-relational data like the following:

| Name | Age | Interests | Expertise |
|------|-----|----------|----------|
| Ken | 24 | reading, music, movies | R:2, C#:4, Python:3 |
| James | 25 | sports, music | R:3, Java:2, C++:5 |
| Penny | 24 | movies, reading | R:1, C++:4, Python:2 |

It is obvious that different records have different set of interests with different lengths, and they also have different set of expertises as well.

If we are forced to squeeze the data into tabular form, there should be multiple tables and a number of relationships between them. Suppose we have a longer list of people (see [here](people.json)) and we want to know the age distribution for each interest class of those who use R and Python both for at least 3 years. It would require some efforts to translate such question to a SQL query to ask the database.

With rlist, the question would be easy to answer:

```r
library(rlist)
library(pipeR)

url <- "http://renkun.me/rlist-tutorial/Getting-started/people.json"
people <- list.load(url)
people %>>%
  list.filter(Expertise$R >= 1 & Expertise$Python >= 1) %>>%
  list.class(Interests) %>>%
  list.map(intclass ~ intclass %>>% list.table(Age))
```

