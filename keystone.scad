
keystone_face_protrusion = 2.0; //Desired amount of socket to protrude from plate face
keystone_block_structural_border = 2.8;
keystone_block_mount_border_w = 2.2-0.3;
keystone_block_mount_depth = 2.2;

keystone_rj45_opening_w = 14.55; //Face width
keystone_rj45_opening_h = 16.2+0.6; //Face height
keystone_rj45_clipledge_depth = 8.24; //Depth from face to clipped ledge
keystone_rj45_topclip_h = 3.50; //Distance from the clip surface to the top of the plug
keystone_rj45_bottomclip_h = 0.5; //Distance from the clip surface to the top of the plug
keystone_rj45_topclip_overhang = 3.1; //How much the notch sticks up from the clip
keystone_rj45_bottomclip_overhang = 1.5;
keystone_rj45_clip_depth = 1.65; //Distance from jack body to clipping surface
keystone_rj45_entire_depth = 30.0;

keystone_rj45_clipledge_arrow_depth = 3.0; //Depth difference between start and end of clipping

keystone_rj45_module_w = 2*keystone_block_structural_border+keystone_rj45_opening_w;
keystone_rj45_module_h = 2*keystone_block_structural_border+keystone_rj45_opening_h+keystone_rj45_bottomclip_overhang+keystone_rj45_topclip_overhang+keystone_rj45_topclip_h+keystone_rj45_bottomclip_h;
keystone_rj45_module_depth = keystone_rj45_clipledge_depth + keystone_rj45_clip_depth - keystone_face_protrusion;

//echo(str("keystone_rj45_module_w: ",keystone_rj45_module_w));
//echo(str("keystone_rj45_module_h: ",keystone_rj45_module_h));

module keystonerj45()
{
       
    difference()
    {
        union()
        {
        translate()
        cube([keystone_rj45_module_w,keystone_rj45_module_h,keystone_rj45_module_depth],center=true);

        translate([0,0,-keystone_block_mount_depth/2])
        cube([keystone_rj45_module_w+keystone_block_mount_border_w*2,keystone_rj45_module_h,keystone_rj45_module_depth-keystone_block_mount_depth],center=true);
        }

    translate([0,0,-keystone_rj45_entire_depth/2+keystone_rj45_module_depth/2+keystone_face_protrusion])

    union()
    {
        //Main body
        cube([keystone_rj45_opening_w,keystone_rj45_opening_h,keystone_rj45_entire_depth],center=true);

        //Bottom clip
        translate([0,0.5-keystone_rj45_opening_h/2-keystone_rj45_bottomclip_overhang/2-keystone_rj45_bottomclip_h,keystone_rj45_clipledge_arrow_depth/2+keystone_rj45_entire_depth/2-keystone_rj45_clipledge_depth])
        cube([keystone_rj45_opening_w,keystone_rj45_bottomclip_overhang+1,keystone_rj45_clipledge_arrow_depth],center=true);

        //Bottom clip allowance region
        translate([0,0.5-keystone_rj45_opening_h/2-keystone_rj45_bottomclip_overhang/2,-keystone_rj45_clipledge_depth+keystone_rj45_clipledge_arrow_depth])
        cube([keystone_rj45_opening_w,keystone_rj45_bottomclip_h,keystone_rj45_entire_depth],center=true);

        //Top clip
        translate([0,-0.5+keystone_rj45_opening_h/2+keystone_rj45_topclip_overhang/2+keystone_rj45_topclip_h,keystone_rj45_clipledge_arrow_depth/2+keystone_rj45_entire_depth/2-keystone_rj45_clipledge_depth])
        cube([keystone_rj45_opening_w,keystone_rj45_topclip_overhang+1,keystone_rj45_clipledge_arrow_depth],center=true);

        //Top clip allowance region
        translate([0,-0.5+keystone_rj45_opening_h/2+keystone_rj45_topclip_overhang/2,-keystone_rj45_clipledge_depth+keystone_rj45_clipledge_arrow_depth])
        cube([keystone_rj45_opening_w,keystone_rj45_topclip_h,keystone_rj45_entire_depth],center=true);
    }

    }

}

