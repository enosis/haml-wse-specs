#00ImplNotes_Code09_8-01_spec.rb
#./haml-wse-specs/ruby/spec/
#Calling: rake spec:suite:code_9_8
#         spec --color spec/00ImplNotes_Code09_8-01_spec.rb -f s
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
describe HamlRender, "ImplNotes Code 9.8-01 -- Heads:Tilde:" do
  it "Basic examples - html_escape:true - WSE Haml" do
    pending "WSE" do
      wspc = HamlRender.new
      h_opts = { :escape_html => true, 
                 :preserve => ['pre', 'textarea', 'code'],
                 :preformatted => ['ver'],
                 :oir => 'loose' }
      wspc.render_haml( <<'HAML', h_opts )
%zot
  = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")
  ~ "Foo\n<pre>Bar\nBaz</pre>"
HAML
      wspc.html.should == <<"HTML"
<zot>
  Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
  Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
</zot>
HTML
    end
  end
end
#Legacy Haml: Notice the Tilde ~ operator didn't transform the \n
#    (and the FAP operator, escaped the fresh encoding of \n)
#<zot>
#  Foo\n  &lt;pre&gt;Bar&amp;#x000A;Baz&lt;/pre&gt;
#  Foo\n  &lt;pre&gt;Bar\n  Baz&lt;/pre&gt;
#</zot>
#Legacy Haml:
# Besides the \n bug, there's an inconsistency in whitespace normalization:
#   Why should tilde ~ insert that two-space OutputIndent to align the Baz?
#   a. Actually, at all (given <pre> is option:preserve), and
#   b. When FAP does not also do such alignment/insert (even with newline transform)? 
# WSE Haml assumes the two should give same result ... the FAP result.
