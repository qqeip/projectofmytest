Rem Delete Delphi temporary file 
Rem **************************** 
@echo Delete Delphi temporary file 
@dir/w/s *.~* 
@echo ����Ϊ��ǰĿ¼����Ŀ¼��ʱ�ļ�,�밴�����ȷ��ɾ��! 
@pause 
@for /r . %%a in (.) do @if exist "%%a\*.~*" del "%%a\*.~*" 
@dir/w/s *.dcu
@echo ����Ϊ��ǰĿ¼����Ŀ¼DCU�ļ�,�밴�����ȷ��ɾ��! 
@pause 
@for /r . %%a in (.) do @if exist "%%a\*.dcu" del "%%a\*.dcu"
@dir/w/s *.ddp
@echo ����Ϊ��ǰĿ¼����Ŀ¼DDP�ļ�,�밴�����ȷ��ɾ��! 
@pause 
@for /r . %%a in (.) do @if exist "%%a\*.ddp" del "%%a\*.ddp"  
@echo ɾ���ɹ�! 
@pause 
Rem ****************************