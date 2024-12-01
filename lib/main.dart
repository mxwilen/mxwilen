import 'package:flutter/material.dart';
import 'package:cli_portfolio/constants/text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CLI Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.green, fontFamily: 'Courier'),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _outputs = []; // List to hold CLI output
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ensure the input field is always focused
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleInput(String input) {
    setState(() {
      _outputs.add('> $input'); // Echo input

      if (input.isNotEmpty) _outputs.add(_processCommand(input)); // Add output
    });
    _controller.clear(); // Clear input field

    // Scroll to the bottom after adding output
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _focusNode.requestFocus(); // Refocus on the input field
    });
  }

  String _processCommand(String command) {
    switch (command.toLowerCase()) {
      case 'hello':
        return 'Hello, User!';
      case 'help':
        return 'Available commands: hello, help, clear';
      case 'clear':
        setState(() {
          _outputs.clear();
        });
        return '';
      case '':
        return '';
      default:
        return 'Unknown command: $command';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Check if the FocusNode is not focused and request focus
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Attach scroll controller
                  itemCount: _outputs.length + 1, // Add one for the input row
                  itemBuilder: (context, index) {
                    if (index == _outputs.length) {
                      // Handles the current input and output.
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('> ', style: PortfolioTextStyles.terminalGreen),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode, // Attach focus node
                              autofocus:
                                  true, // Ensure the field gets focus initially
                              style: PortfolioTextStyles.terminalGreen,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              cursorWidth: 10.0,
                              cursorHeight: 20.0,
                              cursorColor: Colors.white,
                              onSubmitted: _handleInput,
                            ),
                          ),
                        ],
                      );
                    }
                    // Otherwise, render output rows. These are the "old" inputs and outputs.
                    return Text(_outputs[index],
                        style: PortfolioTextStyles.terminalGreen);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
