{ config, pkgs, ... }:

{
  # Setup CUPS for printing documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip mfcl2700dncupswrapper ];

  # Add printers to CUPS.
  hardware.printers.ensurePrinters = [
    {
      name = "Brother_MFC-L2700DW";
      description = "Brother MFC-L2700DW";
      location = "Office Upstairs";
      deviceUri = "ipp://192.168.178.37/ipp";
      # Get installed PPD files by running `lpinfo -m`.
      model = "brother-MFCL2700DN-cups-en.ppd";
      # Get options by running `lpoptions -p Brother_MFC-L2700DW -l`.
      ppdOptions = {
        "PageSize" = "A4";
        "BrMediaType" = "PLAIN";
        "Resolution" = "600dpi";
        "InputSlot" = "TRAY1"; # Scanning?
        "Duplex" = "None";
        "TonerSaveMode" = "OFF";
        # Timeout before going to sleep after printing.
        # Can be "PrinterDefault", "2minutes", "10minutes" or "30minutes".
        "Sleep" = "PrinterDefault";
      };
    }
    {
      name = "HP_OfficeJet_Pro_7720";
      description = "HP Officejet Pro 7720";
      location = "Office Downstairs";
      deviceUri = "hp:/net/OfficeJet_Pro_7720_series?ip=192.168.178.36";
      model = "drv:///hp/hpcups.drv/hp-officejet_pro_7720_series.ppd";
      ppdOptions = {
        "PageSize" = "A3";
        "ColorModel" = "RGB";
        "MediaType" = "Plain";
        "OutputMode" = "Normal"; # Quality, can be "Normal", "FastDraft", "Best" or "Photo".
        "InputSlot" = "Upper"; # Scanning?
        "Duplex" = "None";
      };
    }
  ];
}
