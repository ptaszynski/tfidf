# tf\*idf calculator

This is a super simple (and pretty fast) tf\*idf calculator. It will calculate tf\*idf for each word in each document and save the results in separate files accordingly.

## 1. Dependencies.

Before using you will need to install the following Perl modules:
   - **utf8::all** and **List::Util**  if you use the normal version, and additionally:
   - **MCE**, **MCE::Loop** if you want to use multicore version.
   
   Multicore version can be faster if you have a large number of documents (>~10).

## 2. Usage.

Prepare each document in separate file. Make sure the documents are properly tokenized (e.g., words and punctuation are separated by spaces). You can process all txt files in present working folder with the following command. 

```
perl tfidf_calc.pl *.txt
```

## 3. Weighting schemes.

You can choose: 1) traditional tf\*idf, 2) Okapi BM25, or 3) BM25+ weighting schemes. BM25 adds document length into consideration, while BM25+ solves the problem where BM25 cannot compute proper weight for very long documents. Usage, accordingly:

```
perl tfidf_calc.pl -bm25 *.txt
```
```
perl tfidf_calc.pl -bm25plus *.txt
```

## 4. Multicore versions.

I tested three versions of the script that use Perl's multicore engine:
- tfidf_calc_mc_words.pl  -  this version simultaneously takes all unique words in file. 
- tfidf_calc_mc_files.pl  -  this version simultaneously takes all provided files provided. 
- tfidf_calc_mc_files_words.pl  -  this version simultaneously takes both all provided files and all unique words in each file (like a double fork). 

Below are the benchmarking results for speed of processing 1 file, 10 files, and 100 files. The overall conclusion is that taking all words simultaneusly is the best option cost-performance-wise. Double fork is not very efficient (as you would expect) if you have 100 documents or more, while taking simultaneusly all files is not very efficient in general.

### Multicore benchmark results for 1 file 
```
                                 Rate tfidf_calc_mc_files tfidf_calc_mc_words tfidf_calc_mc_files_words tfidf_calc
tfidf_calc_mc_files       210928156/s                  --                 -0%                       -7%        -8%
tfidf_calc_mc_words       211530235/s                  0%                  --                       -7%        -7%
tfidf_calc_mc_files_words 227757632/s                  8%                  8%                        --        -0%
tfidf_calc                228422117/s                  8%                  8%                        0%         --
```
### Multicore benchmark results for 10 files 
```
                                 Rate tfidf_calc tfidf_calc_mc_files tfidf_calc_mc_words tfidf_calc_mc_files_words
tfidf_calc                207960970/s         --                 -5%                -11%                      -12%
tfidf_calc_mc_files       219996677/s         6%                  --                 -6%                       -7%
tfidf_calc_mc_words       233991201/s        13%                  6%                  --                       -1%
tfidf_calc_mc_files_words 235470822/s        13%                  7%                  1%                        --
```
### Multicore benchmark results for 100 files 
```
                                 Rate tfidf_calc tfidf_calc_mc_files_words tfidf_calc_mc_files tfidf_calc_mc_words
tfidf_calc                208945748/s         --                       -3%                 -4%                 -4%
tfidf_calc_mc_files_words 216463105/s         4%                        --                 -0%                 -1%
tfidf_calc_mc_files       217209498/s         4%                        0%                  --                 -0%
tfidf_calc_mc_words       218061234/s         4%                        1%                  0%                  --
```
