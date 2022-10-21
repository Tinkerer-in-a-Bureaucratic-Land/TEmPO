
include <zaxis_threaded_rod_support_UNIVERSAL.scad>
//include <zaxis_rail.scad>
include <z_motor_mount.scad>

include <zmodule_2and2.scad>
include <zmodule_3and3.scad>
include <zmodule_2and2rail.scad>
include <zmodule_zl.scad>

module Render_Z_Module(zmodule)
{
  if (!is_undef($BED_CONFIG) && is_undef($HIDE_Z))
  {
    if (zconfig_typename(zmodule)=="2AND2")
    {
      zmodule_2and2_render();
    }
    else if (zconfig_typename(zmodule)=="3AND3")
    {
      zmodule_3and3_render();
    }
    else if (zconfig_typename(zmodule)=="2AND2RAIL")
    {
      zmodule_2and2rail_render();
    }
    else if (zconfig_typename(zmodule)=="ZL")
    {
      zmodule_zl_render();
    }
  }
}
