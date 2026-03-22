# Copyright 2026 github.com/zadlg
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//:version.bzl", "VERSION")

# Default tree-sitter version to use.
DEFAULT_VERSION = VERSION

# SHA-256 sum of the default tree-sitter version GitHub archive.
DEFAULT_SHA256SUM = "8e012493b2103e0471d3aba8048b73bc1a3138132974e2fd8bfb89a63e62f478"

# Integrity in Subresource Integrity format.
# This can be obtained by doing:
# ```shell
# export DGST=384
# curl -L "${URL}" -s | shasum -a "${DGST}" | cut -f1 -d' ' | xxd -r -p | base64 | (echo -ne "sha${DGST}-" && "cat" -)
# ```
DEFAULT_INTEGRITY = "sha384-UFn59au2/IMpAb2LqYOhZsHOhoFOttBAnZ5wPPPL4woryAnZyW/c1xEiiBobALr/"

# Format for URLs to GitHub archives.
_URL_FMT = "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v{version}.tar.gz"

# Format for stripping the archive prefix.
_STRIP_PREFIX_FMT = "tree-sitter-{version}"

def tree_sitter_build_http_archive_arguments(
        version = DEFAULT_VERSION,
        sha256 = DEFAULT_SHA256SUM,
        integrity = DEFAULT_INTEGRITY,
        url = None,
        strip_prefix = None):
    """Builds the argument for `http_archive`.

    Args:
      version: str
        Version to use.
      sha256: str
        SHA-256 sum.
      url: str
        URL.
      strip_prefix: str
        Strip prefix.

    Returns: dict
      Arguments for `http_archive`. `name` is missing.
    """
    if url == None:
        url = _URL_FMT.format(version = version)
    elif url != None and version != None:
        fail("`url` and `version` are mutually exclusive.")

    if strip_prefix == None:
        if version != None:
            strip_prefix = _STRIP_PREFIX_FMT.format(version = version)
        else:
            print("WARNING: no `strip_prefix` will be used.")

    if sha256 == None and integrity == None:
        print("WARNING: `sha256` and`integrity` SHOULD NOT be None.")

    if integrity != None:
        sha256 = None

    return {
        "urls": [url],
        "sha256": sha256,
        "integrity": integrity,
        "strip_prefix": strip_prefix,
        "build_file_content": """exports_files(glob(["lib/**"]))""",
    }
