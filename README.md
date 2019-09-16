# UFRGS Mobile

Primeiro aplicativo para dispositivos móveis da Universidade. Possui, em sua primeira versão, enfoque em informações e tarefas úteis do dia a dia, em especial naquelas comumente desempenhadas pelo seu público discente, tais como consulta às notícias veiculadas na página da Universidade e ao cardápio dos restaurantes universitários.

## Começando

Para clonar o repositório, escolha o link HTTPS e não o SSH (onde aparece SSH é só clicar que muda para o HTTPS).

### 1 - Pré-requisitos

Para gerenciamento de bibliotecas, foi utilizado o [Carthage](https://github.com/Carthage/Carthage) em sua maioria e [CocoaPods](https://cocoapods.org/) no caso do [Firebase](https://firebase.google.com/), pois este não possui bom suporte na instalação via Carthage.

Caso o Carthage não esteja instalado, use o seguinte comando:

```
brew install carthage
```

E para instalar o CocoaPods:

```
sudo gem install cocoapods
```

### 2 - Instalando as dependências

Execute:

```
carthage update --platform iOS --no-use-binaries
```

e após:

```
pod install
```

## Sobre o projeto (XCode)

Sempre abrir o projeto com o arquivo `ufrgsmobile.workspace` pois o mesmo contém todos os links de bibliotecas e pods. Quando o projeto é aberto com `ufrgsmobile.xcodeproj` ele não será executável.

### Bibliotecas utilizadas

#### Via Carthage

* `Alamofire`
	* https://github.com/Alamofire/Alamofire
	* Serviços de API rest

* `Kingfisher`
	* https://github.com/onevcat/Kingfisher
	* Tratamento de imagens com link

* `SwiftyJSON`
	* https://github.com/SwiftyJSON/SwiftyJSON
	* Tratamento de arquivos JSON recebidos da API

* `SwiftOverlays`
	* https://github.com/peterprokop/SwiftOverlays
	* Mostrar popups de carregamento
	
* `Hero`
	* https://github.com/HeroTransitions/Hero
	* Transições customizadas

#### Via CocoaPods

* `Firebase/Core` e `Firebase/Messaging`
	* https://firebase.google.com/?hl=pt-br
	* Bibliotecas da Google para gerar notificações com o Firebase

### Em caso de dúvidas

* Augusto Boranga - aboranga@inf.ufrgs.br
* Lucas Flores - lsflores@inf.ufrgs.br
