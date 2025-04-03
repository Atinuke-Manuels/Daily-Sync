// import 'package:flutter/material.dart';
//
// import '../custom_dropdown.dart';
// import '../custom_text_field.dart';
//
// class ViewTeamMembers extends StatefulWidget {
//   const ViewTeamMembers({super.key});
//
//   @override
//   State<ViewTeamMembers> createState() => _ViewTeamMembersState();
// }
//
// class _ViewTeamMembersState extends State<ViewTeamMembers> {
//   String? selectedDepartment;
//   TextEditingController searchController = TextEditingController();
//
//   final List<String> departments = [
//     "Engineering",
//     "Marketing",
//     "HR",
//     "Finance",
//     "Sales"
//   ];
//
//   final List<Map<String, String>> teamMembers = [
//     {"name": "Alice Johnson", "department": "Engineering"},
//     {"name": "Bob Smith", "department": "Marketing"},
//     {"name": "Charlie Davis", "department": "HR"},
//     {"name": "Daniel White", "department": "Finance"},
//     {"name": "Emma Wilson", "department": "Sales"},
//     {"name": "Franklin Reed", "department": "Engineering"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> filteredMembers = teamMembers.where((member) {
//       final matchesDepartment =
//           selectedDepartment == null || member["department"] == selectedDepartment;
//       final matchesSearch = searchController.text.isEmpty ||
//           member["name"]!.toLowerCase().contains(searchController.text.toLowerCase());
//       return matchesDepartment && matchesSearch;
//     }).toList();
//
//     return Scaffold(
//       appBar: AppBar(title: Text("All Team",
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       )),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomTextField(
//               controller: searchController,
//               label: "Search Team",
//               hint: "Enter name",
//               optionalIcon: Icons.search,
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//             const SizedBox(height: 20),
//
//             // Display Filtered Team Members
//             Expanded(
//               child: filteredMembers.isEmpty
//                   ? Center(child: Text("No team members found"))
//                   : ListView.builder(
//                 itemCount: filteredMembers.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Color(0xFF030F2D),
//                         child: Text(
//                           filteredMembers[index]["name"]![0],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       title: Text(filteredMembers[index]["name"]!),
//                       subtitle:
//                       Text("Department: ${filteredMembers[index]["department"]}"),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../custom_dropdown.dart';
import '../custom_text_field.dart';

class ViewTeamMembers extends StatefulWidget {
  const ViewTeamMembers({super.key});

  @override
  State<ViewTeamMembers> createState() => _ViewTeamMembersState();
}

class _ViewTeamMembersState extends State<ViewTeamMembers> {
  String? selectedDepartment;
  TextEditingController searchController = TextEditingController();

  final List<String> departments = [
    "All",
    "Engineering",
    "Marketing",
    "HR",
    "Finance",
    "Sales"
  ];

  final List<Map<String, String>> teamMembers = [
    {"name": "Alice Johnson", "department": "Engineering"},
    {"name": "Bob Smith", "department": "Marketing"},
    {"name": "Charlie Davis", "department": "HR"},
    {"name": "Daniel White", "department": "Finance"},
    {"name": "Emma Wilson", "department": "Sales"},
    {"name": "Franklin Reed", "department": "Engineering"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredMembers = teamMembers.where((member) {
      final matchesDepartment = (selectedDepartment == null || selectedDepartment == "All")
          || member["department"] == selectedDepartment;
      final matchesSearch = searchController.text.isEmpty ||
          member["name"]!.toLowerCase().contains(searchController.text.toLowerCase());
      return matchesDepartment && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Team",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            CustomTextField(
              controller: searchController,
              label: "Search Team",
              hint: "Enter name",
              optionalIcon: Icons.search,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),

            // Custom Dropdown for Department Selection
            CustomDropdown(
              label: "Select Department",
              items: departments,
              selectedValue: selectedDepartment,
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Display Filtered Team Members
            Expanded(
              child: filteredMembers.isEmpty
                  ? const Center(child: Text("No team members found"))
                  : ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF030F2D),
                        child: Text(
                          filteredMembers[index]["name"]![0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(filteredMembers[index]["name"]!),
                      subtitle: Text(
                          "Department: ${filteredMembers[index]["department"]}"),
                    ),
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