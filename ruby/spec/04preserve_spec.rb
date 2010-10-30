#04preserve_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/04preserve_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines

#Preserve: observes Offside, requires OIR, 
#Replays all whitespace: initial, leading, interior, trailing 


#================================================================
describe HamlRender, "-01- Preserve:" do
  it "%p Inline Content" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p Inline Paragraph Text  
HAML
      wspc.html.should == <<HTML
<p>Inline Paragraph Text</p>
HTML
  end
end
#For reference


#================================================================
describe HamlRender, "-02- Preserve:" do
  it "%p Nested Content" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p 
  Nested Paragraph Text  
HAML
      wspc.html.should == <<HTML
<p>\n  Nested Paragraph Text\n</p>
HTML
  end
end
#For reference


#================================================================
describe HamlRender, "-03- Preserve:" do
  it "%p Constant Nesting in plaintext content" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p 
  Nested Para Text1  
  Nested Para Text2  
  Nested Para Text3  
HAML
      wspc.html.should == <<HTML
<p>\n  Nested Para Text1\n  Nested Para Text2\n  Nested Para Text3\n</p>
HTML
  end
end
#The trailing spaces on the plaintext lines are removed.


#================================================================
describe HamlRender, "-04- Preserve:" do
  it "%atag plus :preserve - leading whitespace preserved" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo 
  %bar
    :preserve
       funct()   
           expression 
          end
HAML
      wspc.html.should == <<HTML
<foo>
  <bar>
     funct()   &#x000A;     expression &#x000A;    end
  </bar>
</foo>
HTML
    #end
  end
end
#Notice: funct() is indented +1 than OutputIndentStep,
# and all other lines are indented from that same BOD.


#================================================================
describe HamlRender, "-05- Preserve:" do
  it "%code Inline Content (dynamic) - initial and interior whitespace preserved" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%code= " inline expr code()  \n     %nested code:"
HAML
      wspc.html.should == <<HTML
<code> inline expr code()  &#x000A;     %nested code:</code>
HTML
    end
  end
end
#bug-let nit: preserve leading whitespace from expr or interpolation


#================================================================
describe HamlRender, "-06- Preserve:" do
  it "%cope (non-preserve) Inline Content (dynamic) - leading whitespace - =expr" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%laugh
  %cry
    %cope= " inline expr code()  \n     nested code:"
HAML
      wspc.html.should == <<HTML
<laugh>
  <cry>
    <cope> inline expr code()  
           nested code:
    </cope>
  </cry>
</laugh>
HTML
     end
  end
end
#Legacy:
#laugh>
# <cry>
#   <cope>
#      inline expr code()  \n         nested code:
#   </cope>
# </cry>
#/laugh>
#
#Notice: 'cope' is not 'code': it is NOT in option:preserve
#WSE Haml ... honoring author inline by running results tight after 
#the tagstart. 
#Copy through that initial space from expr/interp even for non-preserve
# or non-preformatted tag
#For regular tags (non-preserve/non-preformatted), both legacy and 
# WSE Haml normalize the OutputIndent in the results for cases where 
# newlines are 'interior' to the expr/interp.


#================================================================
describe HamlRender, "-07- Preserve:" do
  it "%code (preserve) Inline Content (dynamic) - interior whitespace - ~expr" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%code~ " inline expr code()  \n     nested code:\n"
HAML
      wspc.html.should == <<HTML
<code> inline expr code()  &#x000A;     nested code:&#x000A;</code>
HTML
    end
  end
end
#Contains WSE extensions too


#================================================================
describe HamlRender, "-08- Preserve:" do
  it "=find_and_preserve - <pre>, no tag, and <xre> (non-option-preserve)" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  = find_and_preserve("Foo\n<pre>Bar\nBaz\n</pre>")
  = find_and_preserve("Foo\n%Bar\nBaz")
  = find_and_preserve("Foo\n<xre>Bar\nBaz\n</xre>")
HAML
      wspc.html.should == <<HTML
<zot>
  Foo\n  <pre>Bar&#x000A;Baz</pre>
  Foo\n  %Bar\n  Baz
  Foo\n  <xre>Bar\n  Baz\n  </xre>
