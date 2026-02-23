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