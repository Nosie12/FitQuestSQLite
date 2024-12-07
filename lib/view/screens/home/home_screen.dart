import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/home/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: HomeViewContent(),
    );
  }
}

class HomeViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Black top section
            Container(
              height: 60,
              color: Colors.black,
              child: Center(
                child: Text(
                  'FitQuest',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Green section centered more over the weekly goal box
            Container(
              color: Color(0xFF81A55D), // Green color
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(context, viewModel),
                    SizedBox(height: 10),
                    _buildWeeklyGoalSection(context, viewModel),
                  ],
                ),
              ),
            ),
            // Black section
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentJoggingSection(viewModel),
                    SizedBox(height: 40),
                    _buildRecentActivitySection(viewModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF81A55D),
        onPressed: () {
          Navigator.pushNamed(context, '/run');
        },
        child: const Icon(Icons.run_circle_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, HomeViewModel viewModel) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[750],
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Spacer(),
        IconButton(
          icon: const Icon(Icons.settings, color: Color(0xFF002A10)),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
    );
  }

  Widget _buildWeeklyGoalSection(BuildContext context, HomeViewModel viewModel) {
    final TextEditingController _goalController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Goal: ${viewModel.weeklyGoal.toStringAsFixed(1)} km',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 12),
          if (!viewModel.goalSet) // Hide input box if goal is set
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter goal...',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final newGoal = double.tryParse(_goalController.text);
                    if (newGoal != null && newGoal > 0) {
                      viewModel.setWeeklyGoal(newGoal);
                      _goalController.clear();
                    }
                  },
                  child: const Text('Set Goal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81A55D),
                  ),
                ),
              ],
            ),
          if (viewModel.goalSet)
            Text(
              'Goal set for the week!',
              style: TextStyle(color: Colors.green[300]),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${viewModel.weeklyProgress.toStringAsFixed(1)} km completed',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                '${viewModel.remainingDistance.toStringAsFixed(1)} km left',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF002A10),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                height: 12,
                width: MediaQuery.of(context).size.width *
                    (viewModel.progressPercentage / 100) *
                    0.85,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildCurrentJoggingSection(HomeViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF81A55D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: viewModel.recentRuns.isNotEmpty
          ? Row(
        children: [
          const Icon(Icons.directions_run, size: 30, color: Color(0xFF002A10)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current jogging',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '${viewModel.recentRuns.first.distance.toStringAsFixed(1)} km',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                'Duration: ${_formatDuration(viewModel.recentRuns.first.duration)}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      )
          : Center(
        child: Text(
          'No active jogs.',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  Widget _buildRecentActivitySection(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 14),
        Container(
          height: 230,
          child: ListView.builder(
            itemCount: viewModel.recentRuns.length,
            itemBuilder: (context, index) {
              final run = viewModel.recentRuns[index];
              return ListTile(
                leading: Icon(Icons.directions_run, color: Colors.green),
                title: Text(
                  '${run.distance.toStringAsFixed(1)} km',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Duration: ${_formatDuration(run.duration)}',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: run.showTime
                    ? Text(
                  '${run.startTime.hour}:${run.startTime.minute} - ${run.endTime.hour}:${run.endTime.minute}',
                  style: TextStyle(color: Colors.grey[400]),
                )
                    : IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.grey),
                  onPressed: () {
                    run.showTime = true;
                    viewModel.notifyListeners();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
