#00ImplNotes_Code08_8-05_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-05_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-05 -- Normalizing:" do
  it "Dynamic var, Folded, Initial Whitespace - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts, :strvar => "  foo\n   bar" )
.quux
  %p= strvar
HAML
      wspc.html.should == <<'HTML'
<div class='quux'>
  <p>
      foo
       bar
  </p>
</div>
HTML
  end
end
#Legacy Haml (this case):
#<div class='quux'>\n  <p>\n      foo\n       bar\n  </p>\n</div>
#WSE Haml (next case - Code08_8-06):
#<div class='quux'>\n  <p>  foo\n       bar\n  </p>\n</div>
