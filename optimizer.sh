#!/bin/sh
if [ $# == 0 ];then
    echo "--- not found dir ---"
    echo "--- please use command like this: '$ ./compress.sh <dir>' or '$ sh compress.sh <dir>' ---"
    exit
fi
if [ ! $# == 1 ];then
    echo "--- dir num > 1 ---"
    exit
fi
path=$(cd "$(dirname "$0")";pwd)
source_dir=$1
[ -d $source_dir"-optimized" ] && rm -rf $source_dir"-optimized"
\cp -R -f $source_dir $source_dir"-optimized"
cd $source_dir
echo "--- start compress png ---"
find . -name "*.png" -print | xargs -n1
pngquant=$path/lib/pngquant
#&&左边的命令（命令1）返回真(即返回0，成功被执行）后，&&右边的命令（命令2）才能够被执行；换句话说，“如果这个命令执行成功&&那么执行这个命令”。||恰恰相反。
if [[ $source_dir =~ "/" ]] ;then
des_dir=$source_dir"-optimized"
else
des_dir="../"$source_dir"-optimized"
fi
echo "--- png_output_des_dir:"$des_dir" ---"
[ -d $des_dir ] || mkdir -p $des_dir
for file in `find . -name "*.png"`
do
    original_file=$file
    file_name=`echo ${original_file#*/}`
    $pngquant $file_name --skip-if-larger --verbose --force -o $des_dir"/"$file_name
done
echo "--- start compress jpg ---"
find . \( -name "*.jpg" -o -name "*.jpeg" \) -print | xargs -n1
jpegoptim=$path/lib/jpegoptim
if [[ $source_dir =~ "/" ]] ;then
des_dir=$source_dir"-optimized"
else
des_dir="../"$source_dir"-optimized"
fi
echo "--- jpg_output_des_dir:"$des_dir" ---"
[ -d $des_dir ] || mkdir -p $des_dir
for file in `find . \( -name "*.jpg" -o -name "*.jpeg" \)`
do
original_file=$file
file_name=`echo ${original_file#*/}`
[[ $file_name =~ "/" ]] && sub_file_path=`echo ${file_name%/*}`
[ -d $des_dir"/"$sub_file_path ] || mkdir -p $des_dir"/"$sub_file_path
[[ $file_name =~ "/" ]] || sub_file_path=""
echo $file_name"===="$des_dir"/"$sub_file_path
$jpegoptim $file -m40 -o -d $des_dir"/"$sub_file_path
done
echo "--- start compress gif ---"
find . -name "*.gif" -print | xargs -n1
gifsicle=$path/lib/gifsicle
if [[ $source_dir =~ "/" ]] ;then
des_dir=$source_dir"-optimized"
else
des_dir="../"$source_dir"-optimized"
fi
echo "--- gif_output_des_dir:"$des_dir" ---"
[ -d $des_dir ] || mkdir -p $des_dir
for file in `find . -name "*.gif"`
do
    original_file=$file
    file_name=`echo ${original_file#*/}`
    $gifsicle $file -O3 --colors 256 --verbose -o $des_dir"/"$file_name
done
echo "--- compress completed ! ---"
