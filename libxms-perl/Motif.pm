package Motif;

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



sub new {

    my $self = {};
    my($class,$weightmatrix,$name,$threshold,%prop) = @_;
    $self->{name} = $name;
    $self->{weightmatrix} = $weightmatrix;
    $self->{threshold} = 0.0;
    %{$self->{annotations}} = %prop;
    
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

    my $writer = $self->{writer};
    my $output = $self->{output};

    my ($wr) = @_;
    if( @_ && (ref($wr) eq "XML::Writer")){
	$writer = $wr;
	$useLocalXMLWriter = 0;
    }

    my $motifname = $self->{name};
    my $threshold = $self->{threshold};

    ##### Begin motif element here #######
    
    $writer->startTag("motif");
    $writer->startTag("name");
    $writer->characters($motifname);
    $writer->endTag("name");

    ###### Begin writing weightmatrix #######
   
    $self->{weightmatrix}->toXML($writer);
    
    ###### Ends weightmatrix ###############
    
    $writer->startTag("threshold");
    $writer->characters($threshold);
    $writer->endTag("threshold");

    ###### Begin writing annotation property set ######
    my %annotations = %{$self->{annotations}};
    while ((my $key,my $value) = each(%annotations)){
	$writer->startTag("prop");
        $writer->startTag("key");
        $writer->characters($key);
        $writer->endTag("key");
        $writer->startTag("value");
        $writer->characters($value);
        $writer->endTag("value");
        $writer->endTag("prop");
    }
    ###### End writing annotation property set ###### 
    
    $writer->endTag("motif");

    if($useLocalXMLWriter == 1 ) {
	$writer->end();
	$xmlString = $self->{output}->value();
    }

    return $self->{output}->value();
}


sub toString {

    my $self = shift;
    my $name = $self->{name};
    my $rawstring = $name; 

    my %annotations = %{$self->{annotations}};
    while ((my $key,my $value) = each(%annotations)){
	
	if($key && $value){
	    $rawstring = $rawstring.";".$key.":".$value;
	}
    }

    $rawstring = $rawstring. "\n". $self->{weightmatrix}->toString();
    return $rawstring;
}

# Preloaded methods go here.

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Motif - Perl extension for creating DNA motifs in XMS format

=head1 SYNOPSIS

  use Motif;

 my $motif = Motif->new($wm,$name,$threshold)   # $wm is weightmatrix, $name is name of the motif and $threshold is the threshold values.
 $motif->toXML()         # Create motifs in XMS format
 $motif->toString()      #  Create motifs in string/xms format



=head1 DESCRIPTION

The Motif package can be used to crrate the XMS format for a given set of motifs, their asscoiated weightmatrices and threshold values.


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
