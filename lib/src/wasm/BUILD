load("@rules_cc//cc:defs.bzl", "cc_library")
load("@tree-sitter-bazel//:rules.bzl", map = "in_pkg_srcs")

cc_library(
    name = "wasm_stdlib",
    hdrs = map(["wasm-stdlib.h"]),
    strip_include_prefix = "/lib/src",
    visibility = ["//visibility:public"]
)
