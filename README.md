# cmp-luasnip-choice

[luasnip](https://github.com/L3MON4D3/LuaSnip) choice node completion source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## Installation via [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use { 'L3MON4D3/LuaSnip' }
use {
  'hrsh7th/nvim-cmp',
  config = function ()
    require'cmp'.setup {
      snippet = {
        expand = function(args)
          require'luasnip'.lsp_expand(args.body)
        end
      },

      sources = {
        { name = 'luasnip_choice' },
        -- more sources
      },
    }
  end
}
use {
  'doxnit/cmp-luasnip-choice',
  config = function()
    require('cmp_luasnip_choice').setup({
        auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
    });
  end,
}
```
