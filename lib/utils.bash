#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/traefik/traefik"
TOOL_NAME="traefik"
TOOL_TEST="traefik --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if traefik is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

get_platform() {
	local os
	# Get uname and lowercase it with awk
	os=$(uname | awk '{print tolower($0)}')
	# Make sure the platform is supported
	if [[ "$os" == "darwin" || "$os" == "linux" || "$os" == "freebsd" ]]; then
		echo "$os"
	else
		echo >&2 "unsupported os: ${os}" && exit 1
	fi
}

get_arch() {
	local arch
	arch=$(uname -m)
	if [[ "$arch" == "x86_64" || "$arch" == "amd64" ]]; then
		echo "amd64"
	elif [[ "$arch" == "arm64" || "$arch" == "aarch64" || "$arch" == "aarch64_be" || "$arch" == "armv8b" || "$arch" == "armv8l" ]]; then
		echo "arm64"
	elif [[ "$arch" == "armv6" || "$arch" == "armv6l" ]]; then
		echo "armv6"
	elif [[ "$arch" == "i386" || "$arch" == "i686" ]]; then
		echo "386"
	else
		echo >&2 "unsupported arch: ${arch}" && exit 1
	fi
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/releases/download/v${version}/traefik_v${version}_$(get_platform)_$(get_arch).tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert traefik executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
