# todo_app_flutter

# To-Do App

Una aplicación de gestión de tareas (to-do) desarrollada con Flutter y ASP.NET Core. Esta aplicación permite a los usuarios crear, listar, completar y eliminar tareas. Funciona tanto en entornos web como móviles y se actualiza en tiempo real utilizando WebSockets.

## Características

- **Interfaz de Usuario Adaptativa y Responsiva:** La aplicación funciona en dispositivos móviles y en la web.
- **Gestión de Tareas:** Los usuarios pueden agregar, completar y eliminar tareas.
- **Actualización en Tiempo Real:** Utiliza WebSockets para actualizar las tareas en tiempo real.
- **Visualización de Gráficos:** Muestra un gráfico de pastel con la distribución de tareas completadas, no completadas y eliminadas utilizando `fl_chart`.

## Requisitos Previos

Asegúrate de tener las siguientes herramientas instaladas en tu sistema:

- **Flutter SDK**: [Instalar Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Generalmente incluido con Flutter.
- **Visual Studio Code** o **Android Studio**: Para editar y ejecutar el código.
- **.NET SDK**: Para el backend. [Descargar .NET SDK](https://github.com/Willikox/to-do-appBackend.git)
- **PostgreSQL**: Como base de datos para el backend. [Descargar PostgreSQL](https://www.postgresql.org/download/)
- **Git**: Para clonar el repositorio. [Descargar Git](https://git-scm.com/downloads)

## Configuración del Proyecto

Sigue estos pasos para configurar y ejecutar la aplicación to-do localmente.

### 1. Clonar el Repositorio

Clona el repositorio desde GitHub en tu máquina local e ingresa al archivo

### 2. Restaura dependencia
flutter pub get

### 3. Correr Flutter
flutter run

Agregar Tareas: Usa el botón de agregar (+) para añadir nuevas tareas.
Completar Tareas: Marca las tareas como completadas usando el botón de check.
Eliminar Tareas: Usa el icono de basura para eliminar tareas.
Ver Estadísticas: Navega a la sección de gráficos para ver estadísticas de tareas completadas, no completadas y eliminadas.

