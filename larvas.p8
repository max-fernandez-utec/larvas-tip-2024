pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- larvas
-- copyleft 2024 - tip

--[[
  larvas (un demake de worms)
  copyright 2024
  by taller de videojuegos tip 2024
  is licensed under cc by-nc 4.0
]]

function _init()
	debug=true
	ents={}
	parts={}
	balas={}
	
	-- setup jugador
	jug=make_larva()
	jug.x=55
	jug.y=100
end

function _update()
	for e in all(ents) do
		e.upd()
	end
end

function _draw()
	cls(12)
	
	-- fondo
	rectfill(0,116,127,127,3)
	
	-- parte del frente
	for e in all(ents) do
		e.drw()
	end
	
	print("a="..jug.a..",p="..jug.p,7)
end


-->8
-- entidades
function make_entity()
	local e={}
	e.x=0
	e.y=0
	e.s=0
	e.dx=0
	e.dy=0
	e.fr=nil
	e.stat=nil
	
	add(ents,e)
	
	return e
end

function make_larva()
	local e=make_entity()
	e.s=1
	e.fh=true
	e.fr={
		walk={ 1,5 },
		idle={ 1,3 }
	}
	
	local idle="idle"
	local walk="walk"
	e.stat=idle
	
	e.a=0
	e.p=0
	e.d=false
	e.cx=5+(e.fh and 5 or 0)
	e.cy=11
	
	local va=0.01
	local dp=0.05
	local vlarva=1
	
	e.upd=function()
		e.cx=5+(e.fh and 5 or 0)
		
		e.stat=idle
		e.dx=0
		if btn(➡️) then
			e.fh=true
			e.stat=walk
			
			e.dx=vlarva
		end
		
		if btn(⬅️) then
			e.fh=false
			e.stat=walk
			
			e.dx=-vlarva
		end
		
		if (btn(⬆️)) jug.a=min(jug.a+va,1/4)
		if (btn(⬇️)) jug.a=max(jug.a-va,-1/4)
		
		if btn(❎) then
			e.d=true
			e.p+=dp
			e.p=min(1,e.p)
		end
		
		if e.d and not btn(❎) then
			make_disparo(e.x+e.cx,e.y+e.cy,e.p,e.a)
			e.p=0
			e.d=false
		end
		
		e.x+=e.dx
	end
	
	e.drw=function()
		local sps=e.fr[e.stat]
		e.s+=.25
		
		if flr(e.s)>#sps then
			e.s=1
		end
		-- dibujar cuerpo
		palt(0,false)
		palt(11,true)
		
		spr(sps[flr(e.s)],
			e.x+(e.fh and 8 or 0),
			e.y,1,2,
			e.fh)
	
		-- dibujar cola
		spr(sps[flr(e.s)]+17,
			e.x+(e.fh and 0 or 8),
			e.y+8,
			1,1,
			e.fh)
			
		palt()
			
		-- dibujar mira
		-- centro en (5,11)
		local md=24
		local mlado=e.fh and 1 or -1
		local mvx=e.x+e.cx+mlado*(md*cos(e.a))
		local mvy=e.y+e.cy+md*sin(e.a)
		
		if (debug) line(e.x+e.cx,e.y+e.cy,mvx,mvy,7)
		
		spr(2,mvx-3,mvy-3)
	end
	
	return e
end

function make_disparo (x,y,pod,ang)
	local e=make_entity()
	local vel=3
	
	add(balas,e)
	
	e.x=x
	e.y=y
	e.dx=vel*pod*cos(ang)
	e.dy=vel*pod*sin(ang)
	
	e.upd=function()
		e.x+=e.dx
		e.y+=e.dy
	end
	
	e.drw=function()
		circfill(e.x,e.y,3,10)
		circfill(e.x,e.y,2,9)
	end
end
__gfx__
00000000bbbbbbbb00666000bbbbbbbb00000000bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb4444bb06060600bbbbbbbb00000000b4444bbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700b4ffff4b60000060bb4444bb000000004ffff4bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b777fff466000660b4ffff4b00000000777fff4b00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b0707fff60000060b777fff4000000000707fffb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700b0707fff06060600b0707fff000000000707fffb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b7777fff00666000b0707fff000000007777ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb4fffff00000000b7777fff00000000b4ffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b4fffff4bbbbbbbbbbfffff4bbbbbbbbbb4fffffbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000
00000000b444fff4bbbbbbbbb444fff4bbbbbbbbbb444fff4bbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb4fffff444bbbbbbb4fffff444bbbbbbbb4ffff4bbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb4ffffffff4bbbbbb4ffffffff4bbbbbbb4fffff444bbbb000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb4ffffffff4bbbbbb4ffffffff4bbbbbbb4ffffffff4bbb000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb4fffffffff4bbbbb4fffffffff4bbbbbb4fffffffff4bb000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbb4ffff44fff4bbbbb4ffff44fff4bbbbbb4ffff444ff4b000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbb4444bb444bbbbbbb4444bb444bbbbbbbb4444bbb44bb000000000000000000000000000000000000000000000000000000000000000000000000
