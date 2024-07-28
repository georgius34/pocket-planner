import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_planner/utils/debounce.dart';

class CategoryAutocomplete extends StatefulWidget {
  final String userId;
  final String label;
  final IconData icon;
  final String category;
  final void Function(String) onChanged;

  const CategoryAutocomplete({
    Key? key,
    required this.userId,
    required this.label,
    required this.icon,
    required this.category,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CategoryAutocompleteState createState() => _CategoryAutocompleteState();
}

class _CategoryAutocompleteState extends State<CategoryAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.category;
  }

  void _getSuggestions(String query) {
    if (query.isEmpty) {
      _clearSuggestions();
      return;
    }

    _debouncer.run(() async {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('categories')
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
          .get();

      setState(() {
        _suggestions = snapshot.docs.map((doc) => doc['name'] as String).toList();
        if (_suggestions.isEmpty) {
          // Add the new category to the database if it does not exist
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('categories')
              .add({'name': query.toLowerCase()});
          _suggestions.add(query.toLowerCase());
        }
      });

      _showSuggestions();
    });
  }

  void _showSuggestions() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Container(
              color: Colors.green.shade900,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  if (index >= 3) {
                    return Container(); // Return an empty container for items after the first 3
                  }
                  return ListTile(
                    title: Text(
                      _suggestions[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _controller.text = _suggestions[index];
                      widget.onChanged(_suggestions[index]);
                      _clearSuggestions();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearSuggestions() {
    setState(() {
      _suggestions.clear();
    });
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category",
            style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
          ),
          SizedBox(height: 2),
          TextFormField(
            controller: _controller,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
            decoration: InputDecoration(
              fillColor: Colors.green.shade900,
              filled: true,
              prefixIcon: Icon(widget.icon, color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade900),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade900),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              widget.onChanged(value);
              _getSuggestions(value.toLowerCase());
            },
            onTap: () {
              if (_controller.text.isEmpty) {
                _getSuggestions('');
              } else {
                _showSuggestions();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.cancel();
    super.dispose();
  }
}
