#00ImplNotes_Code09_5-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_5
#         spec --color spec/00ImplNotes_Code09_5-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.5-03 -- Heads:HereDoc:" do
  it "Attributes first - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%body
  %dir
    %dir
      %vtag{ :a => 'b',
             :y => 'z' }<<-DOC
     HereDoc Para
     DOC
HAML
      wspc.html.should == <<'HTML'
<body>
  <dir>
    <dir>
      <vtag a='b' y='z'>
     HereDoc Para
      </vtag>
    </dir>
  </dir>
</body>
HTML
    end
  end
end
