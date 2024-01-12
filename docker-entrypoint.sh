#!/bin/bash
cd app
# Clone the repository
git clone https://github.com/lightningdevkit/ldk-garbagecollected.git
cd ldk-garbagecollected
cargo install cbindgen
git clone https://github.com/lightningdevkit/rust-lightning
cd rust-lightning
git checkout origin/0.0.118-bindings
cd ..
git clone https://github.com/lightningdevkit/ldk-c-bindings
cd ldk-c-bindings
git checkout 0.0.118
export LDK_C_BINDINGS_EXTRA_TARGETS=x86_64-pc-windows-gnu
export LDK_C_BINDINGS_EXTRA_TARGET_CCS=`pwd`/deterministic-build-wrappers/clang-x86_64-windows
./genbindings.sh ../rust-lightning true
cd ../
ls
rm c_sharp/src/org/ldk/enums/*.cs c_sharp/src/org/ldk/impl/*.cs c_sharp/src/org/ldk/structs/*.cs

export LDK_GARBAGECOLLECTED_GIT_OVERRIDE="$(git describe --tag HEAD)"
LDK_TARGET=x86_64-pc-windows-gnu ./genbindings.sh ./ldk-c-bindings/ c_sharp true false
		  
ls
export LDK_GARBAGECOLLECTED_GIT_OVERRIDE="$(git describe --tag HEAD)"
sed -i 's$mono-csc -g -out:csharpldk.dll -langversion:3 -t:library -unsafe c_sharp/src/org/ldk/enums/\*.cs c_sharp/src/org/ldk/impl/\*.cs c_sharp/src/org/ldk/util/\*.cs c_sharp/src/org/ldk/structs/\*.cs$cd c_sharp;dotnet build --configuration Debug --output packaging_artifacts/lib/net6.0; cd ..$' ./genbindings.sh

./genbindings.sh ./ldk-c-bindings/ c_sharp true false 

cd c_sharp
./build-release-nupkg.sh
cd ../  
ls c_sharp/packaging_artifacts
cp c_sharp/org.ldk.nupkg /app/local_output/org.ldk.nupkg 
		  
# Navigate to the repository directory
cd /app/ldk-garbagecollected

# Replace the following commands with your actual GitHub Actions steps
# Run any commands you need to build your project
# For example:
#
# - name: Install required dependencies
#   run: |
#     dnf install -y mingw64-gcc git cargo dotnet clang llvm lld faketime rust-std-static-x86_64-pc-windows-gnu which diffutils
#
# - name: Checkout source code
#   uses: actions/checkout@v2
#   with:
#     fetch-depth: 0
#
# ... Add your GitHub Actions steps here ...

# After running the GitHub Actions steps, you can copy the output to a local folder
# For example, copy files from /app/ldk-garbagecollected/output to /app/local_output
cp -r /app/ldk-garbagecollected/output/* /app/local_output

# Exit the script
exit 0
