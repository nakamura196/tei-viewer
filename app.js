document.addEventListener('DOMContentLoaded', () => {
  // === 言語切り替えロジック ===
  const btnEn = document.getElementById('btn-en');
  const btnJa = document.getElementById('btn-ja');
  const btnBoth = document.getElementById('btn-both');
  const body = document.body;

  function updateLang(lang) {
    body.className = `lang-${lang}`;
    btnEn.classList.toggle('active', lang === 'en');
    btnJa.classList.toggle('active', lang === 'ja');
    btnBoth.classList.toggle('active', lang === 'both');
  }

  btnEn.addEventListener('click', () => updateLang('en'));
  btnJa.addEventListener('click', () => updateLang('ja'));
  btnBoth.addEventListener('click', () => updateLang('both'));

  // === CETEIcean の初期化とロード ===
  const c = new CETEI();
  c.getHTML5("tei.xml", (data) => {
    document.getElementById("content").appendChild(data);
    
    // データ読み込み後に目次と脚注を処理
    generateTOC();
    processFootnotes();
  });

  // 目次の動的生成
  function generateTOC() {
    const tocList = document.getElementById('toc-list');
    const divs = document.querySelectorAll('#content tei-body > tei-div');
    
    divs.forEach((div, index) => {
      const head = div.querySelector(':scope > tei-head');
      if (head) {
        const id = `section-${index}`;
        head.id = id;
        
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.href = `#${id}`;
        a.textContent = head.textContent;
        li.appendChild(a);
        
        // サブセクションのチェック
        const subDivs = div.querySelectorAll(':scope > tei-div');
        if (subDivs.length > 0) {
          const ul = document.createElement('ul');
          subDivs.forEach((subDiv, subIndex) => {
            const subHead = subDiv.querySelector(':scope > tei-head');
            if (subHead) {
              const subId = `section-${index}-${subIndex}`;
              subHead.id = subId;
              const subLi = document.createElement('li');
              const subA = document.createElement('a');
              subA.href = `#${subId}`;
              subA.textContent = subHead.textContent;
              subLi.appendChild(subA);
              ul.appendChild(subLi);
            }
          });
          li.appendChild(ul);
        }
        
        tocList.appendChild(li);
      }
    });
  }

  // 脚注（tei-note）のツールチップ化
  function processFootnotes() {
    const notes = document.querySelectorAll('tei-note[place="foot"]');
    notes.forEach(note => {
      const n = note.getAttribute('n') || '*';
      const content = note.innerHTML;
      // 元の内容をツールチップ用の構造で置き換える
      note.innerHTML = `
        <span class="note-wrapper">
          <sup class="note-ref">[${n}]</sup>
          <span class="tooltip">${content}</span>
        </span>
      `;
    });
  }
});
