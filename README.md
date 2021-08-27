# Servidor WordPress

Infraestrutura para hospedar um servidor wordpress em uma instância EC2 e armazenar os dados produzidos em um RDS.

## Arquitetura

![Project architecture](docs/architecture.svg)

Componentes:

### VPC

Rede privada envolvendo os componentes

### Public subnet

Sub-rede com componentes que possibilitam o acesso externo aos componentes existentes:

- ALB: Application Load Balancer para redirecionar as requisições recebidas em seu DNS público para o servidor web existente na subnet privada.
- Internet Gateway: Habilita acesso a internet aos recursos da VPC.
- Nat Gateway: Permite que componentes em subnets privadas tenham acesso a internet, estes componentes não são acessíveis na internet, apenas possuem acesso a ela.
- Security group: SSH liberado publicamente para acesso ao bastion.
- EC2: Instância t2.micro, esta instância é utilizada apenas para acessar outras instâncias privadas de modo seguro, por isso é chamada de [bastion](https://aws.amazon.com/pt/quickstart/architecture/linux-bastion/).

### Private web server subnet

Sub-rede para o servidor web (EC2):

- Security group:
  - HTTP liberado publicamente;
  - SSH liberado na VPC (10.0.0.0/22).
- EC2: Servidor web com acesso ao banco de dados RDS, a única forma de acesso ao bash é via bastion, não é possível acessá-lo diretamente via internet, apenas via HTTP. Para baixar pacotes como o client do MySQL e PHP é utilizado o Nat Gateway mencionado anteriorment, a instância EC2 é direcionada para o Nat Gateway que por sua vez encaminha a requisição para o Internet Gateway possibilitando o acesso a internet pela instância.

### Private database subnet

Sub-rede para o banco de dados MySQL (RDS)

- Security Group: Acesso liberado a subnet privada (servidor web).
- RDS: MySQL para salvar dados gerados pelo servidor wordpress.

### Implantação

A infraestrutura criada precisa das seguintes variáveis para funcionar corretamente:

| Nome                     | Descricao                                                       | Padrão        |
| ------------------------ | --------------------------------------------------------------- | ------------- |
| wordpress_database       | Nome do banco de dados que será criado                          | wordpress     |
| bastion_key_name         | Key pair para acesso ao bastion (chave .pem)                    | wordpress-lab |
| web_server_key_name      | Key pair para acesso ao web server (chave .pem)                 | wordpress-lab |
| wordpress_user           | Nome do usuário que possuirá acesso a base `wordpress_database` |               |
| wordpress_user_password  | Senha do `wordpress_user`                                       |               |
| master_rds_user          | Nome do usuário master (root)                                   |               |
| master_rds_user_password | Senha do usuário master                                         |               |

**Importante**: A [documentação](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) do terraform orienta que a criação da [Key Pair](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-key-pairs.html) seja feita via console ou fora dos arquivos terraform para não serem armazenados nos arquivos de estado. O direcionamento é que apenas o nome da Key Pair seja utilizado nos arquivos ".tf".
Caso a chave `wordpress-lab` não exista região em que o ambiente será publicado (us-east-1) a infra não será criada. As Keys Pairs podem ser substituidas atribuido as variáveis `bastion_key_name` e `web_server_key_name` novos valores, este processo será detalhado abaixo.

### Variáveis de ambiente

Para criar variáveis que serão identificadas pelo terraform o prefixo **TF_VAR\_** precisa ser utilizado.

#### Powershell

Criar variáveis no powershell:

```Powershell
$env:TF_VAR_wordpress_database = 'exemplo'
$env:TF_VAR_wordpress_user = 'usuario wordpress'
$env:TF_VAR_wordpress_user_password = 'senha super secreta'
$env:TF_VAR_master_rds_user = 'usuario root'
$env:TF_VAR_master_rds_user_password = 'outra senha super secreta'
$env:TF_VAR_bastion_key_name = 'bastion-key-pair'
$env:TF_VAR_web_server_key_name = 'web-server-key-pair'
```

### Shell

Criar variáveis no shell:

```Shell
export TF_VAR_wordpress_database = 'exemplo'
export TF_VAR_wordpress_user = 'usuario wordpress'
export TF_VAR_wordpress_user_password= 'senha super secreta'
export TF_VAR_master_rds_user = 'usuario root'
export TF_VAR_master_rds_user_password = 'outra senha super secreta'
export TF_VAR_bastion_key_name = 'bastion-key-pair'
export TF_VAR_web_server_key_name = 'web-server-key-pair'
```

**Observação**: Criando as as variáveis `TF_VAR_bastion_key_name` e `TF_VAR_web_server_key_name` com os valores acima o padrão "wordpress-lab" definido nas variáveis bastion_key_name e web_server_key_name serão substituidos por **bastion-key-pair** e **web-server-key-pair**, respectivamente.

### Configuração pós implantação

Quando a execução local finalizar 4 outputs serão exibidos conforme imagem abaixo:

http://`ec2-dns`/wp-admin/install.php

ec2_public_address

sudo vim /var/www/html/wp-config.php

i

paste

:x

`ec2-dns`

mysql -u [username] -h [rds-host] -D [database] -p[password]

listar logs da execução
sudo cat /var/log/cloud-init-output.log

SHOW GRANTS FOR 'wordpress'@'%';
