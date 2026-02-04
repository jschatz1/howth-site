# Installation

## Install Script (Recommended)

The install script detects your OS and architecture, downloads the appropriate binary, and verifies the checksum:

```sh
curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh
```

This installs to `~/.howth/bin` by default. You may need to add it to your PATH:

```sh
export PATH="$HOME/.howth/bin:$PATH"
```

### Options

Set a specific version:

```sh
HOWTH_VERSION=v0.1.0 curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh
```

Custom install directory:

```sh
HOWTH_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh
```

### Using wget

If you don't have `curl`, the install script also supports `wget`:

```sh
wget -qO- https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh
```

## GitHub Releases

Download pre-built binaries directly from [GitHub Releases](https://github.com/jschatz1/howth/releases).

Available targets:

| Platform | Target | Archive |
|---|---|---|
| Linux x86_64 | `x86_64-unknown-linux-gnu` | `.tar.gz` |
| macOS Apple Silicon | `aarch64-apple-darwin` | `.tar.gz` |
| macOS Intel | `x86_64-apple-darwin` | `.tar.gz` |
| Windows x86_64 | `x86_64-pc-windows-msvc` | `.zip` |

Each archive contains both `howth` and `fastnode` binaries.

## Docker

Pull and run the official Docker image:

```sh
docker pull ghcr.io/jschatz1/howth:latest
```

Run a script:

```sh
docker run -v $(pwd):/app ghcr.io/jschatz1/howth run script.js
```

Use as a base image:

```dockerfile
FROM ghcr.io/jschatz1/howth:latest
WORKDIR /app
COPY . .
CMD ["howth", "run", "index.js"]
```

Available tags:
- `latest` - Most recent release
- `0.1.1` - Specific version

## Build from Source

Requires [Rust](https://rustup.rs/) 1.75 or later:

```sh
git clone https://github.com/jschatz1/howth.git
cd howth
cargo build --release
```

Binaries are output to `target/release/howth` and `target/release/fastnode`.

## Verify Installation

```sh
howth --version
```
