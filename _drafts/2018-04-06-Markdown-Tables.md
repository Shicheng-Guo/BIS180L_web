---
layout: post
title: Markdown Tables
---

The lab exercise for sequence alignment asks you to make a Markdown table.  But how do you make one?

The basic format is like this:
```
| header 1 |  header 2 | header 3|
|:---------|:----------:|--------:|
| data 1.1 | data 1.2 | data 1.3      |
|  2.1 | data 2.2     |  2.3  |
```
which produces

| header 1 | header 2 | header 3|
|:---------|:--------:|---------:|
| data 1.1 | data 1.2 | data 1.3      |
|  2.1 | data 2.2     |  2.3  |

You use pipes `|` to denote the columns, and separate the headers from the data with a row of `|--|`

You can use colons in the header separating row to left or right (or center) justify.  Look at columns 1 vs 2 vs 3 in the table.  

Note that even if the spacing in your table is uneven (pipes don't line up) the table still looks good in the output.  (But try to make it like nice even in the unformatted text)

For more details, [see here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#tables).  For tool to help you generate a table without all of that finicking typing, [see here](http://www.tablesgenerator.com/markdown_tables)