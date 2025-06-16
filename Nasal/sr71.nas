### Enhanced SR-71 Main Systems File ###

# Update timers for different system priorities
var FAST_UPDATE_TIMER = 0.1;    # Critical systems (engine monitoring, inlet control)
var MAIN_UPDATE_TIMER = 0.3;    # Standard systems (CIT, damage)
var SLOW_UPDATE_TIMER = 1.0;    # Non-critical systems (fuel management)

# Engine and propulsion paths
var engine_damage = ["/engines/engine[0]/eng-damage", "/engines/engine[1]/eng-damage"];
var cit_path = "/fdm/jsbsim/propulsion/cit";
var mach_path = "/fdm/jsbsim/velocities/mach";
var altitude_path = "/fdm/jsbsim/position/h-sl-ft";
var throttle_paths = ["/controls/engines/engine[0]/throttle", "/controls/engines/engine[1]/throttle"];

# Inlet spike and bypass system paths
var inlet_spike_pos = ["/fdm/jsbsim/propulsion/engine[0]/inlet-spike-pos", "/fdm/jsbsim/propulsion/engine[1]/inlet-spike-pos"];
var bypass_ratio = ["/fdm/jsbsim/propulsion/engine[0]/bypass-ratio", "/fdm/jsbsim/propulsion/engine[1]/bypass-ratio"];
var inlet_efficiency = ["/fdm/jsbsim/propulsion/engine[0]/inlet-efficiency", "/fdm/jsbsim/propulsion/engine[1]/inlet-efficiency"];

# Fuel system paths
var fuel_tanks = ["/fdm/jsbsim/propulsion/tank[0]/contents-lbs", "/fdm/jsbsim/propulsion/tank[1]/contents-lbs", "/fdm/jsbsim/propulsion/tank[2]/contents-lbs"];
var fuel_flow = ["/engines/engine[0]/fuel-flow-gph", "/engines/engine[1]/fuel-flow-gph"];

# Environmental and flight envelope
var eas_path = "/fdm/jsbsim/velocities/vc-kts";
var dynamic_pressure_path = "/fdm/jsbsim/aero/qbar-psf";

# Initialize all systems
setprop(engine_damage[0], 0);
setprop(engine_damage[1], 0);
setprop("/cit", 0);
setprop("/systems/sr71/inlet-auto-mode", 1);
setprop("/systems/sr71/turbo-ramjet-mode", 0);
setprop("/systems/sr71/fuel-auto-sequence", 1);
setprop("/systems/sr71/climb-dive-mode", 0);

# Initialize inlet spike positions
setprop(inlet_spike_pos[0], 0);
setprop(inlet_spike_pos[1], 0);
setprop(bypass_ratio[0], 0);
setprop(bypass_ratio[1], 0);

