import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'backend.dart';
import 'figure_dto.dart';
import 'figure_page.dart';

class FigureListView extends StatefulWidget {
  final List<FigureDTO> firstFigures;
  final int? profileId;

  const FigureListView({super.key, required this.firstFigures, this.profileId});

  @override
  FigureListViewState createState() => FigureListViewState();
}

class FigureListViewState extends State<FigureListView> {
  static const _pageSize = 3;
  late final PagingController<int, FigureDTO> _pagingController;
  late final List<FigureDTO> firstFigures;
  late final int? profileId;

  @override
  void initState() {
    super.initState();
    firstFigures = widget.firstFigures;
    profileId = widget.profileId;
    _pagingController = PagingController(
        firstPageKey: firstFigures[firstFigures.length - 1].id);
    _pagingController.appendPage(
        firstFigures, firstFigures[firstFigures.length - 1].id);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int afterId) async {
    try {
      final newItems = await getFigures(afterId, profileId);
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
