PROCEDURE TO LOAD UP PROJECT:

1. Load Manage FPGA:
    a. Copy the load_manage_server.zip file into the C: drive of a DESLA machine (since for load manage we are using the DDR board)
    b. Within the load_manage_server.zip file there are three folders; namely "demo_group", "ip_repo" and "tutorial_3" and some files (ignore files for now, discussed in SDK section)
    c. The "demo_group" folder contains the actual Vivado project, the "ip_repo" folder contains the files for Custom IPs used in the design like the load_manager IP, 
       and the "tutorial_3" folder contains the Board Support Files (please make sure to leave these files within the tutorial_3 folder, don't copy eleswhere)
    d. IMPORTANT: When extracting the load_manage_server.zip, make sure to extract it to the folder: "C:/Useres/<utorId>" and not to "C:/Useres/<utorid>/load_manage_server"
    e. once the folder is extracted then you can open vivavdo and the open the demo_group project present within the demo_group folder from there
    f. Provided that the extraction was done as above, the project should work!
    g. Once project is opened up, you can rerun synth, impl and generate bitstream if required, otherwise exported hardware with bitstream should already exist and you can move on
       to SDK
    h. Steps for SDK:
        i. After Launch SDK, go to: File -> Open Projects From File System
        ii. A pop up will show up, brow the directory to find the sdk folder within the demo_group folder
        iii. Within the demo group folder select the centNode folder and add that
        iv. Follow steps i - iii again, but this time add the centNode_bsp folder
        v. Once folders are loaded, open the main.c and echo.c files in the centNode folder
            -> In here we need to modify the main.c file to reflect the IP address and MAC address of the machine we are on (Use ipconfig in Windows Command Prompt)
            -> Also in main.c modify the init_load_manager() function to reflect the station numbers of the stations we will be using for the project
            -> Go to echo.c and make sure code is as expected
        vi. Next open the lscript.ld file and make sure mig_7series_0_memaddr is used for all the fields in the Section to Memory Region Mapping
        vii. Next open the system.mss file in the centNode_bsp folder and make sure the temac_adapter_options settings are as required.
        viii. Regenerate BSP sources just to be sure
        ix. Next got to Xilinx -> Program FPGA and program FPGA with the exported bitstream
        x. Then go to Run -> Run Configurations, in the popup click on Xilinx C/C++ Application (GDB) and if there exists a run configuration already make sure it is the centNode
        xi. If it is not centNode or if no configuration exists, then create a new configuration, delete the old one
        xii. Clode run configurations, go to the SDK Terminal and connect to FPGA, rate: 9600, port: usually COM6 (but verify using chgport in Windows command Prompt)
        xiii. Go back to the centNode run configuration and click Run -> Server should start (print statements displayed in SDK terminal)
        NOTE: When unzipping the load_manage_server.zip file, there were a few files in there, two of those were: echo_load_manage_server.c and main_load_manage_server.c
              If the contents of echo.c and main.c were not as expected then you can copy the contents of these files into echo.c and main.c
    i. Steps for Desktop Client:
        i. When unzipping the load_manage_server.zip file, there should also be a tcp_client(DESLA).py file present, this is the ython file used to setup the desktop client
        ii. Open the py file in notepad++ to make sure the contents are as required, might have to chnage the HOST IP address to match that of the load manage FPGA
        iii. In a Windows Command Prompt, navigate to the location of the py file and then run: python tcp_client(DESLA).py
        iv. Provided all steps above done correctly, a connection should be setup between FPGA an the desktop
        

