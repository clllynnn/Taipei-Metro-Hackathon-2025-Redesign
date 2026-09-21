const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];

const state = {
  tab: location.hash.replace('#', '') || 'home',
  language: localStorage.getItem('metroGo.language') || 'zh',
  mode: 'normal',
  origin: '台北車站',
  destination: '市政府',
  countdown: 222,
  mapScale: 1,
  playing: true,
  checkedIn: localStorage.getItem('metroGo.checkedIn') === 'true',
  points: Number(localStorage.getItem('metroGo.points') || 0),
  streak: Number(localStorage.getItem('metroGo.streak') || 1),
  drawState: localStorage.getItem('metroGo.drawState') || 'available',
  onboardingPage: 0,
  touristLanguageIndex: 0,
};

const stations = [
  { name: '淡水', code: 'R28', line: 'red', x: 92, y: 90, minute: 37 },
  { name: '北投', code: 'R22', line: 'red', x: 210, y: 90, minute: 30 },
  { name: '士林', code: 'R16', line: 'red', x: 330, y: 180, minute: 22 },
  { name: '民權西路', code: 'R13／O11', line: 'orange', x: 330, y: 335, minute: 14, interchange: true },
  { name: '中山', code: 'R11／G14', line: 'green', x: 330, y: 405, minute: 8, interchange: true },
  { name: '台北車站', code: 'R10／BL12', line: 'red', x: 330, y: 455, minute: 0, interchange: true },
  { name: '西門', code: 'G12／BL11', line: 'blue', x: 245, y: 455, minute: 4, interchange: true },
  { name: '古亭', code: 'G09／O05', line: 'green', x: 300, y: 545, minute: 11, interchange: true },
  { name: '公館', code: 'G07', line: 'green', x: 350, y: 610, minute: 16 },
  { name: '新店', code: 'G01', line: 'green', x: 400, y: 685, minute: 28 },
  { name: '板橋', code: 'BL07／Y16', line: 'blue', x: 125, y: 455, minute: 17, interchange: true },
  { name: '忠孝新生', code: 'BL14／O07', line: 'blue', x: 355, y: 455, minute: 4, interchange: true },
  { name: '忠孝復興', code: 'BL15／BR10', line: 'blue', x: 382, y: 455, minute: 6, interchange: true },
  { name: '市政府', code: 'BL18', line: 'blue', x: 438, y: 455, minute: 12 },
  { name: '南港展覽館', code: 'BL23／BR24', line: 'brown', x: 470, y: 300, minute: 27, interchange: true },
  { name: '松山機場', code: 'BR13', line: 'brown', x: 382, y: 300, minute: 15 },
  { name: '大安', code: 'R05／BR09', line: 'red', x: 330, y: 610, minute: 19, interchange: true },
  { name: '台北101/世貿', code: 'R03', line: 'red', x: 330, y: 650, minute: 22 },
  { name: '象山', code: 'R02', line: 'red', x: 330, y: 690, minute: 24 },
  { name: '景安', code: 'O02／Y11', line: 'orange', x: 230, y: 610, minute: 22, interchange: true },
  { name: '大坪林', code: 'G04／Y07', line: 'green', x: 350, y: 650, minute: 23, interchange: true },
];

