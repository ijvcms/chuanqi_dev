<?php

define('SVN_RES_URL', "C:/work/client/wewars/wewars/res");
define('SVN_SRC_URL', "C:/work/client/wewars/wewars/src");

//版本列表，第一个是apk的整包，后面是svn上的版本号，只会对最后面的apk的组做增量打包
//array("1.0.1",      1183,       1184,"1.0.1/td_1184_1183.zip",   11876,           1,    0,"更新模块优化#天气预报点错后不能进入下一题#别踩白块优化"),
//      游戏版本号,svn开始版本, svn结束版本,                 下载地址,  文件大小,   应用版本号,是否强制删除更新文件    
$version_Android = array(
    array("1.0.0",0,0,"0",0,"1.0.0",0,"更新内容"),
	
    //array("2.2.2",15421,16778,"http://txsc-res.wewars.com/15421_16778_jit2.zip",5556026,"1.4.1",0,"更新内容"),
   
    array("2.4.3",20035,20501,"http://txsc-res.wewars.com/20035_20501_jit2.zip",78614,"1.4.3",0,"更新内容"),
   
);

$version_Ios = array(
    //array("1.2.3",9043,9980,"http://txsc-res.wewars.com/9043_9974_4.zip",16776278,"1.1.0",0,"更新内容"),
 
);

//ios 审核
$version_Ios_TD = array(
    // array("1.2.4",9974,9974,"http://txsc-res.wewars.com/9974_9974.zip",314080,"1.2.1",0,"更新内容"), 
   
);

$version_Ios_TD_ALL = array(
    "3888" => array(
        // array("1.4.1",10458,11243,"http://txsc-res.wewars.com/10458_11243_4.zip",20346,"1.2.4",0,"更新内容"),
    )
);


$versionIos = "1.0.0";
$appIos = "1.0.0";//开放的应用版本
$versionAndroid = "1.0.0";
$appAndroid = "1.0.0";//开放的应用版本


$versionIos_TD = "1.4.3";
$appIos_TD = "1.2.2";//开放的应用版本

$versionIos_TD_ALL = array(
	 "3888" => "1.4.3",
);

$appIos_TD_ALL = array(
	"3888" => "1.2.4",
);

?>