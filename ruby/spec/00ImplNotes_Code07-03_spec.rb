#00ImplNotes_Code07-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_7
#         spec --color spec/00ImplNotes_Code07-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 7-03 -- WSE In Brief:" do
  it "Inline with Newlines - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts, :strvar => "foo\nbar" )
.quux
  %p
    = strvar
  %p= strvar
  %p eggs #{strvar} spam
HAML
      wspc.html.should == <<HTML
<div class='quux'>
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
#Legacy Haml:
#<div class='quux'>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    foo\n    bar\n  </p>
#  <p>\n    eggs foo\n    bar spam\n  </p>
#</div>
#
#The prior spec (Code07-02) shows the extension of Mixed Content
#  to a full ContentModel.
#That example shows the Inline portion of the Content rendered
#  immediately after any Html start tag.
#
#But, a related consequence is the rendering of an Inline Content
#ContentBlock having newlines: the initial whitespace, and the
#initial text is rendered immediately after any Html start tag.
