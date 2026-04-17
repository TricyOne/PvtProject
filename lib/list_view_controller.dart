import 'package:flutter/material.dart';
import 'report_page.dart';

class IceItem {
  final String location;
  final Widget qualityIcon;

  IceItem(this.location, this.qualityIcon);

  Widget buildTitle(BuildContext context) {
    return Text(location);
  }

  //läsa från JSON senare:
  factory IceItem.fromJson(Map<String, dynamic> json) {
    Widget tempIcon;

    if (json['quality'] == 'perfect') {
      tempIcon = Icon(Icons.circle_sharp, color: Colors.green);
    } else if (json['quality'] == 'passable') {
      tempIcon = Icon(Icons.circle_sharp, color: Colors.yellow);
    } else {
      tempIcon = Icon(Icons.circle_sharp, color: Colors.red);
    }
    return IceItem(json['location'], tempIcon);
  }
}

class ListViewController extends StatefulWidget {
  ListViewController({Key? key}) : super(key: key);

  @override
  State<ListViewController> createState() => _ListViewControllerState();
}

class _ListViewControllerState extends State<ListViewController> {
  List<IceItem> iceReports = []; //tidigare:  var iceReports = [];

  @override
  void initState() {
    refreshReports();
    super.initState();
  }

  Future refreshReports() async {
    /*Uri sampleReportsURI = Uri.parse(
    'https: ....',
    );

    final response = await http.get(sampleReportsURI);
    var data = json.decode(response.body);
    List<IceItem> iceReports = []; // var iceReports = [];
    List<IceItem> _reportsTemp = []; // var _reportsTemp = [];
    for (var i = 0; i < data.length; i++) {
    _reportsTemp.add(IceItem.fromJson(datat[i]));
    }
    setState(() {
    iceReports = _reportsTemp;
    });
    }
*/
    //hårdkodat:
    var data = [
      {"location": "Viknamn 1", "quality": "perfect"},
      {"location": "Sjönamn 1", "quality": "passable"},
      {"location": "Viknamn 2", "quality": "poor"},
      {"location": "Sjönamn 2", "quality": "passable"},
    ];
    iceReports = [];
    List<IceItem> _reportsTemp = []; //var _reportsTemp = [];
    for (var i = 0; i < data.length; i++) {
      _reportsTemp.add(IceItem.fromJson(data[i]));
    }
    setState(() {
      iceReports = _reportsTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: refreshReports,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Rapportera is'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportPage()),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: iceReports.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: iceReports[index].qualityIcon,
                    title: iceReports[index].buildTitle(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
