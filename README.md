# Aplicativo InverTexto

Aplicativo desenvolvido em Flutter como trabalho prático acadêmico, integrando recursos e serviços da [API Invertexto](https://api.invertexto.com/).

O projeto conta com 5 funcionalidades completas e funcionais, sendo 2 desenvolvidas previamente durante as aulas e 3 novas implementadas para o trabalho.

---

## 📱 Funcionalidades

### 1. Por Extenso (Aula)
* Converte valores numéricos em sua representação por extenso em língua portuguesa.
* **API utilizada:** `https://api.invertexto.com/v1/number-to-words`

### 2. Busca CEP (Aula)
* Consulta endereços a partir do CEP informado, retornando logradouro, bairro, cidade e estado.
* **API utilizada:** `https://api.invertexto.com/v1/cep/:cep`

### 3. Validador CPF / CNPJ (Nova)
* Valida a autenticidade e formatação de números de CPF e CNPJ.
* **Validações:**
  * Verificação de campo obrigatório antes do envio;
  * Validação de formato (11 dígitos para CPF ou 14 dígitos para CNPJ);
  * Formatação automática do documento e exibição do status (Válido / Inválido);
  * Tratamento de exceções e erros de permissão da API com validação matemática dos dígitos verificadores.
* **API utilizada:** `https://api.invertexto.com/v1/validator`

### 4. Validador de E-mail (Nova)
* Valida o endereço de e-mail verificando a estrutura sintática, registros MX do domínio e se é um endereço descartável.
* **Validações:**
  * Verificação de campo obrigatório;
  * Validação prévia de formato via expressão regular (Regex);
  * Verificação de servidor de e-mail (MX) e descarte temporário;
  * Classificação em E-mail Válido ou E-mail Inválido.
* **API utilizada:** `https://api.invertexto.com/v1/email-validator/:email`

### 5. Conversor de Moedas (Nova)
* Consulta cotações em tempo real e calcula conversões de moedas estrangeiras para Real (BRL).
* Suporta moedas populares pelo nome: **Dólar**, **Euro**, **Yen** (Iene), **Libra**, **Dólar Canadense** e **Peso Argentino**.
* Permite também informar valores numéricos para conversão total (ex: `100 dolar`).
* **Validações:**
  * Campo obrigatório e validação de nome de moeda reconhecido;
  * Exibição da cotação unitária e valor convertido;
  * Horário da última atualização da cotação.
* **API utilizada:** `https://api.invertexto.com/v1/currency/:symbols`

---

## ✅ Requisitos de Validação Atendidos

* **Campos obrigatórios:** Verificação antes do envio de qualquer requisição.
* **Formato dos dados:** Validação de CEP, quantidade de dígitos (CPF/CNPJ), formato de e-mail e identificação de moedas.
* **Tratamento de entradas inválidas:** Exibição de mensagens claras diretamente na interface.
* **Conexão com a internet:** Captura de falhas de rede (`SocketException`) com mensagem amigável.
* **Erros de API:** Tratamento de códigos de retorno e mensagens de erro da API.
* **Carregamento:** Indicador visual (`CircularProgressIndicator`) durante as consultas.
* **Respostas nulas/vazias:** Verificação e proteção contra respostas incompletas ou nulas.
* **Interface consistente:** Mantido o padrão visual das telas desenvolvidas em aula (fundo preto, textos brancos e botões com ícone de edição).

---

## 🛠️ Tecnologias Utilizadas

* [Flutter](https://flutter.dev/) (SDK ^3.12.2)
* [Dart](https://dart.dev/)
* Pacote HTTP (`http: ^1.4.0`)
* [API InverTexto](https://api.invertexto.com/)

---

## 🚀 Como Compilar e Executar

1. Clone o repositório:
```bash
git clone https://github.com/patr0ka/apk_invertexto.git
cd apk_invertexto
```

2. Limpe e instale as dependências:
```bash
flutter clean
flutter pub get
```

3. Execute o aplicativo em um emulador ou dispositivo físico:
```bash
flutter run
```

4. Para gerar o instalador APK otimizado (< 20 MB):
```bash
flutter build apk --split-per-abi
```
Os arquivos gerados estarão em `build/app/outputs/flutter-apk/`:
* `app-arm64-v8a-release.apk` (~16.4 MB - para a grande maioria dos smartphones Android modernos)
* `app-armeabi-v7a-release.apk` (~13.8 MB - para aparelhos de 32 bits)
* `app-x86_64-release.apk` (~17.7 MB - para emuladores x86_64)

Ou para gerar o APK universal único:
```bash
flutter build apk --release
```
Caminho: `build/app/outputs/flutter-apk/app-release.apk`
