


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
            E1 { $VtxChannelMapping = 16; $VtxFreq = 5705 } #5705
            E2 { $VtxChannelMapping = 17; $VtxFreq = 5685 } #5685
            E3 { $VtxChannelMapping = 18; $VtxFreq = 5665 } #5665
            E4 { $VtxChannelMapping = 19; $VtxFreq = 5645 } #5645
            E5 { $VtxChannelMapping = 20; $VtxFreq = 5885 } #5885
            E6 { $VtxChannelMapping = 21; $VtxFreq = 5905 } #5905
            E7 { $VtxChannelMapping = 22; $VtxFreq = 5925 } #5925
            E8 { $VtxChannelMapping = 23; $VtxFreq = 5945 } #5945  
            #Fatshark
            F1 { $VtxChannelMapping = 24; $VtxFreq = 5740 } #5740
            F2 { $VtxChannelMapping = 25; $VtxFreq = 5760 } #5760
            F3 { $VtxChannelMapping = 26; $VtxFreq = 5780 } #5780
            F4 { $VtxChannelMapping = 27; $VtxFreq = 5800 } #5800
            F5 { $VtxChannelMapping = 28; $VtxFreq = 5820 } #5820
            F6 { $VtxChannelMapping = 29; $VtxFreq = 5840 } #5840
            F7 { $VtxChannelMapping = 30; $VtxFreq = 5860 } #5860
            F8 { $VtxChannelMapping = 31; $VtxFreq = 5880 } #5880
            #Raceband R
            R1 { $VtxChannelMapping = 32; $VtxFreq = 5658 } #5658
            R2 { $VtxChannelMapping = 33; $VtxFreq = 5695 } #5695
            R3 { $VtxChannelMapping = 34; $VtxFreq = 5732 } #5732
            R4 { $VtxChannelMapping = 35; $VtxFreq = 5769 } #5769
            R5 { $VtxChannelMapping = 36; $VtxFreq = 5806 } #5806
            R6 { $VtxChannelMapping = 37; $VtxFreq = 5843 } #5843
            R7 { $VtxChannelMapping = 38; $VtxFreq = 5880 } #5880
            R8 { $VtxChannelMapping = 39; $VtxFreq = 5917 } #5917
            #IMD6
            IMD1 { $VtxChannelMapping = 40; $VtxFreq = 5732 } #5732
            IMD2 { $VtxChannelMapping = 41; $VtxFreq = 5765 } #5765
            IMD3 { $VtxChannelMapping = 42; $VtxFreq = 5828 } #5828
            IMD4 { $VtxChannelMapping = 43; $VtxFreq = 5840 } #5840
            IMD5 { $VtxChannelMapping = 44; $VtxFreq = 5866 } #5866
            IMD6 { $VtxChannelMapping = 45; $VtxFreq = 5740 } #5740
            IMD7 { $VtxChannelMapping = 46; $VtxFreq = "N/A" } #0
            IMD8 { $VtxChannelMapping = 47; $VtxFreq = "N/A" } #0
            #Boscam A
            0 { $VtxChannelMapping = "A1"; $VtxFreq = 5865 } #5865
            1 { $VtxChannelMapping = "A2"; $VtxFreq = 5845 } #5845
            2 { $VtxChannelMapping = "A3"; $VtxFreq = 5825 } #5825
            3 { $VtxChannelMapping = "A4"; $VtxFreq = 5805 } #5805
            4 { $VtxChannelMapping = "A5"; $VtxFreq = 5785 } #5785
            5 { $VtxChannelMapping = "A6"; $VtxFreq = 5765 } #5765
            6 { $VtxChannelMapping = "A7"; $VtxFreq = 5745 } #5745
            7 { $VtxChannelMapping = "A8"; $VtxFreq = 5725 } #5725
            #Boscam B
            8 { $VtxChannelMapping = "B1"; $VtxFreq = 5733 } #5733
            9 { $VtxChannelMapping = "B2"; $VtxFreq = 5752 } #5752
            10 { $VtxChannelMapping = "B3"; $VtxFreq = 5771 } #5771
            11 { $VtxChannelMapping = "B4"; $VtxFreq = 5790 } #5790
            12 { $VtxChannelMapping = "B5"; $VtxFreq = 5809 } #5809
            13 { $VtxChannelMapping = "B6"; $VtxFreq = 5828 } #5828
            14 { $VtxChannelMapping = "B7"; $VtxFreq = 5847 } #5847
            15 { $VtxChannelMapping = "B8"; $VtxFreq = 5866 } #5866  
            #Boscam E
            16 { $VtxChannelMapping = "E1"; $VtxFreq = 5705 } #5705
            17 { $VtxChannelMapping = "E2"; $VtxFreq = 5685 } #5685
            18 { $VtxChannelMapping = "E3"; $VtxFreq = 5665 } #5665
            19 { $VtxChannelMapping = "E4"; $VtxFreq = 5645 } #5645
            20 { $VtxChannelMapping = "E5"; $VtxFreq = 5885 } #5885
            21 { $VtxChannelMapping = "E6"; $VtxFreq = 5905 } #5905
            22 { $VtxChannelMapping = "E7"; $VtxFreq = 5925 } #5925
            23 { $VtxChannelMapping = "E8"; $VtxFreq = 5945 } #5945  
            #Fatshark
            24 { $VtxChannelMapping = "F1"; $VtxFreq = 5740 } #5740
            25 { $VtxChannelMapping = "F2"; $VtxFreq = 5760 } #5760
            26 { $VtxChannelMapping = "F3"; $VtxFreq = 5780 } #5780
            27 { $VtxChannelMapping = "F4"; $VtxFreq = 5800 } #5800
            28 { $VtxChannelMapping = "F5"; $VtxFreq = 5820 } #5820
            29 { $VtxChannelMapping = "F6"; $VtxFreq = 5840 } #5840
            30 { $VtxChannelMapping = "F7"; $VtxFreq = 5860 } #5860
            31 { $VtxChannelMapping = "F8"; $VtxFreq = 5880 } #5880
            #Raceband R
            32 { $VtxChannelMapping = "R1"; $VtxFreq = 5658 } #5658
            33 { $VtxChannelMapping = "R2"; $VtxFreq = 5695 } #5695
            34 { $VtxChannelMapping = "R3"; $VtxFreq = 5732 } #5732
            35 { $VtxChannelMapping = "R4"; $VtxFreq = 5769 } #5769
            36 { $VtxChannelMapping = "R5"; $VtxFreq = 5806 } #5806
            37 { $VtxChannelMapping = "R6"; $VtxFreq = 5843 } #5843
            38 { $VtxChannelMapping = "R7"; $VtxFreq = 5880 } #5880
            39 { $VtxChannelMapping = "R8"; $VtxFreq = 5917 } #5917
            #IMD6
            40 { $VtxChannelMapping = "IMD1"; $VtxFreq = 5732 } #5732
            41 { $VtxChannelMapping = "IMD2"; $VtxFreq = 5765 } #5765
            42 { $VtxChannelMapping = "IMD3"; $VtxFreq = 5828 } #5828
            43 { $VtxChannelMapping = "IMD4"; $VtxFreq = 5840 } #5840
            44 { $VtxChannelMapping = "IMD5"; $VtxFreq = 5866 } #5866
            45 { $VtxChannelMapping = "IMD6"; $VtxFreq = 5740 } #5740
            46 { $VtxChannelMapping = 46; $VtxFreq = "N/A" } #0
            47 { $VtxChannelMapping = 47; $VtxFreq = "N/A" } #0
        }
         
        $VtxChannelMapping
        $VtxFreq
    }

Export-ModuleMember -Function Get-VTXChannelMapping