
use <endstopmodule_chineseoptical.scad>
use <endstopmodule_microswitch.scad>

//                                                              0      1           2
function ENDSTOPMODULE_ChineseOptical(triggerdist) =   ["ENDSTOP","COpt",triggerdist];
function ENDSTOPMODULE_Microswitch(triggerdist)    =   ["ENDSTOP","McSw",triggerdist];

function endstop_typename(t) = t[1];
function endstop_triggerdist(t) = t[2]; //Distance between close faces of endstop rects at trigger


// ^     **************
// |     * o        o *
// Z     **************  <| triggerdist
//       ^                |
//       Origin           |
//                        |
// Y->   **************  <|
//       *     o    o *
//       **************
//       ^
//       Origin

function endstop_get_minimum_sep(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_minimum_sep(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_minimum_sep(t)
    :0;

////////////////////////////////

function endstop_get_xsize_flag(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_xsize_flag(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_xsize_flag(t)
    :0;
    
function endstop_get_ysize_flag(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_ysize_flag(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_ysize_flag(t)
    :0;
    
function endstop_get_zsize_flag(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_zsize_flag(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_zsize_flag(t)
    :0;
    
function endstop_get_screwholes_flag(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_screwholes_flag(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_screwholes_flag(t)
    :0;
    
////////////////////////////////

function endstop_get_xsize_switch(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_xsize_switch(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_xsize_switch(t)
    :0;
    
function endstop_get_ysize_switch(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_ysize_switch(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_ysize_switch(t)
    :0;
    
function endstop_get_zsize_switch(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_zsize_switch(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_zsize_switch(t)
    :0;
    
function endstop_get_screwholes_switch(t) =
    (endstop_typename(t) == "COpt") ? COpt_get_screwholes_switch(t)
    :(endstop_typename(t) == "McSw") ? McSw_get_screwholes_switch(t)
    :0;

////////////////////////////////

module EndstopRenderPusherAssembly(t)
{
  if (endstop_typename(t) == "COpt")
    COpt_RenderPusherAssembly(t);
  else if (endstop_typename(t) == "McSw")
    McSw_RenderPusherAssembly(t);
}

module EndstopRenderSwitchAssembly(endstoptype)
{
  if (endstop_typename(endstoptype) == "COpt")
    COpt_RenderSwitchAssembly(endstoptype);
  else if (endstop_typename(endstoptype) == "McSw")
    McSw_RenderSwitchAssembly(endstoptype);
}
