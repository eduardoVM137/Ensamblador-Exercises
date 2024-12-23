# Portafolio de Ensamblador

## Descripción General
Este portafolio contiene una recopilación de programas desarrollados en lenguaje ensamblador utilizando TASM y DEBUG, enfocados en la resolución de problemas y en la implementación de macros, procedimientos y ciclos. Cada proyecto incluye código fuente, instrucciones y conclusiones relevantes.

## Contenido

### 1. Programa: Conversión Binario a Decimal
- **Archivo**: `bin_to_dec.asm`
- **Descripción**: Convierte un número binario ingresado por el usuario a su equivalente decimal.
- **Funciones principales**:
  - Validación de entrada: Asegura que solo se ingresen caracteres válidos ('0' y '1').
  - Conversión: Calcula el valor decimal del número binario usando multiplicación y acumulación.
  - Interfaz: Muestra mensajes de entrada, resultados y errores al usuario.

### 2. Programa: Conversión Binario a Decimal Modular
- **Archivo**: `bin_to_dec_mod.asm`
- **Descripción**: Similar al programa anterior, pero estructurado con procedimientos internos y externos.
- **Funciones principales**:
  - Validación y normalización del número binario.
  - Conversión a decimal usando un procedimiento externo.
  - Macro para mostrar el resultado en pantalla.

### 3. Macro: Posicionamiento del Cursor
- **Archivo**: `cursor_pos.asm`
- **Descripción**: Contiene una macro genérica (`CURSOR`) que permite mover el cursor a cualquier posición de la pantalla en modo texto.
- **Uso**: Utiliza la interrupción `INT 10H` para establecer la posición del cursor.

### 4. Procedimiento: Conversión Binario a Decimal
- **Archivo**: `bin_to_dec_proc.asm`
- **Descripción**: Implementa la lógica para convertir un número binario a decimal.
- **Funciones principales**:
  - Multiplica cada bit por su posición (potencia de 2).
  - Suma los resultados para obtener el valor decimal.

### 5. Programa: Conversión de Caracter a Hexadecimal
- **Archivo**: `char_to_hex.asm`
- **Descripción**: Convierte un carácter ingresado por el usuario a su equivalente hexadecimal y lo muestra.
- **Funciones principales**:
  - Divide el carácter en sus partes alta y baja.
  - Convierte cada parte a su representación hexadecimal.
  - Imprime los resultados en pantalla.

### 6. Programa: Cálculo de Costo de Llamada
- **Archivo**: `call_cost.asm`
- **Descripción**: Calcula el costo total de una llamada telefónica en función de su duración.
- **Funciones principales**:
  - Solicitar duración de la llamada al usuario.
  - Calcular el costo base y adicional según la duración.
  - Mostrar el costo total utilizando una rutina de impresión personalizada.

### 7. Programa: Suma y Resta de Números Hexadecimales
- **Archivo**: `hex_sum_sub.asm`
- **Descripción**: Realiza operaciones aritméticas básicas (suma y resta) con números hexadecimales ingresados por el usuario.
- **Funciones principales**:
  - Captura de tres números hexadecimales (X, Y, Z).
  - Realiza la operación `W = X + Y + 24 - Z`.
  - Muestra el resultado en pantalla en formato hexadecimal.

## Cómo Ejecutar
1. **Requisitos**:
   - TASM y TLINK instalados.
   - Entorno DOSBox o un sistema compatible con MS-DOS.
2. **Pasos**:
   1. Ensamblar el programa:
      ```
      tasm /zi nombre_programa.asm
      ```
   2. Vincular el archivo:
      ```
      tlink /v nombre_programa.obj
      ```
   3. Ejecutar el programa:
      ```
      nombre_programa.exe
      ```

## Conclusión
Este portafolio demuestra habilidades en programación de bajo nivel, aplicando conceptos avanzados como manipulación de registros, macros, procedimientos y ciclos. Está diseñado para mostrar competencias técnicas y organizativas en el desarrollo de soluciones eficientes en lenguaje ensamblador.
