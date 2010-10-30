#!/usr/bin/env perl
#
#13wspcremoval.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/13wspcremoval.t
#          ./perl $ make wspcremoval
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

use Test::More tests=>8;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


#================================================================
$tname = "13WspcRemoval -01- Simple case, Interior (trim_in)";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%spam
  %eggs<
    %p
      Foo!
HAML
is($htmloutput, <<HTML, $tname);
<spam>
  <eggs><p>
    Foo!
  </p></eggs>
</spam>
HTML
#Notice: Although 'trim_in' shifts the immediate child tag (and its inline
# content), that child's nested content obtains the OutputIndent with
# respect to the HtmlOutput indentation of 'effective' leading tag
# -- in this case, the <eggs> element. (Yes, obvious, but the principle
# will also apply to a small adjustment to the case of interpolation with
# newlines.)


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "13WspcRemoval -02- Simple case, Interior (trim_in) 0 Indented";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%eggs
  #n1
    #n1a
      %p<
        Foo!
        Bar!
      %p
        Baz!
    #n1b
HAML
is($htmloutput, <<HTML, $tname);
<eggs>
  <div id='n1'>
    <div id='n1a'>
      <p>Foo!
        Bar!</p>
      <p>
        Baz!
      </p>
    </div>
    <div id='n1b'></div>
  </div>
</eggs>
HTML
#BUG: After applying 'trim_in', indentation of the remaining plaintext of a
#  content block should retain its 'natural' (without trim_in) indentation
#  (which would include any applicable whitespace).
#      <p>
#        Foo!
#        Bar!
#      </p>
}#>>>>>TODO


#================================================================
$tname = "13WspcRemoval -03- Simple case, Exterior (trim_out) - Indented";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
#bac
  #n1
    #n1a
      %p>
        Foo!
        Bar!
      %p
        Baz!
    #n1b
HAML
is($htmloutput, <<HTML, $tname);
<div id='bac'>
  <div id='n1'>
    <div id='n1a'><p>
        Foo!
        Bar!
      </p><p>
        Baz!
      </p>
    </div>
    <div id='n1b'></div>
  </div>
</div>
HTML
#Notice: Regardless of 'trim_out', content block gets its otherwise
# 'natural' HtmlOutput OutputIndent


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "13WspcRemoval -04- Simple case, Exterior - Bug in HtmlOutput endtag indentation";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%gork
  %out
    %div>
      %in
        Foo!
HAML
is($htmloutput, <<HTML, $tname);
<gork>
  <out><div>
      <in>
        Foo!
      </in>
  </div></out>
</gork>
HTML
#Legacy:
#<gork>
#  <out><div>
#      <in>
#        Foo!
#      </in>
#    </div></out>
#</gork>
#BUG: the endtag couplet </div></out> should be symmetrically
# aligned with the starttag couplet <out><div>
}#>>>>>TODO


#================================================================
$tname = "13WspcRemoval -05- Simple case, Interior+Exterior - indented";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%bork
  %zork
    %p para1
    #n1><
      %p
        Fodo!
        Blarg.
    %p para3
HAML
is($htmloutput, <<HTML, $tname);
<bork>
  <zork>
    <p>para1</p><div id='n1'><p>
      Fodo!
      Blarg.
    </p></div><p>para3</p>
  </zork>
</bork>
HTML


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "13WspcRemoval -06- Simple case, Interior - Expression";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%toto
  %tutu
    %p para1
    %p<= "Foo\nBar"
    %p para3
HAML
is($htmloutput, <<HTML, $tname);
<toto>
  <tutu>
    <p>para1</p>
    <p>Foo
      Bar</p>
    <p>para3</p>
  </tutu>
</toto>
HTML
#Legacy:
#<toto>
#  <tutu>
#    <p>para1</p>
#    <p>Foo
#    Bar</p>
#    <p>para3</p>
#  </tutu>
#</toto>
#Minor legacy bug: Since newline is otherwise taken as nesting, the
# result of the expression should be (for non-preserve/preformatted
# Head) treated as Mixed Content which directs that the continued
# content be indented under the containing HtmlOutput element,
# with a single additional OutputIndentStep.
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "13WspcRemoval -07- With HereDoc";
$haml = Text::Haml->new( escape_html => 0,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
%foo
   %p<<<-DOC
  HereDoc Para
   DOC
HAML
is($htmloutput, <<HTML, $tname);
<foo>
  <p>  HereDoc Para</p>
</foo>
HTML
}#>>>>>TODO

