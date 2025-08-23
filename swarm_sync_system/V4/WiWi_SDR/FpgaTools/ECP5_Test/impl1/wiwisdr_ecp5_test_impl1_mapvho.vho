
-- VHDL netlist produced by program ldbanno, Version Diamond (64-bit) 3.14.0.75.2

-- ldbanno -n VHDL -o wiwisdr_ecp5_test_impl1_mapvho.vho -w -neg -gui -msgset C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/promote.xml wiwisdr_ecp5_test_impl1_map.ncd 
-- Netlist created on Tue Dec 10 10:42:48 2024
-- Netlist written on Tue Dec 10 10:42:54 2024
-- Design is for device LFE5U-25F
-- Design is for package CABGA256
-- Design is for performance grade 6

-- entity sapiobuf
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sapiobuf is
    port (I: in Std_logic; PAD: out Std_logic);

    ATTRIBUTE Vital_Level0 OF sapiobuf : ENTITY IS TRUE;

  end sapiobuf;

  architecture Structure of sapiobuf is
  begin
    INST5: OB
      port map (I=>I, O=>PAD);
  end Structure;

-- entity fpga_ledB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity fpga_ledB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "fpga_ledB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_fpgaled	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; fpgaled: out Std_logic);

    ATTRIBUTE Vital_Level0 OF fpga_ledB : ENTITY IS TRUE;

  end fpga_ledB;

  architecture Structure of fpga_ledB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal fpgaled_out 	: std_logic := 'X';

    component sapiobuf
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    fpga_led_pad: sapiobuf
      port map (I=>PADDO_ipd, PAD=>fpgaled_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, fpgaled_out)
    VARIABLE fpgaled_zd         	: std_logic := 'X';
    VARIABLE fpgaled_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    fpgaled_zd 	:= fpgaled_out;

    VitalPathDelay01 (
      OutSignal => fpgaled, OutSignalName => "fpgaled", OutTemp => fpgaled_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_fpgaled,
                           PathCondition => TRUE)),
      GlitchData => fpgaled_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity gnd
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity gnd is
    port (PWR0: out Std_logic);

    ATTRIBUTE Vital_Level0 OF gnd : ENTITY IS TRUE;

  end gnd;

  architecture Structure of gnd is
  begin
    INST1: VLO
      port map (Z=>PWR0);
  end Structure;

-- entity fpga_neopixelB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity fpga_neopixelB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "fpga_neopixelB");

    port (fpganeopixel: out Std_logic);

    ATTRIBUTE Vital_Level0 OF fpga_neopixelB : ENTITY IS TRUE;

  end fpga_neopixelB;

  architecture Structure of fpga_neopixelB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal fpganeopixel_out 	: std_logic := 'X';

    signal GNDI: Std_logic;
    component sapiobuf
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
    component gnd
      port (PWR0: out Std_logic);
    end component;
  begin
    fpga_neopixel_pad: sapiobuf
      port map (I=>GNDI, PAD=>fpganeopixel_out);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
    END BLOCK;

    VitalBehavior : PROCESS (fpganeopixel_out)


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    fpganeopixel 	<= fpganeopixel_out;


    END PROCESS;

  end Structure;

-- entity sapiobuf0001
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sapiobuf0001 is
    port (I: in Std_logic; PAD: out Std_logic);

    ATTRIBUTE Vital_Level0 OF sapiobuf0001 : ENTITY IS TRUE;

  end sapiobuf0001;

  architecture Structure of sapiobuf0001 is
  begin
    INST1: OB
      port map (I=>I, O=>PAD);
  end Structure;

-- entity sdr_txclkB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sdr_txclkB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "sdr_txclkB");

    port (sdrtxclk: out Std_logic);

    ATTRIBUTE Vital_Level0 OF sdr_txclkB : ENTITY IS TRUE;

  end sdr_txclkB;

  architecture Structure of sdr_txclkB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal sdrtxclk_out 	: std_logic := 'X';

    signal GNDI: Std_logic;
    component gnd
      port (PWR0: out Std_logic);
    end component;
    component sapiobuf0001
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    sdr_txclk_pad: sapiobuf0001
      port map (I=>GNDI, PAD=>sdrtxclk_out);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
    END BLOCK;

    VitalBehavior : PROCESS (sdrtxclk_out)


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    sdrtxclk 	<= sdrtxclk_out;


    END PROCESS;

  end Structure;

-- entity sdr_txdataB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sdr_txdataB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "sdr_txdataB");

    port (sdrtxdata: out Std_logic);

    ATTRIBUTE Vital_Level0 OF sdr_txdataB : ENTITY IS TRUE;

  end sdr_txdataB;

  architecture Structure of sdr_txdataB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal sdrtxdata_out 	: std_logic := 'X';

    signal GNDI: Std_logic;
    component gnd
      port (PWR0: out Std_logic);
    end component;
    component sapiobuf0001
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    sdr_txdata_pad: sapiobuf0001
      port map (I=>GNDI, PAD=>sdrtxdata_out);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
    END BLOCK;

    VitalBehavior : PROCESS (sdrtxdata_out)


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    sdrtxdata 	<= sdrtxdata_out;


    END PROCESS;

  end Structure;

-- entity sapiobuf0002
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sapiobuf0002 is
    port (I: in Std_logic; PAD: out Std_logic);

    ATTRIBUTE Vital_Level0 OF sapiobuf0002 : ENTITY IS TRUE;

  end sapiobuf0002;

  architecture Structure of sapiobuf0002 is
  begin
    INST5: OB
      port map (I=>I, O=>PAD);
  end Structure;

