grammar occi_attribute_location;

/**
X-OCCI-Location: http://www.occi-wg.org/compute/123-123-123
X-OCCI-Location: http://www.occi-wg.org/compute/123-123-123, http://www.occi-wg.org/compute/321-321-321
*/
location_header
       :       'X-OCCI-Location' ':' uri (',' uri)* NL
       ;

uri: (ABS_URI | REL_URI) FRAGMENT?;

/**
X-OCCI-Attribute: occi.compute.cores=2
X-OCCI-Attribute: occi.compute.architecture="x86", occi.compute.cores=2, occi.compute.speed=2.4
*/
attribute_header
       :       'X-OCCI-Attribute' ':' occi_attribute? (',' occi_attribute)* NL
       ;
occi_attribute: OCCI_ATTRIBUTE_NAME '=' OCCI_ATTRIBUTE_VALUE;

ABS_URI: SCHEME (AUTHORITY | IPV4ADDRESS) PORT? ABS_PATH? QUERY?;
REL_URI: ABS_PATH QUERY?;
FRAGMENT: '#' (ALPHA_CHAR | DIGIT_CHAR | RESERVED | MARK | ESCAPED)+;

OCCI_ATTRIBUTE_NAME: ATTR_COMPO ('.' ATTR_COMPO)*;
OCCI_ATTRIBUTE_VALUE: INT | STRING | FLOAT | BOOL ;

fragment SCHEME: ALPHA_CHAR+ '://';
fragment PORT: ':' DIGIT_CHAR+;
fragment AUTHORITY: (AUTHORITY_CHAR+ ('.' AUTHORITY_CHAR+)*);
fragment IPV4ADDRESS: (DIGIT_CHAR)+ '.' (DIGIT_CHAR)+ '.' (DIGIT_CHAR)+ '.' (DIGIT_CHAR)+;
fragment ABS_PATH: ( '/' PCHARS (';' PCHARS)? )+ ;
fragment PCHARS : (ESCAPED | ALPHA_CHAR | DIGIT_CHAR | PATH_SEG_CHAR | '-')+ ;
fragment ATTR_COMPO: ATTR_COMPO_START_CHAR ATTR_COMPO_CHAR* ;
fragment ATTR_COMPO_START_CHAR: ALPHA_CHAR | '-' | '_';
fragment ATTR_COMPO_CHAR: ALPHA_CHAR | DIGIT_CHAR | '-' | '_';
fragment QUERY: '?' (ALPHA_CHAR | DIGIT_CHAR | RESERVED | MARK | ESCAPED)+;
fragment BOOL: 'true' | 'false';
fragment FLOAT: INT '.' INT;
fragment INT: DIGIT_CHAR+;
fragment STRING:  '"' STR* '"';
fragment STR: ~('\\'|'"') | ESC_SEQ;
fragment HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;
fragment ESC_SEQ:   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\');// | UNICODE_ESC | OCTAL_ESC;

fragment ESCAPED: '%' HEX HEX;
fragment RESERVED: ';' | '/' | '?' | ':' | '@' | '&' | '=' | '+' | '$' | ',';
fragment MARK: '-' | '_' | '.' | '!' | '~' | '*' | '\'' | '(' | ')';
fragment PATH_SEG_CHAR: ':' | '@' | '&' | '=' | '+' | '$' ;// | ','; //have removed this
fragment HEX: DIGIT_CHAR | ('a'..'f' | 'A'..'F');
fragment AUTHORITY_CHAR: ALPHA_CHAR | '-';
fragment ALPHA_CHAR: 'a'..'z' | 'A'..'Z' ;
fragment DIGIT_CHAR: '0'..'9';

WS : ' ' {skip();} ;
NL : '\r'? '\n' ;