# Enhanced main update loop with improved systems
var main = func () {
    var current_mach = getprop(mach_path);
    var current_altitude = getprop(altitude_path);
    var cit_temp = getprop(cit_path);
    
    # Enhanced CIT monitoring and damage calculation
    var cit_max = 427; # Maximum safe CIT in Celsius
    if (cit_temp > cit_max) {
        var damage_rate = 0;
        
        # More realistic damage progression based on temperature
        if (cit_temp < 453) {
            # Light overheating - 5 hours to failure
            damage_rate = 1 / (18000 / MAIN_UPDATE_TIMER);
        } elsif (cit_temp < 478) {
            # Moderate overheating - 1 hour to failure
            damage_rate = 1 / (3600 / MAIN_UPDATE_TIMER);
        } elsif (cit_temp < 510) {
            # Severe overheating - 5 minutes to failure
            damage_rate = 1 / (300 / MAIN_UPDATE_TIMER);
        } else {
            # Critical overheating - immediate damage
            damage_rate = 1 / (30 / MAIN_UPDATE_TIMER);
        }
        
        # Apply exponential damage for more realistic progression
        var temp_factor = (cit_temp - cit_max) / 100;
        damage_rate *= (1 + temp_factor * temp_factor);
        
        setprop(engine_damage[0], getprop(engine_damage[0]) + damage_rate);
        setprop(engine_damage[1], getprop(engine_damage[1]) + damage_rate);
        
        # Set warning lights
        setprop("/systems/sr71/cit-warning", 1);
    } else {
        setprop("/systems/sr71/cit-warning", 0);
    }
    
    # Engine failure management
    if (getprop(engine_damage[0]) >= 1) {
        setprop("/sim/failure-manager/engines/engine[0]/serviceable", 0);
        setprop("/systems/sr71/engine-0-failed", 1);
    }
    
    if (getprop(engine_damage[1]) >= 1) {
        setprop("/sim/failure-manager/engines/engine[1]/serviceable", 0);
        setprop("/systems/sr71/engine-1-failed", 1);
    }
    
    # Enhanced unstart conditions
    if (current_mach > 3.53) {
        # Probability-based unstart for realism
        var unstart_probability = (current_mach - 3.53) * 0.1;
        if (rand() < unstart_probability * MAIN_UPDATE_TIMER) {
            unstart();
            setprop("/systems/sr71/unstart-event", 1);
        }
    } else {
        setprop("/systems/sr71/unstart-event", 0);
    }
    
    # Inlet shock positioning and efficiency
    inlet_management();
    
    # Turbo-ramjet transition management
    turbo_ramjet_transition();
    
    settimer(func { main(); }, MAIN_UPDATE_TIMER);
}

# Enhanced unstart function with recovery procedures
var unstart = func() {
    setprop("/fdm/jsbsim/fcs/cutoff-switch0", 0);
    setprop("/fdm/jsbsim/fcs/cutoff-switch1", 0);
    setprop("/systems/sr71/engines-unstarted", 1);
    
    # Automatic restart attempt after unstart
    settimer(func {
        if (getprop(mach_path) < 3.2) {
            restart_engines();
        }
    }, 5.0);
}

# Engine restart procedure
var restart_engines = func() {
    var current_mach = getprop(mach_path);
    var current_altitude = getprop(altitude_path);
    
    # Only restart if conditions are suitable
    if (current_mach > 0.8 and current_mach < 3.2 and current_altitude > 20000) {
        setprop("/fdm/jsbsim/fcs/cutoff-switch0", 1);
        setprop("/fdm/jsbsim/fcs/cutoff-switch1", 1);
        setprop("/systems/sr71/engines-unstarted", 0);
    }
}

# Inlet spike management system
var inlet_management = func() {
    var current_mach = getprop(mach_path);
    var auto_mode = getprop("/systems/sr71/inlet-auto-mode");
    
    if (auto_mode) {
        var target_spike_pos = 0;
        var inlet_eff = 1.0;
        
        # Calculate optimal spike position based on Mach number
        if (current_mach < 1.0) {
            target_spike_pos = 0;      # Fully retracted
            inlet_eff = 0.95;
        } elsif (current_mach < 1.6) {
            target_spike_pos = 0.3;    # Partial extension
            inlet_eff = 0.92;
        } elsif (current_mach < 2.2) {
            target_spike_pos = 0.6;    # Extended
            inlet_eff = 0.88;
        } elsif (current_mach < 3.0) {
            target_spike_pos = 0.85;   # Nearly full extension
            inlet_eff = 0.85;
        } else {
            target_spike_pos = 1.0;    # Fully extended
            inlet_eff = 0.82;
        }
        
        # Smooth spike movement
        var current_pos_0 = getprop(inlet_spike_pos[0]);
        var current_pos_1 = getprop(inlet_spike_pos[1]);
        var move_rate = 0.1; # Movement rate per update
        
        # Move spikes gradually toward target
        if (abs(current_pos_0 - target_spike_pos) > 0.01) {
            var new_pos_0 = current_pos_0 + (target_spike_pos - current_pos_0) * move_rate;
            setprop(inlet_spike_pos[0], new_pos_0);
        }
        
        if (abs(current_pos_1 - target_spike_pos) > 0.01) {
            var new_pos_1 = current_pos_1 + (target_spike_pos - current_pos_1) * move_rate;
            setprop(inlet_spike_pos[1], new_pos_1);
        }
        
        # Set inlet efficiency
        setprop(inlet_efficiency[0], inlet_eff);
        setprop(inlet_efficiency[1], inlet_eff);
    }
}

