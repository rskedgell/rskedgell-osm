// Venues with live_music=yes set in the UK
area["name"="United Kingdom"][admin_level=2]->.uk;

(
  nwr
  	[amenity=pub]
  	[live_music=yes]
  	(area.uk);

  nwr
  	[amenity=nightclub]
  	[live_music=yes]
  	(area.uk);

  nwr
  	[amenity=bar]
  	[live_music=yes]
  	(area.uk);

  nwr
  	[amenity=cafe]
  	[live_music=yes]
  	(area.uk);

  nwr
  	[amenity=arts_centre]
  	[live_music=yes]
  	(area.uk);

  nwr
  	[amenity=events_venue]
  	[live_music=yes]
  	(area.uk);
);

(._;>;);
out meta qt;
