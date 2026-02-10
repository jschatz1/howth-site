#!/bin/sh
# Install script for howth
# Usage: curl -fsSL https://howth.run/install.sh | sh

set -e

REPO="jschatz1/howth"
INSTALL_DIR="${HOWTH_INSTALL_DIR:-$HOME/.howth/bin}"

info() {
    printf '%s\n' "$1"
}

error() {
    printf 'Error: %s\n' "$1" >&2
    exit 1
}

detect_target() {
    os=$(uname -s)
    arch=$(uname -m)

    case "$os" in
        Linux)  os_part="unknown-linux-gnu" ;;
        Darwin) os_part="apple-darwin" ;;
        MINGW*|MSYS*|CYGWIN*) os_part="pc-windows-msvc" ;;
        *) error "Unsupported operating system: $os" ;;
    esac

    case "$arch" in
        x86_64|amd64)  arch_part="x86_64" ;;
        aarch64|arm64) arch_part="aarch64" ;;
        *) error "Unsupported architecture: $arch" ;;
    esac

    TARGET="${arch_part}-${os_part}"
}

detect_ext() {
    case "$TARGET" in
        *windows*) EXT="zip" ;;
        *)         EXT="tar.gz" ;;
    esac
}

fetch() {
    url="$1"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- "$url"
    else
        error "Neither curl nor wget found. Please install one and try again."
    fi
}

fetch_to_file() {
    url="$1"
    dest="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL -o "$dest" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -q -O "$dest" "$url"
    else
        error "Neither curl nor wget found. Please install one and try again."
    fi
}

get_latest_version() {
    if [ -n "$HOWTH_VERSION" ]; then
        VERSION="$HOWTH_VERSION"
        return
    fi

    VERSION=$(fetch "https://api.github.com/repos/${REPO}/releases/latest" \
        | grep '"tag_name"' \
        | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')

    if [ -z "$VERSION" ]; then
        error "Could not determine latest version. Set HOWTH_VERSION to install a specific version."
    fi
}

verify_checksum() {
    archive_file="$1"
    checksums_file="$2"
    archive_name=$(basename "$archive_file")

    expected=$(grep "$archive_name" "$checksums_file" | awk '{print $1}')
    if [ -z "$expected" ]; then
        error "No checksum found for $archive_name"
    fi

    if command -v sha256sum >/dev/null 2>&1; then
        actual=$(sha256sum "$archive_file" | awk '{print $1}')
    elif command -v shasum >/dev/null 2>&1; then
        actual=$(shasum -a 256 "$archive_file" | awk '{print $1}')
    else
        info "Warning: sha256sum/shasum not found, skipping checksum verification"
        return 0
    fi

    if [ "$expected" != "$actual" ]; then
        error "Checksum mismatch for $archive_name (expected: $expected, got: $actual)"
    fi

    info "Checksum verified."
}

main() {
    info "Installing howth..."

    detect_target
    detect_ext
    get_latest_version

    ARCHIVE_NAME="howth-${VERSION}-${TARGET}.${EXT}"
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${ARCHIVE_NAME}"
    CHECKSUMS_URL="https://github.com/${REPO}/releases/download/${VERSION}/sha256sums.txt"

    info "  Version:  ${VERSION}"
    info "  Target:   ${TARGET}"
    info "  Archive:  ${ARCHIVE_NAME}"

    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT

    info "Downloading ${ARCHIVE_NAME}..."
    fetch_to_file "$DOWNLOAD_URL" "${tmpdir}/${ARCHIVE_NAME}"
    fetch_to_file "$CHECKSUMS_URL" "${tmpdir}/sha256sums.txt"

    verify_checksum "${tmpdir}/${ARCHIVE_NAME}" "${tmpdir}/sha256sums.txt"

    info "Extracting..."
    case "$EXT" in
        tar.gz)
            tar xzf "${tmpdir}/${ARCHIVE_NAME}" -C "$tmpdir"
            ;;
        zip)
            unzip -q "${tmpdir}/${ARCHIVE_NAME}" -d "$tmpdir"
            ;;
    esac

    mkdir -p "$INSTALL_DIR"

    # Find and copy binaries
    EXTRACT_DIR="${tmpdir}/howth-${VERSION}-${TARGET}"
    if [ -f "${EXTRACT_DIR}/howth" ]; then
        cp "${EXTRACT_DIR}/howth" "$INSTALL_DIR/"
        chmod +x "${INSTALL_DIR}/howth"
    fi
    if [ -f "${EXTRACT_DIR}/fastnode" ]; then
        cp "${EXTRACT_DIR}/fastnode" "$INSTALL_DIR/"
        chmod +x "${INSTALL_DIR}/fastnode"
    fi
    # Windows
    if [ -f "${EXTRACT_DIR}/howth.exe" ]; then
        cp "${EXTRACT_DIR}/howth.exe" "$INSTALL_DIR/"
    fi
    if [ -f "${EXTRACT_DIR}/fastnode.exe" ]; then
        cp "${EXTRACT_DIR}/fastnode.exe" "$INSTALL_DIR/"
    fi

    info ""
    info "howth installed to ${INSTALL_DIR}"

    # Add to PATH if not already there
    case ":$PATH:" in
        *":${INSTALL_DIR}:"*) ;;
        *)
            PATH_LINE="export PATH=\"${INSTALL_DIR}:\$PATH\""
            added_to=""

            # Detect shell and append to the appropriate rc file
            if [ -f "$HOME/.zshrc" ]; then
                if ! grep -qF "$INSTALL_DIR" "$HOME/.zshrc" 2>/dev/null; then
                    printf '\n# howth\n%s\n' "$PATH_LINE" >> "$HOME/.zshrc"
                    added_to="$HOME/.zshrc"
                fi
            fi
            if [ -f "$HOME/.bashrc" ]; then
                if ! grep -qF "$INSTALL_DIR" "$HOME/.bashrc" 2>/dev/null; then
                    printf '\n# howth\n%s\n' "$PATH_LINE" >> "$HOME/.bashrc"
                    added_to="${added_to:+$added_to, }$HOME/.bashrc"
                fi
            elif [ -f "$HOME/.bash_profile" ]; then
                if ! grep -qF "$INSTALL_DIR" "$HOME/.bash_profile" 2>/dev/null; then
                    printf '\n# howth\n%s\n' "$PATH_LINE" >> "$HOME/.bash_profile"
                    added_to="${added_to:+$added_to, }$HOME/.bash_profile"
                fi
            fi
            if [ -d "$HOME/.config/fish" ]; then
                mkdir -p "$HOME/.config/fish/conf.d"
                FISH_LINE="fish_add_path ${INSTALL_DIR}"
                if ! grep -qF "$INSTALL_DIR" "$HOME/.config/fish/conf.d/howth.fish" 2>/dev/null; then
                    printf '# howth\n%s\n' "$FISH_LINE" > "$HOME/.config/fish/conf.d/howth.fish"
                    added_to="${added_to:+$added_to, }$HOME/.config/fish/conf.d/howth.fish"
                fi
            fi

            if [ -n "$added_to" ]; then
                # Pick the first file we actually wrote to for the source hint
                source_file=$(printf '%s' "$added_to" | cut -d',' -f1 | tr -d ' ')
                info "Added to PATH in ${added_to}"
                info "Restart your shell or run: source ${source_file}"
            else
                info ""
                info "Add howth to your PATH by adding this to your shell profile:"
                info ""
                info "  ${PATH_LINE}"
                info ""
            fi
            ;;
    esac

    info ""
    info "Run 'howth --version' to verify the installation."
}

main
