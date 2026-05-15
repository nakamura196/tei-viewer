document.addEventListener('DOMContentLoaded', () => {
  const btnEn = document.getElementById('btn-en');
  const btnJa = document.getElementById('btn-ja');
  const btnBoth = document.getElementById('btn-both');
  const body = document.body;

  function updateLang(lang) {
    // クラスを付け替える
    body.className = `lang-${lang}`;
    
    // ボタンのactive状態を更新
    btnEn.classList.toggle('active', lang === 'en');
    btnJa.classList.toggle('active', lang === 'ja');
    btnBoth.classList.toggle('active', lang === 'both');
  }

  btnEn.addEventListener('click', () => updateLang('en'));
  btnJa.addEventListener('click', () => updateLang('ja'));
  btnBoth.addEventListener('click', () => updateLang('both'));
});
