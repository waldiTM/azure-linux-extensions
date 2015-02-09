#!/bin/bash
proj_name="aem"
proj_version="1.0"

proj_full_name="$proj_name-$proj_version"

script=$(dirname $0)
root=$script/..
cd $root
root=`pwd`

build_dir=$root/build
target_dir=$build_dir/$proj_full_name

mkdir -p $build_dir
mkdir -p $target_dir

cd $root/clib
make clean

cd $root/nodejs
npm pack

cp -r $root/clib $target_dir
cp $root/nodejs/*.tgz $target_dir
cp $root/bin/setup.sh $target_dir
chmod +x $root/bin/setup.sh

echo "#!/bin/bash" > $build_dir/install.sh
echo "root=\$(dirname \$0)" >> $build_dir/install.sh
echo "cd \$root" >> $build_dir/install.sh
echo "root=\`pwd\`" >> $build_dir/install.sh
echo "sed -e '1,/^exit$/d' "\$0" | tar xzf -" >> $build_dir/install.sh
echo "$proj_full_name/setup.sh" >> $build_dir/install.sh
echo "exit" >> $build_dir/install.sh
cd $build_dir
tar czf - $proj_full_name >> $build_dir/install.sh
chmod +x $build_dir/install.sh
