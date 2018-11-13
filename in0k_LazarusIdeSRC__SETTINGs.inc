
//------------------------------------------------------------------------------
//
// Опции настройки компиляции
//
//------------------------------------------------------------------------------

// определяем режим ДЕБАГ
//  Позволяет просматривать лог событий в отдельном окне из IDE
//  View -> IDE Internals -> [eventLog] lazExt_BTF_CodeExplorer
{.$define lazExt_aBTF_CodeExplorer_EventLOG_mode}
{$define in0k_LazarusIdeEXT__DEBUG}


// Режим работы через winApi.
//  Позволяет "вытягивать" окно CodeExplorer на ПЕРД топ позицию, что позволяет
//  исключить мерцание окон SourceEditor.
//  Использует мотоды Windows API, поэтому в системах отличных от Windows
//  автоматически отключается (так как не тестировалась).
{$define lazExt_aBTF_CodeExplorer_WinAPI_mode}

// Авто открытие окна CodeExplorer.
//  Pаботает ТОЛЬКО в режиме lazExt_aBTF_CodeExplorer_WinAPI_mode.
//  В обычном режиме это НЕ отключаемая опция.
{.$define lazExt_aBTF_CodeExplorer_Auto_SHOW}

// Кешровать окно CodeExplorer.
//  Но это сомнительная оптимизация.
//  Pаботает ТОЛЬКО в режиме lazExt_aBTF_CodeExplorer_WinAPI_mode.
{.$define lazExt_aBTF_CodeExplorer_cacheCodeExplorer}


//------------------------------------------------------------------------------
//
// Тюнинг настроек в зависимости от Целевой Системы
//
//------------------------------------------------------------------------------

{$IFDEF Windows}
{$else}
    {$undef  lazExt_aBTF_CodeExplorer_WinAPI_mode}
    {$undef  lazExt_aBTF_CodeExplorer_cacheCodeExplorer}
    {$define lazExt_aBTF_CodeExplorer_Auto_SHOW}
{$endIf}

