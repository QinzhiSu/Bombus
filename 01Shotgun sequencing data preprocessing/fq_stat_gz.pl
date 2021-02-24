#! usr/bin/perl -w
use strict;

die "Usage: perl $0 <reads.fq> <.....> Or <reads.fq.gz> <.....>\n" unless(@ARGV>=1);

my ($seq, $total, $eff, $num, $reads, $gc, $gc_con);
print "\t\t\tReadNum\t\tTotalLen\tEffectiveLen\tGC content\n";
foreach my $k(0..$#ARGV){
    $total=0;
    $eff=0;
    $num=0;
	$gc = 0;
    $reads=$ARGV[$k];
    print "$reads\t";

###############################
	if ($reads =~ /gz$/){
        	open IN, "gzip -dc $reads |" || die "$!\n";
	} else {
        	open IN, "<$reads" || die "$!\n";
	}
##############################

#    open IN,"$reads" or die "$!\n";
    while(<IN>){
        chomp;
        my $id=$_;
	chomp($seq=<IN>);
        $total+=length($seq);
        $seq=~s/N//g;
        $eff+=length($seq);
	$gc += ($seq=~tr/GC/GC/);
        $num++;
	my $null=<IN>;
	$null = <IN>;
    }
	$gc_con = $gc / $eff;
    print "\t$num\t$total\t$eff\t$gc_con\n";
    close IN;
}
