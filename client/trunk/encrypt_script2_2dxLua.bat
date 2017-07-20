set root=%cd%
cd %QUICK_V3_ROOT%\tools\cocos2d-console\bin
cocos luacompile -s %root%\src_lua -d %root%\src -e True -k 2dxLua -b XXTEA --disable-compile True
echo "COMPLETE"
pause
