
NEW RELEASE v.2.0.1.2

[RU]
1. Новый функционал  
   - Возможность указать директорию с дополнительными скинами
      Download All Skins: http://www.alphaskins.com/sfiles/skins/askins.zip
   - Добавлено время перемещения плота и ожидаемое время до завершения  
   - Добавлена возможность изменить размер буфера перемещения файла, новый параметр MoveBufferSize в config.ini
     можно изменять от 1MB до 50MB. При MoveBufferSize=0 значение буфера по умолчанию 1MB. 
	 При увеличении буфера копирования, так же могут увеличиваться и фризы в интерфейсе.  

2. Исправления
   - При выборе скина "standart theme" вылетает исключение - исправлено (обновлена версия скинов 12.15).
   - Не закрывались формы прогресс баров в свернутом состоянии приложения - исправлено.
   - При 100% выполнении прогресс бар показывает 99% - исправлено
   - Другие ошибки в коде 
   
Download binary: https://mega.nz/#F!XFoWkaYL!FqSBonIM1m8pDjqFmOPhxw!uYQ33b5I  
check sum MD5: e39b9710c6242c66e9182b2fded984e6 *PLOTS_GEN_GUI.exe
check sum: SHA: 6e155853624a251cbf91901ccf4d604ef2108e4e *PLOTS_GEN_GUI.exe  
   

NEW RELEASE v.2.0.1.1

[RU]
1. Изменения в интерфейсе
   - Добавлены прогресс бары: 
      при создании нового списка более 100 строк, 
	  при сохранении списка более 100 строк, 
	  при загрузки списка более 100 строк,
	  при очистки списка более 100 строк,	
      при изменении списка более 100 строк.	  
   - Удален с основной формы прогресс бар перемещения файла
   - Установлен лимит создания количества плотсов 10000 строк.
   
2. Исправления
   - Корректно отображается в списке stsrt nons с диапазоном от 2147483647 
   - Исправлена очистка списка (не работало)
   - Исправлена маска char_not_permitted в регулярных выражениях при сохранении файла TaskLis 
   - Другие мелкие исправления
   
Download binary: https://mega.nz/#F!XFoWkaYL!FqSBonIM1m8pDjqFmOPhxw!rQYgCZZT   
check sum MD5: 5ec9442af196235aaa2f970acc0852e7 *PLOTS_GEN_GUI.exe
check sum: SHA: 5f049a6ba4f2ed5bfa69db4d65e46a4ff852ecae *PLOTS_GEN_GUI.exe   


NEW RELEASE v.2.0.0.0
[ENG]
1. Plotters are integrated into the program as resources
   - Automatic choice of a plotter
2. The interface is changed
3. new functions are added
   - AutoRun / autostart
   - Splitting of the list of jobs for execution on several computers
   - An opportunity to change parameters commandline
   - Added the progress-bar of execution 
   - Time of creation of a raft is considered  
4. Other functional improvings of a code

[RU]
1. Плотеры интегрированы в программу как ресурcы
   - Авто выбор плоттера
2. Изменен интерфейс
3. Добавлены новые функции 
   - Авто запуск 
   - Разделение списка заданий для выполнения на нескольких компьютерах
   - Возможность изменять параметры 
   - Добавлен прогресс бар выполнения 
   - считается время создания плота
4. Прочие функциональные улучшения кода 

ScreenShots: https://mega.nz/#F!XFoWkaYL!FqSBonIM1m8pDjqFmOPhxw!fcIQhTKJ
Download archives binary and source: https://mega.nz/#F!XFoWkaYL!FqSBonIM1m8pDjqFmOPhxw
check sum MD5: 2a995c2d34fb517da453788be0dc647e *PLOTS_GEN_GUI.exe
check sum: SHA: d9b3bf15f39655148f1ee278b12b56c8c6b9393f *PLOTS_GEN_GUI.exe


