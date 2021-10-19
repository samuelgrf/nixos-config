{ config, lib, pkgs, sane-airscan, ... }: {

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
        Duplex = "DuplexNoTumble"; # Flip on long edge
        cupsPrintQuality = "Normal";
      };
    }
    {
      name = "Brother_HL-3140CW";
      description = "Brother HL-3140CW";
      location = "Office Downstairs";
      deviceUri = "ipp://192.168.178.38/ipp";
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
      name = "HP_OfficeJet-Pro-7720";
      description = "HP Officejet Pro 7720";
      location = "Office Downstairs";
      deviceUri = "ipp://192.168.178.36/ipp/print";
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
  hardware.printers.ensureDefaultPrinter = "Brother_MFC-L2700DW";

  # Don't fail `ensure-printers` service when printers are unreachable.
  systemd.services.ensure-printers.serviceConfig.ExecStart = lib.mkForce "-${
      pkgs.writeShellScriptBin "ensure-printers"
      config.systemd.services.ensure-printers.script
    }";

  # Enable and configure SANE scanning API.
  hardware.sane = {
    enable = true;
    extraBackends = [ sane-airscan ]; # Support Apple AirScan and Microsoft WSD.
  };

}