const translations = {
  zh: {
    brand: '台北捷運', context: '下班時間，準備回家嗎？', alert: '淡水信義線：台北車站月台人潮較多，請留意月台安全。',
    location: '已定位台北車站', locationHint: 'AI 已依照你的通勤習慣準備路線', origin: '起點', destination: '目的地', toward: '往', updated: '即時更新',
    crowding: '車廂擁擠度', crowdingValue: '普通', quick: '快速切換常用目的地', services: '捷運生活與商業服務',
    nav: ['首頁','路線圖','捷客電台','功能服務','會員中心'], direction: '南港展覽館'
  },
  en: {
    brand: 'Taipei Metro GO', context: 'Heading home after work?', alert: 'Tamsui–Xinyi Line: Platforms at Taipei Main Station are busy. Please take care.',
    location: 'Taipei Main Station located', locationHint: 'AI prepared this route from your commute pattern', origin: 'From', destination: 'To', toward: 'Toward', updated: 'Live',
    crowding: 'Crowding', crowdingValue: 'Moderate', quick: 'Switch favorite destination', services: 'Metro services',
    nav: ['Home','Map','MetroTogether','Services','Account'], direction: 'Nangang Exhibition Center'
  },
  ja: {
    brand: '台北メトロ', context: 'お仕事帰りですか？', alert: '淡水信義線：台北駅のホームは混雑しています。足元にご注意ください。',
    location: '台北駅にいます', locationHint: '通勤履歴からルートを用意しました', origin: '出発', destination: '目的地', toward: '方面', updated: 'ライブ',
    crowding: '混雑状況', crowdingValue: '普通', quick: 'よく使う目的地', services: '地下鉄サービス',
    nav: ['ホーム','路線図','MetroTogether','サービス','アカウント'], direction: '南港展覧館'
  },
  ko: {
    brand: '타이베이 메트로', context: '퇴근길인가요?', alert: '단수이–신이선: 타이베이 메인역 승강장이 혼잡합니다. 안전에 유의하세요.',
    location: '타이베이 메인역', locationHint: '통근 패턴에 맞춰 경로를 준비했어요', origin: '출발', destination: '도착', toward: '방면', updated: '실시간',
    crowding: '혼잡도', crowdingValue: '보통', quick: '자주 가는 목적지', services: '지하철 서비스',
    nav: ['홈','노선도','MetroTogether','서비스','계정'], direction: '난강 전람관'
  }
};

const serviceCatalog = [
  { category: '即時乘車資訊', subtitle: '到站時間、路線狀況與列車動態', icon: 'LIVE', items: [
    ['列車到站時刻','查看各站列車到站時間、發車資訊與末班車時刻'],['列車／路線擁擠度','查詢列車車廂與各路線即時擁擠狀況'],['動態資訊','掌握列車運行、路線狀態與即時乘車動態'],['誤點證明','查詢列車延誤紀錄並申請誤點證明'],['相約列車','分享搭乘資訊，和朋友相約同行'],['車站資訊','查詢車站出口、電梯與站內設施']
  ]},
  { category: '貼心與通勤輔助', subtitle: '提醒、協尋與旅遊票券服務', icon: 'GO', items: [
    ['下車提醒','設定目的地與到站提醒，避免坐過站'],['遺失物協尋','登記遺失物或搜尋捷運拾獲物品'],['貓纜購票','快速選購貓空纜車乘車票券'],['捷運旅遊票優惠','查詢捷運旅遊票種、搭乘方案與優惠'],['無障礙旅運','規劃友善的無障礙乘車路線與站內動線']
  ]},
  { category: '會員與票卡服務', subtitle: '票卡、回饋、減碳紀錄與優惠', icon: 'CARD', items: [
    ['我的票卡／乘車碼','管理常用票卡、乘車碼與乘車紀錄'],['常客優惠查詢','查詢常客優惠資格、回饋與使用紀錄'],['碳排／減碳紀錄','查看搭乘捷運累積的減碳數據'],['捷運點數','查看點數、累積紀錄並兌換好禮'],['優惠券專區','領取、查詢與使用會員優惠券']
  ]},
  { category: '周邊生活與地圖', subtitle: '探索捷運沿線美食、景點與生活設施', icon: 'MAP', items: [
    ['Go! Map','探索美食、夜市、景點與車站周邊生活設施'],['捷運旅遊趣','發現捷運沿線旅遊提案、熱門景點與活動'],['沿線景點','發現沿線熱門景點與當季活動'],['捷運商城','逛逛車站商店與精選優惠']
  ]},
];

const onboardingPages = [
  { title: '智慧通勤，準時掌握', description: 'AI 自動預測你的常用起終點，開啟 App 即可秒查進站倒數與車廂擁擠度，趕車不再慌張。', demo: 'commute' },
  { title: '自由查站，精準出口指引', description: '點擊地圖任意車站即可查看廁所、電梯與超商出口；系統更會推薦最快出站／轉乘車廂。', demo: 'map' },
  { title: '專屬模式，隨時切換', description: '為觀光客提供全段電梯與多語系導航；為無障礙族群提供語音問答與安心的實體求助反饋。', demo: 'mode' },
];

