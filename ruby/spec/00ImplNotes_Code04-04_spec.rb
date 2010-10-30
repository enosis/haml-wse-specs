#00ImplNotes_Code04-04_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_4
#         spec --color spec/00ImplNotes_Code04-04_spec.rb -f s
#
#Authors: 
# enosis@github.com Nick Ragouzis - Last: Oct2010
#
#Correspondence:
# Haml_WhitespaceSemanticsExtension_ImplmentationNotes v0.5, 20101020
#

#Notice: With Whitespace Semantics Extension (WSE), OIR:loose is the default 
#Notice: Trailing whitespace is present on some Textlines

require './HamlRender'


#================================================================
describe HamlRender, "ImplNotes Code 4-04 -- Motivation:" do
  it "Nex3 Issue 28 - Inconsistent indentation (as plaintext) - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
    up four spaces
  down two spaces
HAML
      wspc.html.should == <<HTML
<foo>
  up four spaces
  down two spaces
</foo>
HTML
    end
  end
end
#Same as preceding spec Code 4-03, but this run is prepared for WSE Haml
#WSE Haml results for the 'preformatted' facility depends  on the mechanism
# chosen, and on options and substitution for the phrases "up four spaces" etc.
#
# 1. Legacy Haml: SyntaxError -- Inconsistent Indentation (as above in Code 4-03)
#
# 2. WSE Haml: either or both pharases as: a. plaintext or b. substituted as atag:
#       Single InputIndent yields single OutputIndent, leading whitespace removed
#    <foo>
#      up four spaces
#      down two spaces
#    </foo>
# Further examples and variants: see Code 7-01, Code 7-02 , Code 8.4-02 thru Code 8.4-06
#
# 3. WSE Haml: with option:preformatted => ['foo'] (interpolation, no tag processing)
#       HtmlOutput: block is shifted left to 0 Margin
#       - see other specs, including 03nesting_spec.rb, 05preformatted_spec.rb
#    <foo>
#      up four spaces
#    down two spaces
#    </foo>
#
# 4. WSE Haml: with HereDoc
#       HtmlOutput: Indentation and nesting is replayed
#    %foo<<DOC
#        up four spaces
#      down two spaces
#    DOC
#    <foo>
#        up four spaces
#      down two spaces
#    </foo>
#
# 5. WSE Haml: with filter:preformatted
#       HamlSource: 
#          - IndentStep of parent establishes the :preformatted Onside Ref
#            (This is Legacy Haml's algorithm, except in Legacy IndentStep is constant)
#          - That IndentStep is removed from the Leading Whitespace
#    %foo
#      :preformatted
#          up four spaces
#        down two spaces
#    DOC
#    <foo>
#        up four spaces
#      down two spaces
#    </foo>
