import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../runs/domain/entities/run_session_entity.dart';

class ExerciseDetailsPage extends StatefulWidget {
  final RunSessionEntity runSession;

  const ExerciseDetailsPage({
    super.key,
    required this.runSession,
  });

  @override
  State<ExerciseDetailsPage> createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
  late final List<LatLng> _polylineData;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _polylineData = _decodePolyline(widget.runSession.polyline);
    _setupMapData();
  }

  List<LatLng> _decodePolyline(String polylineString) {
    if (polylineString.isEmpty) return [];
    try {
      List<LatLng> data = [];
      List<dynamic> list = jsonDecode(polylineString);
      for (var element in list) {
        var lat = double.parse((element)[0].toString());
        var long = double.parse((element)[1].toString());
        data.add(LatLng(lat, long));
      }
      return data;
    } catch (e) {
      return [];
    }
  }

  void _setupMapData() {
    if (_polylineData.isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _polylineData,
          color: AppColors.primaryDark,
          width: 5,
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _polylineData.first,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: _polylineData.last,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_polylineData.isNotEmpty) {
      // Small delay to ensure map is fully sized before bounds are applied
      Future.delayed(const Duration(milliseconds: 200), _fitMapToPolyline);
    }
  }

  void _fitMapToPolyline() {
    if (_polylineData.isEmpty || _mapController == null) return;
    
    double minLat = _polylineData.first.latitude;
    double minLong = _polylineData.first.longitude;
    double maxLat = _polylineData.first.latitude;
    double maxLong = _polylineData.first.longitude;

    for (var point in _polylineData) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLong) minLong = point.longitude;
      if (point.longitude > maxLong) maxLong = point.longitude;
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLong),
          northeast: LatLng(maxLat, maxLong),
        ),
        50.0,
      ),
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
  
  String _formatPace(double paceMinPerKm) {
    final mins = paceMinPerKm.floor();
    final secs = ((paceMinPerKm - mins) * 60).round();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _labelForExerciseType(String exerciseType) {
    final l10n = AppLocalizations.of(context)!;
    switch (exerciseType) {
      case 'bike':
        return l10n.exercisesLabelBike;
      case 'walk':
        return l10n.exercisesLabelWalk;
      case 'run':
      default:
        return l10n.exercisesLabelRun;
    }
  }

  @override
  Widget build(BuildContext context) {
    final run = widget.runSession;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    
    final dateStr = DateFormat('E., d/MM/yyyy', locale).format(run.createdAt).toUpperCase();

    // Mock calculations for missing data for display purposes
    final dehydrationMl = (run.durationSeconds / 60) * 8; // dummy: 8ml per minute
    final elevationGain = 20; // dummy
    final elevationLoss = 19; // dummy
    final maxElevation = 86; // dummy

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          dateStr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map section
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _polylineData.isNotEmpty 
                      ? _polylineData.first 
                      : const LatLng(0, 0),
                  zoom: 15,
                ),
                polylines: _polylines,
                markers: _markers,
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
            
            // Header with Exercise Type
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFFF5F6F8), // light gray background from mockup
              child: Text(
                _labelForExerciseType(run.exerciseType).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Main Stats
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMainStat(
                    run.distanceKm.toStringAsFixed(2),
                    l10n.exercisesDetailsDistance(l10n.homeUnitKm).toUpperCase(),
                  ),
                  _buildMainStat(
                    _formatDuration(run.durationSeconds),
                    l10n.exercisesDetailsDuration.toUpperCase(),
                  ),
                  _buildMainStat(
                    run.calories.toStringAsFixed(0),
                    l10n.exercisesDetailsCalories.toUpperCase(),
                  ),
                ],
              ),
            ),

            // Detailed List section
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.timer_outlined, 
                    title: l10n.exercisesDetailsPace, 
                    value: '${_formatPace(run.pace)} min/km',
                  ),
                  _buildListTile(
                    icon: Icons.speed_rounded, 
                    title: l10n.exercisesDetailsAvgSpeed, 
                    value: '${run.averageSpeed.toStringAsFixed(1)} km/h',
                  ),
                  _buildListTile(
                    icon: Icons.speed_rounded, 
                    title: l10n.exercisesDetailsMaxSpeed, 
                    value: '${run.maxSpeed.toStringAsFixed(1)} km/h',
                  ),
                  _buildListTile(
                    icon: Icons.terrain_rounded, 
                    title: l10n.exercisesDetailsElevationGain, 
                    value: '$elevationGain m',
                  ),
                  _buildListTile(
                    icon: Icons.terrain_rounded, 
                    title: l10n.exercisesDetailsElevationLoss, 
                    value: '$elevationLoss m',
                  ),
                  _buildListTile(
                    icon: Icons.terrain_rounded, 
                    title: l10n.exercisesDetailsMaxElevation, 
                    value: '$maxElevation m',
                  ),
                  _buildListTile(
                    icon: Icons.local_drink_outlined, 
                    title: l10n.exercisesDetailsDehydration, 
                    value: '${dehydrationMl.toInt()} ml',
                  ),
                  _buildListTile(
                    icon: Icons.forest_outlined, 
                    title: l10n.exercisesDetailsSeedsEarned, 
                    value: '${run.treesEarned}',
                  ),
                  _buildListTile(
                    icon: Icons.access_time_rounded, 
                    title: l10n.exercisesDetailsStartTime, 
                    value: DateFormat.Hm(locale).format(run.createdAt),
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon, 
    required String title, 
    required String value, 
    bool showDivider = true
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textPrimary, size: 28),
              const SizedBox(width: 16),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.8,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 68, endIndent: 24, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
