local cmp = require('cmp')

local default_config = {
    auto_open = true,
}

local M = {
    source = {}
}

function M.setup(config)
    if config == nil then
        config = default_config
    else
        config = vim.tbl_deep_extend('keep', config, default_config)
    end

    if config.auto_open then
        vim.api.nvim_create_autocmd('User', {
            pattern = 'LuasnipChoiceNodeEnter',
            callback = function()
                vim.schedule(function()
                    cmp.complete({
                        config = {
                            sources = {
                                {name = 'luasnip_choice'}
                            },
                        },
                    })
                end)
            end,
        })
    end
end

function M.source.new()
    return setmetatable({}, {__index = M.source})
end

function M.source:is_available()
    return require('luasnip.session').active_choice_node
end

function M.source:execute(completion_item, callback)
    require('luasnip').set_choice(completion_item.index)
    callback(completion_item)
end

function M.source:get_keyword_pattern()
    return ''
end

function M.source:complete(_, callback)
    local items = {}

    local choices_ok, choice_docstrings = pcall(require('luasnip').get_current_choices)
    if not choices_ok then
        -- no choice active: return no completion-items.
        callback(items)
    end

    for _, choice_docstring in ipairs(choice_docstrings) do
        table.insert(items, {
            label = choice_docstring,
            word = "",
            index = _,
            documentation = choice_docstring,
            kind = cmp.lsp.CompletionItemKind.Snippet,
        })
    end
    callback(items)
end

function M.source:get_debug_name()
    return 'luasnip_choice'
end

return M
