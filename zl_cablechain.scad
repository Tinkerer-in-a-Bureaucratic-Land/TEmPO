
use <hardware.scad>
use <helpers.scad>
use <cablechain/new-chain.scad>

diametric_clearance = 0.32;
diametric_clearance_tight = 0.16;
radial_clearance = diametric_clearance/2;
radial_clearance_tight = diametric_clearance_tight/2;
$fn=$preview?25:300;
ffn=$preview?25:300;






zcc_chainwidth = 22.428;
zcc_chainheight = 13.28;
zcc_chainfloor = 2.4;

module stdend_fixedside(chainscale=1.0)
{
  difference()
  {
    //translate([chainxmax,bedend_cableyface,bedend_current_z])
    rotate([0,0,-90]) rotate([0,-90,0]) rotate([0,0,-90])
    scale([chainscale,chainscale,chainscale])
    translate([0,-3.2-3,0])
    nobar_end2();
    
    cube_extent(
      1,-zcc_chainwidth*chainscale-1,
      -12,+12,
      12.2*chainscale,50*chainscale,
      );
  }
}

module stdend_bedside(chainscale=1.0)
{
  difference()
  {
    
    translate([0,0,-0.8*chainscale])
    rotate([0,0,-90]) rotate([0,-90,0]) rotate([0,0,-90])
    scale([chainscale,chainscale,chainscale])
    translate([0,-3.2,0])
    nobar_end1();
    
    
    /*
    translate([0,0,-0.8*chainscale])
    rotate([0,0,-90]) rotate([0,-90,0]) rotate([0,0,-90])
    scale([chainscale,chainscale,chainscale])
    translate([0,-3.2,0])
    nobar_chain();
    */
    
    cube_extent(
      1,-zcc_chainwidth*chainscale-1,
      -12,+12,
      12.2*chainscale-0.8*chainscale,50*chainscale,
      );
  }
}

