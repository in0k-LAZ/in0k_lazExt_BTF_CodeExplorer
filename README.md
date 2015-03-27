Описание
========

**Пакет расширение Lazarus IDE**: перемещение на передний план окна ["Code Explorer"](http://wiki.freepascal.org/IDE_Window:_Code_Explorer) при переходе в окно ["Source Editor"](http://wiki.freepascal.org/IDE_Window:_Source_Editor).

##Использование

Допустим, работая дизайненре окна "**Form Editor**" и имея расположение окон *(a)*, нажав клавишу **F12**, для перехода в режим редактирования исходного кода формы, получим следующую картинку *(с)*

| a | b | c |
|---|---|---|
|![рис. 1](https://github.com/in0k-LAZ/in0k_lazExt_aBTF_ObjectInspector/blob/master/IDE_FormEditor_ObjectInspector.png)| **F12** |![рис. 2](https://github.com/in0k-LAZ/in0k_lazExt_aBTF_ObjectInspector/blob/master/IDE_SourceEditor_CodeExplorer.png)|

где:

1. окно "**Source Editor**" получившее фокус
2. окно "**Code Explorer**" автоматически перемещенное на "передний" план.

## Настройка и установка

1. Скопировать исходники в любую удобную директорию `<$someDir>`.
2. Открыть файл `<$someDir>/in0k_lazExt_aBTF_CodeExplorer.lpk` в **Lazarus IDE**.
3. Настроить редактируя файл `<$someDir>/in0k_lazExt_aBTF_CodeExplorer_INI.inc`.
4. Скомпилировать и установить пакет.

*замечания*: подробно про установку пакетов должно быть написано [тут](http://wiki.freepascal.org/Install_Packages). 

