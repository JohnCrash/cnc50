include <MCAD/materials.scad>
include <MCAD/stepper.scad>
include <slider.scad>
include <screw.scad> //滚珠洗丝杠螺母

main_color = Aluminum;
table_color = "white";
/*
	加长86步进电机
*/
S86 = [
                [NemaModel, 34],
                [NemaLengthShort, 66*mm],
                [NemaLengthMedium, 150*mm],
                [NemaLengthLong, 150*mm],
                [NemaSideSize, 86*mm], 
                [NemaDistanceBetweenMountingHoles, 69.58*mm], 
                [NemaMountingHoleDiameter, 6.5*mm], 
                [NemaMountingHoleDepth, 5.5*mm], 
                [NemaMountingHoleLip, 5*mm], 
                [NemaMountingHoleCutoutRadius, 17*mm], 
                [NemaEdgeRoundingRadius, 3*mm], 
                [NemaRoundExtrusionDiameter, 73.03*mm], 
                [NemaRoundExtrusionHeight, 1.9*mm], 
                [NemaAxleDiameter, 0.5*inch], 
                [NemaFrontAxleLength, 37*mm], 
                [NemaBackAxleLength, 34*mm],
                [NemaAxleFlatDepth, 1.20*mm],
                [NemaAxleFlatLengthFront, 25*mm],
                [NemaAxleFlatLengthBack, 25*mm]
         ];

//slideway(model=GH20);
//ball_screw(model=SFU12);
/*
	W基板宽度
	W2两个滑块远端宽度
	H基板高度
	S基板厚度
	SW基板留边宽度
	L导轨长度
	OFFL导轨偏移
*/
fix=1;
fixd=0.5;
module table(x=0,W2=300,W=500,H=300,S=50,SW=50,L=500,OFFL=0)
{
	color(main_color)
	translate([0,-H/2,0])
	difference()
	{
		cube([W,H,S]);
		translate([SW,SW,-fixd])
			cube([W-SW*2,H-SW*2,S+fix]);
	}
	for(a=[H/2-SW/2,-H/2+SW/2])
	translate([OFFL,a,S])
		rotate([0,0,-90])
			slideway(x=x-OFFL,N=2,W2=W2,model=GH20,L=L);
}
/*
	整体滚珠丝杠20
*/
module ball_screw20()
{
	B = 64;
	H = 46;
	L = 40;
	W = 50;
	E = 11;
	P = 52;
	C1 = 8;
	C2 = 24;
	color(main_color)
	translate([0,0,-10])
	ball_screw(model=SFU20);
	translate([-B/2,-H/2,0])
	color("red")
	difference()
	{
		cube([B,H,L]);
		translate([B/2,H/2,-1])
			cylinder(r=39/2,h=L+2);
		for(a=[-45,0,45,180-45,180,180+45])
			translate([B/2,H/2,-1])
			rotate([0,0,a])
			translate([-W/2,0,0])
			cylinder(r=M5/2,h=L+2);
		//切角
		/*
		for(s=[0,B])
			translate([s,H-E,-1])
			rotate([0,0,45])
				cube([B,B,B]);
		*/
		//侧向安装空
		translate([B/2,0,H/2-C1/2])
		for(x=[-P/2,P/2])
		for(y=[-C2/2,C2/2])
		translate([x,-1,y])
			rotate([-90,0,0])
			cylinder(r=M5/2,h=H/3);
	}
}
/*
	步进电机和丝杠组
*/
module screw_motor(x=0,OFFX=8,L=400)
{
	S = 32;//头端
	E = 52;//尾端
	//电机
	translate([68,0,15])
		motor(S86);
	//丝杠
	translate([0,0,x+OFFX])
		rotate([0,0,90])
		ball_screw20();
	color("white")
		translate([0,0,-S])
		cylinder(r=20/2,h=L+S+E);
	//丝杠安装座
//	color("white")		
//	translate([-50,-25,-45])
//		cube([180,50,20]);
	color("white")
	translate([-50,-25,L+35])
		cube([100,50,20]);
	//电机座
	color("white")
	translate([68-86/2-50,-86/2,-25-20])
		cube([86+50,86,40+20]);
	//同步轮
	color("green")
	for(s=[0,78])
		translate([s,0,-25])
			cylinder(r=40/2,h=20);
}
//screw_motor();
/*
	简单滑台
	x,y坐标
	width,height滑台的宽度和高度
	table_width,table_height滑台的宽度和高度
	S,W框架的厚度
*/
module table_xy(x=0,y=0,width=800,height=400,
								table_width=200,table_height=200,
								table_Thickness=50,
								S=50,SW=50)
{
	table(x=x,W=width,H=height,W2=table_width,S=S,SW=SW,L=width-SW,OFFL=SW);
	translate([table_width/2+x,-height/2,S+21])
		rotate([0,0,90])
		{
			table(x=y,W=height,H=table_width,W2=table_height,S=S,SW=SW,L=height);
			translate([y,-table_width/2,S+21])
			color(main_color)
			cube([table_height,table_width,table_Thickness]);
		}
}

