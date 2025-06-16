SR-71 BLACKBIRD - ENHANCED EDITION
==================================

This is a comprehensive enhancement of the FlightGear SR-71 Blackbird aircraft addon,
featuring realistic systems simulation, advanced flight dynamics, and authentic
operational procedures based on declassified technical documentation.

VARIANTS AVAILABLE:
- SR-71A: Standard reconnaissance variant
- SR-71B: Trainer variant with dual controls
- SR-71C: Hybrid variant (A-12 forward fuselage with SR-71 aft section)
- BigTail: Variant with enlarged vertical stabilizers
- NASA variants: Modified for research missions

MAJOR ENHANCEMENTS:
==================

1. REALISTIC ENGINE SYSTEMS:
   - Authentic J58 turbo-ramjet simulation
   - Automatic transition from turbojet to ramjet mode above Mach 2.2
   - Compressor Inlet Temperature (CIT) monitoring with 427°C limit
   - Engine unstart protection and automatic restart procedures
   - Realistic fuel consumption curves for JP-7 fuel
   - Altitude-dependent thrust characteristics

2. ADVANCED INLET SPIKE CONTROL:
   - Automatic spike positioning based on Mach number
   - Manual override capability for experienced pilots
   - Realistic inlet efficiency calculations
   - Smooth spike movement with proper kinematic delays
   - Visual spike position indicators in cockpit

3. ENHANCED FLIGHT DYNAMICS:
   - Improved aerodynamic coefficients for high-speed flight
   - Realistic drag characteristics with inlet efficiency effects
   - Ground effect modeling for landing operations
   - Enhanced stability and control at all flight regimes
   - Accurate center of gravity management

4. AUTHENTIC FUEL MANAGEMENT:
   - Proper fuel sequencing system
   - Automatic center of gravity control
   - Fuel transfer logic for high-speed stability
   - Multiple tank configuration (1A, 1, 2, 3, 4, 5, 6A, 6)
   - JP-7 fuel properties simulation

5. CLIMB-DIVE PROCEDURE AUTOMATION:
   - Authentic transonic acceleration technique
   - Automatic phase detection and guidance
   - Dive from 33,000 ft to 30,000 ft for Mach 1 transition
   - Acceleration to 450 KEAS before supersonic climb
   - Constant EAS climb profile implementation

6. FLIGHT ENVELOPE PROTECTION:
   - Mach 3.53 unstart limit enforcement
   - CIT temperature monitoring and warnings
   - Automatic engine protection systems
   - Flight envelope boundary alerts
   - System health monitoring

7. ENHANCED COCKPIT INSTRUMENTATION:
   - CIT gauges for both engines
   - Inlet spike position indicators
   - Turbo-ramjet mode status lights
   - Bypass ratio displays
   - Fuel transfer status indicators
   - Center of gravity position display
   - Flight envelope protection warnings
   - Climb-dive procedure status
   - System health indicators

INSTALLATION:
============

1. Copy the entire SR71-BlackBird folder to your FlightGear Aircraft directory:
   - Windows: C:\Program Files\FlightGear\data\Aircraft\
   - macOS: /Applications/FlightGear.app/Contents/Resources/data/Aircraft/
   - Linux: /usr/share/games/flightgear/Aircraft/

2. Launch FlightGear and select one of the SR-71 variants from the aircraft menu

3. For best experience, start at a military airfield with long runways (>10,000 ft)

COMMAND LINE USAGE:
==================

Basic launch:
fgfs --aircraft=Blackbird-A --airport=KEDW

High-altitude start:
fgfs --aircraft=Blackbird-A --airport=KEDW --altitude=50000 --vc=400

Supersonic cruise start:
fgfs --aircraft=Blackbird-A --airport=KEDW --altitude=70000 --vc=1800

OPERATIONAL PROCEDURES:
======================

1. PREFLIGHT:
   - Set fuel auto-sequence to AUTO
   - Set inlet mode to AUTO
   - Enable Mach limit protection
   - Check system health indicators

2. TAKEOFF:
   - Rotation speed: 180 knots
   - Takeoff speed: 210 knots
   - Initial climb: 300 knots to 10,000 ft

3. TRANSONIC ACCELERATION (Climb-Dive Procedure):
   - Climb to 33,000 ft at 300 knots
   - Enable climb-dive mode
   - Follow automated procedure guidance
   - Dive to 30,000 ft, accelerate to 450 KEAS
   - Begin constant EAS climb

4. SUPERSONIC CRUISE:
   - Maintain 450 KEAS until Mach 1.0
   - Continue climb at constant EAS
   - Monitor CIT temperatures (max 427°C)
   - Watch for ramjet transition at Mach 2.2
   - Cruise altitude: 70,000-85,000 ft
   - Cruise speed: Mach 3.0-3.2

5. DESCENT AND LANDING:
   - Begin descent well before destination
   - Reduce speed gradually
   - Landing approach: 175 knots
   - Landing speed: 155 knots
   - Use drag chute for landing roll

SYSTEM CONTROLS:
===============

Keyboard Controls:
- Ctrl+I: Toggle inlet spike mode (Auto/Manual)
- Ctrl+F: Toggle fuel auto-sequence
- Ctrl+C: Toggle climb-dive procedure
- Ctrl+M: Toggle Mach limit protection
- Ctrl+R: Manual engine restart

Cockpit Switches:
- Inlet Mode: AUTO/MANUAL spike control
- Fuel Auto: Automatic fuel sequencing
- C-D Mode: Climb-dive procedure automation
- Mach Limit: Speed limit enforcement

PERFORMANCE DATA:
================

- Maximum Speed: Mach 3.3+ (limited by CIT)
- Service Ceiling: 85,000+ feet
- Range: 3,200 nautical miles (without refueling)
- Engines: 2 × Pratt & Whitney J58-1 (34,000 lbs thrust each)
- Fuel Capacity: ~80,000 lbs JP-7
- Empty Weight: 59,000 lbs
- Maximum Weight: 170,000 lbs

TROUBLESHOOTING:
===============

Engine Unstart:
- Reduce throttle immediately
- Check Mach number (must be below 3.53)
- Monitor CIT temperatures
- Attempt restart when conditions are suitable

Poor Performance:
- Check inlet spike positions
- Verify fuel sequencing is active
- Monitor system health indicators
- Ensure proper altitude for flight regime

CONTROL ISSUES:
- Verify center of gravity is within limits
- Check fuel distribution
- Ensure proper trim settings
- Monitor flight envelope protection warnings

TECHNICAL NOTES:
===============

This enhanced model incorporates:
- Declassified SR-71 flight manual procedures
- NASA technical reports on J58 engine operation
- Lockheed engineering documentation
- Pilot accounts and operational histories
- Modern flight simulation best practices

The model is designed for educational and entertainment purposes,
representing the best available public information about this
remarkable aircraft's systems and performance.

CREDITS:
========

Original Model: Aeromatic, Gerard Robin
Enhancements: AI Assistant (2024)
Based on: Publicly available technical documentation
Special Thanks: FlightGear development community

VERSION: Enhanced Edition v1.0
STATUS: Beta - Continuous improvement
COMPATIBILITY: FlightGear 2020.3+

For support and updates, refer to the FlightGear community forums.
