
include <xyh_motormount.scad>
include <xyh_idlermount.scad>
include <xyh_sidecarriage.scad>
include <xyh_centercarriage.scad>

include <xyh_module_main.scad>  //Hypercube
include <xysc_module_main.scad> //Screw cross v1

module Render_XY_Module(xymodule)
{
  if (xyconfig_typename(xymodule)=="HYPERCUBE")
  {
    xy_module_hypercube();
  }
  else if (xyconfig_typename(xymodule)=="SCREWCROSSV1")
  {
    xy_module_screwcrossv1();
  }
}
