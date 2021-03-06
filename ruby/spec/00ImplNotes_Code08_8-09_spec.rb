#00ImplNotes_Code08_8-09_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-09_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-09 -- Normalizing:" do
  it "Html Endtag - Preserve Tag - Preserved - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.quux
  - strvar = "   foo\n   bar  \n\n"
  %code= strvar
HAML
      wspc.html.should == <<'HTML'
<div class='quux'>
  <code>foo&#x000A;   bar</code>
</div>
HTML
  end
end
#Legacy Haml: Drops the trailing newlines
#WSE Haml (next spec Code 8.8-10): consolidates the trailing newlines, then transforms
#<div class='quux'>
#  <code>   foo&#x000A;   bar  &#x000A;</code>
#</div>
