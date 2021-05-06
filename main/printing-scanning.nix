{ sane-airscan, ... }: {

  # Enable Common UNIX Printing System.
  services.printing.enable = true;

  # Add printers to CUPS.
  # Get PPD options by running `lpoptions -p <name> -l`.
  hardware.printers.ensurePrinters = [
    {
      name = "Brother-MFC-L2700DW";
      description = "Brother MFC-L2700DW";
      location = "Office Upstairs";
      deviceUri =
        "dnssd://Brother%20MFC-L2700DW%20series._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-3c2af4030af4";
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
    {
      name = "Brother-HL-3140CW";
      description = "Brother HL-3140CW";
      location = "Office Downstairs";
      deviceUri =
        "dnssd://Brother%20HL-3140CW%20series._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-342387ae3d0a";
      model = "everywhere";
      ppdOptions = {
        PageSize = "A4";
        InputSlot = "Auto";
        MediaType = "Stationery";
        ColorModel = "RGB";
        cupsPrintQuality = "Normal";
      };
    }
    {
      name = "HP-OfficeJet-Pro-7720";
      description = "HP Officejet Pro 7720";
      location = "Office Downstairs";
      deviceUri =
        "dnssd://HP%20OfficeJet%20Pro%207720%20series%20%5B507A2F%5D._ipp._tcp.local/?uuid=b4f3cbfb-2d18-56e1-f1cb-fb194e969987";
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
