

# File formats

In the previous pages, we have pointed out that rlist is designed to deal with non-tabular data, that is, data that does not well fit a tabular form. To remind the difference between them, we recall the examples we used.

The following table represents a tabular data:

| Name |  Gender | Age | Major |
|------|---------|-----|-------|
| Ken | Male | 24 | Finance |
| Ashley | Female | 25 | Statistics |
| Jennifer | Female | 23 | Computer Science |

The table can be easily stored into either text-based file or relational database. The most commonly used text-based file format to store such type of data is [CSV](en.wikipedia.org/wiki/Comma-separated_values) which often uses comma (`,`) to divide columns. In this format, the data can be written in the following form:

```
Name,Gender,Age,Major
Ken,Male,24,Finance
Ashley,Female,25,Statistics
Jennifer,Female,23,Computer Science
```

It is obvious that each line represents a record and columns can be distinguished by comma. In R reading a `csv` file is simple: `read.csv()` can handle it easily.

However, when it comes to non-tabular data, standard CSV format and the reader functions certainly do not handle it as well as it does with tabular data. Recall the following table in which a non-tabular data is demonstrated:

| Name | Age | Interests | Expertise |
|------|-----|----------|----------|
| Ken | 24 | reading, music, movies | R:2, C#:4, Python:3 |
| James | 25 | sports, music | R:3, Java:2, C++:5 |
| Penny | 24 | movies, reading | R:1, C++:4, Python:2 |

You can try to write a CSV file to represent it, but the outcome may not be satisfactory: the number of values of `Interests` column is not fixed, and the values of `Expertise` column are also different in names.

[JSON](http://json.org/) is a powerful format to represent such flexible data. It certainly has more notations but does not make the representation too complex. The following text is the JSON format of the table above.

```json
[
  {
		"Name" : "Ken",
		"Age" : 24,
		"Interests" : [
			"reading",
			"music",
			"movies"
		],
		"Expertise" : {
            "R": 2,
            "CSharp": 4,
			"Python" : 3
		}
	},
	{
		"Name" : "James",
		"Age" : 25,
		"Interests" : [
			"sports",
			"music"
		],
		"Expertise" : {
			"R" : 3,
			"Java" : 2,
			"Cpp" : 5
		}
	},
	{
		"Name" : "Penny",
		"Age" : 24,
		"Interests" : [
			"movies",
			"reading"
		],
		"Expertise" : {
			"R" : 1,
			"Cpp" : 4,
			"Python" : 2
		}
	}
]
```

You may find that the JSON text above fully replicates the information in the table but using notations such as `[]`, `{}` and `"key" : value`. Here is a simplified introduction to these notations:

- `[]` creates a unnamed node array.
- `{}` creates a named node list.
- `"key" : value` creates a key-value pair where `value` can be a number, a string, a `[]` array, or a `{}` list.

These notations allow the use of nested lists or arrays, just like how `list` object in R can be nested. Therefore, this similarity briges the use of JSON and R. rlist package imports [jsonlite](https://github.com/jeroenooms/jsonlite) package to read/write JSON data.

Another file format that is also widely used is [YAML](http://yaml.org/). The following text is a YAML format representation (stored [here](../data/sample.yaml)) of the non-tabular data:

```yaml
- Name: Ken
  Age: 24
  Interests:
  - reading
  - music
  - movies
  Expertise:
    R: 2
    CSharp: 4
    Python: 3
- Name: James
  Age: 25
  Interests:
  - sports
  - music
  Expertise:
    R: 3
    Java: 2
    Cpp: 5
- Name: Penny
  Age: 24
  Interests:
  - movies
  - reading
  Expertise:
    R: 1
    Cpp: 4
    Python: 2
```

Note that YAML representation is much cleaner than JSON format. rlist also imports [yaml](https://github.com/viking/r-yaml) package to read/write YAML data.
