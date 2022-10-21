
module debug(modulename, msg)
{
  //rmod = (modulename=="") ? parent_module(1) : modulename;
  echo(str("[",modulename,"] ",msg));
}

function smooth_curve(a) =
let (b = clamp(a))(b * b * (3 - 2 * b));
function clamp(a, b = 0, c = 1) = min(max(a, b), c);
function gauss(x) =  
     x + (x - smooth_curve(x));
function lerp(start, end, bias) = (end * bias + start * (1 - bias));

function magnitude_xy(pt) = sqrt(pt[0]*pt[0]+pt[1]*pt[1]);
function angle_of_point_xy(pt) = atan2(pt[1],pt[0]);
function rotate_point_xy(pt, angle) =
    [
      magnitude_xy(pt)*cos(angle_of_point_xy(pt)+angle),
      magnitude_xy(pt)*sin(angle_of_point_xy(pt)+angle)
    ];

module move_and_look_at_planar(position,looktarg)
{
  v = [position[0]-looktarg[0],position[1]-looktarg[1]];
  length = norm([v.x,v.y]);
  c = atan2(v.y,v.x);
  
  translate(position)
  rotate([0, 0, c])
  children();
}

module move_and_look_at_3d(position,looktarg)
{
  v = [position[0]-looktarg[0],position[1]-looktarg[1],position[2]-looktarg[2]];
  length = norm([v.x,v.y,v.z]);
  b = acos(v.z/length);
  c = atan2(v.y,v.x);
  
  translate(position)
  rotate([0, b, c])
  rotate([180,0,0])
  children();
}

module mesh_squares(xsize, ysize, height, boxsize = 10, boxborder = 0.8)
{
    boxcountx = xsize/boxsize;
    boxcounty = ysize/boxsize;
    for (xx=[-boxcountx/2:boxcountx/2])
    for (yy=[-boxcounty/2:boxcounty/2])
    translate([xx*boxsize,yy*boxsize,height/2])
    cube([boxsize-boxborder,boxsize-boxborder,height],center=true);
}

module mesh_hex(xsize, ysize, height, boxsize = 10, boxborder = 0.8, hrotation = 0)
{
    //cornerdiameter =  2*((boxsize / 2) / cos (180 / 6));
  
    boxcountx = ceil((xsize/boxsize)/(cos(180/6)));
    boxcounty = ysize/boxsize;
    
    for (xx=[-boxcountx/2:2:boxcountx/2])
    for (yy=[-boxcounty/2:boxcounty/2])
    translate([xx*boxsize*(cos(180/6)),yy*boxsize,0])
    rotate([0,0,hrotation])
    cylinder(d=2*(((boxsize-boxborder) / 2) / cos (180 / 6)),h=height,$fn=6);
    
    for (xx=[-boxcountx/2+1:2:boxcountx/2+1])
    for (yy=[-boxcounty/2:boxcounty/2+1])
    translate([xx*boxsize*(cos(180/6)),yy*boxsize-boxsize/2,0])
    rotate([0,0,hrotation])
    cylinder(d=2*(((boxsize-boxborder) / 2) / cos (180 / 6)),h=height,$fn=6);
    
}

module ring(od, id, h)
{
  difference()
  {
    cylinder(d=od,h=h);
    
    translate([0,0,-1])
    cylinder(d=id,h=h+2);
  }
}

module mteardrop(d,h,center=false,angle=45)
{
  union()
  {
    cylinder(d=d,h=h,center=center);
    
    r=d/2;
    //ytangent = r/sqrt(2);
    ytangent = r*cos(angle);
    linear_extrude(height=h,center=center)
    {
      polygon(points=[
      [0,ytangent + (r*sin(angle))*tan(angle)],
      [r*sin(angle),ytangent],
      [-r*sin(angle),ytangent]
      ]);
    }
  }
}

