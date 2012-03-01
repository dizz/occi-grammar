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

grammar OCCI;

options { language = Ruby; }

@header {
  require 'ostruct';
}

@members {

  def emit_error_message(message)
    \$log.warn("Grammer: " + message)
  end

  def remove_quotes(s)
    s.gsub!(/^["|'](.*?)['|"]$/,'\1')
  end
}

headers : (category | link | attribute | location)* ;

// --------------------------------------------------------------------------------------------------------------------
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

category returns [categories]:

  'Category' ':' category_values  { $categories = $category_values.category_list };

  category_values returns [category_list]

    @init { $category_list = Array.new; }

    :   cv1 = category_value      { $category_list << $cv1.data }
        (',' cv2 = category_value { $category_list << $cv2.data })*;

	category_value returns [data]

    scope { category }
    @init { $category_value::category = Hash.new; }

	  :  term_attr scheme_attr klass_attr title_attr? rel_attr? location_attr? c_attributes_attr? actions_attr?
	     { $data = OpenStruct.new($category_value::category) };

	term_attr:          TERM_VALUE
	                    { $category_value::category['term'] = $TERM_VALUE.text };
	
	/* this value can be passed on to the uri rule in Location for validation */
	scheme_attr:        ';' 'scheme'     '=' QUOTED_VALUE
	                    { $category_value::category['scheme'] = remove_quotes $QUOTED_VALUE.text };
	
	klass_attr:         ';' 'class'      '=' QUOTED_VALUE
                      { $category_value::category['clazz'] = remove_quotes $QUOTED_VALUE.text };
                    
	title_attr:         ';' 'title'      '=' QUOTED_VALUE
                      { $category_value::category['title'] = remove_quotes $QUOTED_VALUE.text };
                    
  /* this value can be passed on to the uri rule in Location for validation */
	rel_attr:           ';' 'rel'        '=' QUOTED_VALUE
                      { $category_value::category['related'] = remove_quotes $QUOTED_VALUE.text };

	/* this value can be passed on to the uri rule in Location for validation */
	location_attr:      ';' 'location'   '=' QUOTED_VALUE
                      { $category_value::category['location'] = remove_quotes $QUOTED_VALUE.text };
	
	/* these value once extracted can be passed on to the attributes_attr rule */
	c_attributes_attr:  ';' 'attributes' '=' QUOTED_VALUE
                      { $category_value::category['attributes'] = remove_quotes $QUOTED_VALUE.text };
	
	/* this value can be passed on to the uri rule in Location for validation */
	actions_attr:       ';' 'actions'    '=' QUOTED_VALUE
	                    { $category_value::category['actions'] = remove_quotes $QUOTED_VALUE.text };

// --------------------------------------------------------------------------------------------------------------------
/* e.g.
        Link:
        </storage/disk03>;
        rel="http://example.com/occi/resource#storage";
        self="/link/456-456-456";
        category="http://example.com/occi/link#disk_drive";
        com.example.drive0.interface="ide0", com.example.drive1.interface="ide1"
*/

link returns [links]:

  'Link' ':' link_values  { $links = $link_values.link_list };

	link_values returns [link_list]
	
	 @init { $link_list = Array.new; }

	 :   lv1 = link_value      { $link_list << $lv1.data }
	     (',' lv2 = link_value { $link_list << $lv2.data })*;

	link_value returns [data]
	
	 scope { link }
	 @init { 
	   $link_value::link = Hash.new;
	 }
	
	 :  target_attr related_attr self_attr? category_attr? attribute_attr?
	    {
	       $link_value::link['attributes'] = $attribute_attr.attributes if $attribute_attr.attributes != nil
	       $data = OpenStruct.new($link_value::link)
	    } ;

	/* this value can be passed on to the rel uri rule in Location for validation with the '<' and '>' stripped */
    target_attr:           '<' ( TARGET_VALUE { $link_value::link['target'] = $TARGET_VALUE.text } | URL { $link_value::link['target'] = $URL.text } ) '>';

    related_attr:          ';' 'rel'         '=' QUOTED_VALUE
                         { $link_value::link['related'] = remove_quotes $QUOTED_VALUE.text };

	/* this value can be passed on to the uri rule in Location for validation */
	self_attr:             ';' 'self'        '=' QUOTED_VALUE
	                       { $link_value::link['self'] = remove_quotes $QUOTED_VALUE.text; };

	/* this value can be passed on to the uri rule in Location for validation */
	category_attr:         ';' 'category'    '=' QUOTED_VALUE
                         { $link_value::link['category'] = remove_quotes $QUOTED_VALUE.text; };

	/* e.g. com.example.drive0.interface="ide0", com.example.drive1.interface="ide1" */
	attribute_attr returns [attributes]

	 :                     ';' attributes_attr
	                       { $attributes = $attributes_attr.attributes } ;

	/* e.g. com.example.drive0.interface="ide0", com.example.drive1.interface="ide1" */
  attributes_attr returns [attributes]
  
    scope { data }
    @init { $attributes_attr::data = Hash.new }

    :                    attribute_kv_attr (',' attribute_kv_attr)*
                         { $attributes = $attributes_attr::data } ;

  /* e.g. com.example.drive0.interface="ide0" */
  attribute_kv_attr:     attribute_name_attr '=' attribute_value_attr
                         { $attributes_attr::data[$attribute_name_attr.text] = $attribute_value_attr.text; };

  /* ('.' TERM_VALUE)* ; /* e.g. com.example.drive0.interface */
  attribute_name_attr:   TERM_VALUE;

  /* e.g. "ide0" or 12 or 12.232 */
  attribute_value_attr:  QUOTED_VALUE | DIGITS | FLOAT | URL ;

// --------------------------------------------------------------------------------------------------------------------
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

attribute returns [attributes]

  :                      'X-OCCI-Attribute' ':' attributes_attr
                         { $attributes = $attributes_attr.attributes } ;

// --------------------------------------------------------------------------------------------------------------------
/*
e.g.
  X-OCCI-Location: \
    http://example.com/compute/123, \
    http://example.com/compute/456
*/

location returns [locations]

   :                     'X-OCCI-Location' ':' location_values
                         { $locations = $location_values.locations };

  location_values returns [locations]

    @init { $locations = Array.new }

    :                    u1 = URL      { $locations << $u1.text }
                         (',' u2 = URL { $locations << $u2.text})*;

// --------------------------------------------------------------------------------------------------------------------

URL:          ( 'http://' | 'https://' )( 'a'..'z' | 'A'..'Z' | '0'..'9' | '@' | ':' | '%' | '_' | '\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' | '-' )*;
DIGITS:       ('0'..'9')* ;
FLOAT:        ('0'..'9' | '.')* ;
TERM_VALUE:   ('a'..'z' | 'A..Z' | '0'..'9' | '-' | '_' | '.')* ;
TARGET_VALUE: ('a'..'z' | 'A'..'Z' | '0'..'9' | '/' | '-' | '_')* ;
QUOTED_VALUE: '"' (ESC | ~('\\'|'"'))* '"' ;
WS:           ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;} ;

protected
ESC    : '\\' ('"')* ;