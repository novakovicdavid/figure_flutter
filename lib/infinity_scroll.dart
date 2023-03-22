import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'backend.dart';
import 'figure_dto.dart';
import 'figure_page.dart';

class FigureListView extends StatefulWidget {
  FigureListView({super.key, required this.firstFigures});

  List<FigureDTO> firstFigures;

  @override
  FigureListViewState createState() => FigureListViewState(firstFigures);
}

class FigureListViewState extends State<FigureListView> {
  FigureListViewState(this.firstFigures) {
    _pagingController = PagingController(
        firstPageKey: firstFigures[firstFigures.length - 1].id);
  }

  List<FigureDTO> firstFigures;
  static const _pageSize = 3;

  late final PagingController<int, FigureDTO> _pagingController;

  @override
  void initState() {
    _pagingController.appendPage(
        firstFigures, firstFigures[firstFigures.length - 1].id);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int afterId) async {
    try {
      final newItems = await getFigures(afterId);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newItems[_pageSize - 1].id;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, FigureDTO>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<FigureDTO>(
          itemBuilder: (context, item, index) => FigureListItem(
            figure: item,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class FigureListItem extends StatelessWidget {
  final FigureDTO figure;

  const FigureListItem({super.key, required this.figure});

  @override
  Widget build(BuildContext context) {
    return (InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => FigurePage(figure.id))),
        child: Column(children: [
      CachedNetworkImage(
        imageUrl: figure.url,
        placeholder: (context, url) => AspectRatio(
            aspectRatio: figure.width / figure.height,
            child: const Center(
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator()))),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      Text(figure.title)
    ])));
  }
}
