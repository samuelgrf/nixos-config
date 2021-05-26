{

  # Force overwrite symlinks that KDE replaces with new files.
  xdg = {
    configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
    configFile."mimeapps.list".force = true;
    dataFile."applications/mimeapps.list".force = true;
  };

}
