(self: super: {
  extra-cmake-modules = super.extra-cmake-modules.overrideAttrs (oldAttrs: rec {
    meta = oldAttrs.meta {
      platforms = super.lib.platforms.all; # Allow all platforms
    };
  });
})
