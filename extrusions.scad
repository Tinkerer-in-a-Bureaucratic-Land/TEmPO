use <hardware.scad>

//render_extrusion(extrusion=frametype_name(frametype),h=h);
module render_extrusion(extrusion, h, frametype, fast_preview)
{
  file_height = 304.8; //1 foot

  translate([0,0,h/2])
  scale([1,1,h/304.8])
  {
    if (extrusion=="EXTRUSION_BASE20_2020")
    {
      if (!$fast_preview)
      {
        translate([10,10,0])
        import("external_models/20_2020.stl",convexity=3);
      }
      else
      {
        translate([0,0,-file_height/2])
        cube([20,20,file_height]);
      }
    }
    else if (extrusion=="EXTRUSION_BASE30_3030")
    {
      if (!$fast_preview)
      {
        translate([15,15,0])
        import("external_models/30_3030.stl",convexity=3);
      }
      else
      {
        translate([0,0,-file_height/2])
        cube([30,30,file_height]);
      }
    }
    else if (extrusion=="EXTRUSION_BASE20_4040_ROUND")
    {
      if (!$fast_preview)
      {
      translate([0,0,-304.8/2])
		linear_extrude(height=304.8)
		intersection()
		{
			translate([-130,-140])
			import("external_models/HFSR5-404020-100.dxf",convexity=3);
		
			translate([-5,-5])
			square([50,50]);
		}
      }
      else
      {
        translate([0,0,-file_height/2])
        cube([40,40,file_height]);
      }
    }
    else
    {
      //translate([0,0,-file_height/2])
      //cube([20,20,file_height]);
      
      for (xx=[1:frametype_xsize(frametype)/frametype_extrusionbase(frametype)])
      for (yy=[1:frametype_ysize(frametype)/frametype_extrusionbase(frametype)])
      translate([(xx-1)*frametype_extrusionbase(frametype),(yy-1)*frametype_extrusionbase(frametype),0])
      scale([frametype_extrusionbase(frametype)/20,frametype_extrusionbase(frametype)/20,1])
      translate([10,10,0])
      import("external_models/20_2020.stl",convexity=3);
    }
  }
  
}
