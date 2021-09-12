# tf\*idf calculator

This is a super simple tf\*idf calculator. It will calculate tf\*idf for each word in each document and save the results in separate files accordingly.

1. Dependencies. Before using you will need to install two Perl modules:
   - **utf8::all**  if you use the normal version, and additionally:
   - **MCE**, **MCE::Loop** if you want to use multicore version.
   
   Multicore version can be faster if you have a large number of documents (>~100).

2. Usage. Prepare each document in separate file. Make sure the documents are properly tokenized (e.g., words and punctuation are separated by spaces). You can process all txt files in present working folder with the following command. 

   **perl tfidf_calc.pl \*.txt**