</zot>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-09- Preserve:" do
  it "~expr - <pre>, no tag, and <xre> (non-option-preserve)" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  ~ "Foo\n<pre>Bar\nBaz\n</pre>"
  ~ "Foo\n%Bar\nBaz"
  ~ "Foo\n<xre>Bar\nBaz\n</xre>"
HAML
      wspc.html.should == <<HTML
<zot>
  Foo\n  <pre>Bar&#x000A;Baz\n</pre>
  Foo\n  %Bar\n  Baz
  Foo\n  <xre>Bar\n  Baz\n</xre>
</zot>
HTML
    end
  end
end


#================================================================
describe HamlRender, "-10- Preserve:" do
  it "%code Inline Content - leading and trailing whitespace" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %code= "book-content =\n     attribute id { text },\n     attribute available { text },  "
  %code= "     isbn-element,\n     title-element,\n     author-element*,\n     character-element*  "
HAML
      wspc.html.should == <<HTML
<foo>
  <code>book-content =&#x000A;     attribute id { text },&#x000A;     attribute available { text },</code>
  <code>     isbn-element,&#x000A;     title-element,&#x000A;     author-element*,&#x000A;     character-element*</code>
</foo>
HTML
    end
  end
end
#got:
#
#The preserve option doesn't satisfy two other requirements for
#treatment under rules similar to CSS white-space:pre.  
#Initial, Leading, and trailing whitespace should be preserved.
#Thinking regarding Initial whitespace: An author should be able 
#to control the OutputIndent even across multiple %code elements 
#... which means that a following %code section should be able to 
#begin with the same OutputIndent as that of the last line of the 
#prior %code section, for example, and continue to add even more
#such %code sections as the code definition develops.
#A picture of a typical UA (CSS-neutral) rendering for the 
#Relax NG schema in the %code above:
#
#book-content =
#   attribute id { text },
#   attribute available { text },  
#   isbn-element,
#   title-element,
#   author-element*,
#   character-element*  
#
#As to trailing whitespace, preservation is appropriate. For one, 
#it will match the treatment in multiline text of the internal 
#line-ending whitespace. Moreover, even in single-line cases, 
#rendering of the lines may (according to UA or CSS differences) 
#vary depending on the presence of the whitespace. (Such as with
#centering.)


#================================================================
describe HamlRender, "-11- Preserve:" do
  it "%code -- impermissible Nested Content" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%eggs
  %code
    proc()  
    moreproc()  
%spam
  %cope
    funct()
    morefunct()
%saus
  %code and bacon
    %car/
    %cdr/
HAML
      wspc.html.should == <<HTML
<eggs>
  <code>
    proc()  
    moreproc()  
  </code>
</eggs>
<spam>
  <cope>
    funct()
    morefunct()
  </cope>
</spam>
<saus>
  <code>and bacon</code>
  <car />
  <cdr />
</saus>
HTML
    end
  end
end
#Legacy Bug
#Mixed or Nested content is INELIGIBLE for 'preserve' treatment under
# legacy Haml, and WSE Haml does not change this specified treatment.
#In the example, the nested content to %code is partially interpreted 
# under preserve, including legacy indent bug.
#BUT, the reasonable expectation for legacy Haml (and WSE Haml) is as 
# follows (using %code as an example)
#  - Case A: If the %code Head has (legal) Inline Content, it is the
#      content block for 'preserve-style' %code, and the %code Element
#      is complete; alternatively ...
#  - Case B: If the %code Head lacks Inline Content, then the 
#      content block for the 'preserve-style' %code is EMPTY.
#  - Case C: Case B (empty Inline) PLUS apparently nesting lines:
#      The %code Head should now be considered a normal tag with
#      Nested Content, not a 'preserve-style' tag: same indents and 
#      whitespace handling as %p or %anytag.
#  - Case D: Case A (Inline) PLUS apparently nesting lines:
#      This is prohibited in legacy Haml; permitted in WSE Haml
#      Because %code in is 'option:preserve' there's special handling.
#      As mentioned above, the Inline Content completed the %code Element.
#      So, these 'nesting' lines must be something else.
#      Under OIR:strict or loose, they are considered siblings to the 
#      %code element.
#      Without the special handling for 'option:preserve', say for
#      a normal tag, or 'option:preformatted', the entire Inline plus
#      Nested comprise a Mixed Content ContentBlock to the tag.


