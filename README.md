# tfidf

This is a simple tf\*idf calculator. It will calculate tf\*idf for each word in each document.

1. Dependencies
Before using you will need to install two Perl modules:
   - **utf8::all**
   - **List::Util**

2. Usage.
Prepare each document in separate file. Make sure the documents are properly tokenized (e.g., words and punctuation are separated by spaces). You can process all txt files in present working folder with the following command. 

   **perl tfidf_calc.pl \*.txt**
