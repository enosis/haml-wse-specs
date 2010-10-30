# Haml Whitespace Semantics Extension (WSE) Proposals


## About

This is a draft document, at v0.5002, 30 October 2010.
See the bottom for plans, contributions, and TODO.

To dive right in: [Haml Whitespace Semantics Extension Implementation Notes](http://github.com/enosis/haml-wse-specs/blob/doc/Haml_WhitespaceSemanticsExtension_ImplementationNotes.md)

Proposer: Nick Ragouzis, Enosis Group

Contributors:


## Background

In Haml, as is often mentioned, whitespace is _active_.
When creating a HamlSource, an author must attend to the
presence and structure of whitespace -- coping (however
indirectly) with how the lexer will consume it, and the
consequential semantics for the surrounding text.

Over Haml's life, however, several users and observers have
commented about surprising results that frustrate expectations.
Cases include vertical whitespace, multiline processing,
tag and plaintext indentation, and, ironically for a tool
expressly dedicated to production clean and simple XHTML,
the cruft involved in producing a variety of ordinary XHTML.

Apart from personal experience, one trigger for this effort
was [Issue #28, September 2009, filed by nex3, Nathan Weizenbaum](http://github.com/nex3/haml/issues#issue/28)
(the current maintainer of the Ruby implementation), entitled
_Allow variable indentation under certain circumstances_.
Nathan suggested that instead of the current source-wide
constant indentation rule, orderly indentation may be
supported under a slightly looser regime, for example:

      %foo
        %bar
            %baz
              bang
            boom

Such a change would be a richer realization of the Offside Rule
and advance Haml's realization of a [physical ISWIM language, as
defined by Landin in 1966](http://doi.acm.org/10.1145/365230.365257). 
Such a change would probably also
prompt a smile from many a Haml author.

The WSE Haml proposals are detailed in the enclosed Implementation
Notes. Below is a brief review.


## The Proposed WSE Haml Extensions, In Brief


### Orderly Indentation: 'strict'

This is Nathan's rendering from Issue #28:

      %foo                            <foo>
        %bar                            <bar>
            %baz                          <baz>
              bang                          bang
            boom                          </baz>
                                          boom
                                        </bar>
                                      </foo>


### Orderly Indentation: 'loose'

One motivation for a looser regime for orderly indentation
is that file creation and maintenance is just messy, and
the hedge trimming of re-aligning text, when it seems
unnecessary, is just about the most annoying __fail__ of DRY
as there could be, so WSE Haml's oir:loose (the default)
supports the following:


      %foo                            <foo>
        %bar                            <bar>
            %baz                          <baz>
                bang                        bang
          boom                            </baz>
                                          boom
                                        </bar>
                                      </foo>


### Irregular Plaintext, Normalized

      %p                              <p>
          up four spaces                up four spaces
        down two spaces                 down two spaces
                                      </p>


### Mixed Content

      %foo                            <foo>
        %p Inline fragment              <p>Inline fragment
          Nested fragment                 Nested fragment
                                        </p>
                                      </foo>

### Vertical Whitespace

Vertical whitespace consolidates:

      %fruit                          <fruit>
        apples                          apples

                                        oranges
        oranges                       </fruit>
      %vege                           <vege>
        cucumbers                       cucumbers
                                      </vege>

Vertical whitespace terminates Multiline:

      %div                            <div>
        %p                              <p>
          Line1 Pt1 |                     Line1 Pt1 Line1 Pt2
          Line1 Pt2 |                     Line2 Pt1 Line2 Pt2
                                        </p>
          Line2 Pt1 |                 </div>
          Line2 Pt2 |


### HereDoc

A method of providing a content block with free indentation:

      %div
         %pre<<-DEK
         Roses are red,
           Violets are blue;
         Rhymes can be typeset
           With boxes and glue.
                           DEK

      <div>
        <pre>
         Roses are red,
           Violets are blue;
         Rhymes can be typeset
           With boxes and glue.
        </pre>
      </div>


In this example, `%pre` is a so-called _%vtag_, a member of
`option:preformatted`, the WSE Haml default for `%pre`. Members
of option:preformatted are likely to have, or have been assigned,
CSS white-space:pre characteristics.

For the detail on the variety of interactions of filter:preserve,
filter:preformatted, and HereDoc, with flow tags, option:preserve
tags, and option:preformatted tags, see the RSpec or More::Test file
05preformatted, and the files in the 00ImplNotes_Code09_05 suite,
among others.


### Preformatted: Option for tags; filter

A method of preserving content block structure, and protecting
UA rendering, without newline re-encoding.

      %div
        %pre
          :preformatted
             Nested lines
               More Nested lines
              Final line

      <div>
        <pre>
           Nested lines
             More Nested lines
            Final line
        </pre>
      </div>


### HtmlOutput Improved Conformance

*   Idempotent Escapes: _&amp;amp_ never becomes _&amp;amp;amp;_
*   Apostrophe escapes are conditioned on Doctype
*   HtmlComments cannot produce nested Html comments


### And More ...

*   More cases where Initial Whitespace and Leading Whitespace are preserved
*   Improved rules for Haml Comment markup
*   New helpers: `html_tabs` and get/set `html_tabstring`
*   `html-` aliases for the many `haml-` helpers where the domain
    of operation or production is actually more Html.


## Draft Proposal

This is a draft proposal, in the process of being corrected and refined.

### Proposal Content

*   Haml Whitespace Semantics Extension (WSE) Implementation Notes
    (in Markdown and Pod)
*   An RSpec file, [00ImplementationNotes_spec.rb](http://github.com/enosis/haml-wse-specs/blob/ruby/spec/00ImplementationNotes_spec.rb), of all of the code
    snippets from the Implementation Notes document. Deprecated;
    will be removed after draft v0.5.
*   A collection of RSpec files, one for each code snippet from the
    Implementation Notes document (initially: 61 files).
*   A collection of RSpec files by major extension topic
    (initially: 14 files).
*   A [Rakefile](http://github.com/enosis/haml-wse-specs/blob/ruby/Rakefile)
    with suites to allow you to run the entire suite of code in the
    Implementation Notes document, and by each major topic section.
*   A parallel collection of Test::More files, for running against
    vti's Text::Haml.
*   A parallel [Makefile](http://github.com/enosis/haml-wse-specs/blob/perl/t/Makefile).

Why such a big load of stuff? Well, one of us (Ragouzis) started
just implementing the various extensions, piecewise. But then ...
indentation is really a subset of determining the extent of a
ContentBlock, which impacts interpretation and handling of
initial whitespace, and leading whitespace, mixed content, and
other whitespace consolidation including handling of newlines
(which brings in trailing whitespace). Whitelines are also
intimately involved with ContentBlock extent. Add to that
the idea that it might be worthwhile to have a form of
HtmlOutput that can represent those same varying indentation
structures without newline transforms. Suddenly, you have
a nice little puzzle.


### Implementation

Please be careful to note: the focus here is not on Haml as an
adjunct macro utility to Rails, but on Haml as an independent
language for generating HtmlOutput.

Although both nex3's Ruby Haml and vti's Perl Text::Haml
implementations are of interest, this proposal is slated for
implementation on vti's Text::Haml implementation.

The main reason for this choice is that, indeed, the Perl
implementation is focused more on chomping HamlSource and
producing HtmlOutput.

Also, Text::Haml is less a straight regex-macro processor,
as is the Ruby implementation, and more a nascent tree
grammar parser. It is the regex-macro processor characteristic
that produces in the Ruby implementation such burps as the nested
HtmlComments, the problematic way HamlComments are lexed and parsed,
and the whack Html Escaping. The Text::Haml implementation
exhibits none of these ... but, true, it has other challenges.

Perhaps the main reason for this choice is more about user
expectations: compared to the Ruby implementation, the Perl
implementation (although frustratingly lacking some features)
already sports a more liberal interaction, resulting
in a better match to expectations in HtmlOutput.


### Plans, TODO

*   The primary task remains refining, correcting, and completing
the draft proposal.
*   Implementation in Text::Haml of baseline improvements (independent
of WSE Haml extensions)
*   Implementation of select WSE Haml extensions in a variant of Text::Haml
*   Implementation of select WSE Haml extensions in a variant of Ruby Haml


### Contributions, Comments

Please comment on the proposals through any of the usual means.
Add or up/down-vote issues and proposals; implement aspects you
find interesting.

Issues posted at enosis/haml-wse-specs are likely to get attention,
as are patches or pull requests. Don't feel compelled to post here
if you conclude your issue, even if related to these proposals,
should be directed at the Ruby implementation.

In correcting or commenting on the Implementation Notes, or
the ImplNotes_Code files, feel free to test or patch just one
instance (the Pod or Markdown, the Test::More or RSpec) -- you
needn't repeat yourself in all the appearances.


### Relationship to Other Work

*   Github [nex3/haml](http://github.com/nex3/haml): Ruby implementation

*   Github [vti/text-haml](http://github.com/vti/text-haml): Perl implementation

*   Github [norman/haml-spec](http://github.com/norman/haml-spec): Additional test suite

