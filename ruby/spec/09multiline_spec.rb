#09multiline_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: spec --color spec/09multiline_spec.rb -f s
#Authors:
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

require "./HamlRender"

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines

#Multiline: Does not observe Offside, not require OIR
#Interior whitespace is replayed; Initial, leading, and trailing
#whitespace is consolidated (n->1).


#================================================================
describe HamlRender, "-01- Multiline" do
  it "Basic single multiline" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p para1
%div
    First line |
    Second line |
%p para2
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<div>
  First line Second line
</div>
<p>para2</p>
HTML
    end
  end
end
#BUG: Trailing whitespace added at end of laminated text "Second line "
#legacy: 
#<p>para1</p>
#<div>\n  First line Second line \n</div>\n<p>para2</p>\n"


#================================================================
describe HamlRender, "-02- Multiline" do
  it "Basic single multiline - improper ML lexeme copied thru" do
    #pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p   para1
%div
    First line|
    Second line|
%p para2
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<div>
  First line|
  Second line|
</div>
<p>para2</p>
HTML
    #end
  end
end
#got: "<p>para1</p>\n<div>\n  First line|\n  Second line|\n</div>\n<p>para2</p>\n"
#The REFERENCE says that whitespace separator is nec.: the infix lexeme is ' |'. 
#That's what the lexer would remove before filling the AST.
#But how, then, will trailing space be interpreted? In the same 
#way as leading space ... where the leading space is shortened 
#for the necessary IndentSteps? Or ...? Let's check that out ...


#================================================================
describe HamlRender, "-03- Multiline" do
  it "Basic single multiline -- interpvar plus trailing space preserved, sometimes" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :var1 => 'variable1' )
%p para1
%div
    %p   First line   |
    #{var1}  |
      Third line   |
Fourth line   |
%p para2
HAML
      wspc.html.should == <<HTML
<p>para1</p>
<div>
  <p>First line variable1 Third line Fourth line</p>
</div>
<p>para2</p>
HTML
    end
  end
end
#legacy:
#<p>para1</p>
#<div>
#  <p>First line   variable1  Third line   Fourth line</p>
#</div>
#<p>para2</p>\n"
#Notice: In Legacy Haml multiline trailing whitespace is preserved 
# Approximately, that is. Notice drop at last line, and see other tests in 
# this suite, but initial whitespace is removed. 
# (Perl text::haml varies from this.)
#
#This seems buggy, or at least inconsistent. But what treatment? Would seem,
#either, CONSOLIDATE all/both to single spaces (seems most appropriate, and
#this is indeed what WSE Haml specifies) or normalize them back to the 
#"effective" BOD (the left-most margin in the text, since Multiline
#enforces NEITHER Offside/BOD, or OIR).
#
#Legacy Bug: Compare drop of trailing space after "Fourth line" with add of 
#trailing space in the bug above. 
#
#Related: Note, also, the trailing whitespace that _is_ preserved is 
#NOT ADJUSTED for the wspc nec. for the syntax. 
#That is, the 'lexer' should have removed the lexeme " |" from each of these
#lines, the AST would reflect that the (now-sans-' |') content block is a
#multiline content block, and then the multiline code processor should 
#process/handle/preserve the content, including the _remaining_ spaces. 
#Rather than considering the minimum 'separating' whitespace
#as being contributed from the "    |" we should consider that for Multiline
#the "\n...IndentSteps..." is being CONSOLIDATED to " ".
#
#Notice: Initial whitespace (on first the line, after tag) is removed,
# unless supplied via interpolation ... the usual treatment in WSE Haml.


#================================================================
describe HamlRender, "-04- Multiline" do
  it "Single multiline -- As-if Interpolated + HamlComment -- Legacy Haml" do
    #pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "VarStrPt1\nVarStrPt2" )
%div
  %p 
    First line |
    VarStrPt1  |
    -# Breaking Haml Comment
    VarStrPt2   |
    Third line  |
    Fourth line |
    Foobar
HAML
      wspc.html.should == <<HTML
<div>
  <p>
    First line VarStrPt1  
    VarStrPt2   Third line  Fourth line 
    Foobar
  </p>
</div>
HTML
    #end
  end
end
#Legacy Haml
#Compare this with the next several RSpec cases
#
#In this case, the HamlSource is manipulated to yield the same HtmlOutput 
#as the actual interpolation case, which interpolates the newline
#See below for more comments.


#================================================================
describe HamlRender, "-05- Multiline" do
  it "Single multiline -- As-if Interpolated + Simple ML break -- Legacy Haml" do
    #pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "VarStrPt1\nVarStrPt2" )
%div
  %p 
    First line |
    VarStrPt1 
    VarStrPt2   |
    Third line  |
    Fourth line |
    Foobar
HAML
      wspc.html.should == <<HTML
<div>
  <p>
    First line 
    VarStrPt1
    VarStrPt2   Third line  Fourth line 
    Foobar
  </p>
</div>
HTML
    #end
  end
