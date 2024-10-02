# Adds the `killAllPorts` script, auto generated from any scripts that start with `killPort`.
{ config, lib, ... }:
let
  attrNames = builtins.attrNames config.scripts;
  filteredAttrs = builtins.filter (x: lib.strings.hasPrefix "killPort" x) attrNames;
  commands = builtins.concatStringsSep "\n" (builtins.map
    (x:
      let
        name = lib.substring (lib.stringLength "killPort") (lib.stringLength x) x;
        value = config.scripts.${x}.exec;
      in
      ''
        echo "Killing ${name}"
        ${value}
      ''
    )
    filteredAttrs);
in
{
  config = {
    scripts.killAllPorts = {
      description = "Kills all ports used by the services in the project.";
      exec = ''
        ${commands}
      '';
    };
  };
}
