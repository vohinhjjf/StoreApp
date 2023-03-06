import 'package:store_app/models/product_model.dart';

class ProductViewModel {
  List<ProductModel> getProduct() {
    return [
      ProductModel(
        name:
            "Dell Inspiron 15 N3511 i5 1135G7",
        image:
            "https://images.fpt.shop/unsafe/fit-in/800x800/filters:quality(90):fill(white):upscale()/fptshop.com.vn/Uploads/Originals/2021/10/12/637696546515010716_dell-inspiron-n3511-den-1.jpg",
        details: "Laptop Dell Inspiron 15 3511 P112F001FBL là dòng laptop cao cấp được người dùng tin tưởng lựa chọn. "
            "Với thiết kế trẻ trung, năng động cùng hiệu năng hoạt động ổn định chiếc laptop đến từ thương hiệu Dell này hứa hẹn sẽ không làm người dùng thất vọng."
            "\n- Thiết kế mỏng nhẹ, cao cấp thu hút người nhìn"
            "\n- Hiệu năng hoạt động mạnh mẽ với Intel Core i5-1135G7, ram 8GB DDR4 2666MHz và bộ nhớ trong lên đến 512GB SSD M.2 NVMe"
            "\n- Màn hình 15.6 inch nổi bật cho một góc nhìn rộng cùng chip đồ họa Intel Iris Xe Graphics cao cấp"
            "\n- Bàn phím thời thượng, hiện đại, bộ pin 3 cell 37Wh"
            "\n- Hệ điều hành Windows 11 Home SL và Office Home & Student 2021 và các cổng kết nối đa dạng",
        collection: 'Sản phẩm nổi bật',
        category: 'Laptop',
        price: 19490000,
        discountPercentage: 18,
        sold: 455,
        hot: true,
        freeship: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
            "iPhone 13 Pro Max 128GB",
        image:
            "https://cf.shopee.vn/file/0f010371ecb3c1c9bc9b88f66105a652_tn",
        collection: 'Sản phẩm nổi bật',
        category: 'Điện thoại',
        price: 32990000,
        discountPercentage: 17,
        sold: 10,
        hot: true,
        amount: 1,
        checkBuy: false
      ),//phone
      ProductModel(
          name:
              "Masstel Tab 10M 4G",
          image:
              "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2022/6/20/637913223434531480_may-tinh-bang-masstel-tab-10m-4g-xanh-navy-dd-1.jpg",
          collection: 'Sản phẩm nổi bật',
          category: 'Máy tính bảng',
          price: 3990000,
          discountPercentage: 12,
          sold: 140,
          freeship: true,
          amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Samsung Galaxy A53 5G 256GB",
        image:
            "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2022/9/17/637990012849243485_samsung-galaxy-a53-xanh-dd-docquyen.jpg",
        collection: 'Sản phẩm nổi bật',
        category: 'Điện thoại',
        price: 10990000,
        discountPercentage: 18,
        sold: 87,
        hot: true,
        amount: 1,
        checkBuy: false
      ),//phone
      ProductModel(
        name:
            "Asus TUF Gaming FX517ZC-HN077W i5 12450H",
        image:
            "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2022/3/22/637835763372337463_asus-tuf-gaming-fx517-den-dd-rtx-3050.jpg",
        collection: 'Sản phẩm nổi bật',
        category: 'Laptop',
        price: 27990000,
        sold: 10,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Tai nghe gaming Rapoo VH160 có mic",
        image:
            "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2021/11/8/637719900945146267_HASP-00774722-dd.jpg",
        collection: 'Sản phẩm nổi bật',
        category: 'Tai nghe',
        price: 449000,
        discountPercentage: 15,
        sold: 541,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
          name:
              "Tai nghe Bluetooth JBL T115TWSREDAS",
          image:
              "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2021/11/23/637732744056652714_avt.jpg",
          collection: 'Sản phẩm nổi bật',
          category: 'Tai nghe',
          price: 1490000,
          sold: 585,
          freeship: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
          name:
              "PC GAMING E-POWER 034 Core i3 10105F 3.7 GHz-4.4 GHz/16 GB/240 GB/400 W/GeForce GT 1030",
          image:
              "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2022/8/29/637973904712442492_pc-gaming-e-power-034-den-dd.jpg",
          collection: 'Sản phẩm nổi bật',
          category: 'PC-Lắp ráp',
          price: 12399000,
          discountPercentage: 15,
          sold: 250,
          hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
            "iMac 24' 2021 Retina 4.5K M1/8-Core CPU/8-Core GPU/8GB/256GB SSD",
        image:
            "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2021/4/21/637546128362763420_imac-24-blue-dd.jpg",
          collection: 'Sản phẩm nổi bật',
          category: 'PC-Lắp ráp',
          price: 39999000,
        discountPercentage: 6,
        sold: 844,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
            "Mac mini 2020 M1 256GB SSD MGNR3SA/A",
        image:
            "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2020/11/12/637407926277699019_mac-mini-2020-m1-bac-dd.png",
          collection: 'Sản phẩm nổi bật',
          category: 'PC-Lắp ráp',
          price: 19999000,
        sold: 44,
        freeship: true,
        amount: 1,
        checkBuy: false
      ),
    ];
  }

