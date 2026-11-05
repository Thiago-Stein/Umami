import 'package:flutter/material.dart';
import 'Cores.dart';

class Receita {
  final int id;
  final String nome;
  final int minutos;
  final String dificuldade;
  final double nota;
  final IconData icone;

  const Receita({
    required this.id,
    required this.nome,
    required this.minutos,
    required this.dificuldade,
    required this.nota,
    required this.icone,
  });
}

const List<Receita> _receitasProvisorias = [
  Receita(
    id: 1,
    nome: 'Pizza de lombo com abacaxi',
    minutos: 35,
    dificuldade: 'Fácil',
    nota: 4.8,
    icone: Icons.local_pizza,
  ),
  Receita(
    id: 2,
    nome: 'Vinho suave caseiro',
    minutos: 20,
    dificuldade: 'Difícil',
    nota: 4.5,
    icone: Icons.wine_bar_rounded,
  ),
  Receita(
    id: 3,
    nome: 'Bolo de cenoura com cobertura de chocolate',
    minutos: 25,
    dificuldade: 'Médio',
    nota: 4.8,
    icone: Icons.cake_rounded,

  ),
];

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final Set<int> _favoritos = {};
  int _abaAtual = 0;

  String? _termoPesquisado;

  static const _estiloSecundario = TextStyle(
    fontSize: 13,
    color: Cores.textoSecundario,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// Lógica da pesquisa //
  String _normalizar(String texto) => texto.trim().split(RegExp(r'\s+')).join(' ');

  String? _validar(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'O campo está vazio. Digite o nome de uma receita, por exemplo: Vinho suave caseiro.';
    }
    if (texto.trim().isEmpty) {
      return 'O campo tem apenas espaços. Digite o nome de uma receita, por exemplo: Vinho suave caseiro.';
    }
    return null;
  }

  void _pesquisar() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _termoPesquisado = null);
      return;
    }

    FocusScope.of(context).unfocus();
    final termo = _normalizar(_controller.text);
    _controller.text = termo;
    setState(() => _termoPesquisado = termo);
  }

  void _limpar() {
    _formKey.currentState?.reset();
    _controller.clear();
    setState(() => _termoPesquisado = null);
  }

  List<Receita> _buscar(String termo) {
    final palavras = termo.toLowerCase().split(' ');
    return _receitasProvisorias.where((r) {
      final nome = r.nome.toLowerCase();
      return palavras.every((p) => nome.contains(p));
    }).toList();
  }

  void _alternarFavorito(Receita r) {
    setState(() {
      if (!_favoritos.remove(r.id)) _favoritos.add(r.id);
    });
  }

  void _abrirReceita(Receita r) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Cores.vinhoProfundo,
          content: Text('O preparo de “${r.nome}” será exibido em breve.'),
        ),
      );
  }

  String _formatarNota(double nota) => nota.toStringAsFixed(1).replaceAll('.', ',');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _abaAtual,
          children: [_abaExplorar(), _abaFavoritos()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaAtual,
        onDestinationSelected: (i) => setState(() => _abaAtual = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Explorar'),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  List<Widget> _cabecalho(String titulo, String subtitulo) {
    return [
      const Text(
        'Umami',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Cores.vinho,
        ),
      ),
      const SizedBox(height: 12),
      const Divider(height: 1),
      const SizedBox(height: 24),
      Text(
        titulo,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Cores.vinhoProfundo,
        ),
      ),
      const SizedBox(height: 6),
      Text(subtitulo, style: _estiloSecundario),
    ];
  }

  Widget _abaExplorar() {
    final termo = _termoPesquisado;
    final resultados = termo == null ? _receitasProvisorias : _buscar(termo);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        ..._cabecalho('Receitas', 'Pesquise uma receita pelo nome.'),
        const SizedBox(height: 20),

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nome da receita',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Cores.vinhoProfundo,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validar,
                onFieldSubmitted: (_) => _pesquisar(),
                decoration: InputDecoration(
                  hintText: 'Buscar pelo nome',
                  hintStyle: const TextStyle(color: Cores.textoSecundario),
                  prefixIcon: const Icon(Icons.search, color: Cores.vinhoEscuro),
                  filled: true,
                  fillColor: Colors.white,
                  errorMaxLines: 3,
                  errorStyle: const TextStyle(
                    color: Cores.vermelhoEscuro,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: _borda(Cores.borda),
                  enabledBorder: _borda(Cores.borda),
                  focusedBorder: _borda(Cores.vinho, largura: 2),
                  errorBorder: _borda(Cores.vermelhoEscuro),
                  focusedErrorBorder: _borda(Cores.vermelhoEscuro, largura: 2),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _pesquisar,
                child: const Text('Buscar receitas'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        Semantics(
          liveRegion: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                termo == null ? 'Receitas disponíveis' : 'Resultados para “$termo”',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Cores.vinhoProfundo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                termo == null
                    ? 'Selecione uma receita para ver o preparo.'
                    : 'Toque na receita para ver o preparo.',
                style: _estiloSecundario,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (termo != null && resultados.isEmpty)
          _semResultados(termo)
        else
          for (final r in resultados) _cartao(r),

        if (termo != null) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _limpar,
            child: const Text('Limpar pesquisa'),
          ),
        ],
      ],
    );
  }

  Widget _abaFavoritos() {
    final lista = _receitasProvisorias
        .where((r) => _favoritos.contains(r.id))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        ..._cabecalho('Favoritos', 'Suas receitas salvas.'),
        const SizedBox(height: 20),
        if (lista.isEmpty)
          const Text(
            'Você ainda não favoritou nenhuma receita. '
                'Toque no coração de uma receita em Explorar para salvá-la aqui.',
            style: TextStyle(color: Cores.textoSecundario, height: 1.4),
          )
        else
          for (final r in lista) _cartao(r),
      ],
    );
  }

  OutlineInputBorder _borda(Color cor, {double largura = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }

  Widget _semResultados(String termo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Cores.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Cores.borda),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_off, color: Cores.vinhoEscuro),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nenhuma receita encontrada para “$termo”. '
                  'Confira a escrita ou tente outro nome.',
              style: const TextStyle(color: Cores.vinhoProfundo, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartao(Receita r) {
    final favorito = _favoritos.contains(r.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Cores.superficie,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Cores.borda),
        ),
        child: InkWell(
          onTap: () => _abrirReceita(r),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Cores.destaqueSuave,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(r.icone, size: 44, color: Cores.vinho),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.nome,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Cores.vinhoProfundo,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${r.minutos} min  •  ${r.dificuldade}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Cores.textoSecundario,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_formatarNota(r.nota)} / 5',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Cores.vinho,
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: favorito
                                ? 'Remover dos favoritos'
                                : 'Adicionar aos favoritos',
                            onPressed: () => _alternarFavorito(r),
                            icon: Icon(
                              favorito ? Icons.favorite : Icons.favorite_border,
                              color: favorito
                                  ? Cores.vermelhoVivo
                                  : Cores.vinhoProfundo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}