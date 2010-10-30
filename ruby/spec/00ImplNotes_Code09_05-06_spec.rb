#00ImplNotes_Code09_5-06_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_5
#         spec --color spec/00ImplNotes_Code09_5-06_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.5-06 -- Heads:HereDoc:" do
  it "Case: Textline Following HereDoc Term - Undented - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver', 'vtag' ],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%body
  %dir
    %dir#d1
      %vtag#n1<<-DOC
     HereDoc Para
  DOC
    %p#n2 para2
HAML
      wspc.html.should == <<'HTML'
<body>
  <dir>
    <dir id='d1'>
      <vtag id='n1'>
     HereDoc Para
      </vtag>
    </dir>
    <p id='n2'>para2</p>
  </dir>
</body>
HTML
    end
  end
end
#WSE Haml: tag "%p#n2" is a sibling to "%dir#d1"
#  The reference is the "%vtag#n1" Head, not the "DOC" delimiter.
