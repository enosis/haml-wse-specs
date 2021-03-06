# Haml Whitespace Semantics Extension (WSE) Implementation Notes

  Draft v0.5002, 30 Oct 2010

## Authors

  Proposer: Nick Ragouzis, Enosis Group (http://enosis.github.com/)

  Contributors:

## RSpec and Test::More

A suite of specifications and tests accompany this text.

In an earlier draft, file _OOImplementationNotes_, contained all the code,
in sequence (with the associated major head identified), as found in this
document (WSE Implementation Notes). That file was created as a Ruby RSpec
file provided through draft v0.5; it is slated to be removed after draft v0.5.
The parallel Test::More file was not created.

Instead, each code snippet is provided separately, as, for example,
`./ruby $ spec --color spec/00ImplNotes_Code09_05-10_spec.rb -f s`.

These may be run in suites through use of the provided Rakefile, using the
form `./ruby $ rake spec:suite:code_9_5`, for example. You may run the
entire RSpec 00ImplNotes_code suite using `./ruby $ rake spec:implnotes`.
See the ruby/Rakefile.

A Test::More collection is also provided. For example:
`./perl $ perl t/00ImplNotes_Code09_05_10.t`. These may be run in suites,
for example: `./perl $ make code_9_5`. You may run the entire 00ImplNotes_Code
suite with `./perl $ make implnotes`. Read t/Makefile.

The files numbered from __01__ to __14__ are by topic, contain specifications
and demonstrations of WSE Haml extensions, and a few of the bugs in
legacy Haml. We _highly_ recommend a detailed review of those files,
as not all aspects of the proposed WSE extensions are documented in
this text, and not all bugs encountered in legacy Haml (Ruby, or
Perl ... and the bugs do differ) are documented in this text.



## Shiny Things

      Code 3-01

      Haml                              Html
      ---------------------             -------------------------
      %gee                              <gee>
        %whiz                             <whiz>
          Wow this is cool!                 Wow this is cool!
                                          </whiz>
                                        </gee>

The above is from the HAML_REFERENCE[1], which introduces Haml
(_XHTML Abstraction Markup Language_) as 

      ... a markup language that's used to cleanly and simply 
          describe the XHTML of any web document...

And breezy cool it is.

And yet ... there is a sense that Haml is a bit tetchy. 

Although Chris Eppstein, in 2010, makes the distinction between content versus 
layout[2], the challenges he cites do not hew to that distinction; they have a
more fundamental emanation. Those challenges share a common thread with many 
forum questions (Google and SO) about Haml. These also share a common thread 
with the problems Nathan Weizenbaum worked through in 2008[3]. 

That common thread: the ancient concern of author control.

This rises to ironic levels with Haml. Haml is not just (another) macro
processor with embedded language capabilities; from a clean and simple
description of XHTML, it promises well-formatted XHTML output. In other 
words, it dresses up for just the geeks who are drawn to author control, 
and then leaves them a bit disappointed.

The extensions proposed in this document (and illustrated in the accompanying
RSpec suite), Whitespace Semantics Extensions, or WSE, attempt to address one
large and pervasive component of those problems: whitespace, its specification
by authors, processing by Haml to recognize author intent, and it appearance 
or absence in Haml output.

Although some will see this proposal as _quite enough,thank you_, a reviewer
or implementer, or author, will likely see other candidates for improvement.
It is our hope this proposal will kick off further discussion, corrections,
and improvements by the community.

- [1] [HAML REFERENCE](http://ham-lang.com/docs.yardoc/file.HAML_REFERENCE)

- [2] [Chris Eppstein](http://chriseppstein.github.com/blog/2010/02/08/haml-sucks-for-content/)

- [3] [Nathan Weizenbaum](http://nex-3.com/posts/75-haml-whitespace-handling-sucks-too)


## Motivation

About a year ago, circa September 2009, Nathan Weizenbaum (nex3, the 
maintainer of the Ruby implementation of Haml) filed Issue #28, entitled 
_Allow variable indentation under certain circumstances_. 
Visit: [GitHub nex3 Haml Issue 28](http://github.com/nex3/haml/issues#issue/28).

Nex3 says (with our RSpec code references inserted):

      Label: Hard

      We want to allow variable indentation as long as it's unambiguous. 
      For example, the following:

      Code 4-01

      %foo
        %bar
            %baz
              bang
            boom

      should be [rendered in HtmlOutput] the same as:

      Code 4-02

      %foo
        %bar
          %baz
            bang
          boom

Nex3 continues:

      However, wherever we currently would raise an error, a 
      warning should be printed.

      Ambiguous cases should still be marked as erroneous. 
      For Example, the following

      Code 4-03

      %foo
          up four spaces
        down two spaces

      should raise an error on the "down two spaces" line.

As preview, here is one WSE Haml interpretation:

      Code 4-04

      %foo
          up four spaces
        down two spaces

      <foo>
        up four spaces
        down two spaces
      </foo>

For alternatives, see the referenced code spec, and other rspec suites
mentioned there. For example, had tag 'foo' been a member of
`option:preformatted`, the two line's relative indentation would have
been replayed in HtmlOutput.

The extensions to whitespace semantics proposed in this document attempt
to spell out the implementation of such a change, and its ramifications.

Well, a bit more than that ... because on initially reading Issue 28, 
it seemed it is probably unnecessary and unhelpful to raise warnings, and 
it is probably possible to disambiguate the case above which nex3 labels 
as ambiguous, and many others as well.

Yes, that's all it took, and after a bit of study and testing, here you go.
And, yes, if only because there were a few other teensy irregularities to
sort out: hard.



## Background, or The Case For Change

We think we can improve things a little for Haml authors.

This document accompanies a Perl implementation of proposed extended 
whitespace semantics for Haml. We propose and demonstrate several ideas, 
some extensions of which address issues already seen, while other 
extensions are part of improving some aspect related to the whitespace 
semantics. 

The focus is, most specifically, on the block structure and  whitespace 
characteristics of Haml source, and of the resulting HTML.

As a language, Haml grants significant semantic power to whitespace.
Yet, the semantics and implementation remain somewhat rough, as is
revealed with a brief experience with Haml, or a quick run of just
a bit more complicated test cases, or a perusal of the issues filed
on GitHub including ideas logged by the current maintainer 
_nex3, Nathan Weizenbaum_.

We treat Haml as a domain-specific language for describing HTML, and XML 
(including XHTML) files. (We say "Html" except where differences are 
significant and non-obvious; in this we depart from the Haml specification, 
for reasons that we hope will become obvious.) 

Coarsely, Haml offers: a tag macro language, a templating and variable 
substitution language, and access to underlying programming language 
facilities. 

In form, Haml is marked most by two characteristics:

1. By representation of HTML elements through use of start macros, and

2. By use of indentation, which demarks the extent of model content.

In Haml's history most of the conversations around author expectations
of whitespace and input or output formats have been resolved by finding 
some other way to get the desired results, or sometimes by language 
extensions or fixes. Some entirely reasonable author inquiry about their 
(entirely reasonable) expectations regarding whitespace and Haml's ease 
of use has been met with "don't do it that way", and others by 
"that's unimportant, not what Haml's about".

These latter responses are unsatisfactory, especially since, well,
whitespace is important to folks for whom whitespace is important.

Consider for a moment: As with Html, Haml is used to describe the hull, 
framework, and substructure of a webpage (by means of the Html it yields). 
Both can be said to carry the design of the page, but neither embody a 
design language (just as it would be clumsy to call "I" beams and rivets 
the design language of a bridge). Haml, rather, strikes a tradeoff: for some
of the advantages in writing in or designing to 'pure' Html, Haml defines 
an attractive engineering shorthand. The syntax and surface structures of 
Haml, and the resulting Html, are tuned to deliver related benefits in 
simplicity and clarity. 

So, authors who adopt Haml directly are essentially similar to those using
Html directly, yet they seek the core benefits of Haml: abbreviated 
descriptions and relief from nuisance syntax. They also seek, or appreciate,
improved legibility. For this they will accept certain tradeoffs and 
limitations.

For one author of this document (Ragouzis), it seemed a particularly 
bothersome breakage of DRY when Haml mercilessly condemn to that 
brain-dead drum circle of hedge-trimming (re-indenting) text. 

It seems a particularly bothersome breakage of DRY, however, when Haml 
mercilessly condemn the author to that brain-dead drum circle of 
hedge-trimming (re-indenting) text. 

Who is to say authors must forfeit benefits or practices that Html itself
made possible? Despite all its detractions, Html's essential characteristic
is that humans can parse it, and through text surface structure, whitespace,
and grouping (which are distinguished less by stricture than by a loose, 
even expressive, flexibility), authors could achieve improved scanning, 
legibility, comprehension, and maintainability of the Html. (Even Adobe 
Dreamweaver gives a nod to this effect, with options for block and 
whitespace structures in the resulting code.)

Granted, at production, and certainly at browser rendering, all of these 
benefits are much less salient. But Haml, and the need for working through 
Html, is more a part of the earlier part of the process: the beginning, and 
the vast and distributed middle. As a result, questions about, and control of
whitespace in the resulting Html is a legitimate consideration for Haml 
design, implementation, and relevant to its acceptance.

In short: Whitespace and block structure matters in input, and output; the 
most credible claims to the contrary are those offering significant,
demonstrable, improvements to legibility or brevity. 



## Haml Whitespace Processing, Overview

In Haml, whitespace is 'active.' Parsing Haml can be viewed, largely, as the
lexical decoding of whitespace, and assigning semantics to whitespace-related
productions and proximate text.

The whitespace of a HamlSource, or (Haml) template, determines both 
HamlSource processing, and the appearance of the HtmlOutput. To that is 
added the semantics of the non-whitespace tokens, which include text to be 
transformed, text to be copied through, evaluation forms, and a few 
processing instructions. For the most part, this document pushes transforms
and processing to the background: the focus is whitespace.

Notice that this document concerns Haml itself, not the related
mechanisms. We will be working with the HamlSource, and the HtmlOutput.

In the Haml literature, sometimes the HamlSource is referred to as a
template, or a partial; sometimes it is the output that is called a 
template. It is true that in actual applications the input may be 
substantially a document of interpolation and computation, or that the 
output may be substantially a document prepared for further interpolation 
and computation. Regardless, here we do not work with templates of any 
kind: a HamlSource is prepared by an author, processed by the Haml processor,
producing an HtmlOutput.

For this document and implementation, here's the setup:

                   HamlSource 
                       |
                       v
      Haml Processing: Interpreter & Generator
                       |
                       v
      (black box: interpolation & computation) 
                       |
                       v
                   HtmlOutput

The Haml syntax is (mostly) inert wrt template-like processing: e.g.,
erb <%...%> means nothing in HamlSource syntax. So, although the 
following are possible processing models, these extensions do not
look to their requirements:

      HamlSource --> TemplateOutput (with templating constructs)

      HamlSource --> ERB (Ruby-Html) template --> ('pure')HtmlOutput

      SassSource --> (Haml-like syntactic analysis) --> CSS 

In other words, with the focus on HamlSource, and its resulting HtmlOutput 
(no matter how embellished) the extensions to whitespace semantics (WSE) 
discussed here do not consider templates or intermediate forms and
processing. If you are concerned with these other areas, you might be able
to expand on these extensions or their support -- that would be great.

A HamlSource begins in the first column of the first line (denoted indent 0
of line 0). A Haml document tree is built up from there, through a series of
Elements, in succession. Mostly, the tree is built up in depth-first,
'preorder', fashion, where each parent directly contains and in similar
fashion describes all of its children, although some variance from this is
provided by variable assignment and substitution, evaluation forms,
and processing instructions.

We propose three frames for whitespace semantics:

1.  HamlSource lexical and syntax scanning and analysis

    This frame concerns understanding and codification of author intent
    through inclusion or omission of whitespace. The obvious case is the
    indent-sensitive grouping of content. Less obvious: the mixing of 
    content models or the relationships of sequential blocks.

2.  HtmlOutput code format

    Whitespace in HamlSource also signals an author's intent for formatting of
    HtmlOutput. Indenting of output is a simple case. More complicated is the 
    treatment of trailing or internal whitespace, or preformatted or 
    interpolated texts.

3.  HtmlOutput code content

    This frame of whitespace semantics concerns the content of the view, plus 
    any necessary view-related concessions. Some generated forms must concern 
    themselves with the content itself, and even how Html UA (and similar) are 
    likely to interpret the content. Think Html &lt;pre&gt; and friends.

The proposed extensions touch on all three frames, including that second
frame where, thus far in Haml development, the extent of attention has 
been what has been called _tabbing_ (output indentation). The extensions
proposed here suggest improvements in these whitespace semantics utilizing 
available degrees of expression in the HamlSource.



## The Haml Whitespace Semantics Extensions (WSE), In Brief

Main points:

-   Mixed Content 

    A mixture of Inline Content (on the Head) and Nested Content

-   Plaintext Nesting 

    Nesting is now permitted in Plaintext HamlSource, for most operators

-   OIR:strict for Tag Indentation

    Set the Orderly Indentation Rule similar to Legacy Haml, with more
    flexibility for IndentStep Indents and Undents, removing many aspects
    of the tedious indent tidying during content and layout maintenance.

-   OIR:loose for Tag Indentation

    The default in WSE, simplifying the blocking rules immensely, without
    ambiguity. Entirely removes tidying tedium where, after maintenance of
    content or layout, content remains a descendant of the preceding elements.
    Copy-paste maintenance is also simplified.

-   Vertical Whitespace 

    Vertical whitespace will now separate Html hunks (changed handling of
    whitelines)

-   Multiline Processing 

    Improvements to the syntax for adjacent Multiline blocks, to Haml Comment 
    processing, and introduction of Whiteline termination.

-   Haml Comment Markup 

    Improved rules for Haml markup comments

-   Preformatted

    An extension of `option:preserve`-like semantics, with Mixed Content,
    without newline transforms, with HtmlOutput having symmetric start tag
    and end tags, and limiting the use in HtmlOutput of an Inline fragment
    except where reflecting author's use in HamlSource.

    Three mechanisms provide this facility, each with somewhat different
    features: `option:preformatted` membership for tags (denoted here as
    'vtag', for verbatim); `filter:preformatted`; and the HereDoc
    (described separately).

    In WSE Haml, by default, `%pre` and `%textarea` shift from membership
    in `option:preserve` to `option:preformatted`. Authors will likely
    add to `option:preformatted` any tags for which they assign CSS
    _white-space:pre_-like mechanics.

-   HereDoc

    Introduction of HereDoc << to supply a ContentBlock with leading
    whitespace and newlines preserved, which is then processed according to
    the Head's semantics. A part of the facility for preformatted semantics.

-   html_tabs 

    A new helper, yielding the count of 'tabs' in the current OutputIndent.

-   html_tabstring 

    A new helper, get/set the string used for a single 'tab' of the OutputIndent.

-   Escaped HtmlOutput

    When an author requests HtmlOutput with parts of it transformed to
    prevent its later interpreted as part of Html document syntax, WSE Haml
    now implements an idempotent, fixed point, model:
    _&amp;_ never becomes _&amp;amp;_.

    Further, the transformation to character entity references is conditioned
    on doctype and Haml options.

    For more about the motivations about this change, see Escaped HtmlOutput
    in the Glossary.

As a quick preview of Haml with the WSE extensions, the following,
with varying indent and nesting, just works:

      Code 7-01

      %div#id1
          %p cblock2
          %p cblock3
      %div#id2
        %p cblock4
             cblock4 nested

As does this, which is the above, perhaps after a bit of maintenance,
exhibiting an undent that does not return to a prior level of
indentation:

      Code 7-02

      %div#id1
          %p cblock2
             cblock4 nested
          %p cblock3
        %p cblock4

In both cases, WSE Haml sees what you mean, and creates spiffy HtmlOutput.

      <div id='id1'>
        <p>cblock2</p>
        <p>cblock3</p>
      </div>
      <div id='id2'>
        <p>cblock4
          cblock4 nested
        </p>
      </div>


      <div id='id1'>
        <p>cblock2
          cblock4 nested
        </p>
        <p>cblock3</p>
        <p>cblock4</p>
      </div>

The above shows the extension of Mixed Content to a full ContentModel type,
with examples of the resulting rendered HtmlOutput showing the Inline
portion of the Content rendered immediately after any Html start tag.

Great ... but: the principles behind that change prompt a related change
to the rendering of an Inline Content ContentBlock having newlines, such as
can occur with interpolation, `= expr`, or similar: like the above, the
initial whitespace, and the initial text is rendered immediately after any
Html start tag. For some Haml users, this will be WSE Haml's most obvious
departure of existing facilities from the Legacy Haml rendering.

      Code 7-03

      :strvar => "foo\nbar"

      %p
        = strvar
      <p>
        foo                        # Normalized indent, just as other cases
        bar
      </p>

      %p= strvar                   # WSE Haml: Start my var's content tight
      <p>foo
        bar                        # Normalized indent, just as other cases
      </p>

      %p eggs #{strvar} spam
      <p>eggs foo                  # Same mechanisms applied to previous case
        bar spam
      </p>

These are taken from the Code 08-8 suite of sample code, below, which
contains further examples and discussion.


## Processing Model -- Haml Whitespace Semantics Extensions (WSE)

This section walks through the processing model for whitespace, starting
mostly from guiding principles and the basic elements, and eventually 
moving to specific cases (to which you may be wise to directly skip).

Terms are introduced and explained in place. Please, however, see the 
__Glossary__: you should probably scan it first.

These extensions attempt to be neutral wrt implementation language. 
Be on your guard, however: the Ruby and Perl implementations 
evaluate certain Haml forms at different times and in different dynamic 
contexts. The processing of the results of interpolation is one such area.
It's possible some of that has snuck in here.



### Model of Lexing and Syntactics

From the Haml Reference:

      A substantial portion of any Html document is its content, 
      which is plain old text. ...

An important aspect of the WSE processing model wrt legacy Haml concerns
the model of lexical and syntactical analysis. With respect to lexing 
and syntactics, the legacy implementation (and language design) treats 
the challenge as, essentially, that of an executable language. 
Like Python, for example; but Haml is not Python. 

That approach is a contributor to a confusion captured in the dispiriting 
meme: _Haml is for layout, not content_.

WSE recognizes the difference in these models, aligning lexing and syntax 
more with Haml's actual lexical and syntactical nature: as a macro language. 

An executable language consists of, mostly, active constructs, 
statements and expressions, and such; all other content is narrowly 
constrained or contained. In a macro language the situation is reversed:
the focus is on content, of which macro languages are much more tolerant.
Basically, when a processor of macro languages is not operating directly 
on its own lexemes, it accepts anything. 

Consider, for the starkest of examples, a random (unclosed) `#{...` or 
even `=1 + {`. Under the legacy implementation, the lexer fails and, 
consistent with an executable language approach, terminates the entire 
rendering (in a full Java-esq cascade of errors). Under WSE, the lexer 
(conceptually) runs to the end of the plausible branch, backtracks, 
and fires that construct as plaintext. 

Legacy Haml generates an exception:

      Code 8.1-01

      %div
          %p #{varstr

      Haml::SyntaxError,/Unbalanced brackets/

In WSE Haml, a construct is plaintext unless it fully satisfies some
branch of the syntax:

      Code 8.1-02

      %div
          %p #{varstr

      <div>
        <p>#{varstr</p>
      </div>

That is but one, albeit stark, example of an overall effect. The change 
under WSE provides more expressive latitude for authors, less tedious 
hedge-trimming.


### Coarse Hierarchy of Constructs

Another important aspect of the WSE processing model is the coarse-grained
hierarchy into which Haml constructs are divided. We consider these four 
divisions, with the lexer, the tree builders, and the interpreter/parser 
each dispatching the first-mentioned constructs earlier than the 
later-mentioned:

- Processing Instructions, such as encoding

- Meta Constructs, including, for example: Haml Comments

- Macros (Haml tags), Expressions, and Transforms

- Content (e.g., plain text)

The WSE model assumes the operation of a separate lexer and syntax
analysis, which builds an abstracted tree of the HamlSource. From 
this tree, WSE Haml forms an abstraction of the HamlSource semantics.

How is that significant? Consider for example the Multiline syntax. 
The related text arrives at the later code generation stages with the 
Multiline pipe lexeme `" |"` stripped. This sort of interpretation 
improves author predictability (the first semantic frame, from above), 
sets up an interpretation that parallels the other Haml constructs (the 
author can apply the same reasoning with regards to whitespace as if 
the syntax were the more usual Haml prefix syntax rather than infix) 
and control over included whitespace in the HtmlOutput (the second 
semantic frame) ... and makes sense of a bug fix (a nit) to the legacy 
Ruby implementation.

As an example of the significance of this hierarchical division, and of the
consequential operational model, consider Haml Comments (apart from their 
role as Processing Instruction). Starting at the bottom of the hierarchy, 
Haml Comments are transparent in Content. Moving upwards, Haml Comments are 
neither macro, expression or transform. Haml Comments are, in WSE, meta 
constructs -- they are one of the few Haml tags that describe the semantic 
nature of their accompanying ContentBlock. The semantic for 
Haml Comments: "ignore, entirely, me and my ContentBlock."

Changing to this processing model has two consequences. The most important:
Haml Comments are of lesser significance (in every semantic frame) than 
Whitelines (lines having only whitespace and a newline). Whitelines are 
content, they have a meaning, and they impact HtmlOutput structure and 
content; Haml Comments do not. The corollary: Haml Comments are semantically
invisible to every lower division. 

One simple way this model and its consequences become concrete is with 
the Multiline syntax: Whitelines have salience; Haml Comments do not. 
That is, Haml Comments are semantically impotent (i.e., invisible, 
non-existent) at the point where content is synthesized into HtmlOutput. 
A Whiteline can, therefore, separate two blocks of Multiline syntax. 
This introduces a much more natural syntax, removing some cruft in the 
HamlSource ... at the cost of slight corner-case backward incompatibility 
in the format of the HtmlOutput (but not in the (X)HTML semantics of the 
HtmlOutput).

For example, under WSE Haml (modulo trailing and leading whitespace):

      Code 8.2-01

      %foo
        First |
        Block |

        Second |
        Block |

      <foo>
        First Block
        Second Block
      </foo>

WSE Haml processing mode: by the time the Multiline ContentBlock is
processed, the Haml Comment is already removed:

      Code 8.2-02

      %foo
        First |
        Block |
        -# Haml Comment    # WSE processing model changes the AST
        Second |
        Block |

      <foo>
        First Block Second Block
      </foo>

While we are here considering Multiline, a related way in which the 
WSE processing model changes the semantics of Whitelines (of that
second semantic frame) -- multiple Whitelines are consolidated to 
a single Whiteline:

      Code 8.2-03

      %foo
        First |
        Block |



        Second |
        Block |

      <foo>
        First Block

        Second Block
      </foo>

Finally, under WSE Haml, a Whiteline will terminate the Nested ContentBlock 
of a Haml Comment. This is discussed in greater detail below.



### Elements

An Element:

      Code 8.3-01

      %p
        Text

In shorthand, an Element is some Haml token, and its content. More formally, 
an Element prompts a state change in the parser syntax tree.

Similar to XML, the HamlSource document is the root; in Haml all Elements 
appearing (in effect) at any given column index, including the first column,
are siblings.

Each Element is a collection of tokens describing the Head and a (possibly
null) ContentBlock, which follows some Content Model.

In Haml, the tokens that comprise an Element Head includes levels of 
indentation. Made explicit, with '.' representing indentation, an Element
Head of '`....%span`' below an Element Head of '`..%p`' describes a parent-child
relationship.

      Code 8.3-02

      ..%p 
      ....cblock1
      ....%span cblock2

      <p>
        cblock1
        <span>cblock2</span>
      </p>

A line's indentation is significant in determining its membership in a 
ContentBlock.

A Whiteline is a line containing the final \n with zero or more whitespace
characters preceding: a linespace or (if devoid of characters except the \n)
a blank line. 

(The qualified name for it's complement is 'Textline', or 'Non-Whiteline'. 
When the distinction is irrelevant, both are just 'Line'.) 

Whitelines can be significant in determining the extent of an Element and its 
ContentBlock.

In general, HamlSource is expected to yield an Html document, although (apart 
from the exigencies of parsing, and limited consideration for attribute and
tag syntax, and character sets) no document model or Html element content
model is enforced for the HamlSource nor for the resulting Html. The (current)
sole exceptions are:

- Encoding

    Encoding may be specified by a processing instruction (in Haml Comment
    syntax) at the beginning of the HamlSource.

- Special character escaping

    Escaping of the 'fifth' special character, apostrophe, is, under WSE,
    limited to documents using an effective XML-related doctype or escaping 
    option. Additionally, the (WSE-corrected) `filter:escaped` (alias:
    `filter:escapehtml`) will perform the same processing wrt those special
    characters.



### Indentation

Indentation is a measure: the column index of the first non-whitespace 
character following a prior newline.

After processing instructions, the first non-whitespace character of
a HamlSource must have an Indentation of 0.

Note: This is a discussion concerning HamlSource. Regardless of these 
concerns, when HtmlOutput is generated the size of each OutputIndent 
is a fixed size: by convention 2 spaces, and get/set-able by helper 
`html_tabstring`, a WSE extension. The number of OutputIndents to be 
used when next needed is get-able by (WSE extension) helper `html_tabs`
and modifiable by helpers `tab_up`, `tab_down`, `with_tabs`.

This section will touch on several fundamental concepts. They include:

- The Indentation measure

- The Offside Rule

- The IndentStep, Indent, and Undent

- The Orderly Indentation Rule

- The Block Onside Demarcation (BOD)

Indentation in HamlSource is of primary significance in determining
the scope of a ContentBlock. It is not the only consideration. 
To a smaller extent, e.g., Whitelines are also significant.

In consequence, Haml is a physical ISWIM language observing the general rule 
that a construct be defined in its "southeast quadrant", which gives rise to 
the Offside Rule [4]: Indentation is used to indicate program structure.

Landin defined ISWIM as a four-level concept. With respect to getting 
concepts clear, Python is also a physical (level-1) ISWIM language, 
but is a realization of a narrowed, parochial, interpretation of the 
general abstract (level-3) ISWIM concepts. That's for good effect. 
Legacy Haml, however, hardened Python's interpretation by insisting 
that the indent be everywhere constant (say, 2 spaces). This is 
unnecessary for Haml.

Under default WSE Haml the rule is, just: Stay to the Right.

This abstract example shows a constant 2-space indent (the __IndentStep__)
throughout. It is compatible with legacy Haml implementations.
 
      Code 8.4-01

      HEAD1
       HEAD2
         HEAD3
           Content1
           Content2
       UNDENTLINE

The following example observes the same rules. Below we'll annotate and 
adjust it to demonstrate several aspects of WSE Haml.

      Code 8.4-02

      ..%div#id1
      ....%p cblock1
      ....%div#a
      ......%p cblock2
      ......%p
      ........cblock3
      ..%div#id2
      ....%p cblock4

Such indentation describes the tree: In legacy Haml a child is indented 
by a single IndentStep from its parent; siblings (and cohort cousins) 
have the same IndentStep count (number of identically-sized IndentSteps).

The unadorned general abstract (level-3) ISWIM concepts offer more
flexibility: given that a construct's definition is onside (indented to 
the construct's right), the rules for its interior nesting are unspecified, 
and may vary by physical ISWIM language implementation.

As an ISWIM language, WSE Haml implements these more general abstract-level
concepts. WSE Haml calls its nesting rule the Orderly Indentation Rule (OIR). 

WSE Haml provides three OIR modes: _unobserved_, _strict_, and _loose_.

Not all Haml constructs observe OIR: for example, the Multiline syntax.
Most constructs do observe the OIR. The 'strict' mode of OIR will enforce 
a slightly relaxed form of the legacy indentation rules. 

Under `OIR:strict`, the IndentStep must be constant _within an Element's
immediate ContentBlock_. `OIR:strict` allows the structure shown here.
Notice the changing size of the IndentStep (some might say it allows
improved cosmetics in HamlSource):

      Code 8.4-03

      ..%div#id1
      .....%div#a cblock1
      .....%div#b
      .........cblock2
      .........%p
      ............cblock3
      ..%div#id2
      ......%p cblock4

Under `OIR:strict`, an Undent must 'unfold' (or 'pop') some number of the
preceding IndentSteps to return to the column of a prior indent, as 
with `%div#id2`.

Imagine that maintenance called for removing most of `%div#b`, deleting
`cblock2` and the `%p` element, leaving only the `cblock3` content. The 
following also would conform to `OIR:strict`:

      Code 8.4-04

      ..%div#id1
      .....%div#a cblock1
      .....%div#b
      ............cblock3
      ..%div#id2
      ......%p cblock4

Here, in the resulting tree, despite differences in the size of the 
IndentStep, `%div#a` and `%p cblock4` are at the same level: first 
cousins.

The default for WSE Haml is, however, `OIR:loose`, to which the following,
perhaps after further maintenance, would conform. (Yes, not a typo: the
Indentation of `%p cblock4` is only one more than that of `%div#b`.):

      Code 8.4-05

      ..%div#id1
      .....%div#a cblock1
      .....%div#b
      ............cblock3
      ......%p cblock4

For the concrete implementation of a general, abstract (level-3) ISWIM 
language, like WSE Haml, there is only one, unambiguous, interpretation of 
this HamlSource, for any Offside Rule-compliant substitution for `cblock3` 
or `%p cblock4`: they are siblings. Haml gives:

      <div id='id1'>
        <div id='a'>cblock1</div>
        <div id='b'>
          cblock3
          <p>cblock4</p>
        </div>
      </div>

(This demonstrates how the case discussed in Haml github issue 28 is,
under `OIR:loose`, unambiguously resolved for any Offside Rule-compliant
substitution of the two lines: the two descendants are siblings.)

The example above gives occasion to clarify a few related concepts. 

To put it into operation, "offside" requires a condition or point of
reference. For WSE this point of reference is called the
Block Onside Demarcation (BOD): the Element's complete definition must
fall at that Indentation or greater. The minimum Indentation for an
Element's BOD is its Head's Indentation plus 1.

      ..%div#id1
      .....%div#a cblock1
      .....%div#b
      ............cblock3
      ......%p cblock4

            ^
            | BlockOnsideDemarcation for %div#b (OIR:loose)
              Thus %p cblock4 is "onside"

Under `OIR:strict`, the IndentSteps under an immediate Element will be
constant: the Textlines will demarcate a single clear column. 

Under `OIR:loose`, however, the size of the IndentStep may vary even within
the immediate Element.

      ..%div#id1
      .....%div#a cblock1
      .....%div#b
      ............cblock3
      ......%p cblock4

      ..            IndentStep=2  for `%div#id1`
        ...         IndentStep=3  for `%div#a` and `%div#b` 
           .......  IndentStep=7  for `%p cblock3`
        ....        IndentStep=4  for `%p cblock4`

Offside is part of a state change too. A Textline is considered Onside
when it's Indentation is equal or greater than an Element's BOD; otherwise
it is Offside. A Textline is said to have 'moved' Offside when it appears
as the first Textline to have Indentation less than the prevailing BOD
(with 'moved' Onside as a rare description of the inverse case).

Still in `OIR:loose` (the default):

      Code 8.4-06

      0 00 000    1
      0 23 567    2
      ..%div#id1
      .....%div#a cblock1
      .....%div#b
      ............cblock3
      ......%p cblock4
      .....%div#id2

            ^
            | BlockOnsideDemarcation for %div#b (OIR:loose) (Indentation=6)
           ^
           |  Offside move, for Textline `%div#id2` (Indentation=5)
         ^
         |    BlockOnsideDemarcation for %div#id1 (Indentation=3)

Notice in the above that the smallest Undent for Textline `%div#id2` shifts 
it Offside into the `%div#id1` ContentBlock, as a sibling. Any move offside,
Undent, between Indentation 5 and 3 would have had the same result.

In a HamlSource describing an ordinary HTML document, after the encoding PI, 
and doctype macros, it would be most common for most Textlines to never go 
Offside past the second BlockOnsideDemarcation (here, demarcated by CONTENT):

      Code 8.4-07

      0 2 4
      %html
        %head
        %body
          CONTENT

There is the potential for a variety of HamlSource whitespace forms which
result in different treatments, such as those for Multiline or HereDocs.
Also, there is a variety of HtmlOutput whitespace forms, including a
difference under `option:preserve` or `option:preformatted`.

In summary of the basic indentation rules:

-   Legacy 

    IndentSteps are constant throughout

-   OIR:strict 

    IndentSteps must be the same within an immediate Element. 
    Undents must unfold (pop) some number of prior IndentSteps.

-   OIR:loose 

    IndentSteps may vary within an immediate Element, provided
    they stay Onside: with Indentation equal or greater-than that
    of the prevailing BOD.

Exceptions to the above arise with certain specific structures. Some
of the annotations are rather cryptic or are introduced here for the
first time. Refer to descriptions later in this document.

                  Observe    Require
                  Offside    OIR      Notes
      ---------   -------    -------  ------------------------------------------------------------------

      !!!            Yes     n/a      Inline-only
      -code          Yes     n/a      Inline-only
      =expr et al    Yes     n/a      Inline-only(embedded \n*); Interpolation; no %tags; Init Wspc
      ~expr          Yes     n/a      Inline-only(embedded \n*); Interp.; no %tags; preserve transform
      Plaintext      Yes     Free     Just line-by-line, variable indentation; Interpolation

      Multiline      No      No       Infix lexeme; %tags & Interpolation; Consolidate Whitespace
      HereDoc        No      No       Terminal lexeme; Interpolation; Verbatim Whitespace

      Haml Comment   Yes     No       Meta content; In addition to Offside, Whiteline terminates too
      Html Comment   Yes     No       Haml processing (%tags, interpolation, etc)

      preformatted   Yes     Free     %tag member option; Haml procsng; presv indent.; Symmetric tags
      preserve       Inline  Legacy   %tag member option; Haml procsng; presv indent.; Transform newlines

      filters        Yes     No       For the Filter Head; Each filter then has its own content rules

      :preserve      BOD at  No       As in Legacy: BOD for Filter ContentBlock is set at the
                     Indent           Indentation of the filter's Head plus its IndentStep.
                     Step             (Legacy idiom: BOD is indented 2 from Head indentation.)
                                      HtmlOutput is equivalent to rendering at Indentation 0
                                      Preserve transform; Interpolation; no %tags

      :preformatted  BOD at  No       Similar to filter:preserve, except: no newline transform.
                     Indent           Indentation of the filter's Head plus its IndentStep.
                     Step             On HtmlOutput, the parent's tags are symmetrically placed, and
                                      the content block with leading whitespace is rigid-shifted left
                                      to Indentation 0

      Haml %tag      Yes     Yes      Haml processing; OIR:loose (default) or OIR:strict;

      * embedded \n: Operator permits expression having embedded newline (which it interprets)

      ----
      Observe Offside: Is the extent of the Content Model of the specified 
          ContentBlock sensitive to the BOD and Offside Undents? An Inline-only
          Content Model is by definition Offside sensitive (plaintext Textline, 
          etc.); A Content Model whose extent is insensitive to the BOD and
          Offside Undents will require something other than these effects to 
          terminate the ContentBlock (e.g., Multiline: the absence of the infix 
          lexeme; HereDoc: the presence of the specified terminal string).
      Require OIR: Does the Content Model of the specified ContentBlock 
          enforce the OIR (strict, or loose) for it's content? This impacts
          nested tags, as you'd expect. But it also impacts author expectations	
          related to plaintext. For example, legacy Haml disallows indentation 
          in plaintext. Mysterious-enough for an ordinary tag, but it comes as
          a surprise to an author attempting to use an option:preserve tag with 
          nested content (sure, Haml jocks have learned that this is improper), 
          who is told: [just] use filter:preserve [after indenting every line of
          the entire text another IndentStep]. Under WSE Haml, tags follow 
          `OIR:loose` by default.

For more examples, see the RSpec test cases.

* [4] P. J. Landin ACM v9 n3, Mar 1966, p157. "Offside" is the spelling on 
      p160, where it is actually defined (p164 spells it "off-side"). 
      Merriam-Webster's Collegiate 10th lists it as "offside". Good enough for 
      me ... I invite you to (try to) correct the various Wikipedia entries.
      Landin proposed ISWIM _If you See What I Mean_ as the name for the 
      family of languages realizing the described system.



### Four Content Models

There are (broadly speaking) four types of Content Models:

-   Inline Content ('On-the-line') 

    In the _Inline Content_ Content Model, the ContentBlock appears on the same 
    line as the Head: a %tag, or '= expr' or '- code' or similar.

-   Nested Content 

    In the _Nested Content_ Content Model, the ContentBlock starts not on the 
    line with the Head but on the next Textline, at increased indentation from
    the Head. (If Inline Content is also present the entire ContentBlock is
    called _Mixed Content_, q.v.)  Unless otherwise noted, an Element supporting _Nested Content_ permits
    additional, nested, Elements; otherwise it is said to support (only)
    _Nested Text Content_ (which may enforce a single BlockOnsideDemarcation,
    or alternatively permit additional indentation).

-   Mixed Content 

    Where the _Mixed Content_ Content Model is permitted, the ContentBlock may
    start on the Head (Inline), and continue below on the next Textline, indented
    (Nested). Where Mixed Content is permitted, either _Inline Content_ alone 
    or _Nested Content_ alone may be used. Wider support of _Mixed Content_,
    and the related formats for HtmlOutput, is one of the key extensions in 
    WSE Haml.

-   HereDoc Content 

    Where the _HereDoc Content_ Content Model is permitted, that Element's 
    ContentBlock starts at Indentation 0 of the Line following the Head line 
    that contains the Initial HereDoc Delimiter of alphanumeric-plus-underscore 
    characters (/<<-?[\w_]+/). The Element's ContentBlock ends with the 
    newline of the last Line before the Terminating HereDoc Delimiter. If the 
    Initial HereDoc Delimiter begins with the form '<<-', the Terminating 
    HereDoc Delimiter may be indented.

    Within HereDoc Content, the Orderly Indentation Rule and Offside effects
    are suspended. Interpolation is provided, but ordinary Haml tags and other
    processing is not provided.

    (For those familiar with Ruby HereDoc, the WSE Haml implementation is 
    similar to the interpolating HereDoc (with double-quotes, or bare) ... 
    but quotes marks are not supported in the WSE Haml HereDoc syntax.)

    Where an Element supports HereDocs, the resulting ContentBlock (after 
    interpretation, including interpolation) is valid for any type of 
    Content Model (Inline, Nested, or Mixed). If, for example, the Element's 
    Head is listed in `option:preserve`, the ContentBlock is handled as-if
    Inline, and the standard preserve transformations will be applied to
    assure 'preserve'-compliant HtmlOutput.

    Any Textlines following the Line containing the Terminating HereDoc 
    Delimiter is evaluated as part of the parent or ancestors of the Element
    to which the HereDoc provides the ContentBlock (i.e., the Textline is 
    the Element's sibling or a cousin, depending on OIR.)

    TODO: The `<<EOD` provides the entire ContentBlock. Perhaps the Initial 
    HereDoc Delimiter could be followed by something? Whatever that could be,
    it would not be part of the ContentBlock--it would seem appropriate to
    apply to the Head or the Element overall. Perhaps it could be text, such
    as `<<EOD.` or `<<EOD  *`, which would be appended to the HtmlOutput for the
    Element, ala `helper:succeed`. See the RSpec suite for exploration of
    this.

These content models, and variations, are described further below.



### Whitespace (Horizontal whitespace)

Indentation is the most significant whitespace, it pertains to HamlSource 
syntax and semantics. But there are other whitespace considerations, 
including some pertaining to HtmlOutput, as follows.

WSE Haml approaches Whitespace using three transforms:

- Replay (null transform, after IndentStep/syntax adjustment)

- Consolidate (transform n->1)

- Remove (transform n->0)

The four categories of Whitespace in WSE Haml are _Initial_, _Leading_, 
_Interior_, and _Trailing_.

-   Trailing Whitespace

    Trailing whitespace has no semantic significance to Haml. Further,
    in all but a few cases it is removed from HtmlOutput, or in 
    the few exceptions, it is consolidated.

    Trailing whitespace is replayed under `option:preserve` and 
    `option:preformatted`, within filter:preserve and filter:preformatted,
    and in HereDoc; it is consolidated in Multiline text.

    Notice that under WSE, "preserve" is changed to consolidate trailing 
    newlines in an expression (that is, the "="-equiv constructs), 
    then transform the single remaining newline. 

    In Multiline Content Blocks, Trailing Whitespace is consolidated.

-   Interior Whitespace

    The interior linear whitespace of ordinary HamlSource Textlines is 
    replayed (n->n).

    TODO: Possible option wspcinterior:consolidate ?

-   Leading Whitespace

    This category refers to whitespace at the beginning of each Textline
    in Nested Content, distinguishing it from Initial Whitespace (see below).

    Leading Whitespace refers to the Whitespace preceding the first text
    of a Textline remaining after subtracting any IndentSteps: the
    IndentSteps of the ancestor Elements, and the IndentStep of the Head:
    it is the whitespace between the Head's Indentation and the first text
    of the Textline.

    Leading Whitespace is replayed. Exceptions to this include the Multiline
    syntax, and option:preformatted tags (where the ContentBlock is rigidly
    shifted to Indentation 0).

    In filter:preserve and filter:preformatted, the Leading Whitespace to be
    replayed is calculated as the difference of the ContentBlock's actual
    indentation (indentation of the left-most text) relative to the filter's
    head (the indentation of the initial ":" colon), minus the IndentStep
    applicable to the filter's Head itself (between the :preserve, and its
    parent's Head, say '%code'). Because in WSE Haml a filter sets the BOD for
    its ContentBlock at an offset equal to the IndentStep applicable to the
    filter's Head itself, a simpler formulation is that any whitespace at and
    to the right of the ContentBlock's BOD is considered Leading Whitespace,
    which these two filters replay.

-   Initial Whitespace

    Initial Whitespace is present when an author has started the first Textline 
    of an Element's ContentBlock with Whitespace: whether on Inline Content,
    or when the first Textline is in a Nested Content ContentBlock.

    WSE honors the author's action: Initial Whitespace is replayed to HtmlOutput.

    In plaintext content (for tags _not_ listed in `option:preserve` or 
    `option:preformatted`, or without expressions, for example), there can be 
    no Initial Whitespace in Inline Content: the gap between the Haml lexeme and 
    the plaintext is just part of the syntax.

    Initial Whitespace can arise, however, where the Inline Content is an 
    expression or the Inline Content begins with interpolation, or for tags 
    listed in `option:preserve` or `option:preformatted`. 

    For Haml tags listed in `option:preserve` or `option:preformatted`) the 
    Head is removed, including the single required space (e.g., "%pre "): any 
    remaining whitespace before plaintext is considered part of the ContentBlock, 
    to be replayed to HtmlOutput (preserved). Initial Whitespace is replayed 
    after the proper OutputIndent is emitted (i.e., the Initial Whitespace is
    appended to the OutputIndent). 

    Where the Initial Whitespace appears through a string, or interpolated 
    value, that whitespace is replayed.



### Styles of Specifying and Preserving HamlSource Whitespace

Haml features facilities that enables an author to produce HtmlOutput that,
to varying extent, retains the surface structure of the HamlSource. 
Think Html &lt;pre&gt;, in varying flavors.

Implementation note: The _method_ by which such surface structure is retained
or represented during processing is implementation-dependent, only the
form (including encoding) of the HtmlOutput is assured.

Legacy Haml offers these _preserve_ facilities:

- helper:find_and_preserve, for contained <ptag></ptag> where _ptag_ is included in option:preserve.

- expression:~ (Tilde) alias for find_and_preserve

- hamltag:%ptag, where `ptag` is listed in option:preserve, for Inline Content

- helper:preserve

- filter:preserve

Note that these break down to two main facilities: the __FAP Facility__ 
for Inline Content (which might more fully be called 
`reencode_interior_newlines`), and the
__General Newline Transform facility__ for Inline or Nested Content.

The main concerns for Haml authors of such facilities: the ContentBlock,
the transformation to HtmlOutput, and any restrictions to Haml, as follows:

-   What types of ContentBlock?

-   Restrictions on indentation for ContentBlock?

-   How do transformed newlines appear in HtmlOutput? A.k.a: How is _preserve_ accomplished?

-   How is whitespace transformed in transit from HamlSource to HtmlOutput?

-   Interaction with escaping of Html?

-   Interaction with, or prohibition of, other Haml operators and constructs?

WSE Haml extends the legacy facilities to attempt to _complete_ the set of
whitespace-preserving operators and mechanisms, with `option:preformatted`, 
the `filter:preformatted` facility, and HereDocs.

TODO: Once the Initial Whitespace and Inline/Mixed Content extensions
are supported, the _preformatted_ group of extensions seem the least
compelling. Both the 'vtag' and filter:preformatted offering only minor
convenience improvements. On the other hand HereDoc greatly simplifies
a frequently-needed form of HamlSource-to-HtmlOutput transit.

The following tables show how the above-listed concerns are addressed by 
legacy Haml plus the WSE Haml extensions.

Nomenclature: Just as _ptag_ denotes (above) a tag listed in 
`option:preserve` (_p_ as in preserve), _vtag_ denotes a tag listed 
in the WSE extension `option:preformatted` (that's _v_ for _verbatim_).
Also, _H:preserve_ refers to the helper function `=preserve()`; the 
_F:preserve_ refers to the filter operator `:preserve`.

Note that all of these facilities permit interpolation (although with
differences in the interpretation of embedded whitespace or newlines
introduced by dynamic variables). Neither F:preserve, F:preformatted,
nor HereDoc will operate on other contained Haml (i.e., `%atag` is
replayed as the string _%atag_).

Language Constructs and ContentBlock Support

      ================================================================================
      ContentBlock
      Inline          Nested            Mixed permitted
      ----------      ----------        ------------------
      FAP             F:preserve
      Tilde               
      ptag            ptag +
                      vtag *            vtag
      H:preserve     
                      F:preformatted *
                      HereDoc *

      * New in WSE Haml
      + atag semantics, essentially


Language Constructs and Newline Treatment

      ================================================================================
      Newline Treatment
      Transform \n to &#x000A;                 Emit \n
      -------------------------------------    -------------
      Only in <ptag></ptag>     All Content    All Content
      ----------------------    -----------    -------------
      FAP *                     F:preserve     F:preformatted
      Tilde *                   ptag ^         vtag ^
                                H:preserve     HereDoc

      * FAP and Tilde perform their reencoding of \n-to-&#x000A; on every
        \n interior to a <ptag>, ignoring any contained or containing <vtag>.
      ^ A %ptag will transform all of its inline \n, even if a nested
        descendant of a %vtag.  A %ptag with a Nested Content ContentBlock
        adheres to %atag semantics; a %ptag with a HereDoc ContentBlock
        processed that ContentBlock as if inline, using %ptag semantics.


Language Constructs and Offsides, OIR, and OutputIndents

      ================================================================================
      Observe and Enforce Offsides, Indentation
                            Offside for     OIR in
      Facility      n/a     ContentBlock    ContentBlock         OutputIndent
      ----------   ------   ------------    -----------------    ---------------------
      FAP            x      (Inline)        (Inline)             Head
      Tilde          x      (Inline)        (Inline)             Head
      ptag           x      (Inline)        (Inline)             Head
      H:preserve     x      (Inline)        (Inline)             Head
      vtag                  Observed        OIR:strict,loose     Rigid shift to 0
      F:preserve            Observed        Free Indentation *   Relative to Head BOD
      F:preformatted        Observed        Free Indentation *   Relative to Head BOD
      HereDoc               NOT Observed    Free Indentation     Absolute

      * Note on F:preserve: and F:preformatted: that particular combination
        of Offside plus OIR permits free indentation, provided the
        ContentBlock remains Onside of the Head -- that is, the author must
        align the Textlines at and to the right of the BOD of the :preserve or
        :preformatted head: at the Head's Indentation plus Head's IndentStep.


Preformatted-type Language Constructs and HtmlOutput

      ================================================================================
      HtmlOutput by Interaction of Tag Category
      (RSpec spec/05preformatted_spec.rb contains an example of each of these cases.)

                              Nested Content Block
                              atag              ptag              vtag
                              ---------------   ---------------   ----------------

      Direct
         Initial wspc         Removed           Removed           After "%vtag "
         Leading wspc         IndentStep        IndentStep        Nested Only
         Newline transform    None              None              None
         Tag placement        Vertical          Vertical          Vertical
         HtmlOutput Align     OutputIndent      OutputIndent      Block shift to 0

      F:preserve
         Initial wspc         N/A               N/A               N/A
         Leading wspc         Relative BOD      Relative BOD      Relative BOD
         Newline transform    &#x000A;          &#x000A;          &#x000A;
         Tag placement        Vertical          Horizontal        Vertical
         HtmlOutput Align     OutputIndent      Relative to 0     Relative to 0

      F:preformatted
         Initial wspc         N/A               N/A               N/A
         Leading wspc         Relative BOD      Relative BOD      Relative BOD
         Newline transform    None              &#x000A;          None
         Tag placement        Vertical          Vertical          Vertical
         HtmlOutput Align     OutputIndent      Relative to 0     Relative to 0

      HereDoc
         Initial wspc         N/A               N/A               N/A
         Leading wspc         Verbatim          Relative BOD      Verbatim
         Newline transform    None              &#x000A;          None
         Tag placement        Vertical          Vertical          Vertical
         HtmlOutput Align     OutputIndent      Relative to 0     Relative to 0

      Key:
       * Leading wspc + IndentStep:  Any apparent leading wspc is interpreted
           as the IndentStep, not Leading Whitespace
       * Leading wspc + Nested Only: With 'vtag', the leading whitespace of the
           leftmost Textline is removed from all lines, and the block is shifted
           to Indentation 0. The remaining nested lines retain their indentation.
       * Leading wspc + Relative BOD: A Filter sets the BOD for its ContentBlock
           at an offset equal to the IndentStep of it's Head. Any whitespace at
           the ContentBlock's BOD or to the right, before text, is Leading
           Whitespace, which these two Filters replay.
       * Tag placement + Vertical: Symmetrically aligned at the same indentation,
           with the content block rendered on intervening lines
       * HtmlOutput Align + OutputIndent: The count of IndentSteps determines the
           count of OutputIndentSteps. For atag and ptag with direct input: the
           combination of "IndentStep" and "OutputIndent" means plaintext is
           shifted flush at the OutputIndent, and any tags will be indented
           by OutputIndents.

      Rendering Variations:
       * These cases produce unique renderings:
           Case 03 (vtag, direct)
           Case 05 (ptag, preserve)
           Case 07 (atag, preformatted)
           Case 09 (vtag, preformatted)
           Case 10 (atag, Heredoc)
           Case 11 (ptag, HereDoc)
           Case 12 (vtag, HereDoc)
       * Case 01 (atag, direct) and Case 02 (ptag, direct) have the same
         HtmlOutput indentation and newline rendering (with different tags)
       * Case 06 (vtag, preserve), and Case 08 (ptag, preformatted) render
         identical; Case 04 (atag, preserve) differs in indentation, only.

Using these tables we can use a pairwise comparison to summarize the
benefits an author might seek in the related WSE Haml extensions. The
comparison looks at the three preformatted mechanisms in the WSE Extensions,
and their respective newline treatments, tag alignment, and the following
characteristic HtmlOutput modes:

      * vtag: HtmlOutput shifted to 0
      * filter:preformatted: HtmlOutput indent equals HamlSource offset from BOD
      * HereDoc: HtmlOutput has indentation of HamlSource


-   `%vtag` over `%ptag`

    Nested ContentBlock, including plaintext; and \n on HtmlOutput,
    with ContentBlock always rigidly shifted to Indentation 0.

-   `%vtag` over `f:preserve`

    HamlSource as normal tag; and \n on HtmlOutput, with ContentBlock
    always rigidly shifted to Indentation 0.

-   `HereDoc` over `f:preserve`

    HamlSource is raw source; HtmlOutput is verbatim replication, with \n

-   `f:preformatted` over `f:preserve`

    HamlSource nested structure, with \n

-   `f:preformatted` over `%vtag`

    HtmlOutput is indented relative to :preformatted Head (by IndentStep
    from parent) rather than shifted to Indentation 0. Yet `%vtag` permits
    an Inline fragment.

-   `HereDoc` over `%vtag`

    ContentBlock HamlSource is replayed verbatim to HtmlOutput,
    rather than shifted to indentation 0.

-   `HereDoc` over `f:preformatted`

    ContentBlock HamlSource is replayed verbatim to HtmlOutput,
    rather than indented relative to :preformatted Head.


### Normalizing HtmlOutput Whitespace and Indentation

The WSE extensions for Mixed Content, and relaxed indentation, offer authors
a bit of flexibility and even clearer code. But what about the related
domain, that of HtmlOutput? For example, how shall this (newly-permitted in
WSE Haml) be rendered?

      Code 8.8-01

      .flow
        %p Inline content
           Nested content

Haml with WSE proposes we honor author choices:

      <div class='flow'>
        <p>Inline content
          Nested content
        </p>
      </div>

There are other justifications too. One is that there is simply no other 
direct way (short of initial surprises in the output, and digging around 
for operator magic, and adding that cruft to the HamlSource)  for an author 
to accomplish that result. Another justification rests on minimizing the 
memory load for authors -- minimizing the variety in manipulations of their 
HamlSource.

Consider this (in legacy Haml, modulo whitespace bugs):

      Code 8.8-02

      %p First line  |
         Second line |

      <p>First line Second line</p>

Multiline is a bit special, so let's consider instead the assumption that
the Haml author might not be in full control of the content (or may feel
the need to provide the quoted string directly in the Haml source). The 
Haml Reference calls this "dynamically-generated":

In legacy Haml (without resorting to the whitespace removal trim_in/out 
cruft), the HtmlOutput processor imposes a change in surface structure:

      Code 8.8-03

      - strvar = "foo bar"
      %p= strvar
      <p>foo bar</p>

      - strvar = "foo\nbar"
      %p= strvar
      <p>                           # Legacy Haml forces nesting for first line
        foo
        bar
      </p>

      - strvar = "foo\nbar"
      %p eggs #{strvar} spam
      <p>                           # Legacy Haml forces nesting for first line
        eggs foo
        bar spam
      </p>

The surprises are reduced under Haml with the WSE extensions, without the
need for the find_and_preserve cruft:

      Code 8.8-04

      - strvar = "foobar"
      %p
        = strvar                  # WSE Haml: Always nest my var's content
      <p>
        foobar
      </p>

      - strvar = "foo\nbar"
      %p
        = strvar
      <p>
        foo                        # Normalized indent, just as other cases
        bar
      </p>

      - strvar = "foo\nbar"
      %p= strvar                   # WSE Haml: Start my var's content tight
      <p>foo
        bar                        # Normalized indent, just as other cases
      </p>

      - strvar = "foo\nbar"
      %p eggs #{strvar} spam
      <p>eggs foo                  # WSE Haml: Same as previous case
        bar spam
      </p>

These cases lead to the more general cases.

The simple case is where plaintext Inline Content begins after some number 
of intervening spaces after the Haml tag. In this case, regardless of the
presence of Nested Content (aka Mixed Content), the intervening spaces
are considered part of the syntax, they are removed and no OutputIndent 
is inserted.

The case open to more author confusion and surprise is where the 
Inline Content begins with quoted or interpolated material having
Initial Whitespaces.

      Code 8.8-05

      - strvar = "  foo\n   bar"
      %p= strvar
      <p>
          foo                       # Legacy Haml
           bar      
      </p>


WSE Haml handling of Initial Whitespace in quoted or interpolated material:

      Code 8.8-06

      %p= strvar
      <p>  foo                      # WSE Haml
           bar      
      </p>

When the tag is a member of `option:preserve` or `option:preformatted` the
extension in WSE Haml is to replay the author's Initial Whitespace,
_preserving_ the Initial Whitespace:

      Code 8.8-07

      :preserve => ['code']
      .quux
        - strvar = "   foo\n   bar"
        %code= strvar

      <div class='quux'>\n  <code>foo...        # Legacy Haml


WSE Haml replays the Initial Whitespace:

      Code 8.8-08

      :preserve => ['code']
      .quux
        %code= strvar

      <div class='quux'>\n  <code>   foo...     # WSE Haml replays the Initial Whitespace

For Html preformatted tags, the UA result will be rendered differently
which presumably reflects the author's intention.

Next we look at the generated Html endtag for the same type of preserve 
element, one containing a newline that's been _preserve_d. In this case,
WSE Haml normalization produces HtmlOutput with a slight improvement
in its correspondence to the author's HamlSource: Trailing Whitespace is 
replayed, even if trailed by newlines: any number of final newlines are
consolidated into a single instance, and transformed (so, I guess that's 
a change from elision to surjection). The result will not produce a 
difference in the rendering by an Html- or CSS-conformant renderer, unless
by author CSS control ... which would now be possible.

      Code 8.8-09

      :preserve => ['code']
      .quux
        - strvar = "   foo\n   bar  \n\n"
        %code= strvar

      <div class='quux'>                            # Legacy Haml drops \n
        <code>foo&#x000A;   bar</code>
      </div>

WSE Haml consolidates the trailing newlines, then transforms:

      Code 8.8-10

      :preserve => ['code']
      .quux
        - strvar = "   foo\n   bar  \n\n"
        %code= strvar

      <div class='quux'>                            # WSE Haml
        <code>   foo&#x000A;   bar  &#x000A</code>
      </div>

Here we see that the Trailing Whitespace is replayed, and the trailing
newlines are replayed _without transform_. That will format the HtmlOutput
so the matching endtag __</code>__ will appear symmetrically aligned 
to the starttag.

      HtmlOutput:
      <code>   foo&#x000A;   bar  &#x000A;</code>
 
      Native Html equivalent:
      <code>   foo
         bar  
      </code>

      HTML/CSS-Conformant UA rendering:
         foo
         bar

Any number of such trailing newlines will be transformed in this way, 
including when only newlines comprise the content. 

Also, for clarity concerning Initial Whitespace and tags listed in option
preserve/preformatted: when creating the AST for Elements not beginning
with variables or interpolation, Haml should capture the Initial Whitespace 
after the tag the associated, obligatory, single whitespace. (And, of course,
trailing whitespace: in the example below there is also Trailing Whitespace 
of two spaces.)

      Code 8.8-11

      :preserve => ['code']
      %code   Foobar               # Notice: "%code " and "  Foobar  "

      <code>  Foobar  </code>      # WSE Haml, notice 2 space Initial WSPC

Inline Content for Html Comments is subject to the same rules as an ordinary 
tag, but be sure to read more about Haml Comments, below.

Initial space in Nested Content is also honored, as above. In the nested 
lines of Mixed Content, however, the space at the left of the Textline 
(leading whitespace) is taken as an IndentStep ... so any whitespace in 
addition to that must be provided through expression or interpolation.

      Code 8.8-12

      :preserve => ['code']
      - strvar = "   foo\n     bar  \n"
      %code= strvar
      %cope= strvar               # Arbitrary tag

      <code>   foo&#x000A;     bar  &#x000A;</code>
      <cope>   foo                 # Not :preserve tag (Code 8.8-04, -06))
        bar                        # WSE Haml, Notice: only 1 OutputIndentStep
      </cope>

The non-`option:preserve` tag, `%cope` is rendered according to
the mechanisms presented above in Code 8.8-04, and Code 8.8-06.

Where a `option:preformatted` tag, `vtag`, is substituted above,
Initial Whitespace is preserved as described, but newline transforms
are not performed, and in the case of Inline 'dynamic content',
the `%vtag` renders the content as a Nested Block giving vertically-
aligned start-and-end tags, and an OutputIndent starting at indentation 0.

When a preserve or preformatted tag contains only whitespace,
the whitespace is replayed.


### Whitelines (Vertical whitespace)

A Whiteline is a line containing a final \n with zero or more preceding 
whitespace characters. Also known as a linespace, or (if devoid of 
characters except for the \n) a blank line.

Just as with a Textline, a Whiteline falls within the scope of an Element. 
By convention, a Whiteline is assigned an Indentation measure drawn from
that Element's content: the Indentation of the preceding Textline, or if
none, the Indentation of the following Textline.

Inline Content cannot, of course, have Whitelines. 

Elements having Nested Content may have Whitelines. Initial Whitelines are 
removed. Single Whitelines occurring at the end of the scope of an Element
(trailing Whitelines) or within an Element (interior Whitelines) are removed.
Multiple trailing Whitelines, and multiple interior Whitelines are 
consolidated (n -> 1).

The ContentBlock of a Haml Comment is terminated by a Whiteline (as well 
as the usual Offsides); see more about the Haml Comment model, below.

These mechanics provide an author the means to control HtmlOutput line
spacing. Such control is useful in literal text, but also where content
will be interpolated or computed, including possibly null productions.

      Code 8.9-01

      %div
        %p cblock1
        %p
                         # Leading Whiteline is removed
           cblock2a      
                         # Multiple Interior Whitelines are consolidated
      

           cblock2b      
                         # Single Interior Whitelines are removed
           cblock2c
                         # Multiple Trailing Whitelines are consolidated

        %p cblock3

        %p cblock4inline   # Inline content for Mixed Content ContentBlock         
           cblock4a
            -#             # Inserted into Nested Content -- a Haml Comment
             cblock4c      # Captured by Haml Comment as Nested Content ContentBlock
                           # Whiteline delimits Haml Comment
             cblock4d


      <div>
        <p>cblock1</p>
        <p>
          cblock2a

          cblock2b
          cblock2c
        </p>

        <p>cblock3</p>

        <p>
          cblock4inline
          cblock4a
          cblock4d
        </p>
      </div>



## Heads and Their Content Models

This section contains additional details and comments for Haml with 
WSE extensions. Refer to the RSpec and Test implementations for 
further details and examples.


### General

`%tag Inline Content`, `%tag\nNested Content`, and 
`%tag Inline Content\nNested Content` (Mixed Content) make up the
bulk of Haml that embellish plaintext in the HamlSource. The Offside
Rule and Orderly Indentation Rule (OIR) (default:loose) are both observed. 

Haml Comments may appear throughout the `%tag` ContentBlock. Haml Comments
observe Offsides, but in a change under WSE, do not enforce OIR. This latter
change in WSE makes it possible for an author to comment-out blocks of Haml 
text (or even embedded literal Html) without having to change the indentation
to satisfy OIR. See the Haml Comments notes regarding the extent of the 
ContentBlock for Haml Comments falling onside of a ContentBlock for another
Haml Element.



### Haml Comments

Note: These details do not refer to Haml Comments used as processing
instructions (presently: encoding 'coding' ) at the beginning of the 
HamlSource.

Legacy Haml permitted Mixed Content for Haml Comments, so: 
`-# Inline Comment`, `-#\nNested Comment`, and 
`-# Inline Comment\nNested Comment` (Mixed Content). 

In legacy Haml the Haml Comment ContentBlock enforced OIR: the ContentBlock
ended upon Offside.

Under WSE, Haml Comments do not enforce OIR. Haml Comments observe a 
modified Offside Rule: regardless of the IndentStep, the
BlockOnsideDemarcation is established at the minimum Indentation:
the Indentation of the Haml Comment lexeme, plus 1:

      Code 9.2-01

      0123
      -# Haml Comment Inline
       ^
       | BlockOnsideDemarcation, the Offside Rule reference for Haml Comments

      0123
      -# 
         Haml Comment Nested
       ^
       | BlockOnsideDemarcation, the Offside Rule reference for Haml Comments
         (Requires WSE Haml's OIR rules, unless under legacy Haml the file is 
          globally using a 3-space IndentStep.) 
   

In consequence, for Textlines in Haml Comments the indentation
may increase and decrease arbitrarily ... provided they stay 'onside.'
This offers more flexibility for commenting out code without changing
it's indentation, making it easy to re-activate such code.

As mentioned above, Haml Comments (within the HamlSource body) are 
transparent to all other Haml processing. As such, an author could be 
forgiven for thinking that a Haml Comment couldn't alter the semantics 
of the interpreted Haml, that the Haml Comment should be absent from the 
abstract tree. 

But there is one surprise: in legacy Haml a Haml Comment _can_ delimit
a Multiline block, and therefore can break into two a larger Multiline block.
This was suggested in the forums as a work-around for authors who were 
surprised that a Whiteline couldn't perform that feat. So, even though it is 
__whack__, and in WSE a Whiteline can now also perform that feat, WSE 
extensions will also, for backward compatibility, support Haml Comment in 
that role. See details elsewhere in these Implementation Notes, and in 
the RSpec test files.

Concerning syntax, Haml lexemes are usually separated from their operands
by whitespace. The Haml Comment lexeme "-#" need not be. The following
are two legal (in legacy, and supported in WSE) Haml Comments:

      Code 9.2-02

      -# Text comment
      -#Text comment

In legacy Haml, Mixed Content is prohibited for other operators: you get
Inline Content or Nested Content, but not the combination. Having Mixed 
Content as a normal content model throughout legacy Haml would have enhanced
author expression and control over semantics and output, and enhances 
maintenance. Permitting Mixed Content for Haml Comments, however, gave 
_general content_-scope semantics for a meta operator. As it has
turned out, it was an unfortunate design choice.

WSE Haml, to the contrary, allows Mixed Content in all but a few cases 
(e.g., doctype). In addition, WSE Haml widely permits OIR:loose ... in 
which the ContentBlock need not follow strict indentation, provided it 
remains 'onside'.

Ideally, the entirety of the WSE extensions would present no conflict
with Haml Comments, for both general and specific reasons. The general 
reason: keeping the rules of HamlSource syntax and generated HtmlOutput 
simple, while enabling forms authors are likely to use. The more specific 
reason: when commenting-out existing Haml code, an author shouldn't have
to restructure the code (changing all the indenting from a compliance with
OIR:loose to that of OIR:strict), complicating what is still communicated 
in the source, and any later reversal.

The two do come into conflict, however: a Haml Comment with nesting
Textlines could be difficult to separate from the content of an immediately 
enclosing Element having Mixed or Nested Content. This was already a
challenge for authors in legacy Haml, but with `OIR:loose` the challenge has
grown under WSE. 

Consider the following Haml, perhaps program-generated. We have `%scat` 
categories, each with three children (oir:loose).

      Code 9.2-03

      %esku
        %skulist
          %scat Lights
                     %sid 20301
                   %sname Spot2
                  %sdescr Follow spotlight
          %scat Sound
                     %sid 20304
                   %sname Amplifier
                  %sdescr 60watt reverb

A Haml Comment could fit in that structure in many places, without 
ambiguity and without changes to the indentation of the HamlSource.

Here's one fit that's a bit difficult (which you can bet would show 
up on SO) where an Inline _or_ Nested Content Model for Haml Comments 
would have been better:

      Code 9.2-04

      %esku
        %skulist
          %scat Lights
                     %sid 20301
                 -#%sname Spot2                # Haml Comment Inline
                   %sname Spot3                # Haml Comment Nested
                  %sdescr Follow spotlight     # Haml Comment Nested
          %scat Sound
                     %sid 20304
                   %sname Amplifier
                  %sdescr 60watt reverb

If Legacy-style Haml Comments were just either-or Inline or Nested this
Inline case would work fine: only that line would have been taken up in the
Haml Comment. But the Nested-only case could not have meet all the criteria
for this particular XML author's obsession. The solution under WSE is similar
to what the author would have done if trying a Nested-only approach: in WSE
you have to add a line, a Whiteline.

      Code 9.2-05

      %esku
        %skulist
          %scat Lights
                     %sid 20301
                 -#%sname Spot2                # Haml Comment Inline

                   %sname Spot3
                  %sdescr Follow spotlight
          %scat Sound
                     %sid 20304
                   %sname Amplifier
                  %sdescr 60watt reverb

TODO: How disruptive would it be to _disallow_ the Legacy Haml support
for Mixed Content for Haml Comments?

This approach allows authors much more freedom in the placement of their
leading "-#" and insertion of any commentary, while preserving the 
indentation of their original text ... at a small incompatibility with 
some legacy Haml. 

To recap: Under WSE, the Haml Comment supports the legacy Content Models of
Inline, Nested, and Mixed Content. The extent of its ContentBlock is the 
first of: Offsides (the BOD is at the Head indentation + 1), or a Whiteline.

Finally, Haml Comments are __not__ recognized in HereDoc ContentBlocks:
the line is taken as just another Line to copy through.



### Html Comments

Html Comments are supported in these forms: `/ Inline Comment`, 
`/\nNested Comment`, and `/ Inline Comment\nNested Comment` 
(Mixed Content).

Html Comments may appear throughout a `%tag` ContentBlock.

Html Comments do not observe OIR. Html Comments follow a modified 
Offside Rule: regardless of the IndentStep, the BlockOnsideDemarcation is
established at the minimum Indentation: the Indentation of the 
Html Comment lexeme, plus 1:

      Code 9.3-01

      0123
      / Html Comment Inline
       ^
       | BlockOnsideDemarcation, the reference for the Offside Rule

A space is not required between the initial "/" and the content block.

WSE Haml introduces two additional Html Comment facilities to free authors 
of the repetitive weed-pulling of changing Haml Comment annotations, yet
still generate HTML that's not just pretty, but also well-formed. The first 
facility concerns nesting of the "/ " within another "/ " Element. Instead 
of creating a second, (improperly) enclosed, HTML comment element, WSE Haml 
defangs this surprise: the contained "/ " is replayed literally, as part of 
the enclosing Html comment text. 

The second facility concerns another scenario where authors think they 
are writing/maintaining Haml, which is mostly plaintext with a sprinkling 
of Haml lexemes and Ruby/Perl, but most certainly is _not_ Html. This 
(and the fact that legacy Haml supports interpolation inside the Haml 
Html Comment ContentBlock, as does WSE Haml) easily leads to the case of 
two hyphens--a common feature of plaintext--appearing inside an 
HTML-compliant comment, such as when a Haml author prefixes what is 
otherwise plaintext with the Haml Comment lexeme. (A simplified variation
of this case was raised in GitHub Issue 88 and was met with one of those
"don't do that" responses mentioned in the introduction of these Notes.)
WSE Haml will recognize and adjust for the cases that typically arise
(transformed in the order of priority shown):

      Within Haml Comment ContentBlock (WSE Haml)
      HamlSource                        WSE Haml HtmlOutput
      (After Interpolation)
      ---------------------             ---------------------
      1. /--+>/                         --><!--
      2. /<!--+/                        --><!--
      3. /-(-+)/                        '-' + ' ' * $1.length 


Selected cases:

      Code 9.3-02

      .zork
        %p para1
        / plaintext html comment
        %p para2
        / comment with embedded --> html comment endtag
        <p>para3</p>
        / comment with embedded <!-- html comment starttag
        <p>para4</p>
        / comment with embedded --- serial hyphens

      <div class='zork'>
        <p>para1</p>
        <!-- plaintext html comment -->
        <p>para2</p>
        <!-- comment with embedded --><!-- html comment endtag -->
        <p>para3</p>
        <!-- comment with embedded --><!-- html comment starttag -->
        <p>para4</p>
        <!-- comment with embedded -   serial hyphens -->
      </div>


### Multiline Text

The Multiline syntax provides authors a simple form for specifying
over several HamlSource lines a single-line ContentBlock. 

The syntax is 'infix', with a " |" (space-pipe) as the last non-whitespace 
on each line. For clarity, the last line must also carry the " |". 

The OIR is __not__ enforced; the Offside Rule does __not__ apply.

Initial whitespace is removed. The trailing whitespace (before the
" |" space-pipe lexeme), the newline, and the leading whitespace of
the next line is consolidated (into a single space). Whitespace around
any interpolated newlines receives the same treatment.

Because Multiline provides an author an alternative method of providing 
HamlSource, interpolated newlines _do not_ break the Multiline. This 
is a change from Legacy Haml, which exhibits an inexplicable reversal 
in processing, in that surface syntax is interpreted __after__ content 
semantics. What happens in WSE Haml: The lexer builds an AST having 
the Parent Element's Head as a node, having a Nested ContentBlock, 
and having as its child a node for the Multiline syntactic form. The 
lexer strips the ContentBlock of Multiline Elements of the Multiline 
Lexemes, leaving for the parser (subsequently) to process the lines 
and then finally combine the lines according to Multiline _semantics_.

If the Head of a Textline contains "-#" that line will terminate a 
Multiline Text block (as in legacy Haml), __even if__ that line ends with 
the " |" pipe lexeme (a WSE Haml variance to legacy Haml). This idiom 
(of Haml Comment-demarcation of two adjacent Multiline Elements) is 
deprecated: the recommended separator of two adjacent Multiline 
ContentBlocks is the Whiteline.

TODO: It would be better to undo this blooper in legacy Haml syntax, 
to thereby allow an author to easily remove a line from a Multiline Text 
block by Haml-Commenting it, while not breaking the overall Multiline. 
But would the breakage in legacy Haml code be too great?



### HereDoc

As presented above, HereDoc is a WSE Haml Content Model, which provides
the entire ContentBlock to its Element. It is an alternative to Inline
Content, Nested Content, or Mixed Content.

Within HereDoc Content, the Orderly Indentation Rule and BlockOnsideDemarcation
effects (including Offside) are suspended. 

The HereDoc ContentBlock is inert with respect to Haml tags, =expressions, 
-code, and so on. It is processed for interpolation (as if a double-quoted 
string).

      Code 9.5-01

      option:preformatted => ['vtag']       # Verbatim

      %body
        %dir
          %dir
            %vtag<<DOC
           HereDoc
      -# #{var1}
      DOC

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

      Notice:
       * The HereDoc is replayed without adjusting indentation
       * Interpolation is supported
       * The Haml Comment syntax is ignored -- it is just plaintext
       * When a HereDoc ContentBlock is provided to an option:preserve
         tag (so-called %ptag), the resulting ContentBlock is handled
         as if Inline, meaning it is processed with 'preserve' semantics,
         including transformation of \n to &#x000A;.

An extended syntax is provided, permitting indentation of the terminal 
delimiter:

      Code 9.5-02

      option:preformatted => ['vtag']       # Verbatim

      %body
        %dir
          %dir
            %vtag<<-DOC
           HereDoc
      -# #{var1}
            DOC

WSE Haml's HereDoc syntax does not admit the single-quote extended syntax.

TODO: Perhaps it should? For what use cases?

When mixed with other components of Head syntax, the HereDoc lexeme falls
last:

      Code 9.5-03

      option:preformatted => ['vtag']       # Verbatim

      %div
        %vtag{ :a => 'b',
               :y => 'z' }<<DOC
       HereDoc Para
       DOC

Here with the trim_out lexeme:

      Code 9.5-04

      option:preformatted => ['vtag']       # Verbatim

      %div
        %vtag><<DOC
       HereDoc Para
       DOC

A Textline following the Line containing the HereDoc Terminator is,
either the sibling to the Element to which the HereDoc provides its
content (when having an Indentation equal to or greater than the 
Element's Head), or is a cousin to that Element (when having a lesser
Indentation than the Element's Head). Notice that the relevant
Indentation is with respect to the Element's Head not the HereDoc 
Terminator.

As a sibling:

      Code 9.5-05

      option:preformatted => ['vtag']       # Verbatim

      %body
        %dir
          %dir
            %vtag#n1<<-DOC
           HereDoc Para
           DOC
              %p#n2 para2

      <body>
        <dir>
          <dir>
            <vtag id='n1'>
           HereDoc Para
            </vtag>
            <p id='n2'>para2</p>
          </dir>
        </dir>
      </body>


Undented with respect to the Element's Head, so as a child of 
a common ancestor:

      Code 9.5-06

      option:preformatted => ['vtag']       # Verbatim

      %body
        %dir
          %dir#d1
            %vtag#n1<<-DOC
           HereDoc Para
        DOC
          %p#n2 para2

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

Whitespace Removal lexemes may be used in their usual position, as the
last lexeme of the Head, before the HereDoc token.

The following establishes conflicting modes regarding the Content Model,
and are therefore prohibited, halting Haml processing with an exception
(because to simply warn or otherwise continue could lead to unnoticed 
missing content in the HtmlOutput):

      Code 9.5-07

      %img<<DOC        # %img is included in autoclose; no content
      HereDoc
      DOC

      Haml::SyntaxError

Inline autoclose lexeme:

      Code 9.5-08

      %sku/<<DOC       # Make %sku autoclose, so no content
      HereDoc
      DOC

      Haml::SyntaxError

As noted above, the HereDoc is a method for providing an Element's
ContentBlock: where an Element supports HereDocs, that Element's 
resulting ContentBlock (after the HereDoc interpretation, including 
interpolation) is valid for any type of Content Model (Inline, Nested, 
or Mixed). If, for example, the Element's Head is listed in 
`option:preserve`, the standard preserve transformations will be 
eventually applied.

TODO: Perhaps plaintext or interpolated text might follow the HereDoc lexeme,
after the fashion of `helper:succeed`? The following three examples explore
this possibility (and would give better results with "<" and ">"), although 
there doesn't seem a particularly strong use case, and perhaps there's 
another better use for that slot.

TODO: Candidate capability for content following the HereDoc token

      Code 9.5-09

      %dir
        %span.red<<DOC.
      HereDoc Para
      DOC

      <dir>
        <span class='red'>
          HereDoc Para
        </span>.
      </dir>

TODO: Candidate capability for content following the HereDoc token

      Code 9.5-10

      %p *
        %span.ital<<-DOC *
              HereDoc Para
              DOC

      <p>*
        <span class='ital'>
          HereDoc Para
        </span> *
      </p>

TODO: Candidate capability for content following the HereDoc token

      Code 9.5-11

      - punct = '...'

      %dir
        %span <<DOC#{punct}
      HereDoc Para
      DOC

      <dir>
        <span>
          HereDoc Para
        </span>...
      </dir>



### Preserve (`option:preserve`)

By listing a tag in `option:preserve` the author indicates that special 
treatment should be applied to preserve some aspects of the ContentBlock's 
whitespace.

This special treatment occurs in two cases; both cases apply only when the
Element is determined to have (only) Inline Content. Nested Content will 
not prompt the special treatment; this is unchanged in WSE Haml,
as a change would affect many occurrences of a _preserve_ Head.

(TODO: If, instead, a case were made to change `option:preserve` to 
support Nested content, such a change would be compatible with WSE Haml. 
This would bring many of the benefits that `option:preformatted` brings 
to the listed tags, yet preformatted would still be beneficial as it 
offers other mechanisms--OIR:loose, replay of whitespace, and newlines 
without special entities.)

If an Element's Head is an expression with `find_and_preserve` or a 
Tilde-expression (`~ expr`), then the special treatment is applied to a
segment of the Element's Inline ContentBlock: within the Inline content, 
newlines occurring between the HTML start tag and HTML end tag of a 
`option:preserve`-listed tag will be transformed (with special handling
of any trailing newlines). The other newlines are not transformed.

In the second case, if an Element's Head is one of the tags listed in
`option:preserve`, then the special treatment (transformation of newlines) 
is applied to the entire Inline content. This includes the content provided 
via a HereDoc ContentBlock.

In a variant of this second case, if an Element's Head __is__ a member of
`option:preserve`, and instead of an Inline ContentBlock is determined to
have a Nested (only) ContentBlock, no special treatment is applied: the 
result is as if the tag were __not listed__ in `option:preserve`.

In all cases the WSE-altered Initial Whitespace handling occurs B<before>
the _preserve_ mechanics.

Take careful note of an important interaction between an `option:preserve`
tag and nesting content. In legacy Haml, Mixed Content was prohibited, thus
the absence of Inline Content, and the presence of a Nested Content 
ContentBlock signals that the tag should be treated as a normal tag (no 
special treatment). WSE Haml, however, introduces Mixed Content ... which 
appears like a combination of Inline and Nested Content. This would be an 
error in legacy Haml, and it remains, for `option:preserve` tags, an error
in WSE Haml. If Mixed Content is desired/necessary, perhaps the 
`option:preformatted` treatment would be suitable.

A tag's membership in `option:preformatted` takes precedence over its
membership in `option:preserve`. In WSE Haml tags `%pre` and 
`%textarea` are by default removed from `option:preserve` and listed in 
`option:preformatted`. Authors will also list in `option:preformatted` 
the tags for which they've assigned CSS-style `white-space:pre`-like 
mechanics (or will have such tags' ContentBlock supplied via `HereDoc` 
or `filter:preformatted`).

One difference between the two treatments (preserve, versus preformatted)
is the surface structure of the HtmlOutput: the placement of element
content with respect to the Html start tag and the Html end tag. Preserve 
mechanics will run the element's content _inline_ with the start tag and 
end tag (including when supplying a `filter:preserve` content block);
Preformatted mechanics will run the element's content _nested_, with the
start tag and end tag vertically aligned at the same indentation.

      Code 9.6-01

      :preserve => ['ptag']
      :strvar => "toto\ntutu"

      .wspcpre
        %snap
          %ptag= "Bar\nBaz"
        %crak
          %ptag #{strvar}
        %pahp
          %ptag                             # Trailing whitespace below
            :preserve
                def fact(n)  
                  (1..n).reduce(1, :*)  
                end  

      <div class='wspcpre'>                 # Legacy Haml
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

In the above, for filter:preserve, the preserved Leading Whitespace for the
"def fact..." block is 2 spaces. That is calculated as the difference of the
block's actual indentation relative to the :preserve head (4 spaces), minus
the prevailing IndentStep, in this case 2 spaces. While Legacy Haml uses a
constant IndentStep throughout a given HamlSource, WSE Haml permits a
variable IndentStep, thus we must generalize that rule, as follows: the
preserved Leading Whitespace is calculated as the difference of the block's
actual indentation relative to the :preserve head, minus the IndentStep
of the :preserve head itself.

While in general, in WSE Haml, a Filter establishes a BOD for its
ContentBlock, both `filter:preserve` (and `filter:preformatted`) will accept
a ContentBlock provided it is to the right of the minimum possible BOD,
at the indentation of the 'p' in ":preserve". Using the formulation above
this would produce a negative offset, which is instead forced to 0.

Also, in the above, Trailing Whitespace passed through `filter:preserve`.

In the following example, in order to show the mechanics, the WSE Haml helper
`html_tabstring` is used to increase the size of the OutputIndentStep, while
keeping constant the number of 'tabs'.

      Code 9.6-02

      :preformatted = ['vtag']
      :strvar => "toto\ntutu"
      - html_tabstring('   ')               Clarify indentation adjustments

      .wspcpre
        %spqr
          %vtag Dirigo
             Regnat Populus
               Justitia Omnibus
            Esse quam videri
        %snap
          %vtag= "Bar\nBaz"
        %crak
          %vtag #{strvar}
        %pahp
          %vtag
            :preformatted
                def fact(n)  
                  (1..n).reduce(1, :*)  
                end  
        %vtag<<ASCII
       o           .'`/
           '      /  (
         O    .-'` ` `'-._      .')
            _/ (o)        '.  .' /
            )       )))     ><  <
            `\  |_\      _.'  '. \
              `-._  _ .-'       `.)
          jgs     `\__\
      ASCII


      <div class='wspcpre'>                 # WSE Haml
         <spqr>                             # Indented 3 spaces: haml_tabstring
            <vtag>Dirigo                    # Inline fragment
       Regnat Populus                       # Nested fragment indented as a
         Justitia Omnibus                   # rigid block from indentation 0
      Esse quam videri
            </vtag>
         </spqr>
         <snap>
            <vtag>                          # Notice: opt:preformatted tag
      Bar                                   # Inline renders relative to 0
      Baz                                   # Would replay initial and leading wspc
            </vtag>
         </snap>
         <crak>
            <vtag>
      toto
      tutu
            </vtag>
         </crak>
         <pahp>
            <vtag>                          # filter:preserve replays offset
        def fact(n)  
          (1..n).reduce(1, :*)  
        end  
            </vtag>                         # Notice: trailing whtspc replayed
         </pahp>
         <vtag>                             # HamlSource replay, unshifted
       o           .'`/
           '      /  (
         O    .-'` ` `'-._      .')
            _/ (o)        '.  .' /
            )       )))     ><  <
            `\  |_\      _.'  '. \
              `-._  _ .-'       `.)
          jgs     `\__\
         </vtag>
      </div>

      Notes:
       * option:preformatted tags (here, the %vtag) are, in HtmlOutput,
         indented  as normal: the count of IndentSteps in the HamlSource times
         the OutputIndentStep -- here, a total of 6 spaces.
       * The Nested portion of a preformatted tag need only stay Onside.
         Regardless if the HamlSource indentation, it is rendered in HtmlOutput
         at indentation 0.
       * Although Nested Content is expected to be the primary use of a vtag,
         Inline Content is permitted--just note that under CSS white-space:pre
         the UA will not produce the alignment seen in HamlSource.
       * When rendering a %vtag with Inline Content, the "%vtag " Head is
         removed, and the remaining Inline fragment is rendered following the
         resulting <vtag>.
       * Inline 'dynamic' content is rendered relative to 0, with initial and
         leading whitespace replayed.
       * Filter:preformatted delivers a ContentBlock with the 'offside'
         whitespace removed. The BOD for a Filter is at the offset from the
         Filter's Head equal to the Head's IndentStep from its parent. The
         ContentBlock is rendered nested (the <vtag> start tag, and the </vtag>
         end tag are rendered symmetrically, vertically aligned at the same
         Indentation, in lines separate from the ContentBlock).

The particular newline transformation associated with preserve is further 
documented above, below in "find_and_preserve", and in 
the RSpec and Test suites.



### Helper: find_and_preserve

The underlying _preserve_ mechanics are those of `option:preserve`.
Please review that section and the sections preserving whitespace, and
normalizing whitespace in HtmlOutput.

Here is an example from the Haml Reference (for "~ expr"), and variants:

      Code 9.7-01

      options: preserve => 'pre', html_escape => false
      %zot
        = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")
        = find_and_preserve("Foo\n%Bar\nBaz")
        = find_and_preserve("Foo\n<xre>Bar\nBaz</xre>")

Legacy Haml gives this result. Because the HamlSource lacks Initial or
Trailing Whitespace, and trailing newlines, the result is the same in
WSE Haml:

      <zot>
        Foo\n  <pre>Bar&#x000A;Baz</pre>
        Foo\n  %Bar\n  Baz
        Foo\n  <xre>Bar\n  Baz</xre>
      </zot>

If escaped HtmlOutput is requested, here's the result--with the WSE Haml
fix for producing HtmlOutput that's escaped, which prevents escaping an 
already-escaped entity:

      Code 9.7-02

      option: preserve => 'pre', html_escape => true

      <zot>
        Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
        Foo\n  %Bar\n  Baz
        Foo\n  &lt;xre&gt;Bar\n  Baz&lt;/xre&gt;
      </zot>



### Preserve Expression Head: "~ expr"

The whitespace mechanics are the same as for `helper:find_and_preserve`.

From the Haml Reference:

     For example,

        ~ "Foo\n<pre>Bar\nBaz</pre>"

     is the same as:

        = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")


Note that WSE Haml will produce a different result from legacy Haml in the 
case when the author requests escaped HtmlOutput, correcting a difference
in legacy Haml between find_and_preserve and the tilde operator:

      Code 9.8-01

      options: preserve => 'pre', html_escape => true
      %zot
        = find_and_preserve("Foo\n<pre>Bar\nBaz</pre>")
        ~ "Foo\n<pre>Bar\nBaz</pre>"

      The buggy legacy Haml result:

      <zot>
        Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
        Foo\n  &lt;pre&gt;Bar\n  Baz\n&lt;/pre&gt;
      </zot>

      In WSE Haml the 'interior' newline is transformed and escaped, 
      producing the same result as for (the WSE-adjusted) 
      find_and_preserve, plus no whitespace normalization is performed
      (i.e., no added whitespace):

      <zot>
        Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
        Foo\n  &lt;pre&gt;Bar&#x000A;Baz&lt;/pre&gt;
      </zot>



### Filter: preserve

The whitespace mechanics are the same as for the `option:preserve`.



### Helper: preserve

The whitespace mechanics are the same as for `Filter:preserve`,
with the exception that Helper:preserve is altered according to
the WSE Haml extensions to produce the idempotent Html escaping.



### Preformatted

Elements whose Heads are listed in `option:preformatted` admit
Inline, Nested, and Mixed Content. This option (aka: verbatim tags) 
is new to Haml with WSE Haml.

A _preformatted_ tag observes Offsides, and permits OIR:strict or loose.

A tag appearing in both `option:preformatted` and `option:preserve`
is interpreted under `option:preformatted`.  In WSE Haml, tags `%pre` 
and `%textarea` are by default shifted from `option:preserve` to 
`option:preformatted`. Authors will also list in `option:preformatted` 
the tags for which they've assigned CSS-style `white-space:pre`-like 
mechanics (or will have such tags' ContentBlock supplied via `HereDoc` 
or `filter:preformatted`).

The change in Content Model is unlikely to introduce problems in legacy Haml 
code when subjected to WSE Haml `option:preformatted` semantics--under 
legacy Haml the `option:preserve` code could not have (could not appear to 
have) Mixed Content (it could have Inline--which would get the preserve 
transforms, or Nested--which would be treated as if a non-preserve tag). 
Under preformatted, the Inline Content may appear slightly different in the 
HtmlOutput, but that will be not the result of interpretation under a 
different Content Model, but the result of small differences from the 
`option:preserve` implementation.

As explained above for filter:preserve, WSE filter:preformatted delivers a
ContentBlock with the offside whitespace removed: whitespace at and to the
right of the BOD are replayed. The Filter's official BOD is at the same
offset from the Filter's Head as that Head is from its parent's Head.
Although this BOD is used for calculating the whitespace to replay, the
Filter will accept any ContentBlock that is to the right of the minimum
possible BOD, at the indentation of the 'p' in ":preformatted." Where the
whitespace calculation produces a negative offset, it is instead
forced to 0.



### `option:ugly`

The option `option:ugly` overrides all whitespace mechanics. Except
for HamlSource side-effects, WSE Haml leaves this unchanged.



### `option:autoclose`

Elements whose Heads are listed in `option:autoclose` are subject to
various whitespace consolidation and removal. Except for HamlSource
side-effects, WSE Haml leaves this unchanged.



### Included Html

The Haml References states:

      Note that HTML tags are passed through unmodified as well.
      If you have some HTML you don't want to convert to Haml,
      of if your converting a file line-by-line, you can just
      included it as-is.

Well, not quite: Haml is not _HtmlSource_ aware. Html-tagged text is treated
simply as plaintext, which is, problematically, subject to the rules of 
ordinary Nesting Content. Inserting a single clause of HTML is fine. 
Because the legacy Haml processing rules for plaintext prohibit indentation,
however, a longer HtmlSource text must adhere to a single left margin.
This is, however, unlikely for ordinary Html.

The solution is, it is thought, to feed it as a single inline to an 
Html-aware '= expr' processing block, or _filter_.

Well, neither quite works. WSE Haml offers two solutions: Elements with a
Head in `option:preformatted`, or through HereDoc.



### Whitespace Removal trim_out '`>`' and trim_in '`<`'

These lexemes do, naturally, alter whitespace--Initial, Leading, and
Trailing Whitespace. Apart from a minor bugfix, WSE Haml does not alter
the mechanics for these operators.

One side-effect of WSE Haml concerns Mixed Content, and the generation
of the related HtmlOutput. Recall that with Mixed Content, WSE Haml will
honor author decisions about Inline content--copying the Inline Content 
onto the same HtmlOutput line as the Head, which for the tag-start end
produces the same effect as the _trim_in_ operator.

      Code 9.15-01

      %bac
        %p Foo                     # WSE Haml Mixed Content
          Bar
          Baz

      <bac>
        <p>Foo                     # WSE Haml runs Inline tight
          Bar                      # Same as Legacy indentation
          Baz
      </bac>


      %saus
        %p= "Thud\nGrunt\nGorp"    # Provides non-preserve tag nested content

      <saus>
        <p>Thud                    # WSE Haml runs this tight
          Grunt                    # Indented as if ordinary nested content
          Gorp
        </p>
      </saus>


Trim_in with WSE Haml:

      Code 9.15-02

      %eggs
        %div
          %p< Foo
            Bar
            Baz
        %p para1

      <eggs>
        <div>
          <p>Foo
            Bar
            Baz</p>
        </div>
        <p>para1</p>
      </eggs>


      %spam
        %div
          %p<= "  Foo\nBar\nBaz  "
        %p para2

      <spam>
        <div>
          <p>  Foo                  # Runs tight, replaying Leading Whitespace
            Bar
            Baz  </p>               # Trim_in pulls up end tag, after Whitespace
        </div>
      </spam>

Note, that WSE Haml corrects a nit-ish bug with _trim_out_, where the Html
endtags are not symmetrically aligned with the starttags. The following
example shows how WSE Html will render the Html.

      Code 9.15-03

      %p
      %out
        %div>
          %in
            Foo!

      <p>
        <out><div>
            <in>
              Foo!
            </in>
        </div></out>               # WSE Haml aligns symmetrically with start
      </p>



### New WSE Haml Whitespace-related Operators and Aliases

Related to the above-mentioned whitespace frames, WSE implements two new
whitespace-related operators, and to help clarify the targeted whitespace
frame, a small group of aliases to legacy operators.

These were born of early experience with Haml ... where one of the authors 
(Ragouzis) found a few operator names a bit ambiguous. In one case, to 
disambiguate the locus of the haml_indent operator, it required comparison of
`haml_indent.length` for Inline versus Nested Content, confirming it refers
to the __Html__ OutputIndent. 

The new operators:

      Operator or Control           Locus of Production or Side-Effect
      ---------------------------   -----------------------------------
      html_tabs          Helper     HtmlOutput
                                    Get: Yields the string used for a
                                    single 'tab' of the OutputIndent
                                    Set: Sets the string used

      html_tabstring     Helper     HtmlOutput
                                    Yields the string used for a single 'tab'
                                    of the OutputIndent 

The following table lists the new operators and newly-assigned aliases, 
indicating the operator's locus of production or side-effect (HamlSource, 
or HtmlOutput).

      Locus of Production or Side-Effect

      HamlSource                |  HtmlOutput
      ---------------           |  ------------------
                                |  helper:html_indent     (WSE alias for haml_indent)
                                |
                                |  helper:capture_html    (WSE alias for capture_haml)
                                |  helper:html_concat     (WSE alias for haml_concat)
                                |  helper:html_tag        (WSE alias for haml_tag)

      Related:
                                |  helper:tab_up          (unchanged)
                                |  helper:tab_down        (unchanged)
                                |  helper:with_tabs       (unchanged)
                                |  helper:html_tabs       (WSE proposed function)
                                |  helper:html_tabstring  (WSE proposed function get/set)

                                |  helper:surround        (unchanged)
                                |  helper:precede         (unchanged)
                                |  helper:succeed         (unchanged)

                                |  helper: html_escape    (now Doctype-proper escape_once)
                                |  helper: escape_once    (unchanged)

                                |  option: escape_html    (now Doctype-proper, idempotent)
                                |  operator: &=           (now Doctype-proper, idempotent)
                                |  operator: &            (now Doctype-proper, idempotent)

                                |  filter: escapehtml     (legacy filter 'escaped') *1

                                |  filter: preformatted   (WSE-active verbatim)
      filter: preserve *2       |
      helper: find_and_preserve |

                                |  helper: list_of        (unchanged)
                                |  helper: to_s           (unchanged)
                                |  helper: html_attrs     (unchanged)



      Implementation-oriented (mostly), changes might be helpful/useful:

      helper: non_haml
      helper: is_haml
      helper: block_is_haml
      helper: merge_name_and_attributes

      instance: haml_buffer     # perhaps: html_buffer
    

      helper: haml_bind_proc    # perhaps: html_bind_proc (with related local var changes)
      helper: with_haml_buffer  # perhaps: with_html_buffer



  Notes:

  1.  The change from `filter:escaped` to `filter:escapehtml` better aligns
      the filter's name with other filter names (which for the most part 
      identify a characteristic of the input, or the operation). 
      `filter:escape_html` might be better; aligning similar options and
      helpers might be beneficial.

  2.  It seems more informative to note that these three facilities 
      `filter:preserve`, `helper:find_and_preserve` (and it's client
      `~expr`), and the related (wrt newline transform) `option:preserve`
      work as two-part operators. The operator performs its transform on 
      HamlSource. The result is then subject to any further Haml processing, 
      and that result becomes HtmlOutput. That the first operation  
      converts the newlines directly to an Html Entity is just an 
      implementer's convenience. For further discussion, see "The Newline
      Transform -- Implementation Internals" at the end of this document.



### Models for Html Escape 

An author may request HtmlOutput with some portion of the Html escaped. 
To deliver HtmlOutput with escaped Html, WSE Haml performs
Option/DocType-sensitive escaping.

Regarding the motivations for the change in escaped HtmlOutput. One
motivation concerns the semantics of document processing: In Html, an
escaped text is one which each symbol intended as [plain] text is of an
encoding which assures it will transit document processing and be rendered
as [plain] text. More particularly, that all symbols having significance to
Html document syntax processing be represented (here, encoded) in such a way
as to _escape_ such syntax processing. Thus, _in Html_, considering two
separate encodings of the ampersand, _&_ is a symbol susceptible to Html
syntax processing, which would require a different encoding when a part of
[plain] text; _&amp;_ is not, and does not.

As a more Haml-focused motivation, WSE Haml in general manifests a change
of focus from a mostly processing- and programmer-focused view, to that
of an author-focused HamlSource and HtmlOutput view. Thus WSE Haml
changes 'escaping' transforms from that of 'sanitizing' or 'find-replace',
programmer-focused mechanics, to that of the HtmlOutput, author-focused
results.

The escaping changes apply across _all_ Haml operators, whether requested
at the operator level, or through `option:escape_html`, including an
operator such as the Tilde or Ampersand expressions (`~ expr` and `& expr`)
and helper functions such as `helper:capture_html`, operating individually
or in composition.

Note: Sanitizing user input is a separate matter: an input processor
providing HamlSource _should_ sanitize _input_ of the form `&amp;`
to `&amp;amp;`, which WSE Haml, while processing that HamlSource and
generating HtmlOutput, will not further transform.

As mentioned above, there are two effects tempered by Options and the 
DocType:

-   Special character escaping

    Escaping of the apostrophe is limited to documents using an effective 
    XML-related DocType or escaping option. 

- Idempotent Escaping (the Ampersand)

    Specifically: Escaping `&amp;` gives you `&amp;`. This change applies 
    across _all_ Haml operators, including an operator such as the Tilde 
    expression `~ expr` and helper functions such as `helper:capture_html`,
    operating individually or in composition.

The following table summarizes the interaction between `option:html`
and select DocTypes, and the respective output format:

                   FORMAT:OPTION:  HTML4|5       DEFAULT(xhtml)      XHTML
                       -------------------       ----------------    -----
      DOCTYPE  !!!              html401t|5       xhtml 1.0 trans      =
               !!! 5            html401t|5       html5                =
               !!! 1.1          html401t|5       xhtml 1.1            =
               !!! Basic        html401t|5       xhtml b 1.1          =
               !!! Strict       html401|5        xhtml 1.0 s          =
               !!! XML          none|none        xmlencode(only)      =
               none             none             none                 =

To be clear about conflicting configuration, the rule is:

      1. If you specify option:format=>html4:  you get html rules, 
      2. otherwise:                            you get xml rules (&apos;).

                           FORMAT OPTION
                           DEFAULTED     SPECIFIED
                                         XHTML|5          HTML4
                           ---------     ---------        -----
      DOCTYPE
           none(default)   xml           xml|xml          html
           specified   
             unqual        xml           xml|xml          html
             html5         xml           xml|xml          html
             html4-type    xml           xml|xml          html
             xml-type      xml           xml|xml          html          



## Glossary

-   Block Onside Demarcation (BOD)

    The Indentation that serves as the point of reference for _Offside_.
    An Element's BlockOnsideDemarcation is the Indentation at which a Textline,
    and those of greater Indentation, is considered to fall within an Element's
    ContentBlock. In ISWIM: the southeast quadrant from the Element's Head
    containing the Elements' definition. The minimum Indentation for an
    Element's BOD is its Head's Indentation, plus 1.

-   Element

    The fundamental construct of a HamlSource file, made of a Head and
    a (possibly null) ContentBlock. A succession enclosed Elements,
    with Each ContentBlock containing further Elements describes a 
    tree of parents and children.

-   Head

    A component of an Element. The Head is a (usually prefix) lexeme of 
    Haml syntax, such as a Html tag macro (`%p`) or a Haml meta token 
    (such as `-#` for Haml Comments) or the operator for an expression
    (`= expr`) or code block (`- code`), for example.

    Semantically, the IndentStep is considered part of the head, as it
    is part of the description for the extent of the ContentBlock.

