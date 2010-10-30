#02initialwspc_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/02initialwspc_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

def expr1(arg = "expr1arg" )
  "__" + arg + "__"
end

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines


#================================================================
describe HamlRender, "-01- Initial Whitespace:" do
  it "haml_indent - Inline and Nested" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= haml_indent.length
%p
  = haml_indent.length
  More Text
.foo
  %p
    = haml_indent.length
HAML
      wspc.html.should == <<HTML
<p>2</p>
<p>
  2
  More Text
</p>
<div class='foo'>
  <p>
    4
  </p>
</div>
HTML
  end
end
#From the operator name you might think this would yield lengths 
#wrt HamlSource, as in:
#  "<p>0</p>\n<p>\n  2\n  More Text\n</p>\n"
#Or that it refers to indentation index for the <p> or it's content.
#
#Instead, it is querying an attribute of the buffer instance -- the current 
#setting. So as is clear above, it is of utility for one specific operation: 
#it returns the string that will be used _when_ OutputIndent is deemed to
#be required ... not necessarily as will actually be used for rendering
#the then-current line to HtmlOutput.
#WSE proposes rename: html_indent


#================================================================
describe HamlRender, "-02- Initial Whitespace:" do
  it "html_indent alias for haml_indent - Inline and Nested" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p= html_indent.length
%p
  = html_indent.length
  Even More Text
.foo
  %p
    = html_indent.length
HAML
      wspc.html.should == <<HTML
<p>2</p>
<p>
  2
  Event More Text
</p>
<div class='foo'>
  <p>
    4
  </p>
</div>
HTML
    end
  end
end
#WSE proposed alias for haml_indent


#================================================================
describe HamlRender, "-03- Initial Whitespace:" do
  it "html_tabs and html_tabstring WSE proposed functions" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
- foo = html_tabs
- bar = html_tabstring
%p= foo
%p= bar
%p= html_indent.length
- baz = html_tabstring('..')
%dir
  %p
    Nested text
HAML
      wspc.html.should == <<HTML
<p>1</p>
<p>  </p>
<p>2</p>
<dir>
..<p>
....Nested text
..</p>
</dir>
HTML
    end
  end
end
#WSE proposed operators (see also tab_up, tab_down, with_tabs)
# html_tabstring is get/set
#The then-current count of "tabs" used for the OutputIndent
#The html_tabstring is the OutputIndentStep, typically = 2 spaces
# html_tabstring * html_tabs = OutputIndent


#================================================================
describe HamlRender, "-04- Initial Whitespace:" do
  it ":preserve filter - simple 2-space IndentStep - Legacy Haml" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
.txt1
  %p para1
  %p
    :preserve
       This
           is a fish
        of some kind
         never before seen here
  %code
    :preserve
       This
           is a fish
        of some kind
         never before seen here
  %p
    %code= " This\n    is a fish\n of some kind\n  never before seen here"
HAML
      wspc.html.should == <<HTML
<div class='txt1'>
  <p>para1</p>
  <p>
     This&#x000A;     is a fish&#x000A;  of some kind&#x000A;   never before seen here
  </p>
  <code> This&#x000A;     is a fish&#x000A;  of some kind&#x000A;   never before seen here</code>
  <p>
    <code> This&#x000A;    is a fish&#x000A; of some kind&#x000A;  never before seen here</code>
  </p>
</div>
HTML
    end
  end
end
#BUG: The nit here, in legacy Haml, does not concern :preserve, but rather
# concerns dropping leading whitespace in =expr. Shown as expected here is 
# the WSE Haml correction, for comparison.
#WSE Haml retains the behavior of :preserve of using a 'fixed' indent,  
# set by the Element's Head IndentStep, to calculate the initial/leading 
# whitespace for the contained contentblock


#================================================================
describe HamlRender, "-05- Initial Whitespace:" do
  it ":preformatted filter - simple 2-space IndentStep - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver', 'vtag'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
.txt1
  %p para1
  %p.wspcpre#prfmttd
    :preformatted
       This
           is a fish
        of some kind
         never before seen here
  %vtag
    :preformatted
       This
           is a fish
        of some kind
         never before seen here
  %p
    %vtag= " This\n    is a fish\n of some kind\n  never before seen here"
