#!/usr/bin/env perl
#
#00ImplNotes_Code04-03.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_4
#          ./perl $ perl t/00ImplNotes_Code04-03.t
#
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default
#Notice: Trailing whitespace is present on some Textlines

use strict;
use warnings;

use Test::More tests=>2;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}

my ($haml,$tname,$htmloutput);


#================================================================
$tname = "ImplNotes Code 4-03: Motivation - Nex3 Issue 28 - Inconsistent indentation - Legacy Haml";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
throws_ok { $haml->render(<<'HAML')} 'Haml::SyntaxError','Inconsistent identation';
%foo
    up four spaces
  down two spaces
HAML
#Legacy Haml
#Inconsistent indentation: 2 spaces were used for indentation,
#    but the rest of the document was indented using 4 spaces.
#In WSE Haml, this spec should 'fail' because it will not raise the SyntaxError
#For WSE Haml spec, see next spec: Code 4-04

