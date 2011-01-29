grammar occi_http_text;

tokens {
	SCHEME_ATTR = 'scheme';
	CLASS_ATTR = 'class';
	TITLE_ATTR = 'title';
	REL_ATTR = 'rel';
	ATTRIBUTES_ATTR = 'attributes';
	ACTIONS_ATTR = 'action';
	LOCATION_ATTR = 'location';
}
// ---------------------------------------- 
// ---------- Category attribute ---------- 
// ---------------------------------------- 

/*
EBNF representation of category from the http rendering specification

  Category         = "Category" ":" #category-value
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

Examples:

	Category: storage;
	    scheme="http://schemas.ogf.org/occi/infrastructure#";
	    class="kind";
	    title="Storage Resource";
	    rel="http://schemas.ogf.org/occi/core#resource";
	    location=/storage/;
	    attributes="occi.storage.size occi.storage.state";
	    actions="http://schemas.ogf.org/occi/infrastructure/storage/action#resize ...";
*/

category: CATEGORY_HEADER category_value;
category_value: term_attr scheme_attr class_attr (title_attr|rel_attr|location_attr|attributes_attr|actions_attr)?;

term_attr: term_attr_value;
term_attr_value: (UPALPHA|LOWALPHA|NUM|RESERVED)* WS?;

scheme_attr: ATTR_TERMINATOR WS? SCHEME_ATTR ASSIGNMENT scheme_attr_value WS?;
scheme_attr_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

class_attr: ATTR_TERMINATOR WS? CLASS_ATTR ASSIGNMENT class_attr_value WS?;
class_attr_value: QUOTE CATEGORY_CLASS_ENUM QUOTE;

title_attr: ATTR_TERMINATOR WS? TITLE_ATTR ASSIGNMENT title_attr_value WS?;
title_attr_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

rel_attr: ATTR_TERMINATOR WS? REL_ATTR ASSIGNMENT rel_attr_value WS?;
rel_attr_value:  QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

//TODO lexical rules
location_attr: ATTR_TERMINATOR WS? LOCATION_ATTR ASSIGNMENT location_attr_value WS?;
location_attr_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

//TODO lexical rules
attributes_attr: ATTR_TERMINATOR WS? ATTRIBUTES_ATTR ASSIGNMENT attributes_attr_value WS?;
attributes_attr_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

//TODO lexical rules
actions_attr: ATTR_TERMINATOR WS? ACTIONS_ATTR ASSIGNMENT actions_attr_value WS?;
actions_attr_value: QUOTE (UPALPHA|LOWALPHA|NUM)* QUOTE;

CATEGORY_HEADER : ('C'|'c')'ategory' WS? ':' WS?;
CATEGORY_CLASS_ENUM: ('action' | 'mixin' | 'kind');

// ---------------------------------------- 
// ------------ Link attribute ------------ 
// ---------------------------------------- 
/*

EBNF representation of link from the http rendering specification

  Link             = "Link" ":" #link-value
  link-value       = "<" URI-Reference ">"
                    ";" "rel" "=" <"> resource-type <">
                    [ ";" "self" "=" <"> link-instance <"> ]
                    [ ";" "category" "=" link-type ]
                    *( ";" link-attribute )
  term             = token
  scheme           = URI
  type-identifier  = scheme term
  resource-type    = type-identifier *( 1*SP type-identifier )
  link-type        = type-identifier *( 1*SP type-identifier )
  link-instance    = URI-reference
  link-attribute   = attribute-name "=" ( token | quoted-string )
  attribute-name   = attr-component *( "." attr-component )
  attr-component   = LOALPHA *( LOALPHA | DIGIT | "-" | "_" )

Example:

	Link: </network/123>;
	    rel="http://schemas.ogf.org/occi/infrastructure#network";
	    self="/link/networkinterface/456";
	    category="http://schemas.ogf.org/occi/infrastructure#networkinterface";
	    occi.networkinterface.interface="eth0";
	    occi.networkinterface.mac="00:11:22:33:44:55";
	    occi.networkinterface.state="active";

or for instances:

	Link: </compute/123?action=start>;
    	rel="http://schemas.ogf.org/occi/infrastructure/compute/action#start"
*/
link: ;

// ---------------------------------------- 
// ------ X-OCCI-Attribute attribute ------
// ---------------------------------------- 
/*

EBNF representation of X-OCCI-Attribute from the http rendering specification

  Attribute        = "X-OCCI-Attribute" ":" #attribute-repr
  attribute-repr   = attribute-name "=" ( token | quoted-string )
  attribute-name   = attr-component *( "." attr-component )
  attr-component   = LOALPHA *( LOALPHA | DIGIT | "-" | "_" )

Example: 
  X-OCCI-Attribute: occi.compute.architechture="x86_64"
  X-OCCI-Attribute: occi.compute.architechture="x86_64", occi.compute.cores=2
*/
attribute: ATTRIBUTE_HEADER attribute_value;// (WS* ',' attribute_value)*;
attribute_value: attribute_string_key attribute_string_value; //	| attribute_int_key ASSIGNMENT attribute_int_value

attribute_string_key: ASSIGNMENT (UPALPHA|LOWALPHA|RESERVED|NUM)*;
attribute_string_value: ASSIGNMENT WS* QUOTE (UPALPHA|LOWALPHA|RESERVED|NUM)* QUOTE;

attribute_int_key: (UPALPHA|LOWALPHA|RESERVED|NUM)*;
attribute_int_value: WS* NUM*;


ATTRIBUTE_HEADER: 'X-OCCI-Attribute' WS? ':' WS?;
// ---------------------------------------- 
// ------ X-OCCI-Location attribute -------
// ---------------------------------------- 
/*

EBNF representation of X-OCCI-Location from the http rendering specification

  Location        = "X-OCCI-Location" ":" location-value
  location-value  = URI-reference

Examples:
  X-OCCI-Location: http://example.com/compute/123
  X-OCCI-Location: http://example.com/compute/123, http://example.com/compute/123
*/
location: LOCATION_HEADER location_value (WS* ',' location_value)*;
location_value:  WS* (UPALPHA|LOWALPHA|RESERVED|NUM)*;

LOCATION_HEADER: 'X-OCCI-Location' WS* ':';


// ----------------------------------------
// --------- Common Lexical Rules ---------
// ----------------------------------------
ATTR_TERMINATOR: ';';
ASSIGNMENT: WS* '=' WS*;

WS:   ( ' ' | '\t') {$channel=HIDDEN;};
QUOTE: '"';
UPALPHA: 'A'..'Z';
LOWALPHA: 'a'..'z';
NUM: '0'..'9';
RESERVED: ':' | '/' | '?' | '_' | '.' | '-';