  List<ProductModel> getPhone(){
    return [
      ProductModel(
        name:
        "Samsung Galaxy S22 Ultra 5G",
        image:
        "https://cdn.tgdd.vn/Products/Images/42/235838/Galaxy-S22-Ultra-Burgundy-600x600.jpg",
        category: 'Điện thoại',
        price: 30990000,
        discountPercentage: 17,
        sold: 476,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "OPPO A55",
        image:
        "https://cdn.tgdd.vn/Products/Images/42/249944/oppo-a55-4g-thumb-new-600x600.jpg",
          category: 'Điện thoại',
          price: 4490000,
        sold: 308,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "iPhone 13 Pro Max 128GB",
        image:
        "https://cf.shopee.vn/file/0f010371ecb3c1c9bc9b88f66105a652_tn",
          category: 'Điện thoại',
          price: 32990000,
        discountPercentage: 17,
        sold: 10,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "iPhone 14 Pro Max 128GB",
        image:
        "https://cdn.tgdd.vn/Products/Images/42/251192/iphone-14-pro-max-tim-thumb-600x600.jpg",
          category: 'Điện thoại',
          price: 33990000,
        sold: 0,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Samsung Galaxy A53 5G 256GB",
        image:
        "https://images.fpt.shop/unsafe/fit-in/214x214/filters:quality(90):fill(white)/fptshop.com.vn/Uploads/Originals/2022/9/17/637990012849243485_samsung-galaxy-a53-xanh-dd-docquyen.jpg",
          category: 'Điện thoại',
          price: 10990000,
        discountPercentage: 18,
        sold: 87,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Samsung Galaxy Z Fold3 5G",
        image:
        "https://cdn.tgdd.vn/Products/Images/42/226935/samsung-galaxy-z-fold-3-silver-1-600x600.jpg",
          category: 'Điện thoại',
          price: 41990000,
        discountPercentage: 23,
        sold: 0,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
    ];
  }

  List<ProductModel> getLaptop(){
    return [
      ProductModel(
        name:
        "Laptop HP VICTUS 16-e0177AX 4R0U9PA",
        image:
        "https://lh3.googleusercontent.com/DYNZIMfeWaMuqoOJvftV6cVXy6R2HkyUwEjMhcRUMdiMTb9Ur97Hxktxetv3iMme6ipR9Wknxf7GmnErLrxUH_m1qJojuk6yFg=rw-w230",
          category: 'Laptop',
          price: 22990000,
        discountPercentage: 23,
        sold: 106,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Laptop ACER Nitro 5 Eagle AN515-57-54MV NH.QENSV.003",
        image:
        "https://lh3.googleusercontent.com/c7VuA4P8sHHJCilfzRVp50AQmgZEkJOyOCuh4vvkcT9jxfqTzZVd2gepUFSSqzXVSEljnYlAN319sJD-H1IztNcxPT3UypA=rw-w230",
          category: 'Laptop',
          price: 24990000,
        discountPercentage: 16,
        sold: 80,
        freeship: true,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Laptop Dell Vostro 5410 V4I5214W1",
        image:
        "https://lh3.googleusercontent.com/awNX33cUhBXFLT7Wv9aNBfKo9wiwiwLgPi2JfNgZKHGWTmYZ1N5AMQNE4HZT2AuZMZ1zX2Exk7UwQ0d-irm_sjcUwClzZTlW=rw-w230",
          category: 'Laptop',
          price: 23090000,
        discountPercentage: 11,
        sold: 10,
        freeship: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Laptop ASUS A415EA-EB1750W",
        image:
        "https://lh3.googleusercontent.com/Gdy1aeN6rQp1YrQZLApFRRmcjewQ723vS6qdIx1NMtKXrzvcfBemHXOsU8Nuq7YW0tzTCn0bkfNWvIKp3IRA7hDgAuzzMeQF=rw-w230",
          category: 'Laptop',
          price: 33990000,
        sold: 0,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Laptop ASUS TUF Gaming FA507RE-HN007W",
        image:
        "https://lh3.googleusercontent.com/-RguQKI55rPdg5ItOSaB0ZzxG0vwsq1FUxqvKvhKTNBip9tFXwdZJY4WKnP-ihTHf7RlfqyRcPsVoXst9SbmCYxpN6gzvOA=rw-w230",
          category: 'Laptop',
          price: 30490000,
        discountPercentage: 25,
        sold: 87,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Laptop MSI GF63 Thin 11SC 664VN",
        image:
        "https://lh3.googleusercontent.com/zv-LptUN4QTrDqaj4reDDNvQzB3vVeYcRWsfASlv2dOf0knKYbubS-JX6L4pxsPoJTL1DngCHi5zJCnauYHgO-r4MlUS1c4=rw-w230",
        category: 'Laptop',
        price: 20990000,
        discountPercentage: 17,
        sold: 0,
        freeship: true,
        amount: 1,
        checkBuy: false
      ),
    ];
  }

  List<ProductModel> getPC(){
    return [
      ProductModel(
        name:
        "iMac 24 inch M1 2021 4.5K/7-core GPU",
        image:
        "https://cdn.tgdd.vn/Products/Images/5698/238061/imac-24-icnh-2021-m1-thumb-bac-1-600x600.jpg",
        category: 'PC-Lắp ráp',
        price: 34490000,
        discountPercentage: 5,
        sold: 13,
        freeship: true,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "HP AIO 24-cb1011d i5 1235U (6K7G6PA)",
        image:
        "https://cdn.tgdd.vn/Products/Images/5698/287315/hp-aio-24-cb1011d-i5-6k7g6pa-thumb-600x600.jpg",
          category: 'PC-Lắp ráp',
          price: 21890000,
        sold: 80,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "PC Dell Vostro 3888 D29M002 70271212",
        image:
        "https://lh3.googleusercontent.com/qLldcOAUaxsH3dFVu2lex0FiTHRljzSKpSImoFdPe6_zGSfCAupJ8NC39ToVWoJrBETleXpZOdDQN87TJZxKCgkHrTbE8Lk=rw-w230",
          category: 'PC-Lắp ráp',
          price: 10390000,
        discountPercentage: 11,
        sold: 10,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Asus ROG Strix G35DX-VN003W R7 5800X",
        image:
        "https://cdn.tgdd.vn/Products/Images/5698/289958/asus-rog-strix-g35dx-vn003w-thumb-600x600.jpg",
          category: 'PC-Lắp ráp',
          price: 20990000,
        sold: 0,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "MSI Creator P50 11SI i5 11400 (058XVN)",
        image:
        "https://cdn.tgdd.vn/Products/Images/5698/290824/msi-creator-p50-11si-i5-058xvn-fixthumb.-600x600.jpg",
          category: 'PC-Lắp ráp',
          price: 19990000,
        discountPercentage: 5,
        sold: 87,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
    ];
  }

  List<ProductModel> getTablet(){
    return [
      ProductModel(
        name:
        "Samsung Galaxy Tab S8",
        image:
        "https://cdn.tgdd.vn/Products/Images/522/247510/Samsung-Galaxy-tab-s8-black-thumb-600x600.jpg",
          category: 'Máy tính bảng',
          price: 20990000,
        discountPercentage: 1,
        sold: 16,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Samsung Galaxy Tab S8 Ultra",
        image:
        "https://cdn.tgdd.vn/Products/Images/522/247513/samsung-tab-s8-ultra-thumb-600x600.jpg",
          category: 'Máy tính bảng',
          price: 30990000,
        sold: 30,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "iPad Pro M1 11 inch 5G",
        image:
        "https://cdn.tgdd.vn/Products/Images/522/269329/pad-pro-m1-11-inch-wifi-cellular-1tb-2021-bac-thumb-600x600.jpeg",
          category: 'Máy tính bảng',
          price: 41990000,
        discountPercentage: 10,
        sold: 10,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "iPad Air 5 M1 Wifi Cellular 64GB",
        image:
        "https://cdn.tgdd.vn/Products/Images/522/274155/ipad-air-5-wifi-cellular-tim-thumb-600x600.jpg",
          category: 'Máy tính bảng',
          price: 20990000,
        discountPercentage: 2,
        sold: 1,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Lenovo Yoga Tab 11",
        image:
        "https://cdn.tgdd.vn/Products/Images/522/244565/lenovo-yoga-tab-11-thumb-600x600.jpg",
          category: 'Máy tính bảng',
          price: 10990000,
        discountPercentage: 6,
        sold: 87,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Huawei MatePad 11 WiFi",
        image:
        "https://cdn.tgdd.vn/Products/Images/522/241299/huawei-matepad-11-9-1-600x600.jpg",
          category: 'Máy tính bảng',
          price: 13990000,
        discountPercentage: 7,
        sold: 0,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
    ];
  }

  List<ProductModel> getSmartWatch(){
    return [
      ProductModel(
        name:
        "Apple Watch SE 40mm viền nhôm dây silicone",
        image:
        "https://cdn.tgdd.vn/Products/Images/7077/234918/se-40mm-vien-nhom-day-cao-su-xanh-den-thumb-1-600x600.jpg",
          category: 'Đồng hồ thông minh',
          price: 8990000,
        discountPercentage: 22,
        sold: 16,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Samsung Galaxy Watch 4 Classic 46mm dây silicone",
        image:
        "https://cdn.tgdd.vn/Products/Images/7077/278317/samsung-galaxy-watch-4-classic-46mm-den-600x600.jpg",
          category: 'Đồng hồ thông minh',
          price: 30990000,
        discountPercentage: 33,
        sold: 30,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Xiaomi Watch S1 46.5mm dây da",
        image:
        "https://cdn.tgdd.vn/Products/Images/7077/274192/274192-nâu-600x600.jpg",
          category: 'Đồng hồ thông minh',
          price: 5990000,
        discountPercentage: 8,
        sold: 10,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Apple Watch Series 7 GPS 41mm viền nhôm dây silicone",
        image:
        "https://cdn.tgdd.vn/Products/Images/7077/249906/apple-watch-s7-41mm-den-thumb-600x600.jpg",
          category: 'Đồng hồ thông minh',
          price: 11990000,
        discountPercentage: 16,
        sold: 1,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Honor Watch GS3 45.9mm dây da",
        image:
        "https://cdn.tgdd.vn/Products/Images/7077/285233/honor-watch-gs-3-day-da-vang-tb-1-2-600x600.jpg",
          category: 'Đồng hồ thông minh',
          price: 5990000,
        sold: 87,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Xiaomi Mi Band 6 dây TPU",
        image:
        "https://cdn.tgdd.vn/Products/Images/7077/236733/mi-band-6-1-2-3-600x600.jpg",
          category: 'Đồng hồ thông minh',
          price: 1290000,
        discountPercentage: 36,
        sold: 159,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
    ];
  }

  List<ProductModel> getHeadPhone(){
    return [
      ProductModel(
        name:
        "Tai nghe Bluetooth AirPods Pro 2 MagSafe Charge Apple MQD83 Trắng",
        image:
        "https://cdn.tgdd.vn/Products/Images/54/289781/tai-nghe-bluetooth-airpods-pro-2-magsafe-charge-apple-mqd83-trang-090922-034128-600x600.jpeg",
          category: 'Tai nghe',
          price: 6990000,
        sold: 0,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Tai nghe Bluetooth True Wireless Samsung Galaxy Buds 2 Pro R510N",
        image:
        "https://cdn.tgdd.vn/Products/Images/54/286045/tai-nghe-bluetooth-true-wireless-galaxy-buds2-pro-den-1-2-3-600x600.jpg",
          category: 'Tai nghe',
          price: 4990000,
        discountPercentage: 8,
        sold: 30,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Tai nghe Bluetooth True Wireless OPPO ENCO Air 2 Pro ETE21",
        image:
        "https://cdn.tgdd.vn/Products/Images/54/286335/tai-nghe-bluetooth-true-wireless-oppo-enco-air-2-pro-ete21-220822-051149-600x600.jpg",
          category: 'Tai nghe',
          price: 1990000,
        sold: 25,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Tai nghe Bluetooth True Wireless Gaming Asus Rog Cetra",
        image:
        "https://cdn.tgdd.vn/Products/Images/54/286604/tai-nghe-bluetooth-true-wireless-gaming-asus-rog-cetra-den-600x600.jpg",
          category: 'Tai nghe',
          price: 2290000,
        discountPercentage: 10,
        sold: 1,
        hot: true,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Tai nghe Có Dây Awei Q29Hi",
        image:
        "https://cdn.tgdd.vn/Products/Images/54/202536/tai-nghe-ep-awei-q29hi-den-hong-thumb-600x600.jpeg",
          category: 'Tai nghe',
          price: 150000,
        discountPercentage: 20,
        sold: 124,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
      ProductModel(
        name:
        "Tai nghe Bluetooth Chụp Tai Kanen K6",
        image:
        "https://cdn.tgdd.vn/Products/Images/54/202888/tai-nghe-bluetooth-kanen-k6-xam-gold-12-600x600.jpg",
          category: 'Tai nghe',
          price: 600000,
        discountPercentage: 20,
        sold: 67,
        hot: false,
        amount: 1,
        checkBuy: false
      ),
    ];
  }
}
