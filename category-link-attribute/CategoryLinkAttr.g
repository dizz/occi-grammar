grammar CategoryLinkAttr;

options {
  language = Java;
}

category: 'Category' ':' category_values;
	category_values: category_value (',' category_value)*;
	category_value: term_attr scheme_attr klass_attr title_attr? rel_attr? location_attr? c_attributes_attr? actions_attr?;
	term_attr            : TERM_VALUE;
	scheme_attr          : ';' 'scheme' '=' QUOTED_VALUE; //this value can be passed on to the uri rule in Location for validation
	klass_attr           : ';' 'class' '=' QUOTED_VALUE;
	title_attr           : ';' 'title' '=' QUOTED_VALUE;
	rel_attr             : ';' 'rel' '=' QUOTED_VALUE; //this value can be passed on to the uri rule in Location for validation
	location_attr        : ';' 'location' '=' TARGET_VALUE; //this value can be passed on to the uri rule in Location for validation
	c_attributes_attr    : ';' 'attributes' '=' QUOTED_VALUE; //these value once extracted can be passed on to the attributes_attr rule
	actions_attr         : ';' 'actions' '=' QUOTED_VALUE; //this value can be passed on to the uri rule in Location for validation

/* e.g.
        Link:
        </storage/disk03>;
        rel="http://example.com/occi/resource#storage";
        self="/link/456-456-456";
        category="http://example.com/occi/link#disk_drive";
        com.example.drive0.interface="ide0", com.example.drive1.interface="ide1"
*/

link                   : 'Link' ':' link_values;
link_values            : link_value (',' link_value)*;
link_value             : target_attr rel_attr self_attr? category_attr? attribute_attr? ;

target_attr            : '<' (TARGET_VALUE) ('?action=' TERM_VALUE)? '>' ;

self_attr              returns [String value] :
                        ';' 'self' '=' QUOTED_VALUE{
                          $value = $QUOTED_VALUE.text;
                        }
                        ;

category_attr          returns [String value] :
                        ';' 'category' '=' QUOTED_VALUE {
                          $value = $QUOTED_VALUE.text;
                        }
                        ;

attribute_attr         returns [java.util.HashMap attr] :
                        ';' attributes_attr {
                            $attr = $attributes_attr.attrs;
                        }
                        ;

attributes_attr        returns [java.util.HashMap attrs] :
                        kv1=attribute_kv_attr {
                            $attrs = new java.util.HashMap();
                            $attrs.put($kv1.keyval.get(0), $kv1.keyval.get(1));
                        }
                        (
                          ',' kv2=attribute_kv_attr {
                                $attrs.put($kv2.keyval.get(0), $kv2.keyval.get(1));
                              }
                        )*
                        ;

attribute_kv_attr      returns [ArrayList keyval] :
                        attribute_name_attr '=' attribute_value_attr {
                          $keyval.add($attribute_name_attr.text);
                          $keyval.add($attribute_value_attr.text);
                        }
                        ;
attribute_name_attr    : TERM_VALUE ('.' TERM_VALUE)* ;
attribute_value_attr   : QUOTED_VALUE | DIGITS | (DIGITS '.' DIGITS) ;

attribute: 'X-OCCI-Attribute' ':' attributes_attr ;

DIGITS        : ('0'..'9')* ;
QUOTE         : '"' | '\'' ;
TERM_VALUE    : ('a'..'z' | 'A..Z' | '0'..'9' | '-' | '_')* ;
TARGET_VALUE  : ('a'..'z' | 'A'..'Z' | '0'..'9' | '/' | '-')* ;
QUOTED_VALUE  : QUOTE ( options {greedy=false;} : . )* QUOTE ;

WS  :   ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;} ;
