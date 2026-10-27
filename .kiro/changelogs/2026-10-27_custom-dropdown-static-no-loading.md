# CustomDropdown não exibe loading para lista estática

**Date**: 2026-10-27
**Type**: Bug Fix
**Status**: Completed

## Summary

Sem `listController` externo, o `CustomDropdown` criava um controller
interno com `initWithRequest: true`: ao abrir, o `PagedListView` chamava
`refresh()` → `fetchNewItems`, que liga o loading e aguarda
`Durations.medium1`, mesmo com os itens já em memória. A busca seguia o
mesmo caminho. Agora a lista estática é entregue direto ao controller
(`initWithRequest: false`), a busca filtra de forma síncrona, o filtro é
limpo ao fechar e a lista recarrega automaticamente quando `items` muda
(comparação por `value`/`label`, não por referência).

## Files Modified

- `lib/src/presentation/widgets/dropdown/custom_dropdown.dart` -
  `_isStatic`, `_filteredItems`, `_syncStaticItems` e `_itemsChanged`;
  `initState`, `didUpdateWidget`, `_closeDropdown` e `onSearchChanged`
  usam a sincronização direta para listas estáticas.

## Files Created

- Nenhum.

## Files Deleted

- Nenhum.

## Architecture Impact

- Somente Presentation. Com `listController` externo (busca dinâmica) o
  comportamento não muda.

## Testing

- `dart analyze` sem issues.
