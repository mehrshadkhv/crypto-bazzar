const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..', '..');
const failures = [];
const codeBlocks = {};
const imageSources = {};
const expectedScreenshots = fs.readdirSync(path.join(root, 'assets', 'screenshots'))
  .filter(name => /\.png$/i.test(name)).map(name => `assets/screenshots/${name}`).sort();
for (const name of ['README.md', 'README.fa.md']) {
  const file = path.join(root, name);
  if (!fs.existsSync(file)) { failures.push(`${name}: missing`); continue; }
  const text = fs.readFileSync(file, 'utf8');
  if (!text.includes('[English](README.md) | [فارسی](README.fa.md)')) failures.push(`${name}: missing switcher`);
  if (!text.includes('License-MIT-green') || !text.includes('](LICENSE)')) failures.push(`${name}: MIT license badge or link missing`);
  if (text.includes('License-not%20specified') || text.includes('No `LICENSE` file is included') || text.includes('فایل `LICENSE` وجود ندارد')) failures.push(`${name}: outdated license text`);
  if (text.includes('\uFFFD')) failures.push(`${name}: replacement character`);
  if (!text.includes('changePercent24Hr')) failures.push(`${name}: missing API key name`);
  let stack = [], inFence = false, current = [], blocks = [], prose = [];
  for (const line of text.split(/\r?\n/)) {
    const div = line.match(/^\s*<div dir="(rtl|ltr)" align="(right|left)">\s*$/);
    if (div && !inFence) stack.push(div[1]);
    if (/^\s*```/.test(line)) {
      if (!inFence) {
        if (name.endsWith('.fa.md') && stack[stack.length - 1] !== 'ltr') failures.push(`${name}: code fence outside LTR wrapper`);
        current = [line.trim()];
      } else { blocks.push(current.join('\n')); current = []; }
      inFence = !inFence;
    } else if (inFence) current.push(line.trim());
    else prose.push(line);
    if (/^\s*<\/div>\s*$/.test(line) && !inFence) {
      if (!stack.length) failures.push(`${name}: unmatched div`); else stack.pop();
    }
  }
  if (inFence || stack.length) failures.push(`${name}: unclosed fence/div`);
  if (name.endsWith('.fa.md') && (!text.startsWith('<div dir="rtl" align="right">\n\n') || !text.trimEnd().endsWith('</div>'))) failures.push(`${name}: outer RTL wrapper`);
  const visible = prose.join('\n');
  const images = [...visible.matchAll(/<img\b[^>]*src="([^"]+)"[^>]*>/g)];
  imageSources[name] = images.map(image => image[1]);
  if (images.length !== expectedScreenshots.length || JSON.stringify([...imageSources[name]].sort()) !== JSON.stringify(expectedScreenshots)) failures.push(`${name}: screenshot gallery does not match the supplied PNG files`);
  if (visible.includes('placeholder.svg') || visible.includes('Screenshot pending:') || visible.includes('تصویر اضافه نشده:')) failures.push(`${name}: outdated screenshot placeholder`);
  for (const image of images) {
    if (!fs.existsSync(path.resolve(root, image[1]))) failures.push(`${name}: missing image ${image[1]}`);
    if (!image[0].includes('width="200"') || !image[0].includes('alt=')) failures.push(`${name}: image sizing/alt text`);
  }
  for (const match of visible.matchAll(/\]\(([^)]+)\)/g)) {
    if (!/^(https?:|#)/.test(match[1]) && !fs.existsSync(path.resolve(root, match[1]))) failures.push(`${name}: missing link ${match[1]}`);
  }
  codeBlocks[name] = blocks;
  console.log(`${name}: ${Buffer.byteLength(text)} bytes; ${text.split('\n').length} lines; ${blocks.length} code blocks; ${images.length} valid images`);
}
if (JSON.stringify(codeBlocks['README.md']) !== JSON.stringify(codeBlocks['README.fa.md'])) failures.push('English/Persian code blocks differ');
if (JSON.stringify(imageSources['README.md']) !== JSON.stringify(imageSources['README.fa.md'])) failures.push('English/Persian screenshot order differs');
if (failures.length) { console.error(failures.join('\n')); process.exit(1); }
console.log('README checks passed.');