# Turbo-ramjet transition system
var turbo_ramjet_transition = func() {
    var current_mach = getprop(mach_path);
    var current_altitude = getprop(altitude_path);
    
    # Transition occurs above Mach 2.2 as documented
    if (current_mach > 2.2 and current_altitude > 40000) {
        # Calculate bypass ratio based on Mach number
        var bypass_amount = math.min((current_mach - 2.2) / 1.0, 0.6); # Max 60% bypass
        
        setprop(bypass_ratio[0], bypass_amount);
        setprop(bypass_ratio[1], bypass_amount);
        setprop("/systems/sr71/turbo-ramjet-mode", 1);
        
        # Adjust engine efficiency for ramjet mode
        var ramjet_efficiency = 0.8 + (current_mach - 2.2) * 0.1;
        ramjet_efficiency = math.min(ramjet_efficiency, 1.2);
        
        setprop("/fdm/jsbsim/propulsion/engine[0]/ramjet-efficiency", ramjet_efficiency);
        setprop("/fdm/jsbsim/propulsion/engine[1]/ramjet-efficiency", ramjet_efficiency);
    } else {
        # Pure turbojet mode
        setprop(bypass_ratio[0], 0);
        setprop(bypass_ratio[1], 0);
        setprop("/systems/sr71/turbo-ramjet-mode", 0);
        setprop("/fdm/jsbsim/propulsion/engine[0]/ramjet-efficiency", 1.0);
        setprop("/fdm/jsbsim/propulsion/engine[1]/ramjet-efficiency", 1.0);
    }
}

# Fuel management system
var fuel_management = func() {
    var auto_sequence = getprop("/systems/sr71/fuel-auto-sequence");
    
    if (auto_sequence) {
        # Implement proper fuel sequencing as per SR-71 manual
        var tank_0_fuel = getprop(fuel_tanks[0]);
        var tank_1_fuel = getprop(fuel_tanks[1]);
        var tank_2_fuel = getprop(fuel_tanks[2]);
        
        # Center of gravity management through fuel transfer
        var total_fuel = tank_0_fuel + tank_1_fuel + tank_2_fuel;
        var current_mach = getprop(mach_path);
        
        # Adjust fuel distribution based on flight phase
        if (current_mach > 2.0) {
            # High-speed flight - move fuel aft for stability
            if (tank_0_fuel > tank_2_fuel + 1000) {
                # Transfer fuel from forward to aft tank
                setprop("/systems/sr71/fuel-transfer-active", 1);
            }
        } else {
            # Subsonic flight - balance fuel load
            setprop("/systems/sr71/fuel-transfer-active", 0);
        }
    }
}

# Climb-dive technique implementation
var climb_dive_procedure = func() {
    var climb_dive_mode = getprop("/systems/sr71/climb-dive-mode");
    var current_mach = getprop(mach_path);
    var current_altitude = getprop(altitude_path);
    var eas = getprop(eas_path);
    
    if (climb_dive_mode and current_mach > 0.9 and current_mach < 1.3) {
        # Implement the documented climb-dive transonic acceleration
        if (current_altitude > 32000 and current_altitude < 34000 and current_mach < 1.0) {
            # Initiate dive to 30,000 ft
            setprop("/systems/sr71/climb-dive-phase", "diving");
        } elsif (current_altitude < 31000 and eas < 450) {
            # Pull out and accelerate to 450 KEAS
            setprop("/systems/sr71/climb-dive-phase", "accelerating");
        } elsif (eas >= 450) {
            # Begin constant EAS climb
            setprop("/systems/sr71/climb-dive-phase", "climbing");
            setprop("/systems/sr71/climb-dive-mode", 0); # Complete procedure
        }
    }
}

# Slow update loop for non-critical systems
var slow_update = func() {
    fuel_management();
    climb_dive_procedure();
    
    settimer(func { slow_update(); }, SLOW_UPDATE_TIMER);
}

# Initialize all systems
main();
slow_update();