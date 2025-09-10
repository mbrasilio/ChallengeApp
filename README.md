# ChallengeApp

App iOS (UIKit + ViewCode) feito para um desafio técnico

**Foco:** arquitetura escalável, separação por módulos e demonstração prática de Clean Swift, Coordinator, Factory, injeção de dependências, Design System e Networking leve (sem libs de terceiros).

**Tema:** PokéAPI (listar personagens/pokémons e exibir detalhes).

> Objetivo do recorte: entregar 2 telas (lista + detalhe) bem estruturadas, priorizando clareza arquitetural e testabilidade, mesmo sem cobrir 100% de funcionalidades.

## Arquitetura

### Camadas e padrões principais:

**Clean Swift (VIP):** View ↔ Interactor ↔ Presenter + Router.
Mantém regras de UI, negócio e formatação desacopladas e testáveis.

**Coordinator (AppCoordinator):** orquestra o fluxo global (setup inicial, navegação root, troca de features) mantendo ViewControllers “burros” quanto a navegação.

Factory/Builder: cria cenas e monta wiring de dependências da feature (útil para escalar e facilitar testes/mocks).

Injeção de dependências: feita no App (composition root) e dentro das Factories das features.

Multimódulo via múltiplos .xcodeproj: cada “área” vira um framework/target próprio (UI/DesignSystem, Services/Networking, Features/*).
Permite compilar e evoluir partes do app de forma isolada, além de facilitar samples por feature no futuro.

## Módulos

### ChallengeApp (App)
- Ponto de entrada (UIKit, sem Storyboard para telas; apenas LaunchScreen).
- AppDelegate, SceneDelegate, AppCoordinator.
- Composition root da DI (injeta services nas features).

### UI/DesignSystem
- DesignSystem.framework
- Componentes reutilizáveis (cores, tipografia, botões, células, estilos), Assets e extensões de UI.
- Geração de código de assets via SwiftGen.

### Services/Networking
- Networking.framework
- EndpointApi (URL, método, headers, body, timeout),
- NetworkService (URLSession), NetworkServicing (protocolo para mock),
- CustomError (domínio de erros com mapeamento por HTTP status e descrições amigáveis).
- Sem libs externas; requests e parsing com JSONDecoder.

### Features/Characters
- FeatureCharacters.framework
- Implementação Clean Swift da feature Pokémon (lista + detalhe).
- Localizables próprios e geração via SwiftGen.

> Observação: a estrutura já está preparada para um projeto multimodular com mais features (Features/<NovaFeature>), mantendo o Design System e Services compartilhados.

## Por que essas escolhas?
### Clean Swift:
- Separa responsabilidades com clareza, facilita testes de negócio (Interactor) e formatação (Presenter).

### Coordinator + Factory:
- Deixa a navegação fora das Views e padroniza a construção de cenas, útil quando o app cresce (ou vários times mexem em features diferentes).

### Multimódulo via múltiplos .xcodeproj (em vez de SPM):
- Mais flexível no dia a dia para excluir/renomear arquivos/pastas, sem as limitações do SPM no Xcode UI.
- Facilita targets de sample por feature (ex.: rodar só Characters com um app “demo”).
- Se no futuro os módulos forem publicados/compartilhados, dá para migrar para SPM/XCFramework com pouco atrito.

### SwiftGen: 
- Padroniza acesso a Strings e Assets, evita typos e dá autocompletion.

## Estrutura de Pastas
```txt
ChallengeApp/
├─ ChallengeApp/                   # App (UIKit, Coordinator, DI)
├─ UI/
│  └─ DesignSystem/
│     ├─ DesignSystem.xcodeproj
│     ├─ DesignSystem/Generated/   # SwiftGen (Assets)
│     ├─ DesignSystem/Resources/   # .xcassets, cores, fontes
│     └─ swiftgen.yml
├─ Services/
│  └─ Networking/
│     ├─ Networking.xcodeproj
│     ├─ Networking/Service/       # NetworkService, protocols
│     ├─ Networking/Error/         # CustomError
│     ├─ Networking/Extensions/
│     ├─ Networking/Generated/     # SwiftGen (Strings)
│     └─ swiftgen.yml
└─ Features/
   └─ Characters/
      ├─ Characters.xcodeproj
      ├─ Characters/Localizable/Localizable.strings
      ├─ Characters/Generated/     # SwiftGen (Strings)
      ├─ Characters/... (VIP files: Interactor/Presenter/Router/View)
      └─ swiftgen.yml
```

## Como rodar

### 1. Clonar
```bash
git clone https://github.com/mbrasilio/ChallengeApp
cd ChallengeApp
```

### 2. Abrir o workspace
- Abra ChallengeApp/ChallengeApp.xcworkspace.

### 3. SwiftGen (uma vez, local)
- **Pré-requisito:** brew install swiftgen
- Gerar código (opção manual):

```bash
# Design System
(cd UI/DesignSystem && swiftgen)
# Networking
(cd Services/Networking && swiftgen)
# Characters
(cd Features/Characters && swiftgen)
```
  
### 4. Selecionar o scheme ChallengeApp e Run.

## Pontos de Melhoria
- Adicionar scripts para geração automática do swiftgen

_STILL IN PROGRESS_
