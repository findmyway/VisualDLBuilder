using BinaryBuilder

const src_name = "VisuaDL"
const src_version = v"1.2.1"

platforms = [
    BinaryProvider.Linux(:x86_64, compiler_abi=CompilerABI(:gcc7))
]

sources = [
    "https://tianjun.me/static/site_resources/visualdl.tar.gz" => "d512909eb54b28fd9474b87ff94a3d1161f34964d1e89fb61062297cfa8a7cf7"
]

script = raw"""
cd $WORKSPACE/srcdir/VisualDL
mkdir build && cd build
cmake -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_CXX_FLAGS="-march=x86-64" -DCMAKE_INSTALL_PREFIX=${prefix} -DCMAKE_FIND_ROOT_PATH=${prefix} -DJulia_PREFIX=${prefix} -DWITH_JULIA=ON -DWITH_PYTHON=OFF ..
make
make install
"""

products(prefix) = [
    LibraryProduct(prefix, "libvdljl", :libvdljl)
]

dependencies = [
    "https://github.com/JuliaPackaging/JuliaBuilder/releases/download/v1.0.0-2/build_Julia.v1.0.0.jl",
    "http://github.com/JuliaInterop/libcxxwrap-julia/releases/download/v0.5.1/build_libcxxwrap-julia-1.0.v0.5.1.jl"
]

build_tarballs(ARGS, src_name, src_version, sources, script, platforms, products, dependencies)