/*
module cube_extent(x1,x2,y1,y2,z1,z2)
{
  xmax=max(x1,x2);
  xmin=min(x1,x2);
  ymax=max(y1,y2);
  ymin=min(y1,y2);
  zmax=max(z1,z2);
  zmin=min(z1,z2);
  
  translate([xmin,ymin,zmin])
  cube([xmax-xmin,ymax-ymin,zmax-zmin]);
}
*/

module edge_rounding(length,radius,ffn=20)
{
  qwer = 0.11;
  qwer2 = 0.17;
  
  //echo(str("ffn=",ffn));
  
  translate([-radius,-radius,0])
  difference()
  {
    translate([0.01,0.01,0])
    cube([radius+qwer2,radius+qwer2,length]);
    
    translate([0,0,-qwer])
    rotate([0,0,90])
    cylinder_sector(d=2*radius,angle=90,h=length+2*qwer,$fn=ffn);
  }
}

module corner_rounding_inner110(radius,ffn=20)
{
  qwer = 0.12;
  qwer2 = 0.18;
  
  difference()
  {
    translate([-radius,-radius,-radius])
    cube([radius+qwer,radius+qwer,radius+qwer]);
    
    translate([-radius-qwer,-radius,-radius])
    rotate([0,90,0])
    rotate([0,0,180])
    cylinder_sector(d=2*radius,angle=90,h=2*qwer+qwer2+radius,$fn=ffn);
    
    translate([-radius,qwer,-radius])
    rotate([90,0,0])
    rotate([0,0,90])
    cylinder_sector(d=2*radius,angle=90,h=2*qwer+qwer2+radius,$fn=ffn);
  }
}

module corner_rounding(radius,ffn=20)
{
  qwer = 0.13;
  qwer2 = 0.19;
  
  translate([-radius,-radius,-radius])
  difference()
  {
    translate([0.01,0.01,0])
    cube([radius+qwer2,radius+qwer2,radius+qwer2]);
    
    sphere(r=radius,$fn=ffn);
    //translate([0,0,-qwer])
    //rotate([0,0,90])
    //cylinder_sector(d=2*radius,angle=90,h=length+2*qwer,$fn=ffn);
  }
}

