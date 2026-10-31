# JulogicTUNNEL

**Uma aplicação VPN para Android, de código aberto.**

O JulogicTUNNEL é um projeto de aplicação VPN para Android que procura oferecer uma experiência de utilização simples, desenvolvimento transparente e melhorias impulsionadas pela comunidade.

O projeto acolhe programadores, testadores, investigadores de segurança e utilizadores interessados em contribuir para a sua evolução.

> **Estado do projeto:** Em desenvolvimento. As funcionalidades, a compatibilidade e a disponibilidade podem variar entre versões.

---

## 📱 Transferir a aplicação

Descarrega a versão mais recente do JulogicTUNNEL através da página oficial de lançamentos do projeto no GitHub.

### ⬇️ [Descarregar a versão mais recente](../../releases/latest)

### Como instalar

1. Acede à página de lançamentos (*Releases*).
2. Descarrega o ficheiro APK compatível com o teu dispositivo Android.
3. Se necessário, autoriza a instalação de aplicações provenientes da fonte utilizada para o download.
4. Instala a aplicação e segue as instruções apresentadas no ecrã.

**Importante:** Instala apenas ficheiros APK provenientes de fontes em que confias. Consulta as notas da versão antes de instalares uma atualização.

---

## ✨ Funcionalidades

As funcionalidades disponíveis dependem da implementação atual da aplicação.

- **Aplicação Android:** Desenvolvida para dispositivos Android.
- **Código aberto:** Código-fonte disponível para consulta, estudo e colaboração.
- **Colaboração comunitária:** Aceitamos relatos de erros, sugestões e contribuições de código.
- **Lançamentos versionados:** Disponibilização de APKs e notas de cada versão.
- **Melhoria contínua:** Desenvolvimento orientado para a usabilidade, a fiabilidade e a facilidade de manutenção.

As funcionalidades adicionais serão documentadas à medida que forem implementadas e disponibilizadas.

---

## 🚀 Como começar

### Requisitos

- Um dispositivo Android compatível com a versão mínima suportada pela aplicação.
- Um ficheiro APK obtido através de uma fonte de confiança.
- Uma ligação à Internet para utilizar as funcionalidades VPN.
- Acesso a um servidor ou serviço VPN compatível, conforme a implementação da aplicação.

### Como utilizar

1. Instala e abre o JulogicTUNNEL.
2. Consulta as instruções e as permissões solicitadas pela aplicação.
3. Configura ou seleciona uma ligação VPN suportada, caso seja necessário.
4. Inicia a ligação e autoriza a utilização do serviço VPN nas definições do Android, quando solicitado.
5. Verifica se a ligação está a funcionar corretamente.

Os passos exatos podem variar conforme a versão da aplicação e a configuração do servidor.

---

## 🛠️ Desenvolvimento

O projeto está aberto à participação da comunidade de desenvolvimento Android.

### Código-fonte

Clona o repositório:

```bash
git clone <URL_DO_REPOSITORIO>
cd <NOME_DO_DIRETORIO>
```

Abre o projeto num ambiente de desenvolvimento Android compatível.

Antes de compilar, consulta a configuração do Gradle e os requisitos do Android SDK.

### Como compilar o APK

Se o projeto incluir o Gradle Wrapper, podes gerar uma versão de depuração com:

```bash
./gradlew assembleDebug
```

No Windows, utiliza:

```bat
gradlew.bat assembleDebug
```

O APK gerado encontra-se normalmente em:

```text
app/build/outputs/apk/debug/app-debug.apk
```

**Nota:** Estas instruções pressupõem que o projeto utiliza Gradle e o plugin padrão de aplicações Android. Dependendo das configurações e dependências, poderão ser necessários passos adicionais.

---

## 🤝 Como contribuir

A tua contribuição pode ajudar a tornar o JulogicTUNNEL melhor.

Podes participar através de:

- Relatos de erros e problemas.
- Sugestões de novas funcionalidades.
- Melhorias na interface.
- Correções de código.
- Melhorias na documentação.
- Revisão do código-fonte.
- Testes de novas versões.
- Identificação e comunicação responsável de vulnerabilidades de segurança.

### Processo de contribuição

1. Consulta os problemas existentes para evitar duplicações.
2. Cria uma bifurcação do repositório (*fork*).
3. Cria uma ramificação para as tuas alterações.
4. Implementa e testa as modificações.
5. Envia um pedido de integração (*Pull Request*), explicando o que alteraste e porquê.

