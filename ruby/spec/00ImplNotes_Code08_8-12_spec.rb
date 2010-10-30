#00ImplNotes_Code08_8-12_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-12_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-12 -- Normalizing:" do
  it "Mixed Content Leading Whitespace in Expression - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts, :strvar => "   foo\n     bar  \n" )
.quux
  %code= strvar
  %cope= strvar
HAML
      wspc.html.should == <<'HTML'
<div class='quux'>
  <code>   foo&#x000A;     bar  \n</code>
  <cope>   foo
    bar  
  </cope>
</div>
HTML
    end
  end
end
#Notice: For WSE Haml, with non-option:preserve tag <cope>:
# 1. The Inline, with Initial Whitespace follows Code 8.8-04 and Code 8.8-06
# 2. Under oir:loose or oir:strict
#    Only 1 OutputIndentStep (defaulted at 2)
#Legacy:
#<div class='quux'>
#  <code>foo&#x000A;     bar</code>
#  <cope>\n       foo\n         bar\n  </cope>
#</div>
