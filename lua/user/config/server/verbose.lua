-- LSP Diagnostic Debugging & Fix for Neovim
-- This will help you understand WHY diagnostics only show after text changes

-- ============================================================================
-- PART 1: DIAGNOSTIC LOGGING (Run this to see what's happening)
-- ============================================================================

-- Enable LSP logging to see what's happening
vim.lsp.set_log_level("DEBUG")  -- Change to "DEBUG" to see everything
print("LSP log file location: " .. vim.lsp.get_log_path())

-- Track when diagnostics are published
local diagnostic_tracker = vim.api.nvim_create_augroup('DiagnosticTracker', { clear = true })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = diagnostic_tracker,
  callback = function(args)
    local diagnostics = vim.diagnostic.get(args.buf)
    print(string.format(
      "[DiagnosticChanged] Buffer: %d, Count: %d, Time: %s",
      args.buf,
      #diagnostics,
      vim.fn.strftime("%H:%M:%S")
    ))
  end,
})

-- Track LSP notifications
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg:match("diagnostic") or msg:match("textDocument") then
    print("[LSP Notify] " .. msg)
  end
  original_notify(msg, level, opts)
end

-- ============================================================================
-- PART 2: COMMON CAUSES & THEIR FIXES
-- ============================================================================

--[[
COMMON CAUSES:

1. LSP server doesn't send diagnostics on didOpen
   - Many servers only send on didChange or didSave
   - Fix: Force a refresh on BufEnter

2. Neovim doesn't request diagnostics on buffer enter
   - Default behavior waits for server to push
   - Fix: Manually request diagnostics

3. Your diagnostic config has update_in_insert = true
   - This might prevent updates in normal mode
   - Fix: Ensure diagnostics refresh in normal mode too

4. LSP server is slow to initialize
   - Diagnostics come later after full workspace scan
   - Fix: Force refresh after a delay

5. Diagnostic display is disabled until text change
   - vim.diagnostic.show() might not be called
   - Fix: Explicitly call show on buffer enter
]]

-- ============================================================================
-- PART 3: THE UNIVERSAL FIX
-- ============================================================================

-- Force diagnostic refresh on buffer enter and mode changes
local function force_diagnostic_refresh()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      
      if not client then return end
      
      -- Create buffer-local autocommands
      local refresh_group = vim.api.nvim_create_augroup(
        'LspDiagnosticRefresh_' .. bufnr,
        { clear = true }
      )
      
      -- CRITICAL FIX 1: Refresh on buffer enter
      vim.api.nvim_create_autocmd('BufEnter', {
        group = refresh_group,
        buffer = bufnr,
        callback = function()
          -- Small delay to ensure LSP is ready
          vim.defer_fn(function()
            -- Request fresh diagnostics from server
            if client.server_capabilities.diagnosticProvider then
              -- For servers supporting pull diagnostics (LSP 3.17+)
              vim.lsp.diagnostic.on_publish_diagnostics(
                nil,
                { uri = vim.uri_from_bufnr(bufnr) },
                { client_id = client.id }
              )
            end
            
            -- Force display of existing diagnostics
            vim.diagnostic.show(nil, bufnr)
            
            -- Alternative: Trigger textDocument/didChange with empty edit
            -- This tricks the server into sending diagnostics
            -- vim.lsp.util.buf_notify(bufnr, 'textDocument/didChange', {
            --   textDocument = { uri = vim.uri_from_bufnr(bufnr), version = 0 },
            --   contentChanges = {}
            -- })
          end, 100)
        end,
      })
      
      -- CRITICAL FIX 2: Refresh when entering normal mode
      vim.api.nvim_create_autocmd('ModeChanged', {
        group = refresh_group,
        buffer = bufnr,
        pattern = '*:n',  -- Any mode to normal mode
        callback = function()
          vim.diagnostic.show(nil, bufnr)
        end,
      })
      
      -- CRITICAL FIX 3: Refresh after LSP is fully attached
      vim.defer_fn(function()
        vim.diagnostic.show(nil, bufnr)
      end, 500)
      
      print(string.format(
        "[LSP] Diagnostic refresh enabled for %s (client: %s)",
        vim.api.nvim_buf_get_name(bufnr),
        client.name
      ))
    end,
  })
