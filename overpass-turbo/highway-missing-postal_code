/*
Find streets within an administrative area without a postal_code.
https://wiki.openstreetmap.org/wiki/Key:postal_code
*/
area[admin_level=6][name="City of London"]->.admin_area;

(
/*
Named streets without a postal_code.
Motorroads and expressways are excluded as not meaningfully addressable.
*/
way[highway~"^(trunk|trunk_link|primary|primary_link|secondary|secondary_link|tertiary|tertiary_link|unclassified|residential|living_street)$"]
  [name]
  [motorroad!=yes]
  [expressway!=yes]
  [!postal_code]
  [!"postal_code:left"]
  [!"postal_code:right"]
  (area.admin_area);

/* Pedestrian roads, but not areas (many of which are mis-tagged). */
way
  [highway=pedestrian]
  [area!=yes]
  [name]
  [!postal_code]
  (area.admin_area);

/* Named highways with a USRN (includes addressable residential footways) */
way
  [highway]
  [name]
  ["ref:GB:usrn"]
  [!postal_code]
  [!"postal_code:left"]
  [!"postal_code:right"]
  (area.admin_area);
);

(._;>;);
out meta qt;
