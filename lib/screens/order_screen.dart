import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/order_providers.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {

  static const orderScreenRouteName = '/orderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late Future _ordersFuture;
  Future _obtainFutureOrders(){
    return Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
     _ordersFuture = _obtainFutureOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String orderScreen = 'Order';
    return Scaffold(
      appBar: AppBar(
        title: const Text(orderScreen, style: TextStyle(
          fontSize: 20,
        ),
        ),
      ),
      drawer: AppDrawer(),
      //30_06: Alternative method not to use Future delay in the initState
      body: FutureBuilder(future: _ordersFuture,
      builder: (ctx, dataSnapshot) {
        if(dataSnapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        // else if(dataSnapshot.error == null){
        //   return const Center(child: Text('Error in displaying orders'),);
        // }
        else{
          return Consumer<OrdersProvider>(
            builder: (ctx,ordersProvider, child) => ListView.builder(
              itemBuilder: (ctx, index) => OrderData(ordersProvider.orders[index],),
              itemCount: ordersProvider.orders.length,
            ),
          );
        }
      },),
    );
  }
}
