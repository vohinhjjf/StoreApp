import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/Firebase/respository.dart';
import 'package:store_app/components/coupon_card.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/campaign_model.dart';
import 'package:store_app/view/order/components/confirm_cart.dart';


class Voucher extends StatefulWidget {
  String id;
  Voucher(this.id);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Voucher> with SingleTickerProviderStateMixin {

  Repository _repository = Repository();
  List<CollectionCoupon> listActive = [];
  String Discount = "0", Freeship="0";
  List<int> length = [];
  List<String> header = ["Ưu đãi phí vận chuyển", "Mã giảm giá","Xem thêm"];
  bool checkFreeShip = false, checkVoucher = false;
  double maxDiscount = 0;
  int voucher = 0;
  @override
  void initState() {
    _repository.getActiveVoucher().then((value) => listActive = value);
    _repository.getVoucherSaved().then((value) {
      int temp1 =0;
      int temp2=0;
      for(int i=0; i < value.length; i++){
        if(value[i].freeship){
          temp1++;
        }
        else {
          temp2++;
        }
      }
      voucher = temp2;
      length.add(temp1);
      length.add(temp2);
      length.add(0);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> header ;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute (
                  builder: (BuildContext context) => ConfirmOrderPage(
                      widget.id,false, false, '0',0, '0'
                  ),
                ),
              );
            }),
        centerTitle: true,
        title: const Text(
          'Voucher',
          style: TextStyle(color: Colors.blue, fontSize: mFontTitle),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: MaterialButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute (
                builder: (BuildContext context) => ConfirmOrderPage(
                    widget.id, checkFreeShip, checkVoucher,Discount,maxDiscount,Freeship),
              ),
            );
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: const Text(
            "Đồng ý",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _repository.getVoucherSaved(),
        builder: (context,AsyncSnapshot<List<CampaignModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Container();
            }
            return buildList(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(List<CampaignModel> listCampaign) {
    int temp = length[0];
    return GroupListView(
      padding: const EdgeInsets.only(bottom: 60),
      sectionsCount: 3,
      itemBuilder: (context, index) {
        int idx= index.section == 0 ? index.index : temp++;
        List<CampaignModel> listCampaign1 = [];
        List<CampaignModel> listCampaign2 = [];
        for(int i =0; i< listCampaign.length; i++) {
          if (listCampaign[i].freeship) {
            listCampaign1.add(listCampaign[i]);
            listCampaign.removeAt(i);
            return buildData(listCampaign1[0], listActive[idx]);
          }
          else{
            if(index.section==1) {
              listCampaign2.add(listCampaign[i]);
              listCampaign.removeAt(i);
              return buildData(listCampaign2[0], listActive[idx]);
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      groupHeaderBuilder: (BuildContext context, int section) {
        return Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
          margin: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 8),
          child: section == 2
              ? MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    side: BorderSide(color: Colors.red.shade300)
                ),
                onPressed: () {
                  setState((){
                    if(header.getRange(2, 3).contains("Xem thêm")) {
                      length.replaceRange(1, 2, [voucher]);
                      header.replaceRange(2, 2, ["Thu gọn"]);
                    }
                    else {
                      length.replaceRange(1, 2, [1]);
                      header.replaceRange(2, 2, ["Xem thêm"]);
                    }
                  });
                },
                child: Text(
                  header[section],
                  style: TextStyle(fontSize: 18, color: Colors.red.shade300, fontWeight: FontWeight.w500),
                ),
              )
              : Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Text(
                    header[section],
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
          ),
        );
      },
      countOfItemInSection: (int section) {
        return length[section];
      },
      sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
    );
  }

  Widget buildData(CampaignModel campaignModel, CollectionCoupon collectionCoupon) {
    return CouponCard(
      name: campaignModel.name,
      voucherId: campaignModel.campaignId,
      maxDiscount: campaignModel.maxDiscount,
      freeship: campaignModel.freeship,
      time: campaignModel.time,
      startColor: campaignModel.freeship?Colors.green: Colors.red.shade300,
      endColor: campaignModel.freeship?Colors.green.shade100:Colors.red.shade100,
      onclick: (){
      },
      cb_voucher: (bool? value){
        setState((){
          collectionCoupon.active = value!;
          if(collectionCoupon.active){
            if(campaignModel.freeship){
              Freeship = campaignModel.maxDiscount.toString();
              checkFreeShip= true;
            }
            else{
              Discount=campaignModel.discountPercentage.toString();
              maxDiscount = campaignModel.maxDiscount;
              checkVoucher = true;
            }
          }
          else {
            if(campaignModel.freeship){
              Freeship = "";
              checkFreeShip= false;
            }
            else{
              Discount="";
              maxDiscount = 0;
              checkVoucher = false;
            }
          }
        });
      },
      check: collectionCoupon.active,
    );
  }

  Dialog(BuildContext context, SharedPreferences prefs) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Column(
              children: const [
                const CircularProgressIndicator(),
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