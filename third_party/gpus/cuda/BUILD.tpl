licenses(["restricted"])  # MPL2, portions GPL v3, LGPL v3, BSD-like

load("@local_config_cuda//cuda:platform.bzl", "readlink_command")

package(default_visibility = ["//visibility:public"])

config_setting(
    name = "using_nvcc",
    values = {
        "define": "using_cuda_nvcc=true",
    },
)

config_setting(
    name = "using_clang",
    values = {
        "define": "using_cuda_clang=true",
    },
)

# Equivalent to using_clang && -c opt.
config_setting(
    name = "using_clang_opt",
    values = {
        "define": "using_cuda_clang=true",
        "compilation_mode": "opt",
    },
)

config_setting(
    name = "darwin",
    values = {"cpu": "darwin"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "freebsd",
    values = {"cpu": "freebsd"},
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda_headers",
    hdrs = glob([
        "**/*.h",
        "**/*.hpp",
    ]),
    includes = [
        ".",
        "include",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cudart_static",
    srcs = ["lib/%{cudart_static_lib}"],
    includes = ["include/"],
    linkopts = select({
        ":freebsd": [],
        "//conditions:default": ["-ldl"],
    }) + [
        "-lpthread",
        %{cudart_static_linkopt}
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda_driver",
    srcs = ["lib/%{cuda_driver_lib}"],
    includes = ["include/"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cudart",
    srcs = ["lib/%{cudart_lib}"],
    data = ["lib/%{cudart_lib}"],
    includes = ["include/"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cublas",
    srcs = ["lib/%{cublas_lib}"],
    data = ["lib/%{cublas_lib}"],
    includes = ["include/"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cusolver",
    srcs = ["lib/%{cusolver_lib}"],
    data = ["lib/%{cusolver_lib}"],
    includes = ["include/"],
    linkstatic = 1,
    linkopts = ["-lgomp"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cudnn",
    srcs = ["lib/%{cudnn_lib}"],
    data = ["lib/%{cudnn_lib}"],
    includes = ["include/"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cufft",
    srcs = ["lib/%{cufft_lib}"],
    data = ["lib/%{cufft_lib}"],
    includes = ["include/"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "curand",
    srcs = ["lib/%{curand_lib}"],
    data = ["lib/%{curand_lib}"],
    includes = ["include/"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda",
    deps = [
        ":cuda_headers",
        ":cudart",
        ":cublas",
        ":cudnn",
        ":cufft",
        ":curand",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cupti_headers",
    hdrs = glob([
        "**/*.h",
    ]),
    includes = [
        ".",
        "extras/CUPTI/include/",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cupti_dsos",
    data = ["lib/%{cupti_lib}"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "libdevice_root",
    data = glob(["nvvm/libdevice/*.bc"]),
    visibility = ["//visibility:public"],
)
