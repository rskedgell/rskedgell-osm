area[admin_level=5][name="Greater London"]->.search_area;

(
node
  [highway=crossing]
  [crossing=marked]
  [button_operated=yes]
  (area.search_area);

node
  [highway=crossing]
  [crossing=marked]
  [crossing_ref=pelican]
  (area.search_area);

node
  [highway=crossing]
  [crossing=marked]
  [crossing_ref=puffin]
  (area.search_area);

node
  [highway=crossing]
  [crossing=marked]
  [crossing_ref=toucan]
  (area.search_area);

node
  [highway=crossing]
  [crossing=marked]
  [crossing_ref=pegasus]
  (area.search_area);

node
  [highway=crossing]
  [crossing=marked]
  ["crossing:signals"=yes]
  (area.search_area);
  
/* pedestrian-only crossings don't use dashes */
node
  [highway=crossing]
  ["crossing:markings"=dashes]
  [!bicycle]
  (area.search_area);

/* should be traffic_signals_countdown=yes */
node
  [highway=crossing]
  [crossing_ref=countdown]
  (area.search_area);

/* has a fixme tag */
//node
//  [highway=crossing]
//  [fixme]
//  (area.search_area);

)->.crossing_nodes_raw;

(
node(id:3729863986); // Ally Pally
) -> .ignore;

(.crossing_nodes_raw; - .ignore;) -> .crossing_nodes;

(.crossing_nodes <;) -> .crossing_node_parents;

(
way
    [highway]
        [crossing]
        .crossing_node_parents;
) -> .crossing_ways;

(.crossing_nodes;.crossing_ways;);

(._;>;);
out meta qt;

