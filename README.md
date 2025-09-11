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

### Router + Factory:
- Deixa a navegação fora das Views e padroniza a construção de cenas.

### Multimódulo via múltiplos .xcodeproj (em vez de SPM):
- Mais flexível no dia a dia para excluir/renomear arquivos/pastas, sem as limitações do SPM no Xcode.
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
      ├─ Characters/... (VIP files: Interactor/Presenter/Router/ViewController)
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

## Exemplo do App Rodando
https://github.com/user-attachments/assets/18097d6e-4685-4fd4-8e9f-3844f0edead0



## Pontos de Melhoria Futuros
### Injeção de Dependências
- Adoção de um container de injeção de dependências. Esse container funcionaria como ponto central de configuração, responsável por registrar todas as implementações concretas e expô-las através de protocolos. Assim, cada módulo passaria a depender apenas de contratos públicos (protocolos), e não de implementações específicas.

### Estrutura para CI/CD
- Fundamental para automatizar o fluxo de desenvolvimento. Com isso, cada alteração enviada ao repositório poderia passar automaticamente por validações como: execução de testes unitários, análise estática de código (lint, formatação, métricas de cobertura) e build do projeto.

### Organização do GitFlow.
- Definir uma convenção clara de fluxo de branches e nomenclatura de commits facilita a colaboração entre múltiplos desenvolvedores.
- Adoção de práticas como feature branches, release branches e hotfixes traz mais previsibilidade ao ciclo de releases.
- Além disso, integrar revisões de pull requests dentro do fluxo padronizado ajuda a manter qualidade de código consistente, facilita rastreabilidade de mudanças e evita conflitos desnecessários.

### SwiftUI e SwiftConcurrency
- Evoluir a interface para SwiftUI traria maior produtividade e simplicidade no desenvolvimento de telas, aproveitando a abordagem declarativa que reduz boilerplate de código e melhora a legibilidade.
- Aliar SwiftUI ao uso de Swift Concurrency (async/await, Task, Actors) tornaria a arquitetura mais moderna, segura e escalável.

### Analytics / Crashlytics
- Integrar soluções como Firebase Analytics e Crashlytics permitiria coletar métricas de uso, rastrear falhas e monitorar a saúde do app em produção. 

### SwiftLint
- Adotar o SwiftLint para análise estática do código garante que o projeto siga padrões consistentes de estilo e boas práticas.
- A padronização também contribui para onboarding mais rápido de novos membros na equipe.
