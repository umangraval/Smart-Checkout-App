import 'package:flutter/material.dart';
import 'package:inventory/JsonData/cartItems.dart';
import 'package:inventory/JsonData/productDetail.dart';
import 'package:inventory/screens/student_payment_screen/order_id.dart';
import 'package:inventory/screens/student_payment_screen/payments_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalValue = 0;
  String sellerId = "1337";
  String orderIdGenerated;
  String email = "test@test.com";
  @override
  void didChangeDependencies() async{
//    print(CartItems.cart[0].name);
    // TODO: implement didChangeDependencies
    CartItems.cart.forEach((element) {
      totalValue = totalValue + element.price;
    });
    OrderId orderId = OrderId(
      amount: totalValue*100,
      userName: email,
      userId: sellerId,
    );
    orderIdGenerated = await orderId.generateOrderId();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Cart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Card(
                  elevation: 4.0,
                  color: Colors.grey[100],
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6))),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.black87, width: 10))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,right: 80),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Items',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),),
                                Text('Price',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                itemCount: CartItems.cart.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (CartItems.cart.isEmpty) {
                                    return Text('no products in cart');
                                  }
                                  final item = CartItems.cart[index];
                                  return ListTile(
                                    title: Text('${item.name}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Rs.${item.price}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),),
                                        SizedBox(
                                          width: 50.0,
                                        ),
                                        Icon(
                                          MdiIcons.delete,
                                          color: Colors.redAccent,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // context.read is the easiest way to call
                                      // methods on a provided model
                                      setState(() {
                                        CartItems.cart.remove(item);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Text(
                'Total:  $totalValue',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
//                  Expanded(
//                    child: RaisedButton(
//                      child: Padding(
//                        padding: const EdgeInsets.all(12.0),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceAround,
//                          children: [
//                            Text(
//                              'Cancel',
//                              style: TextStyle(fontSize: 18.0),
//                            ),
//                            Icon(
//                              MdiIcons.closeCircle,
//                            )
//                          ],
//                        ),
//                      ),
//                      color: Colors.redAccent,
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(8.0),
//                          )),
//                      onPressed: () {},
//                    ),
//                  ),
//                  SizedBox(
//                    width: 10.0,
//                  ),
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 26.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Checkout',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Icon(
                            MdiIcons.logoutVariant,
                          )
                        ],
                      ),
                    ),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        )),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaymentsScreen(
                                  cartTotal: totalValue*100,
                                  email: email,
                                  sellerId: sellerId,
                                  orderId: orderIdGenerated,
                                  productList: [],
                                ))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}