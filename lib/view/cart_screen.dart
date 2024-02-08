import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopping_cart/cart_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider_shopping_cart/db_helper.dart';
import 'package:provider_shopping_cart/model/cart_model.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          badges.Badge(
            badgeContent: Consumer<CartProvider>(
                builder: (context, value, child){
                  return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white));
                }),
            child: Icon(Icons.shopping_bag_outlined),
          ),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot){
                if(snapshot.hasData){
                  return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                        image: NetworkImage(snapshot.data![index].image.toString()),
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data![index].productName.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    dbHelper!.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  },
                                                  child: Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("\$" + snapshot.data![index].productPrice.toString() + " per " + snapshot.data![index].unitTag.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  );
                }else {
                  return const Text('');
                }
              }),
          Consumer<CartProvider>(builder: (context, value, child){
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00' ? false : true,
              child: Column(
                children: [
                  ReusableWidget(title: 'Sub Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                ],
              ),
            );
          }),

        ],
      ),
    );
  }
}


// Resuable Widget for SubTotal

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium,),
          Text(value, style: Theme.of(context).textTheme.titleSmall,),
        ],
      ),
    );
  }
}