end
#Legacy Haml
#Compare this with the above RSpec case, and several below.
#
#This case shows what would happen should an embedded newline be
#taken as 'literal' substitution _before_ Multiline syntax is
#processed. That would be an inversion of a more conventional
#parsing, wherein a dynamic variable substitution would happen
#only _after_ the syntax tree has been generated.
#See below for more comments.


#================================================================
describe HamlRender, "-06- Multiline" do
  it "Single multiline -- Interpolated Newline -- Legacy Haml" do
    #pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "VarStrPt1\nVarStrPt2" )
%div
  %p 
    First line |
    #{varstr}  |
    Third line  |
    Fourth line |
    Foobar
HAML
      wspc.html.should == <<HTML
<div>
  <p>
    First line VarStrPt1
    VarStrPt2  Third line  Fourth line
    Foobar
  </p>
</div>
HTML
    #end
  end
end
#Legacy Haml
#Compare this with the prior, and the following RSpec cases
#
#This case reveals an odd reversal in the legacy implementation: 
#surface syntax is interpreted _after_ content semantics.
#In this case, the HamlSource has an interpolation form, which 
#is given a phrase containing a newline.
#Notice that although the interpolation form falls within a
#Multiline Element's ContentBlock, the result is as if the
#newline broke the Multiline, and started a new Multiline for
#the next few lines. But the prior RSpec case shows that given those
#inputs a different result obtains. Instead it renders as if a 
#Haml Comment were inserted (or, in WSE Haml, as if a Whiteline 
#had been inserted). But that's an odd result too.
#
#The next RSpec case shows what we expect in WSE Haml, and discusses
#the parsing model


#================================================================
describe HamlRender, "-07- Multiline" do
  it "Single multiline -- interpolated newline - WSE Haml" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "VarStrPt1\nVarStrPt2" )
%div
  %p 
    First line |
    #{varstr}  |
    Third line  |
    Fourth line |
    Foobar
HAML
      wspc.html.should == <<HTML
<div>
  <p>
    First line VarStrPt1 VarStrPt2 Third line Fourth line
    Foobar
  </p>
</div>
HTML
    end
  end
end
#Legacy Bug + WSE Extensions
#WSE Haml result when Multiline ContentBlock contains interpolated newline
#(Note: Also WSE Haml results for consolidating whitespace, etc)
#
#Compare with cases above. What is happening in WSE Haml:
#The lexer builds an AST having the %p as a node, having a Nested 
#ContentBlock, and having as children two syntactic forms: 
#the first child is a Multiline node, the second child is a Plaintext node.
#As we already know, the lexer strips the ContentBlock of Multiline 
#Elements of the Multiline Lexemes -- leaving just the lines to be 
#processed (including interpolation ... which makes it obvious that an
#interpolated ' |\n.. |\n' cannot trigger a Multiline), and then finally
#combined according to Multiline _semantics_.


#================================================================
describe HamlRender, "-08- Multiline" do
  it "Single multiline -- interpolated newline with Pipe" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts, :varstr => "VarStrPt1 |\nVarStrPt2 " )
%div
  %p 
    First line |
    #{varstr}  |
    Third line  |
HAML
      wspc.html.should == <<WSE
<div>
  <p>
    First line VarStrPt1 | VarStrPt2 Third line
  </p>
</div>
WSE
      wspc.html.should_not == <<LEGACY
<div>
  <p>
    First line VarStrPt1 |
    VarStrPt2   Third line
  </p>
</div>
LEGACY
    end
  end
end
#Confirming: Legacy Haml properly does NOT interpret interpolated 
# Multiline lexeme. 


#================================================================
describe HamlRender, "-09- Multiline" do
  it "Haml Comment in middle of Multiline -- Deprecated" do
    #pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
First line |
Second line |
-#Third line
Another online Hamlmultiline |
Next Content Block
HAML
      wspc.html.should == <<HTML
First line Second line 
Another online Hamlmultiline 
Next Content Block
HTML
    #end
  end
end
#First, see WSE Implementation Notes, and notes in this spec re processing 
# sequence and abstract grammar.
#Then: All of that points to a Haml Comment being UNABLE to break a 
# Multiline, or any other multi-line structure.
#However: there's a legacy Haml problem here ... a workaround for
# reasonably expected behavior (that a Whiteline  _would_ separate
# two adjacent Multilines) was to use a Haml Comment. 
#So, although that is clearly I<whack>, we'll have to support it too.
#
#Deprecated: Using a Haml Comment to demarcate two adjacent Multiline Elements
#is now deprecated. The recommended idiom is now the Whiteline. 
#BUG: Excessive trailing whitespace at end of laminated lines


#================================================================
describe HamlRender, "-10- Multiline" do
  it "Haml Comment inside Multiline block -- with Multiline syntax -- Deprecated" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
First line |
Second line |
-# Third line |
Last line |
Next Content Block
HAML
      wspc.html.should == <<HTML
First line Second line\nLast line \nNext Content Block
HTML
    end
  end
