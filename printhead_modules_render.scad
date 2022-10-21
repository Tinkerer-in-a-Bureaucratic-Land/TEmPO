
include <printhead_singlebowden/singlebowden.scad>
include <dial_mount/dial_mount.scad>

module generic_printhead(dotranslate=1,xmirror=false,ymirror=false)
{
  if (printer_printhead1=="DIALMOUNT")
    dialmount_assembly(dotranslate=dotranslate,xmirror=xmirror,ymirror=ymirror);
  else if (printer_printhead1=="SINGLEBOWDEN")
    singlebowden_assembly(dotranslate=dotranslate,xmirror=xmirror,ymirror=ymirror);
}
