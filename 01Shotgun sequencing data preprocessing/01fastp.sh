#!/bin/bash
usage()
{
    echo $0 '-i <input_folder> -o <output folder> -n <number of threads>'
}

thread=1	#指定默认并发个数
Primary_DIR=$(pwd)
Script_DIR="$( cd "$( dirname "$0"  )" && pwd  )"

while getopts "hi:o:n:" opt
do
	case $opt in
		h)
		  usage
		  exit 0;;
		i)
		  if [ -d "$OPTARG" ]
            then 
            echo '-i: '$OPTARG
            input_folder=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;
        o)
        if [ -d "$OPTARG" ]
            then 
            echo '-o: '$OPTARG
            output_folder=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;
        n)
		  thread=$OPTARG;;
		?)
		  echo "invalid option"
		  echo $OPTARG
		  exit 1;;
	esac
done



#定义获取文件标识ID（flowcell_lane_barcode）的函数##
file_id_func()
{
    file_basename=`basename $file` #获取不带路径的文件名
    file_left=${file_basename%%.*} #截取从左往右第一个小数点之前的文件名
    file_right=${file_basename#*.} #截取从左往右第一个小数点之后的文件名
    file_id=${file_left%_*} #截取从左往右最后一个_之前的文件名，即flowcell_lane_barcode
}

fastp_function()
{
    time fastp -i $i -I $I -o $o -O $O \
    -q 20 -u 40\
    -w 4 -h $h -j $j # -w: 4个内部线程数
}

tmpfile=$$.fifo    #创建管道名称 
mkfifo $tmpfile    #创建管道 
exec 4<>$tmpfile   #创建文件标示4，以读写方式操作管道$tmpfile
rm $tmpfile        #将创建的管道文件清除
# 为并发线程创建相应个数的占位 
{ 
for (( i = 1;i<=${thread};i++ )) 
do 
echo;                #因为read命令一次读取一行，一个echo默认输出一个换行符，所以为每个线程输出一个占位换行 
done 
} >&4                #将占位信息写入管道 

#首先获取一级路径下的文件
for file in $input_folder/*_1.f*.gz #这时的$file带有路径
do
    if [ -f "$file" ]  #变量加双引号以识别空字符串
    then
        read	 #读取一行，即fd4中的一个占位符
        {
        file_id_func #调用获取文件标识ID（flowcell_lane_barcode）的函数##
        ##下面使用fastp进行reads过滤
        echo "Working on "$file_id
        mkdir $output_folder/$file_id
        i=$file                                   #这时的$file带有路径
        I=$input_folder/$file_id"_2."$file_right
        o=$output_folder/$file_id/$file_id"_1.fq.clean.gz"
        O=$output_folder/$file_id/$file_id"_2.fq.clean.gz"
        h=$output_folder/$file_id/$file_id".filter.report.html"
        j=$output_folder/$file_id/$file_id".filter.report.json"
        fastp_function #调用函数运行fastp
        echo >&4 #任务执行完后在fd4中写入一个占位符
        }& #在后台执行任务块
        sleep 5s #暂停
    fi
done <&4                   #指定fd4为整个for的标准输入

#下面获取二级路径（文件夹）中的文件
for folder in `ls $input_folder` #这时的$folder不带路径
do
    if [ -d "$input_folder/$folder" ]
    then
        for file in $input_folder/$folder/*_1.f*.gz #这时的$file带有路径
        do
            if [ -f "$file" ]
            then
                read	 #读取一行，即fd4中的一个占位符
                {
                file_id_func #调用获取文件标识ID（flowcell_lane_barcode）的函数##
                ##下面使用fastp进行reads过滤
                echo "Working on "$file_id
                mkdir $output_folder/$file_id
                i=$file                                   #这时的$file带有路径
                I=$input_folder/$folder/$file_id"_2."$file_right
                o=$output_folder/$file_id/$file_id"_1.fq.clean.gz"
                O=$output_folder/$file_id/$file_id"_2.fq.clean.gz"
                h=$output_folder/$file_id/$file_id".filter.report.html"
                j=$output_folder/$file_id/$file_id".filter.report.json"
                fastp_function #调用函数运行fastp
                echo >&4 #任务执行完后在fd4中写入一个占位符
                }& #在后台执行任务块
                sleep 5s #暂停
            fi            
        done
    fi
done <&4                   #指定fd4为整个for的标准输入

wait                       #等待所有在此shell脚本中启动的后台任务完成 
exec 4>&-                  #关闭管道 
echo "All done!"
