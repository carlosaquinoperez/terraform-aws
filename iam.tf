# 1. Creamos la Política (El manual de reglas)
resource "aws_iam_policy" "datalake_access" {
  name        = "SpikioDataLakeAccessPolicy"
  description = "Permite a los servicios de datos leer y escribir en el Data Lake Medallon"

  # jsonencode traduce nuestro código a formato JSON que AWS entiende
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "s3:GetObject",    # Permiso para LEER archivos (SELECT)
          "s3:PutObject",    # Permiso para ESCRIBIR archivos (INSERT)
          "s3:ListBucket"    # Permiso para ver qué hay dentro de la carpeta
        ]
        # Usamos el comodín (*) para no tener que escribir los 3 buckets a mano
        Resource = [
          "arn:aws:s3:::datalake-*-2026",    # Permiso sobre el "contenedor"
          "arn:aws:s3:::datalake-*-2026/*"   # Permiso sobre los "archivos" dentro del contenedor
        ]
      },
    ]
  })
}

# 2. Creamos el Rol (El "gafete" para la máquina de procesamiento)
resource "aws_iam_role" "datalake_role" {
  name = "SpikioDataProcessorRole"

  # Trust Policy: Define QUIÉN se puede poner este gafete
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          # Permitimos que servicios como AWS Glue (o integraciones de Spark) asuman este rol
          Service = "glue.amazonaws.com" 
        }
      },
    ]
  })
}

# 3. Engrapamos el Documento al Gafete (Role Policy Attachment)
resource "aws_iam_role_policy_attachment" "datalake_attach" {
  role       = aws_iam_role.datalake_role.name      # El nombre del rol que acabamos de crear
  policy_arn = aws_iam_policy.datalake_access.arn   # El ARN de la política que tú ya tenías arriba
}

# 4. Le damos permiso al Rol para que pueda escribir en el Catálogo de Glue
resource "aws_iam_role_policy_attachment" "glue_service_attach" {
  role       = aws_iam_role.datalake_role.name
  # Esta es una política administrada por AWS (ya viene pre-creada)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}