import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Livros e Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          elevation: 4,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> entries = [
    {'title': 'O Senhor dos Anéis', 'opinion': 'Uma obra-prima da fantasia'},
    {'title': 'Harry Potter', 'opinion': 'Uma série mágica e envolvente'},
    {'title': 'O Pequeno Príncipe', 'opinion': 'Uma história tocante'},
    {'title': 'A Origem', 'opinion': 'Um filme fascinante'},
    {'title': 'A Rede Social', 'opinion': 'Muito interessante'},
    {'title': 'Parasita', 'opinion': 'Um suspense surpreendente'},
  ];

  final List<Map<String, dynamic>> userOpinions = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController opinionController = TextEditingController();
  String searchText = '';
  String selectedOption = 'Pesquisar';

  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.amber,
  ];

  void _addUserOpinion() {
    if (titleController.text.isNotEmpty && opinionController.text.isNotEmpty) {
      Color iconColor = colors[userOpinions.length % colors.length];
      setState(() {
        userOpinions.add({
          'title': titleController.text,
          'opinion': opinionController.text,
          'iconColor': iconColor,
        });
        titleController.clear();
        opinionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
    }
  }

  void _removeUserOpinion(int index) {
    setState(() {
      userOpinions.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opinião removida com sucesso!')),
    );
  }

  void _showDetails(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(entry['title']),
          content: Text(entry['opinion']),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final combinedEntries = [
      ...entries,
      ...userOpinions,
    ];

    final filteredEntries = combinedEntries.where((entry) {
      return entry['title']!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Livros e Filmes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedOption,
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue!;
                  searchController.clear();
                  titleController.clear();
                  opinionController.clear();
                });
              },
              items: <String>['Pesquisar', 'Adicionar Opinião']
                  .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            if (selectedOption == 'Pesquisar') ...[
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pesquisar Filme/Livro',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: filteredEntries[index]['iconColor'] ??
                              Colors.black,
                        ),
                        title: Text(filteredEntries[index]['title']!),
                        subtitle: Text(filteredEntries[index]['opinion']!),
                        onTap: () => _showDetails(filteredEntries[index]),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título do Filme/Livro',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: opinionController,
                decoration: InputDecoration(
                  labelText: 'Sua Opinião',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addUserOpinion,
                child: Text('Adicionar Opinião'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: userOpinions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: userOpinions[index]['iconColor'],
                        ),
                        title: Text(userOpinions[index]['title']!),
                        subtitle: Text(userOpinions[index]['opinion']!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeUserOpinion(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
