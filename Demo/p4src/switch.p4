/* Copyright 2017 FuZhou University SDNLab, Edu. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */

/*
	Easy Demo: 1sw2host

	h1(IP: 10.0.0.1) <---> s1 <---> h2(IP: 10.0.0.2)
 */

/* switch.p4 */

/* header */

header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;

/* Parser */

parser start {
    return parse_ethernet;
}

parser parse_ethernet {
    extract(ethernet);
    return ingress;
}

/* Action */

action _drop() {
    drop();
}

action _nop() {
}

action pkt_action() {
	count(pkt_cnt, 0); // count the packets
	drop();
}

/* packet counter */

counter pkt_cnt {
	type : packets;
	static : pkt_table;
	instance_count : 10;
}

/* Table */

table pkt_table {
	// TODO: add your fields
	// and match method
	actions {_nop; _drop; pkt_action;}
}

/* Control Program */

control ingress {
	apply(pkt_table);
}

control egress {
	// leave empty
}
