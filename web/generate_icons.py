"""Generates minimal valid PNG icons for Flutter Web build."""
import struct, zlib, os

def make_png(size, color=(10, 108, 94)):
    def chunk(name, data):
        c = struct.pack('>I', len(data)) + name + data
        return c + struct.pack('>I', zlib.crc32(c[4:]) & 0xFFFFFFFF)
    r, g, b = color
    raw = b''.join(b'\x00' + bytes([r, g, b, 255] * size) for _ in range(size))
    return (b'\x89PNG\r\n\x1a\n'
            + chunk(b'IHDR', struct.pack('>IIBBBBB', size, size, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(raw))
            + chunk(b'IEND', b''))

os.makedirs('web/icons', exist_ok=True)
for name, size in [
    ('Icon-192.png', 192),
    ('Icon-512.png', 512),
    ('Icon-maskable-192.png', 192),
    ('Icon-maskable-512.png', 512),
]:
    with open(f'web/icons/{name}', 'wb') as f:
        f.write(make_png(size))
    print(f'  ✓ {name}')

print('Icons generated.')