HAML
      wspc.html.should == <<HTML
<div class='txt1'>
  <p>para1</p>
  <p id='prfmttd' class='wspcpre'>
     This
         is a fish
      of some kind
        never before seen here
  </p>
  <vtag>
 This
     is a fish
  of some kind
   never before seen here
  </vtag>
  <p>
    <vtag> This&#x000A    is a fish&#x000A  of some kind&#x000A;   never before seen here</vtag>
  </p>
</div>
HTML
    end
  end
end
#WSE Haml: 
#Notice: %vtag is option:preformatted (similar to 'pre')
#Notice: Of course that <p id='prfmttd'> element won't render in the
# UA as 'preformatted' unless the author provides the appropriate CSS.
#See the RSpec for preformatted


#================================================================
describe HamlRender, "-06- Initial Whitespace:" do
  it "with tab_up()" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p
   ptext
- tab_up(1)
%p
   pt2
   .one
      .two
         %pre= expr1(haml_indent)
%p pt3
%p
   pt4
HAML
      wspc.html.should == <<'HTML'
<p>
  ptext
</p>
  <p>
    pt2
    <div class='one'>
      <div class='two'>
        <pre>__        __</pre>
      </div>
    </div>
  </p>
  <p>pt3</p>
  <p>
    pt4
  </p>
HTML
  end
end
#haml_indent is counting the number of IndentSteps in
#the HamlSource, i, (here: i=3, at three spaces each) which 
#is the multiples of OutputIndentStep (two spaces) to apply.
#For haml_indent, then the result is i=3, plus 1 for tab_up(1), 
#4 total. 4 Times 2 = 8. (More rationally: 9 spaces in haml_indent,
#in the HamlSource, and 8 spaces in html_indent, in the HtmlOutput.)
#Also: When WSE Haml, the s/haml_indent/html_indent/g


#================================================================
describe HamlRender, "-07- Initial Whitespace:" do
  it "with with_tabs()" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p
   ptext
%dir
   - with_tabs(3) do
      %p
         SomeText
         %p
            IndentText
            %pre= expr1(html_indent)
         MoreText
         - foo = html_tabs
         %p= foo
%p
   pt2
.blk2
   %p
      = html_indent.length
   - with_tabs(html_indent.length) do
      %p
         SomeText
         %p
            IndentText
            %pre= expr1(html_indent)
         MoreText
         %p EasyText
HAML
      wspc.html.should == <<HTML
<p>
  ptext
</p>
<dir>
      <p>
        SomeText
        <p>
          IndentText
          <pre>__          __</pre>
        </p>
        MoreText
        <p>3</p>
      </p>
</dir>
<p>
  pt2
</p>
<div class='blk2'>
  <p>
    4
  </p>
    <p>
      SomeText
      <p>
        IndentText
        <pre>__        __</pre>
      </p>
      MoreText
      <p>EasyText</p>
    </p>
</div>
HTML
    end
  end
end
#Notice that the OutputIndent is, simply, the number given
#times the size of the OutputIndentStep (legacy:2). So, here,
#the <p> in HtmlOutput is at column index 6, and the haml_indent
#expression (WSE Haml: html_indent) is two IndentSteps
#from there, so plus 4 = 10. 


#================================================================
describe HamlRender, "-08- Initial Whitespace:" do
  it "Tabs as initial whitespace" do
    #pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<"HAML", h_opts )
%div
\t\t%p
\t\t\t\tpara1
HAML
      wspc.html.should == <<HTML
<div>\n  <p>\n    para1\n  </p>\n</div>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-09- Initial Whitespace:" do
  it "Inline expression with newline -- initial and leading" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  %p= "  foo\n   bar"
HAML
      wspc.html.should == <<HTML
<zot>
  <p>  foo
       bar
  </p>
</zot>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-10- Initial Whitespace:" do
  it "Inline expression with newline in local var" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :strvar => "  foo\n   bar" )
%spike
  %p para
  %p #{strvar}
HAML
      wspc.html.should == <<HTML
<spike>
  <p>para</p>
  <p>  foo
       bar
  </p>
</spike>
HTML
    end
  end
end

