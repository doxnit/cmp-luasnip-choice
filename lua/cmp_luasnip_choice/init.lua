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

function M.source:complete(params, callback)
    local items = {}
    local choices = require('luasnip.session').active_choice_node.choices
    for _, choice in ipairs(choices) do
        local copy = choice:copy()
        copy:static_init()

        local text = ''
        for _, str in ipairs(copy:get_static_text()) do
            text = text .. str .. '\n'
        end

        table.insert(items, {
            label = copy:get_static_text()[1],
            word = copy:get_static_text()[1],
            index = _,
            documentation = text,
            kind = cmp.lsp.CompletionItemKind.Snippet,
        })
    end
    callback(items)
end

function M.source:get_debug_name()
    return 'luasnip_choice'
end

return M
