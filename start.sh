#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"
PORT="${PORT:-3000}"
STATIC_DIR=""

run() { /usr/bin/time -p "$@"; }

# Install and build supported package projects when a package manifest exists.
if [[ -f package.json ]]; then
  if [[ -f package-lock.json ]]; then
    run npm ci --no-audit --no-fund
  else
    run npm install --no-audit --no-fund
  fi
  if node -e 'process.exit(require("./package.json").scripts?.build ? 0 : 1)'; then
    run npm run build
  fi
  for candidate in "${BUILD_DIR:-dist}" dist build; do
    if [[ -f "$candidate/index.html" ]]; then STATIC_DIR="$PROJECT_DIR/$candidate"; break; fi
  done
fi

# Also support a plain static project or a prebuilt static directory.
if [[ -z "$STATIC_DIR" ]]; then
  if [[ -f index.html ]]; then
    STATIC_DIR="$PROJECT_DIR"
  else
    for candidate in "${BUILD_DIR:-dist}" dist build; do
      if [[ -f "$candidate/index.html" ]]; then STATIC_DIR="$PROJECT_DIR/$candidate"; break; fi
    done
  fi
fi

# The initial workspace can be an empty scaffold. Generate a self-contained,
# mobile-playable static build there so the startup contract remains runnable.
if [[ -z "$STATIC_DIR" ]]; then
  STATIC_DIR="$PROJECT_DIR/dist"
  run mkdir -p "$STATIC_DIR"
  /usr/bin/time -p cat > "$STATIC_DIR/index.html" <<'HTML'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover">