Por exemplo:

```bash
git checkout -b funcionalidade/minha-melhoria
```

Procura manter as contribuições organizadas, explicar as alterações importantes e testar o código antes de o submeter.

---

## 🐛 Reportar problemas

Encontraste um erro ou tens alguma dificuldade?

Podes comunicar problemas através da secção **Issues** do GitHub.

Ao criares um relatório, procura incluir:

- Descrição clara do problema.
- Versão da aplicação.
- Modelo do dispositivo.
- Versão do Android.
- Passos necessários para reproduzir o erro.
- Capturas de ecrã ou registos relevantes, quando aplicável.

### Comunicar um problema

[Reportar um problema](../../issues/new)

**Atenção:** Não publiques palavras-passe, chaves privadas, credenciais, ficheiros de configuração confidenciais ou outros dados pessoais nos relatórios públicos.

---

## 🔐 Segurança

A segurança é uma parte importante do desenvolvimento do JulogicTUNNEL.

Se identificares uma vulnerabilidade, evita divulgá-la publicamente antes de a equipa ter oportunidade de a analisar.

Comunica vulnerabilidades de forma responsável através de um canal privado de contacto disponibilizado pelo responsável do projeto.

Nunca partilhes publicamente:

- Palavras-passe.
- Chaves privadas.
- Tokens de acesso.
- Credenciais de servidores.
- Ficheiros de configuração confidenciais.
- Informações que possam comprometer outros utilizadores.

Para mais informações, consulta o ficheiro `SECURITY.md`, caso esteja disponível no repositório.

---

## 📦 Versões e atualizações

As versões oficiais do JulogicTUNNEL serão disponibilizadas na secção de lançamentos do GitHub.

Cada lançamento poderá incluir:

- Ficheiro APK.
- Número da versão.
- Data de publicação.
- Lista de alterações.
- Correções de erros.
- Melhorias implementadas.
- Informações de compatibilidade.

### Consultar lançamentos

[Ver todas as versões](../../releases)

Recomenda-se utilizar sempre as versões disponibilizadas nas páginas oficiais do projeto.

---

## 📝 Histórico de alterações

As alterações importantes do projeto serão documentadas no ficheiro `CHANGELOG.md`.

Este histórico permitirá acompanhar a evolução da aplicação, desde as primeiras versões até às futuras atualizações.

---

## ⚖️ Licença

A licença do projeto deverá ser definida e publicada no ficheiro `LICENSE`.

Caso seja escolhida a **GNU General Public License v3.0 (GPL-3.0)**, o projeto poderá ser utilizado, estudado, modificado e redistribuído nos termos dessa licença, incluindo a possibilidade de distribuição comercial, respeitando as suas condições.

A licença do código-fonte não concede automaticamente direitos sobre marcas, logótipos, identidade visual ou outros materiais protegidos que não estejam expressamente abrangidos.

---

## 🌍 Comunidade

O JulogicTUNNEL é um projeto em evolução e a participação da comunidade é bem-vinda.

Se és programador Android, estudante, entusiasta de tecnologia ou simplesmente alguém interessado no projeto, podes ajudar através de sugestões, testes, documentação e contribuições.

Acreditamos que projetos de código aberto crescem através da colaboração, transparência e partilha de conhecimento.

---

## ⚠️ Aviso legal

O JulogicTUNNEL é disponibilizado para fins tecnológicos e educacionais, respeitando a legislação aplicável.

A utilização da aplicação é da responsabilidade do utilizador.

O projeto não incentiva atividades ilegais, acesso não autorizado a sistemas, violação de privacidade ou utilização abusiva de redes e serviços.

Os utilizadores devem respeitar as leis aplicáveis, os termos dos serviços utilizados e as políticas dos respetivos fornecedores de Internet.

---

## 👨‍💻 Responsável pelo projeto

**JulogicTUNNEL**

Desenvolvido por **JuLogic404**.

Um projeto independente dedicado ao desenvolvimento Android e à inovação tecnológica.

---

**Obrigado por apoiares o JulogicTUNNEL!**

Se gostas do projeto, considera deixar uma ⭐ no repositório, experimentar as versões disponibilizadas e contribuir para o seu desenvolvimento.
