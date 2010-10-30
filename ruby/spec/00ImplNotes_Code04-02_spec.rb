#00ImplNotes_Code04-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_4
#         spec --color spec/00ImplNotes_Code04-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 4-02 -- Motivation:" do
  it "Nex3 Issue 28 - 1-level indent - Legacy Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%foo
  %bar
    %baz
      bang
    boom
HAML
      wspc.html.should == <<HTML
<foo>
  <bar>
    <baz>
      bang
    </baz>
    boom
  </bar>
</foo>
HTML
  end
end
#Legacy Haml: the same result is expected in Code 4-01, 2-level indent