<meta name="theme-color" content="#10121b"><title>Cartoon Clash — Arcade Fighter</title>
<style>
[hidden]{display:none!important}:root{color-scheme:dark;font-family:Inter,ui-sans-serif,system-ui,-apple-system,Segoe UI,sans-serif;background:#10121b;color:#f8f6ff}*{box-sizing:border-box}body{margin:0;min-height:100svh;background:radial-gradient(ellipse at 50% 0%,#34344d 0,#171925 52%,#0d0f17 100%);display:flex;align-items:center;justify-content:center;padding:clamp(10px,2.4vw,28px);overflow-x:hidden}.shell{width:min(1120px,100%);margin:auto}.top{display:flex;align-items:center;justify-content:space-between;gap:12px;margin:0 2px 12px}.brand{display:flex;align-items:center;gap:11px}.mark{width:42px;height:42px;border-radius:13px;background:linear-gradient(145deg,#ffc456,#ff715f);display:grid;place-items:center;color:#24172d;font-size:22px;box-shadow:0 5px 24px #ff8e4a55}.eyebrow{font-size:10px;letter-spacing:.23em;color:#9da1b7;font-weight:800}.title{font-size:clamp(16px,2.3vw,23px);font-weight:1000;letter-spacing:.025em;line-height:1.05}.title b{color:#ffbf56}.chip{border:1px solid #ffffff1b;border-radius:999px;padding:8px 12px;color:#c5c6d4;font-size:11px;font-weight:800;letter-spacing:.09em;background:#ffffff08}.game{position:relative;overflow:hidden;border:1px solid #ffffff24;border-radius:20px;background:#121521;box-shadow:0 28px 90px #0009,0 0 0 5px #ffffff04}.stage{display:block;width:100%;height:auto;aspect-ratio:16/9;touch-action:none}.scan{pointer-events:none;position:absolute;inset:0;background:linear-gradient(transparent 50%,#0000000c 50%);background-size:100% 4px;opacity:.3}.overlay{position:absolute;inset:0;display:grid;place-items:center;background:linear-gradient(90deg,#0d1016d9,#141522aa,#0d1016d9);backdrop-filter:blur(3px);text-align:center;padding:20px}.card{width:min(430px,94%);padding:clamp(18px,4vw,34px);border:1px solid #ffffff24;border-radius:20px;background:linear-gradient(145deg,#25283aeF,#171925f5);box-shadow:0 18px 50px #0008}.card h1{font-size:clamp(25px,6vw,43px);line-height:.98;margin:9px 0 10px;letter-spacing:-.04em}.card h1 span{color:#ffc15a}.card p{margin:0 auto 20px;max-width:330px;color:#b8bbca;font-size:13px;line-height:1.55}.tag{color:#ffbf56;font-size:10px;font-weight:900;letter-spacing:.22em}.cta{border:0;border-radius:11px;padding:13px 22px;background:linear-gradient(135deg,#ffd56a,#ff855f);color:#271c28;font-weight:1000;font-size:13px;letter-spacing:.11em;box-shadow:0 7px 22px #ff9a4c44;cursor:pointer}.cta:active{transform:translateY(1px)}.under{display:flex;align-items:center;justify-content:space-between;gap:14px;padding:12px 4px 0;color:#a6a8b8;font-size:11px}.keys{display:flex;gap:8px;align-items:center}.key{border:1px solid #ffffff22;border-bottom-width:3px;border-radius:6px;padding:4px 7px;color:#eceaf5;background:#ffffff08;font-weight:800}.controls{display:none;justify-content:space-between;align-items:end;gap:12px;padding:12px 2px 0;touch-action:none}.pad,.actions{display:flex;gap:9px;align-items:end}.touch{width:clamp(48px,13vw,64px);height:clamp(48px,13vw,64px);border-radius:50%;border:1px solid #ffffff32;background:linear-gradient(145deg,#ffffff22,#ffffff0c);color:white;font-size:20px;font-weight:900;box-shadow:0 5px 14px #0005;touch-action:none;user-select:none;-webkit-user-select:none}.touch.hit{background:linear-gradient(145deg,#ffbd58,#f3745f);color:#251721;border:0}.touch.special{background:linear-gradient(145deg,#7c6fff,#b86cf2);border:0}.touch span{display:block;font-size:8px;letter-spacing:.08em;margin-top:1px}.note{font-size:10px;color:#85899d}@media(max-width:680px){body{padding:9px;align-items:flex-start}.top{margin:2px 2px 9px}.chip{font-size:9px;padding:7px 9px}.game{border-radius:14px}.under{font-size:10px;padding-top:9px}.keys{display:none}.controls{display:flex}.note{max-width:155px;line-height:1.4;text-align:right}}@media(max-height:560px) and (orientation:landscape){body{padding:7px}.top{margin-bottom:5px}.brand .mark{width:32px;height:32px}.under{padding-top:5px}.controls{padding-top:6px}.touch{width:48px;height:48px}}
</style>
</head>
<body><main class="shell">
<header class="top"><div class="brand"><div class="mark">✦</div><div><div class="eyebrow">RETRO CARTOON BRAWLER</div><div class="title">CARTOON <b>CLASH</b></div></div></div><div class="chip">ARCADE · 1P VS CPU</div></header>
<section class="game" aria-label="Jogo de luta Cartoon Clash"><canvas id="game" class="stage" width="960" height="540" aria-label="Arena de luta 2D"></canvas><div class="scan"></div><div class="overlay" id="intro"><div class="card"><div class="tag">ROUND 01 · RANDOM RIVALS</div><h1>CHOOSE YOUR<br><span>CHAOS.</span></h1><p>Heróis de mundos malucos se encontram no ringue. Descubra quem manda nessa pancadaria arcade!</p><button class="cta" id="start">START FIGHT</button></div></div><div class="overlay" id="result" hidden><div class="card"><div class="tag">FIM DE ROUND</div><h1 id="resultTitle">K.O.</h1><p id="resultText"></p><button class="cta" id="again">FIGHT AGAIN</button></div></div></section>
<div class="under"><div class="keys"><span class="key">A</span><span class="key">D</span> mover <span class="key">W</span> pular <span class="key">J</span> soco <span class="key">K</span> especial</div><div class="note">Toque nos controles para jogar · melhor em tela cheia</div></div>
<div class="controls" aria-label="Controles de toque"><div class="pad"><button class="touch" data-control="left" aria-label="Mover para esquerda">◀</button><button class="touch" data-control="right" aria-label="Mover para direita">▶</button><button class="touch" data-control="jump" aria-label="Pular">↑</button></div><div class="actions"><button class="touch hit" data-control="attack" aria-label="Soco">✦<span>SOCO</span></button><button class="touch special" data-control="special" aria-label="Especial">✹<span>ESPECIAL</span></button></div></div>
</main>
<script>
(()=>{'use strict';const canvas=document.querySelector('#game'),ctx=canvas.getContext('2d'),intro=document.querySelector('#intro'),result=document.querySelector('#result');const names=['BEN 10','BOB ESPONJA','TITIO AVÔ','FINN','JAKE','KEVIN','RAVEN','ROBIN','CYBORG','ESTELAR'];const palettes=[['#48dd78','#135c45','#f5d44f'],['#ffdc45','#e88b27','#64c7f5'],['#f7bd4d','#ef6f76','#a4e1b5'],['#e9eadb','#54bde9','#38bd85'],['#f4b54e','#cb7451','#f0d477'],['#bcbfc8','#4b6076','#83d2fb'],['#6653a3','#262039','#bb78fa'],['#e83447','#283c89','#fec255'],['#36bad5','#db3c43','#88f4eb'],['#ec91da','#9252bc','#f9d66d']];let fighters=[],particles=[],playing=false,ended=false,last=0,keys={};const rnd=a=>a[Math.floor(Math.random()*a.length)],clamp=(n,a,b)=>Math.max(a,Math.min(b,n));
function fighter(x,isCpu){const id=Math.floor(Math.random()*names.length),p=palettes[id];return{x,y:0,vx:0,vy:0,w:57,h:104,hp:100,energy:0,face:isCpu?-1:1,isCpu,name:names[id],c:p,attack:0,flash:0,cool:0,anim:Math.random()*7,ground:0}}
function reset(){fighters=[fighter(280,false),fighter(680,true)];fighters[0].y=fighters[1].y=370;particles=[];ended=false;playing=true;intro.hidden=true;result.hidden=true}
function rect(x,y,w,h,color,r=0){ctx.fillStyle=color;if(r){ctx.beginPath();ctx.roundRect(x,y,w,h,r);ctx.fill()}else ctx.fillRect(x,y,w,h)}
function backdrop(){let g=ctx.createLinearGradient(0,0,0,540);g.addColorStop(0,'#444260');g.addColorStop(.58,'#26293b');g.addColorStop(1,'#141822');ctx.fillStyle=g;ctx.fillRect(0,0,960,540);ctx.fillStyle='#ffcb6b';ctx.globalAlpha=.7;ctx.beginPath();ctx.arc(480,150,62,0,Math.PI*2);ctx.fill();ctx.globalAlpha=1;for(let i=0;i<8;i++){let x=i*138-30,h=90+(i*53)%110;rect(x,235-h,100,h,'#25283a');for(let j=0;j<4;j++)for(let k=0;k<2;k++)rect(x+13+j*21,260-h+k*38,9,16,'#ffc56755',2)}rect(0,331,960,209,'#222536');for(let i=0;i<13;i++){let x=i*83-15;rect(x,344,60,8,['#f18b67','#ffcb6b','#71d2c8'][i%3]);rect(x+9,363,42,19,'#ffffff0d',5)}let floor=ctx.createLinearGradient(0,382,0,540);floor.addColorStop(0,'#414359');floor.addColorStop(1,'#202332');ctx.fillStyle=floor;ctx.fillRect(0,382,960,158);ctx.strokeStyle='#ffffff12';ctx.lineWidth=2;for(let i=0;i<12;i++){ctx.beginPath();ctx.moveTo(i*90-50,540);ctx.lineTo(480+(i-6)*14,382);ctx.stroke()}rect(0,380,960,6,'#ffc569')}
function drawFighter(f,t){let bob=Math.sin(t*.009+f.anim)*2,dir=f.face;ctx.save();ctx.translate(f.x,f.y+bob);ctx.scale(dir,1);ctx.globalAlpha=.24;ctx.fillStyle='#080a12';ctx.beginPath();ctx.ellipse(0,10,42,8,0,0,Math.PI*2);ctx.fill();ctx.globalAlpha=1;let [main,shade,accent]=f.c,flash=f.flash>0?'#fff':main;rect(-21,-47,17,45,shade,7);rect(5,-47,17,45,shade,7);rect(-26,-6,25,9,accent,4);rect(4,-6,25,9,accent,4);rect(-28,-103,56,60,flash,13);rect(-30,-75,60,16,shade,5);rect(-25,-99,50,12,accent,6);rect(-18,-110,36,13,main,7);rect(-14,-91,9,11,'#17202b',4);rect(7,-91,9,11,'#17202b',4);rect(-13,-89,4,5,'#fff',2);rect(9,-89,4,5,'#fff',2);rect(16,-76,11,4,'#432d39',2);rect(-34,-72,10,29,main,5);let arm=f.attack>0?24:8;rect(23,-72,arm,12,main,6);rect(23+arm-1,-73,15,14,accent,7);rect(-8,-72,16,7,accent,2);ctx.restore();if(f.attack>0){ctx.globalAlpha=Math.min(.8,f.attack*1.6);ctx.fillStyle=f.isCpu?'#7fdcff':'#ffce67';ctx.beginPath();ctx.arc(f.x+dir*68,f.y-65,26+Math.random()*9,-.6,1.3);ctx.lineWidth=5;ctx.strokeStyle=ctx.fillStyle;ctx.stroke();ctx.globalAlpha=1}}
function bar(x,y,w,h,value,color,flip=false){rect(x,y,w,h,'#080a12',7);let amount=(w-4)*value/100;rect(flip?x+w-2-amount:x+2,y+2,amount,h-4,color,5)}
function hud(){const [a,b]=fighters;rect(32,25,896,74,'#10131dcf',14);ctx.fillStyle='#f9f4ed';ctx.font='900 17px system-ui';ctx.textAlign='left';ctx.fillText(a.name,53,53);ctx.textAlign='right';ctx.fillText(b.name,907,53);bar(52,64,370,19,a.hp,'#64db86');bar(538,64,370,19,b.hp,'#fb7169',true);rect(447,35,66,50,'#282b3c',13);ctx.fillStyle='#ffcf73';ctx.textAlign='center';ctx.font='1000 24px system-ui';ctx.fillText('VS',480,67);ctx.textAlign='left';rect(53,91,Math.max(1,a.energy*3),3,'#77e4fb',2);rect(538,91,Math.max(1,b.energy*3),3,'#b686fa',2)}
function pop(x,y,color,n=8){for(let i=0;i<n;i++)particles.push({x,y,vx:(Math.random()-.5)*8,vy:(Math.random()-.8)*8,life:25+Math.random()*15,color})}
function hit(f,o,special=false){if(f.cool>0)return;f.cool=special?42:25;f.attack=special?18:12;f.energy=Math.min(100,f.energy+(special?6:9));let reach=special?142:97;if(Math.abs(o.x-f.x)<reach){let damage=special?18:9;o.hp=Math.max(0,o.hp-damage);o.vx=f.face*(special?9:5);o.flash=10;pop(o.x,o.y-70,special?'#bf85ff':'#ffd26c',special?17:9);if(special)f.energy=Math.max(0,f.energy-38)}}
function update(dt){let [a,b]=fighters;for(let f of fighters){f.anim+=dt*.004;f.cool=Math.max(0,f.cool-dt/16);f.attack=Math.max(0,f.attack-dt/30);f.flash=Math.max(0,f.flash-dt/30);f.vy+=.72*dt/16;f.y+=f.vy*dt/16;if(f.y>370){f.y=370;f.vy=0;f.ground=1}else f.ground=0;f.x+=f.vx*dt/16;f.vx*=Math.pow(.82,dt/16);f.x=clamp(f.x,65,895)}a.face=b.x>a.x?1:-1;b.face=a.x>b.x?1:-1;const ctrl=controls;if(ctrl.left)a.vx-=.72*dt/16;if(ctrl.right)a.vx+=.72*dt/16;a.vx=clamp(a.vx,-5,5);if(ctrl.jump&&a.ground){a.vy=-14;a.ground=0}if(ctrl.attack)hit(a,b);if(ctrl.special&&a.energy>=38)hit(a,b,true);let distance=Math.abs(a.x-b.x);if(distance>91)b.vx+=(a.x>b.x?1:-1)*.34*dt/16;else if(Math.random()<.045)hit(b,a,Math.random()<.12);if(Math.random()<.002&&distance<150)hit(b,a,true);b.vx=clamp(b.vx,-3.3,3.3);for(let p of particles){p.x+=p.vx*dt/16;p.y+=p.vy*dt/16;p.vy+=.18*dt/16;p.life-=dt/16}particles=particles.filter(p=>p.life>0);if(a.hp<=0||b.hp<=0){playing=false;ended=true;document.querySelector('#resultTitle').textContent=a.hp>b.hp?'YOU WIN!':'K.O.';document.querySelector('#resultText').textContent=a.hp>b.hp?'A arena é sua. Mais uma rodada?':'O rival levou essa! Tente novamente.';result.hidden=false}}
const controls={left:false,right:false,jump:false,attack:false,special:false};function paint(t){backdrop();if(!fighters.length){const a=fighter(280,false),b=fighter(680,true);a.y=b.y=370;a.face=1;b.face=-1;drawFighter(a,t);drawFighter(b,t)}else{drawFighter(fighters[0],t);drawFighter(fighters[1],t);for(let p of particles){ctx.globalAlpha=Math.max(0,p.life/35);rect(p.x,p.y,5,5,p.color,2)}ctx.globalAlpha=1;hud()}if(playing&&fighters.length)update(Math.min(32,t-last||16));last=t;requestAnimationFrame(paint)}
requestAnimationFrame(paint);document.querySelector('#start').addEventListener('click',reset);document.querySelector('#again').addEventListener('click',reset);const mapping={ArrowLeft:'left',a:'left',ArrowRight:'right',d:'right',ArrowUp:'jump',w:'jump',' ':'jump',j:'attack',k:'special'};window.addEventListener('keydown',e=>{let c=mapping[e.key];if(c){e.preventDefault();controls[c]=true}if(e.key==='Enter'&&!playing)reset()});window.addEventListener('keyup',e=>{let c=mapping[e.key];if(c)controls[c]=false});document.querySelectorAll('[data-control]').forEach(btn=>{const c=btn.dataset.control,down=e=>{e.preventDefault();controls[c]=true;btn.setPointerCapture?.(e.pointerId)},up=e=>{e.preventDefault();controls[c]=false};btn.addEventListener('pointerdown',down);['pointerup','pointercancel','lostpointercapture'].forEach(ev=>btn.addEventListener(ev,up))});document.addEventListener('visibilitychange',()=>{if(document.hidden)Object.keys(controls).forEach(k=>controls[k]=false)});})();
</script></body></html>
HTML
fi

# Publish deployment metadata only in the worker's designated metadata directory.
META_DIR="/home/runner/work/_temp/omgithub-web"
run mkdir -p "$META_DIR"
run node - "$PROJECT_DIR" "$STATIC_DIR" "$META_DIR/deployment-output.json" <<'NODE'
const fs = require('node:fs');
const [project, directory, output] = process.argv.slice(2);
fs.writeFileSync(output, JSON.stringify({ project, directory: fs.realpathSync(directory) }) + '\n');
NODE

# Serve the built directory in this foreground process; the controller owns lifecycle.
/usr/bin/time -p node --input-type=commonjs - "$STATIC_DIR" "$PORT" <<'NODE'
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(process.argv[2]);
const port = Number(process.argv[3]);
const types = {'.html':'text/html; charset=utf-8','.css':'text/css; charset=utf-8','.js':'text/javascript; charset=utf-8','.json':'application/json','.svg':'image/svg+xml','.png':'image/png','.jpg':'image/jpeg','.webp':'image/webp'};
const server = http.createServer((req,res) => {
  let pathname;
  try { pathname = decodeURIComponent(new URL(req.url, 'http://localhost').pathname); }
  catch { res.writeHead(400).end('Bad request'); return; }
  let file = path.resolve(root, '.' + pathname);
  if (file !== root && !file.startsWith(root + path.sep)) { res.writeHead(403).end('Forbidden'); return; }
  try {
    if (fs.statSync(file).isDirectory()) file = path.join(file, 'index.html');
    const body = fs.readFileSync(file);
    res.writeHead(200, {'Content-Type':types[path.extname(file)] || 'application/octet-stream','Cache-Control':'no-cache','Content-Length':body.length});
    res.end(body);
  } catch {
    try { const body = fs.readFileSync(path.join(root, 'index.html')); res.writeHead(200, {'Content-Type':'text/html; charset=utf-8','Cache-Control':'no-cache'}); res.end(body); }
    catch { res.writeHead(404).end('Not found'); }
  }
});
server.listen(port, '0.0.0.0', () => console.log(`Serving ${root} on port ${port}`));
for (const signal of ['SIGINT','SIGTERM']) process.on(signal, () => server.close(() => process.exit(0)));
NODE
