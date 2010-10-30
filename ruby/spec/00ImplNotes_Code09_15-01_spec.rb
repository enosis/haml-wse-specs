#00ImplNotes_Code09_15-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_15
#         spec --color spec/00ImplNotes_Code09_15-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.15-01 -- Heads:Whitespace Removal:" do
  it "Simple WSE Haml Mixed Content" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%bac
  %p Foo
    Bar
    Baz
%saus
  %p= "Thud\nGrunt\nGorp  "
HAML
      wspc.html.should == <<HTML
<bac>
  <p>Foo
    Bar
    Baz
  </p>
</bac>
<saus>
  <p>Thud
    Grunt
    Gorp
  </p>
</saus>
HTML
    end
  end
end
# Removing the Inline Content from the Mixed Content block (WSE Haml-required)
# Legacy gives the following alignments:
# <p>
#   Bar
#   Baz
# </p>
#
# <p>
#   Thud
#   Grunt
#   Gorp
# </p>
