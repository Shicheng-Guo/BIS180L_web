---
layout: post
title: How to turn in your Rmd assignments
---

One of the advantages of working in R markdown is that the code and its output can all be included in the same document.  

There are two different ways to do this; both will work.   

Here are detailed instructions.

1. Include your code in the R markdown file.  **Any answer that requires any computation should include the code used to answer the question**.  For example, for question 8 _"How many hits have an e-value of 0?"_  or _"Recalculate the above values but in percentage of hits rather than absolute values."_ Do not just type in a number.  Instead include the code in your Rmd that will generate the answer.
2. Click the "Preview" Button generate an up-to-date html version of your notebook.  Check it to make sure you are happy with its content.  __Make sure it includes your code and output__
3. An alternative is to click the triangle next the the preview button and then choose "knit-to-html".  This will re-run all code in your document and generate a new html document; it ensures that your the R output matches the code in your document and so is "best practice".  Note that if you choose this option, when you "knit" your file R will run all of the code in the .Rmd in a new environment.  This means that if your code depends on objects created by code in the lab manual, then that code _also_ most be included so that you knit your file successfully.
4. Add BOTH your .Rmd AND the .html file(s) to your repository.  If you used "knit" you will actually have two .html files, one that ends .nb.html and just one that ends in .html.  The knitted file is the one without .nb, but if you are unsure just add them both.
5. Commit your changes
6. Push 