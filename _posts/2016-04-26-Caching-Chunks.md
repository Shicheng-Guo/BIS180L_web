---
layout: post
title: Tired of slow knits?
---
Knitting can be very slow if you are plotting complex data sets or doing long calculations.  Wouldn't it be nice if there were a way for R not to have to recalculate or replot every time?

__There is!__

We can tell R to not re-knit code or plots that are unchanged from the last time that you knitted.

Place the following near the top of the your .Rmd file (but below the second "---") Place it inside of a code chunk

```
knitr::opts_chunk$set(cache=TRUE, autodep=TRUE)
```

Overall the start of your file should look something like this:
![]({{site.baseurl}}/images/chunkset.png)

