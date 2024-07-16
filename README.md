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

1. Conectar ao Banco de Dados:

```bash
def conectar_banco():
    return duckdb.connect(database='duckdb.db', read_only=False)
```
2. Inicializar a Tabela:

```bash
def inicializar_tabela(con):
    con.execute("""
        CREATE TABLE IF NOT EXISTS historico_arquivos (
            nome_arquivo VARCHAR,
            horario_processamento TIMESTAMP
        )
    """)
```

3. Baixar Arquivos do Google Drive:

```bash
def baixar_pasta_google_drive(url_pasta, diretorio_local):
    os.makedirs(diretorio_local, exist_ok=True)
    sleep(1)
    gdown.download_folder(url_pasta, output=diretorio_local, quiet=False, use_cookies=True)
```
4. Listar Arquivos e Tipos:

```bash
def listar_arquivos_e_tipos(diretorio):
    arquivos_e_tipos = []
    for arquivo in os.listdir(diretorio):
        if arquivo.endswith(".csv") ou arquivo.endswith(".json") ou arquivo.endswith(".parquet"):
            caminho_completo = os.path.join(diretorio, arquivo)
            tipo = arquivo.split(".")[-1]
            arquivos_e_tipos.append((caminho_completo, tipo))
    return arquivos_e_tipos
```
5. Ler Arquivo:

```bash
def ler_arquivo(caminho_do_arquivo, tipo):
    if tipo == 'csv':
        return duckdb.read_csv(caminho_do_arquivo)
    elif tipo == 'json':
        return pd.read_json(caminho_do_arquivo)
    elif tipo == 'parquet':
        return pd.read_parquet(caminho_do_arquivo)
    else:
        raise ValueError(f"Tipo de arquivo não suportado: {tipo}")
```

6. Transformar Dados:

```bash
def transformar(df):
    df_transformado = duckdb.sql("SELECT *, quantidade * valor AS total_vendas FROM df").df()
    return df_transformado
```
7. Salvar no PostgreSQL:

```bash
def salvar_no_postgres(df, tabela):
    DATABASE_URL = os.getenv("DATABASE_URL")
    engine = create_engine(DATABASE_URL)
    df.to_sql(tabela, con=engine, if_exists='append', index=False, schema="outros")
```
8. Pipeline Principal:

```bash
def pipeline():
    logs = []
    url_pasta = 'https://drive.google.com/drive/folders/15OWjNuP0xVsZpiXXK7bQzpiQGNwxQi2n?'
    diretorio_local = './pasta_gdown'

    baixar_pasta_google_drive(url_pasta, diretorio_local)
    con = conectar_banco()
    inicializar_tabela(con)
    processados = arquivos_processados(con)
    arquivos_e_tipos = listar_arquivos_e_tipos(diretorio_local)

    for caminho_do_arquivo, tipo in arquivos_e_tipos:
        nome_arquivo = os.path.basename(caminho_do_arquivo)
        if nome_arquivo not in processados:
            df = ler_arquivo(caminho_do_arquivo, tipo)
            df_transformado = transformar(df)
            salvar_no_postgres(df_transformado, "vendas_calculado")
            registrar_arquivo(con, nome_arquivo)
            print(f"Arquivo {nome_arquivo} processado e salvo.")
            logs.append(f"Arquivo {nome_arquivo} processado e salvo.")
        else:
            print(f"Arquivo {nome_arquivo} já foi processado anteriormente.")
            logs.append(f"Arquivo {nome_arquivo} já foi processado anteriormente.")
    return logs
```
## Uso do Docker
1. Construa a imagem Docker:

```bash
docker build -t nome-do-seu-app .
```
2. Execute o container Docker:

```bash
docker run -p 8501:8501 nome-do-seu-app
```
Acesse a aplicação em http://localhost:8501.

Com isso, você terá o pipeline de processamento de arquivos funcionando e integrado com Streamlit para facilitar a interação e visualização dos logs de processamento.
