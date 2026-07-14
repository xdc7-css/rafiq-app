const test = require('node:test');
const assert = require('node:assert/strict');
const { buildReleaseInfo } = require('../scripts/sync_release_info');

test('buildReleaseInfo returns placeholders when no release exists', () => {
  const info = buildReleaseInfo(null);

  assert.equal(info.tag_name, '');
  assert.equal(info.name, 'No release published yet');
  assert.equal(info.body, 'No release published yet.');
  assert.equal(info.apk_url, '');
  assert.equal(info.aab_url, '');
});

test('buildReleaseInfo extracts assets from a release payload', () => {
  const release = {
    tag_name: 'v1.2.3',
    name: 'Release 1.2.3',
    published_at: '2024-01-01T00:00:00Z',
    body: 'Hello world',
    html_url: 'https://example.com/release',
    assets: [
      { name: 'app-release.apk', browser_download_url: 'https://example.com/app-release.apk', size: 1234 },
      { name: 'app-release.aab', browser_download_url: 'https://example.com/app-release.aab', size: 4321 }
    ]
  };

  const info = buildReleaseInfo(release);

  assert.equal(info.tag_name, 'v1.2.3');
  assert.equal(info.apk_url, 'https://example.com/app-release.apk');
  assert.equal(info.aab_url, 'https://example.com/app-release.aab');
  assert.equal(info.aab_size, 4321);
});
