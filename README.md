# Módulo 2: Servicio de Redirección

Servicio de redirección para acortador de URLs. Recibe un código corto y redirige al usuario al URL original almacenado en DynamoDB.

## 📋 Descripción

Este módulo es responsable de:

- Recibir códigos cortos vía GET `/{codigo}`
- Validar existencia en DynamoDB
- Redireccionar con código HTTP 302
- Registrar estadísticas de visitas

## 🏗️ Arquitectura

- **AWS Lambda**: Función serverless para procesar redirecciones
- **API Gateway**: Endpoint REST regional
- **DynamoDB**: Base de datos compartida `sortener-urls` (creada por Módulo 1)
- **CloudWatch**: Logs con retención de 7 días
- **IAM**: Roles y políticas con permisos mínimos necesarios

## 🚀 Tecnologías

- Node.js 18.x
- Terraform 1.6.0
- AWS SDK v2
- GitHub Actions

## 📁 Estructura del Proyecto
```
.
├── .github/
│   └── workflows/
│       └── deploy.yml          # Pipeline CI/CD
├── lambda/
│   ├── handler.js              # Lógica de redirección
│   ├── package.json
│   └── package-lock.json
├── terraform/
│   ├── data.tf                 # Data sources (región, account)
│   ├── iam.tf                  # Roles y políticas IAM
│   ├── lambda.tf               # Lambda y CloudWatch logs
│   ├── api_gateway.tf          # API Gateway completo
│   ├── provider.tf             # Configuración AWS y backend S3
│   ├── variables.tf            # Variables de configuración
│   ├── outputs.tf              # Outputs del módulo
│   └── terraform.tfvars        # Valores de variables
├── .gitignore
└── README.md
```

## ⚙️ Configuración

### Pre-requisitos

- Cuenta AWS configurada
- Terraform >= 1.6.0
- Node.js >= 18.x
- Tabla DynamoDB `sortener-urls` ya creada por módulo 1

### Variables de Terraform
```hcl
table_name  = "sortener-urls"
lambda_name = "redirect-service"
```

### Secretos de GitHub (CI/CD)

Configurar en el repositorio:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
