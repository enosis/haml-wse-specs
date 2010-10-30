#00ImplNotes_Code07-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_7
#         spec --color spec/00ImplNotes_Code07-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 7-01 -- WSE In Brief:" do
  it "Varying indent and nesting - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%div#id1
    %p cblock2
    %p cblock3
%div#id2
  %p cblock4 
       cblock4 nested
HAML
      wspc.html.should == <<HTML
<div id='id1'>
  <p>cblock2</p>
  <p>cblock3</p>
</div>
<div id='id2'>
  <p>cblock4 
    cblock4 nested
  </p>
</div>
HTML
    end
  end
end
#Legacy Haml:
# Haml::SyntaxError,
# /Inconsistent indentation:.*spaces.*used for indentation, but.*rest.*doc.* using 4 spaces/
#WSE Haml:
# 1. oir:loose, but does not violate oir:strict (each Element undent is 'regular')
# 2. #id1: The indentation for p.cblock2 and p.cblock3 is one IndentStep (4 spaces)
# 3. #id2: The indentation for p.cblock4 is one IndentStep (2 spaces)
#    (in WSE Haml, each Element's immediate ContactBlock can have its own IndentStep)
# 4. #id2: The indentation of "cblock4 nested" is one IndentStep beyond "%p cblock4"
#    this makes it part of a Mixed contentblock to %p
#        "cblock4 nested" could be plaintext or tag; and multiple lines
#    HtmlOutput for this gives "cblock4" tight to the opening tag,
#        and "cblock4 nested" indented by a further OutputIndent.
