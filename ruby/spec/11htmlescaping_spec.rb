#11htmlescaping_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/11htmlescaping_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#
#See also: doctype_spec.rb more directly focuses on interaction
# of option:format and !!! for mode of escaping
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

 The impotence is RSpec'd in htmlescaping_spec.rb; 
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
describe HamlRender, "-01- Html Escaping" do
  it "Enhanced to basic Idempotent transform" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1
%p= 'this & this < that but not &amp; that'
%p para2
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<p>this &amp; this &lt; that but not &amp; that</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================'
describe HamlRender, "-02- Html Escaping" do
  it "doctype controlled - default xhtml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1
%p= %q{this & this < that ' too, but not &amp; that.}
%p para2
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<p>this &amp; this &lt; that &apos; too, but not &amp; that.</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================'
describe HamlRender, "-03- Html Escaping" do
  it "doctype controlled - explicit HTML 5" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
!!! 5
%p para1
%p= %q{this & this < that ' too, but not &amp; that.}
%p para2
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html>
<p>para1</p>
<p>this &amp; this &lt; that &apos; too, but not &amp; that.</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================'
describe HamlRender, "-04- Html Escaping" do
  it "doctype controlled - explicit 1.1" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
!!! 1.1
%p para1
%p= %q{this & this < that ' too, but not &amp; that.}
%p para2
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<p>para1</p>
<p>this &amp; this &lt; that &apos; too, but not &amp; that.</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================'
describe HamlRender, "-05- Html Escaping" do
  it "doctype controlled - option:html4" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict',
                 :format => :html4 }
      wspc.render_haml( <<'HAML', h_opts )
!!!
%p para1
%p= %q{this & this < that, but not ' and ' or &#x000A or &#39; or &amp;.}
%p para2
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<p>para1</p>
<p>this &amp; this &lt; that, but not ' and ' or &#x000A; or &#39; or &amp;.</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-06- Html Escaping" do
  it "doctype controlled - option:html5 - filter :escaped" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict',
                 :format => :html5 }
      wspc.render_haml( <<'HAML', h_opts )
!!!
%p
  :escaped
    this & this < that, plus ' and ' not &#x000A or &#39; or &amp;.
%p para2
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html>
<p>
  this &amp; this &lt; that, plus &apos; and &apos; not &#x000A; or &#39; or &amp;.
</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-07- Html Escaping" do
  it "doctype controlled - option:html5 - filter :escapehtml (WSE Alias) -- WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict',
                 :format => :html5 }
      wspc.render_haml( <<'HAML', h_opts )
!!!
%p
  :escaped
    this & this < that, plus ' and ' not &#x000A or &#39; or &amp;.
%p para2
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html>
<p>
  this &amp; this &lt; that, plus &apos; and &apos; not &#x000A; or &#39; or &amp;.
</p>
<p>para2</p>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-08- Html Escaping" do
  it "doctype controlled - option:html4 - filter :escaped" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict',
                 :format => :html4 }
      wspc.render_haml( <<'HAML', h_opts )
!!!
%p
  :escaped
    this & this < that, but not ' and ' or &#x000A or &#39; or &amp;.
%p para2
HAML
      wspc.html.should == <<HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<p>
  this &amp; this &lt; that, but not ' and ' or &#x000A; or &#39; or &amp;.</p>
<p>para2</p>
HTML
    end
  end
end
