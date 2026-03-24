// Find cycle-specific barriers ion the current view

(
  nwr
  	[barrier=bollard]
  	[bicycle!=no]
  	({{bbox}});

  nwr
  	[barrier=cycle_barrier]
  	[bicycle!=no]
  	({{bbox}});

  nwr
  	[barrier]
  	[bicycle~"^(designated|yes|permissive|customers)$"]
  	({{bbox}});
);

(._;>;);

out meta qt;

{{style:

/* default to hidden */
node, way, relation {
  opacity: 0;
  fill-opacity: 0;
}

/* make barriers visible */
node, way, relation {
  opacity: 1;
  fill-opacity: 0.25;
}

/* maxwidth:physical < 1.2 metres */
node, way, relation[maxwidth:physical<1.2] {
  color: red;
  fill-color: red;
}

/* maxwidth:physical ≥ 1.2 metres */
node, way, relation[maxwidth:physical>=1.2] {
  color: green;
  fill-color: green;
}

/* maxwidth:physical not set */
node, way, relation[!maxwidth:physical] {
  color: gray;
  fill-color: gray;
}

}}
