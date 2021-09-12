# tf\*idf calculator

This is a super simple tf\*idf calculator. It will calculate tf\*idf for each word in each document and save the results in separate files accordingly.

1. Dependencies. Before using you will need to install the following Perl modules:
   - **utf8::all** abd **List::Util**  if you use the normal version, and additionally:
   - **MCE**, **MCE::Loop** if you want to use multicore version.
   
   Multicore version can be faster if you have a large number of documents (>~100).

2. Usage. Prepare each document in separate file. Make sure the documents are properly tokenized (e.g., words and punctuation are separated by spaces). You can process all txt files in present working folder with the following command. 

   **perl tfidf_calc.pl \*.txt**
   
   or
   
   **perl tfidf_calc_mc.pl \*.txt**  
   
   for the multicore version.

3. Weighting schemes. You can choose: 1) traditional tf\*idf, 2) Okapi BM25, or 3) BM25+ weighting schemes. BM25 adds document length into consideration, while BM25+ solves the problem where BM25 cannot compute proper weight for very long documents. Usage, accordingly:

   **perl tfidf_calc.pl -bm25 \*.txt**
   **perl tfidf_calc.pl -bm25plus \*.txt**
   **perl tfidf_calc_mc.pl -bm25 \*.txt**
   **perl tfidf_calc_mc.pl -bm25plus \*.txt**
