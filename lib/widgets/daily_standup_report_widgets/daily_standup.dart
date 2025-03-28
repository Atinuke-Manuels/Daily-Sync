import 'package:flutter/material.dart';

import '../custom_button.dart';

class DailyStandup extends StatelessWidget {
   DailyStandup({super.key});

   final List<Map<String, String>> reports = List.generate(
     3,
         (index) => {
       'name': 'Dorcas Owolabi',
       'todayTask': 'Dorcas Owolabi',
       'yesterdayTask': 'Dorcas Owolabi',
       'date': 'DD/MM/YYYY',
       'time': '10:00AM',
       'blockers': 'Dorcas Owolabi',
     },
   );

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.white,
         elevation: 0,
         leading: IconButton(
           icon: const Icon(Icons.arrow_back, color: Color(0xFF030F2D)),
           onPressed: () {
             Navigator.pop(context);
           },
         ),
         title: const Text(
           'All Standup Reports',
           style: TextStyle(
             fontWeight: FontWeight.bold,
             fontSize: 18,
             color: Color(0xFF030F2D),
           ),
         ),
         centerTitle: true,
       ),
       body: Padding(
         padding: const EdgeInsets.all(16.0),
         child: ListView.builder(
           itemCount: reports.length,
           itemBuilder: (context, index) {
             final report = reports[index];
             return Card(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10),
               ),
               elevation: 2,
               margin: const EdgeInsets.only(bottom: 16),
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildRichText('Name:', report['name']!),
                     _buildRichText('Today’s Task:', report['todayTask']!),
                     _buildRichText('Yesterday Task:', report['yesterdayTask']!),
                     _buildRichText('Date:', report['date']!),
                     _buildRichText('Time:', report['time']!),
                     _buildRichText('Any Blockers/Challenges:', report['blockers']!),
                     const SizedBox(height: 12),
                     CustomButton(
                       title: 'Comment',
                       onTap: () {
                         // Handle comment button press
                       },
                     ),
                   ],
                 ),
               ),
             );
           },
         ),
       ),
     );
   }

   Widget _buildRichText(String label, String value) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 6),
       child: RichText(
         text: TextSpan(
           text: '$label ',
           style: const TextStyle(
             fontSize: 14,
             fontWeight: FontWeight.bold,
             color: Color(0xFF030F2D),
           ),
           children: [
             TextSpan(
               text: value,
               style: const TextStyle(
                 fontWeight: FontWeight.normal,
                 color: Color(0xFF030F2D),
               ),
             ),
           ],
         ),
       ),
     );
   }
}
