
Pipeline CI/CD para Implantação de Infraestrutura e Aplicativos com Terraform
Este repositório contém a configuração da pipeline CI/CD para automatizar a implantação de infraestrutura usando Terraform e implantar aplicativos em instâncias AWS EC2. A pipeline é acionada em "pushes" para o ramo main.

Etapas do Fluxo de Trabalho
Verificar Repositório: Clona o conteúdo do repositório.
Copiar Arquivos Terraform: Copia os arquivos de configuração do Terraform do diretório terraform/.
Copiar Arquivos do Aplicativo: Copia os arquivos do aplicativo do diretório app/.
Configurar Terraform: Configura o Terraform com a versão especificada.
Inicializar Terraform: Inicializa o Terraform.
Validar Terraform: Valida a configuração do Terraform.
Aplicar Terraform: Aplica as alterações do Terraform, provisionando a infraestrutura na AWS.
Configuração do Terraform
A configuração do Terraform neste repositório define os componentes de infraestrutura necessários para a implantação do aplicativo:

Provedor: Configura o provedor AWS com a região especificada.
Módulos:
network: Define o VPC e os componentes de rede.
ec2: Implanta instâncias EC2 com configurações especificadas.
cloudwatch: Configura o monitoramento do CloudWatch para instâncias EC2.
Provisionamento da Instância EC2
Fonte de Dados da AMI: Recupera a última AMI do Ubuntu.
Variáveis:
key_name: Nome da chave SSH para autenticação.
Recursos:
tls_private_key: Gera uma chave privada RSA.
aws_key_pair: Cria um par de chaves AWS para acesso SSH.
aws_instance: Define uma instância EC2 com configurações especificadas.
Provisiona a instância com pacotes necessários e configuração do aplicativo usando provisionadores remote-exec.
Implanta o aplicativo e o inicia usando o Gunicorn.
Saídas
IPs Globais da EC2: Saída os endereços IP públicos das instâncias EC2 implantadas.
Como Usar
Faça um fork ou clone este repositório.
Adicione suas configurações do Terraform ao diretório terraform/ e seus arquivos de aplicativo ao diretório app/.
Certifique-se de que suas credenciais da AWS estejam configuradas de forma segura como segredos (AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY).
Acione a pipeline enviando alterações para o ramo main.
Monitore a execução da pipeline e acesse o aplicativo implantado usando os IPs públicos da EC2 fornecidos.
