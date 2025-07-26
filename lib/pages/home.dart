import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesX extends StatefulWidget {
  const NotesX({super.key});

  @override
  State<NotesX> createState() => _NotesXState();
}

class _NotesXState extends State<NotesX> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tarefas = [];
  late AnimationController _animationController;

  String? emailUsuario;
  String? senhaUsuario;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailUsuario = prefs.getString('email');
      senhaUsuario = prefs.getString('password');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAdicionarTarefaDialog() {
    TextEditingController novaTarefaController = TextEditingController();
    TextEditingController tituloTarefaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.add_task_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Adicionar Nova Tarefa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey[900],
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Digite o título da tarefa',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: novaTarefaController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Conteúdo da tarefa',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        if (novaTarefaController.text.isNotEmpty) {
                          setState(() {
                            _tarefas.add(novaTarefaController.text);
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Adicionar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _salvarTarefas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tarefas', _tarefas);
  }

  void _adicionarTarefa() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tarefas.add(_controller.text);
        _controller.clear();
      });
      _animationController.forward().then((_) {
        _animationController.reset();
      });
    }
  }

  void _removerTarefa(int index) {
    String tarefaRemovida = _tarefas[index];
    setState(() {
      _tarefas.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa removida com sucesso!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red.shade600,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            setState(() {
              _tarefas.insert(index, tarefaRemovida);
            });
          },
        ),
      ),
    );
  }

  void _editarTarefa(int index) {
    TextEditingController editController = TextEditingController(
      text: _tarefas[index],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Edite sua tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarefas[index] = editController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _visualizarTarefa(int index) {
    // Obtém a data/hora atual (ou, idealmente, salve a data/hora ao criar a tarefa)
    DateTime agora = DateTime.now();

    String dataFormatada =
        '${agora.day.toString().padLeft(2, '0')}/${agora.month.toString().padLeft(2, '0')}/${agora.year}';
    String horaFormatada =
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.description_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Conteúdo da Tarefa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey[900],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tarefas[index],
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Text(
                            '$dataFormatada • $horaFormatada',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Fechar',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.user, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(16),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.blue.shade700,
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Dados do Usuário',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.grey[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'E-mail: ${emailUsuario ?? "Não encontrado"}',
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.grey[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Senha: ${senhaUsuario ?? "Não encontrada"}',
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Fechar',
                                style: TextStyle(
                                  color: Colors.blueGrey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 253, 253, 253),
                    Color.fromARGB(255, 24, 23, 24),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.notes, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'NotesX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.home_rounded, color: Colors.blue.shade700),
              ),
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: Colors.purple.shade700,
                ),
              ),
              title: const Text(
                'Configurações',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.list_alt_rounded, color: Colors.grey[600], size: 24),
                SizedBox(width: 8),
                Text(
                  'Suas Tarefas (${_tarefas.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _tarefas.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma tarefa ainda',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione uma tarefa para começar!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _tarefas.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              onTap: () => _visualizarTarefa(index),

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                _tarefas[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red.shade400,
                                  ),

                                  onPressed: () => _removerTarefa(index),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search, size: 20),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_color_rounded),
            label: 'Adcionar Tarefa',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 3) {
            _showAdicionarTarefaDialog();
          }
        },
      ),
    );
  }
}