end

-- Apply the fix
force_diagnostic_refresh()

-- ============================================================================
-- PART 4: SERVER-SPECIFIC WORKAROUNDS
-- ============================================================================

-- For servers that ONLY send diagnostics on save
local function enable_diagnostic_on_save()
  vim.api.nvim_create_autocmd('BufWritePost', {
    callback = function(args)
      vim.defer_fn(function()
        vim.diagnostic.show(nil, args.buf)
      end, 200)
    end,
  })
end

-- Uncomment if your server only sends diagnostics on save:
-- enable_diagnostic_on_save()

-- ============================================================================
-- PART 5: DIAGNOSTIC COMMANDS FOR DEBUGGING
-- ============================================================================

-- Force refresh manually
vim.api.nvim_create_user_command('DiagnosticRefresh', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.diagnostic.show(nil, bufnr)
  
  -- Also try to trigger server refresh
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.server_capabilities.diagnosticProvider then
      print("Requesting diagnostics from: " .. client.name)
      -- Trigger a no-op edit to force diagnostic update
      local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        contentChanges = {}
      }
      client.notify('textDocument/didChange', params)
    end
  end
  
  print("Diagnostic refresh triggered")
end, {})

-- Show diagnostic state
vim.api.nvim_create_user_command('DiagnosticDebug', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)
  
  print("\n=== DIAGNOSTIC DEBUG INFO ===")
  print("Buffer: " .. bufnr)
  print("Diagnostic count: " .. #diagnostics)
  print("\nLSP Clients:")
  
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    print(string.format(
      "  - %s (id: %d, supports diagnostics: %s)",
      client.name,
      client.id,
      client.server_capabilities.diagnosticProvider and "yes" or "no"
    ))
  end
  
  print("\nDiagnostics:")
  for i, diag in ipairs(diagnostics) do
    print(string.format(
      "  %d. [%s] Line %d: %s",
      i,
      vim.diagnostic.severity[diag.severity],
      diag.lnum + 1,
      diag.message:sub(1, 50)
    ))
  end
  
  print("\nCurrent diagnostic config:")
  local config = vim.diagnostic.config()
  print("  update_in_insert: " .. tostring(config.update_in_insert))
  print("  virtual_text: " .. tostring(config.virtual_text ~= false))
  print("  signs: " .. tostring(config.signs ~= false))
  print("===========================\n")
end, {})

-- ============================================================================
-- USAGE INSTRUCTIONS
-- ============================================================================

print([[

=== LSP DIAGNOSTIC DEBUGGING ENABLED ===

To diagnose your issue:

1. Open a file with errors
2. Run: :DiagnosticDebug
   - This shows current state and LSP clients
   
3. Check LSP logs: :lua print(vim.lsp.get_log_path())
   - Look for "textDocument/publishDiagnostics"
   
4. Force refresh: :DiagnosticRefresh
   - If this works, the auto-refresh isn't triggering
   
5. Watch for events:
   - DiagnosticChanged events will print to :messages
   
Common findings:
- If DiagnosticDebug shows diagnostics but they're not visible:
  → Display issue (check your diagnostic config)
  
- If diagnostics appear after :DiagnosticRefresh:
  → Auto-refresh not working (the fixes above should help)
  
- If no diagnostics even after text change:
  → LSP server issue (check :LspInfo and server logs)

==========================================
]])

-- Keymaps for quick debugging
vim.keymap.set('n', '<leader>dr', '<cmd>DiagnosticRefresh<cr>', { desc = 'Force Diagnostic Refresh' })
vim.keymap.set('n', '<leader>dd', '<cmd>DiagnosticDebug<cr>', { desc = 'Show Diagnostic Debug Info' })
