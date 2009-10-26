package WeightMatrix;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# This allows declaration	use XMS ':all';

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

use XML::Writer;
use XML::Writer::String;
use IO::File;
use UNIVERSAL qw(isa);

sub new {
    my $self = {};
    my($class,@name) = @_;
    $self->{alphabet} = "DNA";
   
    $self->{cols} = \@name;
   
    $self->{xmlString} = "";
    $self->{output} =  XML::Writer::String->new();
    $self->{writer} = new XML::Writer(OUTPUT => $self->{output}, DATA_MODE => 'TRUE', DATA_INDENT=>3);

    $self->{rawstring} = "";


    bless($self,$class);
    
    return $self;
}


sub toXML {

    my $self = shift;
    my $useLocalXMLWriter = 1;
    my $xmlString = $self->{xmlString};
    
    if($xmlString eq ""){

	my $writer = $self->{writer};
	my $output = $self->{output};
	
	my ($wr) = @_;  
	if( @_ && (ref($wr) eq "XML::Writer")){
	    $writer = $wr;
	    $useLocalXMLWriter = 0;   
	}
	
	my $alphabet = $self->{alphabet};
	my @columns = @{$self->{cols}};
   
	my $length = @columns;

	$writer->startTag("weightmatrix", 'alphabet'=>$alphabet, 'columns'=>$length);
    	
	my $symbol;

	for my $c (0 .. $#columns){
	    
	    $writer->startTag("column", 'pos'=>$c);
	    
	    for (my $s=0;$s<@{$columns[$c]};$s++){
	    
		if($s==0){
		    $symbol = "adenine";
		    $writer->startTag("weight", 'symbol'=>$symbol);
		    $writer->characters($columns[$c][$s]);
		    $writer->endTag("weight");
		}elsif($s==1){
		    $symbol = "cytosine";
		    $writer->startTag("weight", 'symbol'=>$symbol);
		    $writer->characters($columns[$c][$s]);
		    $writer->endTag("weight");
		}elsif($s==2){
		    $symbol = "guanine";
		    $writer->startTag("weight", 'symbol'=>$symbol);
		    $writer->characters($columns[$c][$s]);
		    $writer->endTag("weight");
		}elsif($s==3){
		    $symbol = "thymine";
		    $writer->startTag("weight", 'symbol'=>$symbol);
		    $writer->characters($columns[$c][$s]);
		    $writer->endTag("weight");
		}
		
	    }

	    $writer->endTag("column");
	}   
 
	$writer->endTag("weightmatrix");
	
	if($useLocalXMLWriter == 1 ) {
	    $writer->end();
	    $xmlString = $self->{output}->value();
	} 
    }
    return $xmlString;
}


sub toString {

    my $self = shift;
    my $rawstring = $self->{rawstring};
    
    if($rawstring eq ""){
	
	my @columns = @{$self->{cols}};
	
	my $length = @columns;
	my $sep = "";
	for my $c (0 .. $#columns){
	    
	    $rawstring = $rawstring . $sep. "@{$columns[$c]}";
            $sep = "\n";
        }
    }
    return $rawstring;
}


sub weightForSymbol {

    my $self = shift;    
    my($symbol,$rowindex) = @_;

    my @columns = @{$self->{cols}};
    my $weight;
    
    
    for my $c (0 .. $#columns){
	if($c == $rowindex){
	
	    my @dna = ("adenine", "cytosine", "guanine", "thymine");

            for (my $s=0;$s<@dna;$s++){
		if($dna[$s] eq "$symbol"){
		    $weight = $columns[$c][$s];
		}
	    } 
	}
    }
    return $weight;
}


sub setWeightForSymbol {
    
    my $self = shift;    
    my($key,$rowindex,$weight)=@_;
    
   
    my @columns = @{$self->{cols}};
    
    for my $c (0 .. $#columns){
	
        if($c == $rowindex){
            my @dna = ("adenine", "cytosine", "guanine", "thymine");
	    
            for (my $s=0;$s<@dna;$s++){
                if($dna[$s] eq "$key"){
		    $columns[$c][$s]=$weight;
		    $self->{rawstring} = "";
		    $self->{xmlString} = "";
                }
            }
        }
    }                         

}


    
# Preloaded methods go here.

1;
__END__


# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

WeightMatrix - Perl extension for creating weightmatrices for DNA motifs in XMS format


=head1 SYNOPSIS

  use WeightMatrix;
  my $wm = Weightmatrix->new(@matrix);   # @matrix is reference to array of arrays
  $wm->toXML();                          # wm is weightmatrix is xms format
  $wm->toString();                       # wm is weightmatrix is string/raw format
  $wm->WeightForSymbol("adenine",rowindex) # Get weight for "adenine" residue at row number rowindex
  $wm->setWeightForSymbol("adenine",rowindex,weight) # Set weight for "adenine" residue at row number rowindex


=head1 DESCRIPTION

The WeightMatrix package can be used to create the XMS format for a given position weight matrix. It can also be sued to obtain weights or to set ne weights.


=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUHTOR

Harpreet Saini, hsaini@ebi.ac.uk

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by hsaini

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
