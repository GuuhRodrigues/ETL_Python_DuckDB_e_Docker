# Projeto de ETL com Python, DuckDB e Docker

## Arquitetura do Workshop:
![Arquitetura](./imgs/arquitetura_workshop.png)

Este projeto demonstra um pipeline de processamento de arquivos que extrai dados de diferentes formatos de arquivo, transforma os dados utilizando DuckDB e Python, e carrega os dados processados em um banco de dados PostgreSQL. Todo o pipeline pode ser executado utilizando Docker e está integrado com Streamlit para uma interface de usuário interativa.

## Índice
1. [Arquitetura](#arquitetura)
2. [Pré-requisitos](#pré-requisitos)
3. [Configuração](#configuração)
4. [Executando a Aplicação](#executando-a-aplicação)
5. [Detalhes do Pipeline](#detalhes-do-pipeline)
6. [Uso do Docker](#uso-do-docker)

## Arquitetura

A arquitetura do projeto segue o modelo ETL (Extract, Transform, Load):

- **Extract (Extração):** Arquivos JSON, CSV e Parquet.
- **Transform (Transformação):** Utilização de DuckDB e Python para transformar os dados.
- **Load (Carregamento):** Os dados transformados são carregados em um banco de dados SQL.

## Pré-requisitos

Antes de começar, você vai precisar ter os seguintes softwares instalados em sua máquina:

- Docker
- Python 3.12.4
- Poetry

## Configuração

1. Clone o repositório:
    ```bash
    git clone https://github.com/seu-usuario/seu-repositorio.git
    cd seu-repositorio
    ```

2. Instale as dependências:
    ```bash
    poetry install
    ```

3. Configure as variáveis de ambiente:
    Crie um arquivo `.env` na raiz do projeto e adicione suas configurações de banco de dados e outras variáveis necessárias.

## Executando a Aplicação

Para executar a aplicação, utilize o Streamlit:

```bash
poetry run streamlit run app.py
```
Acesse a aplicação em http://localhost:8501.

## Detalhes do Pipeline
O pipeline de processamento de arquivos está definido no arquivo pipeline.py e segue os seguintes passos:
