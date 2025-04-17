# 🐳 node-vips

A minimal Alpine-based Node.js Docker image with support for HEIC via libvips and libheif.

## 📦 What's Inside?

This image includes:

- **Node.js 20 (Alpine)**
- **libvips 8.16.1** (compiled from source)
- **HEIC image support** via:
  - `libheif`
  - `libde265`
  - `x265`

---

## 🚀 Usage

You can use this image as a base for your own Node.js projects that rely on `sharp`:

```Dockerfile
FROM jimzrt/node-vips:latest

WORKDIR /app
COPY . .
RUN npm install

CMD ["node", "index.js"]
