// Roads QA for public roads in Greater London
area["name"="Greater London"][admin_level=5]->.search;

// TLRN "trunk" roads, plus A and B roads
(
way
	[highway~"^(trunk|primary|secondary)(_link)?$"]
	(area.search);
) -> .classified_roads;

// tertiary roads and busways
(
way
	[highway~"^tertiary(_link)?$"]
	(area.search);

way
	[highway=busway]
	(area.search);
) -> .other_main_roads;

(.classified_roads; .other_main_roads; ) -> .main_roads;

// public minor roads
(
way
  	[highway~"^(unclassified|residential|living_street)$"]
	[access!=private]
	[ownership!=private]
	["operator:type"!=private]
  	(area.search);

way
  	[highway~"^(pedestrian|service)$"]
	[area!=yes]
	[access!=private]
	[ownership!=private]
	["operator:type"!=private]
  	(area.search);
) -> .minor_roads;

(.main_roads; .minor_roads;) -> .roads;

// footways and cycleways tagged as crossings
(
way
  	[highway=footway]
  	[footway=crossing]
  	(area.search);

way
  	[highway=cycleway]
  	[cycleway=crossing]
  	(area.search);
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
// also check for maxweight:hgv and maxweight:goods, which
// should also be maxweightrating:* (and goods applies ≤ 3.5t)
way.roads
	[~"^maxweight(:goods|:hgv)?(:backward|:forward)?$"~".*"]
	[!"source:maxweight"];

// Obsolete tags from the abandoned 2013 Gross Weight proposal
// https://wiki.openstreetmap.org/wiki/Proposal:Gross_weight
way.roads
	[~"^max(actual|gc)weight.*$"~".*"];

// hgv=designated used on the London Lorry Control Scheme (LLCS)
// Excluded Route Network (ERN)
way.main_roads
	["hgv"]
	["hgv"!="designated"]
	[!"source:hgv"];

way.main_roads
	["hgv:forward"]
	["hgv:forward"!="designated"]
	[!"source:hgv"];

way.main_roads
	["hgv:backward"]
	["hgv:backward"!="designated"]
	[!"source:hgv"];

// hgv=* other than hgv=discouraged is often a misinterpretation
// of TSRGD 622.1A HGV weight restriction signs
way.minor_roads
	["hgv"]
	["hgv"!="discouraged"]
	[!"source:hgv"];

way.minor_roads
	["hgv:forward"]
	["hgv:forward"!="discouraged"]
	[!"source:hgv"];

way.minor_roads
	["hgv:backward"]
	["hgv:backward"!="discouraged"]
	[!"source:hgv"];

// Designated PSV access is unlikely in the UK although restrictions exist,
// should be bus=* | bus=* + taxi=*
way.roads
	[~"^psv(:backward|:forward)?$"~"^(yes|designated)$"]
	[!"source:psv"];

// motor_vehicle=designated usually an error or redundant
// should be bus=* | bus=* + taxi=*
// redundant use or trunk/expressway/motorroad ignored
way.roads
	[motor_vehicle=designated]
	[highway!=trunk]
	[highway!=trunk_link]
	[expressway!=yes]
	[motorroad!=yes]
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

// crossing tags which are meaningless on crossing ways
way.crossing_ways
	[button_operated];

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

// pedestrian prohibitions are quite rare and must be signed
way.roads
	[foot=no]
	[motorroad!=yes]
	[expressway!=yes]
	[!tunnel]
	[tunnel!=building_passage]
	[!"source:foot"];

// pedestrian prohbition usually incompatible with sidewalk=$side
way.roads
	[foot=no]
	[sidewalk~"^(both|left|right)$"];

// unusual or less specific values of sidewalk=*
way.roads
	["sidewalk"]
	["sidewalk"!="both"]
	["sidewalk"!="lane"]
	["sidewalk"!="left"]
	["sidewalk"!="no"]
	["sidewalk"!="right"];
way.roads
	["sidewalk:both"]
	["sidewalk:both"!="lane"]
	["sidewalk:both"!="no"]
	["sidewalk:both"!="separate"]
	["sidewalk:both"!="yes"];
way.roads
	["sidewalk:left"]
	["sidewalk:left"!="lane"]
	["sidewalk:left"!="no"]
	["sidewalk:left"!="separate"]
	["sidewalk:left"!="yes"];
way.roads
	["sidewalk:right"]
	["sidewalk:right"!="lane"]
	["sidewalk:right"!="no"]
	["sidewalk:right"!="separate"]
	["sidewalk:right"!="yes"];

// cycleway=share_busway without bus:lanes=* and bicycle:lanes=*
way.roads
	[~"^cycleway(:both)?$"~"^share_busway$"]
	[!"bus:lanes:forward"]
	[!"bicycle:lanes:forward"]
	[!"bus:lanes:backward"]
	[!"bicycle:lanes:backward"];
way.roads
	["cycleway:left"="share_busway"]
	[!"bus:lanes:forward"]
	[!"bicycle:lanes:forward"];
way.roads
	["cycleway:right"="share_busway"]
	[!"bus:lanes:backward"]
	[!"bicycle:lanes:backward"];

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