module cube_extent(x1,x2,y1,y2,z1,z2,
                    roundededges,
                    roundedcorners,
                    radius=1,
                    $fn=20
                    )
{
  xmax=max(x1,x2);
  xmin=min(x1,x2);
  ymax=max(y1,y2);
  ymin=min(y1,y2);
  zmax=max(z1,z2);
  zmin=min(z1,z2);
  
  difference()
  {
    translate([xmin,ymin,zmin])
    cube([xmax-xmin,ymax-ymin,zmax-zmin]);
    
    for (uu=roundedcorners)
    {
      if ((uu[0]==-1)&&(uu[1]==-1)&&(uu[2]==-1))
        translate([xmin,ymin,zmin])
        rotate([0,0,-90])
        rotate([180,0,0])
        corner_rounding(radius=radius,ffn=$fn);
      else if ((uu[0]==1)&&(uu[1]==-1)&&(uu[2]==-1))
        translate([xmax,ymin,zmin])
        rotate([0,0,0])
        rotate([180,0,0])
        corner_rounding(radius=radius,ffn=$fn);
      else if ((uu[0]==-1)&&(uu[1]==1)&&(uu[2]==-1))
        translate([xmin,ymax,zmin])
        rotate([0,0,180])
        rotate([180,0,0])
        corner_rounding(radius=radius,ffn=$fn);
      else if ((uu[0]==1)&&(uu[1]==1)&&(uu[2]==-1))
        translate([xmax,ymax,zmin])
        rotate([0,0,90])
        rotate([180,0,0])
        corner_rounding(radius=radius,ffn=$fn);
        
      else if ((uu[0]==-1)&&(uu[1]==-1)&&(uu[2]==1))
        translate([xmin,ymin,zmax])
        rotate([0,0,180])
        corner_rounding(radius=radius,ffn=$fn);
      else if ((uu[0]==1)&&(uu[1]==-1)&&(uu[2]==1))
        translate([xmax,ymin,zmax])
        rotate([0,0,-90])
        corner_rounding(radius=radius,ffn=$fn);
      else if ((uu[0]==-1)&&(uu[1]==1)&&(uu[2]==1))
        translate([xmin,ymax,zmax])
        rotate([0,0,90])
        corner_rounding(radius=radius,ffn=$fn);
      else if ((uu[0]==1)&&(uu[1]==1)&&(uu[2]==1))
        translate([xmax,ymax,zmax])
        rotate([0,0,0])
        corner_rounding(radius=radius,ffn=$fn);
    }
    
    for (uu=roundededges)
    {
      //Edges along X axis
      if ((uu[0]==0)&&(uu[1]==-1)&&(uu[2]==-1))
        translate([xmin-1,ymin,zmin])
        rotate([-90,0,0])
        rotate([0,90,0])
        edge_rounding(length=xmax-xmin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==0)&&(uu[1]==1)&&(uu[2]==-1))
        translate([xmin-1,ymax,zmin])
        rotate([0,90,0])
        edge_rounding(length=xmax-xmin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==0)&&(uu[1]==1)&&(uu[2]==1))
        translate([xmin-1,ymax,zmax])
        rotate([90,0,0])
        rotate([0,90,0])
        edge_rounding(length=xmax-xmin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==0)&&(uu[1]==-1)&&(uu[2]==1))
        translate([xmin-1,ymin,zmax])
        rotate([180,0,0])
        rotate([0,90,0])
        edge_rounding(length=xmax-xmin+2,radius=radius,ffn=$fn);
        
      //Edges along Y axis
      else if ((uu[0]==1)&&(uu[1]==0)&&(uu[2]==1))
        translate([xmax,ymax+1,zmax])
        rotate([0,90,0])
        rotate([90,0,0])
        rotate([0,0,90])
        edge_rounding(length=ymax-ymin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==-1)&&(uu[1]==0)&&(uu[2]==1))
        translate([xmin,ymax+1,zmax])
        rotate([0,0,0])
        rotate([90,0,0])
        rotate([0,0,90])
        edge_rounding(length=ymax-ymin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==1)&&(uu[1]==0)&&(uu[2]==-1))
        translate([xmax,ymax+1,zmin])
        rotate([0,180,0])
        rotate([90,0,0])
        rotate([0,0,90])
        edge_rounding(length=ymax-ymin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==-1)&&(uu[1]==0)&&(uu[2]==-1))
        translate([xmin,ymax+1,zmin])
        rotate([0,-90,0])
        rotate([90,0,0])
        rotate([0,0,90])
        edge_rounding(length=ymax-ymin+2,radius=radius,ffn=$fn);
        
      //Edges along Z axis
      else if ((uu[0]==1)&&(uu[1]==1)&&(uu[2]==0))
        translate([xmax,ymax,zmin-1])
        rotate([0,0,0])
        edge_rounding(length=zmax-zmin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==-1)&&(uu[1]==1)&&(uu[2]==0))
        translate([xmin,ymax,zmin-1])
        rotate([0,0,90])
        edge_rounding(length=zmax-zmin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==1)&&(uu[1]==-1)&&(uu[2]==0))
        translate([xmax,ymin,zmin-1])
        rotate([0,0,-90])
        edge_rounding(length=zmax-zmin+2,radius=radius,ffn=$fn);
      else if ((uu[0]==-1)&&(uu[1]==-1)&&(uu[2]==0))
        translate([xmin,ymin,zmin-1])
        rotate([0,0,180])
        edge_rounding(length=zmax-zmin+2,radius=radius,ffn=$fn);
    }
  }
}

module stretched_cylinder(d, h, stretch, center=false)
{
  if (center)
    stretched_cylinder_geom(d=d, h=h, stretch=stretch);
  else
    translate([0,0,h/2])
    stretched_cylinder_geom(d=d, h=h, stretch=stretch);
}

