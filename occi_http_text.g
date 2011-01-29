grammar occi_http_text;

/*
EBNF representation of category:

Category           = "Category" ":" #category-value
  category-value   = term
                    ";" "scheme" "=" <"> scheme <">
                    ";" "class" "=" ( class | <"> class <"> )
                    [ ";" "title" "=" quoted-string ]
                    [ ";" "rel" "=" <"> type-identifier <"> ]
                    [ ";" "location" "=" URI ]
                    [ ";" "attributes" "=" <"> attribute-list <"> ]
                    [ ";" "actions" "=" <"> action-list <"> ]
  term             = token
  scheme           = URI
  type-identifier  = scheme term
  class            = "action" | "mixin" | "kind"
  attribute-list   = attribute-name
                   | attribute-name *( 1*SP attribute-name)
  attribute-name   = attr-component *( "." attr-component )
  attr-component   = LOALPHA *( LOALPHA | DIGIT | "-" | "_" )
  action-list      = action
                   | action *( 1*SP action)
  action           = type-identifier
*/

tokens {
	SCHEME_ATTR = 'scheme';
	CLASS_ATTR = 'class';
	TITLE_ATTR = 'title';
	REL_ATTR = 'rel';
	ATTRIBUTES_ATTR = 'attributes';
	ACTIONS_ATTR = 'action';
	LOCATION_ATTR = 'location';
}

category: CATEGORY_HEADER category_value;
category_value: term scheme class (title|rel|location|attributes|actions)?;

term: term_value;
term_value: (UPALPHA|LOWALPHA|NUM|'_'|'.'|'-')* WS?;

scheme: ATTR_TERMINATOR WS? SCHEME_ATTR ASSIGNMENT scheme_value WS?;
scheme_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

class: ATTR_TERMINATOR WS? CLASS_ATTR ASSIGNMENT class_value WS?;
class_value: QUOTE CLASS_ENUM QUOTE;

title: ATTR_TERMINATOR WS? TITLE_ATTR ASSIGNMENT title_value WS?;
title_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

rel: ATTR_TERMINATOR WS? REL_ATTR ASSIGNMENT rel_value WS?;
rel_value:  QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

location: ATTR_TERMINATOR WS? LOCATION_ATTR ASSIGNMENT location_value WS?;
location_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

attributes: ATTR_TERMINATOR WS? ATTRIBUTES_ATTR ASSIGNMENT attributes_value WS?;
attributes_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

actions: ATTR_TERMINATOR WS? ACTIONS_ATTR ASSIGNMENT actions_value WS?;
actions_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

CATEGORY_HEADER : ('C'|'c')'ategory' WS? ':' WS?;
CLASS_ENUM: ('action' | 'mixin' | 'kind');

ATTR_TERMINATOR: ';';
ASSIGNMENT: WS? '=' WS?;

WS  :   ( ' ' | '\t') {$channel=HIDDEN;};
QUOTE: '"';
UPALPHA: 'A'..'Z';
LOWALPHA: 'a'..'z';
NUM: '0'..'9';

//taken from: http://antlr.org/grammar/1240941192304/css21.g
//fragment URL : ('['|'!'|'#'|'$'|'%'|'&'|'*'|'-'|'~' | NONASCII | ESCAPE)*;
//fragment NONASCII : '\u0080'..'\uFFFF'; // NB: Upper bound should be \u4177777
//fragment ESCAPE : UNICODE | '\\' ~('\r'|'\n'|'\f'|HEXCHAR)  ;
//fragment UNICODE : '\\' HEXCHAR (HEXCHAR (HEXCHAR (HEXCHAR (HEXCHAR HEXCHAR?)?)?)?)?('\r'|'\n'|'\t'|'\f'|' ')*;
//fragment HEXCHAR : ('a'..'f'|'A'..'F'|'0'..'9') ;

/*
tokens{
	CATEGORY_HEADER='Category';
	SCHEME = 'scheme';
}

root : CATEGORY_HEADER WS ':' category;

category : term WS ';' WS SCHEME WS '=' WS scheme;

term : STRING;

scheme : STRING; //needs to be a URL






WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

STRING
    :  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    ;

CHAR:  '\'' ( ESC_SEQ | ~('\''|'\\') ) '\''
    ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;
*/