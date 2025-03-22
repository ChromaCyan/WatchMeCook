import 'package:flutter/material.dart';
import 'package:watchmecook/models/quote_model.dart';
import 'package:watchmecook/services/api.dart';

class QuoteListScreen extends StatefulWidget {
  @override
  _QuoteListScreenState createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  late Future<Quote> _randomQuote;
  List<Quote> _authorQuotes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRandomQuote(); // Initial fetch of random quote
  }

  // Function to fetch random quote
  void _fetchRandomQuote() {
    setState(() {
      _randomQuote = ApiService.fetchRandomQuote(); // Fetch a new random quote
    });
  }

  // Function to search quotes by author
  void _searchQuotesByAuthor(String author) {
    if (author.isEmpty) {
      setState(() {
        _authorQuotes = [];
      });
      return;
    }

    ApiService.fetchQuotesByAuthor(author).then((quoteList) {
      setState(() {
        _authorQuotes = quoteList;
      });
    }).catchError((error) {
      setState(() {
        _authorQuotes = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quotes by author')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _searchQuotesByAuthor,
                decoration: InputDecoration(
                  hintText: "Search quotes by author",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
            ),

            // Random Quote Section
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Random Quote",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _fetchRandomQuote,
                    child: const Text("Get Random Quote"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display Random Quote
                  FutureBuilder<Quote>(
                    future: _randomQuote,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Quote loading...'));
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('No random quote found'));
                      }

                      final randomQuote = snapshot.data!;
                      return _buildQuoteCard(randomQuote);
                    },
                  ),
                ],
              ),
            ),

            const Text(
              "Search Quotes by Author",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            // Display Search Results
            if (_authorQuotes.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _authorQuotes.length,
                itemBuilder: (context, index) {
                  final quote = _authorQuotes[index];
                  return _buildQuoteCard(quote);
                },
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to build quote cards with improved design
  Widget _buildQuoteCard(Quote quote) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            title: Text(
              "\"${quote.text}\"",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              "- ${quote.author}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
