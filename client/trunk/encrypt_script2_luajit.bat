set root=%cd%
cd %QUICK_V3_ROOT%\quick\bin
compile_scripts -i %root%\src_lua -m files -o %root%\src_jit -e xxtea_chunk -ek top_game_com -es XXTEA -ex luac
echo "加密完成"
pause

