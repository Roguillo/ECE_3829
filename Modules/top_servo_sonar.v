`timescale 10ns / 10ps

module top_servo_sonar(
        input  wire       clk         , rst           , btnu_raw, btnd_raw, btnl_raw, btnr_raw, echo_raw,
        input  wire  [7:0]switches_raw,
        
        output wire       pwm_signal  , trigger_signal,
        output wire  [3:0]anode,
        output wire  [7:0]segments,
        output wire [15:0]LEDs
    );

    // interconnects
    wire       at_max;
    wire       at_min;
    wire       auto_mode;
    wire       auto_step_dir;
    wire       auto_step_one;
    wire       btnd_lvl;
    wire       btnd_pulse;
    wire       btnd_synced;
    wire       btnl_lvl;
    wire       btnl_pulse;
    wire       btnl_synced;
    wire       btnr_lvl;
    wire       btnr_pulse;
    wire       btnr_synced;
    wire       btnu_lvl;
    wire       btnu_pulse;
    wire       btnu_synced;
    wire       dir_reg;
    wire       display_tick;
    wire       echo_done;
    wire       echo_fall;
    wire       echo_lvl;
    wire       echo_rise;
    wire       echo_synced;
    wire       echo_tick;
    wire       flush;
    wire       ms_tick;
    wire       step_dir;
    wire       step_one;
    wire       toggle_pattern;
    wire       trigger_start;
    wire       update_newest_minimum;
    wire  [3:0]dig_0;
    wire  [3:0]dig_1;
    wire  [3:0]dig_2;
    wire  [7:0]angle;
    wire  [7:0]dig_0_s;
    wire  [7:0]dig_1_s;
    wire  [7:0]dig_2_s;
    wire  [7:0]switches_lvl;
    wire  [7:0]switches_synced;
    wire  [8:0]display_val;
    wire  [8:0]distance_val;
    wire  [8:0]newest_minimum;

    // --- Input ---
    // -- Manual --
    // -> Buttons
    // Button U
    synchronizer   synchronizer_btnu(
        .clk          (clk)        , .rst(rst), .ext_signal(btnu_raw),
        .synced_signal(btnu_synced)
    );
    
    debouncer         debouncer_btnu(
        .clk       (clk)     , .rst(rst), .signal_raw(btnu_synced), .ms_tick(ms_tick),
        .signal_lvl(btnu_lvl)
    );
    
    edge_detector edge_detector_btnu(
        .clk      (clk)       , .rst(rst)   , .signal_lvl(btnu_lvl),
        .edge_rise(btnu_pulse), .edge_fall()
    );
    
    // Button D
    synchronizer   synchronizer_btnd(
        .clk          (clk)        , .rst(rst), .ext_signal(btnd_raw),
        .synced_signal(btnd_synced)
    );
    
    debouncer         debouncer_btnd(
        .clk       (clk)     , .rst(rst), .signal_raw(btnd_synced), .ms_tick(ms_tick),
        .signal_lvl(btnd_lvl)
    );
    
    edge_detector edge_detector_btnd(
        .clk      (clk)       , .rst(rst)   , .signal_lvl(btnd_lvl),
        .edge_rise(btnd_pulse), .edge_fall()
    );
    
    // Button L
    synchronizer   synchronizer_btnl(
        .clk          (clk)        , .rst(rst), .ext_signal(btnl_raw),
        .synced_signal(btnl_synced)
    );
    
    debouncer         debouncer_btnl(
        .clk       (clk)     , .rst(rst), .signal_raw(btnl_synced), .ms_tick(ms_tick),
        .signal_lvl(btnl_lvl)
    );
    
    edge_detector edge_detector_btnl(
        .clk      (clk)       , .rst(rst)   , .signal_lvl(btnl_lvl),
        .edge_rise(btnl_pulse), .edge_fall()
    );
    
    // Button R
    synchronizer   synchronizer_btnr(
        .clk          (clk)        , .rst(rst), .ext_signal(btnr_raw),
        .synced_signal(btnr_synced)
    );
    
    debouncer         debouncer_btnr(
        .clk       (clk)     , .rst(rst), .signal_raw(btnr_synced), .ms_tick(ms_tick),
        .signal_lvl(btnr_lvl)
    );
    
    edge_detector edge_detector_btnr(
        .clk      (clk)       , .rst(rst)   , .signal_lvl(btnr_lvl),
        .edge_rise(btnr_pulse), .edge_fall()
    );
    
    // -> DIP Switches
    // S0
    synchronizer synchronizer_s0(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[0]),
        .synced_signal(switches_synced[0])
    );
    
    debouncer       debouncer_s0(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[0]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[0])
    );
    
    // S1
    synchronizer synchronizer_s1(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[1]),
        .synced_signal(switches_synced[1])
    );
    
    debouncer       debouncer_s1(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[1]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[1])
    );
    
    // S2
    synchronizer synchronizer_s2(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[2]),
        .synced_signal(switches_synced[2])
    );
    
    debouncer       debouncer_s2(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[2]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[2])
    );
    
    // S3
    synchronizer synchronizer_s3(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[3]),
        .synced_signal(switches_synced[3])
    );
    
    debouncer       debouncer_s3(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[3]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[3])
    );
    
    // S4
    synchronizer synchronizer_s4(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[4]),
        .synced_signal(switches_synced[4])
    );
    
    debouncer       debouncer_s4(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[4]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[4])
    );
    
    // S5
    synchronizer synchronizer_s5(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[5]),
        .synced_signal(switches_synced[5])
    );
    
    debouncer       debouncer_s5(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[5]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[5])
    );
    
    // S6
    synchronizer synchronizer_s6(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[6]),
        .synced_signal(switches_synced[6])
    );
    
    debouncer       debouncer_s6(
        .clk       (clk)            , .rst(rst), .signal_raw(switches_synced[6]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[6])
    );
    
    // S7
    synchronizer synchronizer_s7(
        .clk          (clk)               , .rst(rst), .ext_signal(switches_raw[7]),
        .synced_signal(switches_synced[7])
    );
    
    debouncer       debouncer_s7(
        .clk       (clk)           , .rst(rst), .signal_raw(switches_synced[7]), .ms_tick(ms_tick),
        .signal_lvl(switches_lvl[7])
    );
    
    // -- External --
    // -> Sensor Echo 
    synchronizer   synchronizer_echo(
        .clk          (clk)        , .rst(rst), .ext_signal(echo_raw),
        .synced_signal(echo_synced)
    );
    
    edge_detector edge_detector_echo(
        .clk      (clk)      , .rst      (rst)      , .signal_lvl(echo_synced),
        .edge_rise(echo_rise), .edge_fall(echo_fall)
    );
    
    // --- Inner Modules ---
    // -- Timing --
    tick_manager tick_manager0(
        .clk         (clk)         , .rst    (rst),
        .display_tick(display_tick), .ms_tick(ms_tick), .echo_tick(echo_tick)
    );
    
    // -- FSMs --
    mode_fsm   mode_fsm0(
        .clk      (clk)      , .rst           (rst)           , .btnu_press(btnu_pulse), .ms_tick(ms_tick),
        .auto_mode(auto_mode), .toggle_pattern(toggle_pattern)
    );
    
    cycle_fsm cycle_fsm0(
        .clk     (clk)          , .rst     (rst)          , .auto_mode  (auto_mode)    , .echo_done            (echo_done)            , .at_min        (at_min), .at_max(at_max), .ms_tick(ms_tick),
        .step_one(auto_step_one), .step_dir(auto_step_dir), .ping_sensor(trigger_start), .update_newest_minimum(update_newest_minimum), .actually_flush(flush)
    );
    
    // -- MUXes --
    step_mux       step_mux0(
        .auto_mode(auto_mode), .auto_step(auto_step_one), .auto_dir(auto_step_dir), .btnl_press(btnl_pulse), .btnr_press(btnr_pulse),
        .step_one (step_one) , .step_dir (step_dir)
    );
    
    display_mux display_mux0(
        .auto_mode  (auto_mode)  , .curr_distance(distance_val), .newest_minimum(newest_minimum),
        .display_val(display_val)
    );
    
    // -- Decoders --
    BCD_decoder         BCD_decoder0(
        .num_b(display_val),
        .dig_0(dig_0)      , .dig_1(dig_1), .dig_2(dig_2)
    );
    
    segment_decoder segment_decoder0(
        .nibble  (dig_0),
        .segments(dig_0_s)
    );
    
    segment_decoder segment_decoder1(
        .nibble  (dig_1),
        .segments(dig_1_s)
    );
    segment_decoder segment_decoder2(
        .nibble  (dig_2),
        .segments(dig_2_s)
    );
    
    // -- Registers --
    angle_register                   angle_register0(
        .clk   (clk)   , .rst   (rst)   , .load (btnd_pulse), .step_one(step_one), .step_dir(step_dir), .auto_mode(auto_mode), .value(switches_lvl),
        .at_min(at_min), .at_max(at_max), .dir_reg(dir_reg), .angle(angle)
    );
    
    newest_minimum_register newest_minimum_register0(
        .clk            (clk)           , .rst(rst), .flush(flush), .update(update_newest_minimum), .value(distance_val),
        .display_minimum(newest_minimum)
    );
    
    // echo and distance handling
    echo echo0(
        .clk (clk)      , .rst         (rst)       , .echo_rise(echo_rise), .echo_fall(echo_fall), .echo_tick(echo_tick),
        .done(echo_done), .distance_val(distance_val)
    );
        
    // --- Output ---
    led_mux               led_mux0(
        .auto_mode (auto_mode), .toggle_pattern(toggle_pattern), .dir(dir_reg), .angle(angle),
        .led_values(LEDs)
    );
    
    trigger               trigger0(
        .clk           (clk), .rst(rst), .start(trigger_start), .free_run_mode(~auto_mode),
        .trigger_signal(trigger_signal)
    );
    
    display_driver display_driver0(
        .clk  (clk)  , .rst     (rst)     , .display_tick(display_tick), .dig_0(dig_0_s), .dig_1(dig_1_s), .dig_2(dig_2_s),
        .anode(anode), .segments(segments)
    );
    
    pwm_generator   pwm_generator0(
        .clk       (clk)       , .rst(rst), .angle(angle),
        .pwm_signal(pwm_signal)
    );
endmodule
