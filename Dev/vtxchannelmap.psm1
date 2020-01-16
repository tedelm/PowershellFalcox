


    Function Get-VTXChannelMapping($SmartAudio){
        switch ($SmartAudio)
        {
            #Boscam A
            A1 { $VtxChannelMapping = 0; $VtxFreq = 5865 } #5865
            A2 { $VtxChannelMapping = 1; $VtxFreq = 5845 } #5845
            A3 { $VtxChannelMapping = 2; $VtxFreq = 5825 } #5825
            A4 { $VtxChannelMapping = 3; $VtxFreq = 5805 } #5805
            A5 { $VtxChannelMapping = 4; $VtxFreq = 5785 } #5785
            A6 { $VtxChannelMapping = 5; $VtxFreq = 5765 } #5765
            A7 { $VtxChannelMapping = 6; $VtxFreq = 5745 } #5745
            A8 { $VtxChannelMapping = 7; $VtxFreq = 5725 } #5725
            #Boscam B
            B1 { $VtxChannelMapping = 8; $VtxFreq = 5733 } #5733
            B2 { $VtxChannelMapping = 9; $VtxFreq = 5752 } #5752
            B3 { $VtxChannelMapping = 10; $VtxFreq = 5771 } #5771
            B4 { $VtxChannelMapping = 11; $VtxFreq = 5790 } #5790
            B5 { $VtxChannelMapping = 12; $VtxFreq = 5809 } #5809
            B6 { $VtxChannelMapping = 13; $VtxFreq = 5828 } #5828
            B7 { $VtxChannelMapping = 14; $VtxFreq = 5847 } #5847
            B8 { $VtxChannelMapping = 15; $VtxFreq = 5866 } #5866  
            #Boscam E
            E1 { $VtxChannelMapping = 16 } #5705
            E2 { $VtxChannelMapping = 17 } #5685
            E3 { $VtxChannelMapping = 18 } #5665
            E4 { $VtxChannelMapping = 19 } #5645
            E5 { $VtxChannelMapping = 20 } #5885
            E6 { $VtxChannelMapping = 21 } #5905
            E7 { $VtxChannelMapping = 22 } #5925
            E8 { $VtxChannelMapping = 23 } #5945  
            #Fatshark
            F1 { $VtxChannelMapping = 24 } #5740
            F2 { $VtxChannelMapping = 25 } #5760
            F3 { $VtxChannelMapping = 26 } #5780
            F4 { $VtxChannelMapping = 27 } #5800
            F5 { $VtxChannelMapping = 28 } #5820
            F6 { $VtxChannelMapping = 29 } #5840
            F7 { $VtxChannelMapping = 30 } #5860
            F8 { $VtxChannelMapping = 31 } #5880
            #Raceband R
            R1 { $VtxChannelMapping = 32 } #5658
            R2 { $VtxChannelMapping = 33 } #5695
            R3 { $VtxChannelMapping = 34 } #5732
            R4 { $VtxChannelMapping = 35 } #5769
            R5 { $VtxChannelMapping = 36 } #5806
            R6 { $VtxChannelMapping = 37 } #5843
            R7 { $VtxChannelMapping = 38 } #5880
            R8 { $VtxChannelMapping = 39 } #5917
            #IMD6
            IMD1 { $VtxChannelMapping = 40 } #5732
            IMD2 { $VtxChannelMapping = 41 } #5765
            IMD3 { $VtxChannelMapping = 42 } #5828
            IMD4 { $VtxChannelMapping = 43 } #5840
            IMD5 { $VtxChannelMapping = 44 } #5866
            IMD6 { $VtxChannelMapping = 45 } #5740
            IMD7 { $VtxChannelMapping = 46 } #0
            IMD8 { $VtxChannelMapping = 47 } #0
        }
         
        $VtxChannelMapping
        $VtxFreq
    }

Export-ModuleMember -Function VTXChannel