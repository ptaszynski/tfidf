#!/usr/bin/perl
# this is a simple tf*idf calculator.
# it calculates tf*idf for all words in all provided files
# it assumes that the sentences are already tokenized (word-segmented)
# all files should have extension .txt just in case
# use example:
# > perl tfidf_calc.pl *.txt (to process all txt files in the folder)
# Written by: Michal Ptaszynski
# All comments and requests to: ptaszynski@ieee.org

use utf8::all;

# # TO SHOW HOW MANY ARGUMENTS WERE PROVIDED
# my $numArgs = $#ARGV + 1;
# print "thanks, you gave me $numArgs command-line arguments:\n";

my @filenames;
# my @filenameswithext
my %wordhash;

# find all filenames from arguments
foreach my $argnum (0 .. $#ARGV) {
    # print "$ARGV[$argnum]\n";
    my $filename = substr($ARGV[$argnum], 0, index($ARGV[$argnum], '.'));
    # print "$filename\n";
    push @filenames, $filename;

    open(FILE_1, "<$filename.txt") or die "Cannot open $file: $!";
    my @file = <FILE_1>;
    close FILE_1;
    my $clusterfuck = join ' ', @file;

    # THIS CONTAINS ALL WORDS IN DOCUMENT
    @$filename = split ' ', $clusterfuck;

    # THIS CONTAINS ALL UNIQUE WORDS IN DOCUMENT STORED IN PREMAPPED HASH
    $$filename = { map { $_ => 1 } @$filename };

    # making hash with wordcounts
    foreach my $wordy (@$filename){
      $uniqwords{$filename}{$wordy}++;
    }

    next;
}

foreach my $file (@filenames) {
  my %tfidfhash;

  # foreach my $word (@$file){
  foreach my $word (keys %{$uniqwords{$file}}){
    my $tf = $uniqwords{$file}{$word}/@$file;
    # print "occurences of word \"$word\" in file \"$file\" is $counttf{$word}\n";
    # print "all words in file \"$file\" is $allwords\n";
    # print "TF for word \"$word\" in file \"$file\" is $tf\n";

    my $found=0;
    foreach $tempfilename (@filenames) {
      # USES TRICK (PREMAPPED HASH) FROM LINE 44
      $found++ if $$tempfilename->{ $word };
    }
    # print "word $word appears in $found documents\n" if $found>1;
    # print "number of all files is $allfiles\n";

    my $idf = log(@filenames/$found);
    # # print "IDF for word \"$word\" in file \"$file\" is $idf\n";

    my $tfidf = $tf*$idf;
    # print "TF-IDF for word \"$word\" in file \"$file\" is $tfidf\n\n";

    $tfidfhash{$word}=$tfidf;
  }
  open(FH, '>', "tfidf_$file.txt") or die $!;

  print FH "$_,$tfidfhash{$_}\n" for sort { $tfidfhash{$b} <=> $tfidfhash{$a} or $a cmp $b } keys %tfidfhash;
  close(FH);
}
