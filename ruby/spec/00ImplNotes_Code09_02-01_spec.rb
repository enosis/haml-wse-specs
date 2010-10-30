#00ImplNotes_Code09_02-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_2
#         spec --color spec/00ImplNotes_Code09_02-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.2-01 -- Heads:HamlComment:" do
  it "Lexeme BOD" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => false,
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'strict' }
      wspc.render_haml( <<'HAML', h_opts )
.zork
  %p para1
  -# Haml Comment Inline
  %p para2
.gork
  %p para1
  -#
     WSE Haml Comment Nested
  %p para2
HAML
      wspc.html.should == <<'HTML'
<div class='zork'>
  <p>para1</p>
  <p>para2</p>
</div>
<div class='gork'>
  <p>para1</p>
  <p>para2</p>
</div>
HTML
    end
  end
end
#Legacy Haml:
# Haml::SyntaxError,
# /Inconsistent indentation:.*spaces.*used for indentation, but.*rest.*doc.* using 4 spaces/
#WSE Haml:
# Notice: "Pending WSE" because the Comment designated as
# "WSE Haml Comment..." would, in legacy Haml have to be
# indented one (document-wide fixed) IndentStep from
# the '-' in '-#' ... typically two spaces, and could not
# be aligned as shown (or easily inserted above text an
# author wants to make transparent).