module zl_cablechain_frameside(
    chainxmax,
    fixedend_cableyface,
    fixedend_z,
    chainlinkcount,
    chainscale=1.0,
    //bracketxcenter,
    //bedend_bracketyface,
    //bedend_bracketztop,
    
    extrusionxmax,
    extrusionymin,
    extrusiontype,
    extrusionmountdetails,
    )
{
  hhhh = 40;
  itopz = fixedend_z + hhhh/2;
  bottomz = fixedend_z - hhhh/2;
  //frontyface = fixedend_cableyface-chainscale*0.52;
  frontyface = fixedend_cableyface-chainscale*2.4;
  iroundradius=3;
  
  difference()
  {
    union()
    {
      translate([chainxmax,fixedend_cableyface,0])
      translate([0,0,fixedend_z])
      mirror([0,1,0])
      stdend_fixedside(chainscale);
      
      cube_extent(
          extrusionxmax-frametype_narrowsize(extrusiontype)+radial_clearance_tight,extrusionxmax,
          frontyface,extrusionymin-radial_clearance_tight,
          bottomz,itopz,
          [
            [1,-1,0],
            [-1,-1,0],
            [0,-1,1],
            [0,-1,-1],
            
            [-1,0,1],
            [-1,0,-1],
            [1,0,-1],
          ],
          [
            [-1,-1,1],
            [-1,-1,-1],
            [1,-1,-1],
          ],
          radius=iroundradius,$fn=ffn
          );
          
      cube_extent(
          extrusionxmax-frametype_narrowsize(extrusiontype)+radial_clearance_tight,chainxmax,
          frontyface,extrusionymin-radial_clearance_tight,
          fixedend_z+chainscale*4.185,itopz,
          [
            [1,-1,0],
            [-1,-1,0],
            [0,-1,1],
            [0,-1,-1],
            
            [-1,0,1],
            [-1,0,-1],
            [1,0,1],
          ],
          [
            [-1,-1,1],
            [1,-1,1],
          ],
          radius=iroundradius,$fn=ffn
          );
          
        cube_extent(
          chainxmax-chainscale*zcc_chainwidth,chainxmax,
          frontyface,extrusionymin-radial_clearance_tight,
          fixedend_z+chainscale*4.185,fixedend_z+chainscale*12.2,
          );
          
      //Link bottom feet (printability)
      cube_extent(
          chainxmax-chainscale*2.72,chainxmax-chainscale*4.77,
          frontyface,extrusionymin-radial_clearance_tight,
          chainscale*12.2+fixedend_z,fixedend_z-chainscale*3,
          );
      cube_extent(
          chainxmax-chainscale*zcc_chainwidth+chainscale*2.72,chainxmax-chainscale*zcc_chainwidth+chainscale*4.77,
          frontyface,extrusionymin-radial_clearance_tight,
          chainscale*12.2+fixedend_z,fixedend_z-chainscale*3,
          );
    }
    
    //Ziptie above chain
    translate([chainxmax-chainscale*zcc_chainwidth/2,frontyface,fixedend_z+chainscale*12.2+6])
    rotate([-90,0,0])
    pdb_ziptie_cut(
      ziptie_bend_radius = 3,
      ziptie_diameter = 17*chainscale+diametric_clearance,
      mountthickness = (extrusionymin-radial_clearance_tight)-frontyface,
      );
      
    //Mount holes
    //extrusiontype,
    //extrusionmountdetails,
    for (iii=[-1,1])
    translate([extrusionxmax-frametype_extrusionbase(extrusiontype)/2,extrusionymin+1,fixedend_z+iii*10])
    rotate([90,0,0])
    cylinder(d=screwtype_diameter_actual(extrusionmountdetails[0])+diametric_clearance,h=(extrusionymin-radial_clearance_tight)-frontyface+2,$fn=ffn);
    
    for (iii=[-1,1])
    translate([extrusionxmax-frametype_extrusionbase(extrusiontype)/2,extrusionymin-extrusionmountdetails[1],fixedend_z+iii*10])
    rotate([90,0,0])
    cylinder(d=screwtype_washer_od(extrusionmountdetails[0])+1+diametric_clearance,h=(extrusionymin-radial_clearance_tight)-frontyface+2,$fn=ffn);
  }
}

