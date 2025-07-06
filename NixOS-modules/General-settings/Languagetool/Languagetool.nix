{pkgs, ...}: {
  services.languagetool = {
    enable = true;
    package = pkgs.languagetool;
    settings = {};
    port = 8081;
    jvmOptions = ["-Xmx512m"];
    public = false;
    jrePackage = pkgs.jdk;
    allowOrigin = null;
  };
}
