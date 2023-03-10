{ lib, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        extraConfig = lib.mkDefault ''
          env = LIBVA_DRIVER_NAME,nvidia
          env = XDG_SESSION_TYPE,wayland
          env = GBM_BACKEND,nvidia-drm
          env = __GLX_VENDOR_LIBRARY_NAME,nvidia
          env = WLR_NO_HARDWARE_CURSORS,1
        '';
      };
    };
  };
}
