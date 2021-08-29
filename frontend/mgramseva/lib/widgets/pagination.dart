

import 'package:flutter/material.dart';
import 'package:mgramseva/utils/models.dart';

class Pagination extends StatefulWidget {
 final int limit;
 final int offSet;
 final int totalCount;
 final Function(PaginationResponse) callBack;
  const Pagination({Key? key, required this.limit, required this.offSet, required this.callBack, required this.totalCount}) : super(key: key);

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    return  Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Rows per page'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black
                  ),
                    items: dropDownItems,
                value: widget.limit,
                  onChanged: onChangeOfPageCount,
                ),
              ),
             _buildPageDetails()
            ],
          ),
    );
  }

  get dropDownItems {
    return [10, 20, 30, 40, 50].map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text('$value'),
      );
    }).toList();
  }

  Widget _buildPageDetails(){
    return Container(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Visibility(
              visible:  widget.offSet > widget.limit,
              child: IconButton(onPressed: () => onChangeOfPage(false), icon: Icon(Icons.arrow_left))),
          Text('${widget.offSet} - ${(widget.offSet + widget.limit - 1) <= widget.totalCount ? (widget.offSet + widget.limit -1) : widget.totalCount}'),
          Visibility(
              visible: (widget.offSet + widget.limit - 1) < widget.totalCount ,
              child: IconButton(onPressed: onChangeOfPage, icon:Icon(Icons.arrow_right))),
        ],
      ),
    );
  }

  onChangeOfPage([bool isIncrement = true]) {
    if(isIncrement){
     widget.callBack(PaginationResponse(widget.limit, widget.offSet + widget.limit));
      return;
    }
    widget.callBack(PaginationResponse(widget.limit, widget.offSet - widget.limit));
  }

  onChangeOfPageCount(limit){
    widget.callBack(PaginationResponse(limit, 1));
  }
}
