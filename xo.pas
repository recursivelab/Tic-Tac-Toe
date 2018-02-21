program xo;
uses crt,sysutils;
var
        t:array[1..3,1..3] of char;
        player: char;

procedure init;
var
        i,j:integer;
begin
        player:='X';
        for i:=1 to 3 do
                for j:=1 to 3 do
                        t[i,j]:=' '
end;

procedure show;
var
        i,j:integer;
begin
        clrscr;
        writeln;
        writeln('   A B C');
        writeln('  +-+-+-+');
        for i:=1 to 3 do
        begin
                write(i, ' |');
                for j:=1 to 3 do
                        write(t[i,j],'|');
                writeln;
                writeln('  +-+-+-+')
        end;
        writeln
end;

procedure switch_player;
begin
        if player='X' then
                player:='O'
        else
                player:='X'
end;

procedure user_move;
var
        succ: boolean;
        ans: string;
        r,c: integer;
begin
        succ:=false;
        repeat
                write('Player''s ', player, ' move: ');
                readln(ans);
                if Length(ans)=2 then
                begin
                        c:=ord(ans[1])-ord('A')+1;
                        if c>32 then
                                c:=c-32;
                        r:=ord(ans[2])-ord('1')+1;
                        succ:=(r>=1) and (r<=3) and (c>=1) and (c<=3) and (t[r,c]=' ')
                end;
                if not succ then
                        writeln('Illegal input! Try again.')
        until succ;
        t[r,c]:=player;
        switch_player
end;

function full_table : boolean;
var
        i,j: integer;
begin
        for i:=1 to 3 do
                for j:=1 to 3 do
                        if t[i,j]=' ' then
                                exit(false);
        exit(true)
end;

function game_result : char;
var
        i: integer;
begin
        if t[2,2]<>' ' then
                if ((t[1,1]=t[2,2]) and (t[2,2]=t[3,3])) or ((t[1,3]=t[2,2]) and (t[2,2]=t[3,1])) then
                        exit(t[2,2]);
        for i:=1 to 3 do
                if (t[i,1]=t[i,2]) and (t[i,2]=t[i,3]) and (t[i,1]<>' ') then
                        exit(t[i,1])
                else if (t[1,i]=t[2,i]) and (t[2,i]=t[3,i]) and (t[1,i]<>' ') then
                        exit(t[1,i]);
        if full_table then
                exit('=');
        exit(' ')
end;

function game_over : boolean;
begin
        exit(game_result<>' ')
end;

function winning_side(move: boolean) : char;
var
        r,c,rb,cb: integer;
        w: char;
        looser: boolean;
begin
        looser:=true;
        rb:=0;
        w:=game_result;
        if w<>' ' then
                exit(w);
        for r:=1 to 3 do
                for c:=1 to 3 do
                        if t[r,c]=' ' then
                        begin
                                t[r,c]:=player;
                                switch_player;
                                w:=winning_side(false);
                                switch_player;
                                if w=player then
                                begin
                                        if move then
                                                switch_player
                                        else
                                                t[r,c]:=' ';
                                        exit(w);
                                end;
                                t[r,c]:=' ';
                                if rb=0 then
                                begin
                                        rb:=r;
                                        cb:=c
                                end;
                                if w in [' ', '='] then
                                        if looser then
                                        begin
                                                looser:=false;
                                                rb:=r;
                                                cb:=c
                                        end
                        end;
        if looser then
        begin
                if player='X' then
                        winning_side:='O'
                else
                        winning_side:='X'
        end
        else
                winning_side:=' ';
        if move then
        begin
                t[rb,cb]:=player;
                switch_player
        end
end;

function computer_move : char;
begin
        exit(winning_side(true))
end;

function input(prompt, answers: string) : char;
var
        ans: char;
        i: integer;
begin
        answers:=uppercase(answers);
        repeat
                write(prompt);
                readln(ans);
                if (ans>='a') and (ans<='z') then
                        ans:=chr(ord(ans)-32);
                for i:=1 to Length(answers) do
                        if ans=answers[i] then
                                exit(ans);
                writeln('Illegal answer! Try again.');
        until false;
end;

procedure play;
var
        r,x,o: char;
begin
        clrscr;
        repeat
                init;
                x:=input('Is player X, human or computer? (h/c): ', 'hc');
                o:=input('Is player O, human or computer? (h/c): ', 'hc');
                show;
                repeat
                        if ((player='X') and (x='H')) or ((player='O') and (o='H')) then
                                user_move
                        else
                                computer_move;
                        show;
                until game_over;
                r:=game_result;
                if r<>'=' then
                        writeln('Player ',r,' wins!')
                else
                        writeln('Draw!');
                writeln;
                r:=input('Play again? (y/n): ', 'yn')
        until r='N'
end;

begin
        play;
end.

