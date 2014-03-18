R=0;
D1=1;
D3=2;
B=3;
H1=4;
D5=5;
L1=6;
D4=7;

SFU12=[[R,12],[D1,22],[D3,42],
[B,8],[H1,30],[D5,4.8],[L1,35],[D4,32]];

SFU16=[[R,16],[D1,28],[D3,48],
[B,10],[H1,40],[D5,5.5],[L1,36],[D4,38]];

SFU20=[[R,20],[D1,36],[D3,58],
[B,10],[H1,44],[D5,6.7],[L1,42],[D4,47]];

module ball_screw(model)
{
	r=lookup(R,model);
	d1=lookup(D1,model);
	d3=lookup(D3,model);
	b=lookup(B,model);
	h1=lookup(H1,model);
	d5=lookup(D5,model);
	l1=lookup(L1,model);
	d4=lookup(D4,model);
	difference()
	{
		union()
		{
			cylinder(r=d1/2,h=l1);
			cylinder(r=d3/2,h=b);
		}
		translate([-d3/2,h1/2,-1])cube([d3,d3,d3]);
		translate([-d3/2,-d3-h1/2,-1])cube([d3,d3,d3]);
		translate([0,0,-1])cylinder(r=r/2,h=l1+2);
		//安装空
		for(a=[-45,0,45,180,180+45,180-45])
		rotate([0,0,a])translate([d4/2,0,-0.1])cylinder(r=d5/2,h=12,$fn=12);
	}
}

//ball_screw(model=SFU20);