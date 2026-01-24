const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const PNG_SIGNATURE = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);

const CRC_TABLE = new Uint32Array(256);
for (let n = 0; n < 256; n++) {
  let c = n;
  for (let k = 0; k < 8; k++) {
    c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
  }
  CRC_TABLE[n] = c >>> 0;
}

const baseColor = [9, 13, 45];
const highlightColor = [255, 196, 71];

function crc32(buf) {
  let crc = 0xffffffff;
  for (let i = 0; i < buf.length; i++) {
    crc = CRC_TABLE[(crc ^ buf[i]) & 0xff] ^ (crc >>> 8);
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function chunk(type, data) {
  const typeBuf = Buffer.from(type);
  const lengthBuf = Buffer.alloc(4);
  lengthBuf.writeUInt32BE(data.length, 0);
  const body = Buffer.concat([typeBuf, data]);
  const crcBuf = Buffer.alloc(4);
  crcBuf.writeUInt32BE(crc32(body), 0);
  return Buffer.concat([lengthBuf, body, crcBuf]);
}

function createImage(width, height) {
  const rowLength = width * 4 + 1;
  const raw = Buffer.alloc(rowLength * height);
  const centerX = width / 2;
  const centerY = height / 2;
  const radius = width * 0.35;

  for (let y = 0; y < height; y++) {
    const rowStart = y * rowLength;
    raw[rowStart] = 0; // filter type 0
    for (let x = 0; x < width; x++) {
      const offset = rowStart + 1 + x * 4;
      const pixel = getPixelColor(x, y, width, height, centerX, centerY, radius);
      raw[offset] = pixel[0];
      raw[offset + 1] = pixel[1];
      raw[offset + 2] = pixel[2];
      raw[offset + 3] = pixel[3];
    }
  }

  const compressed = zlib.deflateSync(raw);
  const ihdrData = Buffer.alloc(13);
  ihdrData.writeUInt32BE(width, 0);
  ihdrData.writeUInt32BE(height, 4);
  ihdrData[8] = 8; // bit depth
  ihdrData[9] = 6; // color type RGBA
  ihdrData[10] = 0; // compression
  ihdrData[11] = 0; // filter
  ihdrData[12] = 0; // interlace

  const ihdrChunk = chunk('IHDR', ihdrData);
  const idatChunk = chunk('IDAT', compressed);
  const iendChunk = chunk('IEND', Buffer.alloc(0));
  return Buffer.concat([PNG_SIGNATURE, ihdrChunk, idatChunk, iendChunk]);
}

function getPixelColor(x, y, width, height, centerX, centerY, radius) {
  const dx = x + 0.5 - centerX;
  const dy = y + 0.5 - centerY;
  const distance = Math.sqrt(dx * dx + dy * dy);
  const inGlow = distance < radius;

  if (Math.hypot(x - width * 0.75, y - height * 0.25) < width * 0.08) {
    return [255, 220, 90, 255];
  }

  if ((Math.abs((x - centerX) - (y - centerY)) < width * 0.01) && x > centerX && y > centerY) {
    return [255, 255, 255, 255];
  }

  if (Math.abs(y - (centerY - height * 0.15)) < height * 0.015 && x > width * 0.35) {
    return [255, 255, 255, 220];
  }

  const base = [...baseColor];
  if (inGlow) {
    const glow = Math.max(0, 1 - distance / radius);
    return [
      Math.round(base[0] + (highlightColor[0] - base[0]) * glow),
      Math.round(base[1] + (highlightColor[1] - base[1]) * glow),
      Math.round(base[2] + (highlightColor[2] - base[2]) * glow),
      255,
    ];
  }

  if (Math.abs(dx) < width * 0.03 && Math.abs(dy) < height * 0.03) {
    return [64, 128, 255, 255];
  }

  return [base[0], base[1], base[2], 255];
}

function ensureDir(filePath) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
}

function writeIcon(dest, width, height) {
  ensureDir(dest);
  const png = createImage(width, height);
  fs.writeFileSync(dest, png);
  console.log(`wrote ${dest} (${width}x${height})`);
}

function parseSize(size, scale) {
  const [w, h] = size.split('x').map(Number);
  const factor = parseFloat(scale);
  const width = Math.round(w * factor);
  const height = Math.round(h * factor);
  return { width, height };
}

const androidIcons = [
  { dir: 'android/app/src/main/res/mipmap-mdpi', size: 48 },
  { dir: 'android/app/src/main/res/mipmap-hdpi', size: 72 },
  { dir: 'android/app/src/main/res/mipmap-xhdpi', size: 96 },
  { dir: 'android/app/src/main/res/mipmap-xxhdpi', size: 144 },
  { dir: 'android/app/src/main/res/mipmap-xxxhdpi', size: 192 },
];

for (const icon of androidIcons) {
  writeIcon(path.join(icon.dir, 'ic_launcher.png'), icon.size, icon.size);
}

const iosAssetDir = path.join('ios', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset');
const contentsPath = path.join(iosAssetDir, 'Contents.json');
const contents = JSON.parse(fs.readFileSync(contentsPath, 'utf8'));
for (const image of contents.images) {
  if (!image.filename) continue;
  const { width, height } = parseSize(image.size, image.scale);
  writeIcon(path.join(iosAssetDir, image.filename), width || 1, height || 1);
}

const webIcons = [
  { name: 'favicon.png', size: 64 },
  { name: path.join('web', 'icons', 'Icon-192.png'), size: 192 },
  { name: path.join('web', 'icons', 'Icon-512.png'), size: 512 },
  { name: path.join('web', 'icons', 'Icon-maskable-192.png'), size: 192 },
  { name: path.join('web', 'icons', 'Icon-maskable-512.png'), size: 512 },
];

for (const icon of webIcons) {
  writeIcon(icon.name, icon.size, icon.size);
}

console.log('icons regenerated');
