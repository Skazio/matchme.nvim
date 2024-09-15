local match_ids = {}

local function highlight(pattern)
    local highlight_group = "Visual"

    local match_id = vim.fn.matchadd(highlight_group, pattern)
    print("insterting...")
    table.insert(match_ids, match_id)

    return match_id
end

local function remove_highlight()
    for index, match_id in ipairs(match_ids) do
        pcall(function()
            vim.fn.matchdelete(match_id)
        end)

        table.remove(match_ids, index)
    end
end

local function get_visual_selection()
    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Extract the line numbers and column positions
    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col = end_pos[2], end_pos[3]

    -- Initialize an empty table to hold the selected text
    local selected_text = {}

    -- If it's a single-line selection
    if start_line == end_line then
        local line = vim.fn.getline(start_line)
        table.insert(selected_text, string.sub(line, start_col, end_col))
    else
        -- Multi-line selection
        -- Get the first line (partial)
        local first_line = vim.fn.getline(start_line)
        table.insert(selected_text, string.sub(first_line, start_col))

        -- Get the lines in between
        for i = start_line + 1, end_line - 1 do
            table.insert(selected_text, vim.fn.getline(i))
        end

        -- Get the last line (partial)
        local last_line = vim.fn.getline(end_line)
        table.insert(selected_text, string.sub(last_line, 1, end_col))
    end

    -- Join the lines together (if it's a multi-line selection)
    return table.concat(selected_text, "\n")
end

-- FUNCTIONS
vim.api.nvim_create_user_command("Hd", function()
    print(vim.inspect(match_ids))
end, {})


vim.api.nvim_create_user_command("Hs", function()
    local pattern = get_visual_selection()

    print(pattern)
    highlight(pattern)
end, {})

vim.api.nvim_create_user_command("Hn", function()
    remove_highlight()
end, {})

---


return {
    highlight= highlight
}
