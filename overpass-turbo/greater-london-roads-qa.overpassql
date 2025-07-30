// Roads QA for public roads in Greater London
area["name"="Greater London"][admin_level=5]->.gla;

// TLRN "trunk" roads, plus A and B roads
(
way
	[highway~"^(trunk|primary|secondary)(_link)?$"]
	(area.gla);
) -> .classified_roads;

// tertiary roads and busways
(
way
	[highway~"^tertiary(_link)?$"]
	(area.gla);

way
	[highway=busway]
	(area.gla);
) -> .other_main_roads;

(.classified_roads; .other_main_roads; ) -> .main_roads;

// public minor roads
(
way
  	[highway~"^(unclassified|residential|living_street)$"]
	[access!=private]
	[ownership!=private]
	["operator:type"!=private]
  	(area.gla);

way
  	[highway~"^(pedestrian|service)$"]
	[area!=yes]
	[access!=private]
	[ownership!=private]
	["operator:type"!=private]
  	(area.gla);
) -> .minor_roads;

(.main_roads; .minor_roads;) -> .roads;

// footways and cycleways tagged as crossings
(
way
  	[highway=footway]
  	[footway=crossing]
  	(area.gla);

way
  	[highway=cycleway]
  	[cycleway=crossing]
  	(area.gla);
) -> .all_crossing_ways;

// crossing nodes where crossing ways intersect public roads
(
node
  	[highway=crossing]
  	(w.roads)
  	(w.all_crossing_ways);
) -> .crossing_nodes;

// crossing ways intersecting public roads
(
way
  	[crossing]
  	(bn.crossing_nodes);
) -> .crossing_ways;
  
(

// maxweight=* is usually wrong, should be maxweightrating=* or maxweightrating:hgv=*
way.roads
  	[maxweight]
  	[!"source:maxweight"];

// Obsolete tags from the abandoned 2013 Gross Weight proposal
// https://wiki.openstreetmap.org/wiki/Proposal:Gross_weight
way.roads
	[~"^max(actual|gc)weight.*$"~".*"];

// hgv=designated used on the London Lorry Control Scheme (LLCS)
// Excluded Route Network (ERN)
way.main_roads
	[hgv]
	[hgv!=designated]
	[!"source:hgv"];

// hgv=* other than hgv=discouraged is often a misinterpretation
// of TSRGD 622.1A HGV weight restriction signs
way.minor_roads
	[hgv]
	[hgv!=discouraged]
	[!"source:hgv"];

// Designated PSV access is unlikely in the UK although restrictions exist,
// should be bus=* | bus=* + taxi=*
way.roads
  	[psv~"^(yes|designated)$"]
  	[!"source:psv"];

// motor_vehicle=designated usually an error or redundant
// should be bus=* | bus=* + taxi=*
way.roads
  	[motor_vehicle=designated]
  	[!"source:motor_vehicle"];

// access=bus is undefined, probably bus=yes
way.roads
  	[access=bus];

// bus=access is undefined, probably bus=destination
way.roads
  	[bus=access];

// useless crossing:markings=yes
//node.crossing_nodes
//  	["crossing:markings"=yes];

// deprecated crossing=zebra
//node.crossing_nodes
//  	[crossing=zebra];
//way.crossing_ways
//	[crossing=zebra];

// incorrect crossing:markings=dashes on pedestrian (only) crossings
node.crossing_nodes
  	["crossing:markings"=dashes]
	[bicycle!=designated]
	[bicycle!=yes];

// incorrect tactile_paving on crossing way
way.crossing_ways
	[tactile_paving];
  
// crossings with bicycle allowed and incomptible crossing_ref
node.crossing_nodes
	[bicycle~"^(yes|designated)$"]
	[crossing_ref~"^(pelican|puffin)$"];
way.crossing_ways
	[bicycle~"^(yes|designated)$"]
	[crossing_ref~"^(pelican|puffin)$"];

// unusual speed limits for public highways
way.roads
	[highway!=pedestrian]
	[highway!=service]
	[maxspeed]
	[maxspeed!~"^(20|30|40|50|60|70) mph$"]
	[!"source:maxspeed"]
	[!"maxspeed:type"];

// there's no such thing as a compulsory footpath on UK public highways
way.roads
	[foot=use_sidepath];
  
// fixme
node.crossing_nodes
	[fixme];
way.crossing_ways
	[fixme];
//way.roads
//	[fixme];

);

(._;>;);
out meta qt;
