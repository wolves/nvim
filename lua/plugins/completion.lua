return {
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",

    version = "v0.*",

    opts = {
      keymap = {
        preset = "default",
        ["<C-k>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
      },

      completion = {
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },
        ghost_text = { enabled = false },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      signature = { enabled = true },
    },
  },
}
