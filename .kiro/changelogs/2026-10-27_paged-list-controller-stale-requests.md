# PagedListController descarta respostas obsoletas e abre em loading

**Date**: 2026-10-27
**Type**: Bug Fix
**Status**: Completed

## Summary

Duas correções no `PagedListController`, motivadas pelo `CustomDropdown`
com busca dinâmica (`listController` externo):

- **Itens duplicados ao pesquisar durante um loading**: `_executeSearch`
  chamava `update([])`, que desligava o loading; o guard do
  `fetchNewItems` deixava sair uma segunda requisição em paralelo e as
  duas respostas eram somadas (`state.contains` não deduplica instâncias
  novas). Agora cada requisição recebe uma geração e só a mais recente
  altera itens, erro e loading; `refresh()`, a busca e
  `prepareNewRequest()` invalidam as pendentes.
- **Lista abria vazia antes do loading**: o `refresh()` inicial roda após
  o primeiro frame. Com `initWithRequest: true` o controller já se reporta
  em loading (`isLoading`) até a busca começar. O `CustomDropdown` chama o
  novo `prepareNewRequest()` ao fechar, para a próxima abertura também
  começar em loading, sem exibir os itens anteriores.

## Files Modified

- `lib/src/presentation/controllers/paged_list_controller.dart` -
  `_runFetch` com geração de requisições, `_pendingRequest` em `isLoading`,
  `prepareNewRequest()`; `refresh()` e o guard do `fetchNewItems` checam só
  o loading real.
- `lib/src/presentation/widgets/dropdown/custom_dropdown.dart` -
  `_closeDropdown` chama `prepareNewRequest()` para listas dinâmicas.

## Files Created

- Nenhum.

## Files Deleted

- Nenhum.

## Architecture Impact

- Somente Presentation. `PagedListView`, `PagedWrapView` e
  `PagedTableView` não mudam; lista estática do dropdown segue sem loading.

## Testing

- `dart analyze lib` sem issues.
