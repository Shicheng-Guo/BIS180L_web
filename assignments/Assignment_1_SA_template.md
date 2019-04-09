# Template for Assignment1: Unix, git, and Sequence Alignment Assignments (20 pts possible)

__Full Name:__

__Student ID:__

*_Any code should be formatted as such_*

## Markdown

Paste the bio of your the student you interviewed here:


## Unix

Paste the `date` command that you used for exercise one here:

## Git

Paste the URL for the shared github repository that you created with your lab partners here.  Use proper markdown formatting:

Paste the saved output of the `git log` command here (format as a code block)


## Sequence Alignment

*_Please answer the following questions Be clear and concise with any written answers._*

** Unless otherwise noted we are not requiring you to include your code here.  However, I advise that you record it in a separate Markdown file for your reference.  That way if you need it again (e.g. for the midterm) you have a record of what you did**

__1.__ Paste in the result of the `ls -lR Data` command performed at the beginning of the Sequence_Alignment exercise that shows the aliases (symbolic links).  Format this as a code block.  

__2.__ Paste in the markdown table from the lab manual that includes for each genome:

* Size of the file
* Number of chromosomes
* Size of the genome in bp
* Number of protein-coding genes
* Average protein length

For _ONE_ of the files, provide the code that you used to answer these questions.

__3.__ How do you know that when you use `shuffleseq` that the sequences have the same exact composition?

__4.__ Create a text based "histogram" as described in the lab manual
that shows the distribution of scores when aligning shuffled sequences.

__5.__ Is the shape of the curve normal? Do you expect it to be normal?

__6.__ Perform the experiment 3 more times with a different 1000 shuffled sequences. Create a table using markdown with the mean, mode and median for each run (include your first run for a total of 4 runs).

__7.__ What would be the effect of doing more than 1000 shuffled sequences?

__8.__ Search the ce1 sequence against a shuffled version of the same sequence (ce1) and report the average score.

__9.__ Does amino acid composition affect the scores?  To find out, create a fake protein sequence where the last half of ce1 is replaced with Qs. Now make a shuffled version of this to distribute the Qs around. Align this sequence to the ce1 and at1 sequences and report the alignment score. 

__10.__ Create 1000 shuffles of the Q-enriched sequence above and report the average score.

__11.__ Briefly discuss parts 8-10 with respect to how sequence composition affects score. (*2pts*)

__2019: OK TO SKIP THIS QUESTION__ How does protein length affect the scores?  Design an experiment to test your idea and give the results.

__2019: OK TO SKIP THIS QUESTION__ How many amino acids can be aligned per second?  How many amino acids need to be aligned for the experiment?  How long would it take to compare the two proteomes? 

__14.__ Starting with the C. elegans B0213.10 protein, find the best
match in the A. thaliana and D. melanogaster proteomes with `water`.
Record their alignment scores, percent identities, and protein names
here.  (Use a markdown table!)

__15.__ What is the expected (average) score of each pairwise alignment
at random? (Perform some shuffled alignments to get an idea of what the
random expectation is).

__16.__ How many [Z-scores](https://www.statisticshowto.datasciencecentral.com/probability-and-statistics/z-score/) away from the mean is the best alignment?  If you know how to use R to do this, great.  If not you will learn in the next couple of weeks.  In the meantime, you can use "LibreOffice Calc" on your instance (Applicatoins > Office > LibreOffice Calc), or an online calculator to calculate the mean and sd of your alignments.  [mean](https://goodcalculators.com/statistics-calculator-graph-generator/) [sd](https://goodcalculators.com/standard-deviation-calculator/) [Z](https://goodcalculators.com/z-score-calculator/)

__17.__ Briefly discuss the statistical and biological significance of your results.

