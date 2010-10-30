#00ImplNotes_Code08_8-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-01 -- Normalizing:" do
  it "Mixed Content - HtmlOutput Whitespace and Indentation - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.flow
  %p Inline content
     Nested content
HAML
      wspc.html.should == <<'HTML'
<div class='flow'>
  <p>Inline content
    Nested content
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
# Admits Mixed Content; HtmlOutput formatted similar to Multiline (or other Inline-with-newline)
