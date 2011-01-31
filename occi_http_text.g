grammar occi_http_text;

options {
  language = Java;
}

tokens{
  CATEGORY_HEADER = 'Category:';
  LINK_HEADER = 'Link:';
  ATTR_HEADER = 'X-OCCI-Attribute:';
  LOCATION_HEADER = 'X-OCCI-Location:';
  SCHEME_ATTR = 'scheme';
  CLASS_ATTR = 'class';
  TITLE_ATTR = 'title';
  REL_ATTR = 'rel';
  LOCATION_ATTR = 'location';
  SELF_ATTR = 'self';
  CAT_ATTR = 'category';
  CAT_ATTR_SEP = ';';
  VAL_ASSIGN = '=';
  QUOTE = '"';
  OPEN_PATH = '<';
  CLOSE_PATH = '>';
}


// ---------------------------------------- 
// ---------- Category attribute ---------- 
// ---------------------------------------- 

/*
ABNF representation of category from the http rendering specification

  Category         = "Category" ":" #category-value [ "," #category-value]
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

category_header:
  CATEGORY_HEADER term scheme class (title | rel | location)*
;

term:
  TOKEN
;

scheme:
  CAT_ATTR_SEP SCHEME_ATTR VAL_ASSIGN QUOTE scheme_val QUOTE
;
scheme_val: 
  URI
;

class:
  CAT_ATTR_SEP CLASS_ATTR VAL_ASSIGN QUOTE class_val QUOTE
;
class_val:
  CLASS
;

title:
  CAT_ATTR_SEP TITLE_ATTR VAL_ASSIGN QUOTE title_val QUOTE
;
title_val:
  TOKEN
;

rel:
  CAT_ATTR_SEP REL_ATTR VAL_ASSIGN QUOTE rel_val QUOTE
;
rel_val:
  TOKEN
;

location:
  CAT_ATTR_SEP LOCATION_ATTR VAL_ASSIGN QUOTE location_val QUOTE
;
location_val:
  TOKEN
;

link_header:
  LINK_HEADER  link_path rel (self | link_category)* attributes_attr?
;

link_path:
  OPEN_PATH link_path_val CLOSE_PATH
;
link_path_val:
  PATH 
;

self:
  CAT_ATTR_SEP SELF_ATTR VAL_ASSIGN QUOTE self_val QUOTE
;
self_val:
  TOKEN
;

link_category:
  CAT_ATTR_SEP CAT_ATTR VAL_ASSIGN QUOTE link_category_val QUOTE
;
link_category_val:
  TOKEN
;

attributes_attr:
  attribute_attr+
;
attribute_attr:
  CAT_ATTR_SEP attribute_attr_name VAL_ASSIGN attribute_attr_val
;
attribute_attr_name:
  ATTRIB_NAME
;
attribute_attr_val:
  (QUOTE attribute_attr_string_val QUOTE) | attribute_attr_int_val
;
attribute_attr_string_val:
  TOKEN
;
attribute_attr_int_val:
  DIGIT
;


// ---------------------------------------- 
// ------ X-OCCI-Attribute attribute ------
// ---------------------------------------- 
/*

ABNF representation of X-OCCI-Attribute from the http rendering specification

  Attribute        = "X-OCCI-Attribute" ":" #attribute-repr
  attribute-repr   = attribute-name "=" ( token | quoted-string )
  attribute-name   = attr-component *( "." attr-component )
  attr-component   = LOALPHA *( LOALPHA | DIGIT | "-" | "_" )

Example: 
  X-OCCI-Attribute: occi.compute.architechture="x86_64"
  X-OCCI-Attribute: occi.compute.architechture="x86_64", occi.compute.cores=2
*/

attribute_header:
  ATTR_HEADER
;


// ---------------------------------------- 
// ------ X-OCCI-Location attribute -------
// ---------------------------------------- 
/*

ABNF representation of X-OCCI-Location from the http rendering specification

  Location        = "X-OCCI-Location" ":" location-value
  location-value  = URI-reference

Examples:
  X-OCCI-Location: http://example.com/compute/123
  X-OCCI-Location: http://example.com/compute/123, http://example.com/compute/123
*/

location_header:
  LOCATION_HEADER
;

ATTRIB_NAME: ('a'..'z' | 'A'..'Z')('a'..'z' | 'A'..'Z')+ ('.') TOKEN;
PATH: ('/' TOKEN) ('/' TOKEN)*;
CLASS: ('kind'|'mixin'|'action');
URI: ('http://' | 'https://') TOKEN;
TOKEN: ('a'..'z' | 'A'..'Z') ('a'..'z' | 'A'..'Z')*;
DIGIT: '0'..'9'*;
WS: (' ' | '\t'){$channel = HIDDEN};