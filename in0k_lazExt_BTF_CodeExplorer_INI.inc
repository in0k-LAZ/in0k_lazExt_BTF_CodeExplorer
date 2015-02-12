
// определяем режим ДЕБАГ
{.$define lazExt_BTF_CodeExplorer_DEBUG_mode}

// режим работы через winApi
{$define lazExt_BTF_CodeExplorer_WinAPI_mode}

// авто открытие окна {todo}
{.$define lazExt_BTF_CodeExplorer_Auto_SHOW}


//------------------------------------------------------------------------------

{$IFDEF Windows}
{$else}
    {$undef lazExt_BTF_CodeExplorer_WinAPI_mode}
{$endIf}


// по идее это переместить надо
{$ifDef lazExt_BTF_CodeExplorer_DEBUG_mode}
    {$define _DEBUG_}
{$else}
    {$undef  _DEBUG_}
{$endIf}
{$ifDef _DEBUG_}
    {$undef  _INLINE_}
{$else}
    {$define _INLINE_}
{$endIf}

