

function XYMOUNTTYPE_EVO() = ["EVO"];

module XYMOUNT(xymounttype, left)
{
  if (xymounttype[0]=="EVO")
    motormount_assembly(left);
}
