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
        title: const Text('Product Products'),
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
                                      const Image(
                                        image: NetworkImage('https://pbs.twimg.com/profile_images/1717013664954499072/2dcJ0Unw_400x400.png'),
                                        // image: NetworkImage(snapshot.data[index].image.toString()),
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data![index].productName.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("\$" + snapshot.data![index].productPrice.toString() + " per " + snapshot.data![index].unitTag.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            InkWell(
                                              onTap: (){

                                              },
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: const Center(
                                                    child: Text('Remove', style: TextStyle(color: Colors.white, ),),
                                                  ),
                                                ),
                                              ),
                                            ),
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
                  return Text('');
                }
              }),
        ],
      ),
    );
  }
}
