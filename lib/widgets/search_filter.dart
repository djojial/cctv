import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  final List<String> regions;
  final String? selectedRegion;
  final Function(String) onRegionSelected;
  final Function(String) onSearchChanged;

  const SearchFilter({
    super.key,
    required this.regions,
    required this.selectedRegion,
    required this.onRegionSelected,
    required this.onSearchChanged,
  });

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  bool _isFilterExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search CCTV',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(
                _isFilterExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() {
                  _isFilterExpanded = !_isFilterExpanded;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: widget.onSearchChanged,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isFilterExpanded
              ? (widget.regions.length * 50).toDouble().clamp(0, 250)
              : 0,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: widget.regions.map((region) {
              return ListTile(
                title: Text(region),
                trailing: region == widget.selectedRegion
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  widget.onRegionSelected(region);
                  setState(() {
                    _isFilterExpanded = false;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
