use <helpers.scad>
//bltouch();

BLTOUCH_UNEXTENDED_HEIGHT = 42.04;
BLTOUCH_EXTENDED_HEIGHT = 46.04;

blt_z_oal = 36.31;
blt_z_top = 2.31;
blt_z_topring = 10.25-2.31;
blt_z_taperfromtop = 31.84;
blt_topring_d = 11.7;
blt_bottomring_d = 13.12;//12.84;

//blt_topspan = 26.19

module bltouch(extended=false, $fn=25)
{
  //Connector
    color([0.8,0.8,0.6])
    cube_extent(
        -11.34/2,11.34/2,
        blt_bottomring_d/2,blt_bottomring_d/2+3.54,
        -23.5,-18
        );
    
    color([0.4,0.4,0.4])
    {
        //Top plate
        difference()
        {
            hull()
            {
              cube_extent(
                -6.5/2,6.5/2,
                -blt_topring_d/2,blt_topring_d/2,
                0,-blt_z_top
                );
                
              for (i=[0,1]) mirror([i,0,0])
              translate([26.14/2-4,0,-blt_z_top])
              cylinder(d=8,h=blt_z_top);
            }
            //translate([0,0,-blt_z_top/2])
            //cube([26,11.53,blt_z_top],center=true);
            
            //Screws
            translate([9,0,-3])
            cylinder(d=3.15,h=4,$fn=$fn/2);
            
            translate([-9,0,-3])
            cylinder(d=3.15,h=4,$fn=$fn/2);
        }

        //Top cylinder
        translate([0,0,-blt_z_topring-blt_z_top])
        cylinder(d=blt_topring_d,h=blt_z_topring);
        
        //Bottom cylinder
        intersection()
        {
          union()
          {
            translate([0,0,-(blt_z_oal-blt_z_topring-blt_z_top)-blt_z_top-blt_z_topring])
            cylinder(d=blt_bottomring_d,h=blt_z_oal-blt_z_topring-blt_z_top);
            
            cube_extent(
              blt_bottomring_d/2,-blt_bottomring_d/2,
              0,blt_bottomring_d/2,
              -blt_z_top-blt_z_topring,-blt_z_oal
              );
          }
          
          union()
          {
            translate([0,0,-(blt_z_taperfromtop-(blt_z_top+blt_z_topring))  - (blt_z_top+blt_z_topring)])
            cylinder(d=blt_bottomring_d,h=blt_z_taperfromtop-(blt_z_top+blt_z_topring));
            
            cube_extent(
              blt_bottomring_d/2,-blt_bottomring_d/2,
              0,blt_bottomring_d/2,
              -blt_z_top-blt_z_topring,-blt_z_taperfromtop
              );
              
            translate([0,0,-blt_z_oal])
            cylinder(d2=sqrt(2)*blt_bottomring_d,d1=7.22,h=blt_z_oal-blt_z_taperfromtop);
          }
        }
        
    }
    
    //Pin
    color([0.7,0.7,0.7])
    if (extended)
    {
        translate([0,0,-BLTOUCH_EXTENDED_HEIGHT])
        cylinder(d=1.78,h=13,$fn=$fn/2);
    }
    else
    {
        translate([0,0,-BLTOUCH_UNEXTENDED_HEIGHT])
        cylinder(d=1.78,h=8,$fn=$fn/2);
    }
}
