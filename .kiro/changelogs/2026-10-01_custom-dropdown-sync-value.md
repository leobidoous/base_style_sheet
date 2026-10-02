# CustomDropdown sincroniza o valor recebido do pai

**Date**: 2026-10-01
**Type**: Bug Fix
**Status**: Completed

## Summary

O `CustomDropdown` lia `value` só no `initState`: quando o pai mudava o
valor (ex.: limpava o curso ao trocar o nível de formação), o campo seguia
exibindo a seleção anterior até ser recriado (por isso consumidores usavam
`ValueKey` com o valor selecionado). Agora o `didUpdateWidget` sincroniza
`_valueSelected` quando `value` muda.

## Files Modified

- `lib/src/presentation/widgets/dropdown/custom_dropdown.dart` -
  `didUpdateWidget` atualiza o valor exibido quando `widget.value` muda.

## Files Created

- Nenhum.

## Files Deleted

- Nenhum.

## Architecture Impact

- Somente Presentation. Usos não-controlados (valor do pai inalterado) não
  mudam de comportamento.

## Testing

- `dart analyze` sem issues.
