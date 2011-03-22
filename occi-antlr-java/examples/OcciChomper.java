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

package occi.lexpar.demo;

import java.util.ArrayList;
import java.util.HashMap;

import occi.lexpar.OcciParser;

/*

Parses OCCI text renderings of:
 - Link, 
 - Category, 
 - Attribute, 
 - Location 
 - Combination of all

Extracts the values from the renderings and prints them to standard out.

*/

public class OcciChomper {

	public static void main(String[] args) {

		//Link text format
		String link = "Link: " +
						"</storage/disk03>; " +
						"rel='http://example.com/occi/resource#storage';" +
						"self='/link/456-456-456';" +
						"category='http://example.com/occi/link#disk_drive';" +
						"com.example.drive0.interface='ide0'," +
						"com.example.drive1.interface='title'"
						;

		//Category text format
		String category = "Category: " +
							"storage; " +
							"scheme='http://schemas.ogf.org/occi/infrastructure#';" +
							"class='kind'; title='Storage Resource';" +
							"rel='http://schemas.ogf.org/occi/core#resource';" +
							"location=/storage/;" +
							"attributes='occi.storage.size occi.storage.state';" +
							"actions='http://schemas.ogf.org/occi/infrastructure/storage/action#resize'";

		//Attribute text format
		String attributes = "X-OCCI-Attribute: " +
							"occi.compute.architechture='x86', " +
							"occi.compute.cores=2, " +
							"occi.compute.hostname='testserver', " +
							"occi.compute.speed=2.66, " +
							"occi.compute.memory=3.0, " +
							"occi.compute.state='active'";

		//Location text format
		String location = "X-OCCI-Location: http://example.com/compute/123, http://example.com/compute/456";

		//All the above combined as text format
		String combined = category + "\n" + link + "\n" + attributes;

		System.out.println("Will parse:\n" + link);

		//parse links
		ArrayList res;
		try {
			res = OcciParser.getParser(link).link();
			System.out.println("No errors on parsing link header.");
			System.out.println("Result: " + res.toString() + "\n");
		} catch (Exception e2) {
			e2.printStackTrace();
			System.exit(0);
		}

		//parse category
		System.out.println("Will parse:\n" + category);
		try {
			res = OcciParser.getParser(category).category();
			System.out.println("No errors on parsing category header.");
			System.out.println("Result: " + res.toString() + "\n");
		} catch (Exception e1) {
			e1.printStackTrace();
			System.exit(0);
		}

		//parse attributes
		System.out.println("Will parse:\n" + attributes);
		HashMap res1;
		try {
			res1 = OcciParser.getParser(attributes).attribute();
			System.out.println("No errors on parsing attribute header.");
			System.out.println("Result: " + res1.toString() + "\n");
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}

		//parse attributes
		System.out.println("Will parse:\n" + location);
		try {
			res = OcciParser.getParser(location).location();
			System.out.println("No errors on parsing location header.");
			System.out.println("Result: " + res.toString() + "\n");
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}

		//parse a set of combined OCCI headers
		System.out.println("Will parse:\n" + combined);
		try {
			res1 = OcciParser.getParser(combined).headers();
			System.out.println("No errors on parsing combined header.");
			System.out.println("Result: " + res1.toString() + "\n");
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(0);
		}
	}
}
