# base_style_sheet

**Base Style Sheet** é um package auxiliar para Flutter projetado para centralizar e padronizar os componentes visuais de um aplicativo, seja em um ambiente multi-repositório ou mono-repositório. Ele fornece uma estrutura modular para facilitar a gestão de estilos, temas e elementos visuais reutilizáveis.

## 👉 Recursos
- **Centralização de estilos**: Define cores, tipografia e espaçamentos de forma consistente.
- **Gestão simplificada de temas**: Suporte para temas claro e escuro com fácil configuração.
- **Componentes reutilizáveis**: Facilita a criação de botões, inputs e outros elementos visuais padronizados.
- **Compatibilidade com multiplataforma**: Pode ser usado em projetos Flutter para mobile, web e desktop.

## 👉 Instalação
Adicione o **base_style_sheet** ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  base_style_sheet: latest_version
```

Em seguida, rode o comando:

```sh
flutter pub get
```

## 👉 Como Usar
### Exemplo Básico de Uso

```dart
import 'package:base_style_sheet/base_style_sheet.dart';

void main() {
  final theme = AppTheme.light(); // Carrega o tema claro
  print(theme.primaryColor); // Acessa a cor primária do tema
}
```

### Uso com `ThemeData` no Flutter

```dart
MaterialApp(
  theme: AppTheme.light().toThemeData(),
  darkTheme: AppTheme.dark().toThemeData(),
  home: HomePage(),
);
```

## 👉 Contribuição
Contribuições são bem-vindas! Para sugerir melhorias ou reportar problemas, abra uma issue ou envie um pull request no [repositório do GitHub](https://github.com/seu-repositorio).

## 👉 Licença
Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
