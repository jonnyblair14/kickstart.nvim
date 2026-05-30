vim.o.tabline = '%!v:lua.CustomTabline()'

function _G.CustomTabline()
  local tabs = {}

  for tab = 1, vim.fn.tabpagenr '$' do
    local win = vim.fn.tabpagewinnr(tab)
    local bufnr = vim.fn.tabpagebuflist(tab)[win]
    local name = vim.fn.bufname(bufnr)

    local filename = name ~= '' and vim.fn.fnamemodify(name, ':t') or '[No Name]'

    local duplicate = false
    for other = 1, vim.fn.tabpagenr '$' do
      if other ~= tab then
        local other_win = vim.fn.tabpagewinnr(other)
        local other_bufnr = vim.fn.tabpagebuflist(other)[other_win]
        local other_name = vim.fn.bufname(other_bufnr)
        local other_filename = other_name ~= '' and vim.fn.fnamemodify(other_name, ':t') or '[No Name]'

        if other_filename == filename then
          duplicate = true
          break
        end
      end
    end

    if duplicate and name ~= '' then filename = vim.fn.fnamemodify(name, ':~:.') end

    local hl = tab == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#'
    table.insert(tabs, hl .. '%' .. tab .. 'T ' .. filename .. ' ')
  end

  return table.concat(tabs) .. '%#TabLineFill#%T'
end
