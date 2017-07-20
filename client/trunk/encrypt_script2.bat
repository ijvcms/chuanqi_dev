set root=%cd%
cd %QUICK_V3_ROOT%\tools\cocos2d-console\bin
cocos luacompile -s %root%\src_lua -d %root%\src_ios -e True -k top_game_com -b XXTEA --disable-compile True
echo "加密完成"
pause
