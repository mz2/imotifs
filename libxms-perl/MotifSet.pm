package MotifSet;

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
use WeightMatrix;
use Motif;
use XML::DOM;



sub new {

    my $self = {};
   
    my($class,@motifs) = @_;
   
   
    my ($temp) = @motifs;



    if(ref($temp) eq "Motif"){

    @{$self->{motifs}} = @motifs;
   # $self->{output} =  XML::Writer::String->new();
   # $self->{writer} = new XML::Writer(OUTPUT => $self->{output}, DATA_MODE => 'TRUE', DATA_INDENT=>3);

    }else{
	#$self->{xmlfile} = $temp;

	my $parser = new XML::DOM::Parser;
	my $doc = $parser->parsefile($temp);
	my $root = $doc->getDocumentElement();
	

	my @motifnodes = $root->getElementsByTagName("motif");
	if (scalar @motifnodes == 0){
	    die "Corrupt input XMS file";
	}
	
	my $m=0;
	my @motifarray=();

	foreach my $motif (@motifnodes){
	
    
	    my $motifname = $motif->getElementsByTagName("name")->item(0)->getFirstChild()->getData;
	    	    
	    my $threshold = $motif->getElementsByTagName("threshold")->item(0)->getFirstChild->getData;

	    my @props = $motif->getElementsByTagName("prop");
	 
           ####### Begin reading annotation key value pairs ##########
	    my %annotations;
	    foreach my $prop (@props){
		my ($keynode) = $prop->getElementsByTagName("key");
		my $key="";
		if ( $keynode->getFirstChild() ) {
		    $key = $keynode->getFirstChild()->getData;
		}
		my ($valuenode) = $prop->getElementsByTagName("value");
	 	my $value="";
		if ( $valuenode->getFirstChild() ) {
		    $value = $valuenode->getFirstChild()->getData;
		}
		if ( $key ne "" ){
		    $annotations{$key} = $value;
		}
	    }
	    ####### End reading annotation key value pairs ########## 
	    my @wmnodes = $motif->getElementsByTagName("weightmatrix");
	    my @columnsarray=();
	    foreach my $wmnode (@wmnodes) {

		

		my @columns=$motif->getElementsByTagName("column");

		my %columnhash;
		foreach my $column (@columns){
        
		   my @weights=$column->getElementsByTagName("weight");

		    foreach my $weight (@weights){
        
			my $weightsymbol = $weight->getAttributeNode("symbol");
			my $symbolvalue = $weightsymbol->getValue;
        
			my $weightvalue=$weight->getFirstChild->getData;

			$columnhash{$symbolvalue} = $weightvalue;
		    }
		   my $count=0;
		   my @wmvalues=();
		   foreach my $key (sort keys %columnhash){
		       $wmvalues[$count]=$columnhash{$key};
		       $count++;
		   }
		   push(@columnsarray,[@wmvalues]);
		}
	    }


	    my $wmobj = WeightMatrix->new(@columnsarray);
	    my $motifobj = Motif->new($wmobj,$motifname,$threshold,%annotations);
	    $motifarray[$m] = $motifobj;
	    $m++;
	}
	@{$self->{motifs}} = @motifarray;
    }
    $self->{output} =  XML::Writer::String->new();
    $self->{writer} = new XML::Writer(OUTPUT => $self->{output}, DATA_MODE => 'TRUE', DATA_INDENT=>3);

    bless($self,$class);
    return $self;
	    
}


sub toXML {

    my $self = shift;
    my $writer = $self->{writer};
    my $output = $self->{output};

    my @motifs = @{$self->{motifs}};


    $writer->startTag("motifset");
    for(my $m=0;$m<@motifs;$m++){    
	$self->{motifs}[$m]->toXML($writer);
    }

    $writer->endTag("motifset");

    $writer->end();
    return $self->{output}->value();
}


sub toString {

    my $self = shift;
    my @motifs = @{$self->{motifs}};

    my $rawstring = "";
   
    for(my $m=0;$m<@motifs;$m++){                                               
        $rawstring = $rawstring.$self->{motifs}[$m]->toString();
        if ($m<(@motifs-1)){
	    $rawstring = $rawstring."\n";
	}                            
    }
    return $rawstring;
}

# Preloaded methods go here.

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

MotifSet - Perl extension for creating Motifset for a given array of motifs

=head1 SYNOPSIS

  use MotifSet;

  my $motifset = MotifSet->new(@motif);   # @motif is an array of motifs
  $motifset->toXML();       # Creating motifset in xms format
  $motifset->toString();    # Creatin motifset in string format
  

=head1 DESCRIPTION

The MotifSet package is used to create motifset in XMS and string format from a given array of motifs.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Harpreet Saini, hsaini@ebi.ac.uk

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by hsaini

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
