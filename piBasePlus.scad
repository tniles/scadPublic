// Parameters
base_length = 203; // mm        203mm==7.99in
base_width = 254;  // mm        254mm==10.0in
base_thickness = 13; // mm
cell_size = 20;    // mm
cell_wall = 2;     // mm
rim = 12;           // mm solid rim around the edge

hole_diameter = 6;      // mm, diameter of horizontal holes
hole_spacing_y = 35;    // mm, spacing between holes along Y

// Calculate honeycomb grid bounds
x_start = rim;
x_end = base_length - rim;
y_start = rim;
y_end = base_width - rim;
x_span = x_end - x_start;
y_span = y_end - y_start;

// Calculate honeycomb grid size
x_count = floor((x_span) / cell_size) + 1;
y_count = floor((y_span) / (cell_size * sqrt(3)/2)) + 1;

// Calculate mesh width, accounting for odd row offset
x_mesh_width = (x_count - 1) * cell_size + cell_size / 2;
y_mesh_height = (y_count - 1) * (cell_size * sqrt(3)/2);
x_offset = (base_length - x_mesh_width) / 2;
y_offset = (base_width - y_mesh_height) / 2;

// Honeycomb mesh generator (fully centered)
module honeycomb_mesh() {
    for (i = [0 : x_count - 1])
        for (j = [0 : y_count - 1])
            translate([
                x_offset + i * cell_size + (j % 2) * cell_size / 2,
                y_offset + j * cell_size * sqrt(3)/2,
                0
            ])
                cylinder(h=base_thickness, r=cell_size/2 - cell_wall, $fn=6);
}

// X-axis holes through the base, transverse to the honeycomb
module airflow_holes_x() {
    for (y = [hole_spacing_y/2 : hole_spacing_y : base_width - hole_spacing_y/2])
        translate([0, y, base_thickness/2])
            rotate([0,90,0])
                cylinder(h=base_length + 5, r=hole_diameter/2, $fn=32);
}

// The base with mesh and X-axis horizontal holes
difference() {
    // Main base
    cube([base_length, base_width, base_thickness]);
    // Centered honeycomb mesh cutout
    honeycomb_mesh();
    // X-axis airflow holes
    airflow_holes_x();
}
