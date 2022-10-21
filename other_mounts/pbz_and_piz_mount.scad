use <../helpers.scad>

radial_clearance = 0.2;
diametric_clearance = radial_clearance*2;

plate = 2.5;
sideplate = 4.5;
rampplate = 2;
fanedgeplate = 2;

psu_length = 65.5;
psu_width = 30.5;

screwsep_short = 23.0;
screwsep_long = 58.0;

//sidescrewsep_short = screwsep_short-18;
sidescrewsep_long = screwsep_long-14;

extrusion_size = 20;

tht_relief_x1 = psu_length/2-44;
tht_relief_x2 = psu_length/2-58.6;
tht_relief_y1 = -psu_width/2+0;
tht_relief_y2 = -psu_width/2+6.5;

fan_size = 30;
fan_airhole_d = 29.0 + diametric_clearance;
fan_screwsep = 24;
fan_screwhole_d = 4.4 + diametric_clearance;
fan_xoffset = 22.7;
fan_zoffset = 0;
fan_center_x = -psu_length/2 + fan_xoffset + fan_size/2;
fan_center_z = -fan_zoffset -fan_size/2;
//fan_thickness = 

rotate([90,0,0]) // <------ PRINT
mount();

module mount()
{
  difference()
  {
      union()
      {
          translate([0,0,plate/2])
          cube([psu_length+2*rampplate,psu_width,plate],center=true);
          
          //translate([-psu_length/2,-psu_width/2,plate])
          //cube([sideplate,psu_width,extrusion_size]);
          
          translate([-psu_length/2-rampplate,-psu_width/2-sideplate,0])
          cube([psu_length+2*rampplate,sideplate,extrusion_size+plate]);
          
          for(ii=[0,1])
          mirror([ii,0,0])
          translate([-rampplate/2-psu_length/2,-sideplate/2,0])
          rotate([0,0,-90])
          ramp(psu_width+sideplate,rampplate,0,extrusion_size+plate);
          
          //Fan mount plate
          cube_extent(
            fan_center_x-fan_size/2-fanedgeplate,fan_center_x+fan_size/2+fanedgeplate,
            -psu_width/2,-psu_width/2-sideplate,
            //0,-50
            0,fan_center_z-fan_size/2-fanedgeplate
            );
      }
      
      //Screw holes for fan
      translate([fan_center_x,-1-sideplate-psu_width/2,fan_center_z])
      rotate([-90,0,0])
      union()
      {
        for (xxx=[-1,1])
        for (yyy=[-1,1])
        translate([xxx*fan_screwsep/2,yyy*fan_screwsep/2,0])
        cylinder(d=fan_screwhole_d,h=2+sideplate,$fn=32);
        
        cylinder(d=fan_airhole_d,h=2+sideplate,$fn=100);
      }
      
      //THT relief hole
      cube_extent(
        tht_relief_x1,tht_relief_x2,
        tht_relief_y1,tht_relief_y2,
        -1,plate+1
        );
      
      //Side screws
      //for (ii=[-1,1])
      //translate([-1-psu_length/2,ii*sidescrewsep_short/2,plate+extrusion_size/2])
      //rotate([0,90,0])
      //cylinder(d=5.3,h=sideplate+2,$fn=50);
      
      for (ii=[-1,1])
      translate([ii*sidescrewsep_long/2,-1-psu_width/2-sideplate,plate+extrusion_size/2])
      rotate([-90,0,0])
      cylinder(d=5.3,h=2*sideplate+2,$fn=50);
      
      
      //PSU screws
      for (xx=[-1,1])
      for (yy=[-1,1])
      translate([xx*screwsep_long/2,yy*screwsep_short/2,0])
      {
          translate([0,0,-1])
          //cylinder(d=2.6+diametric_clearance,h=plate+extrusion_size+2,$fn=50);
          mteardrop(d=2.6+diametric_clearance,h=plate+extrusion_size+2,$fn=50);
          
          translate([0,0,plate])
          cylinder(d=7.0+diametric_clearance,h=plate+extrusion_size+2,$fn=50);
      }
      
      /*
      //Bottom reliefs
      tri_start_x = screwsep_long/2-5;
      tri_start_y = screwsep_short/2-5-5;
      translate([0,0,-1])
      linear_extrude(h=plate+extrusion_size+2)
      polygon(points=[[-tri_start_x,-tri_start_y],[-5,0],[-tri_start_x,tri_start_y]],convexity=1);
      
      mirror([1,0,0])
      translate([0,0,-1])
      linear_extrude(h=plate+extrusion_size+2)
      polygon(points=[[-tri_start_x,-tri_start_y],[-5,0],[-tri_start_x,tri_start_y]],convexity=1);
      
      translate([0,0,-1])
      linear_extrude(h=plate+extrusion_size+2)
      polygon(points=[[-tri_start_x+5,-tri_start_y-5],[0,-5],[tri_start_x-5,-tri_start_y-5]],convexity=1);
      
      mirror([0,1,0])
      translate([0,0,-1])
      linear_extrude(h=plate+extrusion_size+2)
      polygon(points=[[-tri_start_x+5,-tri_start_y-5],[0,-5],[tri_start_x-5,-tri_start_y-5]],convexity=1);
      */
  }
}
