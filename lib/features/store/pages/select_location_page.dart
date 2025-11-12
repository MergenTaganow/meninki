// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
//
// class LatLng {
//   final double latitude;
//   final double longitude;
//
//   LatLng(this.latitude, this.longitude);
// }
//
// /// Opens a map screen and lets the user pick a location.
// /// Returns LatLng of selected point, or null if canceled.
// Future<LatLng?> selectLocation(BuildContext context) async {
//   return await Navigator.of(context).push<LatLng>(
//     MaterialPageRoute(
//       builder: (context) => _SelectLocationPage(),
//     ),
//   );
// }
//
// class _SelectLocationPage extends StatefulWidget {
//   @override
//   State<_SelectLocationPage> createState() => _SelectLocationPageState();
// }
//
// class _SelectLocationPageState extends State<_SelectLocationPage> {
//   LatLng? _selectedLatLng;
//
//   // Initial map center (adjust as needed)
//   final LatLng _initialCenter = LatLng(40.0, 20.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Store Location'),
//         actions: [
//           TextButton(
//             onPressed: _selectedLatLng == null
//                 ? null
//                 : () {
//               Navigator.of(context).pop(_selectedLatLng);
//             },
//             child: Text(
//               'CONFIRM',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           center: _initialCenter,
//           zoom: 13.0,
//           onTap: (tapPosition, point) {
//             setState(() {
//               _selectedLatLng = point;
//             });
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           if (_selectedLatLng != null)
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   width: 80,
//                   height: 80,
//                   point: _selectedLatLng!,
//                   builder: (ctx) => Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 )
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }