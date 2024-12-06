import 'package:encuestas_utn/features/auth/domain/entities/user.dart';
import 'package:encuestas_utn/features/auth/presentation/providers/admin/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminEstudianteteScreen extends ConsumerStatefulWidget {
  static String screenName = 'admin_estudiante_screen';

  const AdminEstudianteteScreen({super.key});

  @override
  createState() => _AdminEstudianteScreenState();
}

class _AdminEstudianteScreenState
    extends ConsumerState<AdminEstudianteteScreen> {
  User? _selectedDocente; // Variable para almacenar el docente seleccionado
  String _filterCedula = ''; // Filtro para búsqueda por cédula

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(estudiantesProvider.notifier).obtenerUsuariosPorRol('EST');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(estudiantesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Estudiantes'),
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
                        _buildFilterField(),
                        const SizedBox(height: 10),
                        _buildDocentesTable(
                          userState.usuarios
                              .where((docente) =>
                                  docente.cedula.contains(_filterCedula))
                              .toList(),
                        ),
                        if (_selectedDocente != null) ...[
                          const SizedBox(height: 20),
                          _buildDocenteDetailsCard(_selectedDocente!),
                        ],
                      ],
                    )
                  : const Center(
                      child: Text('No hay estudiantes disponibles.'),
                    ),
    );
  }

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
            'Información Básica de Estudiantes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 1),
          Text(
            'Este módulo permite cambiar la contraseña de los estudiantes.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Campo de texto para el filtro
  Widget _buildFilterField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _filterCedula = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Buscar por Cédula',
        border: OutlineInputBorder(),
      ),
    );
  }

  // Tabla paginada con estudiantes
  Widget _buildDocentesTable(List<User> docentes) {
    final dataSource = _DocentesDataSource(
      docentes,
      (docente) {
        setState(() {
          _selectedDocente = docente;
        });
      },
    );

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
      child: PaginatedDataTable(
        header: const Text('Lista de Estudiantes'),
        columns: const [
          DataColumn(label: Text('Usuario')),
          DataColumn(label: Text('Cédula')),
        ],
        source: dataSource,
        rowsPerPage: 10,
        showCheckboxColumn: false,
      ),
    );
  }

  // Widget para mostrar los detalles del docente seleccionado
  Widget _buildDocenteDetailsCard(User docente) {
    final TextEditingController passwordController = TextEditingController();

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
            'Detalles del Estudiante',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1),
          Text('ID: ${docente.id}'),
          Text('Usuario: ${docente.usuario}'),
          Text('Cédula: ${docente.cedula}'),
          Text('Rol: ${docente.rol}'),
          Text('Curso ID: ${docente.cursoId}'),
          const SizedBox(height: 20),

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

// Fuente de datos para la tabla paginada
class _DocentesDataSource extends DataTableSource {
  final List<User> docentes;
  final void Function(User) onSelect;

  _DocentesDataSource(this.docentes, this.onSelect);

  @override
  DataRow? getRow(int index) {
    if (index >= docentes.length) return null;
    final docente = docentes[index];

    return DataRow(
      cells: [
        DataCell(Text(docente.usuario)),
        DataCell(Text(docente.cedula)),
      ],
      onSelectChanged: (selected) {
        if (selected ?? false) {
          onSelect(docente);
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => docentes.length;

  @override
  int get selectedRowCount => 0;
}
