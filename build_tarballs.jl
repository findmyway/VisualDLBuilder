using BinaryBuilder
using BinaryProvider
using CxxWrap

const src_name = "VisuaDL"
const src_version = v"1.2.1"

platforms = [
    BinaryProvider.Windows(:x86_64),
    BinaryProvider.Linux(:x86_64, :glibc),
    BinaryProvider.MacOS()
]

sources = [
    "https://api.github.com/repos/findmyway/VisualDL/tarball/julia" => "8723e690b9b7645b08ed520bd811949eb108f4f873caea40110478e33b96e48b"
]

const JlCxx_DIR = get(ENV, "JLCXX_DIR", joinpath(dirname(CxxWrap.jlcxx_path), "cmake", "JlCxx"))
const Julia_DIR = joinpath(Sys.BINDIR, "julia")

script = raw"""
cd $WORKSPACE/srcdir/VisualDL
mkdir build && cd build
cmake -DJlCxx_DIR=$JlCXX_DIR -DJulia_EXECUTABLE=$Julia_DIR -DWITH_JULIA=ON ..
make
"""

products(prefix) = [
    LibraryProduct(prefix, joinpath("visualdl", "julia", "libvdljl"), :libvdljl)
]

dependencies = []

build_tarballs(ARGS, src_name, src_version, sources, script, platforms, products, dependencies)