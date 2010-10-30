#00ImplNotes_Code08_8-04_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_8_8
#         spec --color spec/00ImplNotes_Code08_8-04_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 8.8-04 -- Normalizing:" do
  it "Dynamic vars, Folding Inline plus Nesting - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
.quux
  - strvar = "foobar"
  %p
    = strvar
  - strvar = "foo\nbar"
  %p
    = strvar
  - strvar = "foo\nbar"
  %p= strvar
  - strvar = "foo\nbar"
  %p eggs #{strvar} spam
HAML
      wspc.html.should == <<'HTML'
<div class='quux'>
  <p>
    foobar
  </p>
  <p>
    foo
    bar
  </p>
  <p>foo
    bar
  </p>
  <p>eggs foo
    bar spam
  </p>
</div>
HTML
    end
  end
end
#WSE Haml:
#  First case:  Always nest my var's content
#  Second case: Nest my var's content, and normalize just like would otherwise
#  Third case:  Differs from Legacy Haml
#               Start my var's content inline; normalize just like other indents...but:
#               (but: if in option:preserve or option:preformatted, use those indent rules)
#  Fourth case: Differs from Legacy Haml (see prior spec)
#               Start my var's content inline; normalize just like other indents...but:
#               (but: if in option:preserve or option:preformatted, use those indent rules)
#Legacy Haml:
#<div class='quux'>
#  <p>\n    foobar\n  </p>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    eggs foo\n    bar spam\n  </p>
#</div>
