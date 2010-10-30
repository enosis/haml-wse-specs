#00ImplNotes_Code09_15-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_15
#         spec --color spec/00ImplNotes_Code09_15-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.15-02 -- Heads:Whitespace Removal:" do
  it "Trim_in - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%eggs
  %div
    %p< Foo
      Bar
      Baz
  %p para1
%spam
  %div
    %p<= "  Foo\nBar\nBaz  "
  %p para2
HAML
      wspc.html.should == <<HTML
<eggs>
  <div>
    <p>Foo
      Bar
      Baz</p>
  </div>
  <p>para1</p>
</eggs>
<spam>
  <div>
    <p>  Foo
    Bar
    Baz  </p>
  </div>
  <p>para2</p>
</spam>
HTML
    end
  end
end
