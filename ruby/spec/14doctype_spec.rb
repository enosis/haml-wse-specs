#14doctype_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/14doctype_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#
#See also: htmlescaping_spec.rb more directly focuses on forms and
# results of html escapes
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines

=begin rdoc

 WSE extends consideration of document type to condition proper (X)HTML escaping.

 Note that WSE attempts to provide (X)HTML escaping that is well-formed. 
 Haml is considered savvy, so it should produce savvy results.

 Proper (X)HTML escaping means two things:
 1. Transformation of special characters into defined special entities
 2. Idempotent (fixed-point) transform, s.t.:
     a.  s.escape.escape == s.escape; which implies,
     b.  s.transform.reversetransform == s

 The Idempotent transform is RSpec'd in htmlescaping_spec.rb; 
 doctype_spec.rb RSpecs the conditionals based on option:html and doctype

 When to use xhtml special entities (&apos;) or not (just the apostrophe):

                FORMAT:OPTION:  HTML4|5       DEFAULT(xhtml)      XHTML
                    -------------------       ----------------    -----
   DOCTYPE  !!!              html401t|5       xhtml 1.0 trans      =
            !!! 5            html401t|5       html5                =
            !!! 1.1          html401t|5       xhtml 1.1            =
            !!! Basic        html401t|5       xhtml b 1.1          =
            !!! Strict       html401|5        xhtml 1.0 s          =
            !!! XML          none|none        xmlencode(only)      =
            none             none             none                 =

To be clear about conflicting configuration, the rule is:
   1. If you specify option:format=>html4:  you get html rules, 
   2. otherwise:                            you get xml rules (&apos;).

                        FORMAT OPTION
                        DEFAULTED     SPECIFIED
                                      XHTML|5          HTML4
                        ---------     ---------        -----
   DOCTYPE
        none(default)   xml           xml|xml          html
        specified   
          unqual        xml           xml|xml          html
          html5         xml           xml|xml          html
          html4-type    xml           xml|xml          html
          xml-type      xml           xml|xml          html          

=end

#================================================================
describe HamlRender, "-01- Doctype" do
  it "Simple case - option:default - no doctype" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= "proper & ' yes ' no &amp;"
HAML
      wspc.html.should == <<HTML
<p>proper &amp; &apos; yes &apos; no &amp;</p>
HTML
    end
  end
end
#Legacy:
#<p>proper &amp; ' yes ' no &amp;amp;</p>


#================================================================
describe HamlRender, "-02- Doctype" do
  it "Simple case - option:default - doctype !!!" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
!!!
%p= "proper & ' yes ' no &amp;"
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<p>proper &amp; &apos; yes &apos; no &amp;</p>
HTML
    end
  end
end
#Legacy Haml:
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
#<p>proper &amp; ' yes ' no &amp;amp;</p>



#================================================================
describe HamlRender, "-03- Doctype" do
  it "Simple case - option:xhtml - doctype !!! 1.1" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' ,
                 :format => :xhtml }
      wspc.render_haml( <<'HAML', h_opts )
!!! 1.1
%p= "proper & ' yes ' no &amp;"
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<p>proper &amp; &apos yes &apos; no &amp;</p>
HTML
    end
  end
end
#Legacy Haml:
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
#<p>proper &amp; ' yes ' no &amp;amp;</p>


#================================================================
describe HamlRender, "-04- Doctype" do
  it "Simple case - option:html4 - doctype !!!" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' ,
                 :format => :html4 }
      wspc.render_haml( <<'HAML', h_opts )
!!!
%p= "proper & ' no ' no &amp;"
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<p>proper &amp; ' no ' no &amp;</p>
HTML
    end
  end
end
#Legacy Haml
#<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
#<p>proper &amp; ' no ' no &amp;amp;</p>

