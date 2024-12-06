import 'package:encuestas_utn/features/auth/domain/entities/user.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/admin/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDocenteScreen extends ConsumerStatefulWidget {
  static String screenName = 'admin_docente_screen';

  const AdminDocenteScreen({super.key});

  @override
  createState() => _AdminDocenteScreenState();
}

class _AdminDocenteScreenState extends ConsumerState<AdminDocenteScreen> {
  User? _selectedDocente; // Variable para almacenar el docente seleccionado

  // Controladores de texto para el formulario
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(docentesProvider.notifier).obtenerUsuariosPorRol('DOC');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(docentesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Docentes'),
      ),
      body: userState is UserLoading
          ? const Center(child: CircularProgressIndicator())
          : userState is UserError
              ? Center(
                  child: Text(
                    userState.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : userState is UserLoaded
                  ? ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _buildInfoCursoCard(),
                        const SizedBox(height: 10),
                        _buildCreateDocenteTile(),
                        const SizedBox(height: 10),
                        _buildDocentesTable(userState.usuarios),
                        if (_selectedDocente != null) ...[
                          const SizedBox(height: 20),
                          _buildDocenteDetailsCard(_selectedDocente!),
                        ],
                      ],
                    )
                  : const Center(
                      child: Text('No hay docentes disponibles.'),
                    ),
    );
  }

  // Widget para mostrar información del curso
  Widget _buildInfoCursoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información General del Curso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 1),
          Text(
            'Este módulo permite gestionar los docentes asignados.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget para el formulario de creación de docente
  Widget _buildCreateDocenteTile() {
    return ExpansionTile(
      title: const Text(
        'Crear Nuevo Docente',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nombresController,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  BuildContext contextGuardado = context;
                  // Validar campos vacíos
                  if (cedulaController.text.isEmpty ||
                      nombresController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, complete todos los campos'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                    return;
                  }

                  // Intentar crear el docente
                  final success =
                      await ref.read(docentesProvider.notifier).crearDocente(
                            cedulaController.text,
                            nombresController.text,
                            passwordController.text,
                          );

                  // Si tuvo éxito, actualizar la lista de docentes
                  if (success) {
                    await ref
                        .read(docentesProvider.notifier)
                        .obtenerUsuariosPorRol('DOC');
                    if (context.mounted) {
                      ScaffoldMessenger.of(contextGuardado).showSnackBar(
                        const SnackBar(
                          content: Text('Docente creado correctamente'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                    // Limpiar campos del formulario
                    cedulaController.clear();
                    nombresController.clear();
                    passwordController.clear();
                  } else {
                    // Mostrar error si no se pudo crear el docente
                    if (context.mounted) {
                      ScaffoldMessenger.of(contextGuardado).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'No se puede crear el docente, revise los datos'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Crear Docente'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget para mostrar una tabla con la lista de docentes
  Widget _buildDocentesTable(List<User> docentes) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de Docentes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1),
          DataTable(
            showCheckboxColumn: false, // Oculta los checkboxes
            columns: const [
              DataColumn(label: Text('Usuario')),
              DataColumn(label: Text('Cédula')),
            ],
            rows: docentes
                .map(
                  (docente) => DataRow(
                    cells: [
                      DataCell(Text(docente.usuario)),
                      DataCell(Text(docente.cedula)),
                    ],
                    onSelectChanged: (selected) {
                      if (selected ?? false) {
                        setState(() {
                          _selectedDocente = docente;
                        });
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar los detalles del docente seleccionado
  Widget _buildDocenteDetailsCard(User docente) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles del Docente',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1),
          Text('ID: ${docente.id}'),
          Text('Usuario: ${docente.usuario}'),
          Text('Cédula: ${docente.cedula}'),
          Text('Rol: ${docente.rol}'),
          Text('Curso ID: ${docente.cursoId}'),
          // Cambiar Contraseña
          const Text(
            'Cambiar Contraseña',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Nueva Contraseña',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirmación'),
                    content: const Text(
                        '¿Estás seguro de que deseas cambiar la contraseña?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref
                              .read(userProvider.notifier)
                              .actualizarPassword(docente);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Actualizado correctamente'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Guardar'),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedDocente = null;
              });
            },
            child: const Text('Cerrar Detalles'),
          ),
        ],
      ),
    );
  }
}
