# PsyAccess

## Sumário
  * [Descrição do projeto](#descrição-do-projeto)
  * [Funcionalidades](#funcionalidades)
  * [Como rodar a aplicação](#como-rodar-a-aplicação)
  * [Como rodar os testes](#como-rodar-os-testes)
  * [Como executar a análise do código](#como-executar-a-análise-do-código)
  * [Como derrubar a aplicação](#como-derrubar-a-aplicação)

## Descrição do projeto

<p align="justify"> PsyAssess é um sistema que tem como objetivo permitir que psicólogos administrem avaliações psicológicas online, substituindo os tradicionais questionários em papel. Com interfaces separadas para profissionais e pacientes, o sistema simplifica o processo de cadastramento de avaliados, aplicação de instrumentos e análise de resultados. Ele oferece uma solução segura e eficiente para coletar e armazenar dados de avaliações, proporcionando aos psicólogos acesso imediato aos resultados dos testes, mantendo a confidencialidade e a integridade dos dados do avaliado. </p>

## Funcionalidades

### Psicólogos

#### Autenticação
- [x] POST /api/v1/login

#### Gestão de Avaliados
- [x] POST /api/v1/evaluated (cadastrar um novo avaliado)
- [x] GET /api/v1/evaluated (listar todos os avaliados)
- [x] GET /api/v1/evaluated/:id (dados de um avaliado específico)
- [x] PUT /api/v1/evaluated/:id (atualizar dados de um avaliado)
- [x] GET /api/v1/evaluated/:id/instruments (listar os instrumentos de um avaliado)

#### Gestão de Instrumentos
- [x] POST /api/v1/instruments (cadastrar um novo instrumento)
- [x] GET /api/v1/instruments (listar todos os instrumentos)
- [x] GET /api/v1/instruments/:id (dados de um instrumento específico)

#### Aplicação de Instrumentos
- [x] POST /api/v1/evaluations (aplicar um instrumento a um avaliado)
- [x] POST /api/v1/evaluations/:id/send_instrument (enviar por e-mail o link do instrumento ao avaliado)

#### Visualização dos Resultados
- [x] GET /api/v1/evaluations/:id (consultar as informações de um instrumento aplicado)

### Avaliados

#### Confirmação de Dados
- [x] GET /api/v1/confirm/:token (redirecionamento a partir do link no e-mail, com um token único para a sessão de avaliação)
- [x] POST /api/v1/evaluations/:id/confirm_data (confirmação dos dados do avaliado)

#### Execução do Instrumento
- [x] GET /api/v1/evaluations/:id/start (iniciar a execução do instrumento)
- [x] POST /api/v1/evaluations/:evaluation_id/answer (enviar respostas do instrumento)

## Como rodar a aplicação

No terminal, clone o projeto:

```
git clone git@github.com:thalis-freitas/psy_assess_api.git
```

Entre na pasta do projeto:

```
cd psy_assess_api
```

Certifique-se de que o Docker esteja em execução em sua máquina e construa as imagens:

```
docker compose build
```

Suba os containers:

```
docker compose up -d
```

Acesse o container da aplicação:

```
docker compose exec app bash
```

Crie o banco de dados:

```
rails db:create
```

Execute as migrações:

```
rails db:migrate
```

Popule o banco de dados:
```
rails db:seed
```

* Dados do usuário criado para autenticação:

| E-mail             | Senha     |
| ------------------ | --------- |
| debora@psy.assess  | password  |

**OBS:** Para acessar as requisições da API configuradas com o [Bruno](https://www.usebruno.com/), visite o repositório de requisições: [PsyAccess API Requests](https://github.com/thalis-freitas/psy_assess_requests).

## Como rodar os testes

```
rspec
```

## Como executar a análise do código

```
rubocop
```

## Como derrubar a aplicação

```
docker compose down
```
