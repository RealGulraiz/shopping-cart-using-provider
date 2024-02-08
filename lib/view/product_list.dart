import 'dart:core';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:provider_shopping_cart/cart_provider.dart';
import 'package:provider_shopping_cart/db_helper.dart';
import 'package:provider_shopping_cart/model/cart_model.dart';
import 'package:provider_shopping_cart/view/cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper dbHelper = DBHelper();

  List<String> productName = ['Mango', 'Orange', 'Grapes', 'Banana', 'Cherry', 'Peach', 'Mixed Fruit'];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<int> productPrice = [10,20,30,40,50,60,70];
  List<String> productImage = [
    'https://sadruddin.com/wp-content/uploads/2022/06/mango1.jpg',
    'https://d2b5e9fzla1xs8.cloudfront.net/media/images/products/2021/03/3007.jpg',
    'https://pictures.grocerapps.com/original/grocerapp-grapes-tofi-633d1fa172f03.jpeg',
    'https://product-images.metro.ca/images/hcd/h4d/8874222256158.jpg',
    'https://img.freepik.com/free-vector/realistic-berries-composition-with-isolated-image-cherry-with-ripe-leaves-blank-background-vector-illustration_1284-66040.jpg?size=338&ext=jpg&ga=GA1.1.1448711260.1706832000&semt=sph',
    'https://jugais.com/wp-content/uploads/2020/07/pessego-1.jpg',
    'https://img.freepik.com/free-psd/mix-fruits-png-isolated-transparent-background_191095-9865.jpg?size=338&ext=jpg&ga=GA1.1.1448711260.1706745600&semt=ais',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                    builder: (context, value, child){
                      return Text(value.getCounter().toString(), style: TextStyle(color: Colors.white));
                }),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: productName.length,
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
                                image: NetworkImage(productImage[index].toString()),
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productName[index].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text("\$" + productPrice[index].toString() + " per " +productUnit[index].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    InkWell(
                                      onTap: (){
                                        dbHelper.insert(Cart(
                                          id: index,
                                          productId: index.toString(),
                                          productName: productName[index].toString(),
                                          initialPrice: productPrice[index],
                                          productPrice: productPrice[index],
                                          quantity: 1,
                                          unitTag: productUnit[index].toString(),
                                          image: productImage[index].toString(),
                                        )
                                        ).then((value){
                                          print('Product is added to cart');
                                          cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                          cart.addCounter();
                                        }).onError((error, stackTrace){
                                          print(error.toString());
                                        });
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
                                            child: Text('Add to cart', style: TextStyle(color: Colors.white, ),),
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
          ),
        ],
      ),
    );
  }
}


