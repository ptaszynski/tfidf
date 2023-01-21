# This one is just for fun. It was generated with ChatGPT. 
#
import os
import math

# find all filenames from arguments
filenames = []
doclengths = []
uniqwords = {}
bm25 = False
bm25plus = False

for arg in sys.argv[1:]:
    if arg == "-bm25":
        bm25 = True
        continue
    if arg == "-bm25plus":
        bm25plus = True
        continue
    filename = os.path.splitext(arg)[0]
    filenames.append(filename)
    with open(f"{filename}.txt", "r") as f:
        file_content = f.read()
    clusterfuck = " ".join(file_content.strip().split("\n"))
    # THIS CONTAINS ALL WORDS IN DOCUMENT
    all_words = clusterfuck.split(" ")
    if bm25 or bm25plus:
        doclength = len(all_words)
        doclengths.append(doclength)
    # THIS CONTAINS ALL UNIQUE WORDS IN DOCUMENT STORED IN PREMAPPED HASH
    uniqwords[filename] = set(all_words)
    wordcounts = {}
    for word in all_words:
        wordcounts[word] = wordcounts.get(word, 0) + 1
    uniqwords[filename] = wordcounts

if bm25 or bm25plus:
    avglength = sum(doclengths)/len(doclengths)
    k = 2
    b = 0.75

tfidfhash = {}
for file in filenames:
    for word, count in uniqwords[file].items():
        tf = count / len(all_words)
        if bm25:
            tf = count * (k + 1) / (count + k * (1 - b + b * (len(all_words) / avglength)))
        elif bm25plus:
            d = 1
            tf = (count * (k + 1) / (count + k * (1 - b + b * (len(all_words) / avglength))) + d)
        found = sum(1 for tempfilename in filenames if word in uniqwords[tempfilename])
        idf = math.log(len(filenames) / found)
        if bm25 or bm25plus:
            idf = math.log((len(filenames) - found + 0.5) / (found + 0.5))
        tfidfhash[word] = tf * idf

print(tfidfhash)
