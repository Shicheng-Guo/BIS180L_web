---
title: "Installing Requisite Software on your Mac"
layout: post
tags:
hidden: 
---

If you want to try doing the labs directly on your Mac instead of on AWS here is how you can.  This document may have errors; please let me know and I can help (and update the document)

## web downloads

Install the following packages by clicking on the link and following the instructions on the web page:

* [Xcode](https://developer.apple.com/xcode/download/), allowing compilation of source packages on your Mac.
* The [atom](https://atom.io/) editor
* The [R](https://cran.r-project.org/) statistical programming language
* The R IDE [Rstudio](https://www.rstudio.com/)
* The sequence alignment viewer [jalview](http://www.jalview.org/)
* The network viewer [cytoscape](http://www.cytoscape.org/)

## Atom packages

Open up  atom, click on File > Preferences, and then install the following atom packages.  Not all of these are needed for the BIS180L but they are good to have

* Sublime-Style_Column-Selection
* autocomplete-python
* language-r
* language-markdown
* python-tools

In atom go to preferences and search for the 'whitespace' package.  Disable it.

## Homebrew

Install [Homebrew](http://brew.sh/), a package manager for OS X that it much easier to install Linux/Unix packages.  There are some reports that homebrew has issues on El Capitan, but that may have been resolved.  Let me know if you get data one way or the other.

From a terminal window:

upgrade homebrew

    brew update
    brew upgrade

install the following packages through homebrew

    brew tap brewsci/bio # additional packages
    brew install htop
    brew install git
    brew install igv
    brew install clustal-w
    brew install kalign
    brew install t-coffee
    brew install muscle
    brew install mafft
    brew install tophat
    brew install bwa
    brew install cufflinks
    brew install samtools
    brew install bedtools
    brew install blast
    brew install emboss

## R packages

Open R and then

    install.packages(c('swirl','ggplot2','genetics','hwde','seqinr','qtl','evaluate','formatR','highr','markdown','yaml','htmltools','caTools','bitops','knitr','rmarkdown','devtools','shiny','pvclust','gplots','cluster','igraph','scatterplot3d','ape','SNPassoc','rsconnect','dplyr','tidyverse','learnr'))
    devtools::install_github(repo = "cran/PSMix")

Still within R, install bioconductor

    source("http://bioconductor.org/biocLite.R")
    biocLite()
    biocLite(c("Rsubread","snpStats","rtracklayer","goseq","impute","multtest","VariantAnnotation","chopsticks","edgeR"))
    install.packages('LDheatmap')

## perl modules

For auto_barcode to work, the following must be installed (From the Unix command line):

    sudo cpan install Statistics::Descriptive
    sudo cpan install Statistics::R
    sudo cpan install Text::Levenshtein::XS
    sudo cpan install Text::Table

## STAR aligner

From the unix command line:
    
    cd ~/Downloads
    wget https://github.com/alexdobin/STAR/raw/master/bin/MacOSX_x86_64/STAR
    chmod 0755 STAR
    cp STAR /usr/local/bin

## Other

Still need to deal with trimmomatic and auto_barcode, but the instructions in the labs should more or less work.



