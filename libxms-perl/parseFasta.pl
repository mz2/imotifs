#!/usr/bin/perl

use WeightMatrix;
use Motif;
use MotifSet;

my $motiffile =$ARGV[0];
chomp($motiffile);

my $mt=0;
my @M="";
my $count=0;
my %mat;

my @mnum="";
my @matrix=();

my @header;
my $line2;
my @sym;
open(FP2,"$motiffile");  # Phylogibbs track output
while($line2=<FP2>){
    chomp($line2);
     if($line2=~/>/){
	 $name=substr($line2,1,length($line2));	 
	 $mt++;
	 $header = $name;
	 @matrix;     
	 $count=0;
     }else{
	 @num = split(" ", $line2);
	 
	 $matrix[$count] = [@num];
	 $mat{$header}=[@matrix];
	 $count++;     
}

}
print Dump %mat;

my @motif;

foreach my $r (sort(keys %mat)){
    #foreach my $q (0 .. $#{$mat{$r}}){

    
    $rows = WeightMatrix->new(@{$mat{$r}});

    $motif[$m] = Motif->new($rows,$r,0.0);
    print $motif[$m]->toXML(),"\n";
   # print $motif[$m]->toString(),"\n";
#    print $rows->toXML(),"\n";
#    print $rows->toString(),"\n";
#    print $rows->weightForSymbol("adenine",2);
 #   $rows->setWeightForSymbol("adenine",0,0.88);
  #  print $rows->toString(),"\n";
    $m++;
}

#$motifset = MotifSet->new(@motif);
#print $motifset->toXML(),"\n";
#print $motifset->toString(),"\n";

close FP2;

