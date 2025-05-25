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
	[ownership!=private]
	["operator:type"!=private]
  	(area.gla);

  way
  	[highway~"^(pedestrian|service)$"]
	[area!=yes]
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
// PSV restrictions are unlikely in the UK, should be:
// bus=* | bus=* + taxi=*
way.roads
	[highway]
  	[psv]
  	[!"source:psv"];

// access=bus is undefined, probably bus=yes
way.roads
	[highway]
  	[access=bus];

// bus=access is undefined, probably bus=destination
way.roads
	[highway]
  	[bus=access];

// useless crossing:markings=yes
//node.crossing_nodes
//  	["crossing:markings"=yes];

// deprecated crossing=zebra
node.crossing_nodes
  	[crossing=zebra];
way.crossing_ways
	[crossing=zebra];

// incorrect crossing:markings=dashes
node.crossing_nodes
  	["crossing:markings"=dashes];

// incorrect tactile_paving on crossing way
way.crossing_ways
	[tactile_paving];

);

(._;>;);
out meta qt;
