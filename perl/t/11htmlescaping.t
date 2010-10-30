#!/usr/bin/env perl
#
#11htmlescaping.t
#./haml-wse-specs/perl/t
#
#Calling:  ./perl $ perl t/11htmlescaping.t
#          ./perl $ make htmlescaping
#
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default
#Notice: Trailing whitespace is present on some Textlines

# WSE extends consideration of document type to condition proper (X)HTML escaping.
#
# Note that WSE attempts to provide (X)HTML escaping that is well-formed.
# Haml is considered savvy, so it should produce savvy results.
#
# Proper (X)HTML escaping means two things:
# 1. Transformation of special characters into defined special entities
# 2. Idempotent (fixed-point) transform, s.t.:
#     a.  s.escape.escape == s.escape; which implies,
#     b.  s.transform.reversetransform == s
#
# RSpec 14doctype_spec.rb RSpecs the conditionals based on option:html and doctype
#
# When to use xhtml special entities (&apos;) or not (just the apostrophe):
#
#                FORMAT:OPTION:  HTML4|5       DEFAULT(xhtml)      XHTML
#                    -------------------       ----------------    -----
#   DOCTYPE  !!!              html401t|5       xhtml 1.0 trans      =
#            !!! 5            html401t|5       html5                =
#            !!! 1.1          html401t|5       xhtml 1.1            =
#            !!! Basic        html401t|5       xhtml b 1.1          =
#            !!! Strict       html401|5        xhtml 1.0 s          =
#            !!! XML          none|none        xmlencode(only)      =
#            none             none             none                 =
#
#To be clear about conflicting configuration, the rule is:
#   1. If you specify option:format=>html4:  you get html rules,
#   2. otherwise:                            you get xml rules (&apos;).
#
#                        FORMAT OPTION
#                        DEFAULTED     SPECIFIED
#                                      XHTML|5          HTML4
#                        ---------     ---------        -----
#   DOCTYPE
#        none(default)   xml           xml|xml          html
#        specified
#          unqual        xml           xml|xml          html
#          html5         xml           xml|xml          html
#          html4-type    xml           xml|xml          html
#          xml-type      xml           xml|xml          html
#

use strict;
use warnings;

use Test::More tests=>9;
use Test::Exception;

BEGIN {
# use lib qw(../../lib); 
  use_ok( 'Text::Haml' ) or die;
}
my ($haml,$tname,$htmloutput);


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -01- Enhanced to basic Idempotent transform";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p para1
%p= 'this & this < that but not &amp; that'
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<p>this &amp; this &lt; that but not &amp; that</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -02- doctype controlled, default xhtml";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML');
%p para1
%p= %q{this & this < that ' too, but not &amp; that.}
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<p>para1</p>
<p>this &amp; this &lt; that &apos; too, but not &amp; that.</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -03- doctype controlled, explicit HTML 5";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
!!! 5
%p para1
%p= %q{this & this < that ' too, but not &amp; that.}
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<!DOCTYPE html>
<p>para1</p>
<p>this &amp; this &lt; that &apos; too, but not &amp; that.</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -04- doctype controlled, explicit 1.1";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict' );
$htmloutput = $haml->render(<<'HAML' );
!!! 1.1
%p para1
%p= %q{this & this < that ' too, but not &amp; that.}
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<p>para1</p>
<p>this &amp; this &lt; that &apos; too, but not &amp; that.</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -05- doctype controlled, option:html4";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict',
                         format => 'html4' );
$htmloutput = $haml->render(<<'HAML' );
!!!
%p para1
%p= %q{this & this < that, but not ' and ' or &#x000A or &#39; or &amp;.}
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<p>para1</p>
<p>this &amp; this &lt; that, but not ' and ' or &#x000A; or &#39; or &amp;.</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -06- doctype controlled, option:html5, filter :escaped";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict',
                         format => 'html5' );
$htmloutput = $haml->render(<<'HAML' );
!!!
%p
  :escaped
    this & this < that, plus ' and ' not &#x000A or &#39; or &amp;.
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<!DOCTYPE html>
<p>
  this &amp; this &lt; that, plus &apos; and &apos; not &#x000A; or &#39; or &amp;.
</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -07- doctype controlled, option:html5, filter :escapehtml (WSE Alias)";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict',
                         format => 'html5' );
$htmloutput = $haml->render(<<'HAML' );
!!!
%p
  :escaped
    this & this < that, plus ' and ' not &#x000A or &#39; or &amp;.
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<!DOCTYPE html>
<p>
  this &amp; this &lt; that, plus &apos; and &apos; not &#x000A; or &#39; or &amp;.
</p>
<p>para2</p>
HTML
}#>>>>>TODO


TODO: {   #<<<<<
  local $TODO = " -- WSE Haml unimplemented";
#================================================================
$tname = "11HtmlEscaping -08- doctype controlled, option:html4, filter :escaped";
$haml = Text::Haml->new( escape_html => 1,
                         preserve => [ 'pre', 'textarea', 'code' ],
                         preformatted => [ 'ver' ],
                         oir => 'strict',
                         format => 'html4' );
$htmloutput = $haml->render(<<'HAML' );
!!!
%p
  :escaped
    this & this < that, but not ' and ' or &#x000A or &#39; or &amp;.
%p para2
HAML
is($htmloutput, <<HTML, $tname);
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<p>
  this &amp; this &lt; that, but not ' and ' or &#x000A; or &#39; or &amp;.</p>
<p>para2</p>
HTML
}#>>>>>TODO

