
sz=7;
hstep=5;

for (i=[1:6])
{
    translate([(i-1)*sz,0,0])
    cube([sz,sz,hstep*i]);
}