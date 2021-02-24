#!/usr/bin/perl -w
use strict;

die "Usage: perl $0 <genes_copynum> <meta_microbiota_percentage>" unless @ARGV==2;
open ME, "$ARGV[1]"or die"$ARGV[1] $!\n";
open IN,"$ARGV[0]"or die"$ARGV[0] $!\n";
open OUT, ">gene_relative_copynum.txt" or die;

my %hash;
#my %hash1;
#my @data1;
#my @data2;
#my $rowname1;
#my @rowname2;
#my $sp_id;
my @c;
#my $i;
#my $c;

my $line=<ME>;
chomp $line;
my @colname=split(/\s+/,$line);
my @removed = splice @colname, 0, 1;
$"="\t";
print OUT "gene_id|species_id|ko_id\t@colname\n";

#readline ME;
while (<ME>) {
	chomp;
	my @data1 =split /\s+/,$_;
	my $rowname1 = $data1[0];
	$hash{$rowname1}= $_;
}
readline IN;
while (<IN>){
	chomp;
	my @data2 = split /\s+/,$_;
	my @rowname2 = split /\|/,$data2[0];
#	$sp_id = $rowname2[1];
#	$hash1{$data2[0]} = $rowname2[1];
	if (exists $hash{$rowname2[1]}){
#		for ($i=1;$i<=175;$i++){
#			$c[$i]=0;
#			$c[$i] = $data1[$i]+$data2[$i];
#		@c = map {$data1[$_]*$data2[$_]}1..$#data2;
		my @data1=split /\s+/,$hash{$rowname2[1]};
		my @c;
		foreach my $i (1..$#data2){                                                                                                                         
		my($data1,$data2)=($data1[$i], $data2[$i]);
#		print "$data1\t$data2\n";
		push @c,$data1 * $data2;		
		}
#		print "@c\n";
#		}
	$"="\t";
	print OUT "$data2[0]\t@c\n";
#	$hash1{$data2[0]} = @c;

	}

}
#my $key;
#my $value;
#while (($key, $value) = each %hash1){
#	$"="\t";
#	print OUT "$key\t$value\n";
#}

close IN;
close ME;
close OUT;