//T型槽板
module table_T(w,h,t)
{
	C = -6+(t-2*50)/2;
	difference()
	{
		cube([w,h,t]);
		for(n=[0:1:2])
		{
			translate([w-15,-0.5,50*n+C])
				cube([16,h+1,12]);
			translate([w-20,-0.5,50*n-4+C])
				cube([8,h+1,20]);
		}
	}
}

//主轴
module main_tool(x=0 ,D=80)
{
	//80伺服电机
	translate([80,0,0])
	{
		color("Gray")
		{
			cylinder(r=D/2,h=168);
			translate([-40,-40,168-15])
			cube([80,80,15]);
		}
		color(Steel)
		translate([0,0,168])
		cylinder(r=19/2,h=36);
	}
	//主轴箱
	color("white")
		translate([-40,-40,0])
			cube([80,80,168]);
	//同步轮
	color("green")
	for(a=[0,80])
	translate([a,0,182])
		cylinder(r=60/2,h=20);
	//连接块
	translate([-40,-40,168])
		cube([160,80,15]);
	//ER20头
	translate([0,0,-30])
	{
		color("blue")
		cylinder(r=26/2,h=30);
		translate([0,0,-10])
		cylinder(r=32/2,h=20,$fn=6);
		color("red")
		translate([0,0,-30])
		cylinder(r=6/2,h=50);
	}
	//自动换刀
	translate([-62,0,20])
	{
		motor(Nema17);
		color(Steel)
		translate([0,0,-50])
			cylinder(r=8/2,h=60);
		translate([-42/2,-20,-20])
			cube([42,42,20]);
	}
	color(Steel)
	translate([-40,-40,-10-x])
	difference()
	{
		union()
		{
			cube([80,80,10]);
			translate([40,40,-8])
			cylinder(r=40/2,h=8);
			translate([-40,20,0])
			cube([42,42,10]);
		}
		translate([40,40,-50])
			cylinder(r=33/2,h=100,$fn=6);
	}
	
}
//main_tool();
module cnc(x=200,y=200,z=0)
{
	/*
		设置下面机器参数
	*/
	slide_width = 50; //边框宽度
	slide_height = 50; //边框高度
	z_max = 250; //z轴行程
	y_max = 360; //y轴行程
	x_max = 300; //x轴行程
	table_width = 150;//拖板宽度
	table_Thickness = 30; //台面厚度
	motor_width = 250; //电机安装位的宽度
	motor_height = 140; //电机安装位高度
	tool_min_height = 50; //工具预留
	T_OFFSET = 30; //T型板偏移
	X_SPACE = tool_min_height+20+table_Thickness; //X轴预留空间
	Y_LEN = y_max+motor_height;
	X_LEN = x_max+motor_width+X_SPACE;
	Z_LEN = z_max+table_width+slide_height;
	Ht = 21;
	echo("Y:",Y_LEN);
	echo("X:",X_LEN);
	echo("Z:",Z_LEN);
	//z-axis
	translate([-slide_height,0,Z_LEN])
		rotate([0,90,0])
			table(x=z+T_OFFSET,W=Z_LEN,H=Y_LEN,L=Z_LEN,W2=table_width,SW=slide_width,S=slide_height);
	color(table_color)
	translate([Ht,-Y_LEN/2,Z_LEN-z-table_width-T_OFFSET])
		table_T(table_Thickness,Y_LEN,table_width); //台面
	//x-y axis
	table_xy(x=x+X_SPACE,y=y,width=X_LEN,height=Y_LEN,table_width=motor_width,table_height=motor_height,SW=slide_width,S=slide_height,table_Thickness=table_Thickness);
	//主轴
	translate([X_SPACE+x,y-Y_LEN/2+40,40+2*slide_height+2*Ht+table_Thickness])
		rotate([0,90,0])rotate([0,0,90])
			main_tool();
	//侧向加固角
	color(main_color)
	for(o=[-Y_LEN/2,Y_LEN/2+20])
		translate([-slide_height,o,0])
		rotate([90,0,0])
		difference()
		{
			cube([120,120,20]);
			translate([120+slide_height,0,0])
			rotate([0,0,45])
				translate([0,0,-1])
				cube([200,200,22]);
		}
	//电机
	//z-motor
	translate([-25,0,80+15])
	rotate([0,0,90])
	screw_motor(x=z_max-z,OFFX=-6,L=z_max);
	//x-motor
	translate([255+x_max,0,25])
	rotate([0,-90,0])
	rotate([0,0,90])
	screw_motor(x=x_max-x,OFFX=50,L=x_max+2*slide_width+slide_height);
	//y-motor
	translate([X_SPACE+motor_width/2-40+x,-Y_LEN/2+95,95])
	rotate([-90,0,0])
	//rotate([0,0,90])
	screw_motor(x=y,L=y_max-slide_width);
	/*
		自动换刀系统
	*/
	translate([-10,-110,212])
		rotate([0,90,0])
	{
		//刀盘
		difference()
		{
			cylinder(r=160/2,h=10);
			for(b=[0,15])
			for(a=[b:30:360])
				rotate([0,0,a])
					translate([70-b*20/15,0,-1])
						cylinder(r=M6/2,h=20);
		}
		translate([0,0,-100])
			cylinder(r=30/2,h=100);
		color("green")
		translate([0,0,-110])
			cylinder(r=60/2,h=10);
		//刀
		color(Steel)
		translate([0,0,-40])
		{//0,15 ,50,70
			for(b=[0,15])
			for(a=[b:30:360])
				rotate([0,0,a])
					translate([70-b*20/15,0,-1])
					{
						cylinder(r=M6/2,h=60);
						translate([0,0,50])
						cylinder(r=12/2,h=20);
					}
		}
		//托架
		color(Steel)
		translate([-28,-25,-100])
		{
			difference()
			{
				cube([240,50,60]);
				translate([-1,-1,30])
					cube([240-50+1,52,31]);
			}
		}
		//电机
		translate([100,-46,-100+3])
		{
			motor(Nema17);
			color("green")
			translate([0,0,-15])
				cylinder(r=20/2,h=10);
		}
	}
}

module cnc_place(x=0,y=0,z=0)
{
	translate([0,0,250])
		rotate([90,0,0])
		cnc(x=z,y=x,z=y);
	//脚垫
	color(Steel)
	for(x=[0,600])
	translate([x,-25,-50])
		cylinder(r=50/2,h=50);
	color(Steel)
	translate([-25,-400,-50])
		cylinder(r=50/2,h=50);
	//切削盒子
	color([1,1,1])
	translate([0,-450,-50])
	difference()
	{
		cube([500,400,50]);
		translate([0.5,0.5,1.1])
			cube([500-1,400-1,50-1]);
	}
	//切削挡板
	%translate([0,-450-1,0])
		cube([300,0.5,500]);
	//电控箱
	color([0,0.8,0.6])
	translate([-150-50,-450,0])
	difference()
	{
		cube([150,450,500]);
		translate([1.1,0.5,0.5])
		cube([150-1,450-1,500-1]);
	}
}

cnc_place(x=300*sin($t*180),y=200*sin($t*180),z=300*sin($t*180));