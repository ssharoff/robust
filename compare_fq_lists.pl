#!/usr/bin/perl -w
#Serge Sharoff, University of Leeds, 2005
#the script compares two frequency lists and outputs the log-like rated list
use strict;
use Getopt::Long;
#binmode(STDOUT,":utf8");
my $fqname1='bnc-forms.num';
my $fqname2='';
my $log_odds=0;
my $threshold=15.13;  #following the conservative recommendation in Rayson et al 2004 (Cochran rule)
my $ignorezero=1;
my $latex=0;
my $reference=0;
my $simplified=0;
my $functionwords=0;
my $dreal=0;
my $creal=0;
my $cutoff=5;
my ($help,$autosize);
GetOptions ("1=s" => \$fqname1,"2=s" => \$fqname2, "functionwords=i" => \$functionwords, "a"  => \$autosize,  "dreal=i" => \$dreal, "creal=i" => \$creal, "ignorezero"  => \$ignorezero,  "latex"  => \$latex,  "min=i" => \$cutoff, "odds"  => \$log_odds,  "reference"  => \$reference,  "simplified"  => \$simplified, "threshold=i"  => \$threshold, "help"  => \$help);
die "A tool for comparing frequency lists from Fname2 against Fname1 (counts from the reference corpus)
Usage $0 -1 Fname -2 Fname2 [-f N] [-l] [-o] [-s] [-t N]
The format of frequency lists is either frq word OR rank frq word 
-a --autosize 
-c --creal N  the real size of the second corpus
-d --dreal N the real size of the second corpus
-f --functionwords N Do not count the top N most frequent words in L1 (50 is a good approximation)
-i --ignorezero Do not count words not occurring in the reference corpus
-l --latex Output a Latex table
-m --min N Ignore words less frequent than N in L2
-o --odds  Compute log-odds instead of loglikelihood (used by Marco Baroni)
-r --reference Working with a reference corpus, i.e. the frequency of c includes d
-s --simplified Only words and scores are output
-t --threshold N LL not less than N\n" if (!$fqname2) or $help;
binmode(STDOUT,":utf8");

my ($c,$wl1)=create_fq_list($fqname1,$functionwords);
my %wl1=%{$wl1};
$c=($creal) ? $creal : $c;
my ($d,$wl2)=create_fq_list($fqname2);
my %wl2=%{$wl2};
$d=($dreal) ? $dreal : $d;
undef my %g2;
$c=$c-$d if $reference;

my $cd=$c+$d;
my $rate=($d/$c);
my $out=sprintf "Comparing two corpora %s (%5.0f) vs %s (%5.0f)\n", $fqname1, $c, $fqname2, $d;
print STDERR $out;
print $out;
foreach (sort keys %wl2) {
#following Rayson's LLwizard from http://ucrel.lancs.ac.uk/llwizard.html
#the reference corpus is in the second column in the LL calculator
    my $a=$wl1{$_};
    my $b=$wl2{$_};
    next if ($b<$cutoff);
    if ($a) {
#	$b=$b*$rate;
	$a=$a-$b if $reference;
    } elsif ($ignorezero) {
	next;
    } else {
	$wl1{$_}=0;
	$a=0;
    };
    next if ($a<$cutoff);
    if ($log_odds) {
	$g2{$_}=ln($a) + ln($d-$b) - ln($b) - ln($d-$b); # log_odds_ratio
    } else {
	my $E1 = $c*($a+$b)/($cd);
	my $E2 = $d*($a+$b)/($cd);
	$g2{$_}=2*(($a*ln($a/$E1))+ (($b)? ($b*ln($b/$E2)) : 0)) if ($E1>0) and ($E2>0);
    }
}
my $i=0;
my $joinelt=($latex) ? "\&" : "\t";
my $endelt=($latex) ? "\\\\\n" : "\n";
print "Word$joinelt Frq1$joinelt Frq2$joinelt LL-score$endelt";
foreach (sort {$g2{$b} <=> $g2{$a}} keys %g2) {
utf8::upgrade($_);
    last if ($threshold) and ($g2{$_}<$threshold);  
    my $overused=($wl1{$_}<($wl2{$_}/$rate));
    if ($overused) {
	my @out= ($simplified) ? ($g2{$_}) : ($wl1{$_}, $wl2{$_}, $g2{$_});
	print $_;
	foreach (@out) {
		printf "$joinelt%5.0f", $_;
	};
	print $endelt;
    }
}
sub ln {
    return(($_[0]>0) ? log($_[0]) : 0)
}
sub create_fq_list {
    open(IN,$_[0]) or die "Cannot open $_[0]: $!\n";
    my $functionleft=$_[1];
    binmode(IN,":utf8");
    undef my %wl;
    my $totalfq=0;
    my ($fq,$lemma,$realfq);
    while (<IN>) {
	utf8::upgrade($_);
	if (($autosize) and (/corpus size: (\d+) tokens/)) {
	    $realfq=$1;
	} elsif ((($fq,$lemma)=/^\d+\s+([\d.]+)\s+(.+)/) or
	    ((($fq,$lemma)=/^\s*(\d+)\s(.+)/) and ($lemma=~/\w/)) or # for plain frq lists from uniq -c
	    ((($lemma,$fq)=/^(.+?)\t([\d.]+)/) and ($lemma=~/\w/))) { # for reversed lists
	    next if --$functionleft>=0;
	    $wl{$lemma}+=$fq;
	    $totalfq+=$fq;
	}
    }
    print STDERR "$_[0]: $totalfq\n";
    close(IN);
    $realfq=$totalfq unless $realfq;
    return($realfq,\%wl);
}
