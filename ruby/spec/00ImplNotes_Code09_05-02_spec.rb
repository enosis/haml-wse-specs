#00ImplNotes_Code09_5-02_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_5
#         spec --color spec/00ImplNotes_Code09_5-02_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.5-02 -- Heads:HereDoc:" do
  it "Terminator Indentation Case - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts, 'var1' => 'variable1' )
%body
  %dir
    %dir
      %vtag<<-DOC
     HereDoc
-# #{var1}
      DOC
HAML
      wspc.html.should == <<'HTML'
<body>
  <dir>
    <dir>
      <vtag>
     HereDoc 
-# variable1
      </vtag>
    </dir>
  </dir>
</body>
HTML
    end
  end
end
#WSE Haml: Extended HereDoc syntax
