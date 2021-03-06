/*  
Copyright (c) 2008-2011, Intel Performance Learning Solutions Ltd.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Intel Performance Learning Solutions Ltd. nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Intel Performance Learning Solutions Ltd. BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

grammar Occi;

headers : (category | link | attribute | location)* ;

/*
  e.g.
  Category: storage; \
    scheme="http://schemas.ogf.org/occi/infrastructure#"; \
    class="kind"; \
    title="Storage Resource"; \
    rel="http://schemas.ogf.org/occi/core#resource"; \
    location=/storage/; \
    attributes="occi.storage.size occi.storage.state"; \
    actions="http://schemas.ogf.org/occi/infrastructure/storage/action#resize"
*/

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
	     attribute_name_attr    : TERM_VALUE;// ('.' TERM_VALUE)* ; /* e.g. com.example.drive0.interface */
	     attribute_value_attr   : QUOTED_VALUE | DIGITS | FLOAT ; /* e.g. "ide0" or 12 or 12.232 */

/*
e.g.
  X-OCCI-Attribute: \
    occi.compute.architechture="x86_64", \
    occi.compute.cores=2, \
    occi.compute.hostname="testserver", \
    occi.compute.speed=2.66, \
    occi.compute.memory=3.0, \
    occi.compute.state="active"
*/

attribute: 'X-OCCI-Attribute' ':' attributes_attr ;

/*
e.g.
  X-OCCI-Location: \
    http://example.com/compute/123, \
    http://example.com/compute/456
*/

location: 'X-OCCI-Location' ':' location_values;
location_values : URL (',' URL)*;

URL           : ( 'http://' | 'https://' )( 'a'..'z' | 'A'..'Z' | '0'..'9' | '@' | ':' | '%' | '_' | '\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' )*;
DIGITS        : ('0'..'9')* ;
FLOAT         : ('0'..'9' | '.')* ;
QUOTE         : '"' | '\'' ;
TERM_VALUE    : ('a'..'z' | 'A..Z' | '0'..'9' | '-' | '_' | '.')* ;
TARGET_VALUE  : ('a'..'z' | 'A'..'Z' | '0'..'9' | '/' | '-' | '_')* ;
QUOTED_VALUE  : QUOTE ( options {greedy=false;} : . )* QUOTE ;

WS  :   ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;} ;
