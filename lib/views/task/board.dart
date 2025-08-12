import 'package:flutter/material.dart';

// Utils
import 'package:argos_home/styles.dart' as styles;
import 'package:argos_home/views/utils/app_bar.dart' as appbar;


class Tarjeta {
  String titulo;
  String prioridad;
  Tarjeta(this.titulo, this.prioridad);
}

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<List<Tarjeta>> lists = [
    [Tarjeta('Tarea A', 'CRITICA'), Tarjeta('Tarea B', 'MEDIA')],
    [Tarjeta('Tarea C', 'BAJA')],
    [Tarjeta('Tarea D', 'ALTA')],
    [Tarjeta('Tarea E', 'MEDIA'), Tarjeta('Tarea F', 'BAJA')]
  ];

  Color? getColorByPriority(String prioridad) {
    switch (prioridad) {
      case 'CRITICA':
        return Colors.red[800];
      case 'ALTA':
        return Colors.red[300];
      case 'MEDIA':
        return Colors.amber[400];
      case 'BAJA':
        return Colors.grey[400];
      default:
        return Colors.grey;
    }
  }

  void _showEditDialog(int listIndex, int cardIndex) {
    final tarjeta = lists[listIndex][cardIndex];
    final TextEditingController controller =
    TextEditingController(text: tarjeta.titulo);
    String selectedPriority = tarjeta.prioridad;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration:
              const InputDecoration(hintText: 'Título de la tarjeta'),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: selectedPriority,
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPriority = value);
                }
              },
              items: const [
                DropdownMenuItem(value: 'CRITICA', child: Text('CRÍTICA')),
                DropdownMenuItem(value: 'ALTA', child: Text('ALTA')),
                DropdownMenuItem(value: 'MEDIA', child: Text('MEDIA')),
                DropdownMenuItem(value: 'BAJA', child: Text('BAJA')),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                lists[listIndex].removeAt(cardIndex);
              });
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lists[listIndex][cardIndex] =
                    Tarjeta(controller.text.trim(), selectedPriority);
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar.CustomAppBar(
          title: "Tus Tableros",
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lists.length, (listIndex) {
            return DragTarget<Map<String, dynamic>>(
              onWillAccept: (_) => true,
              onAccept: (data) {
                final tarjeta = data['tarjeta'] as Tarjeta;
                final fromList = data['fromList'] as int;
                final index = data['index'] as int;

                setState(() {
                  lists[fromList].removeAt(index);
                  lists[listIndex].add(tarjeta);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lista ${listIndex + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(lists[listIndex].length, (cardIndex) {
                        final tarjeta = lists[listIndex][cardIndex];
                        return LongPressDraggable<Map<String, dynamic>>(
                          data: {
                            'fromList': listIndex,
                            'index': cardIndex,
                            'tarjeta': tarjeta
                          },
                          feedback: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 260,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(tarjeta.titulo),
                            ),
                          ),
                          childWhenDragging: const SizedBox.shrink(),
                          child: GestureDetector(
                            onTap: () => _showEditDialog(listIndex, cardIndex),
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tarjeta.titulo),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getColorByPriority(
                                            tarjeta.prioridad),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        tarjeta.prioridad,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            lists[listIndex]
                                .add(Tarjeta('Nueva tarjeta', 'MEDIA'));
                          });
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Añadir tarjeta'),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}