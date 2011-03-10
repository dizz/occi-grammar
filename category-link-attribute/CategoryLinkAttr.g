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

link: 'Link' ':' link_values;
	link_values: link_value (',' link_value)*;
	link_value: target_attr rel_attr self_attr? category_attr? attribute_attr? ;
	target_attr            : '<' (TARGET_VALUE) ('?action=' TERM_VALUE)? '>' ; //this value can be passed on to the rel uri rule in Location for validation with the '<' and '>' stripped
	self_attr              : ';' 'self' '=' QUOTED_VALUE ; //this value can be passed on to the uri rule in Location for validation
	category_attr          : ';' 'category' '=' QUOTED_VALUE ; //this value can be passed on to the uri rule in Location for validation
	attribute_attr         : ';' attributes_attr ; /* e.g. com.example.drive0.interface="ide0", com.example.drive1.interface="ide1" */
	 attributes_attr        : attribute_kv_attr (',' attribute_kv_attr)* ; /* e.g. com.example.drive0.interface="ide0", com.example.drive1.interface="ide1" */
	   attribute_kv_attr      : attribute_name_attr '=' attribute_value_attr; /* e.g. com.example.drive0.interface="ide0" */
	     attribute_name_attr    : TERM_VALUE ('.' TERM_VALUE)* ; /* e.g. com.example.drive0.interface */
	     attribute_value_attr   : QUOTED_VALUE | DIGITS | (DIGITS '.' DIGITS) ; /* e.g. "ide0" or 12 or 12.232 */

attribute: 'X-OCCI-Attribute' ':' attributes_attr ;

DIGITS        : ('0'..'9')* ;
QUOTE         : '"' | '\'' ;
TERM_VALUE    : ('a'..'z' | 'A..Z' | '0'..'9' | '-' | '_')* ;
TARGET_VALUE  : ('a'..'z' | 'A'..'Z' | '0'..'9' | '/' | '-')* ;
QUOTED_VALUE  : QUOTE ( options {greedy=false;} : . )* QUOTE ;

WS  :   ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;} ;