-- entity spi1_sckB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi1_sckB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi1_sckB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi1sck	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi1sck: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi1_sckB : ENTITY IS TRUE;

  end spi1_sckB;

  architecture Structure of spi1_sckB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi1sck_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi1_sck_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi1sck_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi1sck_out)
    VARIABLE spi1sck_zd         	: std_logic := 'X';
    VARIABLE spi1sck_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi1sck_zd 	:= spi1sck_out;

    VitalPathDelay01 (
      OutSignal => spi1sck, OutSignalName => "spi1sck", OutTemp => spi1sck_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi1sck,
                           PathCondition => TRUE)),
      GlitchData => spi1sck_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi1_mosiB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi1_mosiB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi1_mosiB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi1mosi	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi1mosi: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi1_mosiB : ENTITY IS TRUE;

  end spi1_mosiB;

  architecture Structure of spi1_mosiB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi1mosi_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi1_mosi_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi1mosi_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi1mosi_out)
    VARIABLE spi1mosi_zd         	: std_logic := 'X';
    VARIABLE spi1mosi_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi1mosi_zd 	:= spi1mosi_out;

    VitalPathDelay01 (
      OutSignal => spi1mosi, OutSignalName => "spi1mosi", OutTemp => spi1mosi_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi1mosi,
                           PathCondition => TRUE)),
      GlitchData => spi1mosi_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi2_sckB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi2_sckB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi2_sckB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi2sck	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi2sck: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi2_sckB : ENTITY IS TRUE;

  end spi2_sckB;

  architecture Structure of spi2_sckB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi2sck_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi2_sck_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi2sck_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi2sck_out)
    VARIABLE spi2sck_zd         	: std_logic := 'X';
    VARIABLE spi2sck_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi2sck_zd 	:= spi2sck_out;

    VitalPathDelay01 (
      OutSignal => spi2sck, OutSignalName => "spi2sck", OutTemp => spi2sck_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi2sck,
                           PathCondition => TRUE)),
      GlitchData => spi2sck_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi2_mosiB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi2_mosiB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi2_mosiB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi2mosi	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi2mosi: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi2_mosiB : ENTITY IS TRUE;

  end spi2_mosiB;

  architecture Structure of spi2_mosiB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi2mosi_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi2_mosi_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi2mosi_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi2mosi_out)
    VARIABLE spi2mosi_zd         	: std_logic := 'X';
    VARIABLE spi2mosi_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi2mosi_zd 	:= spi2mosi_out;

    VitalPathDelay01 (
      OutSignal => spi2mosi, OutSignalName => "spi2mosi", OutTemp => spi2mosi_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi2mosi,
                           PathCondition => TRUE)),
      GlitchData => spi2mosi_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi3_sckB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi3_sckB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi3_sckB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi3sck	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi3sck: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi3_sckB : ENTITY IS TRUE;

  end spi3_sckB;

  architecture Structure of spi3_sckB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi3sck_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi3_sck_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi3sck_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi3sck_out)
    VARIABLE spi3sck_zd         	: std_logic := 'X';
    VARIABLE spi3sck_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi3sck_zd 	:= spi3sck_out;

    VitalPathDelay01 (
      OutSignal => spi3sck, OutSignalName => "spi3sck", OutTemp => spi3sck_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi3sck,
                           PathCondition => TRUE)),
      GlitchData => spi3sck_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi3_mosiB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi3_mosiB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi3_mosiB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi3mosi	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi3mosi: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi3_mosiB : ENTITY IS TRUE;

  end spi3_mosiB;

  architecture Structure of spi3_mosiB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi3mosi_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi3_mosi_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi3mosi_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi3mosi_out)
    VARIABLE spi3mosi_zd         	: std_logic := 'X';
    VARIABLE spi3mosi_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi3mosi_zd 	:= spi3mosi_out;

    VitalPathDelay01 (
      OutSignal => spi3mosi, OutSignalName => "spi3mosi", OutTemp => spi3mosi_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi3mosi,
                           PathCondition => TRUE)),
      GlitchData => spi3mosi_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi4_sckB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi4_sckB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi4_sckB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi4sck	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi4sck: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi4_sckB : ENTITY IS TRUE;

  end spi4_sckB;

  architecture Structure of spi4_sckB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi4sck_out 	: std_logic := 'X';

    component sapiobuf
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi4_sck_pad: sapiobuf
      port map (I=>PADDO_ipd, PAD=>spi4sck_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi4sck_out)
    VARIABLE spi4sck_zd         	: std_logic := 'X';
    VARIABLE spi4sck_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi4sck_zd 	:= spi4sck_out;

    VitalPathDelay01 (
      OutSignal => spi4sck, OutSignalName => "spi4sck", OutTemp => spi4sck_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi4sck,
                           PathCondition => TRUE)),
      GlitchData => spi4sck_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity spi4_mosiB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity spi4_mosiB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "spi4_mosiB";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_spi4mosi	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; spi4mosi: out Std_logic);

    ATTRIBUTE Vital_Level0 OF spi4_mosiB : ENTITY IS TRUE;

  end spi4_mosiB;

  architecture Structure of spi4_mosiB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal spi4mosi_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    spi4_mosi_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>spi4mosi_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, spi4mosi_out)
    VARIABLE spi4mosi_zd         	: std_logic := 'X';
    VARIABLE spi4mosi_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    spi4mosi_zd 	:= spi4mosi_out;

    VitalPathDelay01 (
      OutSignal => spi4mosi, OutSignalName => "spi4mosi", OutTemp => spi4mosi_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_spi4mosi,
                           PathCondition => TRUE)),
      GlitchData => spi4mosi_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity fpga_ufl_p7B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity fpga_ufl_p7B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "fpga_ufl_p7B";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_fpgauflp7	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; fpgauflp7: out Std_logic);

    ATTRIBUTE Vital_Level0 OF fpga_ufl_p7B : ENTITY IS TRUE;

  end fpga_ufl_p7B;

  architecture Structure of fpga_ufl_p7B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal fpgauflp7_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    fpga_ufl_p7_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>fpgauflp7_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, fpgauflp7_out)
    VARIABLE fpgauflp7_zd         	: std_logic := 'X';
    VARIABLE fpgauflp7_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    fpgauflp7_zd 	:= fpgauflp7_out;

    VitalPathDelay01 (
      OutSignal => fpgauflp7, OutSignalName => "fpgauflp7", OutTemp => fpgauflp7_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_fpgauflp7,
                           PathCondition => TRUE)),
      GlitchData => fpgauflp7_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity fpga_ufl_p8B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity fpga_ufl_p8B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "fpga_ufl_p8B";

      tipd_PADDO  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_PADDO_fpgauflp8	 : VitalDelayType01 := (0 ns, 0 ns));

    port (PADDO: in Std_logic; fpgauflp8: out Std_logic);

    ATTRIBUTE Vital_Level0 OF fpga_ufl_p8B : ENTITY IS TRUE;

  end fpga_ufl_p8B;

  architecture Structure of fpga_ufl_p8B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDO_ipd 	: std_logic := 'X';
    signal fpgauflp8_out 	: std_logic := 'X';

    component sapiobuf0002
      port (I: in Std_logic; PAD: out Std_logic);
    end component;
  begin
    fpga_ufl_p8_pad: sapiobuf0002
      port map (I=>PADDO_ipd, PAD=>fpgauflp8_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(PADDO_ipd, PADDO, tipd_PADDO);
    END BLOCK;

    VitalBehavior : PROCESS (PADDO_ipd, fpgauflp8_out)
    VARIABLE fpgauflp8_zd         	: std_logic := 'X';
    VARIABLE fpgauflp8_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    fpgauflp8_zd 	:= fpgauflp8_out;

    VitalPathDelay01 (
      OutSignal => fpgauflp8, OutSignalName => "fpgauflp8", OutTemp => fpgauflp8_zd,
      Paths      => (0 => (InputChangeTime => PADDO_ipd'last_event,
                           PathDelay => tpd_PADDO_fpgauflp8,
                           PathCondition => TRUE)),
      GlitchData => fpgauflp8_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity sapiobuf0003
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sapiobuf0003 is
    port (Z: out Std_logic; PAD: in Std_logic);

    ATTRIBUTE Vital_Level0 OF sapiobuf0003 : ENTITY IS TRUE;

  end sapiobuf0003;

  architecture Structure of sapiobuf0003 is
  begin
    INST1: IBPD
      port map (I=>PAD, O=>Z);
  end Structure;

-- entity dpll_clkout2B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity dpll_clkout2B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "dpll_clkout2B";

      tipd_dpllclkout2  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_dpllclkout2_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_dpllclkout2 	: VitalDelayType := 0 ns;
      tpw_dpllclkout2_posedge	: VitalDelayType := 0 ns;
      tpw_dpllclkout2_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; dpllclkout2: in Std_logic);

    ATTRIBUTE Vital_Level0 OF dpll_clkout2B : ENTITY IS TRUE;

  end dpll_clkout2B;

  architecture Structure of dpll_clkout2B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal dpllclkout2_ipd 	: std_logic := 'X';

    component sapiobuf0003
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    dpll_clkout2_pad: sapiobuf0003
      port map (Z=>PADDI_out, PAD=>dpllclkout2_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(dpllclkout2_ipd, dpllclkout2, tipd_dpllclkout2);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, dpllclkout2_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_dpllclkout2_dpllclkout2          	: x01 := '0';
    VARIABLE periodcheckinfo_dpllclkout2	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => dpllclkout2_ipd,
        TestSignalName => "dpllclkout2",
        Period => tperiod_dpllclkout2,
        PulseWidthHigh => tpw_dpllclkout2_posedge,
        PulseWidthLow => tpw_dpllclkout2_negedge,
        PeriodData => periodcheckinfo_dpllclkout2,
        Violation => tviol_dpllclkout2_dpllclkout2,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => dpllclkout2_ipd'last_event,
                           PathDelay => tpd_dpllclkout2_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity dpll_clkout0B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity dpll_clkout0B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "dpll_clkout0B";

      tipd_dpllclkout0  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_dpllclkout0_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_dpllclkout0 	: VitalDelayType := 0 ns;
      tpw_dpllclkout0_posedge	: VitalDelayType := 0 ns;
      tpw_dpllclkout0_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; dpllclkout0: in Std_logic);

    ATTRIBUTE Vital_Level0 OF dpll_clkout0B : ENTITY IS TRUE;

  end dpll_clkout0B;

  architecture Structure of dpll_clkout0B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal dpllclkout0_ipd 	: std_logic := 'X';

    component sapiobuf0003
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    dpll_clkout0_pad: sapiobuf0003
      port map (Z=>PADDI_out, PAD=>dpllclkout0_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(dpllclkout0_ipd, dpllclkout0, tipd_dpllclkout0);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, dpllclkout0_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_dpllclkout0_dpllclkout0          	: x01 := '0';
    VARIABLE periodcheckinfo_dpllclkout0	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => dpllclkout0_ipd,
        TestSignalName => "dpllclkout0",
        Period => tperiod_dpllclkout0,
        PulseWidthHigh => tpw_dpllclkout0_posedge,
        PulseWidthLow => tpw_dpllclkout0_negedge,
        PeriodData => periodcheckinfo_dpllclkout0,
        Violation => tviol_dpllclkout0_dpllclkout0,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => dpllclkout0_ipd'last_event,
                           PathDelay => tpd_dpllclkout0_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity sapiobuf0004
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sapiobuf0004 is
    port (Z: out Std_logic; PAD: in Std_logic);

    ATTRIBUTE Vital_Level0 OF sapiobuf0004 : ENTITY IS TRUE;

  end sapiobuf0004;

  architecture Structure of sapiobuf0004 is
  begin
    INST1: IB
      port map (I=>PAD, O=>Z);
  end Structure;

-- entity sdr_rx_wifiB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sdr_rx_wifiB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "sdr_rx_wifiB";

      tipd_sdrrxwifi  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_sdrrxwifi_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_sdrrxwifi 	: VitalDelayType := 0 ns;
      tpw_sdrrxwifi_posedge	: VitalDelayType := 0 ns;
      tpw_sdrrxwifi_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; sdrrxwifi: in Std_logic);

    ATTRIBUTE Vital_Level0 OF sdr_rx_wifiB : ENTITY IS TRUE;

  end sdr_rx_wifiB;

  architecture Structure of sdr_rx_wifiB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal sdrrxwifi_ipd 	: std_logic := 'X';

    component sapiobuf0004
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    sdr_rx_wifi_pad: sapiobuf0004
      port map (Z=>PADDI_out, PAD=>sdrrxwifi_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(sdrrxwifi_ipd, sdrrxwifi, tipd_sdrrxwifi);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, sdrrxwifi_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_sdrrxwifi_sdrrxwifi          	: x01 := '0';
    VARIABLE periodcheckinfo_sdrrxwifi	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => sdrrxwifi_ipd,
        TestSignalName => "sdrrxwifi",
        Period => tperiod_sdrrxwifi,
        PulseWidthHigh => tpw_sdrrxwifi_posedge,
        PulseWidthLow => tpw_sdrrxwifi_negedge,
        PeriodData => periodcheckinfo_sdrrxwifi,
        Violation => tviol_sdrrxwifi_sdrrxwifi,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => sdrrxwifi_ipd'last_event,
                           PathDelay => tpd_sdrrxwifi_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity sdr_rx_subgB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sdr_rx_subgB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "sdr_rx_subgB";

      tipd_sdrrxsubg  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_sdrrxsubg_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_sdrrxsubg 	: VitalDelayType := 0 ns;
      tpw_sdrrxsubg_posedge	: VitalDelayType := 0 ns;
      tpw_sdrrxsubg_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; sdrrxsubg: in Std_logic);

    ATTRIBUTE Vital_Level0 OF sdr_rx_subgB : ENTITY IS TRUE;

  end sdr_rx_subgB;

  architecture Structure of sdr_rx_subgB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal sdrrxsubg_ipd 	: std_logic := 'X';

    component sapiobuf0004
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    sdr_rx_subg_pad: sapiobuf0004
      port map (Z=>PADDI_out, PAD=>sdrrxsubg_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(sdrrxsubg_ipd, sdrrxsubg, tipd_sdrrxsubg);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, sdrrxsubg_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_sdrrxsubg_sdrrxsubg          	: x01 := '0';
    VARIABLE periodcheckinfo_sdrrxsubg	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => sdrrxsubg_ipd,
        TestSignalName => "sdrrxsubg",
        Period => tperiod_sdrrxsubg,
        PulseWidthHigh => tpw_sdrrxsubg_posedge,
        PulseWidthLow => tpw_sdrrxsubg_negedge,
        PeriodData => periodcheckinfo_sdrrxsubg,
        Violation => tviol_sdrrxsubg_sdrrxsubg,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => sdrrxsubg_ipd'last_event,
                           PathDelay => tpd_sdrrxsubg_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity sdr_rxclkB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity sdr_rxclkB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "sdr_rxclkB";

      tipd_sdrrxclk  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_sdrrxclk_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_sdrrxclk 	: VitalDelayType := 0 ns;
      tpw_sdrrxclk_posedge	: VitalDelayType := 0 ns;
      tpw_sdrrxclk_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; sdrrxclk: in Std_logic);

    ATTRIBUTE Vital_Level0 OF sdr_rxclkB : ENTITY IS TRUE;

  end sdr_rxclkB;

  architecture Structure of sdr_rxclkB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal sdrrxclk_ipd 	: std_logic := 'X';

    component sapiobuf0004
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    sdr_rxclk_pad: sapiobuf0004
      port map (Z=>PADDI_out, PAD=>sdrrxclk_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(sdrrxclk_ipd, sdrrxclk, tipd_sdrrxclk);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, sdrrxclk_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_sdrrxclk_sdrrxclk          	: x01 := '0';
    VARIABLE periodcheckinfo_sdrrxclk	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => sdrrxclk_ipd,
        TestSignalName => "sdrrxclk",
        Period => tperiod_sdrrxclk,
        PulseWidthHigh => tpw_sdrrxclk_posedge,
        PulseWidthLow => tpw_sdrrxclk_negedge,
        PeriodData => periodcheckinfo_sdrrxclk,
        Violation => tviol_sdrrxclk_sdrrxclk,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => sdrrxclk_ipd'last_event,
                           PathDelay => tpd_sdrrxclk_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity stm_fpga_spare1B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity stm_fpga_spare1B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "stm_fpga_spare1B";

      tipd_stmfpgaspare1  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_stmfpgaspare1_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_stmfpgaspare1 	: VitalDelayType := 0 ns;
      tpw_stmfpgaspare1_posedge	: VitalDelayType := 0 ns;
      tpw_stmfpgaspare1_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; stmfpgaspare1: in Std_logic);

    ATTRIBUTE Vital_Level0 OF stm_fpga_spare1B : ENTITY IS TRUE;

  end stm_fpga_spare1B;

  architecture Structure of stm_fpga_spare1B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal stmfpgaspare1_ipd 	: std_logic := 'X';

    component sapiobuf0003
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    stm_fpga_spare1_pad: sapiobuf0003
      port map (Z=>PADDI_out, PAD=>stmfpgaspare1_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(stmfpgaspare1_ipd, stmfpgaspare1, tipd_stmfpgaspare1);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, stmfpgaspare1_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_stmfpgaspare1_stmfpgaspare1          	: x01 := '0';
    VARIABLE periodcheckinfo_stmfpgaspare1	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => stmfpgaspare1_ipd,
        TestSignalName => "stmfpgaspare1",
        Period => tperiod_stmfpgaspare1,
        PulseWidthHigh => tpw_stmfpgaspare1_posedge,
        PulseWidthLow => tpw_stmfpgaspare1_negedge,
        PeriodData => periodcheckinfo_stmfpgaspare1,
        Violation => tviol_stmfpgaspare1_stmfpgaspare1,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => stmfpgaspare1_ipd'last_event,
                           PathDelay => tpd_stmfpgaspare1_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity stm_fpga_spare2B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity stm_fpga_spare2B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "stm_fpga_spare2B";

      tipd_stmfpgaspare2  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_stmfpgaspare2_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_stmfpgaspare2 	: VitalDelayType := 0 ns;
      tpw_stmfpgaspare2_posedge	: VitalDelayType := 0 ns;
      tpw_stmfpgaspare2_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; stmfpgaspare2: in Std_logic);

    ATTRIBUTE Vital_Level0 OF stm_fpga_spare2B : ENTITY IS TRUE;

  end stm_fpga_spare2B;

  architecture Structure of stm_fpga_spare2B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal stmfpgaspare2_ipd 	: std_logic := 'X';

    component sapiobuf0003
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    stm_fpga_spare2_pad: sapiobuf0003
      port map (Z=>PADDI_out, PAD=>stmfpgaspare2_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(stmfpgaspare2_ipd, stmfpgaspare2, tipd_stmfpgaspare2);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, stmfpgaspare2_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_stmfpgaspare2_stmfpgaspare2          	: x01 := '0';
    VARIABLE periodcheckinfo_stmfpgaspare2	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => stmfpgaspare2_ipd,
        TestSignalName => "stmfpgaspare2",
        Period => tperiod_stmfpgaspare2,
        PulseWidthHigh => tpw_stmfpgaspare2_posedge,
        PulseWidthLow => tpw_stmfpgaspare2_negedge,
        PeriodData => periodcheckinfo_stmfpgaspare2,
        Violation => tviol_stmfpgaspare2_stmfpgaspare2,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => stmfpgaspare2_ipd'last_event,
                           PathDelay => tpd_stmfpgaspare2_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity stm_fpga_spare5B
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity stm_fpga_spare5B is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "stm_fpga_spare5B";

      tipd_stmfpgaspare5  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_stmfpgaspare5_PADDI	 : VitalDelayType01 := (0 ns, 0 ns);
      tperiod_stmfpgaspare5 	: VitalDelayType := 0 ns;
      tpw_stmfpgaspare5_posedge	: VitalDelayType := 0 ns;
      tpw_stmfpgaspare5_negedge	: VitalDelayType := 0 ns);

    port (PADDI: out Std_logic; stmfpgaspare5: in Std_logic);

    ATTRIBUTE Vital_Level0 OF stm_fpga_spare5B : ENTITY IS TRUE;

  end stm_fpga_spare5B;

  architecture Structure of stm_fpga_spare5B is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal PADDI_out 	: std_logic := 'X';
    signal stmfpgaspare5_ipd 	: std_logic := 'X';

    component sapiobuf0003
      port (Z: out Std_logic; PAD: in Std_logic);
    end component;
  begin
    stm_fpga_spare5_pad: sapiobuf0003
      port map (Z=>PADDI_out, PAD=>stmfpgaspare5_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(stmfpgaspare5_ipd, stmfpgaspare5, tipd_stmfpgaspare5);
    END BLOCK;

    VitalBehavior : PROCESS (PADDI_out, stmfpgaspare5_ipd)
    VARIABLE PADDI_zd         	: std_logic := 'X';
    VARIABLE PADDI_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_stmfpgaspare5_stmfpgaspare5          	: x01 := '0';
    VARIABLE periodcheckinfo_stmfpgaspare5	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalPeriodPulseCheck (
        TestSignal => stmfpgaspare5_ipd,
        TestSignalName => "stmfpgaspare5",
        Period => tperiod_stmfpgaspare5,
        PulseWidthHigh => tpw_stmfpgaspare5_posedge,
        PulseWidthLow => tpw_stmfpgaspare5_negedge,
        PeriodData => periodcheckinfo_stmfpgaspare5,
        Violation => tviol_stmfpgaspare5_stmfpgaspare5,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    PADDI_zd 	:= PADDI_out;

    VitalPathDelay01 (
      OutSignal => PADDI, OutSignalName => "PADDI", OutTemp => PADDI_zd,
      Paths      => (0 => (InputChangeTime => stmfpgaspare5_ipd'last_event,
                           PathDelay => tpd_stmfpgaspare5_PADDI,
                           PathCondition => TRUE)),
      GlitchData => PADDI_GlitchData,
      Mode       => vitaltransport, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity EHXPLLLB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity EHXPLLLB is
    port (CLKI: in Std_logic; CLKFB: in Std_logic; PHASESEL1: in Std_logic; 
          PHASESEL0: in Std_logic; PHASEDIR: in Std_logic; 
          PHASESTEP: in Std_logic; PHASELOADREG: in Std_logic; 
          STDBY: in Std_logic; PLLWAKESYNC: in Std_logic; RST: in Std_logic; 
          ENCLKOP: in Std_logic; ENCLKOS: in Std_logic; ENCLKOS2: in Std_logic; 
          ENCLKOS3: in Std_logic; CLKOP: out Std_logic; CLKOS: out Std_logic; 
          CLKOS2: out Std_logic; CLKOS3: out Std_logic; LOCK: out Std_logic; 
          INTLOCK: out Std_logic; REFCLK: out Std_logic; 
          CLKINTFB: out Std_logic);



  end EHXPLLLB;

  architecture Structure of EHXPLLLB is
  begin
    INST10: EHXPLLL
      generic map (CLKFB_DIV => 8, CLKI_DIV => 1, CLKOP_CPHASE => 9, 
                   CLKOP_DIV => 10, CLKOP_ENABLE => "ENABLED", 
                   CLKOP_FPHASE => 0, CLKOP_TRIM_DELAY => 0, 
                   CLKOP_TRIM_POL => "FALLING", CLKOS2_CPHASE => 7, 
                   CLKOS2_DIV => 8, CLKOS2_ENABLE => "ENABLED", 
                   CLKOS2_FPHASE => 0, CLKOS3_CPHASE => 12, CLKOS3_DIV => 10, 
                   CLKOS3_ENABLE => "ENABLED", CLKOS3_FPHASE => 3, 
                   CLKOS_CPHASE => 3, CLKOS_DIV => 4, 
                   CLKOS_ENABLE => "ENABLED", CLKOS_FPHASE => 0, 
                   CLKOS_TRIM_DELAY => 0, CLKOS_TRIM_POL => "FALLING", 
                   DPHASE_SOURCE => "DISABLED", FEEDBK_PATH => "CLKOP", 
                   INTFB_WAKE => "DISABLED", INT_LOCK_STICKY => "ENABLED", 
                   OUTDIVIDER_MUXA => "DIVA", OUTDIVIDER_MUXB => "DIVB", 
                   OUTDIVIDER_MUXC => "DIVC", OUTDIVIDER_MUXD => "DIVD", 
                   PLLRST_ENA => "ENABLED", PLL_LOCK_DELAY => 200, 
                   PLL_LOCK_MODE => 0, REFIN_RESET => "DISABLED", 
                   STDBY_ENABLE => "DISABLED", SYNC_ENABLE => "DISABLED")
      port map (CLKI=>CLKI, CLKFB=>CLKFB, PHASESEL1=>PHASESEL1, 
                PHASESEL0=>PHASESEL0, PHASEDIR=>PHASEDIR, PHASESTEP=>PHASESTEP, 
                PHASELOADREG=>PHASELOADREG, STDBY=>STDBY, 
                PLLWAKESYNC=>PLLWAKESYNC, RST=>RST, ENCLKOP=>ENCLKOP, 
                ENCLKOS=>ENCLKOS, ENCLKOS2=>ENCLKOS2, ENCLKOS3=>ENCLKOS3, 
                CLKOP=>CLKOP, CLKOS=>CLKOS, CLKOS2=>CLKOS2, CLKOS3=>CLKOS3, 
                LOCK=>LOCK, INTLOCK=>INTLOCK, REFCLK=>REFCLK, 
                CLKINTFB=>CLKINTFB);
  end Structure;

-- entity my_pll_PLLInst_0
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity my_pll_PLLInst_0 is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "my_pll_PLLInst_0";

      tipd_CLKI  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CLKFB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_STDBY  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_RST  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKI_CLKOS2	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKI_CLKOS	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKI_CLKOP	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKFB_CLKOS2	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKFB_CLKOS	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKFB_CLKOP	 : VitalDelayType01 := (0 ns, 0 ns));

    port (CLKI: in Std_logic; CLKFB: in Std_logic; STDBY: in Std_logic; 
          RST: in Std_logic; LOCK: out Std_logic; CLKOS2: out Std_logic; 
          CLKOS: out Std_logic; CLKOP: out Std_logic);



  end my_pll_PLLInst_0;

  architecture Structure of my_pll_PLLInst_0 is
    signal CLKI_ipd 	: std_logic := 'X';
    signal CLKFB_ipd 	: std_logic := 'X';
    signal STDBY_ipd 	: std_logic := 'X';
    signal RST_ipd 	: std_logic := 'X';
    signal LOCK_out 	: std_logic := 'X';
    signal CLKOS2_out 	: std_logic := 'X';
    signal CLKOS_out 	: std_logic := 'X';
    signal CLKOP_out 	: std_logic := 'X';

    signal GNDI: Std_logic;
    component gnd
      port (PWR0: out Std_logic);
    end component;
    component EHXPLLLB
      port (CLKI: in Std_logic; CLKFB: in Std_logic; PHASESEL1: in Std_logic; 
            PHASESEL0: in Std_logic; PHASEDIR: in Std_logic; 
            PHASESTEP: in Std_logic; PHASELOADREG: in Std_logic; 
            STDBY: in Std_logic; PLLWAKESYNC: in Std_logic; RST: in Std_logic; 
            ENCLKOP: in Std_logic; ENCLKOS: in Std_logic; 
            ENCLKOS2: in Std_logic; ENCLKOS3: in Std_logic; 
            CLKOP: out Std_logic; CLKOS: out Std_logic; CLKOS2: out Std_logic; 
            CLKOS3: out Std_logic; LOCK: out Std_logic; INTLOCK: out Std_logic; 
            REFCLK: out Std_logic; CLKINTFB: out Std_logic);
    end component;
  begin
    my_pll_PLLInst_0_EHXPLLL: EHXPLLLB
      port map (CLKI=>CLKI_ipd, CLKFB=>CLKFB_ipd, PHASESEL1=>GNDI, 
                PHASESEL0=>GNDI, PHASEDIR=>GNDI, PHASESTEP=>GNDI, 
                PHASELOADREG=>GNDI, STDBY=>STDBY_ipd, PLLWAKESYNC=>GNDI, 
                RST=>RST_ipd, ENCLKOP=>GNDI, ENCLKOS=>GNDI, ENCLKOS2=>GNDI, 
                ENCLKOS3=>GNDI, CLKOP=>CLKOP_out, CLKOS=>CLKOS_out, 
                CLKOS2=>CLKOS2_out, CLKOS3=>open, LOCK=>LOCK_out, 
                INTLOCK=>open, REFCLK=>open, CLKINTFB=>open);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(CLKI_ipd, CLKI, tipd_CLKI);
      VitalWireDelay(CLKFB_ipd, CLKFB, tipd_CLKFB);
      VitalWireDelay(STDBY_ipd, STDBY, tipd_STDBY);
      VitalWireDelay(RST_ipd, RST, tipd_RST);
    END BLOCK;

    VitalBehavior : PROCESS (CLKI_ipd, CLKFB_ipd, STDBY_ipd, RST_ipd, LOCK_out, 
      CLKOS2_out, CLKOS_out, CLKOP_out)
    VARIABLE CLKOS2_zd         	: std_logic := 'X';
    VARIABLE CLKOS2_GlitchData 	: VitalGlitchDataType;
    VARIABLE CLKOS_zd         	: std_logic := 'X';
    VARIABLE CLKOS_GlitchData 	: VitalGlitchDataType;
    VARIABLE CLKOP_zd         	: std_logic := 'X';
    VARIABLE CLKOP_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    LOCK 	<= LOCK_out;
    CLKOS2_zd 	:= CLKOS2_out;
    CLKOS_zd 	:= CLKOS_out;
    CLKOP_zd 	:= CLKOP_out;

    VitalPathDelay01 (
      OutSignal => CLKOS2, OutSignalName => "CLKOS2", OutTemp => CLKOS2_zd,
      Paths      => (0 => (InputChangeTime => CLKI_ipd'last_event,
                           PathDelay => tpd_CLKI_CLKOS2,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => CLKFB_ipd'last_event,
                           PathDelay => tpd_CLKFB_CLKOS2,
                           PathCondition => TRUE)),
      GlitchData => CLKOS2_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);
    VitalPathDelay01 (
      OutSignal => CLKOS, OutSignalName => "CLKOS", OutTemp => CLKOS_zd,
      Paths      => (0 => (InputChangeTime => CLKI_ipd'last_event,
                           PathDelay => tpd_CLKI_CLKOS,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => CLKFB_ipd'last_event,
                           PathDelay => tpd_CLKFB_CLKOS,
                           PathCondition => TRUE)),
      GlitchData => CLKOS_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);
    VitalPathDelay01 (
      OutSignal => CLKOP, OutSignalName => "CLKOP", OutTemp => CLKOP_zd,
      Paths      => (0 => (InputChangeTime => CLKI_ipd'last_event,
                           PathDelay => tpd_CLKI_CLKOP,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => CLKFB_ipd'last_event,
                           PathDelay => tpd_CLKFB_CLKOP,
                           PathCondition => TRUE)),
      GlitchData => CLKOP_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity OSCGB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity OSCGB is
    port (OSC: out Std_logic);

    ATTRIBUTE Vital_Level0 OF OSCGB : ENTITY IS TRUE;

  end OSCGB;

  architecture Structure of OSCGB is
  begin
    INST10: OSCG
      generic map (DIV => 128)
      port map (OSC=>OSC);
  end Structure;

-- entity osch_inst
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity osch_inst is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "osch_inst");

    port (OSC: out Std_logic);

    ATTRIBUTE Vital_Level0 OF osch_inst : ENTITY IS TRUE;

  end osch_inst;

  architecture Structure of osch_inst is
    signal OSC_out 	: std_logic := 'X';

    component OSCGB
      port (OSC: out Std_logic);
    end component;
  begin
    osch_inst_OSCG: OSCGB
      port map (OSC=>OSC_out);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
    END BLOCK;

    VitalBehavior : PROCESS (OSC_out)


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    OSC 	<= OSC_out;


    END PROCESS;

  end Structure;

-- entity DP16KDB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity DP16KDB is
    port (CEA: in Std_logic; OCEA: in Std_logic; CLKA: in Std_logic; 
          WEA: in Std_logic; CSA0: in Std_logic; CSA1: in Std_logic; 
          CSA2: in Std_logic; RSTA: in Std_logic; CEB: in Std_logic; 
          OCEB: in Std_logic; CLKB: in Std_logic; WEB: in Std_logic; 
          CSB0: in Std_logic; CSB1: in Std_logic; CSB2: in Std_logic; 
          RSTB: in Std_logic; DIA0: in Std_logic; DIA1: in Std_logic; 
          DIA2: in Std_logic; DIA3: in Std_logic; DIA4: in Std_logic; 
          DIA5: in Std_logic; DIA6: in Std_logic; DIA7: in Std_logic; 
          DIA8: in Std_logic; DIA9: in Std_logic; DIA10: in Std_logic; 
          DIA11: in Std_logic; DIA12: in Std_logic; DIA13: in Std_logic; 
          DIA14: in Std_logic; DIA15: in Std_logic; DIA16: in Std_logic; 
          DIA17: in Std_logic; ADA0: in Std_logic; ADA1: in Std_logic; 
          ADA2: in Std_logic; ADA3: in Std_logic; ADA4: in Std_logic; 
          ADA5: in Std_logic; ADA6: in Std_logic; ADA7: in Std_logic; 
          ADA8: in Std_logic; ADA9: in Std_logic; ADA10: in Std_logic; 
          ADA11: in Std_logic; ADA12: in Std_logic; ADA13: in Std_logic; 
          DIB0: in Std_logic; DIB1: in Std_logic; DIB2: in Std_logic; 
          DIB3: in Std_logic; DIB4: in Std_logic; DIB5: in Std_logic; 
          DIB6: in Std_logic; DIB7: in Std_logic; DIB8: in Std_logic; 
          DIB9: in Std_logic; DIB10: in Std_logic; DIB11: in Std_logic; 
          DIB12: in Std_logic; DIB13: in Std_logic; DIB14: in Std_logic; 
          DIB15: in Std_logic; DIB16: in Std_logic; DIB17: in Std_logic; 
          ADB0: in Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
          ADB3: in Std_logic; ADB4: in Std_logic; ADB5: in Std_logic; 
          ADB6: in Std_logic; ADB7: in Std_logic; ADB8: in Std_logic; 
          ADB9: in Std_logic; ADB10: in Std_logic; ADB11: in Std_logic; 
          ADB12: in Std_logic; ADB13: in Std_logic; DOA0: out Std_logic; 
          DOA1: out Std_logic; DOA2: out Std_logic; DOA3: out Std_logic; 
          DOA4: out Std_logic; DOA5: out Std_logic; DOA6: out Std_logic; 
          DOA7: out Std_logic; DOA8: out Std_logic; DOA9: out Std_logic; 
          DOA10: out Std_logic; DOA11: out Std_logic; DOA12: out Std_logic; 
          DOA13: out Std_logic; DOA14: out Std_logic; DOA15: out Std_logic; 
          DOA16: out Std_logic; DOA17: out Std_logic; DOB0: out Std_logic; 
          DOB1: out Std_logic; DOB2: out Std_logic; DOB3: out Std_logic; 
          DOB4: out Std_logic; DOB5: out Std_logic; DOB6: out Std_logic; 
          DOB7: out Std_logic; DOB8: out Std_logic; DOB9: out Std_logic; 
          DOB10: out Std_logic; DOB11: out Std_logic; DOB12: out Std_logic; 
          DOB13: out Std_logic; DOB14: out Std_logic; DOB15: out Std_logic; 
          DOB16: out Std_logic; DOB17: out Std_logic);

    ATTRIBUTE Vital_Level0 OF DP16KDB : ENTITY IS TRUE;

  end DP16KDB;

  architecture Structure of DP16KDB is
  begin
    INST10: DP16KD
      generic map (ASYNC_RESET_RELEASE => "SYNC", CSDECODE_A => "0b000", 
                   CSDECODE_B => "0b000", DATA_WIDTH_A => 2, DATA_WIDTH_B => 2, 
                   GSR => "ENABLED", 
                   INITVAL_00 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_01 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_02 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_03 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_04 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_05 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_06 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_07 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_08 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_09 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_10 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_11 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_12 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_13 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_14 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_15 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_16 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_17 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_18 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_19 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_20 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_21 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_22 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_23 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_24 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_25 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_26 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_27 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_28 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_29 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_30 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_31 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_32 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_33 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_34 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_35 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_36 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_37 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_38 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_39 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , INIT_DATA => "STATIC", REGMODE_A => "NOREG", 
                   REGMODE_B => "NOREG", RESETMODE => "ASYNC", 
                   WRITEMODE_A => "NORMAL", WRITEMODE_B => "NORMAL")
      port map (DIA0=>DIA0, DIA1=>DIA1, DIA2=>DIA2, DIA3=>DIA3, DIA4=>DIA4, 
                DIA5=>DIA5, DIA6=>DIA6, DIA7=>DIA7, DIA8=>DIA8, DIA9=>DIA9, 
                DIA10=>DIA10, DIA11=>DIA11, DIA12=>DIA12, DIA13=>DIA13, 
                DIA14=>DIA14, DIA15=>DIA15, DIA16=>DIA16, DIA17=>DIA17, 
                ADA0=>ADA0, ADA1=>ADA1, ADA2=>ADA2, ADA3=>ADA3, ADA4=>ADA4, 
                ADA5=>ADA5, ADA6=>ADA6, ADA7=>ADA7, ADA8=>ADA8, ADA9=>ADA9, 
                ADA10=>ADA10, ADA11=>ADA11, ADA12=>ADA12, ADA13=>ADA13, 
                CEA=>CEA, OCEA=>OCEA, CLKA=>CLKA, WEA=>WEA, CSA0=>CSA0, 
                CSA1=>CSA1, CSA2=>CSA2, RSTA=>RSTA, DIB0=>DIB0, DIB1=>DIB1, 
                DIB2=>DIB2, DIB3=>DIB3, DIB4=>DIB4, DIB5=>DIB5, DIB6=>DIB6, 
                DIB7=>DIB7, DIB8=>DIB8, DIB9=>DIB9, DIB10=>DIB10, DIB11=>DIB11, 
                DIB12=>DIB12, DIB13=>DIB13, DIB14=>DIB14, DIB15=>DIB15, 
                DIB16=>DIB16, DIB17=>DIB17, ADB0=>ADB0, ADB1=>ADB1, ADB2=>ADB2, 
                ADB3=>ADB3, ADB4=>ADB4, ADB5=>ADB5, ADB6=>ADB6, ADB7=>ADB7, 
                ADB8=>ADB8, ADB9=>ADB9, ADB10=>ADB10, ADB11=>ADB11, 
                ADB12=>ADB12, ADB13=>ADB13, CEB=>CEB, OCEB=>OCEB, CLKB=>CLKB, 
                WEB=>WEB, CSB0=>CSB0, CSB1=>CSB1, CSB2=>CSB2, RSTB=>RSTB, 
                DOA0=>DOA0, DOA1=>DOA1, DOA2=>DOA2, DOA3=>DOA3, DOA4=>DOA4, 
                DOA5=>DOA5, DOA6=>DOA6, DOA7=>DOA7, DOA8=>DOA8, DOA9=>DOA9, 
                DOA10=>DOA10, DOA11=>DOA11, DOA12=>DOA12, DOA13=>DOA13, 
                DOA14=>DOA14, DOA15=>DOA15, DOA16=>DOA16, DOA17=>DOA17, 
                DOB0=>DOB0, DOB1=>DOB1, DOB2=>DOB2, DOB3=>DOB3, DOB4=>DOB4, 
                DOB5=>DOB5, DOB6=>DOB6, DOB7=>DOB7, DOB8=>DOB8, DOB9=>DOB9, 
                DOB10=>DOB10, DOB11=>DOB11, DOB12=>DOB12, DOB13=>DOB13, 
                DOB14=>DOB14, DOB15=>DOB15, DOB16=>DOB16, DOB17=>DOB17);
  end Structure;

-- entity vcc
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity vcc is
    port (PWR1: out Std_logic);

    ATTRIBUTE Vital_Level0 OF vcc : ENTITY IS TRUE;

  end vcc;

  architecture Structure of vcc is
  begin
    INST1: VHI
      port map (Z=>PWR1);
  end Structure;

-- entity subg_iddr_fifo_inst_pdp_ram_0_0_0
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity subg_iddr_fifo_inst_pdp_ram_0_0_0 is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "subg_iddr_fifo_inst_pdp_ram_0_0_0";

      tipd_DIA1  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_DIA0  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA4  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA3  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA2  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA1  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CEA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_OCEA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_RSTA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CLKA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CLKB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_RSTB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_OCEB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CEB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB1  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB2  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB3  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB4  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKB_DOB0	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKB_DOB1	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_RSTB_DOB0	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_RSTB_DOB1	 : VitalDelayType01 := (0 ns, 0 ns);
      ticd_CLKA	: VitalDelayType := 0 ns;
      tisd_DIA1_CLKA	: VitalDelayType := 0 ns;
      tsetup_DIA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_DIA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_DIA0_CLKA	: VitalDelayType := 0 ns;
      tsetup_DIA0_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_DIA0_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA4_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA4_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA4_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA3_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA3_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA3_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA2_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA2_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA2_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA1_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_CEA_CLKA	: VitalDelayType := 0 ns;
      tsetup_CEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_CEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_OCEA_CLKA	: VitalDelayType := 0 ns;
      tsetup_OCEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_OCEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_RSTA_CLKA	: VitalDelayType := 0 ns;
      tsetup_RSTA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_RSTA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      ticd_CLKB	: VitalDelayType := 0 ns;
      tisd_RSTB_CLKB	: VitalDelayType := 0 ns;
      tsetup_RSTB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_RSTB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_OCEB_CLKB	: VitalDelayType := 0 ns;
      tsetup_OCEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_OCEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_CEB_CLKB	: VitalDelayType := 0 ns;
      tsetup_CEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_CEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB1_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB1_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB1_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB2_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB2_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB2_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB3_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB3_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB3_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB4_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB4_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB4_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tperiod_CLKA 	: VitalDelayType := 0 ns;
      tpw_CLKA_posedge	: VitalDelayType := 0 ns;
      tpw_CLKA_negedge	: VitalDelayType := 0 ns;
      tperiod_CLKB 	: VitalDelayType := 0 ns;
      tpw_CLKB_posedge	: VitalDelayType := 0 ns;
      tpw_CLKB_negedge	: VitalDelayType := 0 ns);

    port (DIA1: in Std_logic; DIA0: in Std_logic; ADA4: in Std_logic; 
          ADA3: in Std_logic; ADA2: in Std_logic; ADA1: in Std_logic; 
          CEA: in Std_logic; OCEA: in Std_logic; RSTA: in Std_logic; 
          CLKA: in Std_logic; CLKB: in Std_logic; RSTB: in Std_logic; 
          OCEB: in Std_logic; CEB: in Std_logic; DOB0: out Std_logic; 
          DOB1: out Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
          ADB3: in Std_logic; ADB4: in Std_logic);

    ATTRIBUTE Vital_Level0 OF subg_iddr_fifo_inst_pdp_ram_0_0_0 : ENTITY IS TRUE;

  end subg_iddr_fifo_inst_pdp_ram_0_0_0;

  architecture Structure of subg_iddr_fifo_inst_pdp_ram_0_0_0 is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal DIA1_ipd 	: std_logic := 'X';
    signal DIA1_dly 	: std_logic := 'X';
    signal DIA0_ipd 	: std_logic := 'X';
    signal DIA0_dly 	: std_logic := 'X';
    signal ADA4_ipd 	: std_logic := 'X';
    signal ADA4_dly 	: std_logic := 'X';
    signal ADA3_ipd 	: std_logic := 'X';
    signal ADA3_dly 	: std_logic := 'X';
    signal ADA2_ipd 	: std_logic := 'X';
    signal ADA2_dly 	: std_logic := 'X';
    signal ADA1_ipd 	: std_logic := 'X';
    signal ADA1_dly 	: std_logic := 'X';
    signal CEA_ipd 	: std_logic := 'X';
    signal CEA_dly 	: std_logic := 'X';
    signal OCEA_ipd 	: std_logic := 'X';
    signal OCEA_dly 	: std_logic := 'X';
    signal RSTA_ipd 	: std_logic := 'X';
    signal RSTA_dly 	: std_logic := 'X';
    signal CLKA_ipd 	: std_logic := 'X';
    signal CLKA_dly 	: std_logic := 'X';
    signal CLKB_ipd 	: std_logic := 'X';
    signal CLKB_dly 	: std_logic := 'X';
    signal RSTB_ipd 	: std_logic := 'X';
    signal RSTB_dly 	: std_logic := 'X';
    signal OCEB_ipd 	: std_logic := 'X';
    signal OCEB_dly 	: std_logic := 'X';
    signal CEB_ipd 	: std_logic := 'X';
    signal CEB_dly 	: std_logic := 'X';
    signal DOB0_out 	: std_logic := 'X';
    signal DOB1_out 	: std_logic := 'X';
    signal ADB1_ipd 	: std_logic := 'X';
    signal ADB1_dly 	: std_logic := 'X';
    signal ADB2_ipd 	: std_logic := 'X';
    signal ADB2_dly 	: std_logic := 'X';
    signal ADB3_ipd 	: std_logic := 'X';
    signal ADB3_dly 	: std_logic := 'X';
    signal ADB4_ipd 	: std_logic := 'X';
    signal ADB4_dly 	: std_logic := 'X';

    signal VCCI: Std_logic;
    signal GNDI: Std_logic;
    component gnd
      port (PWR0: out Std_logic);
    end component;
    component DP16KDB
      port (CEA: in Std_logic; OCEA: in Std_logic; CLKA: in Std_logic; 
            WEA: in Std_logic; CSA0: in Std_logic; CSA1: in Std_logic; 
            CSA2: in Std_logic; RSTA: in Std_logic; CEB: in Std_logic; 
            OCEB: in Std_logic; CLKB: in Std_logic; WEB: in Std_logic; 
            CSB0: in Std_logic; CSB1: in Std_logic; CSB2: in Std_logic; 
            RSTB: in Std_logic; DIA0: in Std_logic; DIA1: in Std_logic; 
            DIA2: in Std_logic; DIA3: in Std_logic; DIA4: in Std_logic; 
            DIA5: in Std_logic; DIA6: in Std_logic; DIA7: in Std_logic; 
            DIA8: in Std_logic; DIA9: in Std_logic; DIA10: in Std_logic; 
            DIA11: in Std_logic; DIA12: in Std_logic; DIA13: in Std_logic; 
            DIA14: in Std_logic; DIA15: in Std_logic; DIA16: in Std_logic; 
            DIA17: in Std_logic; ADA0: in Std_logic; ADA1: in Std_logic; 
            ADA2: in Std_logic; ADA3: in Std_logic; ADA4: in Std_logic; 
            ADA5: in Std_logic; ADA6: in Std_logic; ADA7: in Std_logic; 
            ADA8: in Std_logic; ADA9: in Std_logic; ADA10: in Std_logic; 
            ADA11: in Std_logic; ADA12: in Std_logic; ADA13: in Std_logic; 
            DIB0: in Std_logic; DIB1: in Std_logic; DIB2: in Std_logic; 
            DIB3: in Std_logic; DIB4: in Std_logic; DIB5: in Std_logic; 
            DIB6: in Std_logic; DIB7: in Std_logic; DIB8: in Std_logic; 
            DIB9: in Std_logic; DIB10: in Std_logic; DIB11: in Std_logic; 
            DIB12: in Std_logic; DIB13: in Std_logic; DIB14: in Std_logic; 
            DIB15: in Std_logic; DIB16: in Std_logic; DIB17: in Std_logic; 
            ADB0: in Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
            ADB3: in Std_logic; ADB4: in Std_logic; ADB5: in Std_logic; 
            ADB6: in Std_logic; ADB7: in Std_logic; ADB8: in Std_logic; 
            ADB9: in Std_logic; ADB10: in Std_logic; ADB11: in Std_logic; 
            ADB12: in Std_logic; ADB13: in Std_logic; DOA0: out Std_logic; 
            DOA1: out Std_logic; DOA2: out Std_logic; DOA3: out Std_logic; 
            DOA4: out Std_logic; DOA5: out Std_logic; DOA6: out Std_logic; 
            DOA7: out Std_logic; DOA8: out Std_logic; DOA9: out Std_logic; 
            DOA10: out Std_logic; DOA11: out Std_logic; DOA12: out Std_logic; 
            DOA13: out Std_logic; DOA14: out Std_logic; DOA15: out Std_logic; 
            DOA16: out Std_logic; DOA17: out Std_logic; DOB0: out Std_logic; 
            DOB1: out Std_logic; DOB2: out Std_logic; DOB3: out Std_logic; 
            DOB4: out Std_logic; DOB5: out Std_logic; DOB6: out Std_logic; 
            DOB7: out Std_logic; DOB8: out Std_logic; DOB9: out Std_logic; 
            DOB10: out Std_logic; DOB11: out Std_logic; DOB12: out Std_logic; 
            DOB13: out Std_logic; DOB14: out Std_logic; DOB15: out Std_logic; 
            DOB16: out Std_logic; DOB17: out Std_logic);
    end component;
    component vcc
      port (PWR1: out Std_logic);
    end component;
  begin
    subg_iddr_fifo_inst_pdp_ram_0_0_0_DP16KD: DP16KDB
      port map (CEA=>CEA_dly, OCEA=>OCEA_dly, CLKA=>CLKA_dly, WEA=>VCCI, 
                CSA0=>GNDI, CSA1=>GNDI, CSA2=>GNDI, RSTA=>RSTA_dly, 
                CEB=>CEB_dly, OCEB=>OCEB_dly, CLKB=>CLKB_dly, WEB=>GNDI, 
                CSB0=>GNDI, CSB1=>GNDI, CSB2=>GNDI, RSTB=>RSTB_dly, 
                DIA0=>DIA0_dly, DIA1=>DIA1_dly, DIA2=>'X', DIA3=>'X', 
                DIA4=>'X', DIA5=>'X', DIA6=>'X', DIA7=>'X', DIA8=>'X', 
                DIA9=>'X', DIA10=>'X', DIA11=>'X', DIA12=>'X', DIA13=>'X', 
                DIA14=>'X', DIA15=>'X', DIA16=>'X', DIA17=>'X', ADA0=>GNDI, 
                ADA1=>ADA1_dly, ADA2=>ADA2_dly, ADA3=>ADA3_dly, ADA4=>ADA4_dly, 
                ADA5=>GNDI, ADA6=>GNDI, ADA7=>GNDI, ADA8=>GNDI, ADA9=>GNDI, 
                ADA10=>GNDI, ADA11=>GNDI, ADA12=>GNDI, ADA13=>GNDI, DIB0=>GNDI, 
                DIB1=>GNDI, DIB2=>'X', DIB3=>'X', DIB4=>'X', DIB5=>'X', 
                DIB6=>'X', DIB7=>'X', DIB8=>'X', DIB9=>'X', DIB10=>'X', 
                DIB11=>'X', DIB12=>'X', DIB13=>'X', DIB14=>'X', DIB15=>'X', 
                DIB16=>'X', DIB17=>'X', ADB0=>GNDI, ADB1=>ADB1_dly, 
                ADB2=>ADB2_dly, ADB3=>ADB3_dly, ADB4=>ADB4_dly, ADB5=>GNDI, 
                ADB6=>GNDI, ADB7=>GNDI, ADB8=>GNDI, ADB9=>GNDI, ADB10=>GNDI, 
                ADB11=>GNDI, ADB12=>GNDI, ADB13=>GNDI, DOA0=>open, DOA1=>open, 
                DOA2=>open, DOA3=>open, DOA4=>open, DOA5=>open, DOA6=>open, 
                DOA7=>open, DOA8=>open, DOA9=>open, DOA10=>open, DOA11=>open, 
                DOA12=>open, DOA13=>open, DOA14=>open, DOA15=>open, 
                DOA16=>open, DOA17=>open, DOB0=>DOB0_out, DOB1=>DOB1_out, 
                DOB2=>open, DOB3=>open, DOB4=>open, DOB5=>open, DOB6=>open, 
                DOB7=>open, DOB8=>open, DOB9=>open, DOB10=>open, DOB11=>open, 
                DOB12=>open, DOB13=>open, DOB14=>open, DOB15=>open, 
                DOB16=>open, DOB17=>open);
    DRIVEVCC: vcc
      port map (PWR1=>VCCI);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(DIA1_ipd, DIA1, tipd_DIA1);
      VitalWireDelay(DIA0_ipd, DIA0, tipd_DIA0);
      VitalWireDelay(ADA4_ipd, ADA4, tipd_ADA4);
      VitalWireDelay(ADA3_ipd, ADA3, tipd_ADA3);
      VitalWireDelay(ADA2_ipd, ADA2, tipd_ADA2);
      VitalWireDelay(ADA1_ipd, ADA1, tipd_ADA1);
      VitalWireDelay(CEA_ipd, CEA, tipd_CEA);
      VitalWireDelay(OCEA_ipd, OCEA, tipd_OCEA);
      VitalWireDelay(RSTA_ipd, RSTA, tipd_RSTA);
      VitalWireDelay(CLKA_ipd, CLKA, tipd_CLKA);
      VitalWireDelay(CLKB_ipd, CLKB, tipd_CLKB);
      VitalWireDelay(RSTB_ipd, RSTB, tipd_RSTB);
      VitalWireDelay(OCEB_ipd, OCEB, tipd_OCEB);
      VitalWireDelay(CEB_ipd, CEB, tipd_CEB);
      VitalWireDelay(ADB1_ipd, ADB1, tipd_ADB1);
      VitalWireDelay(ADB2_ipd, ADB2, tipd_ADB2);
      VitalWireDelay(ADB3_ipd, ADB3, tipd_ADB3);
      VitalWireDelay(ADB4_ipd, ADB4, tipd_ADB4);
    END BLOCK;

    --  Setup and Hold DELAYs
    SignalDelay : BLOCK
    BEGIN
      VitalSignalDelay(DIA1_dly, DIA1_ipd, tisd_DIA1_CLKA);
      VitalSignalDelay(DIA0_dly, DIA0_ipd, tisd_DIA0_CLKA);
      VitalSignalDelay(ADA4_dly, ADA4_ipd, tisd_ADA4_CLKA);
      VitalSignalDelay(ADA3_dly, ADA3_ipd, tisd_ADA3_CLKA);
      VitalSignalDelay(ADA2_dly, ADA2_ipd, tisd_ADA2_CLKA);
      VitalSignalDelay(ADA1_dly, ADA1_ipd, tisd_ADA1_CLKA);
      VitalSignalDelay(CEA_dly, CEA_ipd, tisd_CEA_CLKA);
      VitalSignalDelay(OCEA_dly, OCEA_ipd, tisd_OCEA_CLKA);
      VitalSignalDelay(RSTA_dly, RSTA_ipd, tisd_RSTA_CLKA);
      VitalSignalDelay(CLKA_dly, CLKA_ipd, ticd_CLKA);
      VitalSignalDelay(CLKB_dly, CLKB_ipd, ticd_CLKB);
      VitalSignalDelay(RSTB_dly, RSTB_ipd, tisd_RSTB_CLKB);
      VitalSignalDelay(OCEB_dly, OCEB_ipd, tisd_OCEB_CLKB);
      VitalSignalDelay(CEB_dly, CEB_ipd, tisd_CEB_CLKB);
      VitalSignalDelay(ADB1_dly, ADB1_ipd, tisd_ADB1_CLKB);
      VitalSignalDelay(ADB2_dly, ADB2_ipd, tisd_ADB2_CLKB);
      VitalSignalDelay(ADB3_dly, ADB3_ipd, tisd_ADB3_CLKB);
      VitalSignalDelay(ADB4_dly, ADB4_ipd, tisd_ADB4_CLKB);
    END BLOCK;

    VitalBehavior : PROCESS (DIA1_dly, DIA0_dly, ADA4_dly, ADA3_dly, ADA2_dly, 
      ADA1_dly, CEA_dly, OCEA_dly, RSTA_dly, CLKA_dly, CLKB_dly, RSTB_dly, 
      OCEB_dly, CEB_dly, DOB0_out, DOB1_out, ADB1_dly, ADB2_dly, ADB3_dly, 
      ADB4_dly)
    VARIABLE DOB0_zd         	: std_logic := 'X';
    VARIABLE DOB0_GlitchData 	: VitalGlitchDataType;
    VARIABLE DOB1_zd         	: std_logic := 'X';
    VARIABLE DOB1_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_DIA1_CLKA       	: x01 := '0';
    VARIABLE DIA1_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_DIA0_CLKA       	: x01 := '0';
    VARIABLE DIA0_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA4_CLKA       	: x01 := '0';
    VARIABLE ADA4_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA3_CLKA       	: x01 := '0';
    VARIABLE ADA3_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA2_CLKA       	: x01 := '0';
    VARIABLE ADA2_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA1_CLKA       	: x01 := '0';
    VARIABLE ADA1_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_CEA_CLKA       	: x01 := '0';
    VARIABLE CEA_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_OCEA_CLKA       	: x01 := '0';
    VARIABLE OCEA_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_RSTA_CLKA       	: x01 := '0';
    VARIABLE RSTA_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_RSTB_CLKB       	: x01 := '0';
    VARIABLE RSTB_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_OCEB_CLKB       	: x01 := '0';
    VARIABLE OCEB_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_CEB_CLKB       	: x01 := '0';
    VARIABLE CEB_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB1_CLKB       	: x01 := '0';
    VARIABLE ADB1_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB2_CLKB       	: x01 := '0';
    VARIABLE ADB2_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB3_CLKB       	: x01 := '0';
    VARIABLE ADB3_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB4_CLKB       	: x01 := '0';
    VARIABLE ADB4_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_CLKA_CLKA          	: x01 := '0';
    VARIABLE periodcheckinfo_CLKA	: VitalPeriodDataType;
    VARIABLE tviol_CLKB_CLKB          	: x01 := '0';
    VARIABLE periodcheckinfo_CLKB	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalSetupHoldCheck (
        TestSignal => DIA1_dly,
        TestSignalName => "DIA1",
        TestDelay => tisd_DIA1_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_DIA1_CLKA_noedge_posedge,
        SetupLow => tsetup_DIA1_CLKA_noedge_posedge,
        HoldHigh => thold_DIA1_CLKA_noedge_posedge,
        HoldLow => thold_DIA1_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => DIA1_CLKA_TimingDatash,
        Violation => tviol_DIA1_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => DIA0_dly,
        TestSignalName => "DIA0",
        TestDelay => tisd_DIA0_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_DIA0_CLKA_noedge_posedge,
        SetupLow => tsetup_DIA0_CLKA_noedge_posedge,
        HoldHigh => thold_DIA0_CLKA_noedge_posedge,
        HoldLow => thold_DIA0_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => DIA0_CLKA_TimingDatash,
        Violation => tviol_DIA0_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA4_dly,
        TestSignalName => "ADA4",
        TestDelay => tisd_ADA4_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA4_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA4_CLKA_noedge_posedge,
        HoldHigh => thold_ADA4_CLKA_noedge_posedge,
        HoldLow => thold_ADA4_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA4_CLKA_TimingDatash,
        Violation => tviol_ADA4_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA3_dly,
        TestSignalName => "ADA3",
        TestDelay => tisd_ADA3_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA3_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA3_CLKA_noedge_posedge,
        HoldHigh => thold_ADA3_CLKA_noedge_posedge,
        HoldLow => thold_ADA3_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA3_CLKA_TimingDatash,
        Violation => tviol_ADA3_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA2_dly,
        TestSignalName => "ADA2",
        TestDelay => tisd_ADA2_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA2_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA2_CLKA_noedge_posedge,
        HoldHigh => thold_ADA2_CLKA_noedge_posedge,
        HoldLow => thold_ADA2_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA2_CLKA_TimingDatash,
        Violation => tviol_ADA2_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA1_dly,
        TestSignalName => "ADA1",
        TestDelay => tisd_ADA1_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA1_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA1_CLKA_noedge_posedge,
        HoldHigh => thold_ADA1_CLKA_noedge_posedge,
        HoldLow => thold_ADA1_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA1_CLKA_TimingDatash,
        Violation => tviol_ADA1_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => CEA_dly,
        TestSignalName => "CEA",
        TestDelay => tisd_CEA_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_CEA_CLKA_noedge_posedge,
        SetupLow => tsetup_CEA_CLKA_noedge_posedge,
        HoldHigh => thold_CEA_CLKA_noedge_posedge,
        HoldLow => thold_CEA_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => CEA_CLKA_TimingDatash,
        Violation => tviol_CEA_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => OCEA_dly,
        TestSignalName => "OCEA",
        TestDelay => tisd_OCEA_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_OCEA_CLKA_noedge_posedge,
        SetupLow => tsetup_OCEA_CLKA_noedge_posedge,
        HoldHigh => thold_OCEA_CLKA_noedge_posedge,
        HoldLow => thold_OCEA_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => OCEA_CLKA_TimingDatash,
        Violation => tviol_OCEA_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => RSTA_dly,
        TestSignalName => "RSTA",
        TestDelay => tisd_RSTA_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_RSTA_CLKA_noedge_posedge,
        SetupLow => tsetup_RSTA_CLKA_noedge_posedge,
        HoldHigh => thold_RSTA_CLKA_noedge_posedge,
        HoldLow => thold_RSTA_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => RSTA_CLKA_TimingDatash,
        Violation => tviol_RSTA_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => RSTB_dly,
        TestSignalName => "RSTB",
        TestDelay => tisd_RSTB_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_RSTB_CLKB_noedge_posedge,
        SetupLow => tsetup_RSTB_CLKB_noedge_posedge,
        HoldHigh => thold_RSTB_CLKB_noedge_posedge,
        HoldLow => thold_RSTB_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => RSTB_CLKB_TimingDatash,
        Violation => tviol_RSTB_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => OCEB_dly,
        TestSignalName => "OCEB",
        TestDelay => tisd_OCEB_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_OCEB_CLKB_noedge_posedge,
        SetupLow => tsetup_OCEB_CLKB_noedge_posedge,
        HoldHigh => thold_OCEB_CLKB_noedge_posedge,
        HoldLow => thold_OCEB_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => OCEB_CLKB_TimingDatash,
        Violation => tviol_OCEB_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => CEB_dly,
        TestSignalName => "CEB",
        TestDelay => tisd_CEB_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_CEB_CLKB_noedge_posedge,
        SetupLow => tsetup_CEB_CLKB_noedge_posedge,
        HoldHigh => thold_CEB_CLKB_noedge_posedge,
        HoldLow => thold_CEB_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => CEB_CLKB_TimingDatash,
        Violation => tviol_CEB_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB1_dly,
        TestSignalName => "ADB1",
        TestDelay => tisd_ADB1_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB1_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB1_CLKB_noedge_posedge,
        HoldHigh => thold_ADB1_CLKB_noedge_posedge,
        HoldLow => thold_ADB1_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB1_CLKB_TimingDatash,
        Violation => tviol_ADB1_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB2_dly,
        TestSignalName => "ADB2",
        TestDelay => tisd_ADB2_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB2_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB2_CLKB_noedge_posedge,
        HoldHigh => thold_ADB2_CLKB_noedge_posedge,
        HoldLow => thold_ADB2_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB2_CLKB_TimingDatash,
        Violation => tviol_ADB2_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB3_dly,
        TestSignalName => "ADB3",
        TestDelay => tisd_ADB3_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB3_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB3_CLKB_noedge_posedge,
        HoldHigh => thold_ADB3_CLKB_noedge_posedge,
        HoldLow => thold_ADB3_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB3_CLKB_TimingDatash,
        Violation => tviol_ADB3_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB4_dly,
        TestSignalName => "ADB4",
        TestDelay => tisd_ADB4_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB4_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB4_CLKB_noedge_posedge,
        HoldHigh => thold_ADB4_CLKB_noedge_posedge,
        HoldLow => thold_ADB4_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB4_CLKB_TimingDatash,
        Violation => tviol_ADB4_CLKB,
        MsgSeverity => warning);
      VitalPeriodPulseCheck (
        TestSignal => CLKA_ipd,
        TestSignalName => "CLKA",
        Period => tperiod_CLKA,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow => tpw_CLKA_negedge,
        PeriodData => periodcheckinfo_CLKA,
        Violation => tviol_CLKA_CLKA,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);
      VitalPeriodPulseCheck (
        TestSignal => CLKB_ipd,
        TestSignalName => "CLKB",
        Period => tperiod_CLKB,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow => tpw_CLKB_negedge,
        PeriodData => periodcheckinfo_CLKB,
        Violation => tviol_CLKB_CLKB,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    DOB0_zd 	:= DOB0_out;
    DOB1_zd 	:= DOB1_out;

    VitalPathDelay01 (
      OutSignal => DOB0, OutSignalName => "DOB0", OutTemp => DOB0_zd,
      Paths      => (0 => (InputChangeTime => CLKB_dly'last_event,
                           PathDelay => tpd_CLKB_DOB0,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => RSTB_dly'last_event,
                           PathDelay => tpd_RSTB_DOB0,
                           PathCondition => TRUE)),
      GlitchData => DOB0_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);
    VitalPathDelay01 (
      OutSignal => DOB1, OutSignalName => "DOB1", OutTemp => DOB1_zd,
      Paths      => (0 => (InputChangeTime => CLKB_dly'last_event,
                           PathDelay => tpd_CLKB_DOB1,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => RSTB_dly'last_event,
                           PathDelay => tpd_RSTB_DOB1,
                           PathCondition => TRUE)),
      GlitchData => DOB1_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity EHXPLLL0005
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity EHXPLLL0005 is
    port (CLKI: in Std_logic; CLKFB: in Std_logic; PHASESEL1: in Std_logic; 
          PHASESEL0: in Std_logic; PHASEDIR: in Std_logic; 
          PHASESTEP: in Std_logic; PHASELOADREG: in Std_logic; 
          STDBY: in Std_logic; PLLWAKESYNC: in Std_logic; RST: in Std_logic; 
          ENCLKOP: in Std_logic; ENCLKOS: in Std_logic; ENCLKOS2: in Std_logic; 
          ENCLKOS3: in Std_logic; CLKOP: out Std_logic; CLKOS: out Std_logic; 
          CLKOS2: out Std_logic; CLKOS3: out Std_logic; LOCK: out Std_logic; 
          INTLOCK: out Std_logic; REFCLK: out Std_logic; 
          CLKINTFB: out Std_logic);



  end EHXPLLL0005;

  architecture Structure of EHXPLLL0005 is
  begin
    INST10: EHXPLLL
      generic map (CLKFB_DIV => 20, CLKI_DIV => 1, CLKOP_CPHASE => 2, 
                   CLKOP_DIV => 3, CLKOP_ENABLE => "ENABLED", 
                   CLKOP_FPHASE => 0, CLKOP_TRIM_DELAY => 0, 
                   CLKOP_TRIM_POL => "FALLING", CLKOS2_CPHASE => 0, 
                   CLKOS2_DIV => 1, CLKOS2_ENABLE => "DISABLED", 
                   CLKOS2_FPHASE => 0, CLKOS3_CPHASE => 0, CLKOS3_DIV => 1, 
                   CLKOS3_ENABLE => "DISABLED", CLKOS3_FPHASE => 0, 
                   CLKOS_CPHASE => 0, CLKOS_DIV => 1, 
                   CLKOS_ENABLE => "DISABLED", CLKOS_FPHASE => 0, 
                   CLKOS_TRIM_DELAY => 0, CLKOS_TRIM_POL => "FALLING", 
                   DPHASE_SOURCE => "DISABLED", FEEDBK_PATH => "CLKOP", 
                   INTFB_WAKE => "DISABLED", INT_LOCK_STICKY => "ENABLED", 
                   OUTDIVIDER_MUXA => "DIVA", OUTDIVIDER_MUXB => "DIVB", 
                   OUTDIVIDER_MUXC => "DIVC", OUTDIVIDER_MUXD => "DIVD", 
                   PLLRST_ENA => "ENABLED", PLL_LOCK_DELAY => 200, 
                   PLL_LOCK_MODE => 0, REFIN_RESET => "DISABLED", 
                   STDBY_ENABLE => "DISABLED", SYNC_ENABLE => "DISABLED")
      port map (CLKI=>CLKI, CLKFB=>CLKFB, PHASESEL1=>PHASESEL1, 
                PHASESEL0=>PHASESEL0, PHASEDIR=>PHASEDIR, PHASESTEP=>PHASESTEP, 
                PHASELOADREG=>PHASELOADREG, STDBY=>STDBY, 
                PLLWAKESYNC=>PLLWAKESYNC, RST=>RST, ENCLKOP=>ENCLKOP, 
                ENCLKOS=>ENCLKOS, ENCLKOS2=>ENCLKOS2, ENCLKOS3=>ENCLKOS3, 
                CLKOP=>CLKOP, CLKOS=>CLKOS, CLKOS2=>CLKOS2, CLKOS3=>CLKOS3, 
                LOCK=>LOCK, INTLOCK=>INTLOCK, REFCLK=>REFCLK, 
                CLKINTFB=>CLKINTFB);
  end Structure;

-- entity second_pll_PLLInst_0
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity second_pll_PLLInst_0 is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "second_pll_PLLInst_0";

      tipd_CLKI  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CLKFB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_STDBY  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_RST  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKI_CLKOP	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKFB_CLKOP	 : VitalDelayType01 := (0 ns, 0 ns));

    port (CLKI: in Std_logic; CLKFB: in Std_logic; STDBY: in Std_logic; 
          RST: in Std_logic; LOCK: out Std_logic; CLKOP: out Std_logic);



  end second_pll_PLLInst_0;

  architecture Structure of second_pll_PLLInst_0 is
    signal CLKI_ipd 	: std_logic := 'X';
    signal CLKFB_ipd 	: std_logic := 'X';
    signal STDBY_ipd 	: std_logic := 'X';
    signal RST_ipd 	: std_logic := 'X';
    signal LOCK_out 	: std_logic := 'X';
    signal CLKOP_out 	: std_logic := 'X';

    signal GNDI: Std_logic;
    component gnd
      port (PWR0: out Std_logic);
    end component;
    component EHXPLLL0005
      port (CLKI: in Std_logic; CLKFB: in Std_logic; PHASESEL1: in Std_logic; 
            PHASESEL0: in Std_logic; PHASEDIR: in Std_logic; 
            PHASESTEP: in Std_logic; PHASELOADREG: in Std_logic; 
            STDBY: in Std_logic; PLLWAKESYNC: in Std_logic; RST: in Std_logic; 
            ENCLKOP: in Std_logic; ENCLKOS: in Std_logic; 
            ENCLKOS2: in Std_logic; ENCLKOS3: in Std_logic; 
            CLKOP: out Std_logic; CLKOS: out Std_logic; CLKOS2: out Std_logic; 
            CLKOS3: out Std_logic; LOCK: out Std_logic; INTLOCK: out Std_logic; 
            REFCLK: out Std_logic; CLKINTFB: out Std_logic);
    end component;
  begin
    second_pll_PLLInst_0_EHXPLLL: EHXPLLL0005
      port map (CLKI=>CLKI_ipd, CLKFB=>CLKFB_ipd, PHASESEL1=>GNDI, 
                PHASESEL0=>GNDI, PHASEDIR=>GNDI, PHASESTEP=>GNDI, 
                PHASELOADREG=>GNDI, STDBY=>STDBY_ipd, PLLWAKESYNC=>GNDI, 
                RST=>RST_ipd, ENCLKOP=>GNDI, ENCLKOS=>GNDI, ENCLKOS2=>GNDI, 
                ENCLKOS3=>GNDI, CLKOP=>CLKOP_out, CLKOS=>open, CLKOS2=>open, 
                CLKOS3=>open, LOCK=>LOCK_out, INTLOCK=>open, REFCLK=>open, 
                CLKINTFB=>open);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(CLKI_ipd, CLKI, tipd_CLKI);
      VitalWireDelay(CLKFB_ipd, CLKFB, tipd_CLKFB);
      VitalWireDelay(STDBY_ipd, STDBY, tipd_STDBY);
      VitalWireDelay(RST_ipd, RST, tipd_RST);
    END BLOCK;

    VitalBehavior : PROCESS (CLKI_ipd, CLKFB_ipd, STDBY_ipd, RST_ipd, LOCK_out, 
      CLKOP_out)
    VARIABLE CLKOP_zd         	: std_logic := 'X';
    VARIABLE CLKOP_GlitchData 	: VitalGlitchDataType;


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;

    LOCK 	<= LOCK_out;
    CLKOP_zd 	:= CLKOP_out;

    VitalPathDelay01 (
      OutSignal => CLKOP, OutSignalName => "CLKOP", OutTemp => CLKOP_zd,
      Paths      => (0 => (InputChangeTime => CLKI_ipd'last_event,
                           PathDelay => tpd_CLKI_CLKOP,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => CLKFB_ipd'last_event,
                           PathDelay => tpd_CLKFB_CLKOP,
                           PathCondition => TRUE)),
      GlitchData => CLKOP_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity DP16KD0006
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity DP16KD0006 is
    port (CEA: in Std_logic; OCEA: in Std_logic; CLKA: in Std_logic; 
          WEA: in Std_logic; CSA0: in Std_logic; CSA1: in Std_logic; 
          CSA2: in Std_logic; RSTA: in Std_logic; CEB: in Std_logic; 
          OCEB: in Std_logic; CLKB: in Std_logic; WEB: in Std_logic; 
          CSB0: in Std_logic; CSB1: in Std_logic; CSB2: in Std_logic; 
          RSTB: in Std_logic; DIA0: in Std_logic; DIA1: in Std_logic; 
          DIA2: in Std_logic; DIA3: in Std_logic; DIA4: in Std_logic; 
          DIA5: in Std_logic; DIA6: in Std_logic; DIA7: in Std_logic; 
          DIA8: in Std_logic; DIA9: in Std_logic; DIA10: in Std_logic; 
          DIA11: in Std_logic; DIA12: in Std_logic; DIA13: in Std_logic; 
          DIA14: in Std_logic; DIA15: in Std_logic; DIA16: in Std_logic; 
          DIA17: in Std_logic; ADA0: in Std_logic; ADA1: in Std_logic; 
          ADA2: in Std_logic; ADA3: in Std_logic; ADA4: in Std_logic; 
          ADA5: in Std_logic; ADA6: in Std_logic; ADA7: in Std_logic; 
          ADA8: in Std_logic; ADA9: in Std_logic; ADA10: in Std_logic; 
          ADA11: in Std_logic; ADA12: in Std_logic; ADA13: in Std_logic; 
          DIB0: in Std_logic; DIB1: in Std_logic; DIB2: in Std_logic; 
          DIB3: in Std_logic; DIB4: in Std_logic; DIB5: in Std_logic; 
          DIB6: in Std_logic; DIB7: in Std_logic; DIB8: in Std_logic; 
          DIB9: in Std_logic; DIB10: in Std_logic; DIB11: in Std_logic; 
          DIB12: in Std_logic; DIB13: in Std_logic; DIB14: in Std_logic; 
          DIB15: in Std_logic; DIB16: in Std_logic; DIB17: in Std_logic; 
          ADB0: in Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
          ADB3: in Std_logic; ADB4: in Std_logic; ADB5: in Std_logic; 
          ADB6: in Std_logic; ADB7: in Std_logic; ADB8: in Std_logic; 
          ADB9: in Std_logic; ADB10: in Std_logic; ADB11: in Std_logic; 
          ADB12: in Std_logic; ADB13: in Std_logic; DOA0: out Std_logic; 
          DOA1: out Std_logic; DOA2: out Std_logic; DOA3: out Std_logic; 
          DOA4: out Std_logic; DOA5: out Std_logic; DOA6: out Std_logic; 
          DOA7: out Std_logic; DOA8: out Std_logic; DOA9: out Std_logic; 
          DOA10: out Std_logic; DOA11: out Std_logic; DOA12: out Std_logic; 
          DOA13: out Std_logic; DOA14: out Std_logic; DOA15: out Std_logic; 
          DOA16: out Std_logic; DOA17: out Std_logic; DOB0: out Std_logic; 
          DOB1: out Std_logic; DOB2: out Std_logic; DOB3: out Std_logic; 
          DOB4: out Std_logic; DOB5: out Std_logic; DOB6: out Std_logic; 
          DOB7: out Std_logic; DOB8: out Std_logic; DOB9: out Std_logic; 
          DOB10: out Std_logic; DOB11: out Std_logic; DOB12: out Std_logic; 
          DOB13: out Std_logic; DOB14: out Std_logic; DOB15: out Std_logic; 
          DOB16: out Std_logic; DOB17: out Std_logic);

    ATTRIBUTE Vital_Level0 OF DP16KD0006 : ENTITY IS TRUE;

  end DP16KD0006;

  architecture Structure of DP16KD0006 is
  begin
    INST10: DP16KD
      generic map (ASYNC_RESET_RELEASE => "SYNC", CSDECODE_A => "0b000", 
                   CSDECODE_B => "0b000", DATA_WIDTH_A => 2, DATA_WIDTH_B => 2, 
                   GSR => "ENABLED", 
                   INITVAL_00 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_01 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_02 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_03 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_04 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_05 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_06 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_07 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_08 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_09 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_0F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_10 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_11 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_12 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_13 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_14 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_15 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_16 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_17 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_18 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_19 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_1F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_20 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_21 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_22 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_23 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_24 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_25 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_26 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_27 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_28 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_29 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_2F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_30 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_31 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_32 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_33 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_34 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_35 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_36 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_37 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_38 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_39 => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3A => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3B => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3C => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3D => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3E => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , 
                   INITVAL_3F => "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                   , INIT_DATA => "STATIC", REGMODE_A => "NOREG", 
                   REGMODE_B => "NOREG", RESETMODE => "ASYNC", 
                   WRITEMODE_A => "NORMAL", WRITEMODE_B => "NORMAL")
      port map (DIA0=>DIA0, DIA1=>DIA1, DIA2=>DIA2, DIA3=>DIA3, DIA4=>DIA4, 
                DIA5=>DIA5, DIA6=>DIA6, DIA7=>DIA7, DIA8=>DIA8, DIA9=>DIA9, 
                DIA10=>DIA10, DIA11=>DIA11, DIA12=>DIA12, DIA13=>DIA13, 
                DIA14=>DIA14, DIA15=>DIA15, DIA16=>DIA16, DIA17=>DIA17, 
                ADA0=>ADA0, ADA1=>ADA1, ADA2=>ADA2, ADA3=>ADA3, ADA4=>ADA4, 
                ADA5=>ADA5, ADA6=>ADA6, ADA7=>ADA7, ADA8=>ADA8, ADA9=>ADA9, 
                ADA10=>ADA10, ADA11=>ADA11, ADA12=>ADA12, ADA13=>ADA13, 
                CEA=>CEA, OCEA=>OCEA, CLKA=>CLKA, WEA=>WEA, CSA0=>CSA0, 
                CSA1=>CSA1, CSA2=>CSA2, RSTA=>RSTA, DIB0=>DIB0, DIB1=>DIB1, 
                DIB2=>DIB2, DIB3=>DIB3, DIB4=>DIB4, DIB5=>DIB5, DIB6=>DIB6, 
                DIB7=>DIB7, DIB8=>DIB8, DIB9=>DIB9, DIB10=>DIB10, DIB11=>DIB11, 
                DIB12=>DIB12, DIB13=>DIB13, DIB14=>DIB14, DIB15=>DIB15, 
                DIB16=>DIB16, DIB17=>DIB17, ADB0=>ADB0, ADB1=>ADB1, ADB2=>ADB2, 
                ADB3=>ADB3, ADB4=>ADB4, ADB5=>ADB5, ADB6=>ADB6, ADB7=>ADB7, 
                ADB8=>ADB8, ADB9=>ADB9, ADB10=>ADB10, ADB11=>ADB11, 
                ADB12=>ADB12, ADB13=>ADB13, CEB=>CEB, OCEB=>OCEB, CLKB=>CLKB, 
                WEB=>WEB, CSB0=>CSB0, CSB1=>CSB1, CSB2=>CSB2, RSTB=>RSTB, 
                DOA0=>DOA0, DOA1=>DOA1, DOA2=>DOA2, DOA3=>DOA3, DOA4=>DOA4, 
                DOA5=>DOA5, DOA6=>DOA6, DOA7=>DOA7, DOA8=>DOA8, DOA9=>DOA9, 
                DOA10=>DOA10, DOA11=>DOA11, DOA12=>DOA12, DOA13=>DOA13, 
                DOA14=>DOA14, DOA15=>DOA15, DOA16=>DOA16, DOA17=>DOA17, 
                DOB0=>DOB0, DOB1=>DOB1, DOB2=>DOB2, DOB3=>DOB3, DOB4=>DOB4, 
                DOB5=>DOB5, DOB6=>DOB6, DOB7=>DOB7, DOB8=>DOB8, DOB9=>DOB9, 
                DOB10=>DOB10, DOB11=>DOB11, DOB12=>DOB12, DOB13=>DOB13, 
                DOB14=>DOB14, DOB15=>DOB15, DOB16=>DOB16, DOB17=>DOB17);
  end Structure;

-- entity wifi_iddr_fifo_inst_pdp_ram_0_0_0
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity wifi_iddr_fifo_inst_pdp_ram_0_0_0 is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "wifi_iddr_fifo_inst_pdp_ram_0_0_0";

      tipd_DIA1  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_DIA0  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA4  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA3  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA2  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADA1  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CEA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_OCEA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_RSTA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CLKA  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CLKB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_RSTB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_OCEB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_CEB  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB1  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB2  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB3  	: VitalDelayType01 := (0 ns, 0 ns);
      tipd_ADB4  	: VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKB_DOB0	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_CLKB_DOB1	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_RSTB_DOB0	 : VitalDelayType01 := (0 ns, 0 ns);
      tpd_RSTB_DOB1	 : VitalDelayType01 := (0 ns, 0 ns);
      ticd_CLKA	: VitalDelayType := 0 ns;
      tisd_DIA1_CLKA	: VitalDelayType := 0 ns;
      tsetup_DIA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_DIA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_DIA0_CLKA	: VitalDelayType := 0 ns;
      tsetup_DIA0_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_DIA0_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA4_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA4_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA4_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA3_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA3_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA3_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA2_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA2_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA2_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADA1_CLKA	: VitalDelayType := 0 ns;
      tsetup_ADA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADA1_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_CEA_CLKA	: VitalDelayType := 0 ns;
      tsetup_CEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_CEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_OCEA_CLKA	: VitalDelayType := 0 ns;
      tsetup_OCEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_OCEA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_RSTA_CLKA	: VitalDelayType := 0 ns;
      tsetup_RSTA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      thold_RSTA_CLKA_noedge_posedge	: VitalDelayType := 0 ns;
      ticd_CLKB	: VitalDelayType := 0 ns;
      tisd_RSTB_CLKB	: VitalDelayType := 0 ns;
      tsetup_RSTB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_RSTB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_OCEB_CLKB	: VitalDelayType := 0 ns;
      tsetup_OCEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_OCEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_CEB_CLKB	: VitalDelayType := 0 ns;
      tsetup_CEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_CEB_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB1_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB1_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB1_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB2_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB2_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB2_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB3_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB3_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB3_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tisd_ADB4_CLKB	: VitalDelayType := 0 ns;
      tsetup_ADB4_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      thold_ADB4_CLKB_noedge_posedge	: VitalDelayType := 0 ns;
      tperiod_CLKA 	: VitalDelayType := 0 ns;
      tpw_CLKA_posedge	: VitalDelayType := 0 ns;
      tpw_CLKA_negedge	: VitalDelayType := 0 ns;
      tperiod_CLKB 	: VitalDelayType := 0 ns;
      tpw_CLKB_posedge	: VitalDelayType := 0 ns;
      tpw_CLKB_negedge	: VitalDelayType := 0 ns);

    port (DIA1: in Std_logic; DIA0: in Std_logic; ADA4: in Std_logic; 
          ADA3: in Std_logic; ADA2: in Std_logic; ADA1: in Std_logic; 
          CEA: in Std_logic; OCEA: in Std_logic; RSTA: in Std_logic; 
          CLKA: in Std_logic; CLKB: in Std_logic; RSTB: in Std_logic; 
          OCEB: in Std_logic; CEB: in Std_logic; DOB0: out Std_logic; 
          DOB1: out Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
          ADB3: in Std_logic; ADB4: in Std_logic);

    ATTRIBUTE Vital_Level0 OF wifi_iddr_fifo_inst_pdp_ram_0_0_0 : ENTITY IS TRUE;

  end wifi_iddr_fifo_inst_pdp_ram_0_0_0;

  architecture Structure of wifi_iddr_fifo_inst_pdp_ram_0_0_0 is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal DIA1_ipd 	: std_logic := 'X';
    signal DIA1_dly 	: std_logic := 'X';
    signal DIA0_ipd 	: std_logic := 'X';
    signal DIA0_dly 	: std_logic := 'X';
    signal ADA4_ipd 	: std_logic := 'X';
    signal ADA4_dly 	: std_logic := 'X';
    signal ADA3_ipd 	: std_logic := 'X';
    signal ADA3_dly 	: std_logic := 'X';
    signal ADA2_ipd 	: std_logic := 'X';
    signal ADA2_dly 	: std_logic := 'X';
    signal ADA1_ipd 	: std_logic := 'X';
    signal ADA1_dly 	: std_logic := 'X';
    signal CEA_ipd 	: std_logic := 'X';
    signal CEA_dly 	: std_logic := 'X';
    signal OCEA_ipd 	: std_logic := 'X';
    signal OCEA_dly 	: std_logic := 'X';
    signal RSTA_ipd 	: std_logic := 'X';
    signal RSTA_dly 	: std_logic := 'X';
    signal CLKA_ipd 	: std_logic := 'X';
    signal CLKA_dly 	: std_logic := 'X';
    signal CLKB_ipd 	: std_logic := 'X';
    signal CLKB_dly 	: std_logic := 'X';
    signal RSTB_ipd 	: std_logic := 'X';
    signal RSTB_dly 	: std_logic := 'X';
    signal OCEB_ipd 	: std_logic := 'X';
    signal OCEB_dly 	: std_logic := 'X';
    signal CEB_ipd 	: std_logic := 'X';
    signal CEB_dly 	: std_logic := 'X';
    signal DOB0_out 	: std_logic := 'X';
    signal DOB1_out 	: std_logic := 'X';
    signal ADB1_ipd 	: std_logic := 'X';
    signal ADB1_dly 	: std_logic := 'X';
    signal ADB2_ipd 	: std_logic := 'X';
    signal ADB2_dly 	: std_logic := 'X';
    signal ADB3_ipd 	: std_logic := 'X';
    signal ADB3_dly 	: std_logic := 'X';
    signal ADB4_ipd 	: std_logic := 'X';
    signal ADB4_dly 	: std_logic := 'X';

    signal VCCI: Std_logic;
    signal GNDI: Std_logic;
    component gnd
      port (PWR0: out Std_logic);
    end component;
    component vcc
      port (PWR1: out Std_logic);
    end component;
    component DP16KD0006
      port (CEA: in Std_logic; OCEA: in Std_logic; CLKA: in Std_logic; 
            WEA: in Std_logic; CSA0: in Std_logic; CSA1: in Std_logic; 
            CSA2: in Std_logic; RSTA: in Std_logic; CEB: in Std_logic; 
            OCEB: in Std_logic; CLKB: in Std_logic; WEB: in Std_logic; 
            CSB0: in Std_logic; CSB1: in Std_logic; CSB2: in Std_logic; 
            RSTB: in Std_logic; DIA0: in Std_logic; DIA1: in Std_logic; 
            DIA2: in Std_logic; DIA3: in Std_logic; DIA4: in Std_logic; 
            DIA5: in Std_logic; DIA6: in Std_logic; DIA7: in Std_logic; 
            DIA8: in Std_logic; DIA9: in Std_logic; DIA10: in Std_logic; 
            DIA11: in Std_logic; DIA12: in Std_logic; DIA13: in Std_logic; 
            DIA14: in Std_logic; DIA15: in Std_logic; DIA16: in Std_logic; 
            DIA17: in Std_logic; ADA0: in Std_logic; ADA1: in Std_logic; 
            ADA2: in Std_logic; ADA3: in Std_logic; ADA4: in Std_logic; 
            ADA5: in Std_logic; ADA6: in Std_logic; ADA7: in Std_logic; 
            ADA8: in Std_logic; ADA9: in Std_logic; ADA10: in Std_logic; 
            ADA11: in Std_logic; ADA12: in Std_logic; ADA13: in Std_logic; 
            DIB0: in Std_logic; DIB1: in Std_logic; DIB2: in Std_logic; 
            DIB3: in Std_logic; DIB4: in Std_logic; DIB5: in Std_logic; 
            DIB6: in Std_logic; DIB7: in Std_logic; DIB8: in Std_logic; 
            DIB9: in Std_logic; DIB10: in Std_logic; DIB11: in Std_logic; 
            DIB12: in Std_logic; DIB13: in Std_logic; DIB14: in Std_logic; 
            DIB15: in Std_logic; DIB16: in Std_logic; DIB17: in Std_logic; 
            ADB0: in Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
            ADB3: in Std_logic; ADB4: in Std_logic; ADB5: in Std_logic; 
            ADB6: in Std_logic; ADB7: in Std_logic; ADB8: in Std_logic; 
            ADB9: in Std_logic; ADB10: in Std_logic; ADB11: in Std_logic; 
            ADB12: in Std_logic; ADB13: in Std_logic; DOA0: out Std_logic; 
            DOA1: out Std_logic; DOA2: out Std_logic; DOA3: out Std_logic; 
            DOA4: out Std_logic; DOA5: out Std_logic; DOA6: out Std_logic; 
            DOA7: out Std_logic; DOA8: out Std_logic; DOA9: out Std_logic; 
            DOA10: out Std_logic; DOA11: out Std_logic; DOA12: out Std_logic; 
            DOA13: out Std_logic; DOA14: out Std_logic; DOA15: out Std_logic; 
            DOA16: out Std_logic; DOA17: out Std_logic; DOB0: out Std_logic; 
            DOB1: out Std_logic; DOB2: out Std_logic; DOB3: out Std_logic; 
            DOB4: out Std_logic; DOB5: out Std_logic; DOB6: out Std_logic; 
            DOB7: out Std_logic; DOB8: out Std_logic; DOB9: out Std_logic; 
            DOB10: out Std_logic; DOB11: out Std_logic; DOB12: out Std_logic; 
            DOB13: out Std_logic; DOB14: out Std_logic; DOB15: out Std_logic; 
            DOB16: out Std_logic; DOB17: out Std_logic);
    end component;
  begin
    wifi_iddr_fifo_inst_pdp_ram_0_0_0_DP16KD: DP16KD0006
      port map (CEA=>CEA_dly, OCEA=>OCEA_dly, CLKA=>CLKA_dly, WEA=>VCCI, 
                CSA0=>GNDI, CSA1=>GNDI, CSA2=>GNDI, RSTA=>RSTA_dly, 
                CEB=>CEB_dly, OCEB=>OCEB_dly, CLKB=>CLKB_dly, WEB=>GNDI, 
                CSB0=>GNDI, CSB1=>GNDI, CSB2=>GNDI, RSTB=>RSTB_dly, 
                DIA0=>DIA0_dly, DIA1=>DIA1_dly, DIA2=>'X', DIA3=>'X', 
                DIA4=>'X', DIA5=>'X', DIA6=>'X', DIA7=>'X', DIA8=>'X', 
                DIA9=>'X', DIA10=>'X', DIA11=>'X', DIA12=>'X', DIA13=>'X', 
                DIA14=>'X', DIA15=>'X', DIA16=>'X', DIA17=>'X', ADA0=>GNDI, 
                ADA1=>ADA1_dly, ADA2=>ADA2_dly, ADA3=>ADA3_dly, ADA4=>ADA4_dly, 
                ADA5=>GNDI, ADA6=>GNDI, ADA7=>GNDI, ADA8=>GNDI, ADA9=>GNDI, 
                ADA10=>GNDI, ADA11=>GNDI, ADA12=>GNDI, ADA13=>GNDI, DIB0=>GNDI, 
                DIB1=>GNDI, DIB2=>'X', DIB3=>'X', DIB4=>'X', DIB5=>'X', 
                DIB6=>'X', DIB7=>'X', DIB8=>'X', DIB9=>'X', DIB10=>'X', 
                DIB11=>'X', DIB12=>'X', DIB13=>'X', DIB14=>'X', DIB15=>'X', 
                DIB16=>'X', DIB17=>'X', ADB0=>GNDI, ADB1=>ADB1_dly, 
                ADB2=>ADB2_dly, ADB3=>ADB3_dly, ADB4=>ADB4_dly, ADB5=>GNDI, 
                ADB6=>GNDI, ADB7=>GNDI, ADB8=>GNDI, ADB9=>GNDI, ADB10=>GNDI, 
                ADB11=>GNDI, ADB12=>GNDI, ADB13=>GNDI, DOA0=>open, DOA1=>open, 
                DOA2=>open, DOA3=>open, DOA4=>open, DOA5=>open, DOA6=>open, 
                DOA7=>open, DOA8=>open, DOA9=>open, DOA10=>open, DOA11=>open, 
                DOA12=>open, DOA13=>open, DOA14=>open, DOA15=>open, 
                DOA16=>open, DOA17=>open, DOB0=>DOB0_out, DOB1=>DOB1_out, 
                DOB2=>open, DOB3=>open, DOB4=>open, DOB5=>open, DOB6=>open, 
                DOB7=>open, DOB8=>open, DOB9=>open, DOB10=>open, DOB11=>open, 
                DOB12=>open, DOB13=>open, DOB14=>open, DOB15=>open, 
                DOB16=>open, DOB17=>open);
    DRIVEVCC: vcc
      port map (PWR1=>VCCI);
    DRIVEGND: gnd
      port map (PWR0=>GNDI);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(DIA1_ipd, DIA1, tipd_DIA1);
      VitalWireDelay(DIA0_ipd, DIA0, tipd_DIA0);
      VitalWireDelay(ADA4_ipd, ADA4, tipd_ADA4);
      VitalWireDelay(ADA3_ipd, ADA3, tipd_ADA3);
      VitalWireDelay(ADA2_ipd, ADA2, tipd_ADA2);
      VitalWireDelay(ADA1_ipd, ADA1, tipd_ADA1);
      VitalWireDelay(CEA_ipd, CEA, tipd_CEA);
      VitalWireDelay(OCEA_ipd, OCEA, tipd_OCEA);
      VitalWireDelay(RSTA_ipd, RSTA, tipd_RSTA);
      VitalWireDelay(CLKA_ipd, CLKA, tipd_CLKA);
      VitalWireDelay(CLKB_ipd, CLKB, tipd_CLKB);
      VitalWireDelay(RSTB_ipd, RSTB, tipd_RSTB);
      VitalWireDelay(OCEB_ipd, OCEB, tipd_OCEB);
      VitalWireDelay(CEB_ipd, CEB, tipd_CEB);
      VitalWireDelay(ADB1_ipd, ADB1, tipd_ADB1);
      VitalWireDelay(ADB2_ipd, ADB2, tipd_ADB2);
      VitalWireDelay(ADB3_ipd, ADB3, tipd_ADB3);
      VitalWireDelay(ADB4_ipd, ADB4, tipd_ADB4);
    END BLOCK;

    --  Setup and Hold DELAYs
    SignalDelay : BLOCK
    BEGIN
      VitalSignalDelay(DIA1_dly, DIA1_ipd, tisd_DIA1_CLKA);
      VitalSignalDelay(DIA0_dly, DIA0_ipd, tisd_DIA0_CLKA);
      VitalSignalDelay(ADA4_dly, ADA4_ipd, tisd_ADA4_CLKA);
      VitalSignalDelay(ADA3_dly, ADA3_ipd, tisd_ADA3_CLKA);
      VitalSignalDelay(ADA2_dly, ADA2_ipd, tisd_ADA2_CLKA);
      VitalSignalDelay(ADA1_dly, ADA1_ipd, tisd_ADA1_CLKA);
      VitalSignalDelay(CEA_dly, CEA_ipd, tisd_CEA_CLKA);
      VitalSignalDelay(OCEA_dly, OCEA_ipd, tisd_OCEA_CLKA);
      VitalSignalDelay(RSTA_dly, RSTA_ipd, tisd_RSTA_CLKA);
      VitalSignalDelay(CLKA_dly, CLKA_ipd, ticd_CLKA);
      VitalSignalDelay(CLKB_dly, CLKB_ipd, ticd_CLKB);
      VitalSignalDelay(RSTB_dly, RSTB_ipd, tisd_RSTB_CLKB);
      VitalSignalDelay(OCEB_dly, OCEB_ipd, tisd_OCEB_CLKB);
      VitalSignalDelay(CEB_dly, CEB_ipd, tisd_CEB_CLKB);
      VitalSignalDelay(ADB1_dly, ADB1_ipd, tisd_ADB1_CLKB);
      VitalSignalDelay(ADB2_dly, ADB2_ipd, tisd_ADB2_CLKB);
      VitalSignalDelay(ADB3_dly, ADB3_ipd, tisd_ADB3_CLKB);
      VitalSignalDelay(ADB4_dly, ADB4_ipd, tisd_ADB4_CLKB);
    END BLOCK;

    VitalBehavior : PROCESS (DIA1_dly, DIA0_dly, ADA4_dly, ADA3_dly, ADA2_dly, 
      ADA1_dly, CEA_dly, OCEA_dly, RSTA_dly, CLKA_dly, CLKB_dly, RSTB_dly, 
      OCEB_dly, CEB_dly, DOB0_out, DOB1_out, ADB1_dly, ADB2_dly, ADB3_dly, 
      ADB4_dly)
    VARIABLE DOB0_zd         	: std_logic := 'X';
    VARIABLE DOB0_GlitchData 	: VitalGlitchDataType;
    VARIABLE DOB1_zd         	: std_logic := 'X';
    VARIABLE DOB1_GlitchData 	: VitalGlitchDataType;

    VARIABLE tviol_DIA1_CLKA       	: x01 := '0';
    VARIABLE DIA1_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_DIA0_CLKA       	: x01 := '0';
    VARIABLE DIA0_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA4_CLKA       	: x01 := '0';
    VARIABLE ADA4_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA3_CLKA       	: x01 := '0';
    VARIABLE ADA3_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA2_CLKA       	: x01 := '0';
    VARIABLE ADA2_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADA1_CLKA       	: x01 := '0';
    VARIABLE ADA1_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_CEA_CLKA       	: x01 := '0';
    VARIABLE CEA_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_OCEA_CLKA       	: x01 := '0';
    VARIABLE OCEA_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_RSTA_CLKA       	: x01 := '0';
    VARIABLE RSTA_CLKA_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_RSTB_CLKB       	: x01 := '0';
    VARIABLE RSTB_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_OCEB_CLKB       	: x01 := '0';
    VARIABLE OCEB_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_CEB_CLKB       	: x01 := '0';
    VARIABLE CEB_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB1_CLKB       	: x01 := '0';
    VARIABLE ADB1_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB2_CLKB       	: x01 := '0';
    VARIABLE ADB2_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB3_CLKB       	: x01 := '0';
    VARIABLE ADB3_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_ADB4_CLKB       	: x01 := '0';
    VARIABLE ADB4_CLKB_TimingDatash	: VitalTimingDataType;
    VARIABLE tviol_CLKA_CLKA          	: x01 := '0';
    VARIABLE periodcheckinfo_CLKA	: VitalPeriodDataType;
    VARIABLE tviol_CLKB_CLKB          	: x01 := '0';
    VARIABLE periodcheckinfo_CLKB	: VitalPeriodDataType;

    BEGIN

    IF (TimingChecksOn) THEN
      VitalSetupHoldCheck (
        TestSignal => DIA1_dly,
        TestSignalName => "DIA1",
        TestDelay => tisd_DIA1_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_DIA1_CLKA_noedge_posedge,
        SetupLow => tsetup_DIA1_CLKA_noedge_posedge,
        HoldHigh => thold_DIA1_CLKA_noedge_posedge,
        HoldLow => thold_DIA1_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => DIA1_CLKA_TimingDatash,
        Violation => tviol_DIA1_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => DIA0_dly,
        TestSignalName => "DIA0",
        TestDelay => tisd_DIA0_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_DIA0_CLKA_noedge_posedge,
        SetupLow => tsetup_DIA0_CLKA_noedge_posedge,
        HoldHigh => thold_DIA0_CLKA_noedge_posedge,
        HoldLow => thold_DIA0_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => DIA0_CLKA_TimingDatash,
        Violation => tviol_DIA0_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA4_dly,
        TestSignalName => "ADA4",
        TestDelay => tisd_ADA4_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA4_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA4_CLKA_noedge_posedge,
        HoldHigh => thold_ADA4_CLKA_noedge_posedge,
        HoldLow => thold_ADA4_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA4_CLKA_TimingDatash,
        Violation => tviol_ADA4_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA3_dly,
        TestSignalName => "ADA3",
        TestDelay => tisd_ADA3_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA3_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA3_CLKA_noedge_posedge,
        HoldHigh => thold_ADA3_CLKA_noedge_posedge,
        HoldLow => thold_ADA3_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA3_CLKA_TimingDatash,
        Violation => tviol_ADA3_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA2_dly,
        TestSignalName => "ADA2",
        TestDelay => tisd_ADA2_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA2_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA2_CLKA_noedge_posedge,
        HoldHigh => thold_ADA2_CLKA_noedge_posedge,
        HoldLow => thold_ADA2_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA2_CLKA_TimingDatash,
        Violation => tviol_ADA2_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADA1_dly,
        TestSignalName => "ADA1",
        TestDelay => tisd_ADA1_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_ADA1_CLKA_noedge_posedge,
        SetupLow => tsetup_ADA1_CLKA_noedge_posedge,
        HoldHigh => thold_ADA1_CLKA_noedge_posedge,
        HoldLow => thold_ADA1_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADA1_CLKA_TimingDatash,
        Violation => tviol_ADA1_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => CEA_dly,
        TestSignalName => "CEA",
        TestDelay => tisd_CEA_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_CEA_CLKA_noedge_posedge,
        SetupLow => tsetup_CEA_CLKA_noedge_posedge,
        HoldHigh => thold_CEA_CLKA_noedge_posedge,
        HoldLow => thold_CEA_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => CEA_CLKA_TimingDatash,
        Violation => tviol_CEA_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => OCEA_dly,
        TestSignalName => "OCEA",
        TestDelay => tisd_OCEA_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_OCEA_CLKA_noedge_posedge,
        SetupLow => tsetup_OCEA_CLKA_noedge_posedge,
        HoldHigh => thold_OCEA_CLKA_noedge_posedge,
        HoldLow => thold_OCEA_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => OCEA_CLKA_TimingDatash,
        Violation => tviol_OCEA_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => RSTA_dly,
        TestSignalName => "RSTA",
        TestDelay => tisd_RSTA_CLKA,
        RefSignal => CLKA_dly,
        RefSignalName => "CLKA",
        RefDelay => ticd_CLKA,
        SetupHigh => tsetup_RSTA_CLKA_noedge_posedge,
        SetupLow => tsetup_RSTA_CLKA_noedge_posedge,
        HoldHigh => thold_RSTA_CLKA_noedge_posedge,
        HoldLow => thold_RSTA_CLKA_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => RSTA_CLKA_TimingDatash,
        Violation => tviol_RSTA_CLKA,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => RSTB_dly,
        TestSignalName => "RSTB",
        TestDelay => tisd_RSTB_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_RSTB_CLKB_noedge_posedge,
        SetupLow => tsetup_RSTB_CLKB_noedge_posedge,
        HoldHigh => thold_RSTB_CLKB_noedge_posedge,
        HoldLow => thold_RSTB_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => RSTB_CLKB_TimingDatash,
        Violation => tviol_RSTB_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => OCEB_dly,
        TestSignalName => "OCEB",
        TestDelay => tisd_OCEB_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_OCEB_CLKB_noedge_posedge,
        SetupLow => tsetup_OCEB_CLKB_noedge_posedge,
        HoldHigh => thold_OCEB_CLKB_noedge_posedge,
        HoldLow => thold_OCEB_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => OCEB_CLKB_TimingDatash,
        Violation => tviol_OCEB_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => CEB_dly,
        TestSignalName => "CEB",
        TestDelay => tisd_CEB_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_CEB_CLKB_noedge_posedge,
        SetupLow => tsetup_CEB_CLKB_noedge_posedge,
        HoldHigh => thold_CEB_CLKB_noedge_posedge,
        HoldLow => thold_CEB_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => CEB_CLKB_TimingDatash,
        Violation => tviol_CEB_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB1_dly,
        TestSignalName => "ADB1",
        TestDelay => tisd_ADB1_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB1_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB1_CLKB_noedge_posedge,
        HoldHigh => thold_ADB1_CLKB_noedge_posedge,
        HoldLow => thold_ADB1_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB1_CLKB_TimingDatash,
        Violation => tviol_ADB1_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB2_dly,
        TestSignalName => "ADB2",
        TestDelay => tisd_ADB2_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB2_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB2_CLKB_noedge_posedge,
        HoldHigh => thold_ADB2_CLKB_noedge_posedge,
        HoldLow => thold_ADB2_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB2_CLKB_TimingDatash,
        Violation => tviol_ADB2_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB3_dly,
        TestSignalName => "ADB3",
        TestDelay => tisd_ADB3_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB3_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB3_CLKB_noedge_posedge,
        HoldHigh => thold_ADB3_CLKB_noedge_posedge,
        HoldLow => thold_ADB3_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB3_CLKB_TimingDatash,
        Violation => tviol_ADB3_CLKB,
        MsgSeverity => warning);
      VitalSetupHoldCheck (
        TestSignal => ADB4_dly,
        TestSignalName => "ADB4",
        TestDelay => tisd_ADB4_CLKB,
        RefSignal => CLKB_dly,
        RefSignalName => "CLKB",
        RefDelay => ticd_CLKB,
        SetupHigh => tsetup_ADB4_CLKB_noedge_posedge,
        SetupLow => tsetup_ADB4_CLKB_noedge_posedge,
        HoldHigh => thold_ADB4_CLKB_noedge_posedge,
        HoldLow => thold_ADB4_CLKB_noedge_posedge,
        CheckEnabled => TRUE,
        RefTransition => '/',
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        TimingData => ADB4_CLKB_TimingDatash,
        Violation => tviol_ADB4_CLKB,
        MsgSeverity => warning);
      VitalPeriodPulseCheck (
        TestSignal => CLKA_ipd,
        TestSignalName => "CLKA",
        Period => tperiod_CLKA,
        PulseWidthHigh => tpw_CLKA_posedge,
        PulseWidthLow => tpw_CLKA_negedge,
        PeriodData => periodcheckinfo_CLKA,
        Violation => tviol_CLKA_CLKA,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);
      VitalPeriodPulseCheck (
        TestSignal => CLKB_ipd,
        TestSignalName => "CLKB",
        Period => tperiod_CLKB,
        PulseWidthHigh => tpw_CLKB_posedge,
        PulseWidthLow => tpw_CLKB_negedge,
        PeriodData => periodcheckinfo_CLKB,
        Violation => tviol_CLKB_CLKB,
        MsgOn => MsgOn, XOn => XOn,
        HeaderMsg => InstancePath,
        CheckEnabled => TRUE,
        MsgSeverity => warning);

    END IF;

    DOB0_zd 	:= DOB0_out;
    DOB1_zd 	:= DOB1_out;

    VitalPathDelay01 (
      OutSignal => DOB0, OutSignalName => "DOB0", OutTemp => DOB0_zd,
      Paths      => (0 => (InputChangeTime => CLKB_dly'last_event,
                           PathDelay => tpd_CLKB_DOB0,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => RSTB_dly'last_event,
                           PathDelay => tpd_RSTB_DOB0,
                           PathCondition => TRUE)),
      GlitchData => DOB0_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);
    VitalPathDelay01 (
      OutSignal => DOB1, OutSignalName => "DOB1", OutTemp => DOB1_zd,
      Paths      => (0 => (InputChangeTime => CLKB_dly'last_event,
                           PathDelay => tpd_CLKB_DOB1,
                           PathCondition => TRUE),
                     1 => (InputChangeTime => RSTB_dly'last_event,
                           PathDelay => tpd_RSTB_DOB1,
                           PathCondition => TRUE)),
      GlitchData => DOB1_GlitchData,
      Mode       => ondetect, XOn => XOn, MsgOn => MsgOn);

    END PROCESS;

  end Structure;

-- entity GSR5MODE
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity GSR5MODE is
    port (GSRP: in Std_logic);

    ATTRIBUTE Vital_Level0 OF GSR5MODE : ENTITY IS TRUE;

  end GSR5MODE;

  architecture Structure of GSR5MODE is
    signal GSRMODE: Std_logic;
  begin
    INST10: BUFBA
      port map (A=>GSRP, Z=>GSRMODE);
    INST20: GSR
      port map (GSR=>GSRMODE);
  end Structure;

-- entity GSR_INSTB
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity GSR_INSTB is
    -- miscellaneous vital GENERICs
    GENERIC (
      TimingChecksOn	: boolean := TRUE;
      XOn           	: boolean := FALSE;
      MsgOn         	: boolean := TRUE;
      InstancePath  	: string := "GSR_INSTB";

      tipd_GSRNET  	: VitalDelayType01 := (0 ns, 0 ns));

    port (GSRNET: in Std_logic);

    ATTRIBUTE Vital_Level0 OF GSR_INSTB : ENTITY IS TRUE;

  end GSR_INSTB;

  architecture Structure of GSR_INSTB is
    ATTRIBUTE Vital_Level0 OF Structure : ARCHITECTURE IS TRUE;

    signal GSRNET_ipd 	: std_logic := 'X';

    component GSR5MODE
      port (GSRP: in Std_logic);
    end component;
  begin
    GSR_INST_GSRMODE: GSR5MODE
      port map (GSRP=>GSRNET_ipd);

    --  INPUT PATH DELAYs
    WireDelay : BLOCK
    BEGIN
      VitalWireDelay(GSRNET_ipd, GSRNET, tipd_GSRNET);
    END BLOCK;

    VitalBehavior : PROCESS (GSRNET_ipd)


    BEGIN

    IF (TimingChecksOn) THEN

    END IF;



    END PROCESS;

  end Structure;

-- entity top
  library IEEE, vital2000, ECP5U;
  use IEEE.STD_LOGIC_1164.all;
  use vital2000.vital_timing.all;
  use ECP5U.COMPONENTS.ALL;

  entity top is
    port (fpga_led: out Std_logic; fpga_neopixel: out Std_logic; 
          dpll_clkout2: in Std_logic; dpll_clkout0: in Std_logic; 
          sdr_rx_wifi: in Std_logic; sdr_rx_subg: in Std_logic; 
          sdr_rxclk: in Std_logic; sdr_txclk: out Std_logic; 
          sdr_txdata: out Std_logic; fpga_sda: in Std_logic; 
          fpga_scl: in Std_logic; spi1_sck: out Std_logic; 
          spi1_mosi: out Std_logic; spi2_sck: out Std_logic; 
          spi2_mosi: out Std_logic; stm_fpga_spare1: in Std_logic; 
          spi3_sck: out Std_logic; spi3_mosi: out Std_logic; 
          spi4_sck: out Std_logic; spi4_mosi: out Std_logic; 
          stm_fpga_spare2: in Std_logic; fpga_ufl_p7: out Std_logic; 
          fpga_ufl_p8: out Std_logic; stm_fpga_spare5: in Std_logic);



  end top;

  architecture Structure of top is
    signal my_led_counter_2: Std_logic;
    signal my_led_counter_1: Std_logic;
    signal my_led_n133: Std_logic;
    signal my_led_n134: Std_logic;
    signal my_led_n1943: Std_logic;
    signal int_clk_out: Std_logic;
    signal my_led_n2360: Std_logic;
    signal my_led_n2361: Std_logic;
    signal my_led_counter_25: Std_logic;
    signal my_led_n110: Std_logic;
    signal my_led_n2372: Std_logic;
    signal my_led_counter_24: Std_logic;
    signal my_led_counter_23: Std_logic;
    signal my_led_n111: Std_logic;
    signal my_led_n112: Std_logic;
    signal my_led_n2371: Std_logic;
    signal my_led_counter_22: Std_logic;
    signal my_led_counter_21: Std_logic;
    signal my_led_n113: Std_logic;
    signal my_led_n114: Std_logic;
    signal my_led_n2370: Std_logic;
    signal my_led_counter_20: Std_logic;
    signal my_led_counter_19: Std_logic;
    signal my_led_n115: Std_logic;
    signal my_led_n116: Std_logic;
    signal my_led_n2369: Std_logic;
    signal my_led_counter_18: Std_logic;
    signal my_led_counter_17: Std_logic;
    signal my_led_n117: Std_logic;
    signal my_led_n118: Std_logic;
    signal my_led_n2368: Std_logic;
    signal my_led_counter_16: Std_logic;
    signal my_led_counter_15: Std_logic;
    signal my_led_n119: Std_logic;
    signal my_led_n120: Std_logic;
    signal my_led_n2367: Std_logic;
    signal my_led_counter_14: Std_logic;
    signal my_led_counter_13: Std_logic;
    signal my_led_n121: Std_logic;
    signal my_led_n122: Std_logic;
    signal my_led_n2366: Std_logic;
    signal my_led_counter_12: Std_logic;
    signal my_led_counter_11: Std_logic;
    signal my_led_n123: Std_logic;
    signal my_led_n124: Std_logic;
    signal my_led_n2365: Std_logic;
    signal my_led_counter_6: Std_logic;
    signal my_led_counter_5: Std_logic;
    signal my_led_n129: Std_logic;
    signal my_led_n130: Std_logic;
    signal my_led_n2362: Std_logic;
    signal my_led_n2363: Std_logic;
    signal my_led_counter_10: Std_logic;
    signal my_led_counter_9: Std_logic;
    signal my_led_n125: Std_logic;
    signal my_led_n126: Std_logic;
    signal my_led_n2364: Std_logic;
    signal my_led_counter_8: Std_logic;
    signal my_led_counter_7: Std_logic;
    signal my_led_n127: Std_logic;
    signal my_led_n128: Std_logic;
    signal my_led_counter_0: Std_logic;
    signal my_led_n135: Std_logic;
    signal my_led_counter_4: Std_logic;
    signal my_led_counter_3: Std_logic;
    signal my_led_n131: Std_logic;
    signal my_led_n132: Std_logic;
    signal subg_iddr_fifo_inst_w_gctr_ci: Std_logic;
    signal subg_iddr_fifo_inst_wcount_1: Std_logic;
    signal subg_iddr_fifo_inst_wcount_0: Std_logic;
    signal subg_iddr_fifo_inst_iwcount_1: Std_logic;
    signal subg_iddr_fifo_inst_iwcount_0: Std_logic;
    signal subg_iddr_fifo_inst_wren_i: Std_logic;
    signal internal_200MHz: Std_logic;
    signal subg_iddr_fifo_inst_co0: Std_logic;
    signal subg_iddr_fifo_inst_wcount_3: Std_logic;
    signal subg_iddr_fifo_inst_wcount_2: Std_logic;
    signal subg_iddr_fifo_inst_iwcount_3: Std_logic;
    signal subg_iddr_fifo_inst_iwcount_2: Std_logic;
    signal subg_iddr_fifo_inst_co1: Std_logic;
    signal subg_iddr_fifo_inst_wcount_4: Std_logic;
    signal subg_iddr_fifo_inst_iwcount_4: Std_logic;
    signal subg_iddr_fifo_inst_r_gctr_ci: Std_logic;
    signal subg_iddr_fifo_inst_rcount_1: Std_logic;
    signal subg_iddr_fifo_inst_rcount_0: Std_logic;
    signal subg_iddr_fifo_inst_ircount_1: Std_logic;
    signal subg_iddr_fifo_inst_ircount_0: Std_logic;
    signal subg_iddr_fifo_inst_rden_i: Std_logic;
    signal main_reset_n_N_4: Std_logic;
    signal internal_80MHz: Std_logic;
    signal subg_iddr_fifo_inst_co0_1: Std_logic;
    signal subg_iddr_fifo_inst_rcount_3: Std_logic;
    signal subg_iddr_fifo_inst_rcount_2: Std_logic;
    signal subg_iddr_fifo_inst_ircount_3: Std_logic;
    signal subg_iddr_fifo_inst_ircount_2: Std_logic;
    signal subg_iddr_fifo_inst_co1_1: Std_logic;
    signal subg_iddr_fifo_inst_rcount_4: Std_logic;
    signal subg_iddr_fifo_inst_ircount_4: Std_logic;
    signal subg_iddr_fifo_inst_cmp_ci: Std_logic;
    signal subg_iddr_fifo_inst_w_g2b_xor_cluster_0: Std_logic;
    signal subg_iddr_fifo_inst_wcount_r0: Std_logic;
    signal subg_iddr_fifo_inst_co0_2: Std_logic;
    signal subg_iddr_fifo_inst_wcount_r3: Std_logic;
    signal subg_iddr_fifo_inst_wcount_r2: Std_logic;
    signal subg_iddr_fifo_inst_co1_2: Std_logic;
    signal subg_iddr_fifo_inst_empty_cmp_clr: Std_logic;
    signal subg_iddr_fifo_inst_empty_cmp_set: Std_logic;
    signal subg_iddr_fifo_inst_empty_d_c: Std_logic;
    signal subg_iddr_fifo_inst_empty_d: Std_logic;
    signal subg_iddr_fifo_empty: Std_logic;
    signal subg_iddr_fifo_inst_cmp_ci_1: Std_logic;
    signal subg_iddr_fifo_inst_r_g2b_xor_cluster_0: Std_logic;
    signal subg_iddr_fifo_inst_rcount_w0: Std_logic;
    signal subg_iddr_fifo_inst_co0_3: Std_logic;
    signal subg_iddr_fifo_inst_rcount_w3: Std_logic;
    signal subg_iddr_fifo_inst_rcount_w2: Std_logic;
    signal subg_iddr_fifo_inst_co1_3: Std_logic;
    signal subg_iddr_fifo_inst_full_cmp_clr: Std_logic;
    signal subg_iddr_fifo_inst_full_cmp_set: Std_logic;
    signal subg_iddr_fifo_inst_full_d_c: Std_logic;
    signal subg_iddr_fifo_inst_full_d: Std_logic;
    signal subg_iddr_fifo_full: Std_logic;
    signal wifi_iddr_fifo_inst_w_gctr_ci: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_1: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_0: Std_logic;
    signal wifi_iddr_fifo_inst_iwcount_1: Std_logic;
    signal wifi_iddr_fifo_inst_iwcount_0: Std_logic;
    signal wifi_iddr_fifo_inst_wren_i: Std_logic;
    signal wifi_iddr_fifo_inst_co0: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_3: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_2: Std_logic;
    signal wifi_iddr_fifo_inst_iwcount_3: Std_logic;
    signal wifi_iddr_fifo_inst_iwcount_2: Std_logic;
    signal wifi_iddr_fifo_inst_co1: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_4: Std_logic;
    signal wifi_iddr_fifo_inst_iwcount_4: Std_logic;
    signal wifi_iddr_fifo_inst_r_gctr_ci: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_1: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_0: Std_logic;
    signal wifi_iddr_fifo_inst_ircount_1: Std_logic;
    signal wifi_iddr_fifo_inst_ircount_0: Std_logic;
    signal wifi_iddr_fifo_inst_rden_i: Std_logic;
    signal wifi_iddr_fifo_inst_co0_1: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_3: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_2: Std_logic;
    signal wifi_iddr_fifo_inst_ircount_3: Std_logic;
    signal wifi_iddr_fifo_inst_ircount_2: Std_logic;
    signal wifi_iddr_fifo_inst_co1_1: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_4: Std_logic;
    signal wifi_iddr_fifo_inst_ircount_4: Std_logic;
    signal wifi_iddr_fifo_inst_cmp_ci: Std_logic;
    signal wifi_iddr_fifo_inst_w_g2b_xor_cluster_0: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_r0: Std_logic;
    signal wifi_iddr_fifo_inst_co0_2: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_r3: Std_logic;
    signal wifi_iddr_fifo_inst_wcount_r2: Std_logic;
    signal wifi_iddr_fifo_inst_co1_2: Std_logic;
    signal wifi_iddr_fifo_inst_empty_cmp_clr: Std_logic;
    signal wifi_iddr_fifo_inst_empty_cmp_set: Std_logic;
    signal wifi_iddr_fifo_inst_empty_d_c: Std_logic;
    signal wifi_iddr_fifo_inst_empty_d: Std_logic;
    signal wifi_iddr_fifo_empty: Std_logic;
    signal wifi_iddr_fifo_inst_cmp_ci_1: Std_logic;
    signal wifi_iddr_fifo_inst_r_g2b_xor_cluster_0: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_w0: Std_logic;
    signal wifi_iddr_fifo_inst_co0_3: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_w3: Std_logic;
    signal wifi_iddr_fifo_inst_rcount_w2: Std_logic;
    signal wifi_iddr_fifo_inst_co1_3: Std_logic;
    signal wifi_iddr_fifo_inst_full_cmp_clr: Std_logic;
    signal wifi_iddr_fifo_inst_full_cmp_set: Std_logic;
    signal wifi_iddr_fifo_inst_full_d_c: Std_logic;
    signal wifi_iddr_fifo_inst_full_d: Std_logic;
    signal wifi_iddr_fifo_full: Std_logic;
    signal sdr_rxclk_c: Std_logic;
    signal subg_iddr_sdr_rxclk_last: Std_logic;
    signal data_rising: Std_logic;
    signal my_led_n2721: Std_logic;
    signal my_led_n2781: Std_logic;
    signal my_led_n2739: Std_logic;
    signal my_led_n2773: Std_logic;
    signal fpga_led_c: Std_logic;
    signal my_led_led_N_63: Std_logic;
    signal fpga_ufl_p7_c: Std_logic;
    signal subg_q_spi_spi_clk_N_224: Std_logic;
    signal subg_q_spi_spi_clk_enable: Std_logic;
    signal internal_160MHz: Std_logic;
    signal subg_q_spi_shift_reg_0: Std_logic;
    signal subg_q_spi_internal_160MHz_enable_43: Std_logic;
    signal fpga_ufl_p8_c: Std_logic;
    signal r_phase_count_2: Std_logic;
    signal r_phase_count_1: Std_logic;
    signal r_phase_count_0: Std_logic;
    signal w_lvds_rx_09_d0: Std_logic;
    signal o_debug_state_0: Std_logic;
    signal n2949: Std_logic;
    signal w_lvds_rx_09_d1: Std_logic;
    signal lvds_rx_09_inst_n1: Std_logic;
    signal subg_ddr_data_valid: Std_logic;
    signal lvds_rx_09_inst_n1924: Std_logic;
    signal lvds_rx_09_inst_n2765: Std_logic;
    signal o_debug_state_1: Std_logic;
    signal lvds_rx_09_inst_n2929: Std_logic;
    signal lvds_rx_09_inst_n2749: Std_logic;
    signal lvds_rx_09_inst_o_debug_state_1_N_121_1: Std_logic;
    signal r_phase_count_2_adj_232: Std_logic;
    signal r_phase_count_1_adj_233: Std_logic;
    signal r_phase_count_0_adj_234: Std_logic;
    signal w_lvds_rx_24_d0: Std_logic;
    signal o_debug_state_0_adj_231: Std_logic;
    signal n2946: Std_logic;
    signal w_lvds_rx_24_d1: Std_logic;
    signal lvds_rx_24_inst_n1: Std_logic;
    signal wifi_ddr_data_valid: Std_logic;
    signal lvds_rx_24_inst_n1926: Std_logic;
    signal lvds_rx_24_inst_n2952: Std_logic;
    signal o_debug_state_1_adj_230: Std_logic;
    signal lvds_rx_24_inst_n1277: Std_logic;
    signal lvds_rx_24_inst_n2757: Std_logic;
    signal lvds_rx_24_inst_o_debug_state_1_N_121_1: Std_logic;
    signal w_rx_24_fifo_data_12: Std_logic;
    signal n552: Std_logic;
    signal n566: Std_logic;
    signal lvds_rx_24_inst_internal_80MHz_enable_56: Std_logic;
    signal o_fifo_data_0: Std_logic;
    signal o_fifo_data_14: Std_logic;
    signal w_rx_24_fifo_data_13: Std_logic;
    signal n550: Std_logic;
    signal n551: Std_logic;
    signal o_fifo_data_15: Std_logic;
    signal o_fifo_data_16: Std_logic;
    signal n2960: Std_logic;
    signal r_phase_count_2_N_123_1: Std_logic;
    signal lvds_rx_09_inst_internal_80MHz_enable_57: Std_logic;
    signal lvds_rx_09_inst_n2942: Std_logic;
    signal r_phase_count_2_N_123_2: Std_logic;
    signal n2963: Std_logic;
    signal r_phase_count_2_N_123_1_adj_236: Std_logic;
    signal lvds_rx_24_inst_internal_80MHz_enable_59: Std_logic;
    signal lvds_rx_24_inst_n2957: Std_logic;
    signal r_phase_count_2_N_123_2_adj_235: Std_logic;
    signal shift_reg_3: Std_logic;
    signal w_rx_09_fifo_data_18: Std_logic;
    signal n2947: Std_logic;
    signal spi_busy: Std_logic;
    signal shift_reg_2: Std_logic;
    signal w_rx_09_fifo_data_17: Std_logic;
    signal shift_reg_15_N_168_2: Std_logic;
    signal shift_reg_15_N_168_1: Std_logic;
    signal internal_160MHz_enable_84: Std_logic;
    signal shift_reg_1: Std_logic;
    signal shift_reg_5: Std_logic;
    signal w_rx_09_fifo_data_20: Std_logic;
    signal shift_reg_4: Std_logic;
    signal w_rx_09_fifo_data_19: Std_logic;
    signal shift_reg_15_N_168_4: Std_logic;
    signal shift_reg_15_N_168_3: Std_logic;
    signal shift_reg_7: Std_logic;
    signal w_rx_09_fifo_data_22: Std_logic;
    signal shift_reg_6: Std_logic;
    signal w_rx_09_fifo_data_21: Std_logic;
    signal shift_reg_15_N_168_6: Std_logic;
    signal shift_reg_15_N_168_5: Std_logic;
    signal shift_reg_9: Std_logic;
    signal w_rx_09_fifo_data_24: Std_logic;
    signal shift_reg_8: Std_logic;
    signal w_rx_09_fifo_data_23: Std_logic;
    signal shift_reg_15_N_168_8: Std_logic;
    signal shift_reg_15_N_168_7: Std_logic;
    signal shift_reg_11: Std_logic;
    signal w_rx_09_fifo_data_26: Std_logic;
    signal shift_reg_10: Std_logic;
    signal w_rx_09_fifo_data_25: Std_logic;
    signal shift_reg_15_N_168_10: Std_logic;
    signal shift_reg_15_N_168_9: Std_logic;
    signal shift_reg_13: Std_logic;
    signal w_rx_09_fifo_data_28: Std_logic;
    signal shift_reg_12: Std_logic;
    signal w_rx_09_fifo_data_27: Std_logic;
    signal shift_reg_15_N_168_12: Std_logic;
    signal shift_reg_15_N_168_11: Std_logic;
    signal shift_reg_15: Std_logic;
    signal w_rx_09_fifo_data_30: Std_logic;
    signal shift_reg_14: Std_logic;
    signal w_rx_09_fifo_data_29: Std_logic;
    signal shift_reg_15_N_168_14: Std_logic;
    signal shift_reg_15_N_168_13: Std_logic;
    signal w_rx_09_fifo_data_31: Std_logic;
    signal subg_i_spi_internal_160MHz_enable_25: Std_logic;
    signal shift_reg_11_adj_242: Std_logic;
    signal w_rx_09_fifo_data_10: Std_logic;
    signal spi_busy_adj_237: Std_logic;
    signal shift_reg_15_N_168_10_adj_257: Std_logic;
    signal internal_160MHz_enable_83: Std_logic;
    signal shift_reg_10_adj_243: Std_logic;
    signal shift_reg_11_adj_273: Std_logic;
    signal w_rx_24_fifo_data_27: Std_logic;
    signal n2943: Std_logic;
    signal spi_busy_adj_268: Std_logic;
    signal shift_reg_15_N_168_10_adj_288: Std_logic;
    signal internal_160MHz_enable_82: Std_logic;
    signal shift_reg_10_adj_274: Std_logic;
    signal shift_reg_11_adj_304: Std_logic;
    signal w_rx_24_fifo_data_11: Std_logic;
    signal spi_busy_adj_299: Std_logic;
    signal shift_reg_15_N_168_10_adj_319: Std_logic;
    signal internal_160MHz_enable_81: Std_logic;
    signal shift_reg_10_adj_305: Std_logic;
    signal shift_reg_12_adj_241: Std_logic;
    signal w_rx_09_fifo_data_11: Std_logic;
    signal shift_reg_15_N_168_11_adj_256: Std_logic;
    signal shift_reg_12_adj_272: Std_logic;
    signal w_rx_24_fifo_data_28: Std_logic;
    signal shift_reg_15_N_168_11_adj_287: Std_logic;
    signal shift_reg_12_adj_303: Std_logic;
    signal shift_reg_15_N_168_11_adj_318: Std_logic;
    signal shift_reg_13_adj_240: Std_logic;
    signal w_rx_09_fifo_data_12: Std_logic;
    signal shift_reg_15_N_168_12_adj_255: Std_logic;
    signal shift_reg_13_adj_271: Std_logic;
    signal w_rx_24_fifo_data_29: Std_logic;
    signal shift_reg_15_N_168_12_adj_286: Std_logic;
    signal shift_reg_13_adj_302: Std_logic;
    signal shift_reg_15_N_168_12_adj_317: Std_logic;
    signal shift_reg_14_adj_239: Std_logic;
    signal w_rx_09_fifo_data_13: Std_logic;
    signal shift_reg_15_N_168_13_adj_254: Std_logic;
    signal shift_reg_14_adj_270: Std_logic;
    signal shift_reg_15_N_168_13_adj_285: Std_logic;
    signal shift_reg_14_adj_301: Std_logic;
    signal shift_reg_15_N_168_13_adj_316: Std_logic;
    signal shift_reg_15_adj_238: Std_logic;
    signal w_rx_09_fifo_data_14: Std_logic;
    signal shift_reg_15_N_168_14_adj_253: Std_logic;
    signal shift_reg_15_adj_269: Std_logic;
    signal shift_reg_15_N_168_14_adj_284: Std_logic;
    signal shift_reg_15_adj_300: Std_logic;
    signal shift_reg_15_N_168_14_adj_315: Std_logic;
    signal w_rx_09_fifo_data_15: Std_logic;
    signal wifi_i_spi_internal_160MHz_enable_61: Std_logic;
    signal wifi_q_spi_internal_160MHz_enable_79: Std_logic;
    signal shift_reg_2_adj_251: Std_logic;
    signal w_rx_09_fifo_data_1: Std_logic;
    signal shift_reg_15_N_168_1_adj_266: Std_logic;
    signal shift_reg_1_adj_252: Std_logic;
    signal shift_reg_2_adj_282: Std_logic;
    signal w_rx_24_fifo_data_18: Std_logic;
    signal shift_reg_15_N_168_1_adj_297: Std_logic;
    signal shift_reg_1_adj_283: Std_logic;
    signal shift_reg_2_adj_313: Std_logic;
    signal w_rx_24_fifo_data_2: Std_logic;
    signal shift_reg_15_N_168_1_adj_328: Std_logic;
    signal shift_reg_1_adj_314: Std_logic;
    signal shift_reg_3_adj_250: Std_logic;
    signal w_rx_09_fifo_data_2: Std_logic;
    signal shift_reg_15_N_168_2_adj_265: Std_logic;
    signal shift_reg_3_adj_281: Std_logic;
    signal w_rx_24_fifo_data_19: Std_logic;
    signal shift_reg_15_N_168_2_adj_296: Std_logic;
    signal shift_reg_3_adj_312: Std_logic;
    signal w_rx_24_fifo_data_3: Std_logic;
    signal shift_reg_15_N_168_2_adj_327: Std_logic;
    signal shift_reg_4_adj_249: Std_logic;
    signal w_rx_09_fifo_data_3: Std_logic;
    signal shift_reg_15_N_168_3_adj_264: Std_logic;
    signal shift_reg_4_adj_280: Std_logic;
    signal w_rx_24_fifo_data_20: Std_logic;
    signal shift_reg_15_N_168_3_adj_295: Std_logic;
    signal shift_reg_4_adj_311: Std_logic;
    signal w_rx_24_fifo_data_4: Std_logic;
    signal shift_reg_15_N_168_3_adj_326: Std_logic;
    signal shift_reg_5_adj_248: Std_logic;
    signal w_rx_09_fifo_data_4: Std_logic;
    signal shift_reg_15_N_168_4_adj_263: Std_logic;
    signal shift_reg_5_adj_279: Std_logic;
    signal w_rx_24_fifo_data_21: Std_logic;
    signal shift_reg_15_N_168_4_adj_294: Std_logic;
    signal shift_reg_5_adj_310: Std_logic;
    signal w_rx_24_fifo_data_5: Std_logic;
    signal shift_reg_15_N_168_4_adj_325: Std_logic;
    signal shift_reg_6_adj_247: Std_logic;
    signal w_rx_09_fifo_data_5: Std_logic;
    signal shift_reg_15_N_168_5_adj_262: Std_logic;
    signal shift_reg_6_adj_278: Std_logic;
    signal w_rx_24_fifo_data_22: Std_logic;
    signal shift_reg_15_N_168_5_adj_293: Std_logic;
    signal shift_reg_6_adj_309: Std_logic;
    signal w_rx_24_fifo_data_6: Std_logic;
    signal shift_reg_15_N_168_5_adj_324: Std_logic;
    signal shift_reg_7_adj_246: Std_logic;
    signal w_rx_09_fifo_data_6: Std_logic;
    signal shift_reg_15_N_168_6_adj_261: Std_logic;
    signal shift_reg_7_adj_277: Std_logic;
    signal w_rx_24_fifo_data_23: Std_logic;
    signal shift_reg_15_N_168_6_adj_292: Std_logic;
    signal shift_reg_7_adj_308: Std_logic;
    signal w_rx_24_fifo_data_7: Std_logic;
    signal shift_reg_15_N_168_6_adj_323: Std_logic;
    signal shift_reg_8_adj_245: Std_logic;
    signal w_rx_09_fifo_data_7: Std_logic;
    signal shift_reg_15_N_168_7_adj_260: Std_logic;
    signal shift_reg_8_adj_276: Std_logic;
    signal w_rx_24_fifo_data_24: Std_logic;
    signal shift_reg_15_N_168_7_adj_291: Std_logic;
    signal shift_reg_8_adj_307: Std_logic;
    signal w_rx_24_fifo_data_8: Std_logic;
    signal shift_reg_15_N_168_7_adj_322: Std_logic;
    signal shift_reg_9_adj_244: Std_logic;
    signal w_rx_09_fifo_data_8: Std_logic;
    signal shift_reg_15_N_168_8_adj_259: Std_logic;
    signal shift_reg_9_adj_275: Std_logic;
    signal w_rx_24_fifo_data_25: Std_logic;
    signal shift_reg_15_N_168_8_adj_290: Std_logic;
    signal shift_reg_9_adj_306: Std_logic;
    signal w_rx_24_fifo_data_9: Std_logic;
    signal shift_reg_15_N_168_8_adj_321: Std_logic;
    signal w_rx_09_fifo_data_9: Std_logic;
    signal shift_reg_15_N_168_9_adj_258: Std_logic;
    signal w_rx_24_fifo_data_26: Std_logic;
    signal shift_reg_15_N_168_9_adj_289: Std_logic;
    signal w_rx_24_fifo_data_10: Std_logic;
    signal shift_reg_15_N_168_9_adj_320: Std_logic;
    signal subg_i_spi_shift_reg_0: Std_logic;
    signal spi1_mosi_c: Std_logic;
    signal spi1_sck_c: Std_logic;
    signal subg_i_spi_spi_clk_N_224: Std_logic;
    signal subg_i_spi_spi_clk_enable: Std_logic;
    signal wifi_i_spi_shift_reg_0: Std_logic;
    signal spi3_mosi_c: Std_logic;
    signal spi3_sck_c: Std_logic;
    signal wifi_i_spi_spi_clk_N_224: Std_logic;
    signal wifi_i_spi_spi_clk_enable: Std_logic;
    signal wifi_q_spi_shift_reg_0: Std_logic;
    signal spi4_mosi_c: Std_logic;
    signal spi4_sck_c: Std_logic;
    signal wifi_q_spi_spi_clk_N_224: Std_logic;
    signal wifi_q_spi_spi_clk_enable: Std_logic;
    signal subg_i_spi_bit_count_3: Std_logic;
    signal subg_i_spi_n8: Std_logic;
    signal subg_i_spi_bit_count_0: Std_logic;
    signal n2693: Std_logic;
    signal n3030: Std_logic;
    signal n1237: Std_logic;
    signal n2685: Std_logic;
    signal n3032: Std_logic;
    signal n2681: Std_logic;
    signal n3031: Std_logic;
    signal n1251: Std_logic;
    signal n1220: Std_logic;
    signal n2689: Std_logic;
    signal n3029: Std_logic;
    signal n1230: Std_logic;
    signal subg_iddr_fifo_empty_N_71: Std_logic;
    signal subg_i_spi_bit_count_4_N_218_0: Std_logic;
    signal n2932: Std_logic;
    signal subg_i_spi_bit_count_2: Std_logic;
    signal subg_i_spi_bit_count_1: Std_logic;
    signal subg_i_spi_n1338: Std_logic;
    signal subg_i_spi_n1342: Std_logic;
    signal subg_i_spi_n1344: Std_logic;
    signal subg_i_spi_n2934: Std_logic;
    signal stm_fpga_spare1_c: Std_logic;
    signal w_rx_09_fifo_push: Std_logic;
    signal subg_i_spi_bit_count_4: Std_logic;
    signal subg_i_spi_bit_count_4_N_184_4: Std_logic;
    signal w_rx_09_fifo_data_16: Std_logic;
    signal shift_reg_15_N_168_0: Std_logic;
    signal subg_i_spi_n2653: Std_logic;
    signal subg_i_spi_n1908: Std_logic;
    signal sdr_rx_subg_c: Std_logic;
    signal subg_iddr_data_rising_capture: Std_logic;
    signal subg_iddr_internal_200MHz_enable_3: Std_logic;
    signal subg_iddr_fifo_data_0: Std_logic;
    signal subg_iddr_fifo_data_1: Std_logic;
    signal subg_iddr_fifo_inst_r_gdata_1: Std_logic;
    signal subg_iddr_fifo_inst_r_gdata_0: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_0: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_1: Std_logic;
    signal subg_iddr_fifo_inst_r_gdata_3: Std_logic;
    signal subg_iddr_fifo_inst_r_gdata_2: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_2: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_3: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_4: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w0: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w1: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w2: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w3: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w4: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w20: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w21: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w22: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w23: Std_logic;
    signal subg_iddr_fifo_inst_r_gcount_w24: Std_logic;
    signal subg_iddr_fifo_inst_rptr_0: Std_logic;
    signal subg_iddr_fifo_inst_rptr_1: Std_logic;
    signal subg_iddr_fifo_inst_rptr_2: Std_logic;
    signal subg_iddr_fifo_inst_rptr_3: Std_logic;
    signal subg_iddr_fifo_inst_w_gdata_1: Std_logic;
    signal subg_iddr_fifo_inst_w_gdata_0: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_0: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_1: Std_logic;
    signal subg_iddr_fifo_inst_w_gdata_3: Std_logic;
    signal subg_iddr_fifo_inst_w_gdata_2: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_2: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_3: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_4: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r0: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r1: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r2: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r3: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r4: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r20: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r21: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r22: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r23: Std_logic;
    signal subg_iddr_fifo_inst_w_gcount_r24: Std_logic;
    signal subg_iddr_fifo_inst_wptr_0: Std_logic;
    signal subg_iddr_fifo_inst_wptr_1: Std_logic;
    signal subg_iddr_fifo_inst_wptr_2: Std_logic;
    signal subg_iddr_fifo_inst_wptr_3: Std_logic;
    signal subg_iddr_fifo_full_N_81: Std_logic;
    signal data_falling: Std_logic;
    signal subg_iddr_fifo_wr_en: Std_logic;
    signal subg_q_spi_bit_count_3: Std_logic;
    signal subg_q_spi_n8: Std_logic;
    signal subg_q_spi_bit_count_0: Std_logic;
    signal subg_q_spi_bit_count_4_N_218_0: Std_logic;
    signal n2938: Std_logic;
    signal subg_q_spi_bit_count_2: Std_logic;
    signal subg_q_spi_bit_count_1: Std_logic;
    signal subg_q_spi_n1332: Std_logic;
    signal subg_q_spi_n1326: Std_logic;
    signal subg_q_spi_n1322: Std_logic;
    signal subg_q_spi_n2933: Std_logic;
    signal subg_q_spi_bit_count_4: Std_logic;
    signal subg_q_spi_bit_count_4_N_184_4: Std_logic;
    signal w_rx_09_fifo_data_0: Std_logic;
    signal shift_reg_15_N_168_0_adj_267: Std_logic;
    signal subg_q_spi_n2641: Std_logic;
    signal subg_q_spi_n1900: Std_logic;
    signal subg_iddr_fifo_out_0: Std_logic;
    signal subg_iddr_fifo_out_1: Std_logic;
    signal wifi_iddr_fifo_out_0: Std_logic;
    signal wifi_iddr_fifo_out_1: Std_logic;
    signal n357: Std_logic;
    signal n358: Std_logic;
    signal lvds_rx_09_inst_internal_80MHz_enable_68: Std_logic;
    signal n355: Std_logic;
    signal n356: Std_logic;
    signal n353: Std_logic;
    signal n354: Std_logic;
    signal n351: Std_logic;
    signal n352: Std_logic;
    signal n349: Std_logic;
    signal n350: Std_logic;
    signal n347: Std_logic;
    signal n348: Std_logic;
    signal n345: Std_logic;
    signal n346: Std_logic;
    signal n343: Std_logic;
    signal n344: Std_logic;
    signal n341: Std_logic;
    signal n342: Std_logic;
    signal n339: Std_logic;
    signal n340: Std_logic;
    signal n337: Std_logic;
    signal n338: Std_logic;
    signal n335: Std_logic;
    signal n336: Std_logic;
    signal n333: Std_logic;
    signal n334: Std_logic;
    signal n331: Std_logic;
    signal n332: Std_logic;
    signal n329: Std_logic;
    signal n330: Std_logic;
    signal n327: Std_logic;
    signal n328: Std_logic;
    signal lvds_rx_09_inst_o_fifo_push_N_159: Std_logic;
    signal lvds_rx_09_inst_internal_80MHz_enable_30: Std_logic;
    signal n564: Std_logic;
    signal n2259: Std_logic;
    signal w_rx_24_fifo_data_1: Std_logic;
    signal n562: Std_logic;
    signal n563: Std_logic;
    signal n560: Std_logic;
    signal n561: Std_logic;
    signal n558: Std_logic;
    signal n559: Std_logic;
    signal n556: Std_logic;
    signal n557: Std_logic;
    signal n554: Std_logic;
    signal n555: Std_logic;
    signal n549: Std_logic;
    signal n553: Std_logic;
    signal w_rx_24_fifo_data_17: Std_logic;
    signal n547: Std_logic;
    signal n548: Std_logic;
    signal n545: Std_logic;
    signal n546: Std_logic;
    signal n543: Std_logic;
    signal n544: Std_logic;
    signal n541: Std_logic;
    signal n542: Std_logic;
    signal n539: Std_logic;
    signal n540: Std_logic;
    signal n537: Std_logic;
    signal n538: Std_logic;
    signal lvds_rx_24_inst_o_fifo_push_N_159: Std_logic;
    signal lvds_rx_24_inst_internal_80MHz_enable_17: Std_logic;
    signal w_rx_24_fifo_push: Std_logic;
    signal wifi_iddr_fifo_empty_N_71: Std_logic;
    signal wifi_i_spi_bit_count_3: Std_logic;
    signal wifi_i_spi_n8: Std_logic;
    signal wifi_i_spi_bit_count_0: Std_logic;
    signal wifi_i_spi_bit_count_4_N_218_0: Std_logic;
    signal n2931: Std_logic;
    signal wifi_i_spi_bit_count_2: Std_logic;
    signal wifi_i_spi_bit_count_1: Std_logic;
    signal wifi_i_spi_n1316: Std_logic;
    signal wifi_i_spi_n1312: Std_logic;
    signal wifi_i_spi_n1324: Std_logic;
    signal wifi_i_spi_n2930: Std_logic;
    signal stm_fpga_spare2_c: Std_logic;
    signal wifi_i_spi_bit_count_4: Std_logic;
    signal wifi_i_spi_bit_count_4_N_184_4: Std_logic;
    signal shift_reg_15_N_168_0_adj_298: Std_logic;
    signal wifi_i_spi_n2649: Std_logic;
    signal wifi_i_spi_n1922: Std_logic;
    signal sdr_rx_wifi_c: Std_logic;
    signal wifi_iddr_data_rising_capture: Std_logic;
    signal wifi_iddr_internal_200MHz_enable_4: Std_logic;
    signal wifi_iddr_fifo_data_0: Std_logic;
    signal wifi_iddr_fifo_data_1: Std_logic;
    signal wifi_iddr_fifo_inst_r_gdata_1: Std_logic;
    signal wifi_iddr_fifo_inst_r_gdata_0: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_0: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_1: Std_logic;
    signal wifi_iddr_fifo_inst_r_gdata_3: Std_logic;
    signal wifi_iddr_fifo_inst_r_gdata_2: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_2: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_3: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_4: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w0: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w1: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w2: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w3: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w4: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w20: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w21: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w22: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w23: Std_logic;
    signal wifi_iddr_fifo_inst_r_gcount_w24: Std_logic;
    signal wifi_iddr_fifo_inst_rptr_0: Std_logic;
    signal wifi_iddr_fifo_inst_rptr_1: Std_logic;
    signal wifi_iddr_fifo_inst_rptr_2: Std_logic;
    signal wifi_iddr_fifo_inst_rptr_3: Std_logic;
    signal wifi_iddr_fifo_inst_w_gdata_1: Std_logic;
    signal wifi_iddr_fifo_inst_w_gdata_0: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_0: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_1: Std_logic;
    signal wifi_iddr_fifo_inst_w_gdata_3: Std_logic;
    signal wifi_iddr_fifo_inst_w_gdata_2: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_2: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_3: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_4: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r0: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r1: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r2: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r3: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r4: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r20: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r21: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r22: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r23: Std_logic;
    signal wifi_iddr_fifo_inst_w_gcount_r24: Std_logic;
    signal wifi_iddr_fifo_inst_wptr_0: Std_logic;
    signal wifi_iddr_fifo_inst_wptr_1: Std_logic;
    signal wifi_iddr_fifo_inst_wptr_2: Std_logic;
    signal wifi_iddr_fifo_inst_wptr_3: Std_logic;
    signal wifi_iddr_n2950: Std_logic;
    signal wifi_iddr_fifo_wr_en: Std_logic;
    signal wifi_q_spi_bit_count_0: Std_logic;
    signal wifi_q_spi_bit_count_4_N_218_0: Std_logic;
    signal n2935: Std_logic;
    signal wifi_q_spi_bit_count_2: Std_logic;
    signal wifi_q_spi_bit_count_1: Std_logic;
    signal wifi_q_spi_n1336: Std_logic;
    signal wifi_q_spi_n1334: Std_logic;
    signal wifi_q_spi_bit_count_3: Std_logic;
    signal wifi_q_spi_n8: Std_logic;
    signal wifi_q_spi_n1330: Std_logic;
    signal wifi_q_spi_n2941: Std_logic;
    signal wifi_q_spi_bit_count_4: Std_logic;
    signal wifi_q_spi_bit_count_4_N_184_4: Std_logic;
    signal shift_reg_15_N_168_0_adj_329: Std_logic;
    signal wifi_q_spi_n2645: Std_logic;
    signal wifi_q_spi_n1905: Std_logic;
    signal lvds_rx_24_inst_n2951: Std_logic;
    signal lvds_rx_24_inst_n2663: Std_logic;
    signal lvds_rx_24_inst_n2612: Std_logic;
    signal my_led_n2717: Std_logic;
    signal my_led_n2725: Std_logic;
    signal my_led_n2713: Std_logic;
    signal my_led_n2701: Std_logic;
    signal my_led_n2699: Std_logic;
    signal my_led_n2705: Std_logic;
    signal lvds_rx_09_inst_n2945: Std_logic;
    signal n1766: Std_logic;
    signal lvds_rx_09_inst_n2677: Std_logic;
    signal n2955: Std_logic;
    signal second_pll_lock: Std_logic;
    signal stm_fpga_spare5_c: Std_logic;
    signal pll_lock: Std_logic;
    signal lvds_rx_24_inst_n2498: Std_logic;
    signal n2629: Std_logic;
    signal lvds_rx_09_inst_n2496: Std_logic;
    signal n2627: Std_logic;
    signal subg_iddr_fifo_inst_rptr_4: Std_logic;
    signal subg_iddr_fifo_inst_wptr_4: Std_logic;
    signal wifi_iddr_fifo_inst_rptr_4: Std_logic;
    signal wifi_iddr_fifo_inst_wptr_4: Std_logic;
    signal stm_fpga_spare5_N_9: Std_logic;
    signal GND_net: Std_logic;
    signal dpll_clkout2_c: Std_logic;
    signal dpll_clkout0_c: Std_logic;
    signal my_pll_CLKOP: Std_logic;
    signal VCCI: Std_logic;
    component fpga_ledB
      port (PADDO: in Std_logic; fpgaled: out Std_logic);
    end component;
    component fpga_neopixelB
      port (fpganeopixel: out Std_logic);
    end component;
    component sdr_txclkB
      port (sdrtxclk: out Std_logic);
    end component;
    component sdr_txdataB
      port (sdrtxdata: out Std_logic);
    end component;
    component spi1_sckB
      port (PADDO: in Std_logic; spi1sck: out Std_logic);
    end component;
    component spi1_mosiB
      port (PADDO: in Std_logic; spi1mosi: out Std_logic);
    end component;
    component spi2_sckB
      port (PADDO: in Std_logic; spi2sck: out Std_logic);
    end component;
    component spi2_mosiB
      port (PADDO: in Std_logic; spi2mosi: out Std_logic);
    end component;
    component spi3_sckB
      port (PADDO: in Std_logic; spi3sck: out Std_logic);
    end component;
    component spi3_mosiB
      port (PADDO: in Std_logic; spi3mosi: out Std_logic);
    end component;
    component spi4_sckB
      port (PADDO: in Std_logic; spi4sck: out Std_logic);
    end component;
    component spi4_mosiB
      port (PADDO: in Std_logic; spi4mosi: out Std_logic);
    end component;
    component fpga_ufl_p7B
      port (PADDO: in Std_logic; fpgauflp7: out Std_logic);
    end component;
    component fpga_ufl_p8B
      port (PADDO: in Std_logic; fpgauflp8: out Std_logic);
    end component;
    component dpll_clkout2B
      port (PADDI: out Std_logic; dpllclkout2: in Std_logic);
    end component;
    component dpll_clkout0B
      port (PADDI: out Std_logic; dpllclkout0: in Std_logic);
    end component;
    component sdr_rx_wifiB
      port (PADDI: out Std_logic; sdrrxwifi: in Std_logic);
    end component;
    component sdr_rx_subgB
      port (PADDI: out Std_logic; sdrrxsubg: in Std_logic);
    end component;
    component sdr_rxclkB
      port (PADDI: out Std_logic; sdrrxclk: in Std_logic);
    end component;
    component stm_fpga_spare1B
      port (PADDI: out Std_logic; stmfpgaspare1: in Std_logic);
    end component;
    component stm_fpga_spare2B
      port (PADDI: out Std_logic; stmfpgaspare2: in Std_logic);
    end component;
    component stm_fpga_spare5B
      port (PADDI: out Std_logic; stmfpgaspare5: in Std_logic);
    end component;
    component my_pll_PLLInst_0
      port (CLKI: in Std_logic; CLKFB: in Std_logic; STDBY: in Std_logic; 
            RST: in Std_logic; LOCK: out Std_logic; CLKOS2: out Std_logic; 
            CLKOS: out Std_logic; CLKOP: out Std_logic);
    end component;
    component osch_inst
      port (OSC: out Std_logic);
    end component;
    component subg_iddr_fifo_inst_pdp_ram_0_0_0
      port (DIA1: in Std_logic; DIA0: in Std_logic; ADA4: in Std_logic; 
            ADA3: in Std_logic; ADA2: in Std_logic; ADA1: in Std_logic; 
            CEA: in Std_logic; OCEA: in Std_logic; RSTA: in Std_logic; 
            CLKA: in Std_logic; CLKB: in Std_logic; RSTB: in Std_logic; 
            OCEB: in Std_logic; CEB: in Std_logic; DOB0: out Std_logic; 
            DOB1: out Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
            ADB3: in Std_logic; ADB4: in Std_logic);
    end component;
    component second_pll_PLLInst_0
      port (CLKI: in Std_logic; CLKFB: in Std_logic; STDBY: in Std_logic; 
            RST: in Std_logic; LOCK: out Std_logic; CLKOP: out Std_logic);
    end component;
    component wifi_iddr_fifo_inst_pdp_ram_0_0_0
      port (DIA1: in Std_logic; DIA0: in Std_logic; ADA4: in Std_logic; 
            ADA3: in Std_logic; ADA2: in Std_logic; ADA1: in Std_logic; 
            CEA: in Std_logic; OCEA: in Std_logic; RSTA: in Std_logic; 
            CLKA: in Std_logic; CLKB: in Std_logic; RSTB: in Std_logic; 
            OCEB: in Std_logic; CEB: in Std_logic; DOB0: out Std_logic; 
            DOB1: out Std_logic; ADB1: in Std_logic; ADB2: in Std_logic; 
            ADB3: in Std_logic; ADB4: in Std_logic);
    end component;
    component GSR_INSTB
      port (GSRNET: in Std_logic);
    end component;
  begin
    my_led_SLICE_0I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_2, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n133, DI0=>my_led_n134, A0=>my_led_counter_1, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2360, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2361, 
                F1=>my_led_n133, Q1=>my_led_counter_2, F0=>my_led_n134, 
                Q0=>my_led_counter_1);
    my_led_SLICE_1I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>my_led_n110, A0=>my_led_counter_25, B0=>'X', C0=>'X', 
                D0=>'1', FCI=>my_led_n2372, M0=>'X', CE=>'X', CLK=>int_clk_out, 
                LSR=>my_led_n1943, FCO=>open, F1=>open, Q1=>open, 
                F0=>my_led_n110, Q0=>my_led_counter_25);
    my_led_SLICE_2I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_24, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n111, DI0=>my_led_n112, A0=>my_led_counter_23, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2371, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2372, 
                F1=>my_led_n111, Q1=>my_led_counter_24, F0=>my_led_n112, 
                Q0=>my_led_counter_23);
    my_led_SLICE_3I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_22, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n113, DI0=>my_led_n114, A0=>my_led_counter_21, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2370, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2371, 
                F1=>my_led_n113, Q1=>my_led_counter_22, F0=>my_led_n114, 
                Q0=>my_led_counter_21);
    my_led_SLICE_4I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_20, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n115, DI0=>my_led_n116, A0=>my_led_counter_19, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2369, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2370, 
                F1=>my_led_n115, Q1=>my_led_counter_20, F0=>my_led_n116, 
                Q0=>my_led_counter_19);
    my_led_SLICE_5I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_18, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n117, DI0=>my_led_n118, A0=>my_led_counter_17, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2368, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2369, 
                F1=>my_led_n117, Q1=>my_led_counter_18, F0=>my_led_n118, 
                Q0=>my_led_counter_17);
    my_led_SLICE_6I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_16, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n119, DI0=>my_led_n120, A0=>my_led_counter_15, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2367, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2368, 
                F1=>my_led_n119, Q1=>my_led_counter_16, F0=>my_led_n120, 
                Q0=>my_led_counter_15);
    my_led_SLICE_7I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_14, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n121, DI0=>my_led_n122, A0=>my_led_counter_13, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2366, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2367, 
                F1=>my_led_n121, Q1=>my_led_counter_14, F0=>my_led_n122, 
                Q0=>my_led_counter_13);
    my_led_SLICE_8I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_12, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n123, DI0=>my_led_n124, A0=>my_led_counter_11, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2365, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2366, 
                F1=>my_led_n123, Q1=>my_led_counter_12, F0=>my_led_n124, 
                Q0=>my_led_counter_11);
    my_led_SLICE_9I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_6, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n129, DI0=>my_led_n130, A0=>my_led_counter_5, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2362, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2363, 
                F1=>my_led_n129, Q1=>my_led_counter_6, F0=>my_led_n130, 
                Q0=>my_led_counter_5);
    my_led_SLICE_10I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_10, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n125, DI0=>my_led_n126, A0=>my_led_counter_9, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2364, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2365, 
                F1=>my_led_n125, Q1=>my_led_counter_10, F0=>my_led_n126, 
                Q0=>my_led_counter_9);
    my_led_SLICE_11I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_8, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n127, DI0=>my_led_n128, A0=>my_led_counter_7, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2363, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2364, 
                F1=>my_led_n127, Q1=>my_led_counter_8, F0=>my_led_n128, 
                Q0=>my_led_counter_7);
    my_led_SLICE_12I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"55FF", 
                   REG1_SD=>"VHI", CHECK_DI1=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_0, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n135, DI0=>'X', A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                FCI=>'X', M0=>'X', CE=>'X', CLK=>int_clk_out, 
                LSR=>my_led_n1943, FCO=>my_led_n2360, F1=>my_led_n135, 
                Q1=>my_led_counter_0, F0=>open, Q0=>open);
    my_led_SLICE_13I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"AA00", INIT1_INITVAL=>X"AA00", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>my_led_counter_4, B1=>'X', C1=>'X', D1=>'1', 
                DI1=>my_led_n131, DI0=>my_led_n132, A0=>my_led_counter_3, 
                B0=>'X', C0=>'X', D0=>'1', FCI=>my_led_n2361, M0=>'X', CE=>'X', 
                CLK=>int_clk_out, LSR=>my_led_n1943, FCO=>my_led_n2362, 
                F1=>my_led_n131, Q1=>my_led_counter_4, F0=>my_led_n132, 
                Q0=>my_led_counter_3);
    subg_iddr_fifo_inst_SLICE_14I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>'1', B1=>'1', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>subg_iddr_fifo_inst_w_gctr_ci, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_15I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", REG0_REGSET=>"SET", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"AAAA", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_wcount_1, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>subg_iddr_fifo_inst_iwcount_1, 
                DI0=>subg_iddr_fifo_inst_iwcount_0, 
                A0=>subg_iddr_fifo_inst_wcount_0, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_w_gctr_ci, M0=>'X', 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                FCO=>subg_iddr_fifo_inst_co0, 
                F1=>subg_iddr_fifo_inst_iwcount_1, 
                Q1=>subg_iddr_fifo_inst_wcount_1, 
                F0=>subg_iddr_fifo_inst_iwcount_0, 
                Q0=>subg_iddr_fifo_inst_wcount_0);
    subg_iddr_fifo_inst_SLICE_16I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"AAAA", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_wcount_3, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>subg_iddr_fifo_inst_iwcount_3, 
                DI0=>subg_iddr_fifo_inst_iwcount_2, 
                A0=>subg_iddr_fifo_inst_wcount_2, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co0, M0=>'X', 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                FCO=>subg_iddr_fifo_inst_co1, 
                F1=>subg_iddr_fifo_inst_iwcount_3, 
                Q1=>subg_iddr_fifo_inst_wcount_3, 
                F0=>subg_iddr_fifo_inst_iwcount_2, 
                Q0=>subg_iddr_fifo_inst_wcount_2);
    subg_iddr_fifo_inst_SLICE_17I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>subg_iddr_fifo_inst_iwcount_4, 
                A0=>subg_iddr_fifo_inst_wcount_4, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co1, M0=>'X', 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                FCO=>open, F1=>open, Q1=>open, 
                F0=>subg_iddr_fifo_inst_iwcount_4, 
                Q0=>subg_iddr_fifo_inst_wcount_4);
    subg_iddr_fifo_inst_SLICE_18I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>'1', B1=>'1', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>subg_iddr_fifo_inst_r_gctr_ci, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_19I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", INIT0_INITVAL=>X"AAAA", 
                   INIT1_INITVAL=>X"AAAA", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_rcount_1, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>subg_iddr_fifo_inst_ircount_1, 
                DI0=>subg_iddr_fifo_inst_ircount_0, 
                A0=>subg_iddr_fifo_inst_rcount_0, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_r_gctr_ci, M0=>'X', 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, FCO=>subg_iddr_fifo_inst_co0_1, 
                F1=>subg_iddr_fifo_inst_ircount_1, 
                Q1=>subg_iddr_fifo_inst_rcount_1, 
                F0=>subg_iddr_fifo_inst_ircount_0, 
                Q0=>subg_iddr_fifo_inst_rcount_0);
    subg_iddr_fifo_inst_SLICE_20I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"AAAA", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_rcount_3, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>subg_iddr_fifo_inst_ircount_3, 
                DI0=>subg_iddr_fifo_inst_ircount_2, 
                A0=>subg_iddr_fifo_inst_rcount_2, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co0_1, M0=>'X', 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, FCO=>subg_iddr_fifo_inst_co1_1, 
                F1=>subg_iddr_fifo_inst_ircount_3, 
                Q1=>subg_iddr_fifo_inst_rcount_3, 
                F0=>subg_iddr_fifo_inst_ircount_2, 
                Q0=>subg_iddr_fifo_inst_rcount_2);
    subg_iddr_fifo_inst_SLICE_21I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>subg_iddr_fifo_inst_ircount_4, 
                A0=>subg_iddr_fifo_inst_rcount_4, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co1_1, M0=>'X', 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, FCO=>open, F1=>open, Q1=>open, 
                F0=>subg_iddr_fifo_inst_ircount_4, 
                Q0=>subg_iddr_fifo_inst_rcount_4);
    subg_iddr_fifo_inst_SLICE_22I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_rden_i, 
                B1=>subg_iddr_fifo_inst_rden_i, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>subg_iddr_fifo_inst_cmp_ci, F1=>open, Q1=>open, F0=>open, 
                Q0=>open);
    subg_iddr_fifo_inst_SLICE_23I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_rcount_1, 
                B1=>subg_iddr_fifo_inst_w_g2b_xor_cluster_0, C1=>'1', D1=>'1', 
                DI1=>'X', DI0=>'X', A0=>subg_iddr_fifo_inst_rcount_0, 
                B0=>subg_iddr_fifo_inst_wcount_r0, C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_cmp_ci, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>subg_iddr_fifo_inst_co0_2, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_24I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_rcount_3, 
                B1=>subg_iddr_fifo_inst_wcount_r3, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>subg_iddr_fifo_inst_rcount_2, 
                B0=>subg_iddr_fifo_inst_wcount_r2, C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co0_2, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>subg_iddr_fifo_inst_co1_2, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_25I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"FF00")
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>subg_iddr_fifo_inst_empty_cmp_set, 
                B0=>subg_iddr_fifo_inst_empty_cmp_clr, C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co1_2, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>subg_iddr_fifo_inst_empty_d_c, F1=>open, 
                Q1=>open, F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_26I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", INIT0_INITVAL=>X"0000", 
                   INIT1_INITVAL=>X"0000", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>subg_iddr_fifo_inst_empty_d, A0=>'X', B0=>'X', C0=>'1', 
                D0=>'1', FCI=>subg_iddr_fifo_inst_empty_d_c, M0=>'X', CE=>'X', 
                CLK=>internal_80MHz, LSR=>main_reset_n_N_4, FCO=>open, 
                F1=>open, Q1=>open, F0=>subg_iddr_fifo_inst_empty_d, 
                Q0=>subg_iddr_fifo_empty);
    subg_iddr_fifo_inst_SLICE_27I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_wren_i, 
                B1=>subg_iddr_fifo_inst_wren_i, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>subg_iddr_fifo_inst_cmp_ci_1, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_28I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_wcount_1, 
                B1=>subg_iddr_fifo_inst_r_g2b_xor_cluster_0, C1=>'1', D1=>'1', 
                DI1=>'X', DI0=>'X', A0=>subg_iddr_fifo_inst_wcount_0, 
                B0=>subg_iddr_fifo_inst_rcount_w0, C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_cmp_ci_1, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>subg_iddr_fifo_inst_co0_3, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_29I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>subg_iddr_fifo_inst_wcount_3, 
                B1=>subg_iddr_fifo_inst_rcount_w3, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>subg_iddr_fifo_inst_wcount_2, 
                B0=>subg_iddr_fifo_inst_rcount_w2, C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co0_3, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>subg_iddr_fifo_inst_co1_3, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_30I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"FF00")
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>subg_iddr_fifo_inst_full_cmp_set, 
                B0=>subg_iddr_fifo_inst_full_cmp_clr, C0=>'1', D0=>'1', 
                FCI=>subg_iddr_fifo_inst_co1_3, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>subg_iddr_fifo_inst_full_d_c, F1=>open, 
                Q1=>open, F0=>open, Q0=>open);
    subg_iddr_fifo_inst_SLICE_31I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>subg_iddr_fifo_inst_full_d, A0=>'X', B0=>'X', C0=>'1', 
                D0=>'1', FCI=>subg_iddr_fifo_inst_full_d_c, M0=>'X', CE=>'X', 
                CLK=>internal_200MHz, LSR=>'X', FCO=>open, F1=>open, Q1=>open, 
                F0=>subg_iddr_fifo_inst_full_d, Q0=>subg_iddr_fifo_full);
    wifi_iddr_fifo_inst_SLICE_32I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>'1', B1=>'1', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>wifi_iddr_fifo_inst_w_gctr_ci, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_33I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", REG0_REGSET=>"SET", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"AAAA", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_wcount_1, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>wifi_iddr_fifo_inst_iwcount_1, 
                DI0=>wifi_iddr_fifo_inst_iwcount_0, 
                A0=>wifi_iddr_fifo_inst_wcount_0, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_w_gctr_ci, M0=>'X', 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                FCO=>wifi_iddr_fifo_inst_co0, 
                F1=>wifi_iddr_fifo_inst_iwcount_1, 
                Q1=>wifi_iddr_fifo_inst_wcount_1, 
                F0=>wifi_iddr_fifo_inst_iwcount_0, 
                Q0=>wifi_iddr_fifo_inst_wcount_0);
    wifi_iddr_fifo_inst_SLICE_34I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"AAAA", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_wcount_3, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>wifi_iddr_fifo_inst_iwcount_3, 
                DI0=>wifi_iddr_fifo_inst_iwcount_2, 
                A0=>wifi_iddr_fifo_inst_wcount_2, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co0, M0=>'X', 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                FCO=>wifi_iddr_fifo_inst_co1, 
                F1=>wifi_iddr_fifo_inst_iwcount_3, 
                Q1=>wifi_iddr_fifo_inst_wcount_3, 
                F0=>wifi_iddr_fifo_inst_iwcount_2, 
                Q0=>wifi_iddr_fifo_inst_wcount_2);
    wifi_iddr_fifo_inst_SLICE_35I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>wifi_iddr_fifo_inst_iwcount_4, 
                A0=>wifi_iddr_fifo_inst_wcount_4, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co1, M0=>'X', 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                FCO=>open, F1=>open, Q1=>open, 
                F0=>wifi_iddr_fifo_inst_iwcount_4, 
                Q0=>wifi_iddr_fifo_inst_wcount_4);
    wifi_iddr_fifo_inst_SLICE_36I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>'1', B1=>'1', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>wifi_iddr_fifo_inst_r_gctr_ci, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_37I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", INIT0_INITVAL=>X"AAAA", 
                   INIT1_INITVAL=>X"AAAA", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_rcount_1, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>wifi_iddr_fifo_inst_ircount_1, 
                DI0=>wifi_iddr_fifo_inst_ircount_0, 
                A0=>wifi_iddr_fifo_inst_rcount_0, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_r_gctr_ci, M0=>'X', 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, FCO=>wifi_iddr_fifo_inst_co0_1, 
                F1=>wifi_iddr_fifo_inst_ircount_1, 
                Q1=>wifi_iddr_fifo_inst_rcount_1, 
                F0=>wifi_iddr_fifo_inst_ircount_0, 
                Q0=>wifi_iddr_fifo_inst_rcount_0);
    wifi_iddr_fifo_inst_SLICE_38I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"AAAA", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_rcount_3, B1=>'X', C1=>'1', 
                D1=>'1', DI1=>wifi_iddr_fifo_inst_ircount_3, 
                DI0=>wifi_iddr_fifo_inst_ircount_2, 
                A0=>wifi_iddr_fifo_inst_rcount_2, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co0_1, M0=>'X', 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, FCO=>wifi_iddr_fifo_inst_co1_1, 
                F1=>wifi_iddr_fifo_inst_ircount_3, 
                Q1=>wifi_iddr_fifo_inst_rcount_3, 
                F0=>wifi_iddr_fifo_inst_ircount_2, 
                Q0=>wifi_iddr_fifo_inst_rcount_2);
    wifi_iddr_fifo_inst_SLICE_39I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"AAAA", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>wifi_iddr_fifo_inst_ircount_4, 
                A0=>wifi_iddr_fifo_inst_rcount_4, B0=>'X', C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co1_1, M0=>'X', 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, FCO=>open, F1=>open, Q1=>open, 
                F0=>wifi_iddr_fifo_inst_ircount_4, 
                Q0=>wifi_iddr_fifo_inst_rcount_4);
    wifi_iddr_fifo_inst_SLICE_40I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_rden_i, 
                B1=>wifi_iddr_fifo_inst_rden_i, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>wifi_iddr_fifo_inst_cmp_ci, F1=>open, Q1=>open, F0=>open, 
                Q0=>open);
    wifi_iddr_fifo_inst_SLICE_41I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_rcount_1, 
                B1=>wifi_iddr_fifo_inst_w_g2b_xor_cluster_0, C1=>'1', D1=>'1', 
                DI1=>'X', DI0=>'X', A0=>wifi_iddr_fifo_inst_rcount_0, 
                B0=>wifi_iddr_fifo_inst_wcount_r0, C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_cmp_ci, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>wifi_iddr_fifo_inst_co0_2, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_42I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_rcount_3, 
                B1=>wifi_iddr_fifo_inst_wcount_r3, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>wifi_iddr_fifo_inst_rcount_2, 
                B0=>wifi_iddr_fifo_inst_wcount_r2, C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co0_2, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>wifi_iddr_fifo_inst_co1_2, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_43I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"FF00")
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>wifi_iddr_fifo_inst_empty_cmp_set, 
                B0=>wifi_iddr_fifo_inst_empty_cmp_clr, C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co1_2, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>wifi_iddr_fifo_inst_empty_d_c, F1=>open, 
                Q1=>open, F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_44I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", INIT0_INITVAL=>X"0000", 
                   INIT1_INITVAL=>X"0000", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>wifi_iddr_fifo_inst_empty_d, A0=>'X', B0=>'X', C0=>'1', 
                D0=>'1', FCI=>wifi_iddr_fifo_inst_empty_d_c, M0=>'X', CE=>'X', 
                CLK=>internal_80MHz, LSR=>main_reset_n_N_4, FCO=>open, 
                F1=>open, Q1=>open, F0=>wifi_iddr_fifo_inst_empty_d, 
                Q0=>wifi_iddr_fifo_empty);
    wifi_iddr_fifo_inst_SLICE_45I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"66AA")
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_wren_i, 
                B1=>wifi_iddr_fifo_inst_wren_i, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>'X', B0=>'X', C0=>'1', D0=>'1', FCI=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                FCO=>wifi_iddr_fifo_inst_cmp_ci_1, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_46I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_wcount_1, 
                B1=>wifi_iddr_fifo_inst_r_g2b_xor_cluster_0, C1=>'1', D1=>'1', 
                DI1=>'X', DI0=>'X', A0=>wifi_iddr_fifo_inst_wcount_0, 
                B0=>wifi_iddr_fifo_inst_rcount_w0, C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_cmp_ci_1, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>wifi_iddr_fifo_inst_co0_3, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_47I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"99AA")
      port map (M1=>'X', A1=>wifi_iddr_fifo_inst_wcount_3, 
                B1=>wifi_iddr_fifo_inst_rcount_w3, C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>wifi_iddr_fifo_inst_wcount_2, 
                B0=>wifi_iddr_fifo_inst_rcount_w2, C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co0_3, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>wifi_iddr_fifo_inst_co1_3, F1=>open, Q1=>open, 
                F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_48I: SCCU2C
      generic map (CCU2_INJECT1_0=>"NO", CCU2_INJECT1_1=>"NO", 
                   INIT0_INITVAL=>X"99AA", INIT1_INITVAL=>X"FF00")
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>'X', A0=>wifi_iddr_fifo_inst_full_cmp_set, 
                B0=>wifi_iddr_fifo_inst_full_cmp_clr, C0=>'1', D0=>'1', 
                FCI=>wifi_iddr_fifo_inst_co1_3, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', FCO=>wifi_iddr_fifo_inst_full_d_c, F1=>open, 
                Q1=>open, F0=>open, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_49I: SCCU2C
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", CCU2_INJECT1_0=>"NO", 
                   CCU2_INJECT1_1=>"NO", SRMODE=>"ASYNC", 
                   INIT0_INITVAL=>X"0000", INIT1_INITVAL=>X"0000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', A1=>'X', B1=>'X', C1=>'1', D1=>'1', DI1=>'X', 
                DI0=>wifi_iddr_fifo_inst_full_d, A0=>'X', B0=>'X', C0=>'1', 
                D0=>'1', FCI=>wifi_iddr_fifo_inst_full_d_c, M0=>'X', CE=>'X', 
                CLK=>internal_200MHz, LSR=>'X', FCO=>open, F1=>open, Q1=>open, 
                F0=>wifi_iddr_fifo_inst_full_d, Q0=>wifi_iddr_fifo_full);
    subg_iddr_SLICE_51I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>sdr_rxclk_c, CE=>'X', CLK=>internal_200MHz, 
                LSR=>subg_iddr_sdr_rxclk_last, OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>open, F0=>open, Q0=>data_rising);
    my_led_SLICE_52I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"0020", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>my_led_n2773, 
                B1=>my_led_n2739, C1=>my_led_n2781, D1=>my_led_n2721, DI1=>'X', 
                DI0=>my_led_led_N_63, A0=>fpga_led_c, B0=>my_led_n1943, 
                C0=>'X', D0=>'X', M0=>'X', CE=>'X', CLK=>int_clk_out, LSR=>'X', 
                OFX1=>open, F1=>my_led_n1943, Q1=>open, OFX0=>open, 
                F0=>my_led_led_N_63, Q0=>fpga_led_c);
    subg_q_spi_SLICE_53I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"INV", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>subg_q_spi_spi_clk_N_224, 
                A0=>fpga_ufl_p7_c, B0=>'X', C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>subg_q_spi_spi_clk_enable, 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>subg_q_spi_spi_clk_N_224, Q0=>fpga_ufl_p7_c);
    subg_q_spi_SLICE_54I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>subg_q_spi_shift_reg_0, 
                CE=>subg_q_spi_internal_160MHz_enable_43, CLK=>internal_160MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>fpga_ufl_p8_c);
    lvds_rx_09_inst_SLICE_55I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"C5C0", LUT1_INITVAL=>X"FEFE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_0, 
                B1=>r_phase_count_1, C1=>r_phase_count_2, D1=>'X', DI1=>'X', 
                DI0=>lvds_rx_09_inst_n1, A0=>w_lvds_rx_09_d1, B0=>n2949, 
                C0=>o_debug_state_0, D0=>w_lvds_rx_09_d0, M0=>'X', 
                CE=>subg_ddr_data_valid, CLK=>internal_80MHz, 
                LSR=>lvds_rx_09_inst_n1924, OFX1=>open, F1=>n2949, Q1=>open, 
                OFX0=>open, F0=>lvds_rx_09_inst_n1, Q0=>o_debug_state_0);
    lvds_rx_09_inst_SLICE_56I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"C0CA", LUT1_INITVAL=>X"1000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_2, 
                B1=>r_phase_count_0, C1=>o_debug_state_0, D1=>w_lvds_rx_09_d1, 
                DI1=>'X', DI0=>lvds_rx_09_inst_o_debug_state_1_N_121_1, 
                A0=>lvds_rx_09_inst_n2749, B0=>lvds_rx_09_inst_n2929, 
                C0=>o_debug_state_1, D0=>lvds_rx_09_inst_n2765, M0=>'X', 
                CE=>subg_ddr_data_valid, CLK=>internal_80MHz, LSR=>'X', 
                OFX1=>open, F1=>lvds_rx_09_inst_n2749, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_09_inst_o_debug_state_1_N_121_1, 
                Q0=>o_debug_state_1);
    lvds_rx_24_inst_SLICE_57I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"C0CA", LUT1_INITVAL=>X"FEFE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_0_adj_234, 
                B1=>r_phase_count_1_adj_233, C1=>r_phase_count_2_adj_232, 
                D1=>'X', DI1=>'X', DI0=>lvds_rx_24_inst_n1, 
                A0=>w_lvds_rx_24_d1, B0=>n2946, C0=>o_debug_state_0_adj_231, 
                D0=>w_lvds_rx_24_d0, M0=>'X', CE=>wifi_ddr_data_valid, 
                CLK=>internal_80MHz, LSR=>lvds_rx_24_inst_n1926, OFX1=>open, 
                F1=>n2946, Q1=>open, OFX0=>open, F0=>lvds_rx_24_inst_n1, 
                Q0=>o_debug_state_0_adj_231);
    lvds_rx_24_inst_SLICE_58I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"C0CA", LUT1_INITVAL=>X"1000", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_lvds_rx_24_d1, 
                B1=>r_phase_count_0_adj_234, C1=>o_debug_state_0_adj_231, 
                D1=>w_lvds_rx_24_d0, DI1=>'X', 
                DI0=>lvds_rx_24_inst_o_debug_state_1_N_121_1, 
                A0=>lvds_rx_24_inst_n2757, B0=>lvds_rx_24_inst_n1277, 
                C0=>o_debug_state_1_adj_230, D0=>lvds_rx_24_inst_n2952, 
                M0=>'X', CE=>wifi_ddr_data_valid, CLK=>internal_80MHz, 
                LSR=>'X', OFX1=>open, F1=>lvds_rx_24_inst_n2757, Q1=>open, 
                OFX0=>open, F0=>lvds_rx_24_inst_o_debug_state_1_N_121_1, 
                Q0=>o_debug_state_1_adj_230);
    SLICE_59I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"5044", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_12, D1=>'X', 
                DI1=>n552, DI0=>n566, A0=>w_lvds_rx_24_d1, 
                B0=>o_debug_state_0_adj_231, C0=>n2946, 
                D0=>o_debug_state_1_adj_230, M0=>'X', 
                CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n552, 
                Q1=>o_fifo_data_14, OFX0=>open, F0=>n566, Q0=>o_fifo_data_0);
    SLICE_60I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>o_fifo_data_14, D1=>'X', 
                DI1=>n550, DI0=>n551, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_13, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n550, 
                Q1=>o_fifo_data_16, OFX0=>open, F0=>n551, Q0=>o_fifo_data_15);
    SLICE_61I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", LUT0_INITVAL=>X"3F2B", 
                   LUT1_INITVAL=>X"9999", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_1, 
                B1=>o_debug_state_0, C1=>'X', D1=>'X', DI1=>'X', DI0=>n2960, 
                A0=>r_phase_count_1, B0=>o_debug_state_1, C0=>o_debug_state_0, 
                D0=>r_phase_count_2, M0=>r_phase_count_0, 
                CE=>subg_ddr_data_valid, CLK=>internal_80MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>n2960, F0=>open, 
                Q0=>r_phase_count_0);
    SLICE_62I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", LUT0_INITVAL=>X"002F", 
                   LUT1_INITVAL=>X"7117", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>r_phase_count_1, D1=>r_phase_count_0, 
                DI1=>'X', DI0=>r_phase_count_2_N_123_1, A0=>w_lvds_rx_09_d1, 
                B0=>w_lvds_rx_09_d0, C0=>o_debug_state_0, D0=>o_debug_state_1, 
                M0=>n2949, CE=>lvds_rx_09_inst_internal_80MHz_enable_57, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>r_phase_count_2_N_123_1, F0=>open, Q0=>r_phase_count_1);
    SLICE_63I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", LUT0_INITVAL=>X"002F", 
                   LUT1_INITVAL=>X"7117", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>r_phase_count_2, 
                D1=>lvds_rx_09_inst_n2942, DI1=>'X', 
                DI0=>r_phase_count_2_N_123_2, A0=>w_lvds_rx_09_d1, 
                B0=>w_lvds_rx_09_d0, C0=>o_debug_state_0, D0=>o_debug_state_1, 
                M0=>n2949, CE=>lvds_rx_09_inst_internal_80MHz_enable_57, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>r_phase_count_2_N_123_2, F0=>open, Q0=>r_phase_count_2);
    SLICE_64I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", LUT0_INITVAL=>X"3F2B", 
                   LUT1_INITVAL=>X"9999", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_1_adj_230, 
                B1=>o_debug_state_0_adj_231, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>n2963, A0=>r_phase_count_1_adj_233, 
                B0=>o_debug_state_1_adj_230, C0=>o_debug_state_0_adj_231, 
                D0=>r_phase_count_2_adj_232, M0=>r_phase_count_0_adj_234, 
                CE=>wifi_ddr_data_valid, CLK=>internal_80MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>n2963, F0=>open, 
                Q0=>r_phase_count_0_adj_234);
    SLICE_65I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", LUT0_INITVAL=>X"004F", 
                   LUT1_INITVAL=>X"7117", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>r_phase_count_1_adj_233, 
                D1=>r_phase_count_0_adj_234, DI1=>'X', 
                DI0=>r_phase_count_2_N_123_1_adj_236, A0=>w_lvds_rx_24_d1, 
                B0=>w_lvds_rx_24_d0, C0=>o_debug_state_0_adj_231, 
                D0=>o_debug_state_1_adj_230, M0=>n2946, 
                CE=>lvds_rx_24_inst_internal_80MHz_enable_59, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>r_phase_count_2_N_123_1_adj_236, F0=>open, 
                Q0=>r_phase_count_1_adj_233);
    SLICE_66I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   REG0_REGSET=>"SET", SRMODE=>"ASYNC", LUT0_INITVAL=>X"004F", 
                   LUT1_INITVAL=>X"7117", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>r_phase_count_2_adj_232, 
                D1=>lvds_rx_24_inst_n2957, DI1=>'X', 
                DI0=>r_phase_count_2_N_123_2_adj_235, A0=>w_lvds_rx_24_d1, 
                B0=>w_lvds_rx_24_d0, C0=>o_debug_state_0_adj_231, 
                D0=>o_debug_state_1_adj_230, M0=>n2946, 
                CE=>lvds_rx_24_inst_internal_80MHz_enable_59, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>r_phase_count_2_N_123_2_adj_235, F0=>open, 
                Q0=>r_phase_count_2_adj_232);
    SLICE_67I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_18, D1=>shift_reg_3, 
                DI1=>shift_reg_15_N_168_2, DI0=>shift_reg_15_N_168_1, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_17, 
                D0=>shift_reg_2, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_2, Q1=>shift_reg_2, OFX0=>open, 
                F0=>shift_reg_15_N_168_1, Q0=>shift_reg_1);
    SLICE_68I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_20, D1=>shift_reg_5, 
                DI1=>shift_reg_15_N_168_4, DI0=>shift_reg_15_N_168_3, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_19, 
                D0=>shift_reg_4, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_4, Q1=>shift_reg_4, OFX0=>open, 
                F0=>shift_reg_15_N_168_3, Q0=>shift_reg_3);
    SLICE_69I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_22, D1=>shift_reg_7, 
                DI1=>shift_reg_15_N_168_6, DI0=>shift_reg_15_N_168_5, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_21, 
                D0=>shift_reg_6, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_6, Q1=>shift_reg_6, OFX0=>open, 
                F0=>shift_reg_15_N_168_5, Q0=>shift_reg_5);
    SLICE_70I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_24, D1=>shift_reg_9, 
                DI1=>shift_reg_15_N_168_8, DI0=>shift_reg_15_N_168_7, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_23, 
                D0=>shift_reg_8, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_8, Q1=>shift_reg_8, OFX0=>open, 
                F0=>shift_reg_15_N_168_7, Q0=>shift_reg_7);
    SLICE_71I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_26, D1=>shift_reg_11, 
                DI1=>shift_reg_15_N_168_10, DI0=>shift_reg_15_N_168_9, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_25, 
                D0=>shift_reg_10, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_10, Q1=>shift_reg_10, OFX0=>open, 
                F0=>shift_reg_15_N_168_9, Q0=>shift_reg_9);
    SLICE_72I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_28, D1=>shift_reg_13, 
                DI1=>shift_reg_15_N_168_12, DI0=>shift_reg_15_N_168_11, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_27, 
                D0=>shift_reg_12, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_12, Q1=>shift_reg_12, OFX0=>open, 
                F0=>shift_reg_15_N_168_11, Q0=>shift_reg_11);
    SLICE_73I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"FB40", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy, B1=>n2947, 
                C1=>w_rx_09_fifo_data_30, D1=>shift_reg_15, 
                DI1=>shift_reg_15_N_168_14, DI0=>shift_reg_15_N_168_13, 
                A0=>spi_busy, B0=>n2947, C0=>w_rx_09_fifo_data_29, 
                D0=>shift_reg_14, M0=>'X', CE=>internal_160MHz_enable_84, 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>shift_reg_15_N_168_14, Q1=>shift_reg_14, OFX0=>open, 
                F0=>shift_reg_15_N_168_13, Q0=>shift_reg_13);
    subg_i_spi_SLICE_74I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>w_rx_09_fifo_data_31, 
                CE=>internal_160MHz_enable_84, CLK=>internal_160MHz, 
                LSR=>subg_i_spi_internal_160MHz_enable_25, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>open, Q0=>shift_reg_15);
    SLICE_75I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_10_adj_257, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_10, 
                D0=>shift_reg_11_adj_242, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_10_adj_257, Q0=>shift_reg_10_adj_243);
    SLICE_76I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_10_adj_288, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_27, 
                D0=>shift_reg_11_adj_273, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_10_adj_288, Q0=>shift_reg_10_adj_274);
    SLICE_77I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_10_adj_319, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_11, 
                D0=>shift_reg_11_adj_304, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_10_adj_319, Q0=>shift_reg_10_adj_305);
    SLICE_78I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_11_adj_256, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_11, 
                D0=>shift_reg_12_adj_241, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_11_adj_256, Q0=>shift_reg_11_adj_242);
    SLICE_79I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_11_adj_287, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_28, 
                D0=>shift_reg_12_adj_272, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_11_adj_287, Q0=>shift_reg_11_adj_273);
    SLICE_80I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_11_adj_318, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_12, 
                D0=>shift_reg_12_adj_303, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_11_adj_318, Q0=>shift_reg_11_adj_304);
    SLICE_81I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_12_adj_255, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_12, 
                D0=>shift_reg_13_adj_240, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_12_adj_255, Q0=>shift_reg_12_adj_241);
    SLICE_82I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_12_adj_286, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_29, 
                D0=>shift_reg_13_adj_271, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_12_adj_286, Q0=>shift_reg_12_adj_272);
    SLICE_83I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_12_adj_317, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_13, 
                D0=>shift_reg_13_adj_302, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_12_adj_317, Q0=>shift_reg_12_adj_303);
    SLICE_84I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_13_adj_254, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_13, 
                D0=>shift_reg_14_adj_239, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_13_adj_254, Q0=>shift_reg_13_adj_240);
    SLICE_85I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_13_adj_285, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_29, 
                D0=>shift_reg_14_adj_270, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_13_adj_285, Q0=>shift_reg_13_adj_271);
    SLICE_86I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_13_adj_316, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_13, 
                D0=>shift_reg_14_adj_301, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_13_adj_316, Q0=>shift_reg_13_adj_302);
    SLICE_87I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_14_adj_253, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_14, 
                D0=>shift_reg_15_adj_238, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_14_adj_253, Q0=>shift_reg_14_adj_239);
    SLICE_88I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_14_adj_284, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_29, 
                D0=>shift_reg_15_adj_269, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_14_adj_284, Q0=>shift_reg_14_adj_270);
    SLICE_89I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_14_adj_315, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_13, 
                D0=>shift_reg_15_adj_300, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_14_adj_315, Q0=>shift_reg_14_adj_301);
    subg_q_spi_SLICE_90I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>w_rx_09_fifo_data_15, 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, 
                LSR=>subg_q_spi_internal_160MHz_enable_43, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>shift_reg_15_adj_238);
    wifi_i_spi_SLICE_91I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>w_rx_24_fifo_data_29, 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, 
                LSR=>wifi_i_spi_internal_160MHz_enable_61, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>shift_reg_15_adj_269);
    wifi_q_spi_SLICE_92I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>w_rx_24_fifo_data_13, 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, 
                LSR=>wifi_q_spi_internal_160MHz_enable_79, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>shift_reg_15_adj_300);
    SLICE_93I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_1_adj_266, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_1, 
                D0=>shift_reg_2_adj_251, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_1_adj_266, Q0=>shift_reg_1_adj_252);
    SLICE_94I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_1_adj_297, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_18, 
                D0=>shift_reg_2_adj_282, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_1_adj_297, Q0=>shift_reg_1_adj_283);
    SLICE_95I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_1_adj_328, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_2, 
                D0=>shift_reg_2_adj_313, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_1_adj_328, Q0=>shift_reg_1_adj_314);
    SLICE_96I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_2_adj_265, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_2, 
                D0=>shift_reg_3_adj_250, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_2_adj_265, Q0=>shift_reg_2_adj_251);
    SLICE_97I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_2_adj_296, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_19, 
                D0=>shift_reg_3_adj_281, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_2_adj_296, Q0=>shift_reg_2_adj_282);
    SLICE_98I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_2_adj_327, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_3, 
                D0=>shift_reg_3_adj_312, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_2_adj_327, Q0=>shift_reg_2_adj_313);
    SLICE_99I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_3_adj_264, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_3, 
                D0=>shift_reg_4_adj_249, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_3_adj_264, Q0=>shift_reg_3_adj_250);
    SLICE_100I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_3_adj_295, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_20, 
                D0=>shift_reg_4_adj_280, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_3_adj_295, Q0=>shift_reg_3_adj_281);
    SLICE_101I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_3_adj_326, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_4, 
                D0=>shift_reg_4_adj_311, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_3_adj_326, Q0=>shift_reg_3_adj_312);
    SLICE_102I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_4_adj_263, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_4, 
                D0=>shift_reg_5_adj_248, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_4_adj_263, Q0=>shift_reg_4_adj_249);
    SLICE_103I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_4_adj_294, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_21, 
                D0=>shift_reg_5_adj_279, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_4_adj_294, Q0=>shift_reg_4_adj_280);
    SLICE_104I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_4_adj_325, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_5, 
                D0=>shift_reg_5_adj_310, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_4_adj_325, Q0=>shift_reg_4_adj_311);
    SLICE_105I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_5_adj_262, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_5, 
                D0=>shift_reg_6_adj_247, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_5_adj_262, Q0=>shift_reg_5_adj_248);
    SLICE_106I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_5_adj_293, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_22, 
                D0=>shift_reg_6_adj_278, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_5_adj_293, Q0=>shift_reg_5_adj_279);
    SLICE_107I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_5_adj_324, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_6, 
                D0=>shift_reg_6_adj_309, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_5_adj_324, Q0=>shift_reg_5_adj_310);
    SLICE_108I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_6_adj_261, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_6, 
                D0=>shift_reg_7_adj_246, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_6_adj_261, Q0=>shift_reg_6_adj_247);
    SLICE_109I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_6_adj_292, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_23, 
                D0=>shift_reg_7_adj_277, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_6_adj_292, Q0=>shift_reg_6_adj_278);
    SLICE_110I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_6_adj_323, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_7, 
                D0=>shift_reg_7_adj_308, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_6_adj_323, Q0=>shift_reg_6_adj_309);
    SLICE_111I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_7_adj_260, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_7, 
                D0=>shift_reg_8_adj_245, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_7_adj_260, Q0=>shift_reg_7_adj_246);
    SLICE_112I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_7_adj_291, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_24, 
                D0=>shift_reg_8_adj_276, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_7_adj_291, Q0=>shift_reg_7_adj_277);
    SLICE_113I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_7_adj_322, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_8, 
                D0=>shift_reg_8_adj_307, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_7_adj_322, Q0=>shift_reg_7_adj_308);
    SLICE_114I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_8_adj_259, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_8, 
                D0=>shift_reg_9_adj_244, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_8_adj_259, Q0=>shift_reg_8_adj_245);
    SLICE_115I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_8_adj_290, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_25, 
                D0=>shift_reg_9_adj_275, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_8_adj_290, Q0=>shift_reg_8_adj_276);
    SLICE_116I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_8_adj_321, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_9, 
                D0=>shift_reg_9_adj_306, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_8_adj_321, Q0=>shift_reg_8_adj_307);
    SLICE_117I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_9_adj_258, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>w_rx_09_fifo_data_9, 
                D0=>shift_reg_10_adj_243, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_9_adj_258, Q0=>shift_reg_9_adj_244);
    SLICE_118I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_9_adj_289, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_26, 
                D0=>shift_reg_10_adj_274, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_9_adj_289, Q0=>shift_reg_9_adj_275);
    SLICE_119I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_9_adj_320, 
                A0=>spi_busy_adj_299, B0=>n2943, C0=>w_rx_24_fifo_data_10, 
                D0=>shift_reg_10_adj_305, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_9_adj_320, Q0=>shift_reg_9_adj_306);
    subg_i_spi_SLICE_120I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>subg_i_spi_shift_reg_0, 
                CE=>subg_i_spi_internal_160MHz_enable_25, CLK=>internal_160MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>spi1_mosi_c);
    subg_i_spi_SLICE_121I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"INV", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>subg_i_spi_spi_clk_N_224, 
                A0=>spi1_sck_c, B0=>'X', C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>subg_i_spi_spi_clk_enable, 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>subg_i_spi_spi_clk_N_224, Q0=>spi1_sck_c);
    wifi_i_spi_SLICE_122I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>wifi_i_spi_shift_reg_0, 
                CE=>wifi_i_spi_internal_160MHz_enable_61, CLK=>internal_160MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>spi3_mosi_c);
    wifi_i_spi_SLICE_123I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"INV", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>wifi_i_spi_spi_clk_N_224, 
                A0=>spi3_sck_c, B0=>'X', C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>wifi_i_spi_spi_clk_enable, 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>wifi_i_spi_spi_clk_N_224, Q0=>spi3_sck_c);
    wifi_q_spi_SLICE_124I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>wifi_q_spi_shift_reg_0, 
                CE=>wifi_q_spi_internal_160MHz_enable_79, CLK=>internal_160MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>spi4_mosi_c);
    wifi_q_spi_SLICE_125I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"INV", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>wifi_q_spi_spi_clk_N_224, 
                A0=>spi4_sck_c, B0=>'X', C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>wifi_q_spi_spi_clk_enable, 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>wifi_q_spi_spi_clk_N_224, Q0=>spi4_sck_c);
    SLICE_126I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EE4E", LUT1_INITVAL=>X"FDFD", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_i_spi_bit_count_0, 
                B1=>subg_i_spi_n8, C1=>subg_i_spi_bit_count_3, D1=>'X', 
                DI1=>'X', DI0=>n1237, A0=>spi_busy, B0=>n2947, C0=>n3030, 
                D0=>n2693, M0=>'X', CE=>'X', CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>n2693, Q1=>open, OFX0=>open, F0=>n1237, 
                Q0=>spi_busy);
    SLICE_127I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EE4E", LUT1_INITVAL=>X"EE4E", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi_busy_adj_268, B1=>n2943, 
                C1=>n3032, D1=>n2685, DI1=>n1251, DI0=>n1220, 
                A0=>spi_busy_adj_237, B0=>n2947, C0=>n3031, D0=>n2681, M0=>'X', 
                CE=>'X', CLK=>internal_160MHz, LSR=>'X', OFX1=>open, F1=>n1251, 
                Q1=>spi_busy_adj_268, OFX0=>open, F0=>n1220, 
                Q0=>spi_busy_adj_237);
    SLICE_128I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EE4E", LUT1_INITVAL=>X"8888", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi4_sck_c, 
                B1=>wifi_q_spi_spi_clk_enable, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>n1230, A0=>spi_busy_adj_299, B0=>n2943, C0=>n3029, 
                D0=>n2689, M0=>'X', CE=>'X', CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>n3029, Q1=>open, OFX0=>open, F0=>n1230, 
                Q0=>spi_busy_adj_299);
    subg_iddr_SLICE_129I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>subg_iddr_fifo_empty_N_71, 
                A0=>subg_iddr_fifo_empty, B0=>'X', C0=>'X', D0=>'X', M0=>'X', 
                CE=>'X', CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>open, OFX0=>open, F0=>subg_iddr_fifo_empty_N_71, 
                Q0=>subg_ddr_data_valid);
    subg_i_spi_SLICE_130I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"78F0", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>subg_i_spi_bit_count_4_N_218_0, 
                A0=>spi1_sck_c, B0=>subg_i_spi_spi_clk_enable, 
                C0=>subg_i_spi_bit_count_0, D0=>spi_busy, M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>n2932, OFX1=>open, F1=>open, 
                Q1=>open, OFX0=>open, F0=>subg_i_spi_bit_count_4_N_218_0, 
                Q0=>subg_i_spi_bit_count_0);
    subg_i_spi_SLICE_131I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"9999", LUT1_INITVAL=>X"E1E1", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_i_spi_bit_count_1, 
                B1=>subg_i_spi_bit_count_0, C1=>subg_i_spi_bit_count_2, 
                D1=>'X', DI1=>subg_i_spi_n1338, DI0=>subg_i_spi_n1342, 
                A0=>subg_i_spi_bit_count_1, B0=>subg_i_spi_bit_count_0, 
                C0=>'X', D0=>'X', M0=>'X', 
                CE=>subg_i_spi_internal_160MHz_enable_25, CLK=>internal_160MHz, 
                LSR=>n2932, OFX1=>open, F1=>subg_i_spi_n1338, 
                Q1=>subg_i_spi_bit_count_2, OFX0=>open, F0=>subg_i_spi_n1342, 
                Q0=>subg_i_spi_bit_count_1);
    subg_i_spi_SLICE_132I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"F0E1", LUT1_INITVAL=>X"FEFE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_i_spi_bit_count_1, 
                B1=>subg_i_spi_bit_count_0, C1=>subg_i_spi_bit_count_2, 
                D1=>'X', DI1=>'X', DI0=>subg_i_spi_n1344, 
                A0=>subg_i_spi_bit_count_1, B0=>subg_i_spi_bit_count_0, 
                C0=>subg_i_spi_bit_count_3, D0=>subg_i_spi_bit_count_2, 
                M0=>'X', CE=>subg_i_spi_internal_160MHz_enable_25, 
                CLK=>internal_160MHz, LSR=>n2932, OFX1=>open, 
                F1=>subg_i_spi_n2934, Q1=>open, OFX0=>open, 
                F0=>subg_i_spi_n1344, Q0=>subg_i_spi_bit_count_3);
    SLICE_133I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EEED", LUT1_INITVAL=>X"0808", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_rx_09_fifo_push, 
                B1=>stm_fpga_spare1_c, C1=>spi_busy, D1=>'X', DI1=>'X', 
                DI0=>subg_i_spi_bit_count_4_N_184_4, 
                A0=>subg_i_spi_bit_count_4, B0=>n2932, 
                C0=>subg_i_spi_bit_count_3, D0=>subg_i_spi_n2934, M0=>'X', 
                CE=>internal_160MHz_enable_84, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>n2932, Q1=>open, OFX0=>open, 
                F0=>subg_i_spi_bit_count_4_N_184_4, Q0=>subg_i_spi_bit_count_4);
    SLICE_134I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_0, A0=>spi_busy, 
                B0=>n2947, C0=>w_rx_09_fifo_data_16, D0=>shift_reg_1, M0=>'X', 
                CE=>internal_160MHz_enable_84, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_0, Q0=>subg_i_spi_shift_reg_0);
    subg_i_spi_SLICE_135I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"DCFC", LUT1_INITVAL=>X"8080", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi1_sck_c, 
                B1=>subg_i_spi_spi_clk_enable, C1=>spi_busy, D1=>'X', DI1=>'X', 
                DI0=>subg_i_spi_n1908, A0=>subg_i_spi_n2653, B0=>n2932, 
                C0=>subg_i_spi_spi_clk_enable, 
                D0=>subg_i_spi_internal_160MHz_enable_25, M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>subg_i_spi_internal_160MHz_enable_25, Q1=>open, OFX0=>open, 
                F0=>subg_i_spi_n1908, Q0=>subg_i_spi_spi_clk_enable);
    subg_iddr_SLICE_136I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>sdr_rx_subg_c, CE=>data_rising, 
                CLK=>internal_200MHz, LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>open, F0=>open, Q0=>subg_iddr_data_rising_capture);
    subg_iddr_SLICE_137I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   GSR=>"DISABLED", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>subg_iddr_data_rising_capture, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>sdr_rx_subg_c, 
                CE=>subg_iddr_internal_200MHz_enable_3, CLK=>internal_200MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>subg_iddr_fifo_data_1, 
                OFX0=>open, F0=>open, Q0=>subg_iddr_fifo_data_0);
    subg_iddr_fifo_inst_SLICE_138I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_iddr_fifo_inst_rcount_1, 
                B1=>subg_iddr_fifo_inst_rcount_2, C1=>'X', D1=>'X', 
                DI1=>subg_iddr_fifo_inst_r_gdata_1, 
                DI0=>subg_iddr_fifo_inst_r_gdata_0, 
                A0=>subg_iddr_fifo_inst_rcount_0, 
                B0=>subg_iddr_fifo_inst_rcount_1, C0=>'X', D0=>'X', M0=>'X', 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>subg_iddr_fifo_inst_r_gdata_1, 
                Q1=>subg_iddr_fifo_inst_r_gcount_1, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_r_gdata_0, 
                Q0=>subg_iddr_fifo_inst_r_gcount_0);
    subg_iddr_fifo_inst_SLICE_139I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_iddr_fifo_inst_rcount_3, 
                B1=>subg_iddr_fifo_inst_rcount_4, C1=>'X', D1=>'X', 
                DI1=>subg_iddr_fifo_inst_r_gdata_3, 
                DI0=>subg_iddr_fifo_inst_r_gdata_2, 
                A0=>subg_iddr_fifo_inst_rcount_2, 
                B0=>subg_iddr_fifo_inst_rcount_3, C0=>'X', D0=>'X', M0=>'X', 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>subg_iddr_fifo_inst_r_gdata_3, 
                Q1=>subg_iddr_fifo_inst_r_gcount_3, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_r_gdata_2, 
                Q0=>subg_iddr_fifo_inst_r_gcount_2);
    subg_iddr_fifo_inst_SLICE_140I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   SRMODE=>"ASYNC", CHECK_M0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>subg_iddr_fifo_inst_rcount_4, 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>open, F0=>open, Q0=>subg_iddr_fifo_inst_r_gcount_4);
    subg_iddr_fifo_inst_SLICE_141I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_r_gcount_1, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_r_gcount_0, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>subg_iddr_fifo_inst_r_gcount_w1, OFX0=>open, 
                F0=>open, Q0=>subg_iddr_fifo_inst_r_gcount_w0);
    subg_iddr_fifo_inst_SLICE_142I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_r_gcount_3, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_r_gcount_2, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>subg_iddr_fifo_inst_r_gcount_w3, OFX0=>open, 
                F0=>open, Q0=>subg_iddr_fifo_inst_r_gcount_w2);
    subg_iddr_fifo_inst_SLICE_143I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_r_gcount_w0, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_r_gcount_4, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>subg_iddr_fifo_inst_r_gcount_w20, OFX0=>open, 
                F0=>open, Q0=>subg_iddr_fifo_inst_r_gcount_w4);
    subg_iddr_fifo_inst_SLICE_144I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_r_gcount_w2, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_r_gcount_w1, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>subg_iddr_fifo_inst_r_gcount_w22, OFX0=>open, 
                F0=>open, Q0=>subg_iddr_fifo_inst_r_gcount_w21);
    subg_iddr_fifo_inst_SLICE_145I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_r_gcount_w4, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_r_gcount_w3, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>subg_iddr_fifo_inst_r_gcount_w24, OFX0=>open, 
                F0=>open, Q0=>subg_iddr_fifo_inst_r_gcount_w23);
    subg_iddr_fifo_inst_SLICE_146I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_rcount_1, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>subg_iddr_fifo_inst_rcount_0, 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_rptr_1, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_rptr_0);
    subg_iddr_fifo_inst_SLICE_147I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_rcount_3, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>subg_iddr_fifo_inst_rcount_2, 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_rptr_3, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_rptr_2);
    subg_iddr_fifo_inst_SLICE_149I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_iddr_fifo_inst_wcount_1, 
                B1=>subg_iddr_fifo_inst_wcount_2, C1=>'X', D1=>'X', 
                DI1=>subg_iddr_fifo_inst_w_gdata_1, 
                DI0=>subg_iddr_fifo_inst_w_gdata_0, 
                A0=>subg_iddr_fifo_inst_wcount_0, 
                B0=>subg_iddr_fifo_inst_wcount_1, C0=>'X', D0=>'X', M0=>'X', 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>subg_iddr_fifo_inst_w_gdata_1, 
                Q1=>subg_iddr_fifo_inst_w_gcount_1, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_w_gdata_0, 
                Q0=>subg_iddr_fifo_inst_w_gcount_0);
    subg_iddr_fifo_inst_SLICE_150I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_iddr_fifo_inst_wcount_3, 
                B1=>subg_iddr_fifo_inst_wcount_4, C1=>'X', D1=>'X', 
                DI1=>subg_iddr_fifo_inst_w_gdata_3, 
                DI0=>subg_iddr_fifo_inst_w_gdata_2, 
                A0=>subg_iddr_fifo_inst_wcount_2, 
                B0=>subg_iddr_fifo_inst_wcount_3, C0=>'X', D0=>'X', M0=>'X', 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>subg_iddr_fifo_inst_w_gdata_3, 
                Q1=>subg_iddr_fifo_inst_w_gcount_3, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_w_gdata_2, 
                Q0=>subg_iddr_fifo_inst_w_gcount_2);
    subg_iddr_fifo_inst_SLICE_151I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>subg_iddr_fifo_inst_wcount_4, 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_w_gcount_4);
    subg_iddr_fifo_inst_SLICE_152I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_w_gcount_1, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_w_gcount_0, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_w_gcount_r1, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_w_gcount_r0);
    subg_iddr_fifo_inst_SLICE_153I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_w_gcount_3, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_w_gcount_2, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_w_gcount_r3, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_w_gcount_r2);
    subg_iddr_fifo_inst_SLICE_154I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_w_gcount_r0, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_w_gcount_4, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_w_gcount_r20, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_w_gcount_r4);
    subg_iddr_fifo_inst_SLICE_155I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_w_gcount_r2, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_w_gcount_r1, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_w_gcount_r22, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_w_gcount_r21);
    subg_iddr_fifo_inst_SLICE_156I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_w_gcount_r4, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>subg_iddr_fifo_inst_w_gcount_r3, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>subg_iddr_fifo_inst_w_gcount_r24, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_fifo_inst_w_gcount_r23);
    subg_iddr_fifo_inst_SLICE_157I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_wcount_1, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>subg_iddr_fifo_inst_wcount_0, 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>subg_iddr_fifo_inst_wptr_1, 
                OFX0=>open, F0=>open, Q0=>subg_iddr_fifo_inst_wptr_0);
    subg_iddr_fifo_inst_SLICE_158I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>subg_iddr_fifo_inst_wcount_3, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>subg_iddr_fifo_inst_wcount_2, 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>subg_iddr_fifo_inst_wptr_3, 
                OFX0=>open, F0=>open, Q0=>subg_iddr_fifo_inst_wptr_2);
    subg_iddr_SLICE_160I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"INV", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>subg_iddr_fifo_full_N_81, 
                A0=>subg_iddr_fifo_full, B0=>'X', C0=>'X', D0=>'X', M0=>'X', 
                CE=>'X', CLK=>internal_200MHz, LSR=>data_falling, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>subg_iddr_fifo_full_N_81, 
                Q0=>subg_iddr_fifo_wr_en);
    subg_iddr_SLICE_161I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>sdr_rxclk_c, CE=>'X', CLK=>internal_200MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>subg_iddr_sdr_rxclk_last);
    subg_q_spi_SLICE_162I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"78F0", LUT1_INITVAL=>X"FDFD", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_q_spi_bit_count_0, 
                B1=>subg_q_spi_n8, C1=>subg_q_spi_bit_count_3, D1=>'X', 
                DI1=>'X', DI0=>subg_q_spi_bit_count_4_N_218_0, 
                A0=>fpga_ufl_p7_c, B0=>subg_q_spi_spi_clk_enable, 
                C0=>subg_q_spi_bit_count_0, D0=>spi_busy_adj_237, M0=>'X', 
                CE=>'X', CLK=>internal_160MHz, LSR=>n2938, OFX1=>open, 
                F1=>n2681, Q1=>open, OFX0=>open, 
                F0=>subg_q_spi_bit_count_4_N_218_0, Q0=>subg_q_spi_bit_count_0);
    subg_q_spi_SLICE_163I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"9999", LUT1_INITVAL=>X"E1E1", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_q_spi_bit_count_1, 
                B1=>subg_q_spi_bit_count_0, C1=>subg_q_spi_bit_count_2, 
                D1=>'X', DI1=>subg_q_spi_n1332, DI0=>subg_q_spi_n1326, 
                A0=>subg_q_spi_bit_count_1, B0=>subg_q_spi_bit_count_0, 
                C0=>'X', D0=>'X', M0=>'X', 
                CE=>subg_q_spi_internal_160MHz_enable_43, CLK=>internal_160MHz, 
                LSR=>n2938, OFX1=>open, F1=>subg_q_spi_n1332, 
                Q1=>subg_q_spi_bit_count_2, OFX0=>open, F0=>subg_q_spi_n1326, 
                Q0=>subg_q_spi_bit_count_1);
    subg_q_spi_SLICE_164I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"F0E1", LUT1_INITVAL=>X"FEFE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_q_spi_bit_count_1, 
                B1=>subg_q_spi_bit_count_0, C1=>subg_q_spi_bit_count_2, 
                D1=>'X', DI1=>'X', DI0=>subg_q_spi_n1322, 
                A0=>subg_q_spi_bit_count_1, B0=>subg_q_spi_bit_count_0, 
                C0=>subg_q_spi_bit_count_3, D0=>subg_q_spi_bit_count_2, 
                M0=>'X', CE=>subg_q_spi_internal_160MHz_enable_43, 
                CLK=>internal_160MHz, LSR=>n2938, OFX1=>open, 
                F1=>subg_q_spi_n2933, Q1=>open, OFX0=>open, 
                F0=>subg_q_spi_n1322, Q0=>subg_q_spi_bit_count_3);
    SLICE_165I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EEED", LUT1_INITVAL=>X"0808", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_rx_09_fifo_push, 
                B1=>stm_fpga_spare1_c, C1=>spi_busy_adj_237, D1=>'X', DI1=>'X', 
                DI0=>subg_q_spi_bit_count_4_N_184_4, 
                A0=>subg_q_spi_bit_count_4, B0=>n2938, 
                C0=>subg_q_spi_bit_count_3, D0=>subg_q_spi_n2933, M0=>'X', 
                CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>n2938, Q1=>open, OFX0=>open, 
                F0=>subg_q_spi_bit_count_4_N_184_4, Q0=>subg_q_spi_bit_count_4);
    SLICE_166I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"8888", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_rx_09_fifo_push, 
                B1=>stm_fpga_spare1_c, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>shift_reg_15_N_168_0_adj_267, A0=>spi_busy_adj_237, 
                B0=>n2947, C0=>w_rx_09_fifo_data_0, D0=>shift_reg_1_adj_252, 
                M0=>'X', CE=>internal_160MHz_enable_83, CLK=>internal_160MHz, 
                LSR=>'X', OFX1=>open, F1=>n2947, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_0_adj_267, Q0=>subg_q_spi_shift_reg_0);
    subg_q_spi_SLICE_167I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"DCFC", LUT1_INITVAL=>X"8080", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>fpga_ufl_p7_c, 
                B1=>subg_q_spi_spi_clk_enable, C1=>spi_busy_adj_237, D1=>'X', 
                DI1=>'X', DI0=>subg_q_spi_n1900, A0=>subg_q_spi_n2641, 
                B0=>n2938, C0=>subg_q_spi_spi_clk_enable, 
                D0=>subg_q_spi_internal_160MHz_enable_43, M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>subg_q_spi_internal_160MHz_enable_43, Q1=>open, OFX0=>open, 
                F0=>subg_q_spi_n1900, Q0=>subg_q_spi_spi_clk_enable);
    subg_iddr_SLICE_168I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"INV", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>subg_iddr_fifo_out_0, FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', 
                C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', 
                C0=>'X', D0=>'X', M0=>subg_iddr_fifo_out_1, 
                CE=>subg_iddr_fifo_empty, CLK=>internal_80MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>w_lvds_rx_09_d1, OFX0=>open, 
                F0=>open, Q0=>w_lvds_rx_09_d0);
    wifi_iddr_SLICE_169I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"INV", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>wifi_iddr_fifo_out_0, FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', 
                C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', 
                C0=>'X', D0=>'X', M0=>wifi_iddr_fifo_out_1, 
                CE=>wifi_iddr_fifo_empty, CLK=>internal_80MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>w_lvds_rx_24_d1, OFX0=>open, 
                F0=>open, Q0=>w_lvds_rx_24_d0);
    SLICE_170I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"A088", 
                   LUT1_INITVAL=>X"F1F1", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_lvds_rx_09_d0, D1=>'X', DI1=>n357, 
                DI0=>n358, A0=>w_lvds_rx_09_d1, B0=>o_debug_state_0, C0=>n2949, 
                D0=>o_debug_state_1, M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n357, 
                Q1=>w_rx_09_fifo_data_1, OFX0=>open, F0=>n358, 
                Q0=>w_rx_09_fifo_data_0);
    SLICE_171I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_1, D1=>'X', 
                DI1=>n355, DI0=>n356, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_0, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n355, 
                Q1=>w_rx_09_fifo_data_3, OFX0=>open, F0=>n356, 
                Q0=>w_rx_09_fifo_data_2);
    SLICE_172I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_3, D1=>'X', 
                DI1=>n353, DI0=>n354, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_2, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n353, 
                Q1=>w_rx_09_fifo_data_5, OFX0=>open, F0=>n354, 
                Q0=>w_rx_09_fifo_data_4);
    SLICE_173I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_5, D1=>'X', 
                DI1=>n351, DI0=>n352, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_4, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n351, 
                Q1=>w_rx_09_fifo_data_7, OFX0=>open, F0=>n352, 
                Q0=>w_rx_09_fifo_data_6);
    SLICE_174I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_7, D1=>'X', 
                DI1=>n349, DI0=>n350, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_6, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n349, 
                Q1=>w_rx_09_fifo_data_9, OFX0=>open, F0=>n350, 
                Q0=>w_rx_09_fifo_data_8);
    SLICE_175I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_9, D1=>'X', 
                DI1=>n347, DI0=>n348, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_8, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n347, 
                Q1=>w_rx_09_fifo_data_11, OFX0=>open, F0=>n348, 
                Q0=>w_rx_09_fifo_data_10);
    SLICE_176I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_11, D1=>'X', 
                DI1=>n345, DI0=>n346, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_10, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n345, 
                Q1=>w_rx_09_fifo_data_13, OFX0=>open, F0=>n346, 
                Q0=>w_rx_09_fifo_data_12);
    SLICE_177I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_13, D1=>'X', 
                DI1=>n343, DI0=>n344, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_12, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n343, 
                Q1=>w_rx_09_fifo_data_15, OFX0=>open, F0=>n344, 
                Q0=>w_rx_09_fifo_data_14);
    SLICE_178I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_15, D1=>'X', 
                DI1=>n341, DI0=>n342, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_14, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n341, 
                Q1=>w_rx_09_fifo_data_17, OFX0=>open, F0=>n342, 
                Q0=>w_rx_09_fifo_data_16);
    SLICE_179I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_17, D1=>'X', 
                DI1=>n339, DI0=>n340, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_16, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n339, 
                Q1=>w_rx_09_fifo_data_19, OFX0=>open, F0=>n340, 
                Q0=>w_rx_09_fifo_data_18);
    SLICE_180I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_19, D1=>'X', 
                DI1=>n337, DI0=>n338, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_18, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n337, 
                Q1=>w_rx_09_fifo_data_21, OFX0=>open, F0=>n338, 
                Q0=>w_rx_09_fifo_data_20);
    SLICE_181I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_21, D1=>'X', 
                DI1=>n335, DI0=>n336, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_20, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n335, 
                Q1=>w_rx_09_fifo_data_23, OFX0=>open, F0=>n336, 
                Q0=>w_rx_09_fifo_data_22);
    SLICE_182I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_23, D1=>'X', 
                DI1=>n333, DI0=>n334, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_22, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n333, 
                Q1=>w_rx_09_fifo_data_25, OFX0=>open, F0=>n334, 
                Q0=>w_rx_09_fifo_data_24);
    SLICE_183I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_25, D1=>'X', 
                DI1=>n331, DI0=>n332, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_24, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n331, 
                Q1=>w_rx_09_fifo_data_27, OFX0=>open, F0=>n332, 
                Q0=>w_rx_09_fifo_data_26);
    SLICE_184I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_27, D1=>'X', 
                DI1=>n329, DI0=>n330, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_26, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n329, 
                Q1=>w_rx_09_fifo_data_29, OFX0=>open, F0=>n330, 
                Q0=>w_rx_09_fifo_data_28);
    SLICE_185I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>o_debug_state_1, C1=>w_rx_09_fifo_data_29, D1=>'X', 
                DI1=>n327, DI0=>n328, A0=>o_debug_state_0, B0=>o_debug_state_1, 
                C0=>w_rx_09_fifo_data_28, D0=>'X', M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n327, 
                Q1=>w_rx_09_fifo_data_31, OFX0=>open, F0=>n328, 
                Q0=>w_rx_09_fifo_data_30);
    lvds_rx_09_inst_SLICE_186I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"0010", LUT1_INITVAL=>X"00FE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_0, 
                B1=>r_phase_count_1, C1=>r_phase_count_2, D1=>o_debug_state_0, 
                DI1=>'X', DI0=>lvds_rx_09_inst_o_fifo_push_N_159, 
                A0=>r_phase_count_0, B0=>r_phase_count_1, C0=>o_debug_state_1, 
                D0=>r_phase_count_2, M0=>'X', 
                CE=>lvds_rx_09_inst_internal_80MHz_enable_30, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_09_inst_n2929, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_09_inst_o_fifo_push_N_159, Q0=>w_rx_09_fifo_push);
    SLICE_187I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"1F1F", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>o_fifo_data_0, D1=>'X', 
                DI1=>n564, DI0=>n2259, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_lvds_rx_24_d0, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n564, 
                Q1=>w_rx_24_fifo_data_2, OFX0=>open, F0=>n2259, 
                Q0=>w_rx_24_fifo_data_1);
    SLICE_188I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_2, D1=>'X', 
                DI1=>n562, DI0=>n563, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_1, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n562, 
                Q1=>w_rx_24_fifo_data_4, OFX0=>open, F0=>n563, 
                Q0=>w_rx_24_fifo_data_3);
    SLICE_189I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_4, D1=>'X', 
                DI1=>n560, DI0=>n561, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_3, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n560, 
                Q1=>w_rx_24_fifo_data_6, OFX0=>open, F0=>n561, 
                Q0=>w_rx_24_fifo_data_5);
    SLICE_190I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_6, D1=>'X', 
                DI1=>n558, DI0=>n559, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_5, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n558, 
                Q1=>w_rx_24_fifo_data_8, OFX0=>open, F0=>n559, 
                Q0=>w_rx_24_fifo_data_7);
    SLICE_191I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_8, D1=>'X', 
                DI1=>n556, DI0=>n557, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_7, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n556, 
                Q1=>w_rx_24_fifo_data_10, OFX0=>open, F0=>n557, 
                Q0=>w_rx_24_fifo_data_9);
    SLICE_192I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_10, D1=>'X', 
                DI1=>n554, DI0=>n555, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_9, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n554, 
                Q1=>w_rx_24_fifo_data_12, OFX0=>open, F0=>n555, 
                Q0=>w_rx_24_fifo_data_11);
    SLICE_193I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>o_fifo_data_15, D1=>'X', 
                DI1=>n549, DI0=>n553, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_11, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n549, 
                Q1=>w_rx_24_fifo_data_17, OFX0=>open, F0=>n553, 
                Q0=>w_rx_24_fifo_data_13);
    SLICE_194I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_17, D1=>'X', 
                DI1=>n547, DI0=>n548, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>o_fifo_data_16, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n547, 
                Q1=>w_rx_24_fifo_data_19, OFX0=>open, F0=>n548, 
                Q0=>w_rx_24_fifo_data_18);
    SLICE_195I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_19, D1=>'X', 
                DI1=>n545, DI0=>n546, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_18, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n545, 
                Q1=>w_rx_24_fifo_data_21, OFX0=>open, F0=>n546, 
                Q0=>w_rx_24_fifo_data_20);
    SLICE_196I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_21, D1=>'X', 
                DI1=>n543, DI0=>n544, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_20, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n543, 
                Q1=>w_rx_24_fifo_data_23, OFX0=>open, F0=>n544, 
                Q0=>w_rx_24_fifo_data_22);
    SLICE_197I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_23, D1=>'X', 
                DI1=>n541, DI0=>n542, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_22, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n541, 
                Q1=>w_rx_24_fifo_data_25, OFX0=>open, F0=>n542, 
                Q0=>w_rx_24_fifo_data_24);
    SLICE_198I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_25, D1=>'X', 
                DI1=>n539, DI0=>n540, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_24, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n539, 
                Q1=>w_rx_24_fifo_data_27, OFX0=>open, F0=>n540, 
                Q0=>w_rx_24_fifo_data_26);
    SLICE_199I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", GSR=>"DISABLED", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"E0E0", 
                   LUT1_INITVAL=>X"E0E0", REG1_SD=>"VHI", REG0_SD=>"VHI", 
                   CHECK_DI1=>TRUE, CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>o_debug_state_1_adj_230, C1=>w_rx_24_fifo_data_27, D1=>'X', 
                DI1=>n537, DI0=>n538, A0=>o_debug_state_0_adj_231, 
                B0=>o_debug_state_1_adj_230, C0=>w_rx_24_fifo_data_26, D0=>'X', 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>n537, 
                Q1=>w_rx_24_fifo_data_29, OFX0=>open, F0=>n538, 
                Q0=>w_rx_24_fifo_data_28);
    lvds_rx_24_inst_SLICE_200I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"0010", LUT1_INITVAL=>X"00FE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_0_adj_234, 
                B1=>r_phase_count_1_adj_233, C1=>r_phase_count_2_adj_232, 
                D1=>o_debug_state_0_adj_231, DI1=>'X', 
                DI0=>lvds_rx_24_inst_o_fifo_push_N_159, 
                A0=>r_phase_count_1_adj_233, B0=>r_phase_count_2_adj_232, 
                C0=>o_debug_state_1_adj_230, D0=>r_phase_count_0_adj_234, 
                M0=>'X', CE=>lvds_rx_24_inst_internal_80MHz_enable_17, 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_24_inst_n1277, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_24_inst_o_fifo_push_N_159, Q0=>w_rx_24_fifo_push);
    wifi_iddr_SLICE_201I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>wifi_iddr_fifo_empty_N_71, 
                A0=>wifi_iddr_fifo_empty, B0=>'X', C0=>'X', D0=>'X', M0=>'X', 
                CE=>'X', CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>open, OFX0=>open, F0=>wifi_iddr_fifo_empty_N_71, 
                Q0=>wifi_ddr_data_valid);
    wifi_i_spi_SLICE_202I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"78F0", LUT1_INITVAL=>X"FDFD", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_i_spi_bit_count_0, 
                B1=>wifi_i_spi_n8, C1=>wifi_i_spi_bit_count_3, D1=>'X', 
                DI1=>'X', DI0=>wifi_i_spi_bit_count_4_N_218_0, A0=>spi3_sck_c, 
                B0=>wifi_i_spi_spi_clk_enable, C0=>wifi_i_spi_bit_count_0, 
                D0=>spi_busy_adj_268, M0=>'X', CE=>'X', CLK=>internal_160MHz, 
                LSR=>n2931, OFX1=>open, F1=>n2685, Q1=>open, OFX0=>open, 
                F0=>wifi_i_spi_bit_count_4_N_218_0, Q0=>wifi_i_spi_bit_count_0);
    wifi_i_spi_SLICE_203I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"9999", LUT1_INITVAL=>X"E1E1", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_i_spi_bit_count_1, 
                B1=>wifi_i_spi_bit_count_0, C1=>wifi_i_spi_bit_count_2, 
                D1=>'X', DI1=>wifi_i_spi_n1316, DI0=>wifi_i_spi_n1312, 
                A0=>wifi_i_spi_bit_count_1, B0=>wifi_i_spi_bit_count_0, 
                C0=>'X', D0=>'X', M0=>'X', 
                CE=>wifi_i_spi_internal_160MHz_enable_61, CLK=>internal_160MHz, 
                LSR=>n2931, OFX1=>open, F1=>wifi_i_spi_n1316, 
                Q1=>wifi_i_spi_bit_count_2, OFX0=>open, F0=>wifi_i_spi_n1312, 
                Q0=>wifi_i_spi_bit_count_1);
    wifi_i_spi_SLICE_204I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"F0E1", LUT1_INITVAL=>X"FEFE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_i_spi_bit_count_1, 
                B1=>wifi_i_spi_bit_count_0, C1=>wifi_i_spi_bit_count_2, 
                D1=>'X', DI1=>'X', DI0=>wifi_i_spi_n1324, 
                A0=>wifi_i_spi_bit_count_1, B0=>wifi_i_spi_bit_count_0, 
                C0=>wifi_i_spi_bit_count_3, D0=>wifi_i_spi_bit_count_2, 
                M0=>'X', CE=>wifi_i_spi_internal_160MHz_enable_61, 
                CLK=>internal_160MHz, LSR=>n2931, OFX1=>open, 
                F1=>wifi_i_spi_n2930, Q1=>open, OFX0=>open, 
                F0=>wifi_i_spi_n1324, Q0=>wifi_i_spi_bit_count_3);
    SLICE_205I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EEED", LUT1_INITVAL=>X"0808", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_rx_24_fifo_push, 
                B1=>stm_fpga_spare2_c, C1=>spi_busy_adj_268, D1=>'X', DI1=>'X', 
                DI0=>wifi_i_spi_bit_count_4_N_184_4, 
                A0=>wifi_i_spi_bit_count_4, B0=>n2931, 
                C0=>wifi_i_spi_bit_count_3, D0=>wifi_i_spi_n2930, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>n2931, Q1=>open, OFX0=>open, 
                F0=>wifi_i_spi_bit_count_4_N_184_4, Q0=>wifi_i_spi_bit_count_4);
    SLICE_206I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>shift_reg_15_N_168_0_adj_298, 
                A0=>spi_busy_adj_268, B0=>n2943, C0=>w_rx_24_fifo_data_17, 
                D0=>shift_reg_1_adj_283, M0=>'X', 
                CE=>internal_160MHz_enable_82, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_0_adj_298, Q0=>wifi_i_spi_shift_reg_0);
    wifi_i_spi_SLICE_207I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"DCFC", LUT1_INITVAL=>X"8080", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi3_sck_c, 
                B1=>wifi_i_spi_spi_clk_enable, C1=>spi_busy_adj_268, D1=>'X', 
                DI1=>'X', DI0=>wifi_i_spi_n1922, A0=>wifi_i_spi_n2649, 
                B0=>n2931, C0=>wifi_i_spi_spi_clk_enable, 
                D0=>wifi_i_spi_internal_160MHz_enable_61, M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>wifi_i_spi_internal_160MHz_enable_61, Q1=>open, OFX0=>open, 
                F0=>wifi_i_spi_n1922, Q0=>wifi_i_spi_spi_clk_enable);
    wifi_iddr_SLICE_208I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>sdr_rx_wifi_c, CE=>data_rising, 
                CLK=>internal_200MHz, LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>open, F0=>open, Q0=>wifi_iddr_data_rising_capture);
    wifi_iddr_SLICE_209I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   GSR=>"DISABLED", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>wifi_iddr_data_rising_capture, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>sdr_rx_wifi_c, 
                CE=>wifi_iddr_internal_200MHz_enable_4, CLK=>internal_200MHz, 
                LSR=>'X', OFX1=>open, F1=>open, Q1=>wifi_iddr_fifo_data_1, 
                OFX0=>open, F0=>open, Q0=>wifi_iddr_fifo_data_0);
    wifi_iddr_fifo_inst_SLICE_210I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_inst_rcount_1, 
                B1=>wifi_iddr_fifo_inst_rcount_2, C1=>'X', D1=>'X', 
                DI1=>wifi_iddr_fifo_inst_r_gdata_1, 
                DI0=>wifi_iddr_fifo_inst_r_gdata_0, 
                A0=>wifi_iddr_fifo_inst_rcount_0, 
                B0=>wifi_iddr_fifo_inst_rcount_1, C0=>'X', D0=>'X', M0=>'X', 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_r_gdata_1, 
                Q1=>wifi_iddr_fifo_inst_r_gcount_1, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_r_gdata_0, 
                Q0=>wifi_iddr_fifo_inst_r_gcount_0);
    wifi_iddr_fifo_inst_SLICE_211I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_inst_rcount_3, 
                B1=>wifi_iddr_fifo_inst_rcount_4, C1=>'X', D1=>'X', 
                DI1=>wifi_iddr_fifo_inst_r_gdata_3, 
                DI0=>wifi_iddr_fifo_inst_r_gdata_2, 
                A0=>wifi_iddr_fifo_inst_rcount_2, 
                B0=>wifi_iddr_fifo_inst_rcount_3, C0=>'X', D0=>'X', M0=>'X', 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_r_gdata_3, 
                Q1=>wifi_iddr_fifo_inst_r_gcount_3, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_r_gdata_2, 
                Q0=>wifi_iddr_fifo_inst_r_gcount_2);
    wifi_iddr_fifo_inst_SLICE_212I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   SRMODE=>"ASYNC", CHECK_M0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>wifi_iddr_fifo_inst_rcount_4, 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>open, F0=>open, Q0=>wifi_iddr_fifo_inst_r_gcount_4);
    wifi_iddr_fifo_inst_SLICE_213I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_r_gcount_1, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_r_gcount_0, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>wifi_iddr_fifo_inst_r_gcount_w1, OFX0=>open, 
                F0=>open, Q0=>wifi_iddr_fifo_inst_r_gcount_w0);
    wifi_iddr_fifo_inst_SLICE_214I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_r_gcount_3, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_r_gcount_2, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>wifi_iddr_fifo_inst_r_gcount_w3, OFX0=>open, 
                F0=>open, Q0=>wifi_iddr_fifo_inst_r_gcount_w2);
    wifi_iddr_fifo_inst_SLICE_215I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_r_gcount_w0, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_r_gcount_4, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>wifi_iddr_fifo_inst_r_gcount_w20, OFX0=>open, 
                F0=>open, Q0=>wifi_iddr_fifo_inst_r_gcount_w4);
    wifi_iddr_fifo_inst_SLICE_216I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_r_gcount_w2, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_r_gcount_w1, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>wifi_iddr_fifo_inst_r_gcount_w22, OFX0=>open, 
                F0=>open, Q0=>wifi_iddr_fifo_inst_r_gcount_w21);
    wifi_iddr_fifo_inst_SLICE_217I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_r_gcount_w4, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_r_gcount_w3, CE=>'X', 
                CLK=>internal_200MHz, LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>open, Q1=>wifi_iddr_fifo_inst_r_gcount_w24, OFX0=>open, 
                F0=>open, Q0=>wifi_iddr_fifo_inst_r_gcount_w23);
    wifi_iddr_fifo_inst_SLICE_218I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_rcount_1, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>wifi_iddr_fifo_inst_rcount_0, 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_rptr_1, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_rptr_0);
    wifi_iddr_fifo_inst_SLICE_219I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   LSRMUX=>"SIG", SRMODE=>"ASYNC", CHECK_M1=>TRUE, 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_rcount_3, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>wifi_iddr_fifo_inst_rcount_2, 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_rptr_3, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_rptr_2);
    wifi_iddr_fifo_inst_SLICE_221I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_inst_wcount_1, 
                B1=>wifi_iddr_fifo_inst_wcount_2, C1=>'X', D1=>'X', 
                DI1=>wifi_iddr_fifo_inst_w_gdata_1, 
                DI0=>wifi_iddr_fifo_inst_w_gdata_0, 
                A0=>wifi_iddr_fifo_inst_wcount_0, 
                B0=>wifi_iddr_fifo_inst_wcount_1, C0=>'X', D0=>'X', M0=>'X', 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>wifi_iddr_fifo_inst_w_gdata_1, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_1, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_w_gdata_0, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_0);
    wifi_iddr_fifo_inst_SLICE_222I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6666", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_inst_wcount_3, 
                B1=>wifi_iddr_fifo_inst_wcount_4, C1=>'X', D1=>'X', 
                DI1=>wifi_iddr_fifo_inst_w_gdata_3, 
                DI0=>wifi_iddr_fifo_inst_w_gdata_2, 
                A0=>wifi_iddr_fifo_inst_wcount_2, 
                B0=>wifi_iddr_fifo_inst_wcount_3, C0=>'X', D0=>'X', M0=>'X', 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>wifi_iddr_fifo_inst_w_gdata_3, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_3, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_w_gdata_2, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_2);
    wifi_iddr_fifo_inst_SLICE_223I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>wifi_iddr_fifo_inst_wcount_4, 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_4);
    wifi_iddr_fifo_inst_SLICE_224I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_w_gcount_1, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_w_gcount_0, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_r1, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_r0);
    wifi_iddr_fifo_inst_SLICE_225I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_w_gcount_3, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_w_gcount_2, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_r3, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_r2);
    wifi_iddr_fifo_inst_SLICE_226I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_w_gcount_r0, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_w_gcount_4, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_r20, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_r4);
    wifi_iddr_fifo_inst_SLICE_227I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_w_gcount_r2, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_w_gcount_r1, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_r22, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_r21);
    wifi_iddr_fifo_inst_SLICE_228I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_w_gcount_r4, FXA=>'X', FXB=>'X', 
                A1=>'X', B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>'X', B0=>'X', C0=>'X', D0=>'X', 
                M0=>wifi_iddr_fifo_inst_w_gcount_r3, CE=>'X', 
                CLK=>internal_80MHz, LSR=>'X', OFX1=>open, F1=>open, 
                Q1=>wifi_iddr_fifo_inst_w_gcount_r24, OFX0=>open, F0=>open, 
                Q0=>wifi_iddr_fifo_inst_w_gcount_r23);
    wifi_iddr_fifo_inst_SLICE_229I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_wcount_1, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>wifi_iddr_fifo_inst_wcount_0, 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>wifi_iddr_fifo_inst_wptr_1, 
                OFX0=>open, F0=>open, Q0=>wifi_iddr_fifo_inst_wptr_0);
    wifi_iddr_fifo_inst_SLICE_230I: SLOGICB
      generic map (M0MUX=>"SIG", M1MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", 
                   SRMODE=>"ASYNC", CHECK_M1=>TRUE, CHECK_M0=>TRUE, 
                   CHECK_CE=>TRUE)
      port map (M1=>wifi_iddr_fifo_inst_wcount_3, FXA=>'X', FXB=>'X', A1=>'X', 
                B1=>'X', C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', 
                B0=>'X', C0=>'X', D0=>'X', M0=>wifi_iddr_fifo_inst_wcount_2, 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>wifi_iddr_fifo_inst_wptr_3, 
                OFX0=>open, F0=>open, Q0=>wifi_iddr_fifo_inst_wptr_2);
    wifi_iddr_SLICE_232I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"INV", 
                   LUT0_INITVAL=>X"5555", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>wifi_iddr_n2950, 
                A0=>wifi_iddr_fifo_full, B0=>'X', C0=>'X', D0=>'X', M0=>'X', 
                CE=>'X', CLK=>internal_200MHz, LSR=>data_falling, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>wifi_iddr_n2950, 
                Q0=>wifi_iddr_fifo_wr_en);
    wifi_q_spi_SLICE_233I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"78F0", REG0_SD=>"VHI", CHECK_DI0=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>wifi_q_spi_bit_count_4_N_218_0, 
                A0=>spi4_sck_c, B0=>wifi_q_spi_spi_clk_enable, 
                C0=>wifi_q_spi_bit_count_0, D0=>spi_busy_adj_299, M0=>'X', 
                CE=>'X', CLK=>internal_160MHz, LSR=>n2935, OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, 
                F0=>wifi_q_spi_bit_count_4_N_218_0, Q0=>wifi_q_spi_bit_count_0);
    wifi_q_spi_SLICE_234I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"9999", LUT1_INITVAL=>X"E1E1", 
                   REG1_SD=>"VHI", REG0_SD=>"VHI", CHECK_DI1=>TRUE, 
                   CHECK_DI0=>TRUE, CHECK_CE=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_q_spi_bit_count_1, 
                B1=>wifi_q_spi_bit_count_0, C1=>wifi_q_spi_bit_count_2, 
                D1=>'X', DI1=>wifi_q_spi_n1336, DI0=>wifi_q_spi_n1334, 
                A0=>wifi_q_spi_bit_count_1, B0=>wifi_q_spi_bit_count_0, 
                C0=>'X', D0=>'X', M0=>'X', 
                CE=>wifi_q_spi_internal_160MHz_enable_79, CLK=>internal_160MHz, 
                LSR=>n2935, OFX1=>open, F1=>wifi_q_spi_n1336, 
                Q1=>wifi_q_spi_bit_count_2, OFX0=>open, F0=>wifi_q_spi_n1334, 
                Q0=>wifi_q_spi_bit_count_1);
    wifi_q_spi_SLICE_235I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"F0E1", LUT1_INITVAL=>X"FDFD", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_q_spi_bit_count_0, 
                B1=>wifi_q_spi_n8, C1=>wifi_q_spi_bit_count_3, D1=>'X', 
                DI1=>'X', DI0=>wifi_q_spi_n1330, A0=>wifi_q_spi_bit_count_1, 
                B0=>wifi_q_spi_bit_count_0, C0=>wifi_q_spi_bit_count_3, 
                D0=>wifi_q_spi_bit_count_2, M0=>'X', 
                CE=>wifi_q_spi_internal_160MHz_enable_79, CLK=>internal_160MHz, 
                LSR=>n2935, OFX1=>open, F1=>n2689, Q1=>open, OFX0=>open, 
                F0=>wifi_q_spi_n1330, Q0=>wifi_q_spi_bit_count_3);
    wifi_q_spi_SLICE_236I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"EEED", LUT1_INITVAL=>X"FEFE", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_q_spi_bit_count_1, 
                B1=>wifi_q_spi_bit_count_0, C1=>wifi_q_spi_bit_count_2, 
                D1=>'X', DI1=>'X', DI0=>wifi_q_spi_bit_count_4_N_184_4, 
                A0=>wifi_q_spi_bit_count_4, B0=>n2935, 
                C0=>wifi_q_spi_bit_count_3, D0=>wifi_q_spi_n2941, M0=>'X', 
                CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, LSR=>'X', 
                OFX1=>open, F1=>wifi_q_spi_n2941, Q1=>open, OFX0=>open, 
                F0=>wifi_q_spi_bit_count_4_N_184_4, Q0=>wifi_q_spi_bit_count_4);
    SLICE_237I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"FB40", LUT1_INITVAL=>X"8888", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_rx_24_fifo_push, 
                B1=>stm_fpga_spare2_c, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>shift_reg_15_N_168_0_adj_329, A0=>spi_busy_adj_299, 
                B0=>n2943, C0=>w_rx_24_fifo_data_1, D0=>shift_reg_1_adj_314, 
                M0=>'X', CE=>internal_160MHz_enable_81, CLK=>internal_160MHz, 
                LSR=>'X', OFX1=>open, F1=>n2943, Q1=>open, OFX0=>open, 
                F0=>shift_reg_15_N_168_0_adj_329, Q0=>wifi_q_spi_shift_reg_0);
    wifi_q_spi_SLICE_238I: SLOGICB
      generic map (CLKMUX=>"SIG", CEMUX=>"VHI", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"DCFC", LUT1_INITVAL=>X"8080", 
                   REG0_SD=>"VHI", CHECK_DI0=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi4_sck_c, 
                B1=>wifi_q_spi_spi_clk_enable, C1=>spi_busy_adj_299, D1=>'X', 
                DI1=>'X', DI0=>wifi_q_spi_n1905, A0=>wifi_q_spi_n2645, 
                B0=>n2935, C0=>wifi_q_spi_spi_clk_enable, 
                D0=>wifi_q_spi_internal_160MHz_enable_79, M0=>'X', CE=>'X', 
                CLK=>internal_160MHz, LSR=>'X', OFX1=>open, 
                F1=>wifi_q_spi_internal_160MHz_enable_79, Q1=>open, OFX0=>open, 
                F0=>wifi_q_spi_n1905, Q0=>wifi_q_spi_spi_clk_enable);
    lvds_rx_24_inst_SLICE_239I: SLOGICB
      generic map (LUT0_INITVAL=>X"4050", LUT1_INITVAL=>X"0008")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>lvds_rx_24_inst_n2663, 
                B1=>lvds_rx_24_inst_n2951, C1=>lvds_rx_24_inst_n2957, 
                D1=>o_debug_state_1_adj_230, DI1=>'X', DI0=>'X', 
                A0=>lvds_rx_24_inst_n2612, B0=>lvds_rx_24_inst_n1277, 
                C0=>wifi_ddr_data_valid, D0=>o_debug_state_1_adj_230, M0=>'X', 
                CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_24_inst_n2612, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_24_inst_internal_80MHz_enable_59, Q0=>open);
    my_led_SLICE_240I: SLOGICB
      generic map (LUT0_INITVAL=>X"FFEF", LUT1_INITVAL=>X"FFFE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>my_led_counter_12, 
                B1=>my_led_counter_0, C1=>my_led_counter_18, 
                D1=>my_led_counter_16, DI1=>'X', DI0=>'X', A0=>my_led_n2713, 
                B0=>my_led_n2725, C0=>my_led_counter_7, D0=>my_led_n2717, 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>my_led_n2717, Q1=>open, OFX0=>open, F0=>my_led_n2739, 
                Q0=>open);
    my_led_SLICE_241I: SLOGICB
      generic map (LUT0_INITVAL=>X"FFFE", LUT1_INITVAL=>X"EEEE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>my_led_counter_25, 
                B1=>my_led_counter_2, C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>my_led_counter_22, B0=>my_led_n2699, C0=>my_led_n2701, 
                D0=>my_led_counter_15, M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>my_led_n2701, Q1=>open, OFX0=>open, 
                F0=>my_led_n2721, Q0=>open);
    my_led_SLICE_242I: SLOGICB
      generic map (LUT0_INITVAL=>X"FFFD", LUT1_INITVAL=>X"EEEE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>my_led_counter_21, 
                B1=>my_led_counter_4, C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>my_led_counter_8, B0=>my_led_counter_13, C0=>my_led_n2705, 
                D0=>my_led_counter_3, M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>my_led_n2705, Q1=>open, OFX0=>open, 
                F0=>my_led_n2725, Q0=>open);
    wifi_q_spi_SLICE_243I: SLOGICB
      generic map (LUT0_INITVAL=>X"1010", LUT1_INITVAL=>X"FEFE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_q_spi_bit_count_1, 
                B1=>wifi_q_spi_bit_count_2, C1=>wifi_q_spi_bit_count_4, 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>wifi_q_spi_n8, 
                B0=>wifi_q_spi_bit_count_3, C0=>wifi_q_spi_bit_count_0, 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>wifi_q_spi_n8, Q1=>open, OFX0=>open, F0=>wifi_q_spi_n2645, 
                Q0=>open);
    SLICE_244I: SLOGICB
      generic map (LUT0_INITVAL=>X"D0D0", LUT1_INITVAL=>X"1030")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>lvds_rx_09_inst_n2677, 
                B1=>n1766, C1=>subg_ddr_data_valid, D1=>lvds_rx_09_inst_n2945, 
                DI1=>'X', DI0=>'X', A0=>n2949, B0=>o_debug_state_0, 
                C0=>o_debug_state_1, D0=>'X', M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_09_inst_internal_80MHz_enable_57, Q1=>open, 
                OFX0=>open, F0=>n1766, Q0=>open);
    SLICE_245I: SLOGICB
      generic map (LUT0_INITVAL=>X"F808", LUT1_INITVAL=>X"8888")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi3_sck_c, 
                B1=>wifi_i_spi_spi_clk_enable, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>w_rx_24_fifo_push, B0=>stm_fpga_spare2_c, 
                C0=>spi_busy_adj_268, D0=>n3032, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', OFX1=>open, F1=>n3032, Q1=>open, OFX0=>open, 
                F0=>internal_160MHz_enable_82, Q0=>open);
    SLICE_246I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"VHI", LSRMUX=>"SIG", 
                   LUT0_INITVAL=>X"8080", LUT1_INITVAL=>X"4040", 
                   CHECK_M0=>TRUE, CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_full, 
                B1=>data_falling, C1=>n2955, D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>pll_lock, B0=>stm_fpga_spare5_c, C0=>second_pll_lock, 
                D0=>'X', M0=>subg_iddr_sdr_rxclk_last, CE=>'X', 
                CLK=>internal_200MHz, LSR=>sdr_rxclk_c, OFX1=>open, 
                F1=>wifi_iddr_internal_200MHz_enable_4, Q1=>open, OFX0=>open, 
                F0=>n2955, Q0=>data_falling);
    SLICE_247I: SLOGICB
      generic map (LUT0_INITVAL=>X"8000", LUT1_INITVAL=>X"0AA2")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>n2629, 
                B1=>lvds_rx_24_inst_n2498, C1=>o_debug_state_0_adj_231, 
                D1=>o_debug_state_1_adj_230, DI1=>'X', DI0=>'X', A0=>pll_lock, 
                B0=>stm_fpga_spare5_c, C0=>second_pll_lock, 
                D0=>wifi_ddr_data_valid, M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>lvds_rx_24_inst_internal_80MHz_enable_56, 
                Q1=>open, OFX0=>open, F0=>n2629, Q0=>open);
    SLICE_248I: SLOGICB
      generic map (LUT0_INITVAL=>X"8000", LUT1_INITVAL=>X"0AA2")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>n2627, 
                B1=>lvds_rx_09_inst_n2496, C1=>o_debug_state_0, 
                D1=>o_debug_state_1, DI1=>'X', DI0=>'X', A0=>pll_lock, 
                B0=>stm_fpga_spare5_c, C0=>second_pll_lock, 
                D0=>subg_ddr_data_valid, M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>lvds_rx_09_inst_internal_80MHz_enable_68, 
                Q1=>open, OFX0=>open, F0=>n2627, Q0=>open);
    SLICE_249I: SLOGICB
      generic map (LUT0_INITVAL=>X"F088", LUT1_INITVAL=>X"8888")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>fpga_ufl_p7_c, 
                B1=>subg_q_spi_spi_clk_enable, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>w_rx_09_fifo_push, B0=>stm_fpga_spare1_c, 
                C0=>n3031, D0=>spi_busy_adj_237, M0=>'X', CE=>'X', CLK=>'X', 
                LSR=>'X', OFX1=>open, F1=>n3031, Q1=>open, OFX0=>open, 
                F0=>internal_160MHz_enable_83, Q0=>open);
    SLICE_250I: SLOGICB
      generic map (LUT0_INITVAL=>X"F808", LUT1_INITVAL=>X"8888")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>spi1_sck_c, 
                B1=>subg_i_spi_spi_clk_enable, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>w_rx_09_fifo_push, B0=>stm_fpga_spare1_c, 
                C0=>spi_busy, D0=>n3030, M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>n3030, Q1=>open, OFX0=>open, 
                F0=>internal_160MHz_enable_84, Q0=>open);
    subg_iddr_fifo_inst_SLICE_251I: SLOGICB
      generic map (LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6996")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_iddr_fifo_inst_wcount_r3, 
                B1=>subg_iddr_fifo_inst_w_gcount_r22, 
                C1=>subg_iddr_fifo_inst_w_gcount_r21, 
                D1=>subg_iddr_fifo_inst_w_gcount_r20, DI1=>'X', DI0=>'X', 
                A0=>subg_iddr_fifo_inst_w_gcount_r24, 
                B0=>subg_iddr_fifo_inst_w_gcount_r23, C0=>'X', D0=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>subg_iddr_fifo_inst_wcount_r0, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_wcount_r3, Q0=>open);
    subg_iddr_fifo_inst_SLICE_252I: SLOGICB
      generic map (LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6996")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_iddr_fifo_inst_rcount_w3, 
                B1=>subg_iddr_fifo_inst_r_gcount_w22, 
                C1=>subg_iddr_fifo_inst_r_gcount_w21, 
                D1=>subg_iddr_fifo_inst_r_gcount_w20, DI1=>'X', DI0=>'X', 
                A0=>subg_iddr_fifo_inst_r_gcount_w24, 
                B0=>subg_iddr_fifo_inst_r_gcount_w23, C0=>'X', D0=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>subg_iddr_fifo_inst_rcount_w0, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_rcount_w3, Q0=>open);
    subg_i_spi_SLICE_253I: SLOGICB
      generic map (LUT0_INITVAL=>X"FEFE", LUT1_INITVAL=>X"1010")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_i_spi_n8, 
                B1=>subg_i_spi_bit_count_3, C1=>subg_i_spi_bit_count_0, 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>subg_i_spi_bit_count_1, 
                B0=>subg_i_spi_bit_count_2, C0=>subg_i_spi_bit_count_4, 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>subg_i_spi_n2653, Q1=>open, OFX0=>open, F0=>subg_i_spi_n8, 
                Q0=>open);
    wifi_iddr_fifo_inst_SLICE_254I: SLOGICB
      generic map (LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6996")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_inst_wcount_r3, 
                B1=>wifi_iddr_fifo_inst_w_gcount_r22, 
                C1=>wifi_iddr_fifo_inst_w_gcount_r21, 
                D1=>wifi_iddr_fifo_inst_w_gcount_r20, DI1=>'X', DI0=>'X', 
                A0=>wifi_iddr_fifo_inst_w_gcount_r24, 
                B0=>wifi_iddr_fifo_inst_w_gcount_r23, C0=>'X', D0=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_wcount_r0, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_wcount_r3, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_255I: SLOGICB
      generic map (LUT0_INITVAL=>X"6666", LUT1_INITVAL=>X"6996")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_iddr_fifo_inst_rcount_w3, 
                B1=>wifi_iddr_fifo_inst_r_gcount_w22, 
                C1=>wifi_iddr_fifo_inst_r_gcount_w21, 
                D1=>wifi_iddr_fifo_inst_r_gcount_w20, DI1=>'X', DI0=>'X', 
                A0=>wifi_iddr_fifo_inst_r_gcount_w24, 
                B0=>wifi_iddr_fifo_inst_r_gcount_w23, C0=>'X', D0=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_rcount_w0, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_rcount_w3, Q0=>open);
    subg_q_spi_SLICE_256I: SLOGICB
      generic map (LUT0_INITVAL=>X"1010", LUT1_INITVAL=>X"FEFE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_q_spi_bit_count_1, 
                B1=>subg_q_spi_bit_count_2, C1=>subg_q_spi_bit_count_4, 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>subg_q_spi_n8, 
                B0=>subg_q_spi_bit_count_3, C0=>subg_q_spi_bit_count_0, 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>subg_q_spi_n8, Q1=>open, OFX0=>open, F0=>subg_q_spi_n2641, 
                Q0=>open);
    lvds_rx_09_inst_SLICE_257I: SLOGICB
      generic map (LUT0_INITVAL=>X"EEEE", LUT1_INITVAL=>X"0100")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_2, 
                B1=>lvds_rx_09_inst_n2942, C1=>o_debug_state_1, 
                D1=>o_debug_state_0, DI1=>'X', DI0=>'X', A0=>r_phase_count_1, 
                B0=>r_phase_count_0, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>lvds_rx_09_inst_n2677, 
                Q1=>open, OFX0=>open, F0=>lvds_rx_09_inst_n2942, Q0=>open);
    wifi_i_spi_SLICE_258I: SLOGICB
      generic map (LUT0_INITVAL=>X"1010", LUT1_INITVAL=>X"FEFE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_i_spi_bit_count_1, 
                B1=>wifi_i_spi_bit_count_2, C1=>wifi_i_spi_bit_count_4, 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>wifi_i_spi_n8, 
                B0=>wifi_i_spi_bit_count_3, C0=>wifi_i_spi_bit_count_0, 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>wifi_i_spi_n8, Q1=>open, OFX0=>open, F0=>wifi_i_spi_n2649, 
                Q0=>open);
    SLICE_259I: SLOGICB
      generic map (LUT0_INITVAL=>X"0808", LUT1_INITVAL=>X"F808")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>w_rx_24_fifo_push, 
                B1=>stm_fpga_spare2_c, C1=>spi_busy_adj_299, D1=>n3029, 
                DI1=>'X', DI0=>'X', A0=>w_rx_24_fifo_push, 
                B0=>stm_fpga_spare2_c, C0=>spi_busy_adj_299, D0=>'X', M0=>'X', 
                CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>internal_160MHz_enable_81, Q1=>open, OFX0=>open, F0=>n2935, 
                Q0=>open);
    subg_iddr_fifo_inst_SLICE_260I: SLOGICB
      generic map (LUT0_INITVAL=>X"6996", LUT1_INITVAL=>X"9696")
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>subg_iddr_fifo_inst_w_gcount_r24, 
                B1=>subg_iddr_fifo_inst_w_gcount_r23, 
                C1=>subg_iddr_fifo_inst_w_gcount_r22, D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>subg_iddr_fifo_inst_w_gcount_r24, 
                B0=>subg_iddr_fifo_inst_w_gcount_r23, 
                C0=>subg_iddr_fifo_inst_w_gcount_r22, 
                D0=>subg_iddr_fifo_inst_w_gcount_r21, M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>subg_iddr_fifo_inst_wcount_r2, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_w_g2b_xor_cluster_0, Q0=>open);
    subg_iddr_fifo_inst_SLICE_261I: SLOGICB
      generic map (LUT0_INITVAL=>X"6996", LUT1_INITVAL=>X"9696")
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>subg_iddr_fifo_inst_r_gcount_w24, 
                B1=>subg_iddr_fifo_inst_r_gcount_w23, 
                C1=>subg_iddr_fifo_inst_r_gcount_w22, D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>subg_iddr_fifo_inst_r_gcount_w24, 
                B0=>subg_iddr_fifo_inst_r_gcount_w23, 
                C0=>subg_iddr_fifo_inst_r_gcount_w22, 
                D0=>subg_iddr_fifo_inst_r_gcount_w21, M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>subg_iddr_fifo_inst_rcount_w2, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_r_g2b_xor_cluster_0, Q0=>open);
    subg_iddr_fifo_inst_SLICE_262I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"2424", 
                   LUT1_INITVAL=>X"4242", CHECK_M0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>subg_iddr_fifo_inst_w_gcount_r24, 
                B1=>subg_iddr_fifo_inst_rcount_4, 
                C1=>subg_iddr_fifo_inst_rptr_4, D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>subg_iddr_fifo_inst_w_gcount_r24, 
                B0=>subg_iddr_fifo_inst_rcount_4, 
                C0=>subg_iddr_fifo_inst_rptr_4, D0=>'X', 
                M0=>subg_iddr_fifo_inst_rcount_4, 
                CE=>subg_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>subg_iddr_fifo_inst_empty_cmp_clr, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_empty_cmp_set, 
                Q0=>subg_iddr_fifo_inst_rptr_4);
    subg_iddr_fifo_inst_SLICE_263I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"1818", LUT1_INITVAL=>X"8181", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>subg_iddr_fifo_inst_r_gcount_w24, 
                B1=>subg_iddr_fifo_inst_wcount_4, 
                C1=>subg_iddr_fifo_inst_wptr_4, D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>subg_iddr_fifo_inst_r_gcount_w24, 
                B0=>subg_iddr_fifo_inst_wcount_4, 
                C0=>subg_iddr_fifo_inst_wptr_4, D0=>'X', 
                M0=>subg_iddr_fifo_inst_wcount_4, 
                CE=>subg_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>subg_iddr_fifo_inst_full_cmp_clr, Q1=>open, 
                OFX0=>open, F0=>subg_iddr_fifo_inst_full_cmp_set, 
                Q0=>subg_iddr_fifo_inst_wptr_4);
    wifi_iddr_fifo_inst_SLICE_264I: SLOGICB
      generic map (LUT0_INITVAL=>X"6996", LUT1_INITVAL=>X"9696")
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>wifi_iddr_fifo_inst_w_gcount_r24, 
                B1=>wifi_iddr_fifo_inst_w_gcount_r23, 
                C1=>wifi_iddr_fifo_inst_w_gcount_r22, D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>wifi_iddr_fifo_inst_w_gcount_r24, 
                B0=>wifi_iddr_fifo_inst_w_gcount_r23, 
                C0=>wifi_iddr_fifo_inst_w_gcount_r22, 
                D0=>wifi_iddr_fifo_inst_w_gcount_r21, M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_wcount_r2, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_w_g2b_xor_cluster_0, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_265I: SLOGICB
      generic map (LUT0_INITVAL=>X"6996", LUT1_INITVAL=>X"9696")
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>wifi_iddr_fifo_inst_r_gcount_w24, 
                B1=>wifi_iddr_fifo_inst_r_gcount_w23, 
                C1=>wifi_iddr_fifo_inst_r_gcount_w22, D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>wifi_iddr_fifo_inst_r_gcount_w24, 
                B0=>wifi_iddr_fifo_inst_r_gcount_w23, 
                C0=>wifi_iddr_fifo_inst_r_gcount_w22, 
                D0=>wifi_iddr_fifo_inst_r_gcount_w21, M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_rcount_w2, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_r_g2b_xor_cluster_0, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_266I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", LSRMUX=>"SIG", 
                   SRMODE=>"ASYNC", LUT0_INITVAL=>X"2424", 
                   LUT1_INITVAL=>X"4242", CHECK_M0=>TRUE, CHECK_CE=>TRUE, 
                   CHECK_LSR=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>wifi_iddr_fifo_inst_w_gcount_r24, 
                B1=>wifi_iddr_fifo_inst_rcount_4, 
                C1=>wifi_iddr_fifo_inst_rptr_4, D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>wifi_iddr_fifo_inst_w_gcount_r24, 
                B0=>wifi_iddr_fifo_inst_rcount_4, 
                C0=>wifi_iddr_fifo_inst_rptr_4, D0=>'X', 
                M0=>wifi_iddr_fifo_inst_rcount_4, 
                CE=>wifi_iddr_fifo_inst_rden_i, CLK=>internal_80MHz, 
                LSR=>main_reset_n_N_4, OFX1=>open, 
                F1=>wifi_iddr_fifo_inst_empty_cmp_clr, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_empty_cmp_set, 
                Q0=>wifi_iddr_fifo_inst_rptr_4);
    wifi_iddr_fifo_inst_SLICE_267I: SLOGICB
      generic map (M0MUX=>"SIG", CLKMUX=>"SIG", CEMUX=>"SIG", SRMODE=>"ASYNC", 
                   LUT0_INITVAL=>X"1818", LUT1_INITVAL=>X"8181", 
                   CHECK_M0=>TRUE, CHECK_CE=>TRUE)
      port map (M1=>'X', FXA=>'X', FXB=>'X', 
                A1=>wifi_iddr_fifo_inst_r_gcount_w24, 
                B1=>wifi_iddr_fifo_inst_wcount_4, 
                C1=>wifi_iddr_fifo_inst_wptr_4, D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>wifi_iddr_fifo_inst_r_gcount_w24, 
                B0=>wifi_iddr_fifo_inst_wcount_4, 
                C0=>wifi_iddr_fifo_inst_wptr_4, D0=>'X', 
                M0=>wifi_iddr_fifo_inst_wcount_4, 
                CE=>wifi_iddr_fifo_inst_wren_i, CLK=>internal_200MHz, LSR=>'X', 
                OFX1=>open, F1=>wifi_iddr_fifo_inst_full_cmp_clr, Q1=>open, 
                OFX0=>open, F0=>wifi_iddr_fifo_inst_full_cmp_set, 
                Q0=>wifi_iddr_fifo_inst_wptr_4);
    my_led_SLICE_268I: SLOGICB
      generic map (LUT0_INITVAL=>X"8000", LUT1_INITVAL=>X"8888")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>my_led_counter_9, 
                B1=>my_led_counter_17, C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>my_led_counter_11, B0=>my_led_counter_20, 
                C0=>my_led_counter_14, D0=>my_led_counter_10, M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>my_led_n2773, Q1=>open, 
                OFX0=>open, F0=>my_led_n2781, Q0=>open);
    lvds_rx_24_inst_SLICE_269I: SLOGICB
      generic map (LUT0_INITVAL=>X"BBBB", LUT1_INITVAL=>X"EEEE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>r_phase_count_1_adj_233, 
                B1=>r_phase_count_0_adj_234, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>w_lvds_rx_24_d1, B0=>w_lvds_rx_24_d0, C0=>'X', 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_24_inst_n2957, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_24_inst_n2951, Q0=>open);
    lvds_rx_24_inst_SLICE_270I: SLOGICB
      generic map (LUT0_INITVAL=>X"BBBB", LUT1_INITVAL=>X"4C4C")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0_adj_231, 
                B1=>wifi_ddr_data_valid, C1=>o_debug_state_1_adj_230, D1=>'X', 
                DI1=>'X', DI0=>'X', A0=>w_lvds_rx_24_d0, B0=>w_lvds_rx_24_d1, 
                C0=>'X', D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>lvds_rx_24_inst_internal_80MHz_enable_17, 
                Q1=>open, OFX0=>open, F0=>lvds_rx_24_inst_n2498, Q0=>open);
    SLICE_271I: SLOGICB
      generic map (LUT0_INITVAL=>X"0808", LUT1_INITVAL=>X"7F7F")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>pll_lock, 
                B1=>stm_fpga_spare5_c, C1=>second_pll_lock, D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>n2955, B0=>data_falling, C0=>subg_iddr_fifo_full, 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>main_reset_n_N_4, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_internal_200MHz_enable_3, Q0=>open);
    lvds_rx_09_inst_SLICE_272I: SLOGICB
      generic map (LUT0_INITVAL=>X"DDDD", LUT1_INITVAL=>X"4C4C")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>o_debug_state_0, 
                B1=>subg_ddr_data_valid, C1=>o_debug_state_1, D1=>'X', 
                DI1=>'X', DI0=>'X', A0=>w_lvds_rx_09_d0, B0=>w_lvds_rx_09_d1, 
                C0=>'X', D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>lvds_rx_09_inst_internal_80MHz_enable_30, 
                Q1=>open, OFX0=>open, F0=>lvds_rx_09_inst_n2496, Q0=>open);
    lvds_rx_09_inst_SLICE_273I: SLOGICB
      generic map (LUT0_INITVAL=>X"DDDD", LUT1_INITVAL=>X"8888")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>subg_ddr_data_valid, 
                B1=>o_debug_state_1, C1=>'X', D1=>'X', DI1=>'X', DI0=>'X', 
                A0=>w_lvds_rx_09_d1, B0=>w_lvds_rx_09_d0, C0=>'X', D0=>'X', 
                M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_09_inst_n1924, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_09_inst_n2945, Q0=>open);
    lvds_rx_24_inst_SLICE_274I: SLOGICB
      generic map (LUT0_INITVAL=>X"EEEE", LUT1_INITVAL=>X"8888")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>wifi_ddr_data_valid, 
                B1=>o_debug_state_1_adj_230, C1=>'X', D1=>'X', DI1=>'X', 
                DI0=>'X', A0=>r_phase_count_1_adj_233, 
                B0=>r_phase_count_2_adj_232, C0=>'X', D0=>'X', M0=>'X', 
                CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>lvds_rx_24_inst_n1926, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_24_inst_n2952, Q0=>open);
    my_led_SLICE_275I: SLOGICB
      generic map (LUT0_INITVAL=>X"FFFE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>my_led_counter_6, 
                B0=>my_led_counter_24, C0=>my_led_counter_19, 
                D0=>my_led_counter_1, M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, F0=>my_led_n2713, 
                Q0=>open);
    my_led_SLICE_276I: SLOGICB
      generic map (LUT0_INITVAL=>X"EEEE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>my_led_counter_23, 
                B0=>my_led_counter_5, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>my_led_n2699, Q0=>open);
    SLICE_277I: SLOGICB
      generic map (LUT0_INITVAL=>X"5555")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>stm_fpga_spare5_c, B0=>'X', 
                C0=>'X', D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', 
                OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>stm_fpga_spare5_N_9, Q0=>open);
    subg_iddr_fifo_inst_SLICE_278I: SLOGICB
      generic map (LUT0_INITVAL=>X"2222")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>subg_iddr_fifo_wr_en, 
                B0=>subg_iddr_fifo_full, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_wren_i, Q0=>open);
    subg_iddr_fifo_inst_SLICE_279I: SLOGICB
      generic map (LUT0_INITVAL=>X"2222")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>subg_ddr_data_valid, 
                B0=>subg_iddr_fifo_empty, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>subg_iddr_fifo_inst_rden_i, Q0=>open);
    lvds_rx_24_inst_SLICE_280I: SLOGICB
      generic map (LUT0_INITVAL=>X"4444")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>r_phase_count_2_adj_232, 
                B0=>o_debug_state_0_adj_231, C0=>'X', D0=>'X', M0=>'X', 
                CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, 
                OFX0=>open, F0=>lvds_rx_24_inst_n2663, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_281I: SLOGICB
      generic map (LUT0_INITVAL=>X"2222")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>wifi_iddr_fifo_wr_en, 
                B0=>wifi_iddr_fifo_full, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_wren_i, Q0=>open);
    wifi_iddr_fifo_inst_SLICE_282I: SLOGICB
      generic map (LUT0_INITVAL=>X"2222")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>wifi_ddr_data_valid, 
                B0=>wifi_iddr_fifo_empty, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>wifi_iddr_fifo_inst_rden_i, Q0=>open);
    lvds_rx_09_inst_SLICE_283I: SLOGICB
      generic map (LUT0_INITVAL=>X"EEEE")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>r_phase_count_1, 
                B0=>w_lvds_rx_09_d0, C0=>'X', D0=>'X', M0=>'X', CE=>'X', 
                CLK=>'X', LSR=>'X', OFX1=>open, F1=>open, Q1=>open, OFX0=>open, 
                F0=>lvds_rx_09_inst_n2765, Q0=>open);
    SLICE_284I: SLOGICB
      generic map (LUT0_INITVAL=>X"0000")
      port map (M1=>'X', FXA=>'X', FXB=>'X', A1=>'X', B1=>'X', C1=>'X', 
                D1=>'X', DI1=>'X', DI0=>'X', A0=>'X', B0=>'X', C0=>'X', 
                D0=>'X', M0=>'X', CE=>'X', CLK=>'X', LSR=>'X', OFX1=>open, 
                F1=>open, Q1=>open, OFX0=>open, F0=>GND_net, Q0=>open);
    fpga_ledI: fpga_ledB
      port map (PADDO=>fpga_led_c, fpgaled=>fpga_led);
    fpga_neopixelI: fpga_neopixelB
      port map (fpganeopixel=>fpga_neopixel);
    sdr_txclkI: sdr_txclkB
      port map (sdrtxclk=>sdr_txclk);
    sdr_txdataI: sdr_txdataB
      port map (sdrtxdata=>sdr_txdata);
    spi1_sckI: spi1_sckB
      port map (PADDO=>spi1_sck_c, spi1sck=>spi1_sck);
    spi1_mosiI: spi1_mosiB
      port map (PADDO=>spi1_mosi_c, spi1mosi=>spi1_mosi);
    spi2_sckI: spi2_sckB
      port map (PADDO=>fpga_ufl_p7_c, spi2sck=>spi2_sck);
    spi2_mosiI: spi2_mosiB
      port map (PADDO=>fpga_ufl_p8_c, spi2mosi=>spi2_mosi);
    spi3_sckI: spi3_sckB
      port map (PADDO=>spi3_sck_c, spi3sck=>spi3_sck);
    spi3_mosiI: spi3_mosiB
      port map (PADDO=>spi3_mosi_c, spi3mosi=>spi3_mosi);
    spi4_sckI: spi4_sckB
      port map (PADDO=>spi4_sck_c, spi4sck=>spi4_sck);
    spi4_mosiI: spi4_mosiB
      port map (PADDO=>spi4_mosi_c, spi4mosi=>spi4_mosi);
    fpga_ufl_p7I: fpga_ufl_p7B
      port map (PADDO=>fpga_ufl_p7_c, fpgauflp7=>fpga_ufl_p7);
    fpga_ufl_p8I: fpga_ufl_p8B
      port map (PADDO=>fpga_ufl_p8_c, fpgauflp8=>fpga_ufl_p8);
    dpll_clkout2I: dpll_clkout2B
      port map (PADDI=>dpll_clkout2_c, dpllclkout2=>dpll_clkout2);
    dpll_clkout0I: dpll_clkout0B
      port map (PADDI=>dpll_clkout0_c, dpllclkout0=>dpll_clkout0);
    sdr_rx_wifiI: sdr_rx_wifiB
      port map (PADDI=>sdr_rx_wifi_c, sdrrxwifi=>sdr_rx_wifi);
    sdr_rx_subgI: sdr_rx_subgB
      port map (PADDI=>sdr_rx_subg_c, sdrrxsubg=>sdr_rx_subg);
    sdr_rxclkI: sdr_rxclkB
      port map (PADDI=>sdr_rxclk_c, sdrrxclk=>sdr_rxclk);
    stm_fpga_spare1I: stm_fpga_spare1B
      port map (PADDI=>stm_fpga_spare1_c, stmfpgaspare1=>stm_fpga_spare1);
    stm_fpga_spare2I: stm_fpga_spare2B
      port map (PADDI=>stm_fpga_spare2_c, stmfpgaspare2=>stm_fpga_spare2);
    stm_fpga_spare5I: stm_fpga_spare5B
      port map (PADDI=>stm_fpga_spare5_c, stmfpgaspare5=>stm_fpga_spare5);
    my_pll_PLLInst_0I: my_pll_PLLInst_0
      port map (CLKI=>dpll_clkout2_c, CLKFB=>my_pll_CLKOP, STDBY=>GND_net, 
                RST=>stm_fpga_spare5_N_9, LOCK=>pll_lock, 
                CLKOS2=>internal_80MHz, CLKOS=>internal_160MHz, 
                CLKOP=>my_pll_CLKOP);
    osch_instI: osch_inst
      port map (OSC=>int_clk_out);
    subg_iddr_fifo_inst_pdp_ram_0_0_0I: subg_iddr_fifo_inst_pdp_ram_0_0_0
      port map (DIA1=>subg_iddr_fifo_data_1, DIA0=>subg_iddr_fifo_data_0, 
                ADA4=>subg_iddr_fifo_inst_wptr_3, 
                ADA3=>subg_iddr_fifo_inst_wptr_2, 
                ADA2=>subg_iddr_fifo_inst_wptr_1, 
                ADA1=>subg_iddr_fifo_inst_wptr_0, 
                CEA=>subg_iddr_fifo_inst_wren_i, 
                OCEA=>subg_iddr_fifo_inst_wren_i, RSTA=>main_reset_n_N_4, 
                CLKA=>internal_200MHz, CLKB=>internal_80MHz, 
                RSTB=>main_reset_n_N_4, OCEB=>subg_iddr_fifo_inst_rden_i, 
                CEB=>subg_iddr_fifo_inst_rden_i, DOB0=>subg_iddr_fifo_out_0, 
                DOB1=>subg_iddr_fifo_out_1, ADB1=>subg_iddr_fifo_inst_rptr_0, 
                ADB2=>subg_iddr_fifo_inst_rptr_1, 
                ADB3=>subg_iddr_fifo_inst_rptr_2, 
                ADB4=>subg_iddr_fifo_inst_rptr_3);
    second_pll_PLLInst_0I: second_pll_PLLInst_0
      port map (CLKI=>dpll_clkout0_c, CLKFB=>internal_200MHz, STDBY=>GND_net, 
                RST=>stm_fpga_spare5_N_9, LOCK=>second_pll_lock, 
                CLKOP=>internal_200MHz);
    wifi_iddr_fifo_inst_pdp_ram_0_0_0I: wifi_iddr_fifo_inst_pdp_ram_0_0_0
      port map (DIA1=>wifi_iddr_fifo_data_1, DIA0=>wifi_iddr_fifo_data_0, 
                ADA4=>wifi_iddr_fifo_inst_wptr_3, 
                ADA3=>wifi_iddr_fifo_inst_wptr_2, 
                ADA2=>wifi_iddr_fifo_inst_wptr_1, 
                ADA1=>wifi_iddr_fifo_inst_wptr_0, 
                CEA=>wifi_iddr_fifo_inst_wren_i, 
                OCEA=>wifi_iddr_fifo_inst_wren_i, RSTA=>main_reset_n_N_4, 
                CLKA=>internal_200MHz, CLKB=>internal_80MHz, 
                RSTB=>main_reset_n_N_4, OCEB=>wifi_iddr_fifo_inst_rden_i, 
                CEB=>wifi_iddr_fifo_inst_rden_i, DOB0=>wifi_iddr_fifo_out_0, 
                DOB1=>wifi_iddr_fifo_out_1, ADB1=>wifi_iddr_fifo_inst_rptr_0, 
                ADB2=>wifi_iddr_fifo_inst_rptr_1, 
                ADB3=>wifi_iddr_fifo_inst_rptr_2, 
                ADB4=>wifi_iddr_fifo_inst_rptr_3);
    GSR_INST: GSR_INSTB
      port map (GSRNET=>n2955);
    VHI_INST: VHI
      port map (Z=>VCCI);
    PUR_INST: PUR
      port map (PUR=>VCCI);
  end Structure;



  library IEEE, vital2000, ECP5U;
  configuration Structure_CON of top is
    for Structure
    end for;
  end Structure_CON;


