function [waveform, info, cfgDL] = generateNRWaveform()
    cfgDL = nrDLCarrierConfig;
    cfgDL.Label = 'Carrier1';
    cfgDL.FrequencyRange = 'FR1';
    cfgDL.ChannelBandwidth = 50;
    cfgDL.NCellID = 1;
    cfgDL.NumSubframes = 10;
    cfgDL.InitialNSubframe = 0;
    cfgDL.WindowingPercent = 15;
    cfgDL.SampleRate = [];
    cfgDL.CarrierFrequency = 0;

    scscarrier = nrSCSCarrierConfig;
    scscarrier.SubcarrierSpacing = 15;
    scscarrier.NSizeGrid = 270;
    scscarrier.NStartGrid = 3;

    cfgDL.SCSCarriers = {scscarrier};

    bwp = nrWavegenBWPConfig;
    bwp.BandwidthPartID = 1;
    bwp.Label = 'BWP1';
    bwp.SubcarrierSpacing = 15;
    bwp.CyclicPrefix = 'normal';
    bwp.NSizeBWP = 270;
    bwp.NStartBWP = 3;

    cfgDL.BandwidthParts = {bwp};

    ssburst = nrWavegenSSBurstConfig;
    ssburst.Enable = true;
    ssburst.Power = 0;
    ssburst.BlockPattern = 'Case A';
    ssburst.TransmittedBlocks = ones([1 4]);
    ssburst.Period = 20;
    ssburst.NCRBSSB = [];
    ssburst.KSSB = 0;
    ssburst.DataSource = 'MIB';
    ssburst.DMRSTypeAPosition = 2;
    ssburst.CellBarred = false;
    ssburst.IntraFreqReselection = false;
    ssburst.PDCCHConfigSIB1 = 0;
    ssburst.SubcarrierSpacingCommon = 15;

    cfgDL.SSBurst = ssburst;

    coreset1 = nrCORESETConfig;
    coreset1.CORESETID = 0;
    coreset1.Label = 'CORESET0';
    coreset1.FrequencyResources = ones([1 8]);
    coreset1.Duration = 2;
    coreset1.CCEREGMapping = 'interleaved';
    coreset1.REGBundleSize = 6;
    coreset1.InterleaverSize = 2;
    coreset1.ShiftIndex = 0;
    coreset1.PrecoderGranularity = 'sameAsREG-bundle';
    coreset1.RBOffset = [];

    % CORESET 2
    coreset2 = nrCORESETConfig;
    coreset2.CORESETID = 1;
    coreset2.Label = 'CORESET1';
    coreset2.FrequencyResources = ones([1 8]);
    coreset2.Duration = 2;
    coreset2.CCEREGMapping = 'interleaved';
    coreset2.REGBundleSize = 6;
    coreset2.InterleaverSize = 2;
    coreset2.ShiftIndex = 0;
    coreset2.PrecoderGranularity = 'sameAsREG-bundle';
    coreset2.RBOffset = [];

    cfgDL.CORESET = {coreset1,coreset2};

    searchspace = nrSearchSpaceConfig;
    searchspace.SearchSpaceID = 1;
    searchspace.Label = 'SearchSpace1';
    searchspace.CORESETID = 1;
    searchspace.SearchSpaceType = 'ue';
    searchspace.StartSymbolWithinSlot = 0;
    searchspace.SlotPeriodAndOffset = [1 0];
    searchspace.Duration = 1;
    searchspace.NumCandidates = [8 8 4 2 1];

    cfgDL.SearchSpaces = {searchspace};

    pdcch = nrWavegenPDCCHConfig;
    pdcch.Enable = true;
    pdcch.Label = 'PDCCH1';
    pdcch.Power = 0;
    pdcch.BandwidthPartID = 1;
    pdcch.SearchSpaceID = 1;
    pdcch.AggregationLevel = 8;
    pdcch.AllocatedCandidate = 1;
    pdcch.CCEOffset = [];
    pdcch.SlotAllocation = 0;
    pdcch.Period = 1;
    pdcch.Coding = true;
    pdcch.DataBlockSize = 20;
    pdcch.DataSource = 'PN9-ITU';
    pdcch.RNTI = 1;
    pdcch.DMRSScramblingID = 2;
    pdcch.DMRSPower = 0;

    cfgDL.PDCCH = {pdcch};

    pdsch1 = nrWavegenPDSCHConfig;
    pdsch1.Enable = true;
    pdsch1.Label = 'PDSCH1';
    pdsch1.Power = 0;
    pdsch1.BandwidthPartID = 1;
    pdsch1.Modulation = 'QPSK';
    pdsch1.NumLayers = 1;
    pdsch1.MappingType = 'A';
    pdsch1.ReservedCORESET = [];
    pdsch1.SymbolAllocation = [0 14];
    pdsch1.SlotAllocation = 5;
    pdsch1.Period = 10;
    pdsch1.PRBSet = 30:60;
    pdsch1.PRBSetType = 'VRB';
    pdsch1.VRBToPRBInterleaving = false;
    pdsch1.VRBBundleSize = 2;
    pdsch1.NID = [];
    pdsch1.RNTI = 1;
    pdsch1.Coding = true;
    pdsch1.TargetCodeRate = 0.513671875;
    pdsch1.TBScaling = 1;
    pdsch1.XOverhead = 0;
    pdsch1.LimitedBufferRateMatching = true;
    pdsch1.MaxNumLayers = 8;
    pdsch1.MCSTable = 'qam256';
    pdsch1.RVSequence = [0 2 3 1];
    pdsch1.DataSource = 'PN9-ITU';
    pdsch1.DMRSPower = 0;
    pdsch1.EnablePTRS = false;
    pdsch1.PTRSPower = 0;

    pdsch1ReservedPRB = nrPDSCHReservedConfig;
    pdsch1ReservedPRB.PRBSet = [];
    pdsch1ReservedPRB.SymbolSet = [];
    pdsch1ReservedPRB.Period = [];

    pdsch1.ReservedPRB = {pdsch1ReservedPRB};

    pdsch1DMRS = nrPDSCHDMRSConfig;
    pdsch1DMRS.DMRSConfigurationType = 1;
    pdsch1DMRS.DMRSReferencePoint = 'CRB0';
    pdsch1DMRS.DMRSTypeAPosition = 2;
    pdsch1DMRS.DMRSAdditionalPosition = 0;
    pdsch1DMRS.DMRSLength = 1;
    pdsch1DMRS.CustomSymbolSet = [];
    pdsch1DMRS.DMRSPortSet = [];
    pdsch1DMRS.NIDNSCID = [];
    pdsch1DMRS.NSCID = 0;
    pdsch1DMRS.NumCDMGroupsWithoutData = 2;
    pdsch1DMRS.DMRSDownlinkR16 = false;
    pdsch1DMRS.DMRSEnhancedR18 = false;

    pdsch1.DMRS = pdsch1DMRS;

    pdsch1PTRS = nrPDSCHPTRSConfig;
    pdsch1PTRS.TimeDensity = 1;
    pdsch1PTRS.FrequencyDensity = 2;
    pdsch1PTRS.REOffset = '00';
    pdsch1PTRS.PTRSPortSet = [];

    pdsch1.PTRS = pdsch1PTRS;

    pdsch2 = nrWavegenPDSCHConfig;
    pdsch2.Enable = true;
    pdsch2.Label = 'PDSCH2';
    pdsch2.Power = 0;
    pdsch2.BandwidthPartID = 1;
    pdsch2.Modulation = 'QPSK';
    pdsch2.NumLayers = 1;
    pdsch2.MappingType = 'A';
    pdsch2.ReservedCORESET = [];
    pdsch2.SymbolAllocation = [0 14];
    pdsch2.SlotAllocation = 3:7;
    pdsch2.Period = 10;
    pdsch2.PRBSet = 61:90;
    pdsch2.PRBSetType = 'VRB';
    pdsch2.VRBToPRBInterleaving = false;
    pdsch2.VRBBundleSize = 2;
    pdsch2.NID = [];
    pdsch2.RNTI = 1;
    pdsch2.Coding = true;
    pdsch2.TargetCodeRate = 0.513671875;
    pdsch2.TBScaling = 1;
    pdsch2.XOverhead = 0;
    pdsch2.LimitedBufferRateMatching = true;
    pdsch2.MaxNumLayers = 8;
    pdsch2.MCSTable = 'qam256';
    pdsch2.RVSequence = [0 2 3 1];
    pdsch2.DataSource = 'PN9-ITU';
    pdsch2.DMRSPower = 0;
    pdsch2.EnablePTRS = false;
    pdsch2.PTRSPower = 0;

    pdschreserved = nrPDSCHReservedConfig;
    pdschreserved.PRBSet = [];
    pdschreserved.SymbolSet = [];
    pdschreserved.Period = [];

    pdsch2.ReservedPRB = {pdschreserved};

    pdschdmrs = nrPDSCHDMRSConfig;
    pdschdmrs.DMRSConfigurationType = 1;
    pdschdmrs.DMRSReferencePoint = 'CRB0';
    pdschdmrs.DMRSTypeAPosition = 2;
    pdschdmrs.DMRSAdditionalPosition = 0;
    pdschdmrs.DMRSLength = 1;
    pdschdmrs.CustomSymbolSet = [];
    pdschdmrs.DMRSPortSet = [];
    pdschdmrs.NIDNSCID = [];
    pdschdmrs.NSCID = 0;
    pdschdmrs.NumCDMGroupsWithoutData = 2;
    pdschdmrs.DMRSDownlinkR16 = false;
    pdschdmrs.DMRSEnhancedR18 = false;

    pdsch2.DMRS = pdschdmrs;

    pdschptrs = nrPDSCHPTRSConfig;
    pdschptrs.TimeDensity = 1;
    pdschptrs.FrequencyDensity = 2;
    pdschptrs.REOffset = '00';
    pdschptrs.PTRSPortSet = [];

    pdsch2.PTRS = pdschptrs;

    pdsch3 = nrWavegenPDSCHConfig;
    pdsch3.Enable = true;
    pdsch3.Label = 'PDSCH3';
    pdsch3.Power = 0;
    pdsch3.BandwidthPartID = 1;
    pdsch3.Modulation = 'QPSK';
    pdsch3.NumLayers = 1;
    pdsch3.MappingType = 'A';
    pdsch3.ReservedCORESET = [];
    pdsch3.SymbolAllocation = [0 14];
    pdsch3.SlotAllocation = 3:2:7;
    pdsch3.Period = 10;
    pdsch3.PRBSet = 91:120;
    pdsch3.PRBSetType = 'VRB';
    pdsch3.VRBToPRBInterleaving = false;
    pdsch3.VRBBundleSize = 2;
    pdsch3.NID = [];
    pdsch3.RNTI = 1;
    pdsch3.Coding = true;
    pdsch3.TargetCodeRate = 0.513671875;
    pdsch3.TBScaling = 1;
    pdsch3.XOverhead = 0;
    pdsch3.LimitedBufferRateMatching = true;
    pdsch3.MaxNumLayers = 8;
    pdsch3.MCSTable = 'qam256';
    pdsch3.RVSequence = [0 2 3 1];
    pdsch3.DataSource = 'PN9-ITU';
    pdsch3.DMRSPower = 0;
    pdsch3.EnablePTRS = false;
    pdsch3.PTRSPower = 0;

    pdschreserved = nrPDSCHReservedConfig;
    pdschreserved.PRBSet = [];
    pdschreserved.SymbolSet = [];
    pdschreserved.Period = [];

    pdsch3.ReservedPRB = {pdschreserved};

    pdschdmrs = nrPDSCHDMRSConfig;
    pdschdmrs.DMRSConfigurationType = 1;
    pdschdmrs.DMRSReferencePoint = 'CRB0';
    pdschdmrs.DMRSTypeAPosition = 2;
    pdschdmrs.DMRSAdditionalPosition = 0;
    pdschdmrs.DMRSLength = 1;
    pdschdmrs.CustomSymbolSet = [];
    pdschdmrs.DMRSPortSet = [];
    pdschdmrs.NIDNSCID = [];
    pdschdmrs.NSCID = 0;
    pdschdmrs.NumCDMGroupsWithoutData = 2;
    pdschdmrs.DMRSDownlinkR16 = false;
    pdschdmrs.DMRSEnhancedR18 = false;

    pdsch3.DMRS = pdschdmrs;

    pdschptrs = nrPDSCHPTRSConfig;
    pdschptrs.TimeDensity = 1;
    pdschptrs.FrequencyDensity = 2;
    pdschptrs.REOffset = '00';
    pdschptrs.PTRSPortSet = [];

    pdsch3.PTRS = pdschptrs;

    pdsch4 = nrWavegenPDSCHConfig;
    pdsch4.Enable = true;
    pdsch4.Label = 'PDSCH4';
    pdsch4.Power = 0;
    pdsch4.BandwidthPartID = 1;
    pdsch4.Modulation = 'QPSK';
    pdsch4.NumLayers = 1;
    pdsch4.MappingType = 'A';
    pdsch4.ReservedCORESET = [];
    pdsch4.SymbolAllocation = [0 14];
    pdsch4.SlotAllocation = 2:8;
    pdsch4.Period = 10;
    pdsch4.PRBSet = 121:150;
    pdsch4.PRBSetType = 'VRB';
    pdsch4.VRBToPRBInterleaving = false;
    pdsch4.VRBBundleSize = 2;
    pdsch4.NID = [];
    pdsch4.RNTI = 1;
    pdsch4.Coding = true;
    pdsch4.TargetCodeRate = 0.513671875;
    pdsch4.TBScaling = 1;
    pdsch4.XOverhead = 0;
    pdsch4.LimitedBufferRateMatching = true;
    pdsch4.MaxNumLayers = 8;
    pdsch4.MCSTable = 'qam256';
    pdsch4.RVSequence = [0 2 3 1];
    pdsch4.DataSource = 'PN9-ITU';
    pdsch4.DMRSPower = 0;
    pdsch4.EnablePTRS = false;
    pdsch4.PTRSPower = 0;

    pdschreserved = nrPDSCHReservedConfig;
    pdschreserved.PRBSet = [];
    pdschreserved.SymbolSet = [];
    pdschreserved.Period = [];

    pdsch4.ReservedPRB = {pdschreserved};

    pdschdmrs = nrPDSCHDMRSConfig;
    pdschdmrs.DMRSConfigurationType = 1;
    pdschdmrs.DMRSReferencePoint = 'CRB0';
    pdschdmrs.DMRSTypeAPosition = 2;
    pdschdmrs.DMRSAdditionalPosition = 0;
    pdschdmrs.DMRSLength = 1;
    pdschdmrs.CustomSymbolSet = [];
    pdschdmrs.DMRSPortSet = [];
    pdschdmrs.NIDNSCID = [];
    pdschdmrs.NSCID = 0;
    pdschdmrs.NumCDMGroupsWithoutData = 2;
    pdschdmrs.DMRSDownlinkR16 = false;
    pdschdmrs.DMRSEnhancedR18 = false;

    pdsch4.DMRS = pdschdmrs;

    pdschptrs = nrPDSCHPTRSConfig;
    pdschptrs.TimeDensity = 1;
    pdschptrs.FrequencyDensity = 2;
    pdschptrs.REOffset = '00';
    pdschptrs.PTRSPortSet = [];

    pdsch4.PTRS = pdschptrs;

    pdsch5 = nrWavegenPDSCHConfig;
    pdsch5.Enable = true;
    pdsch5.Label = 'PDSCH5';
    pdsch5.Power = 0;
    pdsch5.BandwidthPartID = 1;
    pdsch5.Modulation = 'QPSK';
    pdsch5.NumLayers = 1;
    pdsch5.MappingType = 'A';
    pdsch5.ReservedCORESET = [];
    pdsch5.SymbolAllocation = [0 14];
    pdsch5.SlotAllocation = 3:2:7;
    pdsch5.Period = 10;
    pdsch5.PRBSet = 151:180;
    pdsch5.PRBSetType = 'VRB';
    pdsch5.VRBToPRBInterleaving = false;
    pdsch5.VRBBundleSize = 2;
    pdsch5.NID = [];
    pdsch5.RNTI = 1;
    pdsch5.Coding = true;
    pdsch5.TargetCodeRate = 0.513671875;
    pdsch5.TBScaling = 1;
    pdsch5.XOverhead = 0;
    pdsch5.LimitedBufferRateMatching = true;
    pdsch5.MaxNumLayers = 8;
    pdsch5.MCSTable = 'qam256';
    pdsch5.RVSequence = [0 2 3 1];
    pdsch5.DataSource = 'PN9-ITU';
    pdsch5.DMRSPower = 0;
    pdsch5.EnablePTRS = false;
    pdsch5.PTRSPower = 0;

    pdschreserved = nrPDSCHReservedConfig;
    pdschreserved.PRBSet = [];
    pdschreserved.SymbolSet = [];
    pdschreserved.Period = [];

    pdsch5.ReservedPRB = {pdschreserved};

    pdschdmrs = nrPDSCHDMRSConfig;
    pdschdmrs.DMRSConfigurationType = 1;
    pdschdmrs.DMRSReferencePoint = 'CRB0';
    pdschdmrs.DMRSTypeAPosition = 2;
    pdschdmrs.DMRSAdditionalPosition = 0;
    pdschdmrs.DMRSLength = 1;
    pdschdmrs.CustomSymbolSet = [];
    pdschdmrs.DMRSPortSet = [];
    pdschdmrs.NIDNSCID = [];
    pdschdmrs.NSCID = 0;
    pdschdmrs.NumCDMGroupsWithoutData = 2;
    pdschdmrs.DMRSDownlinkR16 = false;
    pdschdmrs.DMRSEnhancedR18 = false;

    pdsch5.DMRS = pdschdmrs;

    pdschptrs = nrPDSCHPTRSConfig;
    pdschptrs.TimeDensity = 1;
    pdschptrs.FrequencyDensity = 2;
    pdschptrs.REOffset = '00';
    pdschptrs.PTRSPortSet = [];

    pdsch5.PTRS = pdschptrs;
    % PDSCH 6
    pdsch6 = nrWavegenPDSCHConfig;
    pdsch6.Enable = true;
    pdsch6.Label = 'PDSCH6';
    pdsch6.Power = 0;
    pdsch6.BandwidthPartID = 1;
    pdsch6.Modulation = 'QPSK';
    pdsch6.NumLayers = 1;
    pdsch6.MappingType = 'A';
    pdsch6.ReservedCORESET = [];
    pdsch6.SymbolAllocation = [0 14];
    pdsch6.SlotAllocation = 3:7;
    pdsch6.Period = 10;
    pdsch6.PRBSet = 181:210;
    pdsch6.PRBSetType = 'VRB';
    pdsch6.VRBToPRBInterleaving = false;
    pdsch6.VRBBundleSize = 2;
    pdsch6.NID = [];
    pdsch6.RNTI = 1;
    pdsch6.Coding = true;
    pdsch6.TargetCodeRate = 0.513671875;
    pdsch6.TBScaling = 1;
    pdsch6.XOverhead = 0;
    pdsch6.LimitedBufferRateMatching = true;
    pdsch6.MaxNumLayers = 8;
    pdsch6.MCSTable = 'qam256';
    pdsch6.RVSequence = [0 2 3 1];
    pdsch6.DataSource = 'PN9-ITU';
    pdsch6.DMRSPower = 0;
    pdsch6.EnablePTRS = false;
    pdsch6.PTRSPower = 0;

    pdschreserved = nrPDSCHReservedConfig;
    pdschreserved.PRBSet = [];
    pdschreserved.SymbolSet = [];
    pdschreserved.Period = [];

    pdsch6.ReservedPRB = {pdschreserved};

    pdschdmrs = nrPDSCHDMRSConfig;
    pdschdmrs.DMRSConfigurationType = 1;
    pdschdmrs.DMRSReferencePoint = 'CRB0';
    pdschdmrs.DMRSTypeAPosition = 2;
    pdschdmrs.DMRSAdditionalPosition = 0;
    pdschdmrs.DMRSLength = 1;
    pdschdmrs.CustomSymbolSet = [];
    pdschdmrs.DMRSPortSet = [];
    pdschdmrs.NIDNSCID = [];
    pdschdmrs.NSCID = 0;
    pdschdmrs.NumCDMGroupsWithoutData = 2;
    pdschdmrs.DMRSDownlinkR16 = false;
    pdschdmrs.DMRSEnhancedR18 = false;

    pdsch6.DMRS = pdschdmrs;

    pdschptrs = nrPDSCHPTRSConfig;
    pdschptrs.TimeDensity = 1;
    pdschptrs.FrequencyDensity = 2;
    pdschptrs.REOffset = '00';
    pdschptrs.PTRSPortSet = [];

    pdsch6.PTRS = pdschptrs;

    % PDSCH 7
    pdsch7 = nrWavegenPDSCHConfig;
    pdsch7.Enable = true;
    pdsch7.Label = 'PDSCH7';
    pdsch7.Power = 0;
    pdsch7.BandwidthPartID = 1;
    pdsch7.Modulation = 'QPSK';
    pdsch7.NumLayers = 1;
    pdsch7.MappingType = 'A';
    pdsch7.ReservedCORESET = [];
    pdsch7.SymbolAllocation = [0 14];
    pdsch7.SlotAllocation = 5;
    pdsch7.Period = 10;
    pdsch7.PRBSet = 211:240;
    pdsch7.PRBSetType = 'VRB';
    pdsch7.VRBToPRBInterleaving = false;
    pdsch7.VRBBundleSize = 2;
    pdsch7.NID = [];
    pdsch7.RNTI = 1;
    pdsch7.Coding = true;
    pdsch7.TargetCodeRate = 0.513671875;
    pdsch7.TBScaling = 1;
    pdsch7.XOverhead = 0;
    pdsch7.LimitedBufferRateMatching = true;
    pdsch7.MaxNumLayers = 8;
    pdsch7.MCSTable = 'qam256';
    pdsch7.RVSequence = [0 2 3 1];
    pdsch7.DataSource = 'PN9-ITU';
    pdsch7.DMRSPower = 0;
    pdsch7.EnablePTRS = false;
    pdsch7.PTRSPower = 0;

    pdschreserved = nrPDSCHReservedConfig;
    pdschreserved.PRBSet = [];
    pdschreserved.SymbolSet = [];
    pdschreserved.Period = [];

    pdsch7.ReservedPRB = {pdschreserved};

    pdschdmrs = nrPDSCHDMRSConfig;
    pdschdmrs.DMRSConfigurationType = 1;
    pdschdmrs.DMRSReferencePoint = 'CRB0';
    pdschdmrs.DMRSTypeAPosition = 2;
    pdschdmrs.DMRSAdditionalPosition = 0;
    pdschdmrs.DMRSLength = 1;
    pdschdmrs.CustomSymbolSet = [];
    pdschdmrs.DMRSPortSet = [];
    pdschdmrs.NIDNSCID = [];
    pdschdmrs.NSCID = 0;
    pdschdmrs.NumCDMGroupsWithoutData = 2;
    pdschdmrs.DMRSDownlinkR16 = false;
    pdschdmrs.DMRSEnhancedR18 = false;

    pdsch7.DMRS = pdschdmrs;

    pdschptrs = nrPDSCHPTRSConfig;
    pdschptrs.TimeDensity = 1;
    pdschptrs.FrequencyDensity = 2;
    pdschptrs.REOffset = '00';
    pdschptrs.PTRSPortSet = [];

    pdsch7.PTRS = pdschptrs;

    cfgDL.PDSCH = {pdsch1,pdsch2,pdsch3,pdsch4,pdsch5,pdsch6,pdsch7};

    csirs = nrWavegenCSIRSConfig;
    csirs.Enable = false;
    csirs.Label = 'CSIRS1';
    csirs.Power = 0;
    csirs.BandwidthPartID = 1;
    csirs.CSIRSType = 'nzp';
    csirs.CSIRSPeriod = 'on';
    csirs.RowNumber = 3;
    csirs.Density = 'one';
    csirs.SymbolLocations = 0;
    csirs.SubcarrierLocations = 0;
    csirs.NumRB = 52;
    csirs.RBOffset = 0;
    csirs.NID = 0;

    cfgDL.CSIRS = {csirs};

    [waveform,info] = nrWaveformGenerator(cfgDL);

end