end
#Legacy:
#First line Second line -#Third line Last line \nNext Content Block
#
#Haml comment (which is "Haml-inactive") should be removed by parser
#before Haml-active HamlSource is considered. The result should be 
#a single multiline before the final text line.
#Although that's clearly still an Haml comment we've got an unexpected
#re-ordering of parsing rules -- Haml comment is carried through to Html
#Interesting that although HamlComment is essentially transparent
#to content, it serves to demarcate the two multiline Elements
#So, the above is a BUG
#HOWEVER, WSE provides backward compatibility for this aberration,
# So, in the Multiline here, that is a Haml Comment.
#Deprecated: Using a Haml Comment to demarcate two adjacent Multiline Elements
#is now deprecated. The recommended idiom is now the Whiteline. 


#================================================================
describe HamlRender, "-11- Multiline" do
  it "Multiline either side of Whiteline" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
First line |
Second line |

Another online Hamlmultiline |
Next Content Block
HAML
      wspc.html.should == <<HTML
First line Second line 
Another online Hamlmultiline
Next Content Block
HTML
    end
  end
end
#BUG: Despite being waived off in Haml Issues: WSE calls this a BUG
#How can Whiteline be of less semantic potency than a Haml comment line? 
# A Whiteline must be more potent, therefore the absence of the " |" must 
# be semantically significant. 
# - HamlComment is an active Haml lexeme, but in the (abbrev version of the)
#   Haml 'hierarchy' of: pi, meta, macros + expr + transforms, content
#   The first two are different from the latter two in that those
#   (most simply) are not carried through to output (there are oth diff)
# - Interesting that although HamlComment is essentially transparent
#   to content, it serves to demarcate the two multiline Elements
# - Where does Whiteline fit in the above hierarchy?
#   Is it a fifth level/category? Does it fall btw meta and macros et al?
#   Or btwn macros et al and content?
# - Under WSE, we consider Whiteline in the latter: either in content,
#   or between that and macros.
# - Under that model, a Whiteline must certainly delimit the two blocks


#================================================================
describe HamlRender, "-12- Multiline" do
  it "Whiteline with Multiline syntax inside Multiline block, improper ML lexeme" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
First line |
Second line |
|
Last line |
Next Content Block
HAML
      wspc.html.should == <<HTML
First line Second line Last line \nNext Content Block
HTML
    end
  end
end
#legacy: "First line Second line \n|\nLast line \nNext Content Block\n" 
#Bug: That unexpected extra trailing space, after "Second line"
#Bug: The multiline block breaks at the 'Whiteline' having just '|'
#     but ... is it simply because the bare '|' is not the proper ' |'?


#================================================================
describe HamlRender, "-13- Multiline" do
  it "Whiteline with Multiline syntax inside Multiline block - with proper ML lexeme" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
First line |
Second line |
 |
Last line |
Next Content Block
HAML
      wspc.html.should == <<HTML
First line Second line Last line \nNext Content Block
HTML
    end
  end
end
#Bug: An apparent bug, if you're a user expecting it to work like
#     a full multiline. Correcting to a proper " |" doesn't fix things.
#     Now it provokes an illegal indentation error (b/c hidden from you
#     until you remove the spaces, there's two newlines being inserted.)


#================================================================
describe HamlRender, "-14- Multiline" do
  it "Multiline supports Mixed Content" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p Baz |
 More     |
  Text    |
HAML
      wspc.html.should == <<HTML
<p>Baz More Text</p>
HTML
    end
  end
end
#Simple case: Notice that Multiline supports Mixed Content
#(But not if the Inline Content is an expression. Error:  %p= "Baz" | )
#WSE: Multiline CONSOLIDATES whitespace


#================================================================
describe HamlRender, "-15- Multiline" do
  it "Multiline, last line w/o operator" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%whoo
  %hoo 
    I think this might get    |
    pretty long so I should   |
    probably make it          |
    multiline so it does not  |
    look awful.
  %p This is short.
HAML
      wspc.html.should == <<HTML
<whoo>
  <hoo>
    I think this might get pretty long so I should probably make it multiline so it does not
    look awful.
  </hoo>
  <p>This is short.</p>
</whoo>
HTML
    end
  end
end
#Variant from perl t/multiline.t; legacy text::perl sucks up the "look awful"
#Legacy Haml:
#<whoo>
#  <hoo>
#    I think this might get    pretty long so I should   probably make it          multiline so it does not  
#    look awful.
#  </hoo>
#  <p>This is short.</p>
#</whoo>
#Notice: That is, in Legacy Haml "\nlook awful" ... is _properly_ not included 
#in the multiline


#================================================================
describe HamlRender, "-16- Multiline" do
  it "Multiline, last line w/o operator -- Perl test::more example" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver' ],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%whoo
  %hoo I think this might get |
    pretty long so I should   |
    probably make it          |
    multiline so it does not  |
    look awful.
  %p This is short.
HAML
      wspc.html.should == <<HTML
<whoo>
  <hoo>I think this might get pretty long so I should probably make it multiline so it does not  
    look awful.
  </hoo>
  <p>This is short.</p>
</whoo>
HTML
    end
  end
end
#Requires WSE to accept Mixed Content ContentModel 
#  -- the "\nlook awful" triggers Mixed Content for the %hoo Element
#Variant of perl t/multiline.t for legacy text::haml 
# Compared to text::haml error for Nested Content (previous test),
# this works in legacy text::haml

