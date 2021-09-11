#!/usr/bin/perl
# this is a simple tf*idf calculator.
# it calculates tf*idf for all words in all provided files
# it assumes that the sentences are already tokenized (word-segemnted)
# all files should have extension .txt
# Written by: Michal Ptaszynski
# All comments and requests to: ptaszynski@ieee.org
# use utf8;
use utf8::all;
use List::Util qw(first);
# use List::Util qw(sum);

# my $numArgs = $#ARGV + 1;
# print "thanks, you gave me $numArgs command-line arguments:\n";

my @filenames;
# my @filenameswithext

# find all filenames from arguments
foreach my $argnum (0 .. $#ARGV) {
    # print "$ARGV[$argnum]\n";
    my $filename = substr($ARGV[$argnum], 0, index($ARGV[$argnum], '.'));
    # print "$filename\n";
    push @filenames, $filename;
    # push @filenameswithext, $ARGV[$argnum]
}

# print "@filenames";

my @allinone;

# opening all files and adding their contents to arrays
foreach my $file (@filenames) {
  open(FILE_1, "<$file.txt") or die "Cannot open $file: $!";
  my @file = <FILE_1>;
  foreach (@file) {
    utf8::decode($_);
    # $_ =~ s/ //g;
  }
  close FILE_1;

  my $clusterfuck = join ' ', @file;
  my @allwordstf = split ' ', $clusterfuck;
  @$file = @allwordstf;

  # # making premapped hashes
  # $$file = { map { $_ => 1 } @$file };

  push @allinone, @file;
  next;
}

# making hash with counts for all words overall
# my %countdf;
# my $masterclusterfuck = join ' ', @allinone;
# my @allwordsdf = split ' ', $masterclusterfuck;
# foreach my $word (@allwordsdf){
#   $countdf{$word}++;
# }

foreach my $file (@filenames) {
  my %counttf;
  my %tfidfhash;

  # making hash with counts for all unique words in this one file
  # my $clusterfuck = join ' ', @$file;
  # my @allwordstf = split ' ', $clusterfuck;
  # foreach my $word (@allwordstf){
  foreach my $word (@$file){
    $counttf{$word}++;
  }

  # counting tf, idf and tfidf
  foreach my $word (@$file){
    my $allwords = @$file;
    my $tf = $counttf{$word}/$allwords;

    # print "occurences of word \"$word\" in file \"$file\" is $counttf{$word}\n";
    # print "all words in file \"$file\" is $allwords\n";

    # my $value_count = sum values %counttf;
    # if ($value_count=@$file){print "YES KURWA\n";}

    # print "TF for word \"$word\" in file \"$file\" is $tf\n";

    # $bunbo = $$file->{ $word };
    # print "word $word appears in $bunbo documents\n" if $bunbo>1;

    # my @founds;
    my $found=0;
    foreach $tempfilename (@filenames) {
      # my %hash = map {$_ => 1} @$tempfilename;
      $found++ if ($word ~~ @$tempfilename);
      # my $found = first { $_ eq $word } @$tempfilename;
      # push @founds, $found;
    }
    # $bunbo = @founds;
    # print "word $word appears in $found documents\n" if $found>1;

    my $allfiles = @filenames;

    # print "number of all files is $allfiles\n";

    my $idf = log($allfiles/$found);

    # print "IDF for word \"$word\" in file \"$file\" is $idf\n";

    my $tfidf = $tf*$idf;

    # print "TF-IDF for word \"$word\" in file \"$file\" is $tfidf\n\n";

    $tfidfhash{$word}=$tfidf;
  }
  open(FH, '>', "tfidf_$file.txt") or die $!;

  print FH "$_,$tfidfhash{$_}\n" for sort { $tfidfhash{$b} <=> $tfidfhash{$a} or $a cmp $b } keys %tfidfhash;
  close(FH);
}