-   Consolidate (Remove and Replay)

    In many cases in WSE Haml, whitespace (linear and vertical) is,
    during transformation into HtmlOutput, consolidated: it is reduce 
    from many spaces to a single space. By comparison, alternative
    transforms are remove and replay.

-   ContentBlock

    A component of an Element. Depending on the particular Element, the 
    ContentBlock may begin in the same line as the Head (Inline Content),
    may begin below and indented from the Head (Nested), or both 
    (Mixed Content). 

    WSE Haml is an ISWIM language, meaning that indentation is used such 
    that an [Element's] entire definition falls to the "southeast quadrant"
    of the [Head]. In WSE Haml this syntax arises from the interplay of
    two rules: The Orderly Indentation Rule, and the Offside Rule.

    Haml's Multiline Syntax relies on the infix operator (the absence of)
    to terminate its ContentBlock.

    Haml Comments rely on a Whiteline to terminate its ContentBlock.

-   Content Model

    Whether the Element's ContentBlock may take Inline Content, Nested Content,
    Mixed Content, or HereDoc Content.

-   Escaped HtmlOutput

    WSE Haml implements an idempotent, fixed point, model: `&amp;` never
    becomes `&amp;amp;`. In addition, escaping of HtmlOutput is DocType
    sensitive.

    Concerning escaping, WSE Haml manifests a change of focus from a mostly
    processing- and programmer-focused view, to that of an author-focused
    view of HamlSource and HtmlOutput. Thus WSE Haml changes 'escaping'
    transforms from that of programmer-focused mechanics such as 'sanitizing'
    or 'find-replace', to that of an author focused on the resulting
    HtmlOutput.

-   HamlSource

    The input into the Haml processor, which in turn generates HtmlOutput.

-   HereDoc Content

    A type of Content Model for the ContentBlock: the HereDoc provides the
    entire ContentBlock of its Element. Neither OIR nor Offside are observed. 
    Instead a terminal string is introduced, which, when it appears alone 
    on a Line signals that the ContentBlock ended with the prior newline.

-   HtmlOutput

    The output of the Haml processor, from consuming HamlSource.

-   Indentation

    A measure: the offset from column 0 of the start of text in a Textline.

-   Inline Content

    A Content Model where the ContentBlock begins on the line with the
    Haml Head.

-   IndentStep

    The Indentation of a Textline is made up of a series of IndentSteps, a
    unit of indentation, the number of which increases for each contained 
    ContentBlock.

    In legacy Haml, the IndentStep was (typically) two spaces, and once one
    IndentStep was lexed, the size of the IndentStep remained fixed throughout
    the file. Each child Element's Indentation was one IndentStep deeper.

    In WSE Haml, under OIR:strict, the IndentStep must remain fixed within each
    immediate Element: it may vary for each child. In addition, Undents must 
    unfold (or pop) previous IndentSteps. Under OIR:loose, the default, the 
    IndentStep is variable, with the _If You See What I Mean_ of ISWIM 
    coming to the fore: Offsides of the Element dominates IndentStep counting.

    The IndentStep is predictive of the OutputIndent in the HtmlOutput.

-   ISWIM

    _If you See What I Mean_, the name Landin proposed for the family of of
    languages realizing the described system. Landin described the system 
    as having no prescribed physical appearance, but which derive from four
    levels of abstraction: applicative expression; abstract tree language;
    the logical abstraction; and a physical ISWIM language.

    One key feature is the reliance on indentation to demarcate the extent
    of content which defines an [Element].

-   Line

    The general term, for a Textline.

-   Mixed Content

    A Content Model where the ContentBlock begins on the same line as the
    Head, as in Inline Content, and continues, indented, on a following 
    Line, as in Nested Content.

-   Nested Content

    A Content Model where the ContentBlock begins on a following Line, 
    perhaps with intervening Whitelines, indented. Unless prohibited
    by the specific Head, Nested Content may contain further (Nested)
    Elements.

-   Orderly Indentation Rule (OIR) loose/strict

    The rule that Indentation must increase, and decrease following a prescribed
    model. The unit of Indentation is the IndentStep.

    In legacy Haml, the IndentStep was (typically) two spaces, and once one
    IndentStep was lexed, the size of the IndentStep remained fixed throughout
    the file. Each child Element's Indentation was one IndentStep deeper.
    Undents must fall at one of these prior Indentation measures, and which
    a new Element must be introduced.

    In WSE Haml, under OIR:strict, the IndentStep must remain fixed within each
    immediate Element: it may vary for each child. In addition, Undents must 
    unfold (or pop) previous IndentSteps. This is very much like legacy Haml's
    model, but with flexibility in the length of the IndentStep itself.

    Under OIR:loose, the default, the IndentStep is variable. This should be
    viewed as realizing a the physical realization of a more relaxed abstraction
    of _If you See What I Mean_ (ISWIM). Instead, the Offsides Rule becomes
    more dominant.

-   OutputIndent

    The unit of indentation in the HtmlOutput, also known as the OutputTab,
    or "tab." By default, each "tab" is two space characters. Lines in 
    HtmlOutput are indented in multiples of OutputIndent to reflect the
    structure of the 

-   Preformatted

    Refers in WSE Haml to a Content Model for an Element, where the _structure_
    of the HamlSource in the ContentBlock is replayed verbatim to the HtmlOutput,
    without newline transforms. (Full Haml processing is performed: interpolation,
    expressions, etc.)  Offsides is enforced, but indentation is free (OIR is 
    not required within the ContentBlock). In WSE Haml, tags `%pre` and 
    `%textarea` are shifted from `option:preserve` to `option:preformatted`;
    authors will also assign those Html tags for which they have assigned CSS
    `white-space:pre`-like mechanics. See details in various parts of the 
    document.

-   Preserve

    Refers in Haml to a transform that converts newlines in HamlSource into the
    special entity `&#x000A;` on HtmlOutput. The side-effect is that the 
    related Whitespace is undisturbed. This transform is available through the
    _preserve_ filter, through the helper `find_and_preserve`, for the Head 
    tags listed in `option:preserve`, and for the content of a "~ expr". Both 
    Offsides and OIR are observed. See details in various parts of the document.

-   Textline (non-Whitelines)

    A Line having non-whitespace characters. The Indentation measure is the
    offset column index from column 0.

-   Undent

    Used in reference to a prior Textline, referring to a smaller Indentation.
    It may refer to the specific difference in Indentation, or to the act
    of reducing the Leading whitespace on a Textline.

-   Whitespace

    Horizontal space between various words and components of the Textline.
    Classified into Initial, Leading, Interior, and Trailing Whitespace.

-   Whiteline (linespace)

    Vertical whitespace. A line containing only whitespace characters (spaces,
    tabs) and a terminal newline. Also: blank line (where no characters are 
    present).

-   Whitespace Semantics Extension (WSE)

    The name proposed for the set of changes and extensions discussed in
    this document.


## The Newline Transform -- Implementation Internals

The three Legacy Haml _preserve_ facilities, `filter:preserve`, 
`helper:find_and_preserve` (and it's client `~expr`), and the related 
(wrt newline transform) `option:preserve` work as two-part operators. 

The operator performs its transform on HamlSource. The result is then 
subject to any further Haml processing, and that result becomes HtmlOutput. 

That the first operation converts the newlines directly to an Html Entity 
is just an implementer's convenience. 

It might better have been any other opaque string during the internal 
private processing (such as the code point '0xfffd' or '0xfffe', or the 
more ancient ASCII/EBCDIC-ish '0x1f') ... which if still present after 
Haml operations, would be converted by some Html-oriented operator to a 
contextually-relevant HtmlOutput character. 

With the leading and trailing whitespaces having already been preserved 
through Haml processing, the appropriate Html character for HtmlOutput 
rarely is the `&#x000A;` special character entity. 

Where the targeted Html element is a preformatted-type, such as `<pre>`, 
the best-by-far character for all further Html-aware uses of the HtmlOutput 
is the author's own file-level platform-relevant newline. This is also true 
for most of the remaining cases. In vanishingly-few cases of 'preserving' 
is `&#x000A;` the ideal character to emit in HtmlOutput--either for reasons 
of the Html source itself, or for Html semantics and rendering. 

Apart from the implementation details of 'preserving' (which should be 
hidden), the choice for `&#x000A;` encoding moves net-positive when the 
author is targeting a preserved fragment to a newline-sensitive process 
(such as portability, or binary processing), or when the author simply 
wants a fragment displayed in HtmlOutput as a single line.

## RSpec Suite

Corresponding to this document is an RSpec test suite. 

In an earlier draft, file _OOImplementationNotes_, contained all the code,
in sequence (with the associated major head identified), as found in this 
document (WSE Implementation Notes). Although updated to draft v0.5,
that RSpec file is deprecated, and is slated for removal after draft v0.5.

Instead, each code snippet is provided separately, as,
for example,  `spec --color spec/00ImplNotes_Code09_05-10_spec.rb -f s`.

These may be run in suites through use of the provided Rakefile, using
the form `rake spec:suite:code_9_5`, for example. See the Rakefile.

The remaining files are by topic, somewhat overlapping with the
_00ImplNotes_Code_ files, and with each other on common topics. These
files also contain documentation and tests for various features,
inconsistencies, nits, and bugs -- most of which are __not__discussed
in this document, and are __not__ included in the _00ImplNotes_ files.

-   00ImplementationNotes_spec.rb (Deprecated, removed after draft v0.5)
-   00ImplNotes_Codexx_yy-zz_spec.rb
-   01helpers_spec.rb (a focus on the new, aliased, or changed helpers)
-   02initialwspc_spec.rb
-   03nesting_spec.rb
-   04preserve_spec.rb (see 05preformatted for more, and comparisons)
-   05preformatted_spec.rb (w/ comparisons of tag and ContentBlock combos)
-   06mixedcontent_spec.rb
-   07hamlcomments_spec.rb
-   08htmlcomments_spec.rb
-   09multiline_spec.rb
-   10verticalwspc_spec.rb
-   11htmlescaping_spec.rb
-   12heredoc_spec.rb
-   13wspcremoval_spec.rb
-   14doctype_spec.rb