function escapeHtml(value) {
  return String(value).replace(/[&<>'"]/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[char]));
}

function stationByName(name) { return stations.find(station => station.name === name) || stations[5]; }

function lineClass(station) { return `line-${station.line}`; }

function switchTab(tab, updateHash = true) {
  const target = $(`[data-screen="${tab}"]`);
  if (!target) tab = 'home';
  state.tab = tab;
  $$('.screen').forEach(screen => {
    const active = screen.dataset.screen === tab;
    screen.hidden = !active;
    screen.classList.toggle('is-active', active);
  });
  $$('[data-tab]').forEach(button => button.classList.toggle('is-active', button.dataset.tab === tab));
  if (updateHash) history.replaceState(null, '', `#${tab}`);
  $('#appMain').scrollTop = 0;
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function applyLanguage(language) {
  state.language = language;
  localStorage.setItem('metroGo.language', language);
  document.documentElement.lang = language === 'zh' ? 'zh-Hant' : language;
  const t = translations[language];
  $('#brandTitle').textContent = t.brand;
  $('#contextTitle').textContent = t.context;
  $('#alertText').textContent = t.alert;
  $('#locationLabel').textContent = t.location;
  $('#locationHint').textContent = t.locationHint;
  $('#originLabel').textContent = t.origin;
  $('#destinationLabel').textContent = t.destination;
  $('#towardLabel').textContent = t.toward;
  $('#updatedText').textContent = t.updated;
  $('#crowdingLabel').textContent = t.crowding;
  $('#crowdingValue').textContent = t.crowdingValue;
  $('#quickRouteLabel').textContent = t.quick;
  $('#metroServicesTitle').textContent = t.services;
  $('#directionName').textContent = t.direction;
  $$('[data-tab] small').forEach((label, index) => label.textContent = t.nav[index]);
  $$('.language-options button').forEach(button => button.classList.toggle('is-selected', button.dataset.language === language));
}

function updateRouteUI() {
  const origin = stationByName(state.origin);
  const destination = stationByName(state.destination);
  $('#originName').textContent = origin.name;
  $('#destinationName').textContent = destination.name;
  $('#originCode').textContent = origin.code.split('／')[0];
  $('#destinationCode').textContent = destination.code.split('／')[0];
  $('#originCode').className = `line-code ${lineClass(origin)}`;
  $('#destinationCode').className = `line-code ${lineClass(destination)}`;
  $('#mapOrigin').textContent = `${origin.name}⌄`;
  $('#mapDestination').textContent = `${destination.name}⌄`;
  $('#locationLabel').textContent = `${translations[state.language].location.split('台北車站').join(origin.name)}`;
  const difference = Math.abs(destination.minute - origin.minute);
  const transfers = origin.line === destination.line ? 0 : (origin.interchange || destination.interchange ? 1 : 2);
  $('#transferCount').textContent = `轉乘 ${transfers} 次`;
  $('#travelMinutes').textContent = `約 ${Math.max(3, difference + transfers * 4)} 分鐘`;
  $$('.station-node').forEach(node => {
    node.classList.toggle('is-current', node.dataset.station === state.origin);
    node.classList.toggle('is-destination', node.dataset.station === state.destination);
  });
}

function renderMap() {
  $('#stationNodes').innerHTML = stations.map(station => `
    <g class="station-node ${station.interchange ? 'is-interchange' : ''}" data-station="${station.name}" transform="translate(${station.x} ${station.y})" role="button" tabindex="0" aria-label="${station.name}站 ${station.code}">
      <circle r="${station.interchange ? 10 : 7}"></circle>
      <text x="${station.x > 390 ? -13 : 13}" y="-12" text-anchor="${station.x > 390 ? 'end' : 'start'}">${station.name}</text>
    </g>`).join('');
  updateRouteUI();
}

function renderServices(query = '') {
  const normalized = query.trim().toLocaleLowerCase();
  let found = 0;
  const html = serviceCatalog.map((category, categoryIndex) => {
    const items = category.items.filter(item => !normalized || `${item[0]} ${item[1]} ${category.category}`.toLocaleLowerCase().includes(normalized));
    if (!items.length) return '';
    found += items.length;
    return `<section class="service-category">
      <header><span class="category-icon">${category.icon}</span><div><h2>${category.category}</h2><p>${category.subtitle}</p></div></header>
      <div class="service-grid">${items.map((item, itemIndex) => `<button class="service-item ${(categoryIndex === 0 && itemIndex < 2 && !normalized) ? 'is-recommended' : ''}" data-service="${escapeHtml(item[0])}"><span>${String(item[0]).slice(0,1)}</span><div><strong>${item[0]}</strong><small>${item[1]}</small></div></button>`).join('')}</div>
    </section>`;
  }).join('');
  $('#serviceList').innerHTML = found ? html : '<div class="empty-results">找不到相符服務，試試「票卡」或「到站」。</div>';
}

function renderWaveform() {
  $('#waveform').innerHTML = Array.from({length: 28}, (_, index) => `<i style="height:${7 + (index * 13 % 21)}px;animation-delay:${index * 37}ms"></i>`).join('');
  $('#waveform').classList.toggle('is-paused', !state.playing);
}

function setMode(mode) {
  state.mode = mode;
  $('#standardHome').hidden = mode !== 'normal';
  $('#touristMode').hidden = mode !== 'tourist';
  $('#accessibleMode').hidden = mode !== 'accessible';
  $('.tabbar').hidden = mode === 'accessible';
  $('#appMain').style.paddingBottom = mode === 'accessible' ? '0' : '';
  $('#settingsMenu').hidden = true;
  $$('[data-mode]').forEach(button => button.lastElementChild.textContent = button.dataset.mode === mode ? '✓' : '›');
}

function showToast(message, duration = 2200) {
  const toast = $('#toast');
  toast.textContent = message;
  toast.hidden = false;
  clearTimeout(showToast.timer);
  showToast.timer = setTimeout(() => toast.hidden = true, duration);
}

function openSheet({ kicker = 'Taipei Metro Go', title, body }) {
  $('#sheetKicker').textContent = kicker;
  $('#sheetTitle').textContent = title;
  $('#sheetBody').innerHTML = body;
  $('#sheetBackdrop').hidden = false;
  $('#bottomSheet').hidden = false;
  document.body.style.overflow = 'hidden';
  $('#closeSheet').focus();
}

function closeSheet() {
  $('#sheetBackdrop').hidden = true;
  $('#bottomSheet').hidden = true;
  document.body.style.overflow = '';
}

function openStationPicker(target) {
  const selected = target === 'origin' ? state.origin : state.destination;
  openSheet({
    kicker: target === 'origin' ? '目前位置' : '路線規劃',
    title: target === 'origin' ? '選擇目前站點' : '選擇目的地',
    body: `<div class="sheet-options">${stations.map(station => `<button class="${station.name === selected ? 'is-selected' : ''}" data-station-choice="${station.name}" data-target="${target}"><span><b class="line-code ${lineClass(station)}" style="height:34px;width:34px;min-width:34px;writing-mode:horizontal-tb">${station.code.split('／')[0]}</b><strong>${station.name}</strong></span><small>${station.name === selected ? '目前選擇 ✓' : station.code}</small></button>`).join('')}</div>`
  });
}

function openStationDetails(name) {
  const station = stationByName(name);
  openSheet({
    kicker: `${station.code} · 車站資訊`, title: `${station.name}站`,
    body: `<div class="facility-pills"><span>♿ 無障礙電梯</span><span>🚻 廁所</span><span>i 服務台</span><span>↗ 出口指引</span></div>
      <div class="sheet-info-card"><h3>建議出口</h3><p>${station.name === '台北車站' ? 'M4／台鐵高鐵：前往台鐵、高鐵與地下街連通道。' : '1 號出口：靠近主要大廳與無障礙動線。'}</p></div>
      <div class="sheet-info-card"><h3>乘車建議</h3><p>建議搭乘第 3 車廂，抵達後較靠近電梯與主要轉乘通道。</p></div>
      <button class="primary-button" style="margin-top:12px" data-set-destination="${station.name}">設為目的地</button>`
  });
}

function openSimpleSheet(type) {
  const sheets = {
    pass: ['票卡與乘車碼','旅遊票卡', '<div class="sheet-info-card"><h3>24 小時票</h3><p>啟用後 24 小時內不限次數搭乘台北捷運。</p></div><div class="sheet-info-card"><h3>QR 乘車碼</h3><p>目前有 2 張可用票券。這是概念原型，不會產生真實票證。</p></div>'],
    locker: ['台北車站 · 即時資訊','行李寄放', '<div class="sheet-info-card"><h3>M3 出口智慧置物櫃</h3><p>大型 4 格、中型 12 格可用。步行約 3 分鐘。</p></div><div class="sheet-info-card"><h3>站內服務中心</h3><p>可協助大型行李與無障礙旅客寄放需求。</p></div>'],
    airport: ['機場轉乘','前往桃園機場', '<div class="sheet-info-card"><h3>建議路線</h3><p>台北車站下車後，依「桃園機場捷運」指標前往 A1 台北車站；全程約 42 分鐘。</p></div>'],
    assist: ['站務支援','需要協助', '<div class="sheet-info-card"><h3>已定位：台北車站</h3><p>可通知最近的站務人員前來協助，原型將示範完整回報流程。</p></div><button class="primary-button" style="margin-top:12px" data-assist-now>通知站務人員</button>'],
    profile: ['會員中心','個人資料', '<div class="sheet-info-card"><h3>林怡君</h3><p>帳號 08•• ••42<br>資料編輯服務將在串接正式會員系統後提供。</p></div>'],
    points: ['會員回饋','捷運點數', '<div class="sheet-info-card"><h3>目前點數 1,280 點</h3><p>最近獲得：搭乘捷運 +12、每日簽到 +10、點數折抵 −30。</p></div>'],
    carbon: ['綠色通勤','累積減碳', '<div class="sheet-info-card"><h3>128.4 kg CO₂e</h3><p>已解鎖「綠色通勤達人」與「減碳百里捷人」徽章。</p></div>'],
    rides: ['乘車分析','最近搭乘', '<div class="sheet-info-card"><h3>市政府 → 台北車站</h3><p>今天 · 板南線 · NT$20</p></div><div class="sheet-info-card"><h3>忠孝復興 → 市政府</h3><p>昨天 · 板南線 · NT$20</p></div><div class="sheet-info-card"><h3>大安 → 忠孝復興</h3><p>2 天前 · 文湖線 · NT$20</p></div>'],
  };
  const entry = sheets[type];
  if (entry) openSheet({ kicker: entry[0], title: entry[1], body: entry[2] });
}

function updateRadioState() {
  $('#metroPoints').textContent = state.points;
  $('#streakDays').textContent = `${state.streak} 天`;
  $('#lotteryChance').textContent = `${Math.min(50, 5 + Math.max(0, state.streak - 1))}%`;
  if (state.checkedIn) {
    $('#checkinButton strong').textContent = '查看今日點播';
    $('#checkinButton small').textContent = '已送出，等待今日抽選';
    $('#rewardPoints').textContent = '已登記';
    $('#drawHeadline').textContent = state.drawState === 'available' ? '抽選券已投入，結果等你親自揭曉' : (state.drawState === 'winner' ? '你的歌被選中了，今天會陪著沿線乘客' : '這次差一點，點播紀錄仍會保留');
    $('#drawStatus').textContent = state.drawState === 'available' ? '可揭曉' : (state.drawState === 'winner' ? '已中選' : '已開獎');
    const digits = ['0','7','2','9','1','8'];
    $('#ticketDigits').innerHTML = digits.map(digit => `<span>${digit}</span>`).join('');
    $('#drawButton').disabled = state.drawState !== 'available';
    $('#drawButton').textContent = state.drawState === 'available' ? '揭曉今日結果' : (state.drawState === 'winner' ? '中選歌曲已加入今日幸運電台' : '點播內容已保留');
  }
}

function openSongCheckIn() {
  if (state.checkedIn) {
    openSheet({ kicker:'今日點播', title:'等待幸運抽選', body:'<div class="sheet-info-card"><h3>旅行的意義</h3><p>回家的路上聽著這首歌，提醒自己慢一點也沒關係。</p></div><p style="color:var(--muted);font-size:.78rem">抽選號碼 MRT-072918 已投入今日抽選。</p>' });
    return;
  }
  openSheet({
    kicker: '每日簽到 · 完成可獲 7 點', title: '留下一首陪伴通勤的歌',
    body: '<form id="songForm"><div class="form-field"><label for="songTitle">歌曲名稱</label><input id="songTitle" required placeholder="例如：旅行的意義"></div><div class="form-field"><label for="songStory">想送給乘客的一段話</label><textarea id="songStory" required placeholder="說說這首歌為什麼陪伴你"></textarea></div><button class="primary-button" type="submit">送出今日點播</button></form>'
  });
}

function completeCheckIn() {
  state.checkedIn = true;
  state.points += 7;
  state.streak = Math.max(1, state.streak + 1);
  localStorage.setItem('metroGo.checkedIn', 'true');
  localStorage.setItem('metroGo.points', state.points);
  localStorage.setItem('metroGo.streak', state.streak);
  updateRadioState();
  closeSheet();
  showToast('點播已送出，獲得 7 捷運點');
}

function revealDraw() {
  if (!state.checkedIn || state.drawState !== 'available') return;
  const won = Math.random() > 0.45;
  state.drawState = won ? 'winner' : 'notSelected';
  localStorage.setItem('metroGo.drawState', state.drawState);
  updateRadioState();
  openSheet({
    kicker: '每日幸運抽選', title: won ? '恭喜，你的歌被選中了！' : '這次差一點',
    body: `<div class="emergency-status"><div class="pulse">${won ? '★' : '♪'}</div><h3>${won ? '今天會陪著沿線乘客' : '歌曲與故事已為你保留'}</h3><p>${won ? '你的點播將加入今日幸運電台。' : '明天可以一鍵沿用，抽獎權重也會持續累積。'}</p></div>`
  });
}

function openCommunity() {
  openSheet({
    kicker: '板南線 · 同線即時', title: '乘客交流',
    body: '<div class="sheet-info-card"><h3>藍線旅人 · 忠孝復興站</h3><p>請問有人也是往南港方向嗎？想確認轉乘月台。</p></div><div class="sheet-info-card"><h3>匿名乘客 · 市政府站</h3><p>下一站下車，可以幫忙提醒一下嗎？謝謝！</p></div><div class="form-field" style="margin-top:12px"><label>發布同線訊息</label><input id="communityMessage" placeholder="輸入互助訊息"></div><button class="primary-button" data-send-community>發布訊息</button>'
  });
}

function openEmergency() {
  openSheet({
    kicker: '安心求助 · 即時回報', title: '站務人員正在前往',
    body: '<div class="emergency-status"><div class="pulse">!</div><h3>已定位板南線 3 車廂</h3><p>台北車站站務員王先生已接到通知，請原地安心等待。</p><strong id="emergencyCountdown">02:00</strong><button class="secondary-button" data-cancel-emergency>取消求助</button></div>'
  });
  let remaining = 120;
  clearInterval(openEmergency.timer);
  openEmergency.timer = setInterval(() => {
    remaining = Math.max(0, remaining - 1);
    const el = $('#emergencyCountdown');
    if (el) el.textContent = `${String(Math.floor(remaining / 60)).padStart(2,'0')}:${String(remaining % 60).padStart(2,'0')}`;
    if (!remaining) clearInterval(openEmergency.timer);
  }, 1000);
}

function renderOnboarding() {
  const page = onboardingPages[state.onboardingPage];
  $('#onboardingTitle').textContent = page.title;
  $('#onboardingDescription').textContent = page.description;
  $('#pageDots').innerHTML = onboardingPages.map((_, index) => `<i class="${index === state.onboardingPage ? 'is-active' : ''}"></i>`).join('');
  $('#nextOnboarding').textContent = state.onboardingPage === onboardingPages.length - 1 ? '🚀 開始體驗 App' : '下一步 →';
  if (page.demo === 'commute') {
    $('#onboardingDemo').innerHTML = '<div class="demo-commute"><header><span>SMART TRAVEL</span><span>AI ✦</span></header><div class="demo-route">台北車站　→　淡水</div><div class="demo-countdown"><span>下一班列車<br><b>進站倒數</b></span><strong>00:38</strong></div><div class="demo-crowd"><i></i><i></i><i></i><i></i><i></i><i></i></div></div>';
  } else if (page.demo === 'map') {
    $('#onboardingDemo').innerHTML = '<div class="demo-map"><div class="demo-map-card"><strong>台北車站</strong><small>🚻 廁所　🏪 超商　♿ 電梯</small><small>建議第 4 車廂，轉乘更順</small></div></div>';
  } else {
    $('#onboardingDemo').innerHTML = '<div class="demo-mode"><nav><span>🧳 觀光模式</span><span>♿ 無障礙模式</span></nav><article><div><b>◎</b><strong>多語系景點導航</strong><small>電梯優先・景點出口推薦</small></div></article></div>';
  }
}

function dismissOnboarding() {
  $('#onboarding').hidden = true;
  document.body.style.overflow = '';
  localStorage.setItem('metroGo.hasSeenOnboarding', 'true');
}

function setupEvents() {
  document.addEventListener('click', event => {
    const tab = event.target.closest('[data-tab]');
    if (tab) switchTab(tab.dataset.tab);

    const go = event.target.closest('[data-go]');
    if (go) switchTab(go.dataset.go);

    const picker = event.target.closest('[data-picker]');
    if (picker) openStationPicker(picker.dataset.picker);

    const stationChoice = event.target.closest('[data-station-choice]');
    if (stationChoice) {
      state[stationChoice.dataset.target] = stationChoice.dataset.stationChoice;
      updateRouteUI(); closeSheet(); showToast(`已選擇${stationChoice.dataset.stationChoice}`);
    }

    const stationNode = event.target.closest('.station-node');
    if (stationNode) openStationDetails(stationNode.dataset.station);

    const favorite = event.target.closest('[data-destination]');
    if (favorite) { state.destination = favorite.dataset.destination; updateRouteUI(); showToast(`目的地已改為${state.destination}`); }

    if (event.target.closest('[data-open-map]')) switchTab('map');

    const mode = event.target.closest('[data-mode]');
    if (mode) setMode(mode.dataset.mode);
    if (event.target.closest('[data-exit-mode]')) setMode('normal');

    const simpleSheet = event.target.closest('[data-sheet]');
    if (simpleSheet) openSimpleSheet(simpleSheet.dataset.sheet);

    const service = event.target.closest('[data-service]');
    if (service) openSheet({ kicker:'功能服務 · 概念流程', title:service.dataset.service, body:`<div class="sheet-info-card"><h3>${service.dataset.service}</h3><p>此原型已保留服務入口與操作回饋；正式串接資料後即可顯示即時內容。</p></div><button class="primary-button" style="margin-top:12px" data-demo-complete>體驗操作</button>` });

    const setDestination = event.target.closest('[data-set-destination]');
    if (setDestination) { state.destination = setDestination.dataset.setDestination; updateRouteUI(); closeSheet(); showToast('已設為目的地'); }

    if (event.target.closest('[data-assist-now]')) { closeSheet(); setTimeout(openEmergency, 180); }
    if (event.target.closest('[data-cancel-emergency]')) { clearInterval(openEmergency.timer); closeSheet(); showToast('已取消求助'); }
    if (event.target.closest('[data-radio-action="together"]')) openCommunity();
    if (event.target.closest('[data-send-community]')) { closeSheet(); showToast('訊息已發布給同線乘客'); }
    if (event.target.closest('[data-demo-complete]')) { closeSheet(); showToast('操作完成'); }

    const mood = event.target.closest('[data-mood]');
    if (mood) {
      const labels = {morning:'晨光通勤',afternoon:'午後慢行',night:'深夜末班'};
      $('#moodButton').textContent = `${labels[mood.dataset.mood]} · 模擬`;
      $('#radioMenu').hidden = true;
      showToast(`已切換為${labels[mood.dataset.mood]}`);
    }
  });

  document.addEventListener('keydown', event => {
    const node = event.target.closest?.('.station-node');
    if (node && (event.key === 'Enter' || event.key === ' ')) { event.preventDefault(); openStationDetails(node.dataset.station); }
    if (event.key === 'Escape') { closeSheet(); $('#settingsMenu').hidden = true; $('#radioMenu').hidden = true; }
  });

  $('#settingsButton').addEventListener('click', event => { event.stopPropagation(); $('#settingsMenu').hidden = !$('#settingsMenu').hidden; });
  $('#radioMenuButton').addEventListener('click', event => { event.stopPropagation(); $('#radioMenu').hidden = !$('#radioMenu').hidden; });
  document.addEventListener('click', event => {
    if (!event.target.closest('#settingsMenu') && !event.target.closest('#settingsButton')) $('#settingsMenu').hidden = true;
    if (!event.target.closest('#radioMenu') && !event.target.closest('#radioMenuButton')) $('#radioMenu').hidden = true;
  });
  $$('.language-options button').forEach(button => button.addEventListener('click', () => applyLanguage(button.dataset.language)));
  $('#dismissAlert').addEventListener('click', () => $('#serviceAlert').hidden = true);
  $('#swapRoute').addEventListener('click', () => { [state.origin, state.destination] = [state.destination, state.origin]; updateRouteUI(); });
  $('#favoriteToggle').addEventListener('click', () => { $('#favoriteGrid').hidden = !$('#favoriteGrid').hidden; $('#favoriteChevron').textContent = $('#favoriteGrid').hidden ? '›' : '⌃'; });
  $('#serviceSearch').addEventListener('input', event => renderServices(event.target.value));
  $('#closeSheet').addEventListener('click', closeSheet);
  $('#sheetBackdrop').addEventListener('click', closeSheet);
  $('#playButton').addEventListener('click', () => {
    state.playing = !state.playing; $('#playButton').textContent = state.playing ? 'Ⅱ' : '▶'; $('#playButton').setAttribute('aria-label', state.playing ? '暫停播放' : '開始播放');
    $('#playState').textContent = state.playing ? '同步播放' : '已暫停'; $('#playDot').classList.toggle('is-paused', !state.playing); renderWaveform();
  });
  $('#checkinButton').addEventListener('click', openSongCheckIn);
  $('#drawButton').addEventListener('click', revealDraw);
  $('#sheetBody').addEventListener('submit', event => { if (event.target.id === 'songForm') { event.preventDefault(); completeCheckIn(); } });
  $('#voiceButton').addEventListener('click', () => {
    const active = $('#voiceButton').classList.toggle('is-listening');
    $('#voiceButton').textContent = active ? '正在聆聽…' : '按住說話';
    $('#voiceGuidance').textContent = active ? '我在聆聽。請說出目的地或詢問無障礙設施。' : '你可以說：「帶我去最近的電梯」';
    if (active) setTimeout(() => { if ($('#voiceButton').classList.contains('is-listening')) { $('#voiceButton').click(); showToast('已找到最近的無障礙電梯'); } }, 2600);
  });
  $$('[data-access-destination]').forEach(button => button.addEventListener('click', () => showToast(`開始引導：${button.dataset.accessDestination}`)));
  $('#emergencyButton').addEventListener('click', openEmergency);
  $('#touristLanguage').addEventListener('click', () => {
    const languages = ['繁中','EN','日本語','한국어']; state.touristLanguageIndex = (state.touristLanguageIndex + 1) % languages.length; $('#touristLanguage').textContent = `🌐 ${languages[state.touristLanguageIndex]}`;
  });
  $('#zoomIn').addEventListener('click', () => setMapScale(Math.min(1.55, state.mapScale + .15)));
  $('#zoomOut').addEventListener('click', () => setMapScale(Math.max(.75, state.mapScale - .15)));
  $('#resetMap').addEventListener('click', () => { setMapScale(1); $('#metroMapWrap').scrollTo({left:0,top:180,behavior:'smooth'}); });
  $('#logoutButton').addEventListener('click', () => openSheet({ kicker:'會員中心', title:'確定要登出？', body:'<p style="color:var(--muted);line-height:1.5">登出後將停止同步此會員帳戶的乘車紀錄與回饋資料。</p><button class="primary-button" data-confirm-logout>確定登出</button>' }));
  $('#sheetBody').addEventListener('click', event => {
    if (event.target.closest('[data-confirm-logout]')) { $('#profileName').textContent = '訪客'; closeSheet(); showToast('已登出會員帳戶'); }
  });
  $('#skipOnboarding').addEventListener('click', dismissOnboarding);
  $('#closeOnboarding').addEventListener('click', dismissOnboarding);
  $('#nextOnboarding').addEventListener('click', () => { if (state.onboardingPage < onboardingPages.length - 1) { state.onboardingPage += 1; renderOnboarding(); } else dismissOnboarding(); });
  window.addEventListener('hashchange', () => switchTab(location.hash.replace('#','') || 'home', false));
}

function setMapScale(scale) { state.mapScale = scale; $('#metroMap').style.transform = `scale(${scale})`; }

function tickCountdown() {
  state.countdown = Math.max(0, state.countdown - 1);
  const minutes = Math.floor(state.countdown / 60);
  const seconds = state.countdown % 60;
  $('#countdown').textContent = state.countdown ? `${String(minutes).padStart(2,'0')}:${String(seconds).padStart(2,'0')}` : '進站中';
  if (!state.countdown) setTimeout(() => state.countdown = 245, 3000);
}

function init() {
  renderMap(); renderServices(); renderWaveform(); renderOnboarding(); applyLanguage(state.language); updateRadioState(); setupEvents();
  switchTab(['home','map','radio','services','account'].includes(state.tab) ? state.tab : 'home', false);
  $('#onboarding').hidden = localStorage.getItem('metroGo.hasSeenOnboarding') === 'true';
  if (!$('#onboarding').hidden) document.body.style.overflow = 'hidden';
  setInterval(tickCountdown, 1000);
  if ('serviceWorker' in navigator) navigator.serviceWorker.register('./sw.js').catch(() => {});
}

init();
