grammar Occi;

options {
  language = Java;
}

@header {
    package occi.lexpar;
    import java.util.HashMap;
    import java.util.ArrayList;
}

@lexer::header {
  package occi.lexpar;
}

@members{

  static String occi_categories         = "occi.categories";
  static String occi_links              = "occi.links";
  static String occi_attributes         = "occi.attributes";
  static String occi_locations          = "occi.locations";
  static String occi_core_term          = "occi.core.term";
  static String occi_core_scheme        = "occi.core.scheme";
  static String occi_core_class         = "occi.core.class";
  static String occi_core_class_kind    = "kind";
  static String occi_core_class_mixin   = "mixin";
  static String occi_core_class_action  = "action";
  static String occi_core_title         = "occi.core.title";
  static String occi_core_rel           = "occi.core.rel";
  static String occi_core_location      = "occi.core.location";
  static String occi_core_attributes    = "occi.core.attributes";
  static String occi_core_actions       = "occi.core.actions";
  static String occi_core_target        = "occi.core.target";
  static String occi_core_actionterm    = "occi.core.actionterm";
  static String occi_core_self          = "occi.core.self";
  static String occi_core_category      = "occi.core.category";

  private String last_error = "";

  public static OcciParser getParser(String occiHeader) throws Exception {

    CharStream stream = new ANTLRStringStream(occiHeader);
	  OcciLexer lexer = new OcciLexer(stream);
	  CommonTokenStream tokenStream = new CommonTokenStream(lexer);
	  OcciParser parser = new OcciParser(tokenStream);

    return parser;
  }

  public String getLastError(){
    return last_error;
  }

  private String removeQuotes(String cleanMe){
    if((cleanMe.charAt(0) == '"' && cleanMe.charAt(cleanMe.length()-1) == '"') || (cleanMe.charAt(0) == '\'' && cleanMe.charAt(cleanMe.length()-1)  == '\'' ) )
      return cleanMe.substring(1, cleanMe.length()-1);
    return cleanMe;
  }
}

@rulecatch{
  catch(RecognitionException rex) {

    last_error = getErrorHeader(rex) + " " + getErrorMessage(rex, OcciParser.tokenNames);
    //System.out.println("Parser error: " + last_error);

    throw new OcciParserException(last_error);
  }
}

headers                returns [HashMap values] :
                         (category | link | attribute | location)*
                         {
                           $values = new HashMap();

                           if($category.cats != null)
                             $values.put(occi_categories, $category.cats);

                           if($link.link != null)
                             $values.put(occi_links, $link.link);

                           if($attribute.attrs != null)
                             $values.put(occi_attributes, $attribute.attrs);

                           if($location.urls != null)
                             $values.put(occi_locations, $location.urls);
                         }
                         ;

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

category               returns [ArrayList cats] :
                         'Category' ':'
                         category_values{
                           $cats = $category_values.cats;
                         }
                         ;

category_values        returns [ArrayList cats] :
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

category_value         returns [HashMap cat] :
	                       term_attr scheme_attr klass_attr title_attr? rel_attr? location_attr? c_attributes_attr? actions_attr?{
	                         $cat = new HashMap();

	                         $cat.put(occi_core_term, $term_attr.value);
	                         $cat.put(occi_core_scheme, $scheme_attr.value);
	                         $cat.put(occi_core_class, $klass_attr.value);

                           if($title_attr.value !=null)
                              $cat.put(occi_core_title, $title_attr.value);

                           if($rel_attr.value != null)
                              $cat.put(occi_core_rel, $rel_attr.value);

                           if($location_attr.value != null)
                              $cat.put(occi_core_location, $location_attr.value);

                           if($c_attributes_attr.value != null)
                              $cat.put(occi_core_attributes, $c_attributes_attr.value);

                           if($actions_attr.value != null)
                              $cat.put(occi_core_actions, $actions_attr.value);
	                       }
                         ;

term_attr              returns [String value] :
	                       TERM_VALUE{
	                         $value = $TERM_VALUE.text;
	                       }
	                       ;

//this value can be passed on to the uri rule in Location for validation
scheme_attr            returns [String value] :
	                       ';' 'scheme' '='
	                       QUOTED_VALUE{
	                         $value = removeQuotes($QUOTED_VALUE.text);
	                       }
	                       ;

klass_attr             returns [String value] :
	                       ';' 'class' '='
	                       QUOTED_VALUE{

	                         String klass = removeQuotes($QUOTED_VALUE.text);

	                         if(!(klass.equals(occi_core_class_kind) || klass.equals(occi_core_class_mixin) ||
	                               klass.equals(occi_core_class_action))){
	                           System.out.println("the 'class' attribute's value can only be ['kind', 'mixin', 'action']");
	                           //throw new OcciParserException("the 'class' attribute's value can only be ['kind', 'mixin', 'action']");
	                         }
	                         $value = klass;
	                       }
	                       ;

title_attr             returns [String value] :
	                       ';' 'title' '='
	                       QUOTED_VALUE{
	                         $value = removeQuotes($QUOTED_VALUE.text);
	                       }
	                       ;

//this value can be passed on to the uri rule in Location for validation
rel_attr               returns [String value] :
	                       ';' 'rel' '='
	                       QUOTED_VALUE{
	                         $value = removeQuotes($QUOTED_VALUE.text);
	                       }
	                       ;