#================================================================
describe HamlRender, "-12- Preserve:" do
  it "%code -- impermissible Nested Content, indented" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
    lambda{ wspc.render_haml( <<'HAML', h_opts ) }.should raise_error(Haml::SyntaxError,/nesting within plain text is illegal/)
%zap
  %code
    def fact(n)  
      (1..n).reduce(1, :*)  
    end  
HAML
      wspc.html.should == nil
    #end
  end
end
#As in, you know, code.
#WSE Haml does not change this.



#================================================================
describe HamlRender, "-13- Preserve:" do
  it "%code preserve Indented Nested Content - plus through the preserve filter" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%zap
  %code
    :preserve
        def fact(n)  
          (1..n).reduce(1, :*)  
        end  
HAML
      wspc.html.should == <<HTML
<zap>
  <code>  def fact(n)  &#x000A;    (1..n).reduce(1, :*)  &#x000A;  end  </code>
</zap>
HTML
    end
  end
end
#Legacy:
#<zap>
#  <code>  def fact(n)  &#x000A;    (1..n).reduce(1, :*)  &#x000A;  end</code>
#</zap>


#================================================================
describe HamlRender, "-14- preserve:" do
  it "Indented Nested Content - through the preserve filter - no initial tag" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
:preserve
      def fact(n)  
        (1..n).reduce(1, :*)  
      end  
%div
  %p para1
HAML
      wspc.html.should == <<HTML
def fact(n)  &#x000A;  (1..n).reduce(1, :*)  &#x000A;end
<div>
  <p>para1</p>
</div>
HTML
    end
  end
end
#Legacy Haml: Minor Bug/Artifact
#In 'ordinary' HamlSource, a :preserve Head won't be the first of the file
#AND, the :preserve Head will calc the Leading Whitespace by subtracting 
#  the by-then global IndentStep (def 2 spaces). 
#IOW, it's surprising to see the content block of :preserve exert any
#  change on the external global state, since it is otherwise local.
#Recco:Don't set the IndentStep at this point ... since it is also
#  unnecessary, as it is logical that such a :preserve content block 
#  be set hard left.


#================================================================
describe HamlRender, "-15- preserve:" do
  it "filter :preserve with internal Haml tag, literal" do
    #pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :var1 => 'variable1' )
%zig
  :preserve
    %p
      #{var1}
      para
HAML
      wspc.html.should == <<HTML
<zig>
  %p&#x000A;  variable1&#x000A;  para
</zig>
HTML
    #end
  end
end


#================================================================
describe HamlRender, "-16- preserve:" do
  it "Preserve and non-preserve leading and trailing wspc, newlines" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :metavar => "  Foo  \n  Bar  \n\n" )
%tutu
  %p para1
  %code= metavar
  %cope= metavar
HAML
      wspc.html.should == <<HTML
<tutu>
  <p>para1</p>
  <code>  Foo  &#x000A;  Bar  &#x000A;</code>
  <cope>
      Foo  
      Bar  
  </cope>
</tutu>
HTML
    end
  end
end 
#legacy:
#<tutu>
#  <p>para1</p>
#  <code>Foo  &#x000A;  Bar</code>
#  <cope>\n      Foo  \n      Bar\n  </cope>
#</tutu>
#
#Why should a preserve tag drop the initial wspc,
#  while a normal tag would copy through (adjusted) the leading wspc?
#Why should preserve remove trailing wspc, like nonpreserve?
#What should be the treatment for that double trailing newline? 
#  -- it's inside an expr, not 'just' in a literal Whiteline
#  -- consolidate into one, then transform in preserve
#Note that the OutputIndent for the second line in the non-preserve
#  case is the result of the html_indent, whatever its then-current 
#  value, plus the content author's extra spacing in the interpolated var. 
