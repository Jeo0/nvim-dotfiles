local M = {}

-- Helper: safely get line text
local function getline(n)
  if n < 1 or n > vim.fn.line("$") then
    return ""
  end
  return vim.fn.getline(n)
end

function M.fold_scope_under_cursor()
  local total = vim.fn.line("$")
  local cur = vim.fn.line(".")

  -- 1️⃣ Find previous unmatched '{'
  local start_line = nil
  local depth = 0
  for l = cur, 1, -1 do
    local text = getline(l)
    local opens = select(2, text:gsub("{", ""))
    local closes = select(2, text:gsub("}", ""))
    depth = depth + closes - opens
    if depth < 0 then
      start_line = l
      break
    end
  end
  if not start_line then
    vim.notify("No unmatched '{' found above cursor", vim.log.levels.WARN)
    return
  end

  -- 2️⃣ Find matching closing '}'
  local end_line = nil
  depth = 0
  for l = start_line, total do
    local text = getline(l)
    local opens = select(2, text:gsub("{", ""))
    local closes = select(2, text:gsub("}", ""))
    depth = depth + opens - closes
    if depth == 0 then
      end_line = l
      break
    end
  end
  if not end_line then
    vim.notify("No matching '}' found below", vim.log.levels.WARN)
    return
  end

  -- 3️⃣ Adjust so fold starts *after* '{' and ends *before* '}'
  local fold_start = start_line + 1
  local fold_end = end_line - 1

  -- Check validity
  if fold_start >= fold_end then
    vim.notify("Nothing to fold inside braces", vim.log.levels.INFO)
    return
  end

  -- 4️⃣ Create the fold
  vim.cmd(string.format("%d,%dfold", fold_start, fold_end))
  vim.notify(string.format("Folded inner scope: %d–%d", fold_start, fold_end))
end


-- Optional mapping
vim.keymap.set("n", "<leader>za", M.fold_scope_under_cursor, { desc = "Fold current scope" })

return M