module stretched_cylinder_geom(d, h, stretch)
{
    union()
    {
        translate([stretch/2,0,0])
        cylinder(d=d,h=h,center=true);
        
        translate([-stretch/2,0,0])
        cylinder(d=d,h=h,center=true);
        
        cube([stretch,d,h],center=true);
    }
}

module stretched_cone(d1, d2, h, stretch, center=false)
{
  if (center)
    stretched_cone_geom(d1=d1, d2=d2, h=h, stretch=stretch);
  else
    translate([0,0,h/2])
    stretched_cone_geom(d1=d1, d2=d2, h=h, stretch=stretch);
}

module stretched_cone_geom(d1, d2, h, stretch)
{
    union()
    {
        translate([stretch/2,0,0])
        cylinder(d1=d1,d2=d2,h=h,center=true);
        
        translate([-stretch/2,0,0])
        cylinder(d1=d1,d2=d2,h=h,center=true);
        
        for (i=[0,1])
        mirror([0,i,0])
        rotate([90,0,0])
        rotate([0,0,90])
        ramp(h,stretch,d1/2,d2/2);
    }
}

module ramp(x,y,z1,z2,round1=false,round2=false,roundradius=2,ffn=20)
{
  /*
  echo(str("x=",x));
  echo(str("y=",y));
  echo(str("z1=",z1));
  echo(str("z2=",z2));
  */
  difference()
  {
    rotate([90,0,0])
    translate([0,0,-y/2])
    linear_extrude(height=y)
    {
        polygon(points=[[-x/2,0],[-x/2,z1],[x/2,z2],[x/2,0]]);
    }
    
    zneg = ((z1<0) || (z2<0)) ? 1 : 0;
    
    if (round1)
    move_and_look_at_3d([x/2,y/2,z2],[-x/2,y/2,z1])
    translate([0,0,-1])
    rotate([0,0,180])
    rotate([0,0,zneg*90])
    edge_rounding(length=2+sqrt(x*x+(z2-z1)*(z2-z1)),radius=roundradius,ffn=ffn);
    
    if (round2)
    move_and_look_at_3d([x/2,-y/2,z2],[-x/2,-y/2,z1])
    translate([0,0,-1])
    rotate([0,0,90])
    rotate([0,0,-zneg*90])
    edge_rounding(length=2+sqrt(x*x+(z2-z1)*(z2-z1)),radius=roundradius,ffn=ffn);
  }
}

function helpersstack(idx = $parent_modules - 1) =
        idx == undef
                ? "<top-level>"
                : idx > 0
                        ? str(parent_module(idx), "() : ", helpersstack(idx - 1))
                        : str(parent_module(idx), "()"); 

module cylinder_sector(d, angle, h, center=false, $fn=20, convexity=2)
{
    rr=d/2;
    steps = ($fn > 0) ?
        ceil($fn * angle / 360)
        :
        min(
          ceil(angle / $fa),
          ceil(PI * d * (angle / 360) / $fs)
        )
        ;
    stepsize = angle / steps;
    
    if (steps <= 0)
    {
      echo(str("ERROR: cylinder_sector STEPS = ", steps, ", d=",d,", angle=",angle,", h=",h,", $fn=",$fn));
      echo(str("ERROR STACK: ", helpersstack()));
    }
    
    //echo(str("steps=",steps));
    //echo(str("angle=",angle));
    //echo(str("$fn=",$fn));
    
    if (!center)
    linear_extrude(height=h,convexity=convexity)
    {
        for (i=[0:steps-1])
        polygon(points=[[0,0],[rr*cos(-i*stepsize),rr*sin(-i*stepsize)],[rr*cos(-(i+1)*stepsize),rr*sin(-(i+1)*stepsize)]]);
    }
    else
    translate([0,0,-h/2])
    linear_extrude(height=h,convexity=convexity)
    {
        for (i=[0:steps-1])
        polygon(points=[[0,0],[rr*cos(-i*stepsize),rr*sin(-i*stepsize)],[rr*cos(-(i+1)*stepsize),rr*sin(-(i+1)*stepsize)]]);
    }
}

