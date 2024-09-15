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

    -- Extract the line numbers and column positions
    local cursor_line, cursor_col = cursor_pos[2], cursor_pos[3]
    local border_line, border_col = border_pos[2], border_pos[3]

    -- Initialize an empty table to hold the selected text
    local selected_text = {}

    -- If it's a single-line selection
    if cursor_line == border_line then
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

        table.insert(selected_text, string.sub(line, min, max))
    else
        -- Unsupported
    end

    -- Join the lines together (if it's a multi-line selection)
    return table.concat(selected_text, "\n")
end

vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
        local mode = vim.fn.mode()
        -- 'v'   for visual character
        -- 'V'   for visual line
        -- '\22' for visual block
        if mode == 'v' or mode == 'V' or mode == '\22' then
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

