{

  # Enable Common UNIX Printing System.
  services.printing.enable = true;

  # Add printers to CUPS.
  # Get PPD options by running `lpoptions -p <name> -l`.
  hardware.printers.ensurePrinters = [
    {
      name = "Brother_MFC-L2700DW";
      description = "Brother MFC-L2700DW";
      location = "Office Upstairs";
      deviceUri = "ipp://192.168.178.37/ipp";
      model = "everywhere";
      ppdOptions = {
        PageSize = "A4";
        InputSlot = "Auto";
        MediaType = "Stationery";
        ColorModel = "Gray";
        Duplex = "None";
        cupsPrintQuality = "Normal";
      };
    }
    {
      name = "HP_OfficeJet_Pro_7720";
      description = "HP Officejet Pro 7720";
      location = "Office Downstairs";
      deviceUri = "ipp://192.168.178.36/ipp/print";
      model = "everywhere";
      ppdOptions = {
        PageSize = "A3";
        MediaType = "Stationery";
        ColorModel = "RGB";
        Duplex = "None";
        cupsPrintQuality = "Normal";
      };
    }
  ];

  # Set default printer.
  hardware.printers.ensureDefaultPrinter = "Brother_MFC-L2700DW";

}