module zl_cablechain_bedside(
    chainxmax,
    bedend_cableyface,
    fixedend_cableyface,
    bedend_max_z,
    bedend_current_z,
    fixedend_z,
    chainlinkcount,
    chainscale=1.0,
    bracketxcenter,
    bedend_bracketyface,
    bedend_bracketztop,
    )
{
  ichainlinktopfacez = bedend_current_z+12.2*chainscale;
  imainblockbottomz = bedend_current_z+6.165*chainscale-0.8*chainscale;
  imainblockfronty = bedend_cableyface+2.4*chainscale;
  iroundradius=3;
  
  difference()
  {
    union()
    {
      //Backplate 1
      cube_extent(
          bracketxcenter+10,chainxmax-zcc_chainwidth*chainscale,
          bedend_bracketyface,imainblockfronty,
          bedend_bracketztop-28,bedend_bracketztop,
          [
            [1,1,0],
            [0,1,-1],
            [1,0,-1],
            
            [-1,1,0],
            [0,1,1],
            [-1,0,1],
            
            [1,0,1],
          ],
          [
            [1,1,-1],
            [-1,1,1],
            [1,1,1],
          ],
          radius=iroundradius,$fn=ffn
          );
          
      //Backplate 2
      cube_extent(
          chainxmax,chainxmax-zcc_chainwidth*chainscale,
          bedend_bracketyface,imainblockfronty,
          imainblockbottomz,max(ichainlinktopfacez+10,bedend_bracketztop-28+iroundradius+0.1),
          [
            //[1,1,0],
          ],
          [
          ],
          radius=iroundradius,$fn=ffn
          );
          
      //Chamfer removal for link
      cube_extent(
          chainxmax,chainxmax-zcc_chainwidth*chainscale,
          bedend_bracketyface,bedend_cableyface+chainscale*0.52,
          imainblockbottomz,ichainlinktopfacez,
          );
          
      //Link bottom feet (printability)
      cube_extent(
          chainxmax,chainxmax-2.48*chainscale,
          bedend_bracketyface,bedend_cableyface+chainscale*0.52,
          bedend_current_z-chainscale*3.198-0.8*chainscale,ichainlinktopfacez,
          );
      cube_extent(
          chainxmax-zcc_chainwidth*chainscale,chainxmax-zcc_chainwidth*chainscale+2.48*chainscale,
          bedend_bracketyface,bedend_cableyface+chainscale*0.52,
          bedend_current_z-chainscale*3.198-0.8*chainscale,ichainlinktopfacez,
          );
      //cube_extent(
          //chainxmax,chainxmax-zcc_chainwidth*chainscale,
          //bedend_bracketyface,bedend_cableyface-chainscale*2.5,
          //bedend_current_z-chainscale*3.198,ichainlinktopfacez,
          //);
      
      /*
      //Chain link end
      difference()
      {
        translate([chainxmax,bedend_cableyface,bedend_current_z])
        rotate([0,0,-90]) rotate([0,-90,0]) rotate([0,0,-90])
        scale([chainscale,chainscale,chainscale])
        translate([0,-3.2,0])
        nobar_end1();
        
        cube_extent(
          chainxmax+1,chainxmax-zcc_chainwidth*chainscale-1,
          bedend_cableyface-12,bedend_cableyface+12,
          ichainlinktopfacez,bedend_current_z+50*chainscale,
          );
      }
      */
      
      translate([chainxmax,bedend_cableyface,bedend_current_z])
      stdend_bedside(chainscale);
      
    }
    
    //Ziptie above link
    translate([chainxmax-zcc_chainwidth*chainscale/2,imainblockfronty,ichainlinktopfacez+6])
    rotate([90,0,0])
    pdb_ziptie_cut(
        ziptie_bend_radius = 3,
        ziptie_diameter = 17*chainscale+diametric_clearance,
        mountthickness = imainblockfronty-bedend_bracketyface,
        );
    
    //Horizontal ziptie
    translate([bracketxcenter-10-4,imainblockfronty,bedend_bracketztop-(17*chainscale+diametric_clearance)/2-iroundradius])
    rotate([0,90,0]) rotate([90,0,0])
    pdb_ziptie_cut(
        ziptie_bend_radius = 3,
        ziptie_diameter = 17*chainscale+diametric_clearance,
        mountthickness = imainblockfronty-bedend_bracketyface,
        );
        
    //Bracket attachment hole
    translate([bracketxcenter,bedend_bracketyface-1,bedend_bracketztop-28/2])
    rotate([-90,0,0])
    cylinder(d=screwtype_diameter_actual(M5())+diametric_clearance,h=2+imainblockfronty-bedend_bracketyface,$fn=ffn);
    
    //Bracket attachment nut
    //translate([bracketxcenter,imainblockfronty-3,bedend_bracketztop-28/2])
    //rotate([-90,0,0])
    //nut_by_flats(f=screwtype_nut_flats_horizontalprint(M5())+diametric_clearance_tight,h=2+imainblockfronty-bedend_bracketyface,$fn=ffn);
    
    //Bracket attachment countersink
    translate([bracketxcenter,imainblockfronty-3,bedend_bracketztop-28/2])
    rotate([-90,0,0])
    cylinder(d=9.25+diametric_clearance,h=2+imainblockfronty-bedend_bracketyface,$fn=ffn);
    
  }
}

