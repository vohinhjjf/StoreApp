import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/address_model.dart';
import 'package:store_app/view/order/components/add_address.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({Key? key}) : super(key: key);

  @override
  _DeliveryAddressPageWidgetState createState() => _DeliveryAddressPageWidgetState();
}
class _DeliveryAddressPageWidgetState extends State<DeliveryAddressPage> {
  final Repository _repository =Repository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ListAppBar().AppBarCart(
            context, "Chọn địa chỉ giao hàng",
                () =>Navigator.of(context, rootNavigator: true).pop()
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: OutlinedButton(
                    autofocus: true,
                    style: OutlinedButton.styleFrom(
                      //minimumSize: MediaQuery.of(context).size,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: mPrimaryColor, width: 1),
                        shape: const RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(5))
                        )
                    ),
                    onPressed:() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute (
                          builder: (BuildContext context) => AddAddressPage(
                            id: "",
                            huyen: 'Quận/Huyện',
                            sdt: '',
                            diachi: '',
                            address_default: false,
                            home_work: true,
                            ten: '',
                            xa: 'Phường/Xã',
                            tinh: 'Tỉnh/Thành phố',
                            title: 'Địa chỉ mới',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "+ Thêm địa chỉ mới",
                      style: const TextStyle(fontSize: mFontListTile, color: mPrimaryColor),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 180,
                child: FutureBuilder(
                  future: _repository.getAddress(),
                  builder: (BuildContext context1, AsyncSnapshot<List<AddressModel>> snapshot) {
                    if(snapshot.hasData){
                      if (snapshot.data!.isEmpty) {
                        return Container();
                      }
                      return BuildList(context,snapshot.data!);
                    }
                    else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BuildList(BuildContext context,List<AddressModel> list_cartModel){
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: list_cartModel.length,
      itemBuilder: (context, index) {
        return productInfo(context,list_cartModel[index]);
      },
    );
  }

  Widget productInfo(BuildContext context,AddressModel addressModel) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          setState(() {
            Dialog(context, addressModel);
          });
        },
        child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 155,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                            'assets/icons/location.png'),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  addressModel.ten,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 10,),
                                Text(
                                  addressModel.so_dien_thoai,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              addressModel.dia_chi,
                              style:
                              const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Text(
                              "${addressModel.xa}, ${addressModel.huyen}, ${addressModel.tinh}",
                              style:
                              const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: const ShapeDecoration(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                  child: Text(
                                    addressModel.loai_dia_chi,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                addressModel.mac_dinh?Container(
                                  decoration: const ShapeDecoration(
                                    shape: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                  child: const Text(
                                    "MẶC ĐỊNH",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red
                                    ),
                                  ),
                                ):Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]
                ),

              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: (){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute (
                          builder: (BuildContext context) => AddAddressPage(
                            id: addressModel.id,
                            huyen: addressModel.huyen,
                            sdt: addressModel.so_dien_thoai,
                            diachi: addressModel.dia_chi,
                            address_default: addressModel.mac_dinh,
                            home_work: addressModel.loai_dia_chi=="Nhà riêng"?true:false,
                            ten: addressModel.ten,
                            xa: addressModel.xa,
                            tinh: addressModel.tinh,
                            title: 'Cập nhật địa chỉ',
                          ),
                        ),
                      );
                    },
                    child: const Text('Chỉnh sửa',
                      style: const TextStyle(color: mPrimaryColor, fontSize: 14),)
                ),
              )
            ],
        )
      ),
    );
  }

  Dialog(BuildContext context,AddressModel addressModel) {
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          _repository.updateAddressDefault(addressModel.id).then((value) => {
                Navigator.pop(context),
                Navigator.of(context, rootNavigator: true).pop()
            }
          );
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Vui lòng chờ trong giây lát',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        });
  }
}