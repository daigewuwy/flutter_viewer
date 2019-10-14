import 'package:flutter/material.dart';
import 'package:flutter_viewer/models/travel_model.dart';
import 'package:flutter_viewer/network/request_helper.dart';
import 'package:flutter_viewer/widgets/loading_container.dart';
import 'package:flutter_viewer/widgets/waterfall_gridview.dart';

const String TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class RecommendPage extends StatefulWidget {
  final int type;
  RecommendPage(this.type);

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  ScrollController _scrollController;
  List<Article> _articleModels;
  int _pageIndex;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _pageIndex = 0;
    _isLoading = true;
    _articleModels = [];
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if((_scrollController.position.pixels + 20.0) >= _scrollController.position.maxScrollExtent) {
        _startRequest();
      }
    });
    _startRequest();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: LoadingContainer(
        isLoading: _isLoading,
          child: GestureDetector(
            onDoubleTap: () {
              _scrollController.animateTo(0.0, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
            },
            child: WaterFallGridView(
                models: _articleModels ?? [],
                scrollController: _scrollController
            ))
          )
    );
  }

  /// [private]

  Future<Null> _handleRefresh() async {
    _startRequest(isLoadMore: false);
    return null;
  }

  _startRequest({bool isLoadMore = true}) {
    if (false == isLoadMore) {
      _pageIndex = 0;
      _articleModels?.removeRange(0, _articleModels.length);
    }

    int pageSize = (0 == _articleModels?.length || 10 > _articleModels?.length) ? 10 : 4;
    Map groupChannelCodeInfo = {
      0 : 'tourphoto_global1',
      1 : 'RX-OMF',
      2 : 'quanliyouxi'
    };
    HttpRequestHelper.getTravelItemData(TRAVEL_URL, {
      'pageIndex': _pageIndex,
      'pageSize': pageSize,
      'groupChannelCode': groupChannelCodeInfo[widget.type]}).then((TravelItemModel val) {
      setState(() {
        _articleModels.addAll(val.resultList.map((item) {
          return item.article;
        }).toList());
        _pageIndex++;
        _isLoading = false;
      });
    });
  }
}