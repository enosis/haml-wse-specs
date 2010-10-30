#!/usr/bin/env perl
#
#10verticalwspc.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/10verticalwspc.t
#          ./perl $ make verticalwspc
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

use Test::More tests=>7;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


#================================================================
$tname = "10VerticalWspc -01- Single whiteline Removal";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p para1

%p para2

%p para3
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<p>para2</p>
<p>para3</p>
HTML


#================================================================
$tname = "10VerticalWspc -02- Single whiteline Removal";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%fruit
  apples
  oranges

%vege
  cucumbers
HAML
is($htmloutput, <<HTML, $tname);
<fruit>
  apples
  oranges
</fruit>
<vege>
  cucumbers
</vege>
HTML



TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "10VerticalWspc -03- Multiple trailing/leading (exterior) whiteline Consolidation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%starch potatoes


%fruit
  apples
  oranges



%vege
  cucumbers
HAML
is($htmloutput, <<HTML, $tname);
<starch>potatoes</starch>

<fruit>
  apples
  oranges
</fruit>

<vege>
  cucumbers
</vege>
HTML
}#>>>>>TODO


#================================================================
$tname = "10VerticalWspc -04- Multiple interior whiteline Consolidation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%fruit
  apples


  oranges

%vege
  cucumbers
HAML
is($htmloutput, <<HTML, $tname);
<fruit>
  apples

  oranges
</fruit>
<vege>
  cucumbers
</vege>
HTML


#================================================================
$tname = "10VerticalWspc -05- Multiple interior whiteline Consolidation - Whitespace Removal Inside <";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%fruit<
  apples


  oranges

%vege
  cucumbers
HAML
is($htmloutput, <<HTML, $tname);
<fruit>apples
oranges</fruit>
<vege>
  cucumbers
</vege>
HTML


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "10VerticalWspc -06- Multiple interior whiteline Consolidate - Whitespace Removal Outside >";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%fruit
  apples


  oranges


%vege>
  cucumbers
HAML
is($htmloutput, <<HTML, $tname);
<fruit>
  apples

  oranges

</fruit><vege>
  cucumbers
</vege>
HTML
#Legacy Bug/nit: trim_out on last Element results in
#  removal of fragment/file-ending newline
}#>>>>>TODO

