use <../helpers.scad>
use <new-chain.scad>

//CHAINTYPE
function CHAINTYPE_STD()    = ["CHAINTYPE", 15.0, 12.5,  9.0, 2.5, 2.5,  8.0,  45.0];

function CC_CHAINTYPE_pivotlength(t) = t[1];
function CC_CHAINTYPE_cablewidth(t) = t[2];
function CC_CHAINTYPE_cableheight(t) = t[3];
function CC_CHAINTYPE_sidewall(t) = t[4];
function CC_CHAINTYPE_verticalwall(t) = t[5];
function CC_CHAINTYPE_centerlength(t) = t[6];
function CC_CHAINTYPE_maximumangle(t) = t[7];


//CC_LINKSECTIONTYPE
function CC_LINKSECTIONTYPE_MALE()     = ["CC_LINKSECTIONTYPE_MALE"];
function CC_LINKSECTIONTYPE_FEMALE()   = ["CC_LINKSECTIONTYPE_FEMALE"];

cc_chainlink(CHAINTYPE_STD(), CC_LINKSECTIONTYPE_MALE(), CC_LINKSECTIONTYPE_FEMALE());

module cc_chainlink(chaintype, link1, link2)
{
  centerlen = CC_CHAINTYPE_centerlength(chaintype);
  cablew = CC_CHAINTYPE_cablewidth(chaintype);
  cableh = CC_CHAINTYPE_cableheight(chaintype);
  sidewall = CC_CHAINTYPE_sidewall(chaintype);
  vertwall = CC_CHAINTYPE_verticalwall(chaintype);
  
  difference()
  {
    union()
    {
      cube_extent(
          -centerlen/2, centerlen/2,
          -cablew/2-2*sidewall, cablew/2+2*sidewall,
          0, cableh + 2*vertwall
        );
    }
  }
  
  cc_section(chaintype, link1);
  
  rotate([0,0,180])
  cc_section(chaintype, link2);
}

module cc_section(chaintype, linksectiontype)
{
  if (linksectiontype[0] == "CC_LINKSECTIONTYPE_MALE")
    cc_section_male(chaintype);
  else if (linksectiontype[0] == "CC_LINKSECTIONTYPE_FEMALE")
    cc_section_female(chaintype);
}

module cc_section_male(chaintype)
{
  
}

module cc_section_female(chaintype)
{
  
}
