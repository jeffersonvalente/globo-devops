subir a infra na aws, usando terraform.
durante a criação da ec2 posso usar o remote-exec para fazer as instalações necessarias.
  - instalar agent do cloudwatch
  - instalar guicorn e flask
  - subir a aplicação diretamente com o ec2 usando remote-exec

metricas interessantes para o cloudwatch
  - High CPU
  - High Memory
  - High Network
  - HTTP 5xx
  - HTTP Response Time

** preciso liberar a porta 22 e criar as chaves para o remote-exec funcionar, fazer via terraform.
** fazer modular para ficar bonito
** ec2, network, cloudwatch

Melhorias:
- Adicionar o tfstate em um s3, para salvar os estados do arquivo, para todos que vão fazer a manutenção
- usar conteiners, kubernets, hpa para lidar com picos de performance
- criar helmchart para a implementar a aplicação em k8s
- adicionar um loadbalancer para cuidar das requisições
- configurar readiness e liveness
- implementar SLOs e slis da aplicação para manter o monitoramento efetivo
- criar grupos para receberem os alertas (telegram/whatsapp/opsgenie/caixa de emails/rocketchat)
- melhorar o tf, adicionando variaveis claras e reutilizaveis entre os modulos, com tags, location e afins, para ficar mais facil a manutenção
- melhorar a pipeline adicionado testes (sonarqube)
