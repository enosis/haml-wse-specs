#!/usr/bin/env perl
#
#00ImplNotes_Code09_02-01.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ make code_9
#       :  ./perl $ make code_9_2
#          ./perl $ perl t/00ImplNotes_Code09_02-01.t
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


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "ImplNotes Code 9.2-01 - Heads:HamlComment: Lexeme BOD";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => ['pre', 'textarea', 'code'],
                         preformatted => ['ver'],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
.zork
  %p para1
  -# Haml Comment Inline
  %p para2
.gork
  %p para1
  -#
     WSE Haml Comment Nested
  %p para2
HAML
is($htmloutput, <<'HTML', $tname);
<div class='zork'>
  <p>para1</p>
  <p>para2</p>
</div>
<div class='gork'>
  <p>para1</p>
  <p>para2</p>
</div>
HTML
#Legacy Haml:
# Haml::SyntaxError,
# /Inconsistent indentation:.*spaces.*used for indentation, but.*rest.*doc.* using 4 spaces/
#WSE Haml:
# Notice: "Pending WSE" because the Comment designated as
# "WSE Haml Comment..." would, in legacy Haml have to be
# indented one (document-wide fixed) IndentStep from
# the '-' in '-#' ... typically two spaces, and could not
# be aligned as shown (or easily inserted above text an
# author wants to make transparent).
}#TODO>>>>>

