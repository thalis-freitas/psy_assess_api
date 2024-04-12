# PsyAccess

## Sumário
  * [Descrição do projeto](#descrição-do-projeto)
  * [Funcionalidades](#funcionalidades)

## Descrição do projeto

<p align="justify"> PsyAssess é um sistema que tem como objetivo permitir que psicólogos administrem avaliações psicológicas online, substituindo os tradicionais questionários em papel. Com interfaces separadas para profissionais e pacientes, o sistema simplifica o processo de cadastramento de avaliados, aplicação de instrumentos e análise de resultados. Ele oferece uma solução segura e eficiente para coletar e armazenar dados de avaliações, proporcionando aos psicólogos acesso imediato aos resultados dos testes, mantendo a confidencialidade e a integridade dos dados do avaliado. </p>

## Funcionalidades

### Psicólogos

#### Autenticação
- [x] POST /api/v1/login

#### Gestão de Avaliados
- [ ] POST /api/v1/evaluated (cadastrar um novo avaliado)
- [x] GET /api/v1/evaluated (listar todos os avaliados)
- [x] GET /api/v1/evalueted/:id (dados de um avaliado específico)
- [ ] GET /api/v1/evalueted/:id/instruments (listar os instrumentos de um avaliado)

#### Gestão de Instrumentos
- [ ] POST /api/v1/instruments (cadastrar um novo instrumento)
- [ ] GET /api/v1/instruments (listar todos os instrumentos)
- [ ] GET /api/v1/instruments/:id (dados de um instrumento específico)

#### Aplicação de Instrumentos
- [ ] POST /api/v1/evaluations (aplicar um instrumento a um avaliado)
- [ ] POST /api/v1/send_instrument/:evaluation_id (enviar por e-mail o link do instrumento ao avaliado)

#### Visualização dos Resultados
- [ ] GET /api/v1/evaluations/:id/results (visualizar os resultados de um instrumento finalizado)

### Avaliados

#### Confirmação de Dados
- [ ] GET /api/v1/confirm/:token (redirecionamento a partir do link no e-mail, com um token único para a sessão de avaliação)
- [ ] POST /api/v1/confirm (confirmação dos dados do avaliado)

#### Execução do Instrumento
- [ ] GET /api/v1/evaluations/:id/start (iniciar a execução do instrumento)
- [ ] POST /api/v1/evaluations/:id/answer (enviar respostas do instrumento)

<div align="center">
  :construction: Em desenvolvimento...
</div>
