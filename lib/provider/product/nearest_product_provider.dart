import 'dart:async';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class NearestProductProvider extends PsProvider {
  NearestProductProvider({required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;
    //isDispose = false;
    print('NearestProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    initSubscription();
  }
  late ProductRepository _repo;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);
  final ProductParameterHolder productNearestParameterHolder =
      ProductParameterHolder().getNearestParameterHolder();
  PsResource<List<Product>> get productList => _productList;
   StreamSubscription<PsResource<List<Product>>>? subscription;
   StreamController<PsResource<List<Product>>>? productListStream;

  dynamic daoSubscription;
  Future<void> initSubscription() async {
    if (productListStream != null) {
      await productListStream?.close();
    }
    if (subscription != null) {
      await subscription?.cancel();
    }

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream!.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      print('**** NearestProductProvider ${resource.data!.length}');
      _productList = resource;
      _productList.data = Product().checkDuplicate(resource.data!);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    //_repo.cate.close();
    subscription?.cancel();

    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Nearest Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);

    if (daoSubscription != null) {
      await daoSubscription.cancel();
    }
    await initSubscription();
    daoSubscription = await _repo.subscribeProductList(
        productListStream, PsStatus.PROGRESS_LOADING, productParameterHolder);    
  }

  Future<dynamic> resetProductList(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isLoading = true;

    updateOffset(0);

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // daoSubscription = await _repo.getProductList(
    //     productListStream,
    //     isConnectedToInternet,
    //     loginUserId,
    //     limit,
    //     offset,
    //     PsStatus.PROGRESS_LOADING,
    //     productParameterHolder);

    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        productParameterHolder);

    if (daoSubscription != null) {
      await daoSubscription.cancel();
    }
    await initSubscription();
    daoSubscription = await _repo.subscribeProductList(
        productListStream, PsStatus.PROGRESS_LOADING, productParameterHolder);    

    isLoading = false;
  }

  Future<dynamic> nextProductList(
      String loginUserId, ProductParameterHolder productParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      // daoSubscription = await _repo.getProductList(
      //     productListStream,
      //     isConnectedToInternet,
      //     loginUserId,
      //     limit,
      //     offset,
      //     PsStatus.PROGRESS_LOADING,
      //     productParameterHolder);
      await _repo.getProductList(
          productListStream,
          isConnectedToInternet,
          loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          productParameterHolder);
    }
  }
}
