# Sistema de Estoque e Vendas — PostgreSQL

Projeto desenvolvido para praticar modelagem relacional, regras de negócio, integridade de dados e automação de estoque utilizando PostgreSQL.

O objetivo do sistema é controlar clientes, produtos, vendas, itens vendidos e quantidade disponível em estoque.

## Tecnologias

* PostgreSQL
* DBeaver
* SQL
* PL/pgSQL

## Estrutura do Banco

O projeto possui as seguintes tabelas:

### cliente

Armazena os clientes cadastrados.

Principais campos:

* `id`
* `nome`
* `cpf`

### produto

Armazena os produtos disponíveis para venda.

Principais campos:

* `id`
* `nome`
* `preco`

O preço é armazenado utilizando `NUMERIC(10,2)` e possui uma restrição para impedir valores negativos.

### estoque

Responsável pelo controle da quantidade disponível de cada produto.

Principais campos:

* `id`
* `produto_id`
* `qt_estoque`

Cada produto possui apenas um registro de estoque através de uma restrição `UNIQUE`.

A quantidade disponível nunca pode ser negativa.

### venda

Representa uma venda realizada para um cliente.

Principais campos:

* `id`
* `cliente_id`
* `valor_vendido`
* `data`
* `status`

Os status permitidos são:

* `PENDENTE`
* `PAGA`
* `CANCELADA`

A data da venda é preenchida automaticamente utilizando `CURRENT_TIMESTAMP`.

### itens_venda

Tabela responsável pelo relacionamento entre vendas e produtos.

Principais campos:

* `id`
* `venda_id`
* `produto_id`
* `quantidade`
* `preco_unitario`

O preço unitário é armazenado no momento da venda para preservar o histórico, mesmo caso o preço atual do produto seja alterado posteriormente.

A combinação de `venda_id` e `produto_id` é única, impedindo que o mesmo produto apareça repetido dentro da mesma venda.

## Relacionamentos

```text
CLIENTE
   │
   │ 1:N
   ▼
VENDA
   │
   │ 1:N
   ▼
ITENS_VENDA
   ▲
   │ N:1
PRODUTO
   │
   │ 1:1
   ▼
ESTOQUE
```

## Regras de Negócio

O banco implementa regras como:

* preço de produto não pode ser negativo;
* estoque não pode ficar negativo;
* quantidade vendida deve ser maior que zero;
* preço unitário deve ser maior que zero;
* uma venda deve pertencer a um cliente;
* um item deve pertencer a uma venda e a um produto;
* o mesmo produto não pode aparecer duas vezes na mesma venda;
* apenas determinados status são aceitos em uma venda.

## Baixa Automática de Estoque

Uma função PL/pgSQL chamada:

```sql
fn_baixa_estoque()
```

é responsável por consultar o estoque disponível antes da inserção de um item de venda.

A função verifica:

```text
Produto possui registro de estoque?
        │
        ├── Não → Produto sem registro de estoque
        │
        ▼
Quantidade disponível é suficiente?
        │
        ├── Não → Estoque insuficiente
        │
        ▼
Atualiza quantidade disponível
```

A atualização é realizada com:

```sql
UPDATE estoque
SET qt_estoque = qt_estoque - NEW.quantidade
WHERE produto_id = NEW.produto_id;
```

## Trigger

A trigger:

```sql
trg_baixa_estoque
```

é executada antes de cada inserção em `itens_venda`.

```sql
CREATE TRIGGER trg_baixa_estoque
BEFORE INSERT
ON itens_venda
FOR EACH ROW
EXECUTE FUNCTION fn_baixa_estoque();
```

Isso garante que o estoque seja validado e atualizado automaticamente durante uma venda.

## Testes Realizados

Foi realizado um teste com estoque inicial de:

```text
10 unidades
```

Após uma venda de:

```text
2 unidades
```

o estoque foi atualizado automaticamente para:

```text
8 unidades
```

Também foi testada uma venda acima da quantidade disponível, e a operação foi bloqueada com a mensagem:

```text
Estoque insuficiente
```

## Conceitos Praticados

Durante o projeto foram utilizados:

* Modelagem relacional
* Primary Key
* Foreign Key
* UNIQUE
* CHECK
* NOT NULL
* GENERATED ALWAYS AS IDENTITY
* NUMERIC
* TIMESTAMP
* DEFAULT
* Relacionamentos 1:N e 1:1
* Tabela associativa para relacionamento N:N
* Functions em PL/pgSQL
* Triggers
* Variáveis
* IF / THEN
* RAISE EXCEPTION
* Regras de integridade no banco

## Objetivo do Projeto

Este projeto faz parte de um portfólio voltado para Banco de Dados e foi desenvolvido como evolução de um primeiro projeto de controle financeiro, introduzindo automações e regras de negócio diretamente no PostgreSQL.
