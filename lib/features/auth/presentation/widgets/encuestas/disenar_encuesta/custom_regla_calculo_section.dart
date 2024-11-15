import 'package:encuestas_utn/features/auth/presentation/providers/docente/disenar_encuesta_provider.dart';
import 'package:encuestas_utn/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomReglaCalculoSection extends ConsumerStatefulWidget {
  const CustomReglaCalculoSection({super.key});

  @override
  createState() => _CustomReglaCalculoSectionState();
}

class _CustomReglaCalculoSectionState
    extends ConsumerState<CustomReglaCalculoSection> {
  @override
  Widget build(BuildContext context) {
    final disenarEncuestaNotifier = ref.read(disenarEncuestaProvider.notifier);
    final disenarEncuestaState = ref.watch(disenarEncuestaProvider);

    return ExpansionTile(title: const Text('Reglas de Cálculo'), children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Regla de cálculo:',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ...disenarEncuestaState.reglas.map((regla) {
              return CustomRegla(
                parametros: disenarEncuestaState.parametros,
                reglaId: regla.id,
                estilos: disenarEncuestaState.estilos,
                onDelete: () => disenarEncuestaNotifier.eliminarRegla(regla.id),
                onSelectEstilo: (estilo) => disenarEncuestaNotifier
                    .actualizarReglaEstilo(regla.id, estilo),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  disenarEncuestaNotifier.agregarRegla();
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Crear Regla',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class CustomRegla extends ConsumerStatefulWidget {
  final String reglaId;
  final List<String> estilos;
  final List<String> parametros;
  final VoidCallback onDelete;
  final ValueChanged<String?> onSelectEstilo;
  final ValueChanged<String?> onSelectParametro;

  const CustomRegla({
    super.key,
    required this.reglaId,
    required this.estilos,
    required this.parametros,
    required this.onDelete,
    required this.onSelectEstilo,
    required this.onSelectParametro
  });

  @override
  createState() => _CustomReglaState();
}

class _CustomReglaState extends ConsumerState<CustomRegla> {
  final List<CustomCondicion> _condiciones = [];

  void _agregarCondicion() {
    setState(() {
      _condiciones.add(CustomCondicion(
        parametros: widget.parametros,
        onDelete: () {
          setState(() {
            _condiciones.removeLast();
          });
        },
        onOperacionSeleccionada: (operacion) {
          ref
              .read(disenarEncuestaProvider.notifier)
              .actualizarReglaOperacion(widget.reglaId, operacion);
        },
        reglaId: widget.reglaId, // Asegúrate de pasar el reglaId aquí
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    filled: true,
                    fillColor: const Color(0xFFF0F0F0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text('Selecciona un estilo'),
                  items: widget.estilos.map((estilo) {
                    return DropdownMenuItem<String>(
                      value: estilo,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(estilo),
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onSelectEstilo,
                  selectedItemBuilder: (BuildContext context) {
                    return widget.estilos.map((String estilo) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          estilo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 127, 119),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  iconSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _agregarCondicion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 127, 119),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Añadir Condición',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          ..._condiciones,
        ],
      ),
    );
  }
}

// Clase auxiliar para definir cada opción de la lista
class _Option extends StatelessWidget {
  final List<String> parametros;
  final List<String> operaciones;
  final VoidCallback onDelete;
  final ValueChanged<String?> onOperacionSeleccionada;

  const _Option({
    required this.parametros,
    required this.operaciones,
    required this.onDelete,
    required this.onOperacionSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Parámetro'),
                items: parametros.map((parametro) {
                  return DropdownMenuItem<String>(
                    value: parametro,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        parametro,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.white),
                iconSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text('Operación'),
          items: operaciones.map((operacion) {
            return DropdownMenuItem<String>(
              value: operacion,
              child: Text(operacion),
            );
          }).toList(),
          onChanged: onOperacionSeleccionada,
        ),
      ],
    );
  }
}

class CustomCondicion extends ConsumerStatefulWidget {
  final List<String> parametros;
  final List<String> operaciones = ['+', '-', '*', '/'];
  final VoidCallback onDelete;
  final ValueChanged<String?> onOperacionSeleccionada;
  final String reglaId;
  final String parametroSeleccionado = '';

  CustomCondicion({
    super.key,
    required this.parametros,
    required this.onDelete,
    required this.onOperacionSeleccionada,
    required this.reglaId,
  });

  @override
  createState() => _CustomCondicionState();
}

class _CustomCondicionState extends ConsumerState<CustomCondicion> {
  final List<_Option> _opciones = [];
  final List<String> comparaciones = ['Ninguna', '>', '<', '=', '>=', '<='];
  String? comparacionSeleccionada;
  String cantidad = '';

  void _agregarOpcion() {
    setState(() {
      _opciones.add(_Option(
        parametros: widget.parametros,
        operaciones: widget.operaciones,
        onDelete: () {
          setState(() {
            _opciones.removeLast();
          });
        },
        onOperacionSeleccionada: widget.onOperacionSeleccionada,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildParametroOperacionRow(),
          const SizedBox(height: 8),
          Column(children: _opciones),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _agregarOpcion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Añadir opción',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: AppTexts.softText('El resultado debe ser:'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: const Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            hint: const Text('Seleccione comparación'),
            value: comparacionSeleccionada,
            items: comparaciones.map((comparacion) {
              return DropdownMenuItem<String>(
                value: comparacion,
                child: Text(comparacion),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                comparacionSeleccionada = value;
              });
              ref
                  .read(disenarEncuestaProvider.notifier)
                  .actualizarComparacion(widget.reglaId, value);
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Cantidad',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: const Color(0xFFF0F0F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                cantidad = value;
              });
              ref
                  .read(disenarEncuestaProvider.notifier)
                  .actualizarCantidadResultado(widget.reglaId, value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParametroOperacionRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Parámetro'),
                items: widget.parametros.map((parametro) {
                  return DropdownMenuItem<String>(
                    value: parametro,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        parametro,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {

                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.white),
                iconSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text('Operación'),
          items: widget.operaciones.map((operacion) {
            return DropdownMenuItem<String>(
              value: operacion,
              child: Text(operacion),
            );
          }).toList(),
          onChanged: widget.onOperacionSeleccionada,
        ),
      ],
    );
  }
}