module approx_chain_run(
    chainxmax,
    bedend_cableyface,
    fixedend_cableyface,
    bedend_max_z,
    bedend_current_z,
    fixedend_z,
    chainlinkcount,
    chainscale=1.0,
    )
{
  chainsep=fixedend_cableyface-bedend_cableyface;
  chainlinks=chainlinkcount;
  
  highestpos=max(fixedend_z,bedend_max_z);
  pos=-1*(bedend_current_z-highestpos);
  endpos=-1*(fixedend_z-highestpos);
  
  linkstilted = floor(sqrt(chainsep*chainscale)-1);
  //linklength = 17*chainscale;
  linklength = 16*chainscale;


  totlen = (chainlinks-linkstilted)*linklength;
  //pos+leftlen=endpos+rightlen
  //leftlen+rightlen=totlen
  leftlen = (endpos-pos+totlen)/2;
  rightlen = totlen-leftlen;
  leftlinks = floor(leftlen/linklength)-1;
  rightlinks = floor(rightlen/linklength)-1;

  translate([chainxmax,bedend_cableyface,highestpos])
  mirror([1,0,0]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,180])
  union()
  {
    if (leftlinks >= 0)
    for (i=[0:floor(leftlen/linklength)-1])
      translate([0,pos+i*linklength,0])
      rotate([0,-90,0])
      translate([0,20*chainscale,0]) mirror([0,1,0])
      scale([chainscale,chainscale,chainscale])
      nobar_chain();

    if (rightlinks >= 0)  
    for (i=[0:floor(rightlen/linklength)-1])
      translate([0,endpos+i*linklength,0])
      translate([-chainsep,24,0]) rotate([0,0,180]) rotate([0,-90,0])
      translate([0,36*chainscale,0]) mirror([0,1,0])
      scale([chainscale,chainscale,chainscale])
      nobar_chain();

    ttrad = (chainsep)/2;
    ttstr = pos + leftlen + ttrad;
    
    #translate([-ttrad,-ttrad+ttstr,0]) cylinder(r=ttrad,h=22.428*chainscale);
    //#cube_extent(0,-2*ttrad,0,ttstr-ttrad,0,22.428*chainscale);
  }
}

module pdb_ziptie_cut(
  buried=false,
  ziptie_width = 3.5 + diametric_clearance,
  ziptie_thickness = 1.2 + diametric_clearance,
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
          radius=buried?(ziptie_bend_radius+ziptie_thickness):0.1,$fn=ffn
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
          radius=ziptie_bend_radius,$fn=ffn
          );
    }
  }
}

