import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:syth_hotel/config/app_color.dart';
import 'package:syth_hotel/config/app_format.dart';
import 'package:syth_hotel/config/app_route.dart';
import 'package:syth_hotel/model/booking.dart';

import '../config/app_asset.dart';
import '../controller/c_history.dart';
import '../controller/c_home.dart';
import '../controller/c_user.dart';

// Penggunaan StatefulWidget untuk menggunakan initState
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cUser = Get.put(CUser());
  final cHistory = Get.put(CHistory());
  final cHome = Get.put(CHome());

  @override
  // Memanggil fungsi getListBooking pada CHistory saat inisiliasi halaman
  void initState() {
    // Seharusnya menggunakan Pull-to-Refresh juga untuk memuat ulang data agar data terupdate
    cHistory.getListBooking(cUser.data.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        header(context),
        const SizedBox(height: 24),
        Obx(
          () => cHistory.listBooking.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Image.asset(AppAsset.emptyHistory, width: 300),
                      const SizedBox(height: 8),
                      Text(
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        'Your history is Empty',
                      ),
                      const SizedBox(height: 5),
                      const Text("Let's book your first hotel now!"),
                      const SizedBox(height: 16),
                    ],
                  ),
                )
              : GetBuilder<CHistory>(
                  builder: (_) {
                    // Sebuah package ListView namun list nya bisa diatur berdasarkan group (tanggal, DESC, ASC, dll)
                    return GroupedListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // _ adalah sebuah controller builder yang merujuk <cHistory>
                      // listBooking => data yang akan ditampilkan
                      elements: _.listBooking,
                      // Mengatur group berdasarkan tanggal karena return date, menghasilkan GROUP
                      groupBy: (element) {
                        return element.date;
                      },
                      // Judul/Header untuk setiap group
                      groupSeparatorBuilder: (String groupByValue) {
                        // Terdapat beberapa kondisi untuk mengatur judul header, Today New hanya untuk booking hari ini
                        // Sedangkan tanggal lain akan memiliki header berdasarkan tanggal booking
                        String date =
                            DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
                                    groupByValue
                                ? 'Today New'
                                : AppFormat.dateMonth(groupByValue);

                        return Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            date,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      itemBuilder: (context, element) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.detailBooking,
                                arguments: element,
                              );
                            },
                            child: item(context, element),
                          ),
                        );
                      },
                      // Sebuah sorting untuk mengatur item-item, karena menggunakan .date sehingga akan diurutkan berdasarkan tanggal
                      // Mengurutkan item di suatu group
                      itemComparator: (item1, item2) =>
                          item1.date.compareTo(item2.date),
                      // Group akan ditampilkan secara DESCENDING
                      order: GroupedListOrder.DESC,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Container item(BuildContext context, Booking booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              booking.cover,
              fit: BoxFit.cover,
              height: 70,
              width: 90,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  AppFormat.date(booking.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: booking.status == 'PAID' ? AppColor.secondary : Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              booking.status,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Padding header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              AppAsset.profilKu,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'My Booking',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Obx(
                () {
                  return Text(
                    '${cHistory.listBooking.length} transactions',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
