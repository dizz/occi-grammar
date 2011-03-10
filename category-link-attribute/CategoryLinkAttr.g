grammar CategoryLinkAttr;

options {
  language = Java;
}

/*
  e.g.
  Category: storage;
    scheme="http://schemas.ogf.org/occi/infrastructure#";
    class="kind";
    title="Storage Resource";
    rel="http://schemas.ogf.org/occi/core#resource";
    location=/storage/;
    attributes="occi.storage.size occi.storage.state";
    actions="http://schemas.ogf.org/occi/infrastructure/storage/action#resize"
*/

category               returns [java.util.ArrayList cats] :
                         'Category' ':'
                         category_values{
                           $cats = $category_values.cats;
                         }
                         ;

	category_values      returns [java.util.ArrayList cats] :
	                       cv1=category_value{
	                         $cats = new ArrayList();
	                         $cats.add($cv1.cat);
	                       }
	                       (
	                       ',' cv2=category_value{
	                             $cats.add($cv2.cat);
	                           }
	                       )*
	                       ;

	category_value       returns [java.util.HashMap cat] :
	                       term_attr scheme_attr klass_attr title_attr? rel_attr? location_attr? c_attributes_attr? actions_attr?{
	                         $cat = new java.util.HashMap();

	                         $cat.put("occi.core.term", $term_attr.value);
	                         $cat.put("occi.core.scheme", $scheme_attr.value);
	                         $cat.put("occi.core.class", $klass_attr.value);

                           if($title_attr.value !=null)
                              $cat.put("occi.core.title", $title_attr.value);

                           if($rel_attr.value != null)
                              $cat.put("occi.core.rel", $rel_attr.value);

                           if($location_attr.value != null)
                              $cat.put("occi.core.location", $location_attr.value);

                           if($c_attributes_attr.value != null)
                              $cat.put("occi.core.attributes", $c_attributes_attr.value);

                           if($actions_attr.value != null)
                              $cat.put("occi.core.actions", $actions_attr.value);
	                       }
                         ;

	term_attr            returns [String value] :
	                       TERM_VALUE{
	                         $value = $TERM_VALUE.text;
	                       }
	                       ;

	//this value can be passed on to the uri rule in Location for validation
	scheme_attr          returns [String value] :
	                       ';' 'scheme' '='
	                       QUOTED_VALUE{
	                         $value = $QUOTED_VALUE.text;
	                       }
	                       ;

	klass_attr           returns [String value] :
	                       ';' 'class' '='
	                       QUOTED_VALUE{

	                         String klass = $QUOTED_VALUE.text;
                           klass = klass.substring(1, klass.length()-1);

	                         if(!(klass.equals("kind") || klass.equals("mixin") || klass.equals("action"))){
	                           System.out.println("the 'class' attribute's value can only be ['kind', 'mixin', 'action']");
	                           //throw new Exception("the 'class' attribute's value can only be ['kind', 'mixin', 'action']");
	                         }
	                         $value = klass;
	                       }
	                       ;

	title_attr           returns [String value] :
	                       ';' 'title' '='
	                       QUOTED_VALUE{
	                         $value = $QUOTED_VALUE.text;
	                       }
	                       ;

	//this value can be passed on to the uri rule in Location for validation
	rel_attr             returns [String value] :
	                     ';' 'rel' '='
	                     QUOTED_VALUE{
	                       $value = $QUOTED_VALUE.text;
	                     }
	                     ;

  //this value can be passed on to the uri rule in Location for validation
	location_attr        returns [String value] :
	                       ';' 'location' '='
	                       TARGET_VALUE{
	                         $value = $TARGET_VALUE.text;
	                       }
	                       ;

  //these value once extracted can be passed on to the attributes_attr rule
	c_attributes_attr    returns [String value] :
	                       ';' 'attributes' '='
	                       QUOTED_VALUE{
	                         $value = $QUOTED_VALUE.text;
	                       }
	                       ;

	//this value can be passed on to the uri rule in Location for validation
	actions_attr         returns [String value] :
	                       ';' 'actions' '='
	                       QUOTED_VALUE{
	                         $value = $QUOTED_VALUE.text;
	                       }
	                       ;