/*
module approx_chain_run(bedmount_x,bedmount_y,y_offset,z_offset,mountsep=zcc_chainheight*2+28,topz,yspacer=1,pos,chainlinks)
{
  chainsep = mountsep-zcc_chainheight*2; //28;
  //chainlinks = 23;
  linkstilted = floor(sqrt(chainsep)-1);
  linklength = 17*zcc_chainscalefactor;
  //pos = 120;
  endpos = 0;


  totlen = (chainlinks-linkstilted)*linklength;
  //pos+leftlen=endpos+rightlen
  //leftlen+rightlen=totlen
  leftlen = (endpos-pos+totlen)/2;
  rightlen = totlen-leftlen;
  leftlinks = floor(leftlen/linklength)-1;
  rightlinks = floor(rightlen/linklength)-1;

  translate([bedmount_x-10,bedmount_y-y_offset,topz-pos+z_offset-32+pos])
  rotate([90,0,0]) rotate([0,0,180])
  union()
  {
    if (leftlinks > 0)
    for (i=[0:floor(leftlen/linklength)-1])
      translate([0,pos+i*linklength,0])
      rotate([0,-90,0])
      translate([0,21,0]) mirror([0,1,0])
      scale([zcc_chainscalefactor,zcc_chainscalefactor,zcc_chainscalefactor])
      nobar_chain();

    if (rightlinks > 0)  
    for (i=[0:floor(rightlen/linklength)-1])
      translate([0,endpos+i*linklength,0])
      translate([-13.28*2-chainsep,24,0]) rotate([0,0,180]) rotate([0,-90,0])
      translate([0,26.5,0]) mirror([0,1,0])
      scale([zcc_chainscalefactor,zcc_chainscalefactor,zcc_chainscalefactor])
      nobar_chain();

    ttrad = (chainsep+13.28*2)/2;
    ttstr = pos + leftlen + ttrad;
    //echo(str("******* ttstr: ",ttstr));
    translate([-ttrad,-ttrad+ttstr,0])
    #cylinder(r=ttrad,h=22.428*zcc_chainscalefactor);
    #cube_extent(0,-2*ttrad,0,ttstr-ttrad,0,22.428*zcc_chainscalefactor);
  }
}

module zl_cablechain_bedside(bedmount_x,bedmount_y,y_offset,z_offset,mountsep=zcc_chainheight*2+28,topz,yspacer=1)
{
  chaininterface_z = topz+z_offset-20.5;
  
  difference()
  {
    union()
    {
      difference()
      {
        union()
        {
          cube_extent(
              bedmount_x-10,bedmount_x+10,
              bedmount_y-yspacer,bedmount_y-y_offset,
              topz,topz+z_offset-34.9,
              [
                [1,-1,0],
                [0,-1,1],
                [1,0,1],
              ],
              [
                [1,-1,1]
              ],
              radius=3,$fn=ffn
              );
              
          cube_extent(
            bedmount_x-10,bedmount_x-10+1,
            bedmount_y-yspacer,bedmount_y-y_offset-0.5,
            chaininterface_z,topz+z_offset-34.9
            );
        }

        translate([0,0,-23.525])
        translate([bedmount_x,bedmount_y-y_offset/2,-36])
        translate([0,0,topz+z_offset])
        ramp(50,
        abs((bedmount_y-yspacer+1)-(bedmount_y-y_offset-1))+3,
        0,50
        );
      }
          
      difference()
      {
        translate([bedmount_x-20/2,bedmount_y-y_offset,-36])
        translate([0,0,topz+z_offset])
        mirror([1,0,0]) rotate([0,-90,0]) rotate([0,0,-90])
        scale([zcc_chainscalefactor,zcc_chainscalefactor,zcc_chainscalefactor])
        nobar_end1();
        
        cube_extent(
          bedmount_x-12,bedmount_x+12,
          bedmount_y,bedmount_y-y_offset-zcc_chainwidth-2,
          topz,chaininterface_z
          );
      }
      
      cube_extent(
        bedmount_x-10,bedmount_x-10+zcc_chainfloor,
        bedmount_y-yspacer-0.002,bedmount_y-y_offset-zcc_chainwidth,
        chaininterface_z+18,chaininterface_z-6,
        [
          [0,-1,1],
        ],
        [
        ],
        radius=3,$fn=ffn
        );
        
      cube_extent(
        bedmount_x-10,bedmount_x-10+zcc_chainfloor,
        bedmount_y-yspacer-0.002,bedmount_y-y_offset-zcc_chainwidth/2,
        topz,chaininterface_z-6,
        [
          [0,-1,1],
        ],
        [
        ],
        radius=3,$fn=ffn
        );
    }
    
    translate([bedmount_x-20/2+zcc_chainfloor,bedmount_y-y_offset-zcc_chainwidth/2,0])
    translate([0,0,chaininterface_z+3])
    rotate([0,-90,0]) rotate([0,0,90])
    pdb_ziptie_cut();
    
    translate([bedmount_x-20/2+zcc_chainfloor,bedmount_y-y_offset-zcc_chainwidth/2,0])
    translate([0,0,chaininterface_z+14])
    rotate([0,-90,0]) rotate([0,0,90])
    pdb_ziptie_cut();
    
    //Mount screw
    translate([bedmount_x,bedmount_y+1,0])
    translate([0,0,topz-28/2-3])
    rotate([90,0,0]) rotate([0,0,-90])
    mteardrop(d=screwtype_diameter_actual(M5()),h=y_offset+4,$fn=ffn);
  }
}

module zl_cablechain_frameside(bedmount_x,bedmount_y,y_offset,z_offset,mountsep=13.28*2+28,topz,yspacer=1)
{
  
}
*/
