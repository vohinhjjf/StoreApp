

import 'package:store_app/models/flash_sale_model.dart';

class FlashSaleViewModel {
  List<FlashSaleModel> getFlashSale() {
    return [
      FlashSaleModel(
        name: "Laptop HP Pavilion 14-dv2034TU 6K770PA",
        image:
            "https://lh3.googleusercontent.com/UebfUbElofMWqaWog-wUgCKqFJhYfK-m5OUqnFev8-ZiDlmxcM10ZI32ecW3duON5BgB9EV7snvGAGRkbrVWvaggUrDbHxoD=rw-w230",
        price: 17389000,
        discountPercentage: 20,
        qty: 1000,
        sold: 900,
        mall: true,
      ),
      FlashSaleModel(
        name: "Laptop ACER Aspire 7 A715-42G-R05G NH.QAYSV.007",
        image:
            "https://lh3.googleusercontent.com/ITuM-86ObB_Q_pELdb6s3xjIvvECtOl2IxJJ9_4RUSaYmzOMEprg8EOQ-VKdFOeI3SFNL-fpnFL7KQggDoo84bXE2WIB_cDe=rw-w230",
        price: 15990000,
        discountPercentage: 22,
        qty: 500,
        sold: 250,
      ),
      FlashSaleModel(
        name: "Ổ cứng SSD Colorful NVME PCIE CN600 256GB WarHalberd",
        image:
            "https://lh3.googleusercontent.com/C8_5oYbctocQLfXxnpQZz96Q2LGi9mRvkWiuAXN8QryuLdxXgtCHCnnZzjxVHjlMN9jdHI2CIxgVHkDhcU0H3OyPOXQZUKc=rw-w230",
        price: 890000,
        discountPercentage: 30,
        qty: 50,
        sold: 10,
        mall: true,
      ),
      FlashSaleModel(
        name: "IPhone 13 Pro 256GB Graphite",
        image: "https://lh3.googleusercontent.com/KmQeeCVXtlRtPMGueouETxYgNPEG1rjHWPHumIOPZtWsin2zZK5nPR5BGSKloeMfGaxQlifNCYffI7kMiMQuQmkNSYur3Es=rw-w230",
        price: 24990000,
        discountPercentage: 20,
        qty: 512,
        sold: 320,
      ),
    ];
  }
}
