# 1. Base Image
# Ajustado a 3.13 según tu pyproject.toml (aunque 3.13 aún es experimental, lo mantendré si es lo que quieres usar).
# Si usas Python 3.12, es mejor mantener la versión 3.12-slim.
FROM python:3.13-alpine

# 2. Instalar Poetry (Necesario para manejar las dependencias)
# Instalamos las dependencias necesarias y el propio Poetry.
RUN pip install --no-cache-dir poetry

# 3. Directorio de Trabajo
WORKDIR /app

# 4. Copiar archivos de dependencia (Cache Layer)
# Copiamos solo los archivos de configuración de Poetry.
# Esto permite que Docker cachee la instalación de dependencias si estos archivos no cambian.
COPY pyproject.toml poetry.lock ./

# 5. Instalar dependencias
# El comando de instalación de Poetry.
# --no-root: No intenta instalar el paquete actual como librería.
# --no-dev: Excluye las dependencias de desarrollo.
RUN poetry install --no-root 
#--no-dev

# 6. Copiar el Código de la Aplicación
# Copiamos el resto de tu código, incluyendo manage.py y la carpeta config/.
COPY . /app/

# 7. Exponer el Puerto
EXPOSE 8000

# 8. Comando de Ejecución (¡Corregido!)
# Usamos 'poetry run' para asegurar que el comando se ejecute dentro del entorno virtual de Poetry.
# NOTA: Tu CMD es casi correcto, asumiendo que el nombre de tu proyecto raíz (donde está settings.py) es 'config'.
CMD ["poetry", "run", "gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]