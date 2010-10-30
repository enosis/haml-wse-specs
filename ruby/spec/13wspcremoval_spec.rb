#13wspcremoval_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/13wspcremoval_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines


#================================================================
describe HamlRender, "-01- Whitespace Removal" do
  it "Simple case - Interior (trim_in)" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%spam
  %eggs<
    %p
      Foo!
HAML
      wspc.html.should == <<HTML
<spam>
  <eggs><p>
    Foo!
  </p></eggs>
</spam>
HTML
    #end
  end
end
#Notice: Although 'trim_in' shifts the immediate child tag (and its inline 
# content), that child's nested content obtains the OutputIndent with 
# respect to the HtmlOutput indentation of 'effective' leading tag
# -- in this case, the <eggs> element. (Yes, obvious, but the principle
# will also apply to a small adjustment to the case of interpolation with
# newlines.)


#================================================================
describe HamlRender, "-02- Whitespace Removal" do
  it "Simple case - Interior (trim_in) -- indented" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
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
    end
  end
end
#BUG: After applying 'trim_in', indentation of the remaining plaintext of a 
#  content block should retain its 'natural' (without trim_in) indentation
#  (which would include any applicable whitespace).
#      <p>
#        Foo!
#        Bar!
#      </p>


#================================================================
describe HamlRender, "-03- Whitespace Removal" do
  it "Simple case - Exterior (trim_out) -- indented" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
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
      wspc.html.should == <<HTML
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
    #end
  end
end
#Notice: Regardless of 'trim_out', content block gets its otherwise
# 'natural' HtmlOutput OutputIndent


#================================================================
describe HamlRender, "-04- Whitespace Removal" do
  it "Simple case - Exterior -- Bug in HtmlOutput endtag indentation" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%gork
  %out
    %div>
      %in
        Foo!
HAML
      wspc.html.should == <<HTML
<gork>
  <out><div>
      <in>
        Foo!
      </in>
  </div></out>
</gork>
HTML
    end
  end
end
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


#================================================================
describe HamlRender, "-05- Whitespace Removal" do
  it "Simple case - Interior+Exterior -- indented" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bork
  %zork
    %p para1
    #n1><
      %p
        Fodo!
        Blarg.
    %p para3
HAML
      wspc.html.should == <<HTML
<bork>
  <zork>
    <p>para1</p><div id='n1'><p>
      Fodo!
      Blarg.
    </p></div><p>para3</p>
  </zork>
</bork>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-06- Whitespace Removal" do
  it "Simple case - Interior -- Expression" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%toto
  %tutu
    %p para1
    %p<= "Foo\nBar"
    %p para3
HAML
      wspc.html.should == <<HTML
<toto>
  <tutu>
    <p>para1</p>
    <p>Foo
      Bar</p>
    <p>para3</p>
  </tutu>
</toto>
HTML
    end
  end
end
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


#================================================================
describe HamlRender, "-07- Whitespace Removal" do
  it "With HereDoc" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
   %p<<<-DOC
  HereDoc Para
   DOC
HAML
      wspc.html.should == <<HTML
<foo>
  <p>  HereDoc Para</p>
</foo>
HTML
    end
  end
end
