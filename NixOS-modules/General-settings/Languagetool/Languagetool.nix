{pkgs, ...}: {
  services.languagetool = {
    enable = true;
    package = pkgs.languagetool; ## GNU LGPL v2.1 or Later
    settings = {};
    port = 8081;
    jvmOptions = ["-Xmx512m"];
    public = false;
    jrePackage = pkgs.jdk;
    allowOrigin = null;
  };
}
