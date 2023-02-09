import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneclicktravel/utils/color_code_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/size_config.dart';

class HotelRoomsSelect extends StatefulWidget {
  @override
  _HotelRoomsSelectState createState() => _HotelRoomsSelectState();
}

class _HotelRoomsSelectState extends State<HotelRoomsSelect> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ScrollController _animatedListController = new ScrollController();
  ListModel? _list;
  int? _selectedItem;
  int _nextItem = 0;
  List adultCount = ['1', '1', '1', '1', '1', '1', '1', '1', '1', '1'];

  List childCount = ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'];
  List<List> agesOfchild = [];

  @override
  void initState() {
    super.initState();

    _list = ListModel<int?>(
      listKey: _listKey,
      initialItems: <int>[1],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 2;
    agesOfchild = List.filled(10, []);

    // agesOfchild.length = 10;
    int i = 0;
    while (i < agesOfchild.length) {
      print('while init ===========================');
      agesOfchild[i] = ['0', '0', '0', '0'];
      i++;
    }
    print(agesOfchild.toString());
    // getLastRoomsAdultsChild();
  }

  // getLastRoomsAdultsChild() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getInt('total_room') != null &&
  //       prefs.getInt('total_adult') != null) {
  //     var totalRoom = prefs.getInt('total_room');
  //     List<int> intArr = [];

  //     setState(() {
  //       intArr.length = totalRoom;
  //       print('totalRoom=======$totalRoom');
  //       for (int i = 0; i < totalRoom;) {
  //         intArr[i] = ++i;
  //       }
  //       print('setting state=======$totalRoom');
  //       print('intArr state=======$intArr');
  //       _list = ListModel<int>(
  //         listKey: _listKey,
  //         initialItems: intArr,
  //         removedItemBuilder: _buildRemovedItem,
  //       );
  //       _nextItem = ++totalRoom;

  //       agesOfchild.length = 10;
  //       int i = 0;
  //       while (i < agesOfchild.length) {
  //         print('while init ===========================');
  //         agesOfchild[i] = ['0', '0', '0', '0'];
  //         i++;
  //       }
  //       print(agesOfchild.toString());
  //     });
  //   } else {}
  // }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    print('buildItem ==================$index');

    return CardItem(
        animation: animation,
        item: _list![index],
        selected: _selectedItem == _list![index],
        list: _list,
        adultCountList: adultCount,
        childCountList: childCount,
        agesOfchild: agesOfchild,
        onTap: () {
          HapticFeedback.vibrate();
          _insert();
        },
        onPressedMinus: () {
          HapticFeedback.vibrate();
          _remove(index);
        });
  }

  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
    );
  }

  void _insert() {
    final int index =
        _selectedItem == null ? _list!.length : _list!.indexOf(_selectedItem);
    print(index.toString() + 'insert index===========');
    print(_nextItem.toString() + '_nextItem ===========');
    print(_list.toString() + '_list ===========');

    if (_list!.length < 10) {
      _list!.insert(index, _nextItem++);
    } else {
      // Fluttertoast.showToast(msg: '')
    }
    print(_list!.length.toString() + '_list.length ===========');

    Timer(
      Duration(milliseconds: 220),
      () {
        _animatedListController.animateTo(
          _animatedListController.position.maxScrollExtent + 250,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
    );
  }

  void _remove(int index) async {
    //print('deleting=====================$index');
    await _list!.removeAt(index);
    for (int i = index; i < _nextItem - 2; i++) {
      adultCount[i] = adultCount[i + 1];
      childCount[i] = childCount[i + 1];
    }
    _nextItem = _nextItem - 1;
  }

  @override
  Widget build(BuildContext context) {
    // print('running build================' + _list!.length.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorCodeGen.colorFromHex('#ffd022'),
        title: Text('Select Room'),
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16,
            right: 16,
            // bottom: 100,
          ),
          child: AnimatedList(
            // padding: EdgeInsets.zero,
            controller: _animatedListController,
            key: _listKey,
            initialItemCount: _list!.length,
            itemBuilder: _buildItem,
          ),
        ),
        returnHotelRoomDoneButton(),
      ]),
    );
  }

  // adultChildrenInEachRoom() {
  //   return List();
  // }

  returnHotelRoomDoneButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ColorCodeGen.colorFromHex('#0e3957'),
          ),
          height: SizeConfig.blockSizeVertical * 6.5,
          width: SizeConfig.blockSizeHorizontal * 95,
          child: ElevatedButton(
            onPressed: () async {
              HapticFeedback.vibrate();
              // adultChildrenInEachRoom();
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.setString('hotel_total_room',_list.length.toString());
              // prefs.setString('hotel_total_room',_list.length.toString());
              // prefs.setString('hotel_total_room',_list.length.toString());
              List totalHotelRoomData =
                  new List.filled(4, null, growable: false);
              print('Room=================' + _list!.length.toString());

              totalHotelRoomData[0] = _list!.length.toString();
              totalHotelRoomData[1] = adultCount;
              totalHotelRoomData[2] = childCount;
              totalHotelRoomData[3] = agesOfchild;

              Navigator.pop(context, totalHotelRoomData);
            },
            child: Center(
              child: Text(
                'DONE',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder = Widget Function(
    int item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  ListModel({
    this.listKey,
    this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState>? listKey;
  final RemovedItemBuilder? removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey!.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  Future<E> removeAt(int index) async {
    print('removing items=========================$index');

    final E removedItem = _items.removeAt(index);

    if (removedItem != null) {
      // Future.delayed(Duration(milliseconds: 10000));
      // print('future========================');
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          //
          return removedItemBuilder!(index, context, animation);
        },
        duration: Duration(microseconds: 0),
      );

      print('_animatedList items=========================' +
          _animatedList.toString());
      print('removedItem items=========================' +
          removedItem.toString());
      print('_items =========================' + _items.toString());
      // _next
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatefulWidget {
  const CardItem({
    this.onTap,
    this.selected = false,
    this.animation,
    required this.item,
    this.list,
    this.onPressedMinus,
    this.adultCountList,
    this.childCountList,
    this.agesOfchild,
  }) : assert(item >= 0);
  final Animation<double>? animation;
  final VoidCallback? onTap;
  final VoidCallback? onPressedMinus;
  final int item;
  final bool selected;
  final ListModel? list;
  final List? adultCountList;
  final List? childCountList;
  final List<List>? agesOfchild;
  _CardItemState createState() => _CardItemState(
        onTap: onTap,
        animation: animation,
        item: item,
        selected: false,
        listRef: list,
        onPressedMinus: onPressedMinus,
        adultCountList: adultCountList,
        childCountList: childCountList,
        agesOfchild: agesOfchild,
      );
}

class _CardItemState extends State<CardItem> {
  _CardItemState({
    this.onTap,
    this.selected = false,
    this.animation,
    required this.item,
    this.listRef,
    this.onPressedMinus,
    this.adultCountList,
    this.childCountList,
    this.agesOfchild,
  }) : assert(item >= 0);

  final Animation<double>? animation;
  final VoidCallback? onTap;
  final VoidCallback? onPressedMinus;
  final int item;
  final bool selected;

  ListModel? listRef;
  List? childCountList;
  List<List>? agesOfchild;

  List? adultCountList;

  // final GlobalKey childAgedropDownKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    print('init=============');
  }

  Widget? childAgeDropDownWidget;

  @override
  Widget build(BuildContext context) {
    print('adult=====build' + adultCountList.toString());
    print('child=====build' + childCountList.toString());
    print('child=====agesOfchild' + agesOfchild.toString());

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(2.0),
          child: SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation!,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              // onTap: onTap,
              child: SizedBox(
                // height: 150.0,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // item > 1
                            //     ?
                            Row(
                              children: [
                                listRef!.length > 1
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: ColorCodeGen.colorFromHex(
                                              '#ffd022'),
                                        ),
                                        onPressed: onPressedMinus,
                                        // onPressed: () {

                                        //   print(
                                        //       'removing  clikced item now==========' +
                                        //           listRef.indexOf(item).toString());
                                        //   listRef.removeAt(listRef.indexOf(item));
                                        // },
                                        tooltip: 'Decrease no of  Room',
                                      )
                                    : SizedBox(),
                                Text(
                                  'Room $item',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            listRef!.length == item && listRef!.length != 10
                                ? InkWell(
                                    onTap: onTap,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle,
                                            color: ColorCodeGen.colorFromHex(
                                                '#ffd022'),
                                          ),
                                          onPressed: onTap,
                                          tooltip: 'Increase no of  Room',
                                        ),
                                        Text(
                                          'Add room',
                                          style: TextStyle(
                                            color: ColorCodeGen.colorFromHex(
                                                '#ffd022'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(''),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.grey[300],
                        thickness: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              openHotelAdultDropDown(item),
                              openHotelChildDropDown(item),
                            ],
                          ),
                          childCountList![item - 1] != "0"
                              ? Padding(
                                  padding: EdgeInsets.only(left: 8.0, top: 8),
                                  child: Text('Ages of Children'),
                                )
                              : Text(''),
                          childCountList![item - 1] != "0"
                              ? returnChildAgeDropDown(
                                  int.parse(childCountList![item - 1]), item)
                              : Row(children: []),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        listRef!.length == item
            ? SizedBox(
                height: 100,
              )
            : SizedBox(
                height: 0,
              )
      ],
    );
  }

  Widget openHotelChildDropDown(int item) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Children'),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.8),
                border: Border.all(color: Colors.grey[200]!)),
            child: DropdownButton<String>(
              value: childCountList![item - 1],
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  // size: 30,
                ),
              ),
              elevation: 16,
              style: TextStyle(
                color: Colors.black87,
                // fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              onChanged: (newValue) {
                setState(() {
                  childCountList![item - 1] = newValue;
                  // print(childCountList.toString());
                  // if (int.parse(newValue) > 0) {
                  //   childAgeDropDownWidget =
                  //       returnChildAgeDropDown(int.parse(newValue), item);
                  // } else {
                  //   childAgeDropDownWidget = null;
                  // }
                });
              },
              items: <String>[
                '0',
                '1',
                '2',
                '3',
                '4',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        value,
                      ),
                    ),
                  ),
                  // overflow: TextOverflow.ellipsis,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget openHotelAdultDropDown(int item) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adults'),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.8),
                border: Border.all(color: Colors.grey[200]!)),
            child: DropdownButton<String>(
              value: adultCountList![item - 1],
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  // size: 30,
                ),
              ),
              elevation: 16,
              style: TextStyle(
                color: Colors.black87,
                // fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              onChanged: (newValue) {
                setState(() {
                  adultCountList![item - 1] = newValue;
                  print('adultCount');
                  print(adultCountList.toString());
                });
              },
              items: <String>[
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(
                          value,
                        ),
                      ),
                    ),
                  ),
                  // overflow: TextOverflow.ellipsis,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget returnChildAgeDropDown(int noOfChild, int item) {
    print('returnChildAgeDropDown ==========no of child $noOfChild');
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: noOfChild,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 3.3),
      ),
      itemBuilder: (BuildContext context, int index) {
        return returnSingleChildAgeDropDown(index, item);
      },
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     for (int i = 1; i <= noOfChild; i++)
    //       returnSingleChildAgeDropDown(noOfChild),
    //   ],
    // );
  }

  Widget returnSingleChildAgeDropDown(int index, int item) {
    print('item=============$item');
    print('index=============$index');
    print('=========================================');

    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // noOfChild <= 1 ? Text('Ages of Children') : Text(''),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.8),
                border: Border.all(color: Colors.grey[200]!)),
            child: DropdownButton<String>(
              value: agesOfchild![item - 1][index],
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                ),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  // size: 30,
                ),
              ),
              elevation: 16,
              style: TextStyle(
                color: Colors.black87,
                // fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              onChanged: (newValue) {
                print('click child age============before age select=');
                print(agesOfchild.toString());
                setState(() {
                  agesOfchild![item - 1][index] = newValue;
                });
                print(
                    'childage of index $index===item $item============is $newValue');
                print(agesOfchild.toString());
              },
              items: <String>[
                '0',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
                '11',
                '12',
                '13',
                '14',
                '15',
                '16',
                '17',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(
                          value,
                        ),
                      ),
                    ),
                  ),
                  // overflow: TextOverflow.ellipsis,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
