#00ImplNotes_Code09_15-03_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_15
#         spec --color spec/00ImplNotes_Code09_15-03_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.15-03 -- Heads:Whitespace Removal:" do
  it "Trim_out Alignment - WSE Haml" do
    pending "BUG" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
%p
  %out
    %div>
      %in
        Foo!
HAML
      wspc.html.should == <<HTML
<p>
  <out><div>
      <in>
        Foo!
      </in>
  </div></out>
</p>
HTML
    end
  end
end
#Legacy:
#  <out><div>
#      <in>
#        Foo!
#      </in>
#    </div></out>
