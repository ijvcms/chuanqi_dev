
<?php

include 'new_config.php';

$arr = array();
$v = $_POST['version'];
$channel = $_POST['channel'];
$platform = $_POST['platform'];
$clientAppVer = $_POST['app'];

$clientGameVerGroup = explode('.',$v); 
$clientAppVerGroup = explode('.',$clientAppVer); 


$verLen = 0;//当前平台需要比较的版本索引长度

$channelVer = $versionAndroid;//当前平台版本
$version_list = $version_Android;
$appVer = $appAndroid;

/*
if($channel == "1888"){
	$channelVer = $versionIos_TD;
	$version_list = $version_Ios_TD;
	$appVer = $appIos_TD;
}elseif(substr($channel, 0, 1) == "1"){
	$channelVer = $versionIos;
	$version_list = $version_Ios;
	$appVer = $appIos;
}elseif(substr($channel, 0, 1) == "3"){
   $channelVer = $versionIos_TD_ALL[$channel];
   $version_list = $version_Ios_TD_ALL[$channel];
   $appVer = $appIos_TD_ALL[$channel];
}
*/

$appVerGroup = explode('.',$appVer);

$channelVerArr = explode('.',$channelVer); 
for($index=0;$index<count($version_list);$index++) 
{ 
	$app = $version_list[$index][5]; //应用版本号
	$appGroup = explode('.',$app); 
	$ret = compareVersion($appGroup, $appVerGroup);
	if($ret == true){
       break;
	}
	$vSrc = $version_list[$index][0];//游戏版本号
	$vSrcGroup = explode('.',$vSrc); 
	$ret = compareVersion($vSrcGroup, $channelVerArr);
	if ($ret == true){
		break;
	}
    if($clientAppVer == $app){//先比较应用版本是否等于
    	$ret = compareVersion($vSrcGroup, $clientGameVerGroup);//比较游戏版本
		if ($ret == true){
			array_push($arr,$version_list[$index]);
		}
    }else{
    	$ret = compareVersion($appGroup, $clientAppVerGroup);
    	if($ret == true){//服务器上的应用版本大于客户端的应用版本
    		array_push($arr,$version_list[$index]);
    	}
    }
		
}

//echo count($arr);
$get = false;
echo "[";
for($index=0;$index<count($arr);$index++) {
	if ($get){
		echo ",";
	}
	echo "[\"".$arr[$index][0]."\",\"".$arr[$index][5]."\",".$arr[$index][6].",\"".$arr[$index][3]."\",".$arr[$index][4].",\"".$arr[$index][7]."\""."]";
	$get = true;
}
echo "]";


function compareVersion($dst, $src) {
	//echo $dst[0].".".$dst[1].".".$dst[2]."_".$src[0].".".$src[1].".".$src[2]. "__________";
    	if ($dst[0] > $src[0])
		{ 
			return true;
		}
		else  if ($dst[0] < $src[0])
		{
			return false;
		}
		if ($dst[1] > $src[1])
		{ 
			return true;
		}
		else  if ($dst[1] < $src[1])
		{
			return false;
		}
		if ($dst[2] > $src[2])
		{ 
			return true;
		}
		else  if ($dst[2] < $src[2])
		{
			return false;
		}
		
		return false;
	}


//$_POST['version'];
//echo '[["1.0.1",1,0,"1.0.1/td_839_815.zip",6234643,"[\'更新1\',\'更新2\',\'更新3\']"],["1.1.1",1,0,"1.1.1/td_973_839.zip",13,"[\'更新1\',\'更新2\',\'更新3\']"],["1.2.1",1,0,"1.2.1/td_989_973.zip",13,"[\'更新1\',\'更新2\',\'更新3\']"]]';
?>

