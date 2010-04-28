Rem Delete Delphi temporary file 
Rem **************************** 
@echo Delete Delphi temporary file 
@dir/w/s *.~* 
@echo 以上为当前目录及子目录临时文件,请按任意键确认删除! 
@pause 
@for /r . %%a in (.) do @if exist "%%a\*.~*" del "%%a\*.~*" 
@dir/w/s *.dcu
@echo 以上为当前目录及子目录DCU文件,请按任意键确认删除! 
@pause 
@for /r . %%a in (.) do @if exist "%%a\*.dcu" del "%%a\*.dcu"
@dir/w/s *.ddp
@echo 以上为当前目录及子目录DDP文件,请按任意键确认删除! 
@pause 
@for /r . %%a in (.) do @if exist "%%a\*.ddp" del "%%a\*.ddp"  
@echo 删除成功! 
@pause 
Rem ****************************