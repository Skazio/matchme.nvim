local match_ids = {}

local function add_highlight(pattern)
    local match_id = vim.fn.matchadd("Visual", pattern)

    table.insert(match_ids, match_id)
end

local function remove_highlight()
    for i = #match_ids, 1, -1 do
        pcall(function() vim.fn.matchdelete(match_ids[i]) end)

        table.remove(match_ids, i)
    end
end

local function get_visual_selection()
    -- Get the position of the cursor (moving part)
    -- And the position of the border (still part)
    local border_pos = vim.fn.getpos('v')
    local cursor_pos = vim.fn.getpos('.')

    -- Extract the line number and column positions
    local cursor_line = cursor_pos[2]
    local cursor_col  = cursor_pos[3]
    local border_col  = border_pos[3]

    local line = vim.fn.getline(cursor_line)

    local min
    local max
    if cursor_col < border_col then
        min = cursor_col
        max = border_col
    else
        min = border_col
        max = cursor_col
    end

    return string.sub(line, min, max)
end

vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
        if vim.fn.mode() == 'v' then
            remove_highlight()
            add_highlight(get_visual_selection())
        end
    end
})

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function(args)
        local old_mode
        local new_mode

        for match in string.gmatch(args.match, "([^:]+)") do
            if not old_mode then
                old_mode = match
            elseif not new_mode then
                new_mode = match
                break  -- Stop after capturing the second match
            end
        end

        if new_mode == 'v' then
            remove_highlight()
            add_highlight(get_visual_selection())
        elseif old_mode == 'v' then
            remove_highlight()
        end
    end
})

return {
    remove_highlight = remove_highlight
}

