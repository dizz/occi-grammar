import be.edmonds.occi.occi_http_textParser;


public class occijson {

	/**
	This will output this (unformatted) JSON 
	[
	    {
	        "category": [
	            {
	                "term": "ie",
	                "scheme": "http://",
	                "class": "mixin",
	                "title": "null",
	                "rel": "null",
	                "location": "null",
	                "attributes": [
	                    null
	                ],
	                "actions": [
	                    null
	                ]
	            },
	            {
	                "term": "compute",
	                "scheme": "http://",
	                "class": "kind",
	                "title": "null",
	                "rel": "null",
	                "location": "null",
	                "attributes": [
	                    null
	                ],
	                "actions": [
	                    null
	                ]
	            },
	            {
	                "term": "large",
	                "scheme": "http://",
	                "class": "mixin",
	                "title": "null",
	                "rel": "null",
	                "location": "null",
	                "attributes": [
	                    null
	                ],
	                "actions": [
	                    null
	                ]
	            },
	            {
	                "term": "ubuntu",
	                "scheme": "http://",
	                "class": "mixin",
	                "title": "null",
	                "rel": "null",
	                "location": "null",
	                "attributes": [
	                    null
	                ],
	                "actions": [
	                    null
	                ]
	            }
	        ],
	        "attributes": {
	            "my.attr": "val",
	            "my.other": 123
	        }
	    }
	]	 
	 */
	public static void main(String[] args) {

		//Note that the grammar does not correct support certain values
		String convertMe = "Category: ie; scheme=\"http://\"; class=\"mixin\", compute; scheme=\"http://\"; class=\"kind\", large; scheme=\"http://\"; class=\"mixin\", ubuntu; scheme=\"http://\"; class=\"mixin\"" +
									"X-OCCI-Attribute: my.attr=\"val\", my.other=123";

		try {
			occi_http_textParser p = occi_http_textParser.getParser(convertMe);
			System.out.println(p.occi_request());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
