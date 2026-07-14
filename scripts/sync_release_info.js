const https = require('https');
const fs = require('fs');

const repo = process.env.GITHUB_REPOSITORY || 'xdc7-css/rafiq-app';
const outputFile = process.env.OUTPUT_FILE || 'build/web/release-info.json';

function buildReleaseInfo(release) {
  if (!release) {
    return {
      tag_name: '',
      name: 'No release published yet',
      published_at: '',
      body: 'No release published yet.',
      html_url: '',
      apk_url: '',
      apk_size: 0,
      aab_url: '',
      aab_size: 0
    };
  }

  const apkAsset = (release.assets || []).find((asset) => /\.apk$/i.test(asset.name));
  const aabAsset = (release.assets || []).find((asset) => /\.aab$/i.test(asset.name));

  return {
    tag_name: release.tag_name || '',
    name: release.name || release.tag_name || 'No release published yet',
    published_at: release.published_at || '',
    body: release.body || 'No release published yet.',
    html_url: release.html_url || '',
    apk_url: apkAsset ? apkAsset.browser_download_url : '',
    apk_size: apkAsset ? apkAsset.size : 0,
    aab_url: aabAsset ? aabAsset.browser_download_url : '',
    aab_size: aabAsset ? aabAsset.size : 0
  };
}

function getLatestRelease() {
  return new Promise((resolve) => {
    const headers = {
      'User-Agent': 'rafiq-release-sync',
      'Accept': 'application/vnd.github+json'
    };

    if (process.env.GITHUB_TOKEN) {
      headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
    }

    const req = https.get({
      hostname: 'api.github.com',
      path: `/repos/${repo}/releases/latest`,
      headers
    }, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        if (res.statusCode && res.statusCode >= 200 && res.statusCode < 300) {
          try {
            resolve(JSON.parse(data));
          } catch (error) {
            resolve(null);
          }
        } else if ([404, 403, 429].includes(res.statusCode)) {
          console.warn(`GitHub API returned ${res.statusCode}; using placeholder release info.`);
          resolve(null);
        } else {
          console.warn(`GitHub API returned ${res.statusCode}; using placeholder release info.`);
          resolve(null);
        }
      });
    });
    req.on('error', () => resolve(null));
  });
}

async function main() {
  try {
    const release = await getLatestRelease();
    const info = buildReleaseInfo(release);
    fs.mkdirSync(require('path').dirname(outputFile), { recursive: true });
    fs.writeFileSync(outputFile, JSON.stringify(info, null, 2));
    console.log('Wrote release info to', outputFile);
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { buildReleaseInfo };
