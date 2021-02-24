#!/usr/bin/perl -w
#use strict;

die "Usage: perl $0 <genes_copynum> <meta_gene_ko>" unless @ARGV==2;
open ME, "$ARGV[1]"or die"$ARGV[1] $!\n";
open IN,"$ARGV[0]"or die"$ARGV[0] $!\n";
open OUT, ">gene_relative_copynum_abundance.txt" or die;

my %hash;

my $line=<ME>;
chomp $line;
#my @colname=split(/\s+/,$line);
#my @removed = splice @colname, 0, 1;
#$"="\t";
print OUT "$line\n";

#readline <ME>;
while (<ME>) {
	chomp;
	my @data = split /\s+/,$_;
	my @rowname = split /\|/,$data[0];
	$hash{$rowname[2]} = $_;
}

readline IN;
while (<IN>) {
	chomp;
	my @data2 = split /\s+/,$_;
	my @rowname = split /\|/,$data2[0];
	if (exists $hash{$rowname[2]}){
		my @data1 = split /\s+/,$hash{$rowname[2]};
		my @c;
		foreach my $i (1..$#data2){
		my($data1,$data2)=($data1[$i], $data2[$i]);
		if($data1!=0){
		push @c,$data2/$data1;}
		else {push @c,0;}
		}
	$"="\t";
	print OUT "$data2[0]\t@c\n";
	}
}

close IN;
close ME;
close OUT;
