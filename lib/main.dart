import 'package:flutter/material.dart';
import 'package:cli_portfolio/constants/text_styles.dart';
import 'package:cli_portfolio/constants/banners.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hi! I'm Max:)",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
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

  String currentPath = '/max/welcome';

  @override
  void initState() {
    super.initState();
    // Ensure the input field is always focused
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    _outputs.add(PortfolioBanners.welcomeBanner);
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
      // Echo input
      _outputs.add('$currentPath > $input');

      // Add input to the CLI if it has content
      if (input.isNotEmpty) _outputs.add(_processCommand(input));
    });

    // Clear input field
    _controller.clear();

    // Auto-scroll to input field and give it focus if it has been set again
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _focusNode.requestFocus();
    });
  }

  String _processCommand(String command) {
    switch (command.toLowerCase()) {
      case 'hello':
        return 'Hello, User!';

      case 'whoami':
        return "Hi, my name is Max Wilén! \nNice to meet you :)";

      case 'cd' || 'cd ..' || 'cd ../..':
        return 'No functionality as of yet:)';

      case 'ls':
        return 'aboutme.txt, contact.txt, courses.txt, projects.txt';
      case 'ls -a' || 'ls -h' || 'ls -l' || 'ls -ahl':
        return 'No functionality as of yet :) Try the basic command!';

      case 'cat aboutme.txt' || 'about':
        return 'Something about me...';
      case 'cat contact.txt' || 'contact':
        return 'Something about me...';
      case 'cat courses.txt' || 'courses':
        return 'Something about the courses i have finished...';
      case 'cat projects.txt' || 'projects':
        return 'Something about the projects i have worked on...';

      case 'less aboutme.txt' ||
            'less contact.txt' ||
            'less courses.txt' ||
            'less projects.txt':
        return 'No less command unfortunatly. Try with cat instead.';

      case 'sudo' || 'sudo -su':
        return 'Nice try ;)';

      case 'clear':
        setState(() {
          _outputs.clear();
        });
        return '';

      case 'help':
        return 'Try with the commonly used unix commands.\n-> Or you can try the simpler ones: about, contact, courses, projects';

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
                  controller: _scrollController,
                  itemCount: _outputs.length + 1, // Add one for the input row
                  itemBuilder: (context, index) {
                    if (index == _outputs.length) {
                      // Handles the current input and output.
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Current input row + static path
                          Text('$currentPath > ',
                              style: PortfolioTextStyles.terminalGreen),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              autofocus: true,
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
