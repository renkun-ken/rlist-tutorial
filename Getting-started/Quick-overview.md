

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

It is obvious that different records have different set of interests with different lengths, and they also have different set of expertise as well.

If we are forced to squeeze the data into tabular form, there should be multiple tables and a number of relationships between them. Suppose we have a longer list of people (see [here](../data/people.json)) and we want to answer the following question:

*What is the age distribution for the most popular 3 interest classes of those who use both R and Python for at least one year?*

It would require some efforts to translate such question to a SQL query to send to the database. But with rlist, the question would be easy to answer:


```r
library(rlist)
library(pipeR)

url <- "http://renkun.me/rlist-tutorial/data/people.json"
people <- list.load(url)
people %>>%
  list.filter(Expertise$R >= 1 & Expertise$Python >= 1) %>>%
  list.class(Interests) %>>%
  list.sort(-length(.)) %>>%
  list.take(3) %>>%
  list.map(. %>>% list.table(Age))
```

```
# $music
# Age
# 21 22 23 24 25 26 27 28 29 30 31 32 33 35 36 
#  1  2  1  2  5  9  6  5  9  6  4  4  1  1  1 
# 
# $hiking
# Age
# 21 22 23 24 25 26 27 28 29 30 31 32 33 
#  2  1  1  3  4  4  6  4  7 13  5  4  2 
# 
# $reading
# Age
# 19 22 23 24 25 26 27 28 29 30 31 32 33 35 
#  1  1  2  1  4  6  2  3  9 11  3  3  3  1
```

The code uses [pipeR](/pipeR)'s `%>>%` operator to organize code into fluent style. Even if you are not familiar with the functions and operators, you would probably be correct if you guess what the code does.

Let's break it down:

1. We filter `people` list by the prerequisites: Using both R and Python  for at least one year.
2. Then we class all people by their interests, that is, we create a big list of possible interest values, each is a nested list of all people whose interests contain that value.
3. Then we sort in descending these interest classes by the number of people who has the corresponding interest.
4. Then we pick out the top 3 interests with most people.
5. Then we map each interest class to a table of ages in that class.

The output is exactly the answer to the question.

It should be clear now that rlist defines a collection of functions to manipulate list objects. Although each function only does a simple job, the combination of them can be very powerful. This tutorial will cover most functionality in detail and provide example solutions to commonly encountered data processing problems.
