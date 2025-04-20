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
  
(
// PSV restrictions are unlikely in the UK, should be:
// bus=* | bus=* + taxi=*
way.roads
	[highway]
  	[psv]
  	[!"source:psv"];
);

(._;>;);
out meta qt;
