//Let Zeds know
[player,4,true,(getPosATL player)] spawn player_alertZombies;

//display gui (temp hint)
hintSilent parseText format ["
	<t size='1.5'font='Bitstream'align='center'color='#DDDDDD'>%1</t><br/>
	<t size='1'font='Bitstream'align='center'color='#DDDDDD'>----------------------</t><br/>
	<t size='1'font='Bitstream'align='left' color='#FF0000'>Blood</t><t size='1' font='Bitstream'align='right'>%2</t><br/>
    <t size='1'font='Bitstream'align='left' color='#16DB57'>Humanity</t><t size='1'font='Bitstream'align='right'>%3</t><br/>
	<t size='1'font='Bitstream'align='center' color='#16DB57'>Survived %4 dayz!</t><br/>
	<t size='1'font='Bitstream'align='center' color='#DDDDDD'>----------------------</t><br/>
	<t size='1'font='Bitstream'align='left'color='#DDDDDD'>Zombies Killed</t><t size='1'font='Bitstream'align='right'>%5</t><br/>
    <t size='1'font='Bitstream'align='left'color='#DDDDDD'>Survivors Killed</t><t size='1'font='Bitstream'align='right'>%6</t><br/>
    <t size='1'font='Bitstream'align='left'color='#DDDDDD'>Bandits Killed</t><t size='1'font='Bitstream'align='right'>%7</t><br/>
    <t size='1'font='Bitstream'align='left'color='#DDDDDD'>Headshots</t><t size='1'font='Bitstream'align='right'>%8</t><br/>
	<t size='1'font='Bitstream'align='left'color='#DDDDDD'>FPS</t><t size='1'font='Bitstream'align='right'>%9</t><br/>
	<t size='1'font='Bitstream'align='center'color='#16DB57'>Restart in %10 minutes!</t><br/>
    <t size='1'font='Bitstream'align='center'color='#DDDDDD'>----------------------</t><br/>",
	(name player),											//1
	r_player_blood,											//2
	(player getVariable['humanity', 0]),					//3
	(dayz_skilllevel),										//4
	(player getVariable['zombieKills', 0]),					//5
	(player getVariable['humanKills', 0]),					//6
	(player getVariable['banditKills', 0]),					//7
	(player getVariable['headShots', 0]),					//8
	((round diag_fps) + 10),								//9
	(/*Server Reset in minutes*/-(round(serverTime/60)))	//10
	//eg. (180-(round(serverTime/60))) for 3 hour resets
];

/*
player createDiarySubject ["MyDiary","My Diary"];
player createDiaryRecord ["MyDiary",["Stats", "Zombies Killed: <execute expression='player getVariable['zombieKills', 0]'</execute>"]];
player createDiaryRecord ["MyDiary",["Stats", "Headshots: <execute expression='player getVariable['headShots', 0]'</execute>"]];
player createDiaryRecord ["MyDiary",["Stats", "Murders: <execute expression='player getVariable['humanKills', 0]'</execute>"]];
player createDiaryRecord ["MyDiary",["Stats", "Bandits Killed: <execute expression='player getVariable['banditKills', 0]'</execute>"]];
player createDiaryRecord ["MyDiary",["Stats", "Humanity: <execute expression='player getVariable['humanity', 0]'</execute>"]];
*/