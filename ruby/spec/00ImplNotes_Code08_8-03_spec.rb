#00ImplNotes_Code08_8-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-03 -- Normalizing:" do
  it "Forced nesting of dynamic vars w/newlines - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.quux
  - strvar = "foo bar"
  %p= strvar
  - strvar = "foo\nbar"
  %p= strvar
  - strvar = "foo\nbar"
  %p eggs #{strvar} spam
HAML
      wspc.html.should == <<'HTML'
<div class='quux'>
  <p>foo bar</p>
  <p>
    foo
    bar
  </p>
  <p>
    eggs foo
    bar spam
  </p>
</div>
HTML
  end
end
#Compare the eggs..spam escample to WSE Haml, below in Code 8.8-04.
