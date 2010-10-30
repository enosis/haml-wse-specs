#00ImplNotes_Code09_2-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_2
#         spec --color spec/00ImplNotes_Code09_2-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.2-02 -- Heads:HamlComment:" do
  it "Lexeme Separation" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
.zork
  %p para1
  -# Text comment
  %p para2
.bork
  %p para1
  -#Text comment
  %p para2
HAML
      wspc.html.should == <<'HTML'
<div class='zork'>
  <p>para1</p>
  <p>para2</p>
</div>
<div class='bork'>
  <p>para1</p>
  <p>para2</p>
</div>
HTML
  end
end

