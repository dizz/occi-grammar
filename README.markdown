# Introduction:
Interoperability is key to [OCCI](http://www.occi-wg.org). The OCCI specifications set out in text how to implement the API and formats, however it is still up to our community and adopters to implement this. It is often the case when implementing a specification certain implementation decisions made can have an impact on an implementations interoperability. It is for this reason why this [ANTLR](http://www.antlr.org) grammar has been created to aid developers in creating their parser. The ANTLR grammar specifies the text rendering format in an abstract language known as a grammar.

# What:
The grammar defined, when used with the ANTLR tools, will generate a [lexer](http://en.wikipedia.org/wiki/Lexical_analysis) and [parser](http://en.wikipedia.org/wiki/Parsing) that will validate any valid OCCI text format. The grammar itself does not currently check whether a value associated with an attribute is valid. Rather it primarily ensures that the structure of the request is valid. It is still up to the implementer that service behaviours (e.g. correctly responding to HTTP GETs) are implemented correctly.

# Why:
One of the key strengths of ANTLR, outside of its lexer/parser technology, is it has a [wide range of target languages (18)](http://www.antlr.org/wiki/display/ANTLR3/Code+Generation+Targets), so your favourite language has a good chance!  This is an important advantage as this enables multiple implementations of OCCI (client or server) to all share a the same rules that parse the OCCI text format, regardless of language. 

# The Goodies:
There are two grammars currently defined: 

* [**occi-antlr-grammar**](https://github.com/dizz/occi-grammar/tree/master/occi-antlr-grammar): this solely defines the grammar and does not contain any target language specifics. It can be used as the foundation of target language specific OCCI grammars. An example of this extension is the occi-antlr-java. This grammar can generate lexer and parsers, however they will only validate the input and not extract values from the supplied input. If extracted values are required, a very common case, then the occi-antlr-java grammar gives an example of this.
* [**occi-antlr-java**](https://github.com/dizz/occi-grammar/tree/master/occi-antlr-java): this extends occi-antlr-grammar to include target language specifics. The target language used is Java. In this grammar file there are Java-specific ANTLR actions that extract the values from a valid OCCI text request/responses.

There are a number of rules that are present within the OCCI grammar that can be reused in order to validate certain supplied values. This would describe a second pass parsing phase. In the case that an implementer would like to validate a URI value then they can do so by using [this URI grammar](https://github.com/dizz/antlr-url-grammar).

# License:
This is released under a 3-clause BSD license and the work is sponsored by the [SLA@SOI EU FP7 project](http://www.sla-at-soi.eu).

# Support:
For issues directly related to the grammars here, simply raise an issue on [the issue tracker here](https://github.com/dizz/occi-grammar/issues). For issues related to the OCCI specification [please contact the OCCI group](http://occi-wg.org/community/contribute-communicate/). 

Andy ([mail](http://www.google.com/recaptcha/mailhide/d?k=01m0Yntj-pUNM5eExuBUYPQA==&c=Bk2vYdq5z8_yuvVhBnbdFw==), [twitter](http://www.twitter.com/dizz)).