import 'dart:io';

import 'package:flutter/material.dart';
import '../models/book.dart';

class BookWidget extends StatefulWidget {
  const BookWidget({
    super.key,
    required this.book,
    required this.onFavoriteToggle,

  });

  final Book book;
  final VoidCallback onFavoriteToggle;

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: 150,
                child: widget.book.imagePath != null
                    ? Image.file(File(widget.book.imagePath!),fit: BoxFit.cover,)
                    : Container(color: Colors.grey),
              ),
              Positioned(
                right: -19,
                top: -16,
                child: RotatedBox(

                  quarterTurns: 25,
                  child: IconButton(
                    onPressed: () {
                      widget.onFavoriteToggle();
                      print('icon${widget.book.isFavorite}');
                    },
                    icon:  Icon(Icons.label,color: widget.book.isFavorite?Colors.red:Colors.white,size: 50,shadows: [],),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              overflow: TextOverflow.ellipsis,

              widget.book.title ?? 'Título não disponível',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.book.author ?? 'Autor desconhecido',
            maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
