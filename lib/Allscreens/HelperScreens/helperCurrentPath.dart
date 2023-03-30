import 'package:flutter/material.dart';

class HelperCurrentPath extends StatelessWidget {
  const HelperCurrentPath({Key? key}) : super(key: key);
  
  static const String idScreen = "currentpath";
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
              Text(
                "CURRENT PATH",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Chatabar",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_right_alt,
                size: 50,
                color: Colors.black,
              ),
              Expanded(
                child: Text(
                  "Vani Vihar",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "OUT TIME",
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "9:45 AM",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