//this value can be passed on to the uri rule in Location for validation
location_attr          returns [String value] :
	                       ';' 'location' '='
	                       TARGET_VALUE{
	                         $value = $TARGET_VALUE.text;
	                       }
	                       ;

//these value once extracted can be passed on to the attributes_attr rule
c_attributes_attr      returns [String value] :
	                       ';' 'attributes' '='
	                       QUOTED_VALUE{
	                         $value = removeQuotes($QUOTED_VALUE.text);
	                       }
	                       ;

//this value can be passed on to the uri rule in Location for validation
actions_attr           returns [String value] :
	                       ';' 'actions' '='
	                       QUOTED_VALUE{
	                         $value = removeQuotes($QUOTED_VALUE.text);
	                       }
	                       ;

/* e.g.
        Link: \
          </storage/disk03>; \
          rel="http://example.com/occi/resource#storage"; \
          self="/link/456-456-456"; \
          category="http://example.com/occi/link#disk_drive"; \
          com.example.drive0.interface="ide0", com.example.drive1.interface="ide1"
*/

link                   returns [ArrayList link] :
                         'Link' ':'
                          link_values {
                            $link = $link_values.links;
                          }
                          ;

link_values            returns [ArrayList links] :
                         lv1=link_value {
                           $links = new ArrayList();
                           $links.add($lv1.linkAttrs);
                         }
                         (
                           ',' lv2=link_value{
                                 $links.add($lv2.linkAttrs);
                               }
                         )*
                         ;

link_value             returns [HashMap linkAttrs] :
                         target_attr rel_attr self_attr? category_attr? attribute_attr?
                         {
                           $linkAttrs = new HashMap();

                           $linkAttrs.put(occi_core_target, $target_attr.targetAndTerm.get(0));
                           if($target_attr.targetAndTerm.size() == 2)
                             $linkAttrs.put(occi_core_actionterm, $target_attr.targetAndTerm.get(1));

                           $linkAttrs.put(occi_core_rel, $rel_attr.value);

                           if($self_attr.value != null)
                             $linkAttrs.put(occi_core_self, $self_attr.value);

                           if($category_attr.value != null)
                             $linkAttrs.put(occi_core_category, $category_attr.value);

                           if($attribute_attr.attr != null)
                             $linkAttrs.putAll($attribute_attr.attr);
                         }
                         ;

target_attr            returns [ArrayList targetAndTerm] :
                         '<' TARGET_VALUE {
                               $targetAndTerm = new ArrayList();
                               $targetAndTerm.add($TARGET_VALUE.text);
                             }
                         ('?action='
                           TERM_VALUE{
                             $targetAndTerm.add($TERM_VALUE.text);
                           }
                         )? '>'
                         ;

self_attr              returns [String value] :
                         ';' 'self' '='
                         QUOTED_VALUE{
                           $value = removeQuotes($QUOTED_VALUE.text);
                         }
                         ;

category_attr          returns [String value] :
                         ';' 'category' '='
                         QUOTED_VALUE {
                           $value = removeQuotes($QUOTED_VALUE.text);
                         }
                         ;

attribute_attr         returns [HashMap attr] :
                        ';' attributes_attr {
                            $attr = $attributes_attr.attrs;
                        }
                        ;

attributes_attr        returns [HashMap attrs] :
                         kv1=attribute_kv_attr {
                               $attrs = new HashMap();
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
                           $keyval = new ArrayList();
                           $keyval.add($attribute_name_attr.text);
                           $keyval.add($attribute_value_attr.text);
                         }
                         ;

//See https://github.com/dizz/occi-grammar/issues#issue/3
attribute_name_attr    : TERM_VALUE;// ('.' TERM_VALUE)* ;
attribute_value_attr   : QUOTED_VALUE | DIGITS | FLOAT ;

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
attribute              returns [HashMap attrs] :
                         'X-OCCI-Attribute' ':'
                         attributes_attr{
                           $attrs = $attributes_attr.attrs;
                         }
                         ;
/*
e.g.
  X-OCCI-Location: \
    http://example.com/compute/123, \
    http://example.com/compute/456
*/
location               returns [ArrayList urls] :
                         'X-OCCI-Location' ':'
                         location_values{
                           $urls = $location_values.urls;
                         }
                         ;

location_values        returns [ArrayList urls]:
	                       u1=URL {
	                         $urls = new ArrayList();
	                         $urls.add($u1.text);
	                       }
	                       (
	                         ','
	                         u2=URL{
	                           $urls.add($u2.text);
	                         }
	                       )*
	                       ;

URL           : ( 'http://' | 'https://' )( 'a'..'z' | 'A'..'Z' | '0'..'9' | '@' | ':' | '%' | '_' | '\\' | '+' | '.' | '~' | '#' | '?' | '&' | '/' | '=' )*;
DIGITS        : ('0'..'9')* ;
FLOAT         : ('0'..'9' | '.')* ;
QUOTE         : '"' | '\'' ;
TERM_VALUE    : ('a'..'z' | 'A..Z' | '0'..'9' | '-' | '_' | '.')* ;
TARGET_VALUE  : ('a'..'z' | 'A'..'Z' | '0'..'9' | '/' | '-')* ;
QUOTED_VALUE  : QUOTE ( options {greedy=false;} : . )* QUOTE ;
WS  :   ( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;} ;
