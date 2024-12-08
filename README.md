# Facultad de Ingeniería en Ciencias Aplicadas (FICA)

A client to use Estilos API.

App for UTN students and professors

## Tesista

- [x] _Ramirez Henry_

## To run Flutter project on local:

1. Clone this repository

```bash
git clone https://github.com/on-brulera/utn-encuesta-mobile-client
```
2. Copy .env-template and to the copy rename to .env and configurated your variables

3. Install flutter dependencies 
```bash
flutter pub get
```

4. Para cambiar el nombre de la app
```bash
dart run change_app_package_name:main com.utnficaibarra.encuestautn
```

5. Para cambiar el icono de la app
```bash
dart run flutter_launcher_icons
```

5. Para Generar el Boundle (AAB) para Dispositivos Android
```bash
flutter build appbundle
```