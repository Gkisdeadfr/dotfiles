return {
  "local/pdf-viewer", -- dummy plugin name, no actual repo
  config = function()
    local pdf_viewer = "open" -- macOS built-in command

    -- 🧠 Auto-open PDF files in Preview when you open them in Neovim
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.pdf",
      callback = function()
        local file = vim.fn.expand("%:p")
        vim.fn.jobstart({ pdf_viewer, file }, { detach = true })
        vim.cmd("bd!") -- closes the empty buffer so Neovim doesn’t hang
      end,
    })

    -- 💡 Manual keybind: <leader>pv to open current file in Preview
    vim.keymap.set("n", "<leader>pv", function()
      local file = vim.fn.expand("%:p")
      vim.fn.jobstart({ pdf_viewer, file }, { detach = true })
    end, { desc = "Open current PDF in Preview" })

    -- 🧾 Optional: :PdfText to convert PDF → text (needs pdftotext)
    vim.api.nvim_create_user_command("PdfText", function()
      local file = vim.fn.expand("%:p")
      local txtfile = vim.fn.expand("%:p:r") .. ".txt"
      vim.fn.jobstart({ "pdftotext", file, txtfile }, {
        on_exit = function()
          vim.cmd("e " .. txtfile)
        end,
      })
    end, { desc = "Convert PDF to text and open in Neovim" })
  end,
}

