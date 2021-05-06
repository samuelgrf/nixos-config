{ sane-airscan, ... }: {

  # Enable Common UNIX Printing System.
  services.printing.enable = true;

  # Add printers to CUPS.
  # Get PPD options by running `lpoptions -p <name> -l`.
  hardware.printers.ensurePrinters = [
    rec {
      name = "Brother-MFC-L2700DW";
      description = "Brother MFC-L2700DW";
      location = "Office Upstairs";
      deviceUri = "ipp://${name}/ipp";
      model = "everywhere";
      ppdOptions = {
        PageSize = "A4";
        InputSlot = "Auto";
        MediaType = "Stationery";
        ColorModel = "Gray";
        Duplex = "DuplexNoTumble"; # Flip on long edge
        cupsPrintQuality = "Normal";
      };
    }
    rec {
      name = "Brother-HL-3140CW";
      description = "Brother HL-3140CW";
      location = "Office Downstairs";
      deviceUri = "ipp://${name}/ipp";
      model = "everywhere";
      ppdOptions = {
        PageSize = "A4";
        InputSlot = "Auto";
        MediaType = "Stationery";
        ColorModel = "RGB";
        cupsPrintQuality = "Normal";
      };
    }
    rec {
      name = "HP-OfficeJet-Pro-7720";
      description = "HP Officejet Pro 7720";
      location = "Office Downstairs";
      deviceUri = "ipp://${name}/ipp/print";
      model = "everywhere";
      ppdOptions = {
        PageSize = "A3";
        MediaType = "Stationery";
        ColorModel = "RGB";
        Duplex = "DuplexTumble"; # Flip on short edge
        cupsPrintQuality = "Normal";
      };
    }
  ];

  # Set default printer.
  hardware.printers.ensureDefaultPrinter = "Brother-MFC-L2700DW";

  # Enable and configure SANE scanning API.
  hardware.sane = {
    enable = true;
    extraBackends = [ sane-airscan ]; # Support Apple AirScan and Microsoft WSD
  };

}
