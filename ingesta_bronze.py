import boto3
import json
from datetime import datetime

# 1. Configuración de tu Arquitectura
bucket_bronze = 'datalake-bronze-2026' # Asegúrate de que sea tu nombre exacto
file_name = 'whatsapp_chats_raw.json'

# Buena Práctica: Particionamiento por fecha (hive-style partitioning)
fecha_hoy = datetime.now().strftime('%Y-%m-%d')
s3_path = f"data/ingestion_date={fecha_hoy}/{file_name}"

# 2. Simulando los datos crudos de tu aplicación
mock_data = [
    {
        "user_phone": "+51999888777", 
        "user_message": "Hello, I want to practice past tense", 
        "ai_response": "Great! Let's start. What did you do yesterday?",
        "timestamp": "2026-03-13T08:00:00Z"
    },
    {
        "user_phone": "+51999888777", 
        "user_message": "I go to the park", 
        "ai_response": "Remember, the past tense of 'go' is 'went'. Say: I went to the park.",
        "timestamp": "2026-03-13T08:01:30Z"
    }
]

# 3. Formato JSONL (JSON Lines) - Estándar para Data Lakes
# En lugar de un solo JSON gigante, guardamos cada evento en una nueva línea
with open(file_name, 'w') as file:
    for record in mock_data:
        file.write(json.dumps(record) + '\n')

# 4. Subir a la capa Bronze usando Boto3
print(f"Subiendo datos simulados a s3://{bucket_bronze}/{s3_path} ...")

try:
    s3 = boto3.client('s3', region_name='us-east-1')
    s3.upload_file(file_name, bucket_bronze, s3_path)
    print("✅ ¡Ingesta exitosa! Los datos han aterrizado en la capa Bronze.")
except Exception as e:
    print(f"❌ Error al subir el archivo: {e}")