import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# 1. Inicializar el contexto de Spark y Glue
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

# Nombres de tus buckets (Asegúrate de que coincidan con tu main.tf)
BRONZE_PATH = "s3://datalake-bronze-2026/data/"
SILVER_PATH = "s3://datalake-silver-2026/data/"

print("Iniciando extracción de la capa Bronze...")

# 2. Leer los datos crudos (JSON) desde Bronze
# spark.read.json es lo suficientemente inteligente para leer todos los archivos de la carpeta
df_bronze = spark.read.json(BRONZE_PATH)

# (Aquí, en el mundo real, harías limpieza de nulos, formateo de fechas, etc.)
print("Transformación completada. Escribiendo en capa Silver...")

# 3. Escribir los datos en Silver en formato PARQUET
# mode("overwrite") asegura que si corres el job dos veces, no dupliques datos
df_bronze.write \
    .mode("overwrite") \
    .format("parquet") \
    .save(SILVER_PATH)

print("¡Trabajo ETL completado con éxito!")