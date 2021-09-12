#!/usr/bin/perl -s
# this is a simple tf*idf calculator.
# it calculates tf*idf for all words in all provided files
# it assumes that the sentences are already tokenized (word-segmented)
# all files should have extension .txt just in case
# use example:
# > perl tfidf_calc.pl *.txt (to process all txt files in the folder)
# > perl tfidf_calc.pl -bm25 *.txt (if you want to use bm25 weighting)
# > perl tfidf_calc.pl -bm25plus *.txt (bm25+ seems to improve weighting for very long documents)
# Written by: Michal Ptaszynski
# All comments and requests to: ptaszynski@ieee.org

use utf8::all;
use List::Util qw(sum);
use MCE::Loop chunk_size => 1;#, max_workers => MCE::Util::get_ncpu;

# # TO SHOW HOW MANY ARGUMENTS WERE PROVIDED
# my $numArgs = $#ARGV + 1;
# print "thanks, you gave me $numArgs command-line arguments:\n";

my @filenames;

# find all filenames from arguments
foreach my $argnum (0 .. $#ARGV) {
    # print "$ARGV[$argnum]\n";
    my $filename = substr($ARGV[$argnum], 0, index($ARGV[$argnum], '.'));
    # print "filename is $filename\n";
    push @filenames, $filename;

    open(FILE_1, "<$filename.txt") or die "Cannot open $file: $!";
    my @file = <FILE_1>;
    close FILE_1;
    my $clusterfuck = join ' ', @file;

    # THIS CONTAINS ALL WORDS IN DOCUMENT
    @$filename = split ' ', $clusterfuck;

    if ($bm25==1 or $bm25plus==1){
      my $doclength = @$filename;
      push @doclengths, $doclength;
      # print "doclength is $doclength\n";
    }

    # THIS CONTAINS ALL UNIQUE WORDS IN DOCUMENT STORED IN PREMAPPED HASH
    $$filename = { map { $_ => 1 } @$filename };

    # making hash with wordcounts
    foreach my $wordy (@$filename){
      $uniqwords{$filename}{$wordy}++;
    }
    next;
}

if ($bm25==1 or $bm25plus==1){
  $avglength = sum(@doclengths)/@doclengths;
  # print "average is $avglength\n";
  $k = 2;
  $b = 0.75;
}

# foreach my $file (@filenames) {
mce_loop {
  my $file = $_;
  my %tfidfhash;

  # my %tfidfhash = mce_loop {
  #   my $word = $_;
  foreach my $word (keys %{$uniqwords{$file}}){
    my $tf = $uniqwords{$file}{$word}/@$file;

    if ($bm25==1){
      $tf = $uniqwords{$file}{$word}*($k+1)/($uniqwords{$file}{$word}+$k*((1-$b)+$b*(@$file/$avglength)));
    }

    if ($bm25plus==1){
      $d = 1;
      $tf = ($uniqwords{$file}{$word}*($k+1)/($uniqwords{$file}{$word}+$k*((1-$b)+$b*(@$file/$avglength)))+$d);
    }

    my $found=0;
    foreach $tempfilename (@filenames) {
      # USES TRICK (PREMAPPED HASH) FROM LINE 36
      $found++ if $$tempfilename->{ $word };
    }

    my $idf = log(@filenames/$found);
    # print "IDF for word \"$word\" in file \"$file\" is $idf\n";

    if ($bm25==1 or $bm25plus==1){
      $idf = log((@filenames-$found+0.5)/($found+0.5));
    }

    my $tfidf = $tf*$idf;
    # print "TF-IDF for word \"$word\" in file \"$file\" is $tfidf\n\n";

    $tfidfhash{$word}=$tfidf;
    # $hashtemp{$word}=$tfidf;
    # MCE->gather(%hashtemp);
  }
  # } keys %{$uniqwords{$file}};

  open(FH, '>', "tfidf_$file.txt") or die $!;

  print FH "$_,$tfidfhash{$_}\n" for sort { $tfidfhash{$b} <=> $tfidfhash{$a} or $a cmp $b } keys %tfidfhash;
  close(FH);
} @filenames;
