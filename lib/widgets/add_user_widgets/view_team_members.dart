import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../view_model/team_view_model.dart';
import '../custom_dropdown.dart';
import '../custom_text_field.dart';
import 'edit_or_disable_members_dialog.dart';

class ViewTeamMembers extends StatefulWidget {
  const ViewTeamMembers({super.key});

  @override
  State<ViewTeamMembers> createState() => _ViewTeamMembersState();
}

class _ViewTeamMembersState extends State<ViewTeamMembers> {
  String? selectedDepartment;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<TeamMembersViewModel>(context, listen: false);
    viewModel.fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TeamMembersViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Members",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: searchController,
              label: "Search Team",
              hint: "Enter name",
              optionalIcon: Icons.search,
              onChanged: (value) {
                setState(() {}); // Rebuild UI when search is typed
              },
            ),
            const SizedBox(height: 16),

            CustomDropdown(
              label: "Select Department",
              items: viewModel.departments,
              selectedValue: selectedDepartment,
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                });
              },
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: viewModel.fetchUsers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var users = snapshot.data!;
                  var filteredMembers = users.where((member) {
                    final matchesDepartment = (selectedDepartment == null || selectedDepartment == "All") ||
                        member["department"] == selectedDepartment;
                    final matchesSearch = searchController.text.isEmpty ||
                        member["name"]!.toLowerCase().contains(searchController.text.toLowerCase());
                    return matchesDepartment && matchesSearch;
                  }).toList();

                  return filteredMembers.isEmpty
                      ? const Center(child: Text("No team members found"))
                      : ListView.builder(
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      var member = filteredMembers[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: member["isDisabled"]
                                ? Colors.grey
                                : const Color(0xFF030F2D),
                            child: Text(
                              member["name"]![0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(member["name"]!),
                          subtitle: Text("Department: ${member["department"]}"),
                          trailing: member["isDisabled"]
                              ? const Text("Disabled", style: TextStyle(color: Colors.red))
                              : null,
                            onTap: () {
                              showUserDialog(context, userData: member, viewModel: viewModel);
                            }
                        ),
                      );
                    },
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
