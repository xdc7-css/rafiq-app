async function loadReleaseInfo() {
  try {
    const response = await fetch('https://api.github.com/repos/xdc7-css/rafiq-app/releases/latest', {
      headers: { Accept: 'application/vnd.github+json', 'User-Agent': 'rafiq-web' }
    });
    if (!response.ok) throw new Error('Unable to load release info');
    const data = await response.json();
    const apkAsset = (data.assets || []).find((asset) => /\.apk$/i.test(asset.name)) || null;
    const aabAsset = (data.assets || []).find((asset) => /\.aab$/i.test(asset.name)) || null;
    const container = document.getElementById('release-info');
    if (!container) return;
    container.innerHTML = `
      <h2>${data.name || data.tag_name}</h2>
      <p><strong>Version:</strong> ${data.tag_name || 'n/a'}</p>
      <p><strong>Published:</strong> ${new Date(data.published_at || '').toLocaleDateString()}</p>
      <p><strong>Release notes:</strong></p>
      <pre>${(data.body || 'No notes available.').replace(/</g, '&lt;')}</pre>
      <p>
        ${apkAsset ? `<a href="${apkAsset.browser_download_url}">Download APK (${(apkAsset.size / 1024 / 1024).toFixed(2)} MB)</a>` : 'APK not available yet.'}
      </p>
      <p>
        ${aabAsset ? `<a href="${aabAsset.browser_download_url}">Download AAB (${(aabAsset.size / 1024 / 1024).toFixed(2)} MB)</a>` : 'AAB not available yet.'}
      </p>
    `;
  } catch (error) {
    const container = document.getElementById('release-info');
    if (container) {
      container.innerHTML = '<p>Release information is currently unavailable.</p>';
    }
  }
}

window.addEventListener('DOMContentLoaded', loadReleaseInfo);