/* e.g.
        Link:
        </storage/disk03>;
        rel="http://example.com/occi/resource#storage";
        self="/link/456-456-456";
        category="http://example.com/occi/link#disk_drive";
        com.example.drive0.interface="ide0", com.example.drive1.interface="ide1"
*/

link                   returns [java.util.ArrayList link] :
                        'Link' ':'
                        link_values {
                          $link = $link_values.links;
                        }
                        ;

link_values            returns [java.util.ArrayList links] :
                        lv1=link_value {
                          $links = new java.util.ArrayList();
                          $links.add($lv1.linkAttrs);
                        }
                        (
                        ',' lv2=link_value{
                              $links.add($lv2.linkAttrs);
                            }
                        )*
                        ;

link_value             returns [java.util.HashMap linkAttrs] :
                        target_attr rel_attr self_attr? category_attr? attribute_attr?
                        {
                          $linkAttrs = new java.util.HashMap();

                          $linkAttrs.put("occi.core.target", $target_attr.targetAndTerm.get(0));
                          if($target_attr.targetAndTerm.size() == 2)
                            $linkAttrs.put("occi.core.actionterm", $target_attr.targetAndTerm.get(1));

                          $linkAttrs.put("occi.core.rel", $rel_attr.value);

                          if($self_attr.value != null)
                            $linkAttrs.put("occi.core.self", $self_attr.value);

                          if($category_attr.value != null)
                            $linkAttrs.put("occi.core.category", $category_attr.value);

                          if($attribute_attr.attr != null)
                            $linkAttrs.putAll($attribute_attr.attr);
                        }
                        ;

target_attr            returns [java.util.ArrayList targetAndTerm] :
                        '<' TARGET_VALUE {
                          $targetAndTerm = new java.util.ArrayList();
                          $targetAndTerm.add($TARGET_VALUE.text);
                        }
                        ('?action='
                          TERM_VALUE{
                            $targetAndTerm.add($TERM_VALUE.text);
                          }
                        )? '>'
                        ;

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

attribute_kv_attr      returns [java.util.ArrayList keyval] :
                        attribute_name_attr '=' attribute_value_attr {
                          $keyval = new java.util.ArrayList();
                          $keyval.add($attribute_name_attr.text);
                          $keyval.add($attribute_value_attr.text);
                        }
                        ;

attribute_name_attr    : TERM_VALUE ('.' TERM_VALUE)* ;
attribute_value_attr   : QUOTED_VALUE | DIGITS | (DIGITS '.' DIGITS) ;

attribute              returns [java.util.HashMap attrs] :
                         'X-OCCI-Attribute' ':'
                         attributes_attr{
                           $attrs = $attributes_attr.attrs;
                         }
                         ;

location               returns [java.util.ArrayList urls] :
                         'X-OCCI-Location' ':'
                         location_values{
                           $urls = $location_values.urls;
                         }
                         ;

location_values        returns [java.util.ArrayList urls]:
	                       u1=URI {
	                         $urls = new java.util.ArrayList();
	                         $urls.add($u1.text);
	                       }
	                       (
	                         ','
	                         u2=URI{
	                           $urls.add($u2.text);
	                         }
	                       )*
	                       ;

URI           : ( 'http://' | 'https://' )( 'a'..'z' | 'A'..'Z' | '0'..'9' | '@' | ':' | '%' | '_' | '\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' )*;
DIGITS        : ('0'..'9')* ;
QUOTE         : '"' | '\'' ;
TERM_VALUE    : ('a'..'z' | 'A..Z' | '0'..'9' | '-' | '_')* ;
TARGET_VALUE  : ('a'..'z' | 'A'..'Z' | '0'..'9' | '/' | '-')* ;
QUOTED_VALUE  : QUOTE ( options {greedy=false;} : . )* QUOTE ;

WS  :   ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;} ;
