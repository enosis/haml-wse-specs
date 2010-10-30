# haml-wse-specs/perl
# Run Test::More tests for proposed Whitespace Semantics Extensions to Haml (WSE Haml)
#
# Authors:
#  enosis@github.com Nick Ragouzis - Last: Oct2010
#
# Correspondence:
#  Haml_WhitespaceSemanticsExtension_ImplementationNotes v0.5, 20101020
#

VERBOSITY=-1

args     := { verbosity => $(VERBOSITY), color => 1 }
runtests := perl -MTAP::Harness -e 'my $$th = TAP::Harness->new(${args}); $$th->runtests(@ARGV);'

implnotes:
	@echo "Implementation Notes"
	@$(runtests) t/00ImplNotes_Code*.t

helpers:
	@echo "Helpers"
	@$(runtests) t/01helpers.t

initialwspc:
	@echo "InitialWhitespace"
	@$(runtests) t/02initialwspc.t

nesting:
	@echo "Nesting"
	@$(runtests) t/03nesting.t

preserve:
	@echo "Perserve"
	@$(runtests) t/04preserve.t

preformatted:
	@echo "Preformatted"
	@$(runtests) t/05preformatting.t

mixedcontent:
	@echo "MixedContent"
	@$(runtests) t/06mixedcontent.t

hamlcomments:
	@echo "HamlComments"
	@$(runtests) t/07hamlcomments.t

htmlcomments:
	@echo "HtmlComments"
	@$(runtests) t/08htmlcomments.t

multiline:
	@echo "Multiline"
	@$(runtests) t/09multiline.t

verticalwspc:
	@echo "VerticalWhitespace"
	@$(runtests) t/10verticalwspc.t

htmlescaping:
	@echo "HtmlEscaping"
	@$(runtests) t/11htmlescaping.t

heredoc:
	@echo "HereDoc"
	@$(runtests) t/12heredoc.t

wspcremoval:
	@echo "WhitespaceRemoval"
	@$(runtests) t/13wspcremoval.t

doctype:
	@echo "DocType"
	@$(runtests) t/14doctype.t

code_3:
	@echo "Shiny Things"
	@$(runtests) t/00ImplNotes_Code03-*.t

code_4:
	@echo "Motivation"
	@$(runtests) t/00ImplNotes_Code04-*.t

code_7: 
	@echo "WSE In Brief"
	@$(runtests) t/00ImplNotes_Code07-*.t

code_8: 
	@echo "Processing Model"
	@$(runtests) t/00ImplNotes_Code08_*.t

code_8_1:
	@echo "Lexing and Syntax"
	@$(runtests) t/00ImplNotes_Code08_1-*.t

code_8_2:
	@echo "Coarse Hierarchy"
	@$(runtests) t/00ImplNotes_Code08_2-*.t

code_8_3:
	@echo "Elements"
	@$(runtests) t/00ImplNotes_Code08_3-*.t

code_8_4:
	@echo "Indentation"
	@$(runtests) t/00ImplNotes_Code08_4-*.t

code_8_8:
	@echo "Normalizing"
	@$(runtests) t/00ImplNotes_Code08_8-*.t

code_8_9:
	@echo "Whiteline"
	@$(runtests) t/00ImplNotes_Code08_9-*.t

code_9:
	@echo "Content Models"
	@$(runtests) t/00ImplNotes_Code09_*.t

code_9_2:
	@echo "Haml Comment"
	@$(runtests) t/00ImplNotes_Code09_02-*.t

code_9_3:
	@echo "Html Comment"
	@$(runtests) t/00ImplNotes_Code09_03-*.t

code_9_5:
	@echo "HereDoc"
	@$(runtests) t/00ImplNotes_Code09_05-*.t

code_9_6:
	@echo "Preserve"
	@$(runtests) t/00ImplNotes_Code09_06-*.t

code_9_7:
	@echo "find_and_preserve"
	@$(runtests) t/00ImplNotes_Code09_07-*.t

code_9_8:
	@echo "tilde Preserve"
	@$(runtests) t/00ImplNotes_Code09_08-*.t

code_9_15:
	@echo "Whitespace Removal"
	@$(runtests) t/00ImplNotes_Code09_15-*.t

