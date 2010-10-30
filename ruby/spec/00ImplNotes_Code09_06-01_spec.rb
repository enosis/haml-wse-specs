#00ImplNotes_Code09_6-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_6
#         spec --color spec/00ImplNotes_Code09_6-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.6-01 -- Heads:Preserve:" do
  it "Starttag-Endtag mechanics - WSE Haml" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code', 'ptag'],
                 :preformatted => ['ver', 'vtag'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts, :strvar => "toto\ntutu" )
.wspcpre
  %snap
    %ptag= "Bar\nBaz"
  %crak
    %ptag #{strvar}
  %pahp
    %ptag
      :preserve
          def fact(n)  
            (1..n).reduce(1, :*)  
          end  
HAML
      wspc.html.should == <<'HTML'
<div class='wspcpre'>
  <snap>
    <ptag>Bar&#x000A;Baz</ptag>
  </snap>
  <crak>
    <ptag>toto&#x000A;tutu</ptag>
  </crak>
  <pahp>
    <ptag>  def fact(n)  &#x000A;    (1..n).reduce(1, :*)  &#x000A;  end</ptag>
  </pahp>
</div>
HTML
  end
end
#Notice: Trailing whitespace
#Notice: The OutputIndent for filter:preserve is 2 spaces, the
# difference after the IndentStep is removed. If this were legacy Haml
# the file-global IndentStep would be 2-spaces, leaving 2 spaces.
