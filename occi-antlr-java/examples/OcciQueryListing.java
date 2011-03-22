package occi.lexpar.demo;

import java.util.HashMap;

import occi.lexpar.OcciParser;

/*

Parses the result of an OCCI Query Interface response.
Extracts the values from the response and prints them to standard out.

*/

public class OcciQueryListing {

	public static String listing =
			"Category: start; scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#'; class='action'; title='Start Compute Action'\n"+
			"Category: stop; scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#'; class='action'; title='Stop Compute Action'; attributes='acpioff graceful poweroff'\n"+
			"Category: restart; scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#'; class='action'; title='Restart Compute Action'; attributes='warm graceful cold'\n"+
			"Category: suspend; scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#'; class='action'; title='Suspend Compute Action'; attributes='hibernate suspend'\n"+
			"Category: up; scheme='http://schemas.ogf.org/occi/infrastructure/network/action#'; class='action'; title='Up Network Action'\n"+
			"Category: down; scheme='http://schemas.ogf.org/occi/infrastructure/network/action#'; class='action'; title='Down Network Action'\n"+
			"Category: online; scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#'; class='action'; title='Online Storage Action'\n"+
			"Category: offline; scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#'; class='action'; title='Offline Storage Action'\n"+
			"Category: backup; scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#'; class='action'; title='Backup Storage Action'\n"+
			"Category: snapshot; scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#'; class='action'; title='Snapshot Storage Action'\n"+
			"Category: resize; scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#'; class='action'; title='Resize Storage Action'\n"+
			"Category: degrade; scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#'; class='action'; title='Degrade Storage Action'\n"+
			"Category: stop; scheme='http://sla-at-soi.eu/occi/infrastructure/service/action#'; class='action'; title='A Stop Service Action'\n"+
			"Category: start; scheme='http://sla-at-soi.eu/occi/infrastructure/service/action#'; class='action'; title='A Start Service Action'\n"+
			"Category: restart; scheme='http://sla-at-soi.eu/occi/infrastructure/service/action#'; class='action'; title='A Restart Service Action'\n"+
			"Category: suspend; scheme='http://sla-at-soi.eu/occi/infrastructure/service/action#'; class='action'; title='A Suspend Service Action'\n"+
			"Category: entity; scheme='http://schemas.ogf.org/occi/core#'; class='kind'; title='Entity type'; attributes='occi.core.title occi.core.id'\n"+
			"Category: resource; scheme='http://schemas.ogf.org/occi/core#'; class='kind'; title='Resource type'; rel='http://schemas.ogf.org/occi/core#entity'; attributes='occi.core.summary'\n"+
			"Category: compute; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='kind'; title='Compute type'; rel='http://schemas.ogf.org/occi/core#resource'; location=/compute; attributes='occi.compute.hostname occi.compute.architecture occi.compute.memory occi.compute.speed occi.compute.cores occi.compute.state'; actions='http://schemas.ogf.org/occi/infrastructure/compute/action#suspend http://schemas.ogf.org/occi/infrastructure/compute/action#stop http://schemas.ogf.org/occi/infrastructure/compute/action#start http://schemas.ogf.org/occi/infrastructure/compute/action#restart'\n"+
			"Category: network; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='kind'; title='Network type'; rel='http://schemas.ogf.org/occi/core#resource'; location=/network; attributes='occi.network.label occi.network.vlan occi.network.state'; actions='http://schemas.ogf.org/occi/infrastructure/network/action#down http://schemas.ogf.org/occi/infrastructure/network/action#up'\n"+
			"Category: storage; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='kind'; title='Storage type'; rel='http://schemas.ogf.org/occi/core#resource'; location=/storage; attributes='occi.storage.size occi.storage.state'; actions='http://schemas.ogf.org/occi/infrastructure/storage/action#offline http://schemas.ogf.org/occi/infrastructure/storage/action#backup http://schemas.ogf.org/occi/infrastructure/storage/action#snapshot http://schemas.ogf.org/occi/infrastructure/storage/action#degrade http://schemas.ogf.org/occi/infrastructure/storage/action#resize http://schemas.ogf.org/occi/infrastructure/storage/action#online'\n"+
			"Category: service; scheme='http://sla-at-soi.eu/occi/infrastructure#'; class='kind'; title='Service type'; rel='http://schemas.ogf.org/occi/core#resource'; location=/service; attributes='eu.slasoi.infrastructure.service.monitoringconfig eu.slasoi.infrastructure.service.state eu.slasoi.infrastructure.service.name'; actions='http://sla-at-soi.eu/occi/infrastructure/service/action#start http://sla-at-soi.eu/occi/infrastructure/service/action#stop http://sla-at-soi.eu/occi/infrastructure/service/action#suspend http://sla-at-soi.eu/occi/infrastructure/service/action#restart'\n"+
			"Category: link; scheme='http://schemas.ogf.org/occi/core#'; class='kind'; title='Link type'; rel='http://schemas.ogf.org/occi/core#entity'; location=/link; attributes='occi.core.target occi.core.source'\n"+
			"Category: networkinterface; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='kind'; title='A network interface link'; rel='http://schemas.ogf.org/occi/core#link'; location=/link; attributes='occi.networkinterface.state occi.networkinterface.interface occi.networkinterface.mac'\n"+
			"Category: storagelink; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='kind'; title='A storage link'; rel='http://schemas.ogf.org/occi/core#link'; location=/link; attributes='occi.storagelink.mountpoint occi.storagelink.state occi.storagelink.deviceid'\n"+
			"Category: slasoicompute; scheme='http://sla-at-soi.eu/occi/infrastructure#'; class='mixin'; title='A SLA@SOI specific compute'; location=/compute; attributes='eu.sla-at-soi.image-identifier eu.sla-at-soi.physical-host'\n"+
			"Category: ipnetwork; scheme='http://schemas.ogf.org/occi/infrastructure/network#'; class='mixin'; title='An IP Networking Mixin'; location=/network; attributes='occi.network.address occi.network.gateway occi.network.allocation'\n"+
			"Category: ipnetworkinterface; scheme='http://schemas.ogf.org/occi/infrastructure/networkinterface#'; class='mixin'; title='An IP Network Interface Mixin'; location=/link; attributes='occi.networkinterface.address occi.networkinterface.gateway occi.networkinterface.allocation'\n"+
			"Category: os_tpl; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='mixin'; title='An OS Template Mixin'; location=/os_tpls\n"+
			"Category: resource_tpl; scheme='http://schemas.ogf.org/occi/infrastructure#'; class='mixin'; title='A Resource Template Mixin'; location=/resource_tpls\n";

	public static void main(String[] args) {

		//parse links
		HashMap res;
		try {
			res = OcciParser.getParser(listing).headers();
			System.out.println("No errors on parsing results from query interface.");
			System.out.println("Result: " + res.toString() + "\n");
		} catch (Exception e2) {
			e2.printStackTrace();
			System.exit(0);
		}
	}
}
