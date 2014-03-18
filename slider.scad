Wr=0;
Hr=1;
P=2;
E=3;
D=4;
H=5;
SW=6;
SL=7;
SH=8;
H2=9;
GH15=[[Wr,15],[Hr,12.5],[P,60],[E,20],[D,6],[H,4.5],[SW,34],[SL,56.8],[SH,12.5],[H2,4.5]];
GH20=[[Wr,20],[Hr,15.5],[P,60],[E,20],[D,9.5],[H,4.5],[SW,42],[SL,69.1],[SH,15.5],[H2,6]];
GH25=[[Wr,23],[Hr,18],[P,60],[E,20],[D,11],[H,4.5],[SW,48],[SL,82.6],[SH,18],[H2,7]];
GH30=[[Wr,28],[Hr,23],[P,60],[E,20],[D,11],[H,4.5],[SW,60],[SL,98.1],[SH,23],[H2,10]];
GH35=[[Wr,34],[Hr,27.5],[P,60],[E,20],[D,14],[H,4.5],[SW,70],[SL,108],[SH,27.5],[H2,11]];

/*
	x滑块坐标
	N滑块数量
	W2滑块间隔(较远的两端的间隔)
	model导轨类型
	L导轨长度
*/
module slideway(x=20,N=1,W2=0,model=GH15,L=1000)
{
	wr = lookup(Wr,model);
	hr = lookup(Hr,model);
	p = lookup(P,model);
	e = lookup(E,model);
	d = lookup(D,model);
	h = lookup(H,model);
	W1= lookup(SW,model);
	L1= lookup(SL,model);
	H1= lookup(SH,model);
	H2= lookup(H2,model);
	R = d/2;
	w2 = W2-2*L1;
	
	difference()
	{
		color("white")
		translate([-wr/2,0,0])
		cube([wr,L,hr]);
		for(y=[e:p:L])
		{
			translate([0,y,hr-h+0.1])
				cylinder(r=d/2,h=h);
			translate([0,y,-1])
				cylinder(r=d/2*3/5,h=hr+2);
		}
		for(a=[1,-1])
		translate([a*(wr/2+R/2),-1,hr*2/3])
			rotate([-90,0,0])
				cylinder(r=R,h=L+2,$fn=6);
	}
	//滑块
	color("green")
	for(n=[0:1:N-1])
		translate([-W1/2,x+n*(w2+L1),H2])
			cube([W1,L1,H1]);
}
