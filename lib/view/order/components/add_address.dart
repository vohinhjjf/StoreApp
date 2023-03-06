import 'dart:async';

import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/components/appbar.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/address_model.dart';
import 'package:store_app/view/order/delivery_address.dart';

class AddAddressPage extends StatefulWidget{
  String id,ten,sdt,tinh,huyen,xa,diachi, title;
  bool home_work,address_default;
  AddAddressPage({Key? key,
    required this.id,
    required this.ten,
    required this.sdt,
    required this.tinh,
    required this.huyen,
    required this.xa,
    required this.diachi,
    required this.home_work,
    required this.address_default,
    required this.title,
  }) : super(key: key);
  @override
  _AddAddressPageWidgetState createState() => _AddAddressPageWidgetState();
}
class _AddAddressPageWidgetState extends State<AddAddressPage> {
  GlobalKey< FormState > _formkey = GlobalKey<FormState>();
  Repository _repository =Repository();
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtPhone = TextEditingController();
  TextEditingController _txtAddress = TextEditingController();
  late dvhcvn.Level1 level1;
  late dvhcvn.Level2 level2;

  void _select1(BuildContext context, ) async {
    final selected = await _select<dvhcvn.Level1>(context, dvhcvn.level1s, header: '');
    if (selected != null){
      setState((){
        level1 = selected;
        widget.tinh = selected.name;
      });
    }
  }

  void _select2(BuildContext context) async {
    if (level1 == null) return;

    final selected = await _select<dvhcvn.Level2>(
      context,
      level1.children,
      header: widget.tinh,
    );
    if (selected != null){
      setState((){
        level2 = selected;
        widget.huyen = selected.name;
      });
    }
  }

  void _select3(BuildContext context) async {
    if (level2 == null) return;

    final selected = await _select<dvhcvn.Level3>(
      context,
      level2.children,
      header: level2.name,
    );
    if (selected != null){
      setState((){
        widget.xa = selected.name;
      });
    }
  }
  @override
  void initState() {
    _txtName.text = widget.ten;
    _txtPhone.text = widget.sdt;
    _txtAddress.text = widget.diachi;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: ListAppBar().AppBarCart(
          context, widget.title,
              () =>Navigator.of(context).pushReplacement(
                MaterialPageRoute (
                  builder: (BuildContext context) => const DeliveryAddressPage(),
                ),
              )
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: widget.home_work == true ? RoundedRectangleBorder(
                                side: const BorderSide(color: mPrimaryColor, width: 2),
                                borderRadius: BorderRadius.circular(5)
                            ) : const RoundedRectangleBorder(),
                            color: Colors.white,
                            elevation: 3,
                            child: MaterialButton(
                              onPressed: () {
                                setState((){
                                  widget.home_work = true;
                                });
                              },
                              height: 160,
                              minWidth: 160,
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                        'assets/icons/address_home.png',
                                        color: darkGrey,
                                        height: 55),
                                  ),
                                  const Text(
                                    'Nhà riêng',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: darkGrey,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                        ),
                        Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: widget.home_work == false ? RoundedRectangleBorder(
                                side: const BorderSide(color: mPrimaryColor, width: 2),
                                borderRadius: BorderRadius.circular(5)
                            ) : const RoundedRectangleBorder(),
                            color: Colors.white,
                            elevation: 3,
                            child: MaterialButton(
                                onPressed: () {
                                  setState((){
                                    widget.home_work = false;
                                  });
                                },
                                height: 160,
                                minWidth: 160,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/icons/address_work.png',
                                          color: darkGrey,
                                          height: 55),
                                    ),
                                    const Text(
                                      'Văn phòng',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: darkGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )
                            )
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Liên hệ',
                        style: TextStyle(fontSize: 12, color: darkGrey),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _txtName,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Họ và tên'),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập tên';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _txtPhone,
                        keyboardType: TextInputType.number,
                        decoration:
                        const InputDecoration(border: InputBorder.none, hintText: 'Số điện thoại'),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập số điện thoại';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Địa chỉ',
                        style: TextStyle(fontSize: 12, color: darkGrey),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                        onPressed: (){
                          _select1(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.tinh),
                            const Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                        onPressed: (){_select2(context);},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.huyen),
                            const Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                        onPressed: (){_select3(context);},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.xa),
                            const Icon(Icons.navigate_next)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _txtAddress,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Tên đường, Tòa nhà, Số nhà'),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập địa chỉ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    InkWell(
                      onTap:(){
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            AddressModel addressModel = AddressModel(
                                id: widget.id,
                                ten: _txtName.text,
                                so_dien_thoai: _txtPhone.text,
                                tinh: widget.tinh,
                                huyen: widget.huyen,
                                xa: widget.xa,
                                dia_chi: _txtAddress.text,
                                loai_dia_chi: widget.home_work? "Nhà riêng" : "Văn phòng",
                                mac_dinh: widget.address_default);
                            if(widget.title == "Địa chỉ mới") {
                              _repository.setAddress(addressModel).then((
                                  value) =>
                              {
                                if(value.isNotEmpty){
                                  Dialog(context, 'Thêm địa chỉ thành công')
                                }
                              });
                            }
                            else {
                              _repository.updateAddress(addressModel).then((
                                  value) =>
                              {
                                if(value.isNotEmpty){
                                  Dialog(context, 'Cập nhật địa chỉ thành công')
                                }
                              });
                            }
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              mPrimaryColor,
                              mPrimaryColor,
                              mPrimaryColor,
                            ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                                offset: Offset(0, 5),
                                blurRadius: 10.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(9.0)),
                        child: const Center(
                          child: Text("Hoàn thành",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Dialog(BuildContext context, String text) {
    late Timer _timer;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute (
                builder: (BuildContext context) => const DeliveryAddressPage(),
              ),
            );
          });
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: [
                const Icon(
                  MdiIcons.checkboxMarkedCircle,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).then((val){
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  Future<T?> _select<T extends dvhcvn.Entity>(
      BuildContext context,
      List<T> list, {
        required String header,
      }) =>
      showModalBottomSheet<T>(
        context: context,
        builder: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header (if provided)
            if (header != null)
              Padding(
                child: Text(
                  header,
                  style: Theme.of(context).textTheme.headline6,
                ),
                padding: const EdgeInsets.all(8.0),
              ),
            if (header != null) const Divider(),

            // entities
            Expanded(
              child: ListView.builder(
                itemBuilder: (itemContext, i) {
                  final item = list[i];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('#${item.id}, ${item.typeAsString}'),
                    onTap: () => Navigator.of(itemContext).pop(item),
                  );
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      );
}
