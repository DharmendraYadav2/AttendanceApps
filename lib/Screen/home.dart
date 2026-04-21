import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tutionsapp/Login/app_login.dart';
import 'package:tutionsapp/Screen/indvidual_batches.dart';
import 'package:tutionsapp/Service/Firebase/providers/signup.dart';
import 'package:tutionsapp/Theme/app_fonts.dart';
import 'package:tutionsapp/Service/Firebase/controller/batch_ctrl.dart';
import '../Functions/app_function.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allbatches = ref.watch(batchcontrollerprovider);
    DateTime? lastPressed;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();

        if (lastPressed == null ||
            now.difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = now;

          Get.snackbar(
            "Exit",
            "Press back again to exit",
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          return false;
        }
        backbutton();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0575E6), Color(0xFF021B79)],
              ),
            ),
          ),
          title: Text(
            "Hajri Book",
            style: AppFonts().heading.copyWith(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await ref.read(authrepositoryprovider).signOut();
                Get.offAll(() => Login());
              },
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        bottomSheet: Container(
          height: MediaQuery.of(context).size.height / 9,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0575E6), Color(0xFF021B79)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showdialog(ref);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 30),
                        SizedBox(width: 2),
                        Text(
                          "Add Site",
                          style: AppFonts().heading.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: allbatches.when(
                data: (batches) {
                  if (batches.isEmpty) {
                    return Center(
                      child: Text(
                        "No site created yet",
                        style: AppFonts().heading,
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: 90),
                    child: ListView.builder(
                      itemCount: batches.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: ValueKey(batches[index].id),
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Editdialog(ref, batches[index]);
                                },
                                icon: Icons.edit_outlined,
                                label: "Edit",
                                backgroundColor: Color(0xFF0575E6),
                                foregroundColor: Colors.white,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  delete(ref, batches[index].id);
                                },
                                icon: Icons.delete,
                                label: "Delete",
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              elevation: 0.6,
                              color: Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  batches[index].name,
                                  style: AppFonts().heading.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Total:${batches[index].total}",
                                  style: AppFonts().body.copyWith(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Color(0xFF021B79),
                                ),
                                onTap: () {
                                  Get.to(
                                    transition: Transition.downToUp,
                                    () => Individual_person(
                                      batchid: batches[index].id,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (e, _) => Center(child: Text(e.toString())),
                loading: () => Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