module cylinder_rotated_path(d,h,angle,$fn=$fn)
{
    union()
    {
        cylinder(d=d,h=h);
        
        rotate([angle,0,0])
        cylinder(d=d,h=h);
        
        rotate([0,-90,0])
        cylinder_sector(d=h*2,h=d,angle=angle,center=true,$fn=$fn*360/angle);
    }
}

module rounded_box(x,y,z,radius,$fn=$fn)
{
    union()
    {
        cube([x,y-2*radius,z],center=true);
        cube([x-2*radius,y,z],center=true);
        
        translate([(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([(x/2-radius),-(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
        
        translate([-(x/2-radius),-(y/2-radius),0])
        cylinder(r=radius,h=z,center=true);
    }
}

module rounded_box_extent(x1,x2,y1,y2,z1,z2,radius,$fn=$fn)
{
  xmax=max(x1,x2);
  xmin=min(x1,x2);
  ymax=max(y1,y2);
  ymin=min(y1,y2);
  zmax=max(z1,z2);
  zmin=min(z1,z2);
  
  translate([xmin,ymin,zmin])
  translate([(xmax-xmin)/2,(ymax-ymin)/2,(zmax-zmin)/2])
  rounded_box(xmax-xmin,ymax-ymin,zmax-zmin,radius,$fn);
}

module torus(diameter, tubed, circlefn = 12, radialfn = 32, angle=360)
{
    rotate([0,0,-360-angle])
    rotate_extrude(convexity = 10, angle=angle,$fn=radialfn)
    translate([diameter/2, 0, 0])
    circle(d = tubed,$fn=circlefn);
}

module rounded_track_pointtopoint(x1,y1,x2,y2,d,h)
{
	hull()
	{
		translate([x1,y1,0])
		cylinder(d=d,h=h);
		translate([x2,y2,0])
		cylinder(d=d,h=h);
	}
}

module pipe_segment(d,point1,point2)
{
    hull()
    {
        translate(point1)
        sphere(d=d);
        
        translate(point2)
        sphere(d=d);
    }
}

module pipe_segmentdd(d1,d2,point1,point2)
{
    hull()
    {
        translate(point1)
        sphere(d=d1);
        
        translate(point2)
        sphere(d=d2);
    }
}

function elen(vec)= sqrt(vec[0]*vec[0]+vec[1]*vec[1]+vec[2]*vec[2]);
function cprod(a,b)=[a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]];
function dprod(a,b)=a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
function vangle(a,b)=acos(dprod(a,b)/(elen(a)*elen(b)));
module pipe_segmentdd_nocaps(d1,d2,point1,point2){
r=d1/2;
cr=d2/2;
diff=point2-point1;
translate(point1+diff/2)rotate(vangle(diff,[0,0,1]),-cprod(diff,[0,0,1]))cylinder(r=r,h=elen(diff),center=true);
}

module snaketorus(diameter, tubed, circlefn = 12, radialfn = 32, angle=360)
{
    steps = radialfn;
    rotate([0,0,-360-angle])
    for (i=[1:steps])
    {
        rotate([0,0,angle*(i-1)/steps])
        rotate_extrude(convexity = 10, angle=(angle/steps))
        translate([diameter/2, 0, 0])
        circle(d = tubed*i/steps,$fn=circlefn);
    }
}

module nut_by_flats(f,h,horizontal=true,center=false){
    if (center)
    {
        translate([0,0,-h/2])
        {
            cornerdiameter =  (f / 2) / cos (180 / 6);
            cylinder(h = h, r = cornerdiameter, $fn = 6);
            if(horizontal){
                for(i = [1:6]){
                    rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube([2,2,h]);
                }
            }
        }
    }
    else
    {
        cornerdiameter =  (f / 2) / cos (180 / 6);
        cylinder(h = h, r = cornerdiameter, $fn = 6);
        if(horizontal){
            for(i = [1:6]){
                rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube([2,2,h]);
            }
        }

    }
}

module ziptie_cut(
  buried=false,
  ziptie_width, //= 3.5 + diametric_clearance,
  ziptie_thickness, //= 1.2 + diametric_clearance,
  ziptie_diameter = 15,
  ziptie_bend_radius = 3,
  mountthickness = 1,
  )
{
  union()
  {
    difference()
    {
      cube_extent(
          -ziptie_diameter/2,ziptie_diameter/2,
          -ziptie_width/2,ziptie_width/2,
          0+0-1,0+0+mountthickness+ziptie_thickness+0.002,
          [
              [1,0,1],
              [-1,0,1],
          ],
          [
          ],
          radius=buried?(ziptie_bend_radius+ziptie_thickness):0.1,$fn=$fn
          );
          
      cube_extent(
          -ziptie_diameter/2+ziptie_thickness,ziptie_diameter/2-ziptie_thickness,
          -ziptie_width/2-1,ziptie_width/2+1,
          0+0-2,0+0+mountthickness+0.001,
          [
              [1,0,1],
              [-1,0,1],
          ],
          [
          ],
          radius=ziptie_bend_radius,$fn=$fn
          );
    }
  }
}


function COLOR_FROM_RGB255(r,g,b) = [r/255,g/255,b/255];

/*
//Original
function DISPLAYCOLORS() =
[
  [0.9,0.4,0.4],
  [0.4,0.9,0.4],
  [0.6,0.4,0.6],
  [0.9,0.7,0.2],
  [0.4,0.4,0.9],
];
*/

/*
//Pastel
function DISPLAYCOLORS() =
[
  COLOR_FROM_RGB255(76,219,166),
  COLOR_FROM_RGB255(246,218,112),
  COLOR_FROM_RGB255(101,167,230),
  COLOR_FROM_RGB255(244,156,115),
  COLOR_FROM_RGB255(214,104,211),
  //COLOR_FROM_RGB255(141,94,212),  
];
*/

/*
//Pastel 2
function DISPLAYCOLORS() =
[
  COLOR_FROM_RGB255(0,194,249),
  COLOR_FROM_RGB255(0,228,185),
  COLOR_FROM_RGB255(254,234,174),
  COLOR_FROM_RGB255(252,177,217),
  COLOR_FROM_RGB255(217,204,178),
];
*/

/*
//Green, Apricot, Purple
function DISPLAYCOLORS() =
[
  COLOR_FROM_RGB255(96,135,117)*1.1, //Wintergreen Dream
  COLOR_FROM_RGB255(252,233,189), //Lemon Meringue
  COLOR_FROM_RGB255(161,79,124)*1.2, //Magenta Haze
  COLOR_FROM_RGB255(254,186,119), //Mellow Apricot
  COLOR_FROM_RGB255(72,48,95)*1.4, //Jacarta
];
*/


function DISPLAYCOLORS() =
[
  COLOR_FROM_RGB255(138,189,144), //Dark Sea Green
  COLOR_FROM_RGB255(239,222,151), //Khaki
  COLOR_FROM_RGB255(223,159,87), //Indian Yellow
  COLOR_FROM_RGB255(203,106,93), //Fuzzy Wuzzy
  COLOR_FROM_RGB255(85,64,87)*1.7, //English Violet
];

//color([0.7,0.3,0.3])
//color([0.3,0.7,0.9])
//color([0.3,0.7,0.3])
//color([0.8,0.8,0.3])

function DISPLAYCOLOR(t) = DISPLAYCOLORS()[t];

module COLOR_RENDER(t,DO_RENDER)
{
  if (!(DO_RENDER))
  {
    color(DISPLAYCOLOR(t))
    children();
  }
  else
  {
    color(DISPLAYCOLOR(t))
    render()
    children();
  }
}

