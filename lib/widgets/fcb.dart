import 'package:bundle_yanga/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FutureContent<T> extends StatefulWidget {
  final dynamic future;
  final Function refresh;
  final bool showRefreshButton;
  final Widget Function(BuildContext context, T value) builder;
  const FutureContent(
      {Key key,
      this.future,
      this.refresh,
      this.builder,
      this.showRefreshButton = false})
      : super(key: key);

  @override
  _FutureContentState<T> createState() => _FutureContentState<T>();
}

class _FutureContentState<T> extends State<FutureContent<T>> {
  var data;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future,
        builder: (context, result) {
          switch (result.connectionState) {
            case ConnectionState.none:
              return EmptyState();
              break;
            case ConnectionState.waiting:
              if (data != null) {
                return DataBuilder<T>(
                    refresh: widget.refresh,
                    builder: widget.builder,
                    data: data);
              }
              return Loader(centralDotRadius: 12);
              break;
            case ConnectionState.active:
              return Loader(centralDotRadius: 12);
              break;
            case ConnectionState.done:
              if (result.hasError) {
                data = null;
                return ErrorState(
                  refresh: widget.refresh,
                  showButton: widget.showRefreshButton,
                );
              } else {
                data = result.data;
                return DataBuilder<T>(
                    refresh: widget.refresh,
                    builder: widget.builder,
                    data: data);
              }
              break;
          }
          return Container();
        });
  }
}

class RetryState extends StatelessWidget {
  const RetryState({
    Key key,
    @required this.refresh,
  }) : super(key: key);

  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Failed to load items.',
          style: TextStyle(color: Colors.red),
        ),
        RaisedButton(
          child: const Text('Tap to try again'),
          onPressed: refresh,
        )
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('Loading items...'),
      ],
    );
  }
}

class DataBuilder<T> extends StatelessWidget {
  const DataBuilder({
    Key key,
    this.data,
    @required this.refresh,
    @required this.builder,
  }) : super(key: key);

  final Function refresh;
  final T data;
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return refresh != null
        ? RefreshIndicator(onRefresh: refresh, child: builder(context, data))
        : builder(context, data);
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    Key key,
    @required this.refresh,
    this.showButton,
  }) : super(key: key);

  final Function refresh;
  final bool showButton;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: showButton
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Failed to load items.',
                  style: TextStyle(color: Colors.red),
                ),
                RaisedButton(
                  child: const Text('Tap to try again'),
                  onPressed: refresh,
                )
              ],
            )
          : InkWell(
              child: const Text(
                '!',
                style: TextStyle(color: Colors.red),
              ),
              onTap: refresh,
            ),
    );
  }
}
