# Data Analyst Challenge 📊

¡Bienvenido a mi repositorio de resolución del desafío de analista de datos!

## Resumen del Proyecto

En este repositorio encontrarás la solución al desafío entregado durante mi entrevista para el puesto de analista de datos. El desafío incluyó varios pasos, desde la creación de cuentas en Snowflake hasta la creación de un proyecto en dbt.

## Creación de Cuenta en Snowflake ❄️

Comenzamos el desafío creando una cuenta en Snowflake, una plataforma de data warehousing en la nube. Esto nos permitió almacenar y analizar grandes volúmenes de datos de manera eficiente.

## Creación de Tablas SQL Customer y Business 🛠️

Luego, creamos tablas SQL para almacenar datos de clientes y negocios. Durante este proceso, nos encontramos con un pequeño problema: la columna `Address` esperaba un valor de tipo `variant`, pero en el SQL existente venía como `str`. La solución fue agregar el comando `TO_VARIANT` antes de la estructura tipo JSON de `Address`.

## Consultas SQL para el Dashboard 📈

Realizamos consultas SQL para obtener los datos necesarios para nuestro futuro dashboard. Estas consultas nos ayudaron a extraer información relevante de nuestras tablas de datos.

## Conexión de Snowflake a Power BI 💻

Conectamos nuestra instancia de Snowflake a Power BI para visualizar los datos de forma interactiva. Esto nos permitió crear un dashboard interactivo que puede ser compartido y explorado por otros usuarios.

## Creación del Dashboard Interactivo 🚀

¡Tenemos un dashboard interactivo conectado directamente desde Snowflake! Puedes verlo [aquí](https://app.powerbi.com/view?r=eyJrIjoiOWVkYmUxODUtYzZkZC00ZWZhLWEyYzEtNDZlODM2NjQyMGE2IiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9).

## Creación del Proyecto dbt 🛠️

Por último, me aventuré en un territorio nuevo para mí: la creación de un proyecto dbt. Usando la línea de comandos y Python, instalé la biblioteca dbt Core para crear una conexión directa a dbt y Snowflake. Después de verificar las conexiones y asegurarme de que los datos estuvieran correctos en el archivo `profile.yml`, aprendí cómo ejecutar el comando `dbt run`. También exploré la página de Getdbt para entender cómo crear tareas y asegurarme de que se ejecuten correctamente.

¡Gracias por revisar mi proyecto! Espero que encuentres útiles las soluciones y aprendizajes que he compartido aquí. ¡No dudes en dejar tus comentarios y sugerencias!


PD: Dejo readme creado por dbt init <proyect>

Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
